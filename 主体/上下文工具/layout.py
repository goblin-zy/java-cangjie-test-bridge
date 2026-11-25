"""Read-only project inventory and literal build declarations; never run builds."""
from fnmatch import fnmatchcase
from pathlib import Path
import os
import re
import xml.etree.ElementTree as ET

from common import issue, safe_path

SKIP_DIRS = {".git", ".svn", ".hg", ".idea", ".vscode", ".gradle", ".cache",
             "__pycache__", ".pytest_cache", ".venv", "venv", "node_modules",
             "target", "build", "dist", "out", "bin", "obj"}


def matched(path, patterns):
    return any(fnmatchcase(path, p) or (p.startswith("**/") and fnmatchcase(path, p[3:]))
               for p in patterns)


def inventory_paths(project, exclude, resource_roots=()):
    """Return sorted regular files and explicit omissions without following links."""
    project = Path(project).resolve()
    files, omissions = [], []

    def failed(error):
        path = Path(error.filename)
        relative = path.relative_to(project).as_posix() if path.is_relative_to(project) else str(path)
        omissions.append(issue("DIRECTORY_READ_FAILED", str(error), file=relative, severity="error"))

    for directory, dirs, names in os.walk(project, topdown=True, followlinks=False, onerror=failed):
        current = Path(directory)
        for name in sorted(dirs):
            path = current / name
            rel = path.relative_to(project).as_posix()
            linked = path.is_symlink() or (hasattr(path, "is_junction") and path.is_junction())
            parts = path.relative_to(project).parts
            conventional_resource = any(parts[i:i + 3] in [("src", "main", "resources"), ("src", "test", "resources")]
                                        for i in range(max(0, len(parts) - 2)))
            declared_resource = any(r == "." or rel == r or rel.startswith(r + "/") for r in resource_roots)
            generated = name in SKIP_DIRS and not (conventional_resource or declared_resource)
            if linked or generated or matched(rel, exclude) or matched(rel + "/", exclude):
                dirs.remove(name)
                omissions.append(issue("LINK_NOT_FOLLOWED" if linked else "DIRECTORY_EXCLUDED",
                                       "未读取该目录", file=rel, severity="info"))
        dirs.sort()
        for name in sorted(names):
            path = current / name
            rel = path.relative_to(project).as_posix()
            if path.is_symlink() or (hasattr(path, "is_junction") and path.is_junction()):
                omissions.append(issue("LINK_NOT_FOLLOWED", "未读取链接文件", file=rel))
            elif matched(rel, exclude):
                omissions.append(issue("FILE_EXCLUDED", "按配置排除", file=rel, severity="info"))
            elif path.is_file():
                files.append(rel)
    return sorted(files), omissions


def resolve_properties(text, properties):
    if text is None:
        return None
    result = text.strip()
    for _ in range(12):
        updated = re.sub(r"\$\{([^}]+)\}", lambda m: properties.get(m[1], m[0]), result)
        if updated == result:
            break
        result = updated
    return result


