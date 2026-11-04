from pathlib import Path
import base64
import json
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import context_tool as tool


class ContextTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp=tempfile.TemporaryDirectory();cls.root=Path(cls.tmp.name)
        cls.project=cls.root/'任意项目名'
        fixture=Path(__file__).resolve().parents[1]/'examples/projects/多模块测试工程'
        shutil.copytree(fixture,cls.project)
        cls.total=tool.collect(cls.project,'spec.CartTest#total()',cls.root/'total')
        cls.whole=tool.collect(cls.project,'checks/src/test/java/spec/CartTest.java',cls.root/'whole')
        cls.other=tool.collect(cls.project,'spec.OtherTest',cls.root/'other')
        cls.dynamic=tool.collect(cls.project,'spec.CartTest#uncertain()',cls.root/'dynamic')
        cls.constant=tool.collect(cls.project,'spec.CartTest#constantResource()',cls.root/'constant')
        cls.cyclic=tool.collect(cls.project,'spec.CartTest#cyclic()',cls.root/'cyclic')

    @classmethod
    def tearDownClass(cls):cls.tmp.cleanup()

    def ids(self,result):return {x['id'] for x in result['records']}

    def test_target_file_and_method_identifiers(self):
        self.assertEqual(len(self.whole['original_tests']),4)
        self.assertEqual(len(self.total['original_tests']),1)
        self.assertIn('seed();',self.total['original_tests'][0]['content'])

    def test_inherited_setup_cleanup_and_field_initialization(self):
        ids=self.ids(self.total)
        self.assertIn('support.BaseCase#prepare()',ids)
        self.assertIn('support.BaseCase#clean()',ids)
        field=next(x for x in self.total['records'] if x['id']=='support.BaseCase#field:cart')
        self.assertIn('new Cart()',field['content'])

    def test_external_helper_and_helper_assertion_not_lost(self):
        record=next(x for x in self.total['records'] if x['id']=='support.TestSupport#check(Cart)')
        self.assertIn('assertEquals(3, value.total())',record['content'])
        self.assertIn('app.Cart#add(int)',self.ids(self.total))

    def test_static_constant_definition(self):
        record=next(x for x in self.total['records'] if x['id']=='app.Limits#field:THREE')
        self.assertIn('THREE = 3',record['content'])

    def test_resource_has_actual_unicode_content(self):
        record=next(x for x in self.total['records'] if x['category']=='resource')
        self.assertEqual(record['content'],(self.project/'checks/src/test/resources/fixtures/price.txt').read_bytes().decode('utf-8'))
        self.assertTrue(record['source']['file'].endswith('price.txt'))

    def test_constant_resource_path_is_resolved(self):
        self.assertTrue(any(x['category']=='resource' for x in self.constant['records']))

    def test_dynamic_overload_and_interface_are_reported(self):
        kinds={x['kind'] for x in self.dynamic['unresolved']}
        self.assertIn('RESOURCE_DYNAMIC_PATH',kinds)
        self.assertIn('OVERLOAD_AMBIGUOUS',kinds)
        self.assertIn('DYNAMIC_IMPLEMENTATION_UNRESOLVED',kinds)

    def test_recursive_helper_stops_without_duplicate_records(self):
        ids=[x['id'] for x in self.cyclic['records']]
        self.assertEqual(len(ids),len(set(ids)))
        self.assertIn('support.TestSupport#cycleA()',ids)
        self.assertIn('support.TestSupport#cycleB()',ids)

    def test_switching_test_does_not_pull_unrelated_helpers(self):
        self.assertNotIn('support.TestSupport#check(Cart)',self.ids(self.other))
        self.assertNotIn('app.Cart#add(int)',self.ids(self.other))

    def test_complete_class_related_members_are_explicit(self):
        record=next(x for x in self.total['records'] if x['category']=='original_test_class')
        self.assertIn('void uncertain()',record['content'])
        related=self.total['related_members']['checks/src/test/java/spec/CartTest.java']
        self.assertIn('spec.CartTest#total()',related)
        self.assertNotIn('spec.CartTest#uncertain()',related)

    def test_real_source_ranges_and_json_markdown_same_content(self):
        for result,name in [(self.total,'total'),(self.whole,'whole')]:
            md=next((self.root/name).glob('*.md')).read_text(encoding='utf-8')
            for rec in result['records']:
                if rec['category']=='resource':continue
                loc=rec['source'];raw=(self.project/loc['file']).read_bytes()
                text=raw.decode('utf-8').encode('utf-16-le')[loc['start_offset_utf16']*2:loc['end_offset_utf16_exclusive']*2].decode('utf-16-le')
                self.assertEqual(rec['content'],text)
                self.assertIn(text.replace('\r\n','\n'),md)
                self.assertEqual(tool.sha(raw),loc['sha256'])

    def test_history_copy_is_not_silently_indexed(self):
        self.assertEqual(self.total['scope']['java_files_indexed'],8)
        self.assertFalse(any(x['kind']=='DUPLICATE_MEMBER' for x in self.total['unresolved']))

    def test_depth_and_member_budget_report_stops(self):
        a=tool.collect(self.project,'spec.CartTest#total()',self.root/'depth',max_depth=1)
        self.assertTrue(any(x['kind']=='DEPTH_LIMIT' for x in a['unresolved']))
        b=tool.collect(self.project,'spec.CartTest#total()',self.root/'budget',max_members=1)
        self.assertTrue(any(x['kind']=='MEMBER_LIMIT' for x in b['unresolved']))

    def test_bad_target_and_overwrite_are_rejected(self):
        with self.assertRaises(ValueError):tool.collect(self.project,'spec.Missing',self.root/'missing')
        self.assertFalse((self.root/'missing').exists())
        with self.assertRaises(ValueError):tool.collect(self.project,'spec.OtherTest',self.root/'other')

    def test_source_and_resource_size_limits_are_explicit(self):
        with self.assertRaisesRegex(ValueError,'源码文件数超过上限'):
            tool.collect(self.project,'spec.OtherTest',self.root/'few-files',max_files=1)
        limited=tool.collect(self.project,'spec.CartTest#total()',self.root/'small-resource',max_resource_bytes=1)
        self.assertTrue(any(x['kind']=='RESOURCE_SIZE_LIMIT' for x in limited['unresolved']))

    def test_method_reference_is_not_guessed_as_zero_argument_call(self):
        project=self.root/'method-reference';project.mkdir()
        (project/'RefTest.java').write_text('import org.junit.Test; class RefTest { void helper(int n){} @Test public void check(){ java.util.function.IntConsumer x=this::helper; } }',encoding='utf-8')
        result=tool.collect(project,'RefTest.java',self.root/'method-reference-out')
        self.assertTrue(any(x['kind']=='METHOD_REFERENCE_UNRESOLVED' for x in result['unresolved']))

    def test_inherited_test_and_unrelated_business_body(self):
        project=self.root/'inherit';project.mkdir()
        (project/'Parent.java').write_text('import org.junit.Test; class Parent { @Test public void inherited(){ new Business().used(); } }',encoding='utf-8')
        (project/'Child.java').write_text('class Child extends Parent {}',encoding='utf-8')
        (project/'Business.java').write_text('class Business { void used(){} void unrelated(){ throw new RuntimeException("irrelevant"); } }',encoding='utf-8')
        result=tool.collect(project,'Child.java#inherited()',self.root/'inherit-out')
        self.assertEqual(result['original_tests'][0]['id'],'Parent#inherited()')
        definition=next(x for x in result['records'] if x['id']=='Business')
        self.assertNotIn('irrelevant',definition['content'])
        self.assertIn('Business#used()',self.ids(result))

    def test_relative_resource_uses_class_literal_package(self):
        project=self.root/'relative-resource'
        code=project/'src/test/java';(code/'app').mkdir(parents=True);(code/'util').mkdir()
        (code/'app/ResourceTest.java').write_text('package app; import org.junit.Test; class ResourceTest { @Test public void reads(){ util.Other.class.getResourceAsStream("data.txt"); } }',encoding='utf-8')
        (code/'util/Other.java').write_text('package util; public class Other {}',encoding='utf-8')
        resource=project/'src/test/resources/util/data.txt';resource.parent.mkdir(parents=True);resource.write_bytes(b'correct-package')
        result=tool.collect(project,'app.ResourceTest',self.root/'relative-resource-out')
        self.assertEqual(next(x['content'] for x in result['records'] if x['category']=='resource'),'correct-package')

    def test_flat_junit4_unicode_crlf_and_binary_resource(self):
        project=self.root/'flat';project.mkdir()
        java='// 中文😀\r\nimport org.junit.Test;\r\nclass FlatTest { @Test public void works(){ getClass().getResourceAsStream("/data.bin"); } }\r\n'
        (project/'FlatTest.java').write_bytes(java.encode('utf-8'))
        (project/'assets').mkdir();(project/'assets/data.bin').write_bytes(b'\xff\x00\x03')
        result=tool.collect(project,'FlatTest.java',self.root/'flat-out',resource_roots=['assets'])
        self.assertTrue(result['scope']['fallback_project_scan'])
        resource=next(x for x in result['records'] if x['category']=='resource')
        self.assertEqual(base64.b64decode(resource['content']),b'\xff\x00\x03')
        test=result['original_tests'][0]
        self.assertEqual(java.encode('utf-16-le')[test['source']['start_offset_utf16']*2:test['source']['end_offset_utf16_exclusive']*2].decode('utf-16-le'),test['content'])


if __name__=='__main__':unittest.main()
