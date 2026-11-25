"""Integration and evidence-boundary tests. Never run the input project or JUnit."""
from pathlib import Path
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from indexer import build
from project import Project
from assemble import assemble, write_context, assemble_class, assemble_test, write_suite
from agent_view import compact_context
from common import load, save, sha
from internal_analysis import query_member, query_features

JAVA = os.environ.get("PP_TEST_JAVA", "java")
JAVAC = os.environ.get("PP_TEST_JAVAC", "javac")


class ContextTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix="context-acceptance-")
        cls.base = Path(cls.temp.name)
        source = cls.base / "source"
        shutil.copytree(ROOT / "tests/fixtures/mini-project", source)
        shutil.copyfile(ROOT / 'tests/fixtures/FlowTest.java', source / 'src/test/java/demo/FlowTest.java')
        test = source / "src/test/java/demo/ProbeTest.java"
        test.write_bytes(('''package demo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
class Parent { int act(int x) { return x; } }
class Child extends Parent { int act(String x) { return 2; } }
class ProbeBase { @BeforeEach void boot() {} }
class ProbeTest extends ProbeBase {
  void boot(int x) {}
  void many(int... values) { assert values.length > 0; }
  @Test void check() throws Exception {
\tString label="值😀"; Child c=new Child(); c.act(1); c.act("s");
    Parent p=new Child(); p.act(3); many(1,2,3);
    ClassLoader loader=ProbeTest.class.getClassLoader();
    loader.getResourceAsStream("data/values.txt");
    loader.getResourceAsStream("/data/values.txt");
    ProbeTest.class.getResourceAsStream("local.txt");
    getClass().getResourceAsStream("local.txt");
    java.nio.file.Paths.get("data/values.txt");
  }
  @Test void duplicate() { new Duplicate().go(); }
}
''').replace('\n', '\r\n').encode('utf-8'))
        fake = source / "src/test/java/demo/FakeTest.java"
        fake.write_text("package demo; import fake.Test; import org.junit.jupiter.api.BeforeEach; class FakeTest { @Test void pretend() {} }", encoding="utf-8")
        annotation = source / "src/test/java/fake/Test.java"
        annotation.parent.mkdir()
        annotation.write_text("package fake; public @interface Test {}", encoding="utf-8")
        (source / "src/test/java/demo/Surrogate.java").write_text(r'package demo; class Surrogate { void f() { getClass().getResourceAsStream("\uD800"); } }', encoding="utf-8")
        (source / 'src/main/java/demo/Duplicate.java').write_text('package demo; class Duplicate { void go() {} }', encoding='utf-8')
        other = source / 'src/support/java/demo'
        other.mkdir(parents=True)
        (other / 'Duplicate.java').write_text('package demo; class Duplicate { void go() {} }', encoding='utf-8')
        (source / 'src/test/java/demo/AmbiguousChild.java').write_text('package demo; class AmbiguousChild extends Duplicate {}', encoding='utf-8')
        (source / 'src/main/java/demo/Mode.java').write_text('package demo; enum Mode { A(3); final int n; Mode(int n) { this.n=n; } }', encoding='utf-8')
        (source / 'src/test/java/demo/EnumTest.java').write_text('package demo; import org.junit.jupiter.api.Test; class EnumTest { @Test void check() { Mode m=Mode.A; assert m!=null; } }', encoding='utf-8')
        (source / 'src/test/java/demo/AnonymousTest.java').write_text('''package demo;
import org.junit.jupiter.api.Test;
interface Handler { boolean emit(); }
class AnonymousTest {
  boolean first=false;
  @Test void check() {
    Handler a=new Handler() { boolean first=true; public boolean emit() { if(first) { first=false; return true; } return false; } };
    Handler b=new Handler() { boolean first=true; public boolean emit() { if(first) { first=false; return true; } return false; } };
    assert a.emit(); assert !a.emit(); assert b.emit(); this.first=true;
  }
}
''', encoding='utf-8')
        (source / 'src/test/java/demo/JUnit4Test.java').write_text('package demo; import org.junit.Test; import org.junit.Before; class JUnit4Test { @Before void setup() {} @Test public void check() {} }', encoding='utf-8')
        (source / 'src/test/java/demo/FieldPairTest.java').write_text('package demo; import org.junit.jupiter.api.Test; class FieldPairTest { int a=1,b=2; @Test void check() { assert a<b; } }', encoding='utf-8')
        (source / 'src/main/java/demo/Box.java').write_text('package demo; class Box<T extends Number> { <R> R echo(R value) throws java.io.IOException { return value; } }', encoding='utf-8')
        (source / 'src/test/java/demo/ReferenceTest.java').write_text('package demo; import org.junit.jupiter.api.Test; class ReferenceTest { void help() { assert true; } @Test void check() { Runnable action=this::help; action.run(); } }', encoding='utf-8')
        (source / 'src/test/java/demo/RecursiveTest.java').write_text('package demo; import org.junit.jupiter.api.Test; class RecursiveTest { void a() { b(); } void b() { a(); } @Test void check() { a(); } }', encoding='utf-8')
        (source / 'src/test/java/demo/InheritedTest.java').write_text('package demo; import org.junit.jupiter.api.Test; class InheritedBase { @Test void check() { assert true; } } class InheritedTest extends InheritedBase {}', encoding='utf-8')
        (source / 'src/test/java/demo/Broken.java').write_text('package demo; class Broken { void broken( }', encoding='utf-8')
        (source / 'src/test/resources/Fixture.java').write_text('this is resource data, not Java source', encoding='utf-8')
        local = source / "src/test/resources/demo/local.txt"
        local.parent.mkdir()
        local.write_text("类相对资源", encoding="utf-8")
        material = cls.base / "materials.json"
        save(material, {"schema_version": "example-1", "items": [{"name": "Counter", "status": "pending", "note": "由Agent判断"}]})
        cls.built = build(source, cls.base / "index", java=JAVA, javac=JAVAC, materials=material, support_roots=['src/support/java'],
                         classpath=[ROOT / 'vendor/java-libs/gson-2.11.0.jar'])

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def setUp(self):
        self.temp_case = tempfile.TemporaryDirectory(prefix="context-case-")
        self.addCleanup(self.temp_case.cleanup)
        self.case = Path(self.temp_case.name)
        shutil.copytree(self.base / "index", self.case / "index")
        self.index = self.case / "index/project_schema.json"
        self.project = Project(self.index)

    def calls(self, name):
        key = self.project.key(name, include_types=False)
        return [self.project.references[k] for k in self.project.by_caller[key]]

    def test_inherited_overloads_varargs_and_virtual_dispatch(self):
        refs = self.calls("demo.ProbeTest#check()")
        acts = [r for r in refs if r["name"] == "act"]
        self.assertEqual(len(acts), 3)
        owners = [self.project.members[r["target_keys"][0]]["owner"] for r in acts]
        self.assertEqual(owners, ["demo.Parent", "demo.Child", "demo.Parent"])
        self.assertTrue(all(r["dispatch"] == "DECLARED_TARGET_ONLY" for r in acts))
        var = next(r for r in refs if r["name"] == "many")
        self.assertEqual(var["resolution"], "resolved_static")
        self.assertEqual(self.project.members[var["target_keys"][0]]["name"], "many")

    def test_unicode_tabs_crlf_spans_and_signature_lines(self):
        refs = self.calls("demo.ProbeTest#check()")
        first = next(r for r in refs if r["name"] == "act")
        self.assertEqual(self.project.resolve(first["reference_key"])["expression"], "c.act(1)")
        row = self.project.read("demo.ProbeTest#check()")
        self.assertIn('值😀', row["content"])
        self.assertIn('\r\n', row["content"])
        signature = self.project.read("demo.ProbeTest#check()", "signature")
        self.assertEqual(signature["source"]["end_line"], signature["source"]["start_line"])
        self.assertNotIn('c.act', signature["content"])

    def test_resource_api_anchor_and_classloader_rules(self):
        refs = self.calls("demo.ProbeTest#check()")
        results = [self.project.resources(r["reference_key"], self.project.key("demo.ProbeTest")) for r in refs]
        results = [r for r in results if r]
        found = [r for r in results if r["status"] == "located"]
        self.assertEqual(len(found), 3)
        self.assertTrue(any(r["api_owner"] == "java.lang.ClassLoader" for r in found))
        self.assertEqual(sum(r["resource"]["content"] == "类相对资源" for r in found), 2)
        self.assertTrue(any(r.get("kind") == "CLASSLOADER_PATH_MUST_BE_ROOT_RELATIVE_WITHOUT_SLASH" for r in results))
        self.assertTrue(any(r.get("kind") == "FILESYSTEM_WORKING_DIRECTORY_NOT_SPECIFIED" for r in results))

    def test_lone_surrogate_roundtrips_through_local_json(self):
        refs = self.calls("demo.Surrogate#f()")
        resource = next(r for r in refs if r['name'] == 'getResourceAsStream')
        self.assertEqual(resource['literal_path'], '\ud800')
        self.assertIn('\\ud800', self.index.read_text(encoding='utf-8').lower())

    def test_duplicate_types_keep_ambiguity_and_distinct_keys(self):
        with self.assertRaisesRegex(ValueError, '不唯一'):
            self.project.key('demo.Duplicate#go()')
        hits = self.project.search('demo.Duplicate#go()')['records']
        self.assertEqual(len(hits), 2)
        self.assertNotEqual(hits[0]['key'], hits[1]['key'])
        call = next(r for r in self.calls('demo.ProbeTest#duplicate()') if r['name'] == 'go')
        self.assertEqual(call['resolution'], 'ambiguous')
        self.assertEqual(call['target_keys'], [])
        _, issues = self.project.hierarchy(self.project.key('demo.AmbiguousChild'))
        self.assertTrue(any(i['kind'] == 'PARENT_AMBIGUOUS' for i in issues))

    def test_explicit_syntax_only_never_invents_bindings(self):
        output = self.case / 'syntax-only'
        result = build(self.base / 'source', output, syntax_only=True, java=JAVA, javac=JAVAC)
        syntax = Project(result['index'])
        self.assertEqual(syntax.data['backend']['mode'], 'SYNTAX_ONLY_EXPLICIT')
        self.assertTrue(all(not r['target_keys'] and r['resolution'] == 'unresolved' for r in syntax.references.values()))

    def test_enum_constant_binding_and_resource_inventory_search(self):
        reference = next(r for r in self.calls('demo.EnumTest#check()') if r['name'] == 'A')
        self.assertEqual(reference['resolution'], 'resolved_static')
        self.assertEqual(self.project.members[reference['target_keys'][0]]['id'], 'demo.Mode#field:A')
        self.assertEqual(self.project.search('local.txt', 'resource')['records'][0]['file'], 'src/test/resources/demo/local.txt')

    def test_anonymous_fields_bind_by_location_without_outer_shadowing(self):
        rows = [r for r in self.project.references.values() if r['file'].endswith('/AnonymousTest.java') and r['name'] == 'first']
        self.assertEqual(len(rows), 5)
        self.assertTrue(all(r['resolution'] == 'resolved_static' for r in rows))
        self.assertTrue(all(r['binding_basis'] == 'SOURCE_LOCATION' for r in rows))
        anonymous = [r for r in rows if '<anonymous@' in r['owner']]
        self.assertEqual(len(anonymous), 4)
        self.assertEqual(len({r['target_keys'][0] for r in anonymous}), 2)
        for r in anonymous:
            target = self.project.members[r['target_keys'][0]]
            self.assertEqual(target['owner'], r['owner'])
            self.assertIn('<anonymous@', r['target_owner'])
            self.assertNotEqual(r['target_owner'], r['reported_target_owner'])
        outer = next(r for r in rows if '<anonymous@' not in r['owner'])
        self.assertEqual(self.project.members[outer['target_keys'][0]]['owner'], 'demo.AnonymousTest')

    def test_junit4_role_and_lifecycle_survive_missing_framework_jar(self):
        _, tests, lifecycle, _, _ = self.project.test_target('demo.JUnit4Test')
        self.assertEqual([self.project.members[k]['id'] for k in tests], ['demo.JUnit4Test#check()'])
        self.assertEqual([self.project.members[k]['id'] for k in lifecycle], ['demo.JUnit4Test#setup()'])

    def test_compact_projection_preserves_source_and_unresolved_evidence(self):
        value = assemble(self.project, 'demo.CounterTest')
        value['unresolved'][0]['reference']['reason'] = 'diagnostic ' * 100
        compact = compact_context(value)
        self.assertEqual([r['content'] for r in compact['records'] if r['content'] is not None],
                         [r['content'] for r in value['records'] if r['content'] is not None])
        self.assertEqual(len(compact['unresolved']), len(value['unresolved']))
        self.assertTrue(compact['unresolved'][0]['reason_abbreviated'])
        for r in compact['unresolved']:
            i = int(r['full_evidence_pointer'].rsplit('/', 1)[1])
            self.assertEqual(r['reference_key'], value['unresolved'][i]['reference']['reference_key'])
        covered_ids = {m['id'] for group in compact['covered_by_source'] for m in group['members']}
        self.assertEqual(covered_ids, {r['id'] for r in value['records'] if r['status'] == 'COVERED_BY_INCLUDED_SOURCE'})
        self.assertEqual(compact['semantic_completeness'], 'NOT_ESTABLISHED')
        result = write_context(self.project, value, self.case / 'compact')
        self.assertEqual(result['recommended_input'], result['agent_json'])
        self.assertEqual(load(result['agent_json'])['full_context_sha256'], sha(result['json']))
        self.assertLess(result['agent_json_bytes'], result['full_json_bytes'] * .75)
        self.assertIn('初始上下文', Path(result['markdown']).read_text(encoding='utf8'))

    def test_compact_view_retains_budget_omissions_and_full_option(self):
        value = assemble(self.project, 'demo.CounterTest', max_chars=0, max_members=1)
        compact = compact_context(value)
        self.assertEqual(compact['required_not_included'], value['required_not_included'])
        self.assertTrue(compact['required_not_included'])
        self.assertFalse(any(r['content'] for r in compact['records']))
        result = write_context(self.project, value, self.case / 'full-view', view='full')
        self.assertEqual(result['recommended_input'], result['json'])
        process = subprocess.run([sys.executable, str(ROOT / 'context_tool.py'), 'initial', '--index', str(self.index),
                                  '--target', 'demo.CounterTest', '--view', 'compact', '--output', str(self.case / 'cli-view')], capture_output=True)
        self.assertEqual(process.returncode, 0, process.stdout)
        self.assertEqual(json.loads(process.stdout)['view'], 'compact')

    def test_inherited_lifecycle_not_hidden_by_different_arity(self):
        value = assemble(self.project, "demo.ProbeTest", "whole")
        setup = [m for group in value["lifecycle"]["setup"] for m in group["members"]]
        self.assertEqual([self.project.members[k]["id"] for k in setup], ["demo.ProbeBase#boot()"])
        self.assertTrue(all(g["within_type_order"] == "NOT_ESTABLISHED" for g in value["lifecycle"]["setup"]))

    def test_foreign_test_annotation_not_promoted(self):
        node = self.project.members[self.project.key("demo.FakeTest#pretend()")]
        self.assertEqual(node["roles"], [])
        self.assertEqual(node["annotation_bindings"][0]["qualified_name"], "fake.Test")
        with self.assertRaisesRegex(ValueError, "未识别"):
            assemble(self.project, "demo.FakeTest")

    def test_helper_assertions_and_budget_omissions(self):
        value = assemble(self.project, "demo.CounterTest#sequence()", "fragment")
        helper = self.project.key("demo.CounterTest#addTwice()")
        record = next(r for r in value["records"] if r["id"] == helper)
        combined = '\n'.join(r["content"] or '' for r in value["records"])
        self.assertIn("assert", combined)
        self.assertEqual(record["status"], "CONTENT_INCLUDED")
        whole = assemble(self.project, "demo.CounterTest", "whole")
        self.assertEqual(next(r for r in whole["records"] if r["id"] == helper)["status"], "COVERED_BY_INCLUDED_SOURCE")
        self.assertTrue(value["unresolved"])
        small = assemble(self.project, "demo.CounterTest#sequence()", "fragment", max_chars=0, max_members=1)
        self.assertTrue(small["required_not_included"])
        self.assertEqual(small["budget"]["included_chars"], 0)
        self.assertFalse(any(r["content"] for r in small["records"]))
        with self.assertRaisesRegex(ValueError, "唯一测试"):
            assemble(self.project, "demo.CounterTest", "fragment")

    def test_optional_material_status_and_hash(self):
        result = self.project.materials("Counter")
        self.assertEqual(result["records"][0]["item"]["status"], "pending")
        self.assertEqual(self.project.materials(kind="rules")["status"], "NOT_PROVIDED")
        (self.case / "index/artifacts/materials.json").write_text('{}', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, "附加资料"):
            Project(self.index)

    def test_external_jar_is_frozen_and_checked(self):
        record = self.project.data['backend']['project_classpath'][0]
        frozen = self.case / 'index' / record['file']
        self.assertEqual(sha(frozen), record['sha256'])
        frozen.write_bytes(b'changed')
        with self.assertRaisesRegex(ValueError, 'JAR'):
            Project(self.index)

    def test_stale_source_and_stale_index_rejected(self):
        path = self.case / "index/source/src/test/java/demo/CounterTest.java"
        path.write_text('changed', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, "冻结原件"):
            self.project.read("demo.CounterTest#sequence()")
        with self.assertRaises(ValueError):
            Project(self.index)
        self.index.write_text('{}', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, "摘要"):
            Project(self.index)

    def test_stage_profiles_output_and_read_only_input(self):
        before = sha(self.case / "index/source_manifest.json")
        for stage in ["materials", "skeleton", "whole"]:
            value = assemble(self.project, "demo.CounterTest", stage)
            result = write_context(self.project, value, self.case / ("view-" + stage))
            self.assertTrue(Path(result["json"]).is_file())
        self.project.log('initial', {}, result)
        self.assertEqual(sha(self.case / "index/source_manifest.json"), before)
        self.assertFalse((self.case / "index/source/query_log.jsonl").exists())
        with self.assertRaises(ValueError):
            write_context(self.project, value, self.case / "index/source/new-output")

    def test_cli_pagination_error_and_query_log(self):
        process = subprocess.run([sys.executable, str(ROOT / 'context_tool.py'), 'search', '--index', str(self.index), '--limit', '2'], capture_output=True)
        self.assertEqual(process.returncode, 0, process.stderr)
        result = json.loads(process.stdout.decode('utf-8'))
        self.assertEqual(len(result['records']), 2)
        self.assertEqual(result['next_offset'], 2)
        self.assertTrue((self.case / 'index/query_log.jsonl').exists())
        process = subprocess.run([sys.executable, str(ROOT / 'context_tool.py'), 'read', '--index', str(self.index), '--id', 'act'], capture_output=True)
        self.assertEqual(process.returncode, 1)
        self.assertEqual(json.loads(process.stdout.decode('utf-8'))['status'], 'ERROR')

    def test_shared_and_per_test_contexts_preserve_helpers(self):
        shared = assemble_class(self.project, 'demo.CounterTest')
        self.assertEqual(shared['selected_tests'], [])
        shared_text = '\n'.join(r['content'] or '' for r in shared['records'])
        self.assertNotIn('void sequence()', shared_text)
        value = assemble_test(self.project, 'demo.CounterTest#sequence()', shared)
        bodies = '\n'.join(r['content'] or '' for r in value['records'])
        self.assertIn('void sequence()', bodies)
        self.assertIn('assertEquals(4, counter.value())', bodies)
        self.assertNotIn('void resource()', bodies)
        self.assertTrue(any(r['status'] == 'PROVIDED_BY_SHARED_CONTEXT' for r in value['records']))
        business = self.project.key('demo.Counter#add(int)')
        self.assertNotIn('value += delta', bodies)
        self.assertIn('value += delta', self.project.read(business)['content'])
        empty = assemble_class(self.project, 'demo.CounterTest', max_chars=0)
        own = assemble_test(self.project, 'demo.CounterTest#sequence()', empty)
        self.assertFalse(any(r['status'] == 'PROVIDED_BY_SHARED_CONTEXT' for r in own['records']))

    def test_suite_outputs_are_self_describing_and_shared_is_hashed(self):
        result = write_suite(self.project, 'demo.CounterTest', self.case / 'suite')
        tasks = load(result['tasks'])
        self.assertEqual(len(tasks['tests']), 2)
        self.assertEqual(tasks['shared']['sha256'], sha(self.case / 'suite/shared.json'))
        for entry in tasks['tests']:
            path = self.case / 'suite' / entry['file']
            value = load(path)
            self.assertEqual(entry['sha256'], sha(path))
            self.assertEqual(value['shared_ref']['sha256'], tasks['shared']['sha256'])
            self.assertEqual((path.parent / value['shared_ref']['file']).resolve(),
                             (self.case / 'suite/shared.json').resolve())
        inherited = write_suite(self.project, 'demo.InheritedTest', self.case / 'inherited')
        self.assertEqual(inherited['tests'], 1)

    def test_zero_resource_budget_and_recursive_calls_are_explicit(self):
        value = assemble(self.project, 'demo.CounterTest#resource()', 'fragment', max_chars=0)
        self.assertTrue(any(r['reason'] == 'RESOURCE_BUDGET' for r in value['required_not_included']))
        recursive = assemble(self.project, 'demo.RecursiveTest#check()', 'fragment')
        self.assertEqual(sum(r['display_id'].endswith('#a()') for r in recursive['records']), 1)
        self.assertEqual(sum(r['display_id'].endswith('#b()') for r in recursive['records']), 1)

    def test_multiple_fields_and_method_reference_use_precise_targets(self):
        self.assertEqual(self.project.types[self.project.key('demo.Box')]['type_parameters'], ['T extends Number'])
        generic = self.project.members[self.project.key('demo.Box#echo(R)')]
        self.assertEqual(generic['type_parameters'], ['R'])
        self.assertEqual(generic['throws'], ['java.io.IOException'])
        refs = [r for r in self.calls('demo.FieldPairTest#check()') if r['name'] in {'a', 'b'}]
        self.assertEqual(len(refs), 2)
        self.assertTrue(all(r['resolution'] == 'resolved_static' for r in refs))
        self.assertEqual(len({r['target_keys'][0] for r in refs}), 2)
        self.assertIn('int a=1,b=2;', self.project.read('demo.FieldPairTest#field:a')['content'])
        reference = next(r for r in self.calls('demo.ReferenceTest#check()') if r.get('call_kind') == 'method_reference')
        self.assertEqual(reference['resolution'], 'resolved_static')
        self.assertEqual(reference['dispatch'], 'METHOD_REFERENCE_DEFERRED_EXECUTION')
        self.assertEqual(self.project.resolve(reference['reference_key'])['expression'], 'this::help')

    def test_parse_failure_and_java_resource_remain_distinct(self):
        self.assertTrue(any(p['file'].endswith('/Broken.java') for p in self.project.data['problems']))
        self.assertNotIn('src/test/resources/Fixture.java', self.project.data['files'])
        self.assertEqual(self.project.read_file('src/test/resources/Fixture.java')['content'],
                         'this is resource data, not Java source')

    def test_snapshot_is_self_contained_and_manifest_changes_are_rejected(self):
        self.assertNotIn('input_config', self.project.data)
        self.assertFalse((self.case / 'index/context_config.json').exists())
        # setUp 只复制 index，没有复制原项目；读取成功说明查询不依赖原项目路径。
        self.assertIn('void sequence()', self.project.read('demo.CounterTest#sequence()')['content'])
        (self.case / 'index/source_manifest.json').write_text('{}', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, '源码清单'):
            Project(self.index)

    def test_internal_source_order_and_branch_loop_guards(self):
        result = query_member(self.project, 'demo.FlowTest#check()')
        nodes = {n['key']: n for n in result['nodes']}
        self.assertTrue(any(n['ast_kind'] == 'IfStmt' and n['top_level'] for n in nodes.values()))
        self.assertTrue(any(n['ast_kind'] == 'ForStmt' for n in nodes.values()))
        self.assertTrue(any(n['ast_kind'] == 'SwitchEntry' for n in nodes.values()))
        self.assertTrue({'THEN', 'ELSE', 'LOOP_BODY'} <= {n['role_in_parent'] for n in nodes.values()})
        guarded = [c for c in result['checks'] if c['control_node_keys']]
        self.assertTrue(any(any(nodes[k]['ast_kind'] == 'IfStmt' for k in c['control_node_keys']) for c in guarded))
        self.assertTrue(any(any(nodes[k]['ast_kind'] == 'ForStmt' for k in c['control_node_keys']) for c in guarded))
        top = [n['start'] for n in result['nodes'] if n['top_level']]
        self.assertEqual(top, sorted(top))
        self.assertEqual(result['ordering'], 'SOURCE_ORDER_ONLY_NOT_RUNTIME_TRACE')

    def test_try_catch_finally_and_resources_are_preserved(self):
        result = query_member(self.project, 'demo.FlowTest#check()')
        nodes = {n['key']: n for n in result['nodes']}
        self.assertTrue(any(n['ast_kind'] == 'CatchClause' for n in nodes.values()))
        self.assertTrue(any(n['try_with_resources'] for n in nodes.values()))
        self.assertTrue({'TRY_BODY', 'CATCH', 'CATCH_BODY', 'FINALLY_BODY'} <= {n['role_in_parent'] for n in nodes.values()})
        fail = next(c for c in result['checks'] if c['name'] == 'fail')
        self.assertTrue(any(nodes[k]['ast_kind'] == 'CatchClause' for k in fail['control_node_keys']))
        feature = query_features(self.project, 'demo.FlowTest')['records']
        self.assertTrue(any(f['kind'] == 'TRY_WITH_RESOURCES' for f in feature))

    def test_lambda_checks_are_deferred_and_native_assert_requires_enablement(self):
        result = query_member(self.project, 'demo.FlowTest#check()')
        native = next(c for c in result['checks'] if c['recognition'] == 'JAVA_ASSERT_SYNTAX')
        self.assertTrue(native['deferred_context'])
        self.assertEqual(native['execution_condition'], 'JAVA_ASSERTIONS_ENABLED_REQUIRED')
        self.assertTrue(any(c['name'] == 'assertTrue' and c['deferred_context'] for c in result['checks']))
        compact = query_member(self.project, 'demo.FlowTest#compactLambda()')
        self.assertEqual(sum(c['deferred_context'] for c in compact['checks']), 2)

    def test_project_assert_name_is_candidate_not_confirmed_assertion(self):
        result = query_member(self.project, 'demo.ShadowAssertTest#custom()')
        self.assertEqual(result['counts']['recognized_checks'], 0)
        self.assertEqual(result['counts']['assertion_candidates'], 1)
        self.assertEqual(result['checks'][0]['name'], 'assertEquals')
        actual = query_member(self.project, 'demo.FlowTest#helper()')['checks'][0]
        self.assertEqual(actual['recognition'], 'SOURCE_IMPORT_SUPPORTED')
        self.assertEqual(actual['basis'], 'UNIQUE_STATIC_IMPORT')

    def test_anonymous_member_analysis_does_not_inline_inner_assertions(self):
        outer = self.project.key('demo.AnonymousTest#check()')
        result = query_member(self.project, outer)
        nodes = result['nodes']
        self.assertFalse(any(n['ast_kind'] == 'IfStmt' for n in nodes))
        anonymous = [k for k, m in self.project.members.items() if '<anonymous@' in m['owner'] and m['name'] == 'emit']
        self.assertEqual(len(anonymous), 2)
        self.assertTrue(all(any(n['ast_kind'] == 'IfStmt' for n in query_member(self.project, k)['nodes']) for k in anonymous))

    def test_internal_pagination_and_zero_source_budget_are_explicit(self):
        result = query_member(self.project, 'demo.FlowTest#check()', limit=2, max_chars=0, include_source=True)
        self.assertEqual(len(result['nodes']), 2)
        self.assertEqual(result['next_offset'], 2)
        self.assertTrue(result['required_not_included'])
        self.assertTrue(all(n['content'] is None for n in result['nodes']))
        following = query_member(self.project, 'demo.FlowTest#check()', offset=2, limit=2)
        self.assertFalse({n['key'] for n in result['nodes']} & {n['key'] for n in following['nodes']})

    def test_initial_summary_preserves_analysis_and_explicit_step_omissions(self):
        value = assemble(self.project, 'demo.FlowTest#longBody()', 'fragment')
        row = next(r for r in value['test_structure']['members'] if r['display_id'].endswith('#longBody()'))
        self.assertEqual(len(row['top_level_steps']), 20)
        self.assertGreater(row['remaining_steps'], 0)
        self.assertEqual(compact_context(value)['test_structure'], value['test_structure'])
        self.assertEqual(value['test_structure']['capabilities']['executable_test_prefix_generation'], 'UNSUPPORTED')

    def test_feature_detection_is_review_only_without_source_conversion(self):
        kinds = {r['kind'] for r in query_features(self.project, limit=500)['records']}
        self.assertTrue({'OVERLOAD_GROUP', 'CONSTRUCTOR_DELEGATION', 'METHOD_REFERENCE', 'LAMBDA', 'INITIALIZER_BLOCK'} <= kinds)
        result = query_features(self.project, 'demo.Counter')
        self.assertTrue(any(r['kind'] == 'OVERLOAD_GROUP' for r in result['records']))
        self.assertTrue(all(r['source_transformation'] == 'UNSUPPORTED' and r['status'] == 'REVIEW_REQUIRED' for r in result['records']))
        self.assertEqual(self.project.input.read_file('src/test/java/demo/FlowTest.java')['content'],
                         (ROOT / 'tests/fixtures/FlowTest.java').read_text(encoding='utf-8'))

    def test_analysis_reference_keys_use_same_member_and_control_context(self):
        result = query_member(self.project, 'demo.FlowTest#check()')
        nodes = self.project.data['internal_analysis']['nodes']
        for key in self.project.by_caller[result['member_key']]:
            ref = self.project.references[key]
            if ref['analysis_node_key'] is not None:
                self.assertEqual(nodes[ref['analysis_node_key']]['member_key'], result['member_key'])
                self.assertIn(key, nodes[ref['analysis_node_key']]['reference_keys'])

    def test_analysis_cli_commands_return_real_json(self):
        for command in [('analyze', '--id', 'demo.FlowTest#check()'), ('features', '--id', 'demo.Counter')]:
            process = subprocess.run([sys.executable, str(ROOT / 'context_tool.py'), *command, '--index', str(self.index)], capture_output=True)
            self.assertEqual(process.returncode, 0, process.stdout)
            self.assertIn(json.loads(process.stdout)['status'], {'INTERNAL_ANALYSIS_READ', 'COMPATIBILITY_FEATURES_READ'})


if __name__ == "__main__":
    unittest.main(verbosity=2)
