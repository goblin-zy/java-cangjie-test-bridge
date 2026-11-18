<div align="center">
<h1>html4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.1.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.1.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.5%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## <img alt="" src="./doc/assets/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 介绍

可用于分析互联网上或本地的的网页资源和HTML标签

### 特性

- 🚀 解析html

- 🚀 操作html节点/属性

- 💪 支持css选择器

## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 软件架构


### 源码目录

```shell
.
├─ .gitignore
├─ CHANGELOG.md
├─ LICENSE
├─ cjpm.toml
├─ README.md
├─ README.OpenSource
├─ doc
│   ├─ assets
│   └─ feature_api.md
└─ src
```

- `doc`  文档目录，用于存放API接口等文档
- `src`  源码目录


### 接口说明

主要是核心类和成员函数说明，详情见 [API](https://gitcode.com/Cangjie-TPC/html4cj/blob/develop/doc/feature_api.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译（win/linux）

两种编译方式

1. 使用脚本编译
    1. 下载配置[编译脚本](https://gitcode.com/Cangjie-TPC/TPC-Test-Framework.git)
    2. ciTest build
2. 使用包管理器编译
    1. 该三方库依赖stdx，请参考[stdx](https://gitcode.com/Cangjie/Cangjie-STDX#%E4%BD%BF%E7%94%A8%E6%8C%87%E5%AF%BC)文档配置`CANGJIE_STDX_PATH`路径
    2. cjpm build

### 功能示例

#### 属性

示例代码如下：

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var doc: Document = Html4cj.parse("<a href=/foo>Hello</a>", "http://127.0.0.1/")
    var a: Element = doc.select("a").first().getOrThrow()
    if (a.attr("href") == "/foo") {
        println("pass1")
    }
    if (a.attr("abs:href") == "http://127.0.0.1/foo") {
        println("pass2")
    }
    if (a.hasAttr("abs:href")) {
        println("pass3")
    }
    if (a.hasAttr("abs:href")) {
        println("pass3")
    }
    if (a.baseUri() == "http://127.0.0.1/") {
        println("pass4")
    }
    if (a.nodeName() == "a") {
        println("pass5")
    }
    if (a.html() == "Hello") {
        println("pass6")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
```

## 开源协议

本项目基于 [MIT License](https://gitcode.com/Cangjie-TPC/html4cj/blob/develop/LICENSE) , 请自由享受和参与开源

## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。