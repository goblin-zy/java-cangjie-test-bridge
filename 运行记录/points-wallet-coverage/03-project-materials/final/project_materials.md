# 项目约定与公共材料

项目：points-wallet
扫描：a07cfb9abf855d9b5240252b
阶段：codex_partial

> 直接事实、分析推断与确认状态分别记录；结构检查不证明语义等价。未运行输入项目或测试。

## 读取范围与版本

```json
{
  "config": {
    "project_name": "points-wallet",
    "sources": [
      {
        "name": "java_business",
        "path": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\main\\java",
        "language": "java",
        "role": "business",
        "include": [
          "**/*"
        ],
        "exclude": [],
        "encoding": "utf-8-sig"
      },
      {
        "name": "java_tests",
        "path": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\test\\java",
        "language": "java",
        "role": "test",
        "include": [
          "**/*"
        ],
        "exclude": [],
        "encoding": "utf-8-sig"
      },
      {
        "name": "project_docs",
        "path": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\README.md",
        "language": "documents",
        "role": "documentation",
        "include": [
          "**/*"
        ],
        "exclude": [],
        "encoding": "utf-8-sig"
      }
    ],
    "output_dir": "D:\\program_study\\yrys\\Translation-all\\output\\points-wallet-coverage\\03-project-materials\\scan",
    "allow_target_tests": false,
    "allow_unparsed_target_evidence": false,
    "exclude": [],
    "max_file_bytes": 3000000,
    "parsers": {
      "java": "D:\\program_study\\yrys\\environment-config\\tools\\jdk-17\\bin\\java.exe",
      "javac": "D:\\program_study\\yrys\\environment-config\\tools\\jdk-17\\bin\\javac.exe",
      "cjc": "cjc",
      "cangjie_helper": null,
      "java_source_roots": [
        "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\main\\java",
        "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\test\\java"
      ],
      "java_classpath": [
        "D:\\program_study\\yrys\\environment-config\\libraries\\junit-platform-console-standalone-1.13.4.jar"
      ],
      "java_language_level": "JAVA_17",
      "timeout_seconds": 120
    }
  },
  "versions": {
    "java_business": {
      "root": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\main\\java",
      "commit": null,
      "note": "非可读Git工作副本；使用逐文件SHA-256"
    },
    "java_tests": {
      "root": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet\\src\\test\\java",
      "commit": null,
      "note": "非可读Git工作副本；使用逐文件SHA-256"
    },
    "project_docs": {
      "root": "D:\\program_study\\yrys\\Translation-all\\01-projects\\points-wallet",
      "commit": null,
      "note": "非可读Git工作副本；使用逐文件SHA-256"
    }
  },
  "coverage": {
    "files": 3,
    "members": 11,
    "references": 25,
    "issues": 5,
    "status_counts": {
      "collected": 1,
      "parsed": 2
    }
  },
  "scope_note": "仅声明/语法草稿；未进行语义核验。未出现的分类需要Codex检查，不能视为项目不存在。",
  "parser_source_hashes": {
    "adapters\\java\\ProjectExtractor.java": "3657157e0f116913357cf30bbd9316505cc0b603dd5563ff386d6f4f64063465",
    "adapters\\cangjie\\ast_dump.cj": "9fa0f4c0c05d10e2e7bcaba4e0e2b3875716e827b2f9add42f3145151ef924f1",
    "src\\pmtool\\__init__.py": "a8a2b7e40811f8aaf93d14ba41438282f8b68858ef22ef74bb801a50c60d689b",
    "src\\pmtool\\__main__.py": "23bb93dfa82b94036fce266f0a5b99f353ebebb2bb71dd25eb3379875a9fc557",
    "src\\pmtool\\cj_ast.py": "8195a3682a10d8f309cf16464238c6fa8e1c6422cb47bb43a997c31d22994f9f",
    "src\\pmtool\\cli.py": "e5d0c1ab40843a06cf6c86994935ae325b9422398b6efca3c4bb5097f25388c1",
    "src\\pmtool\\config_extract.py": "c0e996483ab7479699b8e18084d1cb4d30900698542a9bebc40b3242feb3b821",
    "src\\pmtool\\db.py": "3eaceb119ba6959edff6dcb544ab9b6db94c0c539fe6198d15a30d6c31be689f",
    "src\\pmtool\\frontends.py": "e185eee78a3dd2beebff71eaec5e395cfab732eadbe9ff84ae4403dbbf42b0b1",
    "src\\pmtool\\materials.py": "32842c514ee534e8522d95ff827810ca38614a7ec44aabcfbad1c676cc24dc9d",
    "src\\pmtool\\models.py": "0d446cea1dc5d8249da76e1c76c520520390bf7d58eee3b1c36348b90ab6ac2c",
    "src\\pmtool\\packets.py": "ce9db3a7fd503469cba6b7dd4203e0aeb58a1424dc14c8f7a964a35159bc913a",
    "src\\pmtool\\scan.py": "06468e70d2c2cc2a478a96016d9a610fbb330bf66f1a77e9d611ba5f78ed7b71",
    "src\\pmtool\\util.py": "c43aa0bbc704f105bd88e128a96785b45d07465d793aeff1ff3e4daf7b0ad544"
  },
  "parser_environment": {
    "classpath": [
      {
        "path": "D:\\program_study\\yrys\\environment-config\\libraries\\junit-platform-console-standalone-1.13.4.jar",
        "sha256": "3fdfc37e29744a9a67dd5365e81467e26fbde0b7aa204e6f8bbe79eeaa7ae892"
      }
    ],
    "java_libraries": [
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\checker-qual-3.43.0.jar",
        "sha256": "3fbc2e98f05854c3df16df9abaa955b91b15b3ecac33623208ed6424640ef0f6"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\error_prone_annotations-2.28.0.jar",
        "sha256": "f3fc8a3a0a4020706a373b00e7f57c2512dd26d1f83d28c7d38768f8682b231e"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\failureaccess-1.0.2.jar",
        "sha256": "8a8f81cf9b359e3f6dfa691a1e776985c061ef2f223c9b2c80753e1b458e8064"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\gson-2.11.0.jar",
        "sha256": "57928d6e5a6edeb2abd3770a8f95ba44dce45f3b23b7a9dc2b309c581552a78b"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\guava-33.3.1-jre.jar",
        "sha256": "4bf0e2c5af8e4525c96e8fde17a4f7307f97f8478f11c4c8e35a0e3298ae4e90"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\j2objc-annotations-3.0.0.jar",
        "sha256": "88241573467ddca44ffd4d74aa04c2bbfd11bf7c17e0c342c94c9de7a70a7c64"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\javaparser-core-3.26.3.jar",
        "sha256": "a24c4fa7799ffe0c7a9af11d4eecd757098ed4498f86067bf28b46b2bfea1833"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\javaparser-symbol-solver-core-3.26.3.jar",
        "sha256": "56b8a20297b940e0554584bea6429a62a424f3385d7eb8040f5a0254d6f715ac"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\javassist-3.30.2-GA.jar",
        "sha256": "eba37290994b5e4868f3af98ff113f6244a6b099385d9ad46881307d3cb01aaf"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\jsr305-3.0.2.jar",
        "sha256": "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7"
      },
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\lib\\listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar",
        "sha256": "b372a037d4230aa57fbeffdef30fd6123f9c0c2db85d0aced00c91b974f33f99"
      }
    ],
    "java_classes": [
      {
        "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\java\\classes\\ProjectExtractor.class",
        "sha256": "4304d9ec3409a72f574342353336e3a69cdb960b75d7ba5b23eeffeaffa65830"
      }
    ],
    "environment": {
      "JAVA_HOME": null,
      "CANGJIE_HOME": null
    },
    "java": {
      "path": "D:\\program_study\\yrys\\environment-config\\tools\\jdk-17\\bin\\java.exe",
      "sha256": "cd2202966eee212ee1c58d54a1e55a8db9110b84fd0be356538bfbdd79a27132"
    },
    "jdk_release": {
      "path": "D:\\program_study\\yrys\\environment-config\\tools\\jdk-17\\release",
      "sha256": "90a7d1167433e9cca8ca0a426b7d1681d74a8669f6eaa6af10e3dcfbd6367726"
    },
    "cjc": {
      "configured": "cjc",
      "available": false
    },
    "cangjie_helper": {
      "path": "D:\\program_study\\yrys\\Translation-all\\three-material-get\\Project Agreement and Public Materials Generation Tool\\.build\\cangjie\\ast_dump.exe",
      "sha256": null
    },
    "limitations": "记录已识别助手、JAR、JDK元数据及环境根；不保证穷尽系统动态库，也不证明SDK运行正确。"
  },
  "reviewable_file_ids": [
    "java_business:wallet/PointsWallet.java",
    "java_tests:wallet/PointsWalletTest.java",
    "project_docs:README.md"
  ]
}
```

