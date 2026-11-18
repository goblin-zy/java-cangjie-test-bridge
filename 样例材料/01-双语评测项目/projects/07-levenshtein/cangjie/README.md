<div align="center">
<h1>leven4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-100.0%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/state-孵化-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/domain-HOS/Cloud-brightgreen" style="display: inline-block;" />
</p>

## <img alt="" src="./doc/readme-image/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 1 介绍

### 1.1 项目特性

1. 使用Levenshtein距离算法测量两个字符串之间的差异。

2. 支持纯英文，纯中文，中英混合字符串


### 1.2 项目计划

1. 2024 年 9 月发布 1.0.0 版本。（已发布）

## <img alt="" src="./doc/readme-image/readme-icon-framework.png" style="display: inline-block;" width=3%/> 2 架构

### 2.1 项目结构

```shell
.
├── README.md
├── LICENSE
├── CHANGELOG
├── cjpm.toml
├── doc
|   └── readme-image
|
└── src
    ├── leven.cj           # 核心代码
    └── test
        └── leven_test.cj      # 测试代码
```

## <img alt="" src="./doc/readme-image/readme-icon-compile.png" style="display: inline-block;" width=3%/> 3 使用说明

### 3.1 编译构建（Win/Linux/Mac）

```shell
cjpm build
```
### 3.2 依赖引入

在cjpm.toml文件中添加下面这句话，执行`cjpm update`即可使用
```shell
[dependencies]
  leven4cj = { git = "https://gitcode.com/Cangjie-TPC/leven4cj.git" }
```
### 3.3 接口介绍
`leven(String, String):Int64`  计算两个字符串的距离
### 3.4 功能示例

#### 3.4.1 测量两个纯英文字符串之间的差异
```cangjie
import leven4cj.*

main(): Int64 {
    var diff1 = leven("a","b")
    println("a和b之间相差${diff1}个字符"); 
    //a和b之间相差1个字符
    
    var diff2 = leven("kitten","sitting")
    println("kitten和sitting之间相差${diff2}个字符"); 
    //kitten和sitting之间相差3个字符

    var diff3 = leven("xabxcdxxefxgx", "abcdefg")
    println("xabxcdxxefxgx和abcdefg之间相差${diff3}个字符"); 
    //xabxcdxxefxgx和abcdefg之间相差6个字符
    return 0
}
```

#### 3.4.2 测量两个中文字符串之间的差异
```cangjie
import leven4cj.*

main(): Int64 {
    var diff1 = leven("因为我是中国人所以我会说中文", "因为我是英国人所以我会说英文")
    println("“因为我是中国人所以我会说中文”和“因为我是英国人所以我会说英文”之间相差${diff1}个字符");  
    //“因为我是中国人所以我会说中文”和“因为我是英国人所以我会说英文”之间相差2个字符
    
    return 0
}
```

## <img alt="" src="./doc/readme-image/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 4 参与贡献

本项目由 [SIGCANGJIE / 仓颉兴趣组](https://gitcode.com/SIGCANGJIE) 实现并维护。技术支持和意见反馈请提Issue。

本项目是仓颉兴趣组 [一星级里程碑项目](https://gitcode.com/SIGCANGJIE/homepage/wiki/CompentencyModel.md)。

本项目基于  Apache License 2.0，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目committer：[@Chemxy](https://gitcode.com/Chemxy)

This project is supervised by [@zhangyin-gitcode](https://gitcode.com/zhangyin_gitcode).