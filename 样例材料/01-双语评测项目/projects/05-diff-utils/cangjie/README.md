<div align="center">
<h1>diffutils4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.2-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.2.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-93.3%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

该库可以逐行比对两个字符串的差异，并按行将差异展示出来，提供补丁打包和添加功能。文档和数据的对比需要先转换为字符串数组再使用该库进行逐行比对。

### 特性

- 🚀 对比两组字符串之间的差异
- 💪 提供添加和打包补丁的功能
- 🚀 固定格式显示两组字符串的差异


## 软件架构

### 源码目录

```shell
.
├── doc
├── src
│   ├── change_delta.cj
│   ├── chunk.cj
│   ├── delete_delta.cj
│   ├── delta_comparator.cj
│   ├── delta.cj
│   ├── diff_algorithlm.cj
│   ├── diff_exception.cj
│   ├── diff_node.cj
│   ├── differentiation_failedexception.cj
│   ├── diffutils.cj
│   ├── equalizer.cj
│   ├── insert_delta.cj
│   ├── myers_diff.cj
│   ├── patch.cj
│   ├── path_faulled_exception.cj
│   └── path_node.cj
│   └── snake.cj
└── test
│   ├── DOC
│   ├── FUZZ
│   ├── HLT
│   └── LLT
├── CHANGELOG.md
├── LICENSE.txt
├── module.json
├── README.md
└── README.OpenSource
```

- `doc`  文档目录，用于存API接口文档
- `src`  是库源码目录
- `test` 存放 HLT 测试用例、LLT 自测用例、FUZZ 测试用例和文档示例用例

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

### 编译构建

#### Linux 环境编译

编译描述和具体shell命令

```shell
cjpm update
cjpm build
```

#### Window 环境编译

编译描述和具体cmd命令

```shell
cjpm update
cjpm build
```

### 执行用例
编译用例并执行，步骤如下：

#### 1. 进入 diffutils4cj/test/ 目录下创建 tmp 文件夹，然后编译测试用例
```shell
cd diffutils4cj/test/
mkdir tmp
cjc -O2 --import-path xxxxx/diffutils4cj/build/diffUtils4cj/.. -L xxxxx/diffutils4cj/build/diffUtils4cj -l diffUtils4cj_diffUtils4cj xxxxx/diffutils4cj/test/HLT/Builder/test_Builder_columnWidth_01.cj -o xxxxx/diffutils4cj/test/tmp/test.cj.out --test
```

##### 1.1 具体说明

- cjc命令, -O2表示开启优化
```shell
cjc -O2
```
- --import-path 导入oauth库编译出来的库文件地址, 注意地址最后有".."
- -L 导入库文件的完整路径

```shell
--import-path xxxxx/diffutils4cj/build/diffUtils4cj/.. -L xxxxx/diffutils4cj/build/diffUtils4cj -l diffUtils4cj_diffUtils4cj
```
- -l 要导入的具体的包, 用"库名_包名",一般库文件生成时是"lib库名_包名.后缀"的格式
- 测试用例的完整路径和用例中引入文件的完整路径
- -o 用例编译后输出的位置和名称, .out结尾, 一般使用"用例名称.out"
- --test 用例编译命令结尾
```shell
xxxxx/diffutils4cj/test/HLT/Builder/test_Builder_columnWidth_01.cj -o xxxxx/diffutils4cj/test/tmp/test.cj.out --test
```

#### 2. 把编译好的文件复制到 .out 文件下(diffutils4cj/test/tmp/) 
- 把diffutils4cj/build/diffutils4cj/目录中的文件都复制到 .out 文件位置(diffutils4cj/test/tmp/ 中)

#### 3. 进入到.out文件位置，执行用例
- 进入到.out文件位置执行用例
```shell
cd xxxxx/diffutils4cj/test/tmp/
```
- windows系统打开cmd,输入.out文件完整名称即可执行
```shell
test.cj.out
```
- Linux系统使用 ./.out文件完整名称
```shell
./test.cj.out
```

### 功能示例
#### 对比两组字符串之间的差异功能示例

功能示例描述:

示例代码如下：

```cangjie
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_ReadMe01()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_ReadMe01 {
    @TestCase
    public func testReadMe01(): Unit {
		var patch:  Patch<String>= DiffUtils.diff(ArrayList<String>(["hhh"]), ArrayList<String>(["hhh", "jjj", "kkk"]))
		@Assert(patch.getDeltas().isEmpty(),false)
		@Assert(patch.getDeltas().size,1)

		var  delta = patch.getDeltas().get(0).getOrThrow()
		@Assert(delta is InsertDelta<String>, true)
        @Assert(delta.getOriginal().getLines().isEmpty(), true)
        @Assert(delta.getRevised().getLines().toArray().toString(), "[jjj, kkk]")
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testReadMe01
```

#### 提供添加和打包补丁的功能

示例代码如下：

```cangjie
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_ReadMe01()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_ReadMe02 {
    @TestCase
    public func testReadMe02(): Unit {
		var rev = ArrayList<String>(["hhh", "jjj", "kkk"])
		var orig= ArrayList<String>()
		var patch:  Patch<String>= DiffUtils.diff(rev, orig)
		var res = DiffUtils.patch(rev,patch)
        @Assert(res == orig, true)
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testReadMe02
```

#### 固定格式显示两组字符串的差异

示例代码如下：

```cangjie
import std.math.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_ReadMe03()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_ReadMe03 {
    @TestCase
    public func testReadMe01(): Unit {
		var first = "anything \n \nother\nmore lines";
		var second ="anything\n\nother\nsome more lines"
		var generator = Builder().ignoreWhiteSpaces(true).columnWidth(Int64.Max).build()
		var rows = generator.generateDiffRows(ArrayList<String>(first.split("\n")), ArrayList<String>(second.split("\n")))
		
		@Assert(rows.size,4)
		@Assert(rows.get(0).getOrThrow().getTag().toString(),"EQUAL")
		@Assert(rows.get(1).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(2).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(3).getOrThrow().getTag().toString(),"CHANGE")
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testReadMe03
```

## 约束与限制

在下述版本验证通过：

    Cangjie Version: 1.2.0

## 开源协议

本项目基于 [Apache License 2.0](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。