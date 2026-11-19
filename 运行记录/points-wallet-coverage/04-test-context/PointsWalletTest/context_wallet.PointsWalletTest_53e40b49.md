# 测试具体上下文

查找对象：`wallet.PointsWalletTest`

完整类保留原文；related_members列出本次已收集的相关成员。其他成员仅为周边参考。

## 查找范围

```json
{
  "source_roots": [
    "src/main/java",
    "src/test/java"
  ],
  "resource_roots": [],
  "fallback_project_scan": false,
  "java_files_indexed": 2,
  "max_depth": 6,
  "max_members": 300,
  "max_resource_bytes": 262144,
  "stop_conditions": [
    "外部定义或无法唯一匹配的引用",
    "依赖循环去重",
    "达到深度、成员或资源大小上限"
  ],
  "analysis": "JDK17 syntax plus conservative project-local lookup; no compiler symbol attribution"
}
```

## 完整原始测试类


### wallet.PointsWalletTest

来源：`src/test/java/wallet/PointsWalletTest.java`，行 9—34

查找原因：完整原测试类型；相关成员另行标记; 完整原测试类型；相关成员另行标记; 完整原测试类型；相关成员另行标记; 完整原测试类型；相关成员另行标记; 完整原始测试类；相关成员另行标记

```java
class PointsWalletTest {
    private PointsWallet wallet;

    private PointsWallet newWallet() {
        return new PointsWallet(100);
    }

    @BeforeEach
    void setup() {
        wallet = newWallet();
    }

    @Test
    void spendsPointsInOrder() {
        assertTrue(wallet.spend(30));
        assertEquals(70, wallet.balance());
        assertTrue(wallet.spend(20));
        assertEquals(50, wallet.balance());
    }

    @Test
    void rejectsOverspending() {
        assertFalse(wallet.spend(150));
        assertEquals(100, wallet.balance());
    }
}
```

## 所在类导入


### src/test/java/wallet/PointsWalletTest.java#import:0

来源：`src/test/java/wallet/PointsWalletTest.java`，行 3—3

查找原因：来源文件的原始导入

```java
import org.junit.jupiter.api.BeforeEach;
```

### src/test/java/wallet/PointsWalletTest.java#import:1

来源：`src/test/java/wallet/PointsWalletTest.java`，行 4—4

查找原因：来源文件的原始导入

```java
import org.junit.jupiter.api.Test;
```

### src/test/java/wallet/PointsWalletTest.java#import:2

来源：`src/test/java/wallet/PointsWalletTest.java`，行 5—5

查找原因：来源文件的原始导入

```java
import static org.junit.jupiter.api.Assertions.assertEquals;
```

### src/test/java/wallet/PointsWalletTest.java#import:3

来源：`src/test/java/wallet/PointsWalletTest.java`，行 6—6

查找原因：来源文件的原始导入

```java
import static org.junit.jupiter.api.Assertions.assertFalse;
```

### src/test/java/wallet/PointsWalletTest.java#import:4

来源：`src/test/java/wallet/PointsWalletTest.java`，行 7—7

查找原因：来源文件的原始导入

```java
import static org.junit.jupiter.api.Assertions.assertTrue;
```

## 字段及初始化


### wallet.PointsWalletTest#field:wallet

来源：`src/test/java/wallet/PointsWalletTest.java`，行 10—10

查找原因：保留相关类型的字段与初始化；未做字段最小化

```java
private PointsWallet wallet;
```

### wallet.PointsWallet#field:points

来源：`src/main/java/wallet/PointsWallet.java`，行 4—4

查找原因：保留相关类型的字段与初始化；未做字段最小化

```java
private int points;
```

## 初始化与清理


### wallet.PointsWalletTest#setup()

来源：`src/test/java/wallet/PointsWalletTest.java`，行 16—19

查找原因：适用的JUnit生命周期声明: BeforeEach

```java
@BeforeEach
    void setup() {
        wallet = newWallet();
    }
```

## 目标测试


### wallet.PointsWalletTest#spendsPointsInOrder()

来源：`src/test/java/wallet/PointsWalletTest.java`，行 21—27

查找原因：本次查找的目标测试

```java
@Test
    void spendsPointsInOrder() {
        assertTrue(wallet.spend(30));
        assertEquals(70, wallet.balance());
        assertTrue(wallet.spend(20));
        assertEquals(50, wallet.balance());
    }
```

### wallet.PointsWalletTest#rejectsOverspending()

来源：`src/test/java/wallet/PointsWalletTest.java`，行 29—33

查找原因：本次查找的目标测试

```java
@Test
    void rejectsOverspending() {
        assertFalse(wallet.spend(150));
        assertEquals(100, wallet.balance());
    }
```

## 辅助逻辑与断言


### wallet.PointsWalletTest#newWallet()