已读文件：java_business:wallet/PointsWallet.java, java_tests:wallet/PointsWalletTest.java, project_docs:README.md
已分析分类：C03, C04, C05

## C01 项目结构与模块关系

### P-cc07744e6bcada76b3b6f354 · 文件位置、包与导入

- 对象：java_business:wallet/PointsWallet.java
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：java_business:wallet/PointsWallet.java
- 确认说明：未确认

```json
{
  "relative_path": "wallet/PointsWallet.java",
  "root": "java_business",
  "module": "java_business",
  "language": "java",
  "role": "business",
  "effective_role": "business",
  "package": "wallet",
  "imports": [],
  "status": "parsed"
}
```

来源：

- java_business:wallet/PointsWallet.java，第1—2行

```json
{
  "quote": "package wallet;\n"
}
```

关联成员：无


### P-2145828215870fe624c7fbda · 文件位置、包与导入

- 对象：java_tests:wallet/PointsWalletTest.java
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：java_tests:wallet/PointsWalletTest.java
- 确认说明：未确认

```json
{
  "relative_path": "wallet/PointsWalletTest.java",
  "root": "java_tests",
  "module": "java_tests",
  "language": "java",
  "role": "test",
  "effective_role": "test",
  "package": "wallet",
  "imports": [
    "import org.junit.jupiter.api.BeforeEach;\r\n",
    "import org.junit.jupiter.api.Test;\r\n",
    "import static org.junit.jupiter.api.Assertions.assertEquals;\r\n",
    "import static org.junit.jupiter.api.Assertions.assertFalse;\r\n",
    "import static org.junit.jupiter.api.Assertions.assertTrue;\r\n"
  ],
  "status": "parsed"
}
```

