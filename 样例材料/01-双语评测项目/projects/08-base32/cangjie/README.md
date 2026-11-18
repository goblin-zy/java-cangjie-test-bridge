<div align="center">
<h1>hibase32</h1>
</div>
<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.1.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
</p>

##  1 介绍

### 1.1 项目特性

1. 本项目是使用仓颉实现的一个简单的Base32(RFC 4648)编码/解码函数同时支持UTF-8编码 。
2. 本项目迁移自[hi-base32/src/base32.js at master · emn178/hi-base32 (github.com)](https://github.com/emn178/hi-base32/blob/master/src/base32.js) 

### 1.2 项目计划

1. 计划对本项目中所使用的使用仓颉自行实现的Js的库函数，例如>>>的仓颉实现和仓颉实现的获取字符串长度等（单元测试已进行测试通过），等到仓颉有相关库函数后替换为仓颉官方库函数。
2. 对本项目中可能潜在的bug进行不定期修复。

##  2 架构

### 2.1 项目结构

```shell
.
├── README.md
├── LICENSE
├── cjpm.toml
|
└── src
	└── test					# 测试代码
        ├── base32_test.cj
    └── base32.cj             # 核心代码
```

### 2.2 接口说明

| 名称                                                         | 用途                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `public func decodeAsBytes(base32Str: String): Array<UInt8>` | 将 Base32 编码的字符串解码为字节数组                         |
| `private func encodeBytes(bytes: Array<UInt8>): String `         | 将一个字节数组`Array<UInt8>`编码为一个十六进制字符串         |
| ` public func unsignedRightShift(value:Int64,shift:Int64):Int64  ` | 无符号右移>>>                                                |

## 3 使用说明

### 3.1 编译构建（Win/Linux/Mac）

```shell
cjpm build
```

### 3.2 功能示例
#### 3.2.1 进行编码

```cangjie
encode("Hello") //编码结果为"JBSWY3DP"
encode("Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.",true) //编码结果为"JVQW4IDJOMQGI2LTORUW4Z3VNFZWQZLEFQQG433UEBXW43DZEBRHSIDINFZSA4TFMFZW63RMEBRHK5BAMJ4SA5DINFZSA43JNZTXK3DBOIQHAYLTONUW63RAMZZG63JAN52GQZLSEBQW42LNMFWHGLBAO5UGSY3IEBUXGIDBEBWHK43UEBXWMIDUNBSSA3LJNZSCYIDUNBQXIIDCPEQGCIDQMVZHGZLWMVZGC3TDMUQG6ZRAMRSWY2LHNB2CA2LOEB2GQZJAMNXW45DJNZ2WKZBAMFXGIIDJNZSGKZTBORUWOYLCNRSSAZ3FNZSXEYLUNFXW4IDPMYQGW3TPO5WGKZDHMUWCAZLYMNSWKZDTEB2GQZJAONUG64TUEB3GK2DFNVSW4Y3FEBXWMIDBNZ4SAY3BOJXGC3BAOBWGKYLTOVZGKLQ="
encode("Base64 is a group of similar binary-to-text encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation.") //编码结果为"IJQXGZJWGQQGS4ZAMEQGO4TPOVYCA33GEBZWS3LJNRQXEIDCNFXGC4TZFV2G6LLUMV4HIIDFNZRW6ZDJNZTSA43DNBSW2ZLTEB2GQYLUEBZGK4DSMVZWK3TUEBRGS3TBOJ4SAZDBORQSA2LOEBQW4ICBKNBUSSJAON2HE2LOM4QGM33SNVQXIIDCPEQHI4TBNZZWYYLUNFXGOIDJOQQGS3TUN4QGCIDSMFSGS6BNGY2CA4TFOBZGK43FNZ2GC5DJN5XC4==="
```

#### 3.2.2 utf8Str进行编码

```cangjie
encode("中文") //编码结果为4S4K3ZUWQ4======
encode("中文12") //编码结果为4S4K3ZUWQ4YTE===
encode("aécio") //编码结果为MHB2SY3JN4======
encode("𠜎") //编码结果为6CQJZDQ=
encode("Base64是一種基於64個可列印字元來表示二進制資料的表示方法") //编码结果为IJQXGZJWGTTJRL7EXCAOPKFO4WP3VZUWXQ3DJZMARPSY7L7FRCL6LDNQ4WWZPZMFQPSL5BXIUGUOPJF24S5IZ2MAWLSYRNXIWOD6NFUZ46NIJ2FBVDT2JOXGS246NM4V
```
#### 3.2.3 非字符串进行编码

```cangjie
encode([72]) //编码结果为JA======
encode([72, 101, 108] //编码结果为JBSWY===
encode([72, 101, 108, 108]) //编码结果为JBSWY3A=
encode([72, 101, 108, 108, 111]) //编码结果为JBSWY3DP
```
#### 3.2.3 Uint8Array进行编码

```cangjie
var arr=Array<UInt8>([72, 101, 108, 108, 111])
encode(arr) //编码结果为 JBSWY3DP
```
#### 3.2.4 ArrayBuffer进行编码

```cangjie
var buffer:Array<Byte>=[0]
encode(buffer) //编码结果为AA======
```
#### 3.2.5 对base32Str进行解码

```cangjie
decode("JBSQ====") //He
```
#### 3.2.6 对base32Utf8Strs 进行解码

```cangjie
decode("4S4K3ZUWQ4======") //中文
decode("4S4K3ZUWQ4YTE===") //中文12
decode("MHB2SY3JN4======") //aécio
decode("IJQXGZJWGTTJRL7EXCAOPKFO4WP3VZUWXQ3DJZMARPSY7L7FRCL6LDNQ4WWZPZMFQPSL5BXIUGUOPJF24S5IZ2MAWLSYRNXIWOD6NFUZ46NIJ2FBVDT2JOXGS246NM4V") //Base64是一種基於64個可列印字元來表示二進制資料的表示方法
```

## 4已知问题 

### 4.1仓颉缺少常用的运算符和库函数

js中>>>的仓颉实现函数：(function) func unsignedRightShift(value: Int64, shift: Int64): Int64 

js中>!/^[A-Z2-7=]+$/.test(base32Str)的仓颉实现函数：(function) func testVaildBase32(str: String): Bool 

## 5参与贡献

本项目由 [SIGCANGJIE / 仓颉兴趣组](https://gitcode.com/SIGCANGJIE) 实现并维护。技术支持和意见反馈请提Issue。

本项目基于 MIT License，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目committer：([Moem(@Moem) - GitCode](https://gitcode.com/Moem) )

This project is supervised by [@zhangyin_gitcode](https://gitcode.com/zhangyin_gitcode) (HUAWEI Developer Advocate).

![](https://raw.gitcode.com/SIGCANGJIE/homepage/attachment/uploads/9b648c07-efc2-4eb3-b02f-eab18c77beea/devadvocate.png)