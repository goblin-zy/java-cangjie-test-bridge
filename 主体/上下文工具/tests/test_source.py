"""扫描边界测试：不启动 Java，也不执行输入工程中的任何程序。"""
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from common import load, safe_path
from project_source import ProjectSource, scan_project


class SourceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='source-boundary-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.source = self.base / 'input'
        self.source.mkdir()

    def put(self, name, content='data'):
        path = self.source / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding='utf-8')
        return path

    def test_custom_roots_scope_and_raw_bytes(self):
        self.put('business/pkg/Account.java', 'package pkg; class Account {}\r\n')
        self.put('tests/pkg/A.java', 'package pkg; class A {}')
        self.put('tests/pkg/B.java', 'package pkg; class B {}')
        self.put('support/pkg/Helper.java')
        self.put('fixtures/build/Fixture.java', 'not source')
        self.put('pom.xml', '<project/>')
        self.put('target/ignored.class')
        result = scan_project(self.source, self.base / 'index', business_roots=['business'],
                              test_roots=['tests'], support_roots=['support'], resource_roots=['fixtures'],
                              test_scope=['tests/pkg/A.java'])
        self.assertEqual(result.scope['selected_test_files'], ['tests/pkg/A.java'])
        self.assertEqual(result.files['fixtures/build/Fixture.java']['source_role'], 'resource')
        self.assertFalse(result.files['fixtures/build/Fixture.java']['parse_input'])
        self.assertNotIn('target/ignored.class', result.files)
        self.assertEqual((result.project / 'business/pkg/Account.java').read_bytes(),
                         (self.source / 'business/pkg/Account.java').read_bytes())
        self.assertFalse((self.base / 'index/context_config.json').exists())

    def test_unsafe_output_or_path_or_scope_are_rejected(self):
        self.put('src/test/java/A.java', 'class A {}')
        with self.assertRaises(ValueError):
            scan_project(self.source, self.source / 'index')
        with self.assertRaises(ValueError):
            safe_path(self.source, '../escape')
        with self.assertRaises(ValueError):
            scan_project(self.source, self.base / 'scope', test_scope=['**/Missing.java'])
        self.assertTrue((self.base / 'scope/FAILED.json').is_file())

    def test_explicit_project_root_and_unclassified_source(self):
        self.put('A.java', 'class A {}')
        result = scan_project(self.source, self.base / 'plain', test_roots=['.'])
        self.assertEqual(result.scope['selected_test_files'], ['A.java'])
        default = scan_project(self.source, self.base / 'default')
        self.assertEqual(default.files['A.java']['source_role'], 'support_source')
        self.assertTrue(any(p['kind'] == 'SOURCE_ROLE_NOT_DECLARED' for p in default.issues))

    def test_original_changes_do_not_change_frozen_source(self):
        path = self.put('src/test/java/A.java', 'class A {}')
        result = scan_project(self.source, self.base / 'frozen')
        path.write_text('changed', encoding='utf-8')
        self.assertEqual(result.read_file('src/test/java/A.java')['content'], 'class A {}')
        self.assertIsNone(result.read_file('src/test/java/A.java', 0)['content'])
        (result.project / 'extra.txt').write_text('unexpected', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, '文件集合'):
            ProjectSource(result.manifest_path)

    def test_overlapping_source_roles_are_rejected(self):
        self.put('src/A.java', 'class A {}')
        with self.assertRaisesRegex(ValueError, '重叠'):
            scan_project(self.source, self.base / 'overlap', business_roots=['src'], test_roots=['src'])

    def test_filtered_root_resources_preserve_java_sources(self):
        self.put('src/main/java/A.java', 'class A {}')
        self.put('src/test/java/ATest.java', 'class ATest {}')
        self.put('LICENSE', 'license text')
        self.put('README.md', 'excluded readme')
        self.put('pom.xml', '''<project><build><resources><resource>
          <directory>./</directory><targetPath>META-INF</targetPath>
          <includes><include>LICENSE</include><include>README.md</include></includes>
          <excludes><exclude>README.md</exclude></excludes>
        </resource></resources></build></project>''')
        source = scan_project(self.source, self.base / 'filtered', test_scope=['src/test/java/ATest.java'])
        self.assertEqual(source.scope['selected_test_files'], ['src/test/java/ATest.java'])
        self.assertTrue(source.files['src/main/java/A.java']['parse_input'])
        self.assertEqual(source.files['LICENSE']['source_role'], 'resource')
        self.assertNotEqual(source.files['README.md']['source_role'], 'resource')
        self.assertEqual(source.scope['filtered_resources'], [{'file': 'LICENSE', 'classpath_path': 'META-INF/LICENSE'}])


if __name__ == '__main__':
    unittest.main(verbosity=2)