def discover(project, files, explicit):
    """Detect conventional roots and root/declared Maven modules, not an effective model."""
    project = Path(project).resolve()
    available = set(files)
    roots = {"business": set(), "test": set(), "support": set(), "resource": set()}
    modules, builds, issues = [], [], []

    def add_root(role, value, module="", required=False):
        if not value or "${" in value:
            if value:
                issues.append(issue("UNRESOLVED_SOURCE_ROOT", value, module=module))
            return
        rel = (Path(module) / value).as_posix()
        try:
            path = safe_path(project, rel, allow_root=True)
            if path.is_dir():
                prefix = path.relative_to(project).as_posix()
                roots[role].add(prefix)
            elif required:
                raise ValueError("目录不存在: " + rel)
        except ValueError as exc:
            if required:
                raise
            issues.append(issue("SOURCE_ROOT_NOT_AVAILABLE", str(exc), file=rel))

    # Conventional layout can be recognized for Maven, Gradle and plain projects.
    module_candidates = {""}
    for name in files:
        parts = Path(name).parts
        for i in range(len(parts) - 3):
            if parts[i:i + 3] in [("src", "main", "java"), ("src", "test", "java"),
                                   ("src", "main", "resources"), ("src", "test", "resources")]:
                # Embedded projects in a resource fixture are data, not extra modules.
                prefix = parts[:i]
                if "resources" not in prefix and "java" not in prefix:
                    module_candidates.add(Path(*prefix).as_posix() if prefix else "")
                break

    pending, visited = [""], set()
    while pending:
        module = pending.pop(0)
        if module in visited:
            continue
        visited.add(module)
        pom = (Path(module) / "pom.xml").as_posix()
        if pom not in available:
            continue
        try:
            tree = ET.parse(project / pom)
            node = tree.getroot()
            for element in node.iter():
                element.tag = element.tag.rsplit("}", 1)[-1]
            properties = {x.tag: (x.text or "").strip() for x in node.findall("./properties/*")}
            properties.update({"project.basedir": ".", "basedir": "."})
            declaration = {"file": pom, "kind": "maven", "properties": properties,
                           "source_version_as_declared": node.findtext("./properties/maven.compiler.release") or
                           node.findtext("./properties/maven.compiler.source"),
                           "dependencies": [], "effective_model": "NOT_EVALUATED"}
            for dep in node.findall("./dependencies/dependency"):
                declaration["dependencies"].append({key: resolve_properties(dep.findtext(key), properties)
                                                    for key in ["groupId", "artifactId", "version", "scope"]})
            if declaration["dependencies"]:
                issues.append(issue("DEPENDENCIES_NOT_RESOLVED", "只保存依赖声明，未下载JAR或求解运行类路径", file=pom))
            if node.find("parent") is not None:
                declaration["parent"] = {key: node.findtext("./parent/" + key)
                                         for key in ["groupId", "artifactId", "version", "relativePath"]}
                issues.append(issue("PARENT_MODEL_NOT_EVALUATED", "父POM未作为有效模型求值", file=pom))
            if node.find("profiles") is not None:
                issues.append(issue("BUILD_PROFILES_NOT_EVALUATED", "保存profile声明，未激活或执行", file=pom))
            builds.append(declaration)
            for role, expression in [("business", "./build/sourceDirectory"),
                                     ("test", "./build/testSourceDirectory")]:
                add_root(role, resolve_properties(node.findtext(expression), properties), module)
            for expression in ["./build/resources/resource/directory", "./build/testResources/testResource/directory"]:
                for element in node.findall(expression):
                    add_root("resource", resolve_properties(element.text, properties), module)
            for element in node.findall("./modules/module"):
                value = resolve_properties(element.text, properties)
                try:
                    if not value or "${" in value:
                        raise ValueError("模块路径未确定")
                    target = safe_path(project, (Path(module) / value).as_posix())
                    rel = target.relative_to(project).as_posix()
                    if not target.is_dir():
                        raise ValueError("模块目录不存在")
                    pending.append(rel)
                    module_candidates.add(rel)
                except ValueError as exc:
                    issues.append(issue("MODULE_NOT_AVAILABLE", str(exc), file=pom, value=value))
        except (ET.ParseError, OSError) as exc:
            issues.append(issue("BUILD_FILE_PARSE_ERROR", str(exc), file=pom))

    for module in sorted(module_candidates):
        modules.append(module or ".")
        for role, suffix in [("business", "src/main/java"), ("test", "src/test/java"),
                             ("resource", "src/main/resources"), ("resource", "src/test/resources")]:
            add_root(role, suffix, module)
        for name in ["build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts"]:
            rel = (Path(module) / name).as_posix()
            if rel in available:
                builds.append({"file": rel, "kind": "gradle", "effective_model": "NOT_EVALUATED"})
                issues.append(issue("GRADLE_NOT_EVALUATED", "仅保留构建文件和常规目录，未执行Gradle", file=rel))
    for role, values in explicit.items():
        if values is not None:
            roots[role].clear()
            for value in values:
                add_root(role, value, required=True)
    # A fixture may itself contain a Java project. Resource declarations win over
    # auto-discovered nested source roots, and do not imply runnable modules.
    for role in ["business", "test", "support"]:
        for source in list(roots[role]):
            for resource in roots["resource"]:
                if source == resource:
                    raise ValueError("同一目录不能同时声明为源码和资源: " + source)
                if Path(source).is_relative_to(resource):
                    roots[role].remove(source)
                    break
    # Ambiguous declarations must be fixed rather than given arbitrary priorities.
    for a in ["business", "test", "support"]:
        for b in ["business", "test", "support"]:
            if a >= b:
                continue
            for ra in roots[a]:
                for rb in roots[b]:
                    if Path(ra).is_relative_to(rb) or Path(rb).is_relative_to(ra):
                        raise ValueError(f"源码根角色重叠: {a}:{ra}, {b}:{rb}")
    if not roots["test"]:
        issues.append(issue("TEST_ROOT_NOT_IDENTIFIED", "请用test_roots或--test-root声明测试来源"))
    return {"roots": {k: sorted(v) for k, v in roots.items()}, "modules": modules,
            "build_declarations": builds}, issues


def file_role(relative, layout):
    """资源优先按最长根匹配；显式 '.' 表示整个项目目录。"""
    matches = [(len(root), role) for role, roots in layout["roots"].items()
               for root in roots if root == "." or relative.startswith(root + "/")]
    if matches:
        role = max(matches)[1]
        if role == "resource":
            return "resource"
        return role + "_source" if relative.endswith(".java") else "source_adjacent"
    if relative.endswith(".java"):
        return "unclassified_java"
    if Path(relative).name in {"pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle",
                               "settings.gradle.kts", "gradle.properties"}:
        return "build_config"
    return "project_material"

