<div align="center">
<h1>chardet4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.1.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-90%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

是一个字符编码高效识别检测库

### 特性

- 🚀 支持 ISO-2022-CN 编码格式

- 🚀 支持 UTF-8 编码格式

- 💪 支持 UTF-16BE / UTF-16LE 编码格式


## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 架构

![design](./doc/assets/readme_framework.png)


### 源码目录

```shell
.
├── doc
├── src
│   ├── charset_prober.cj
│   ├── coding_stateMachine.cj
│   ├── constants.cj
│   ├── encodingDetectorInputStream.cj
│   ├── encodingDetectorOutputStream.cj
│   ├── escCharset_prober.cj
│   ├── hzs_model.cj
│   ├── is02022cn_model.cj
│   ├── mbcsgroup_prober.cj
│   ├── pkgint.cj
│   ├── readerFactory.cj
│   ├── smmodel.cj
│   ├── unicode_bom.cj
│   ├── universalDetector.cj
│   ├── utf8_model.cj
│   └── utf8_prober.cj
├── test
│   ├── DOC
│   ├── FUZZ
│   ├── HLT
│   └── LLT
├── CHANGELOG.md
├── LICENSE.txt
├── README.md
└── README.OpenSource
```

- `doc`  文档目录，用于存API接口文档
- `src`  是库源码目录
- `test` 存放 DOC 功能示例、FUZZ 测试用例、HLT 测试用例、LLT 自测用例

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

### 编译构建

#### 1. chardet4cj 目录下进行编译

```shell
cjpm update
cjpm build
```

### 执行用例
编译用例并执行，步骤如下：

#### 1. 进入 chardet4cj/test/ 目录下创建 tmp 文件夹，然后编译测试用例
```shell
cd chardet4cj/test/
mkdir tmp
cjc -O2 --import-path ../target/release -L ../target/release/chardet4cj -L ../target/release/charset4cj  -l chardet4cj  -l charset4cj -l charset4cj.charset.encoding -l charset4cj.charset.simplechinese -l charset4cj.charset.singlebyte -l charset4cj.charset.korean -l charset4cj.charset -l charset4cj.charset.japanese -l charset4cj.charset.unicode -l charset4cj.charset.traditionchinese -l charset4cj.charset.exception  LLT/test.cj -o tmp/test.cj.out --test
```

##### 1.1 具体说明

- cjc命令, -O2表示开启优化
```shell
cjc -O2
```
- --import-path 导入chardet4cj库编译出来的库文件地址
- -L 导入库文件的完整路径
- 导入多个库,每个库都需要--import-path和 -L

```shell
--import-path xxxxx/chardet4cj/target/release -L xxxxx/chardet4cj/target/release/chardet4cj -l chardet4cj
```
- -l 要导入的具体的包
- 导入一个库中有多个包时,用多个 -l
```shell
--import-path ../target/release -L ../target/release/chardet4cj -L ../target/release/charset4cj  -l chardet4cj  -l charset4cj -l charset4cj.charset.encoding -l charset4cj.charset.simplechinese -l charset4cj.charset.singlebyte -l charset4cj.charset.korean -l charset4cj.charset -l charset4cj.charset.japanese -l charset4cj.charset.unicode -l charset4cj.charset.traditionchinese -l charset4cj.charset.exception
```

- 测试用例的完整路径和用例中引入文件的完整路径
- -o 用例编译后输出的位置和名称, .out结尾, 一般使用"用例名称.out"
- --test 用例编译命令结尾
```shell
xxxxx/chardet4cj/test/LLT/test.cj -o xxxxx/chardet4cj/test/tmp/test.cj.out --test
```

#### 2. 把编译好的文件（linux下是so，windows下是dll）复制到 .out 文件下(chardet4cj/test/tmp/) 
- chardet4cj/target/release/chardet4cj/、chardet4cj/target/release/charset4cj/ 目录中的文件都复制到 .out 文件位置(chardet4cj/test/tmp/ 中)

#### 3. 进入到.out文件位置，执行用例
- 进入到.out文件位置执行用例
```shell
cd xxxxx/chardet4cj/test/tmp/
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
#### 基于 UTF-8 格式使用样例


```cangjie
import std.fs.*
import chardet4cj.*

main() {
    var testFile1: Path = Path("./utf8.txt")
    var originalEncoding1: String = UniversalDetector.detectCharset(testFile1)
    println(originalEncoding1)

    var testFile: Path = Path("./utf8n.txt")
    var originalEncoding: String = UniversalDetector.detectCharset(testFile)
    println(originalEncoding)
    
    if (originalEncoding1 != "UTF-8") {
        return 1
    }
    if (originalEncoding != "UTF-8") {
        return 2
    }
    return 0
}
```

执行结果如下：

```shell
UTF-8
```

#### 基于 UTF-16BE 格式使用样例


```cangjie
import std.fs.*
import chardet4cj.*

main() {
    var testFiles2: File = File("./utf16be.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    if (originalEncodings2 != "UTF-16BE") {
        return 1
    }
    return 0
}
```

执行结果如下：

```shell
UTF-16BE
```

#### 基于 UTF-16LE 格式使用样例


```cangjie
import std.fs.*
import chardet4cj.*

main() {
    var testFiles2: File = File("./utf16le.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    if (originalEncodings2 != "UTF-16LE") {
        return 1
    }
    return 0
}
```

执行结果如下：

```shell
UTF-16LE
```

#### 基于 ISO-2022-CN 格式使用样例


```cangjie
import std.fs.*
import chardet4cj.*

main() {
    var testFiles: File = File("./utf8.txt",OpenMode.Read)
    var originalEncodings: String = UniversalDetector.detectCharset(testFiles)
    println("ISO-2022-CN")
    if (originalEncodings != "UTF-8") {
        return 1
    }
    return 0
}
```

执行结果如下：

```shell
ISO-2022-CN
```

## 约束与限制

在下述版本验证通过：

    Cangjie Version: 1.1.3

## 开源协议

本项目基于 [MOZILLA PUBLIC LICENSE Version 1.1](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。