来源：

- java_tests:wallet/PointsWalletTest.java，第1—8行

```json
{
  "quote": "package wallet;\n\nimport org.junit.jupiter.api.BeforeEach;\nimport org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.assertEquals;\nimport static org.junit.jupiter.api.Assertions.assertFalse;\nimport static org.junit.jupiter.api.Assertions.assertTrue;\n"
}
```

关联成员：无


### P-26f23802b708af150779b6bc · 文件位置、包与导入

- 对象：project_docs:README.md
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：project_docs:README.md
- 确认说明：未确认

```json
{
  "relative_path": "README.md",
  "root": "project_docs",
  "module": "project_docs",
  "language": "documents",
  "role": "documentation",
  "effective_role": null,
  "package": "",
  "imports": [],
  "status": "collected"
}
```

来源：

- project_docs:README.md，第1—5行

```json
{
  "quote": "# 积分钱包\n\n一个用于验证 Java 测试翻译流程的独立小项目。钱包从给定余额开始，消费时扣除积分，积分不足时返回 false 并保持余额。\n\nJava 源码在 `src/main/java`，JUnit 5 测试在 `src/test/java`。目标测试沿用包名 `wallet`，暂定业务接口为 `PointsWallet(Int32)`、`spend(Int32): Bool` 和 `balance(): Int32`。目标业务实现由接收方提供。"
}
```

关联成员：无


## C02 项目符号对应表

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C03 目标接口与数据结构

### wallet-api · 暂定仓颉接口

- 对象：wallet.PointsWallet
- 依据类型：document_statement；状态：pending
- 适用范围：points-wallet
- 确认说明：未确认

```json
{
  "api": [
    "PointsWallet(Int32)",
    "spend(Int32): Bool",
    "balance(): Int32"
  ]
}
```

来源：

- project_docs:README.md，第5—5行

```json
{
  "quote": "Java 源码在 `src/main/java`，JUnit 5 测试在 `src/test/java`。目标测试沿用包名 `wallet`，暂定业务接口为 `PointsWallet(Int32)`、`spend(Int32): Bool` 和 `balance(): Int32`。目标业务实现由接收方提供。"
}
```

关联成员：无


## C04 项目公共业务约定

### wallet-contract · 消费和余额约定

- 对象：wallet.PointsWallet
- 依据类型：source_fact；状态：extracted
- 适用范围：points-wallet
- 确认说明：未确认

```json
{
  "behavior": "余额不足时返回 false 并保持余额，否则扣减并返回 true。"
}
```

来源：

- java_business:wallet/PointsWallet.java，第10—20行

```json
{
  "quote": "    public boolean spend(int amount) {\n        if (amount > points) {\n            return false;\n        }\n        points -= amount;\n        return true;\n    }\n\n    public int balance() {\n        return points;\n    }"
}
```

关联成员：无


## C05 公共测试基础设施及迁移状态

### wallet-fixture · 每条测试从 100 积分开始

- 对象：wallet.PointsWallet
- 依据类型：source_fact；状态：extracted
- 适用范围：points-wallet
- 确认说明：未确认

