<div align="center">
<h1>caverphone4cj</h1>
</div>


<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.55.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-93.8%25-brightgreen" style="display: inline-block;" />
</p>

## 介绍

A Cangjie implementation of the [Caverphone 2.0 (aka Caverphone Revised)](https://github.com/tcort/caverphone) phonetic matching algorithm.

### 项目特性

- 可将英文单词转换为数字字符串，用于比较英文单词发音相似度。

## 项目架构

### 源码目录

```shell
.
├── README.md
├── doc
│   ├── assets
│   └── feature_api.md
└── src
```
- doc是库的API文档等内容
- src是库源码目录
### 接口说明

主要类和函数接口说明，详见 [API](./doc/feature_api.md)


## 使用说明
### 编译构建

描述具体的编译过程：

```shell
cpm update
cpm build
```

### 功能示例

示例代码如下：

```cangjie
import caverphone.*
main() {
  var input = "Cailean"
  var output = caverphone(input) // "KLN1111111"
}
```


## 开源协议
[ISC License](https://gitcode.com/Cangjie-TPC/caverphone4cj/blob/develop/LICENSE)

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。