来源：`src/test/java/wallet/PointsWalletTest.java`，行 12—14

查找原因：调用所需实现；包含其中的断言与进一步调用

```java
private PointsWallet newWallet() {
        return new PointsWallet(100);
    }
```

## 相关类型与业务定义


### wallet.PointsWallet

来源：`src/main/java/wallet/PointsWallet.java`，行 3—4

查找原因：相关类型声明头；实际相关字段和方法另外提供; 相关类型声明头；实际相关字段和方法另外提供; 相关类型声明头；实际相关字段和方法另外提供; 相关类型声明头；实际相关字段和方法另外提供

```java
public final class PointsWallet {
    
```

## 进一步调用依赖


### wallet.PointsWallet#spend(int)

来源：`src/main/java/wallet/PointsWallet.java`，行 10—16

查找原因：调用所需实现；包含其中的断言与进一步调用; 调用所需实现；包含其中的断言与进一步调用

```java
public boolean spend(int amount) {
        if (amount > points) {
            return false;
        }
        points -= amount;
        return true;
    }
```

### wallet.PointsWallet#balance()

来源：`src/main/java/wallet/PointsWallet.java`，行 18—20

查找原因：调用所需实现；包含其中的断言与进一步调用; 调用所需实现；包含其中的断言与进一步调用

```java
public int balance() {
        return points;
    }
```

### wallet.PointsWallet#<init>(int)

来源：`src/main/java/wallet/PointsWallet.java`，行 6—8

查找原因：调用所需实现；包含其中的断言与进一步调用

```java
public PointsWallet(int points) {
        this.points = points;
    }
```

## 相关成员标记

```json
{
  "src/test/java/wallet/PointsWalletTest.java": [
    "wallet.PointsWalletTest#field:wallet",
    "wallet.PointsWalletTest#setup()",
    "wallet.PointsWalletTest#spendsPointsInOrder()",
    "wallet.PointsWalletTest#rejectsOverspending()",
    "wallet.PointsWalletTest#newWallet()"
  ],
  "src/main/java/wallet/PointsWallet.java": [
    "wallet.PointsWallet#field:points",
    "wallet.PointsWallet#spend(int)",
    "wallet.PointsWallet#balance()",
    "wallet.PointsWallet#<init>(int)"
  ]
}
```

## 未解析引用

```json
[
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertTrue",
    "caller": "wallet.PointsWalletTest#spendsPointsInOrder()",
    "content": "assertTrue(wallet.spend(30))",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 23,
      "end_line": 23,
      "start_offset_utf16": 540,
      "end_offset_utf16_exclusive": 568,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertEquals",
    "caller": "wallet.PointsWalletTest#spendsPointsInOrder()",
    "content": "assertEquals(70, wallet.balance())",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 24,
      "end_line": 24,
      "start_offset_utf16": 578,
      "end_offset_utf16_exclusive": 612,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertTrue",
    "caller": "wallet.PointsWalletTest#spendsPointsInOrder()",
    "content": "assertTrue(wallet.spend(20))",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 25,
      "end_line": 25,
      "start_offset_utf16": 622,
      "end_offset_utf16_exclusive": 650,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertEquals",
    "caller": "wallet.PointsWalletTest#spendsPointsInOrder()",
    "content": "assertEquals(50, wallet.balance())",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 26,
      "end_line": 26,
      "start_offset_utf16": 660,
      "end_offset_utf16_exclusive": 694,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertFalse",
    "caller": "wallet.PointsWalletTest#rejectsOverspending()",
    "content": "assertFalse(wallet.spend(150))",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 31,
      "end_line": 31,
      "start_offset_utf16": 754,
      "end_offset_utf16_exclusive": 784,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".assertEquals",
    "caller": "wallet.PointsWalletTest#rejectsOverspending()",
    "content": "assertEquals(100, wallet.balance())",
    "source": {
      "file": "src/test/java/wallet/PointsWalletTest.java",
      "start_line": 32,
      "end_line": 32,
      "start_offset_utf16": 794,
      "end_offset_utf16_exclusive": 829,
      "sha256": "9fa15302faf043dc46bf1285e38042d78c70e0c35acf63f7949789c107882ef8"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "wallet.PointsWalletTest"
    ]
  }
]
```

## 停止边界

```json
[]
```

## 工程问题

```json
[]
```

## 限制

- 生命周期仅支持已识别JUnit4/5声明与简单继承，不解释组合注解、扩展注册和接口默认方法
- 重载按名称和参数数量筛选；接口动态实现、链式接收者、反射与动态路径会报告未解析
- 保留完整类型可含无关成员；不把类中所有成员视为本次相关成员
- 不提供跨语言规则、项目翻译约定筛选或完整模型输入组织
- 只读源工程，不执行构建、测试或业务代码