```json
{
  "setup": "setup 调用 newWallet，创建独立钱包。"
}
```

来源：

- java_tests:wallet/PointsWalletTest.java，第12—19行

```json
{
  "quote": "    private PointsWallet newWallet() {\n        return new PointsWallet(100);\n    }\n\n    @BeforeEach\n    void setup() {\n        wallet = newWallet();\n    }"
}
```

关联成员：无


## C06 依赖替代与兼容方案

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C07 已完成的目标代码与允许使用的范例

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C08 工具链与构建配置

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C09 公共资源与环境约定

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C10 翻译和装配约束

当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。

## C11 支持范围与特殊处理决定

### P-358fd7d3d649b6e3504de0d8 · 源测试机制观察：test

- 对象：M-064bdb72283e753ed20e47c5
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：M-064bdb72283e753ed20e47c5
- 确认说明：未确认

```json
{
  "member_id": "M-064bdb72283e753ed20e47c5",
  "annotations": [
    "Test"
  ],
  "observed_role": "test"
}
```

来源：

- java_tests:wallet/PointsWalletTest.java，第29—33行；成员 M-064bdb72283e753ed20e47c5

```json
{
  "quote": "    @Test\n    void rejectsOverspending() {\n        assertFalse(wallet.spend(150));\n        assertEquals(100, wallet.balance());\n    }"
}
```

关联成员：M-064bdb72283e753ed20e47c5

- 限制：观察到机制不代表翻译工具支持它；本条不是某测试输入或预期值。

### P-60f246e2db5b6962289b7e56 · 源测试机制观察：test

- 对象：M-766a50441d70bf9a044ff3af
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：M-766a50441d70bf9a044ff3af
- 确认说明：未确认

```json
{
  "member_id": "M-766a50441d70bf9a044ff3af",
  "annotations": [
    "Test"
  ],
  "observed_role": "test"
}
```

来源：

- java_tests:wallet/PointsWalletTest.java，第21—27行；成员 M-766a50441d70bf9a044ff3af

```json
{
  "quote": "    @Test\n    void spendsPointsInOrder() {\n        assertTrue(wallet.spend(30));\n        assertEquals(70, wallet.balance());\n        assertTrue(wallet.spend(20));\n        assertEquals(50, wallet.balance());\n    }"
}
```

关联成员：M-766a50441d70bf9a044ff3af

- 限制：观察到机制不代表翻译工具支持它；本条不是某测试输入或预期值。

### P-36c36ba8f09d13a5185cd1ff · 源测试机制观察：setup

- 对象：M-f8012357a7125c90ae4d2e82
- 依据类型：source_fact；状态：extracted
- 适用范围：本次扫描：M-f8012357a7125c90ae4d2e82
- 确认说明：未确认

```json
{
  "member_id": "M-f8012357a7125c90ae4d2e82",
  "annotations": [
    "BeforeEach"
  ],
  "observed_role": "setup"
}
```

来源：

- java_tests:wallet/PointsWalletTest.java，第16—19行；成员 M-f8012357a7125c90ae4d2e82

```json
{
  "quote": "    @BeforeEach\n    void setup() {\n        wallet = newWallet();\n    }"
}
```

关联成员：M-f8012357a7125c90ae4d2e82

- 限制：观察到机制不代表翻译工具支持它；本条不是某测试输入或预期值。

## 缺失、冲突与待确认问题

### I-19f5e8a25433cc0342154db1 · pending

M-d438ed572a340d0d4de26e09

未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。

### I-84f5f341950030c9c7a3f29d · pending

M-45fca66f02d1d08d00faaf5f

未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。

### I-9052d5fdfe7ff33c4bed96d1 · pending

M-ddb5194ed980dd905af7a440

未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。

### I-9dfd3545da419b8d90302704 · pending

M-7a25b9c6cdea6956d16d3e16

未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。

### I-cc4ad12f9078ee6e04ddff1e · pending

M-5a28b130da3f461c5d6f89c6

未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。

## 分析记录

- 程序草稿：未调用模型、未运行输入项目、未确认候选等价。
- 核对业务接口、消费约定与共享准备方法。目标实现缺失，接口按 README 暂定。

## 结构与来源检查

```json
{
  "structurally_valid": true,
  "errors": [],
  "warnings": [
    "C02: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "C06: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "C07: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "C08: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "C09: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "C10: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。",
    "当前为程序草稿或部分分析，AI综合整理尚未完成。"
  ],
  "semantic_equivalence_verified": false,
  "execution": "未运行输入项目/测试"
}
```
