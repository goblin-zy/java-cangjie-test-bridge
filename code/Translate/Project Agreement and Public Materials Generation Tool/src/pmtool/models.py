"""Shared schema. Structural validity is deliberately separate from semantic confirmation."""
from __future__ import annotations

from typing import Any, Literal
from pydantic import BaseModel, ConfigDict, Field, model_validator

CATEGORIES = {
    "C01": "项目结构与模块关系", "C02": "项目符号对应表",
    "C03": "目标接口与数据结构", "C04": "项目公共业务约定",
    "C05": "公共测试基础设施及迁移状态", "C06": "依赖替代与兼容方案",
    "C07": "已完成的目标代码与允许使用的范例", "C08": "工具链与构建配置",
    "C09": "公共资源与环境约定", "C10": "翻译和装配约束",
    "C11": "支持范围与特殊处理决定",
}

class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid")

class SourceRoot(StrictModel):
    name: str = Field(pattern=r"^[A-Za-z0-9_-]+$")
    path: str
    language: Literal["java", "cangjie", "documents"]
    role: Literal["business", "test", "mixed", "documentation"] = "mixed"
    include: list[str] = Field(default_factory=lambda: ["**/*"])
    exclude: list[str] = Field(default_factory=list)
    encoding: str = "utf-8-sig"

class ParserSettings(StrictModel):
    java: str = "java"
    javac: str = "javac"
    cjc: str = "cjc"
    cangjie_helper: str | None = None
    java_source_roots: list[str] = Field(default_factory=list)
    java_classpath: list[str] = Field(default_factory=list)
    java_language_level: str = "JAVA_17"
    timeout_seconds: int = Field(default=120, ge=1)

class ProjectConfig(StrictModel):
    project_name: str
    sources: list[SourceRoot] = Field(min_length=1)
    output_dir: str = "outputs/current"
    allow_target_tests: bool = False
    allow_unparsed_target_evidence: bool = False
    exclude: list[str] = Field(default_factory=list)
    max_file_bytes: int = Field(default=3_000_000, ge=1)
    parsers: ParserSettings = Field(default_factory=ParserSettings)

    @model_validator(mode="after")
    def unique_names(self):
        names = [r.name for r in self.sources]
        if len(names) != len(set(names)):
            raise ValueError("sources.name 必须唯一")
        return self

class Evidence(StrictModel):
    file_id: str
    start_line: int = Field(ge=1)
    end_line: int = Field(ge=1)
    quote: str = Field(min_length=1)
    member_id: str | None = None

    @model_validator(mode="after")
    def ordered_lines(self):
        if self.end_line < self.start_line:
            raise ValueError("end_line 小于 start_line")
        return self

class MaterialItem(StrictModel):
    id: str = Field(min_length=1)
    category: str = Field(pattern=r"^C(0[1-9]|1[01])$")
    subject: str = Field(min_length=1)
    title: str = Field(min_length=1)
    content: dict[str, Any]
    basis: Literal["source_fact", "document_statement", "heuristic_candidate", "ai_analysis", "human_confirmation"]
    status: Literal["extracted", "pending", "confirmed", "conflict", "missing"]
    confirmation_note: str = ""
    sources: list[Evidence] = Field(default_factory=list)
    limitations: list[str] = Field(default_factory=list)
    related_members: list[str] = Field(default_factory=list)
    scope: str = Field(min_length=1)

    @model_validator(mode="after")
    def accountable(self):
        if self.status not in {"pending", "missing"} and not self.sources:
            raise ValueError("非待确认/缺失条目必须有来源")
        if self.status == "confirmed" and not self.confirmation_note.strip():
            raise ValueError("confirmed 必须说明核对依据或确认记录，不能只凭引用存在")
        if self.basis == "ai_analysis" and self.status == "extracted":
            raise ValueError("AI 分析不能标记为直接提取")
        if self.basis == "heuristic_candidate" and self.status != "pending":
            raise ValueError("程序启发式候选只能保持pending；分析后使用相应依据类型")
        return self

class Issue(StrictModel):
    id: str
    kind: Literal["missing", "conflict", "parse_failure", "unresolved_reference",
                  "pending", "unsupported", "read_failure", "excluded", "coverage"]
    subject: str
    description: str
    sources: list[Evidence] = Field(default_factory=list)
    related_items: list[str] = Field(default_factory=list)

class Materials(StrictModel):
    schema_version: Literal["1.0"] = "1.0"
    project_name: str
    snapshot_id: str
    phase: Literal["program_draft", "codex_partial", "codex_reviewed"] = "program_draft"
    reviewed_file_ids: list[str] = Field(default_factory=list)
    reviewed_categories: list[str] = Field(default_factory=list)
    read_scope: dict[str, Any]
    categories: list[dict[str, str]] = Field(default_factory=lambda: [
        {"id": key, "name": value} for key, value in CATEGORIES.items()
    ])
    items: list[MaterialItem] = Field(default_factory=list)
    issues: list[Issue] = Field(default_factory=list)
    analysis_notes: list[str] = Field(default_factory=list)

    @model_validator(mode="after")
    def identities(self):
        if self.categories != [{"id": k, "name": v} for k, v in CATEGORIES.items()]:
            raise ValueError("categories 必须保留约定的十一类及顺序")
        for records in (self.items, self.issues):
            ids = [r.id for r in records]
            if len(ids) != len(set(ids)):
                raise ValueError("条目或问题编号重复")
        return self

