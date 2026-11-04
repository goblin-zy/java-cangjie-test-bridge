# 测试具体上下文

查找对象：`spec.CartTest # uncertain()`

完整类保留原文；related_members列出本次已收集的相关成员。其他成员仅为周边参考。

## 查找范围

```json
{
  "source_roots": [
    "checks/src/test/java",
    "core/src/main/java"
  ],
  "resource_roots": [
    "checks/src/test/resources"
  ],
  "fallback_project_scan": false,
  "java_files_indexed": 8,
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


### spec.CartTest

来源：`checks/src/test/java/spec/CartTest.java`，行 10—28

查找原因：完整原测试类型；相关成员另行标记; 完整原测试类型；相关成员另行标记; 完整原始测试类；相关成员另行标记

```java
public class CartTest extends BaseCase {
    private static final String DATA = "/fixtures/price.txt";
    void seed() { TestSupport.check(cart); }
    @Test public void total() throws Exception {
        seed();
        try (InputStream input = TestSupport.data()) { assertNotNull(input); }
        assertEquals(Limits.THREE, cart.total());
    }
    @Test public void constantResource() {
        assertNotNull(getClass().getResourceAsStream(DATA));
    }
    @Test public void uncertain() {
        getClass().getResourceAsStream(System.getProperty("fixture.path"));
        Engine engine = null;
        engine.run();
        Over.check(1);
    }
    @Test public void cyclic() { TestSupport.cycleA(); }
}
```

## 所在类导入


### checks/src/test/java/spec/CartTest.java#import:0

来源：`checks/src/test/java/spec/CartTest.java`，行 2—2

查找原因：来源文件的原始导入

```java
import app.Limits;
```

### checks/src/test/java/spec/CartTest.java#import:1

来源：`checks/src/test/java/spec/CartTest.java`，行 3—3

查找原因：来源文件的原始导入

```java
import app.Engine;
```

### checks/src/test/java/spec/CartTest.java#import:2

来源：`checks/src/test/java/spec/CartTest.java`，行 4—4

查找原因：来源文件的原始导入

```java
import support.BaseCase;
```

### checks/src/test/java/spec/CartTest.java#import:3

来源：`checks/src/test/java/spec/CartTest.java`，行 5—5

查找原因：来源文件的原始导入

```java
import support.TestSupport;
```

### checks/src/test/java/spec/CartTest.java#import:4

来源：`checks/src/test/java/spec/CartTest.java`，行 6—6

查找原因：来源文件的原始导入

```java
import support.Over;
```

### checks/src/test/java/spec/CartTest.java#import:5

来源：`checks/src/test/java/spec/CartTest.java`，行 7—7

查找原因：来源文件的原始导入

```java
import org.junit.jupiter.api.Test;
```

### checks/src/test/java/spec/CartTest.java#import:6

来源：`checks/src/test/java/spec/CartTest.java`，行 8—8

查找原因：来源文件的原始导入

```java
import java.io.InputStream;
```

### checks/src/test/java/spec/CartTest.java#import:7

来源：`checks/src/test/java/spec/CartTest.java`，行 9—9

查找原因：来源文件的原始导入

```java
import static org.junit.jupiter.api.Assertions.*;
```

### checks/src/test/java/support/BaseCase.java#import:0

来源：`checks/src/test/java/support/BaseCase.java`，行 2—2

查找原因：来源文件的原始导入

```java
import app.Cart;
```

### checks/src/test/java/support/BaseCase.java#import:1

来源：`checks/src/test/java/support/BaseCase.java`，行 3—3

查找原因：来源文件的原始导入

```java
import org.junit.jupiter.api.BeforeEach;
```

### checks/src/test/java/support/BaseCase.java#import:2

来源：`checks/src/test/java/support/BaseCase.java`，行 4—4

查找原因：来源文件的原始导入

```java
import org.junit.jupiter.api.AfterEach;
```

## 字段及初始化


### spec.CartTest#field:DATA

来源：`checks/src/test/java/spec/CartTest.java`，行 11—11

查找原因：保留相关类型的字段与初始化；未做字段最小化

```java
private static final String DATA = "/fixtures/price.txt";
```

### support.BaseCase#field:cart

来源：`checks/src/test/java/support/BaseCase.java`，行 6—6

查找原因：保留相关类型的字段与初始化；未做字段最小化

```java
protected Cart cart = new Cart();
```

### app.Cart#field:amount

来源：`core/src/main/java/app/Cart.java`，行 3—3

查找原因：保留相关类型的字段与初始化；未做字段最小化

```java
private int amount = 0;
```

## 相关类型与业务定义


### support.BaseCase

来源：`checks/src/test/java/support/BaseCase.java`，行 5—6

查找原因：相关类型声明头；实际相关字段和方法另外提供

```java
public class BaseCase {
    
```

### app.Cart

来源：`core/src/main/java/app/Cart.java`，行 2—3

查找原因：相关类型声明头；实际相关字段和方法另外提供; 相关类型声明头；实际相关字段和方法另外提供; 相关类型声明头；实际相关字段和方法另外提供

```java
public class Cart {
    
```

### app.Engine

来源：`core/src/main/java/app/Engine.java`，行 2—2

查找原因：相关类型声明头；实际相关字段和方法另外提供

```java
public interface Engine { 
```

### support.Over

来源：`checks/src/test/java/support/Over.java`，行 2—3

查找原因：相关类型声明头；实际相关字段和方法另外提供

```java
public class Over {
    
```

## 初始化与清理


### support.BaseCase#prepare()

来源：`checks/src/test/java/support/BaseCase.java`，行 7—7

查找原因：适用的JUnit生命周期声明: BeforeEach

```java
@BeforeEach public void prepare() { cart.add(2); }
```

### support.BaseCase#clean()

来源：`checks/src/test/java/support/BaseCase.java`，行 8—8

查找原因：适用的JUnit生命周期声明: AfterEach

```java
@AfterEach public void clean() { cart.clear(); }
```

## 目标测试


### spec.CartTest#uncertain()

来源：`checks/src/test/java/spec/CartTest.java`，行 21—26

查找原因：本次查找的目标测试

```java
@Test public void uncertain() {
        getClass().getResourceAsStream(System.getProperty("fixture.path"));
        Engine engine = null;
        engine.run();
        Over.check(1);
    }
```

## 进一步调用依赖


### app.Cart#add(int)

来源：`core/src/main/java/app/Cart.java`，行 4—4

查找原因：调用所需实现；包含其中的断言与进一步调用

```java
public void add(int n) { amount += n; }
```

### app.Cart#clear()

来源：`core/src/main/java/app/Cart.java`，行 6—6

查找原因：调用所需实现；包含其中的断言与进一步调用

```java
public void clear() { amount = 0; }
```

### app.Engine#run()

来源：`core/src/main/java/app/Engine.java`，行 2—2

查找原因：调用所需实现；包含其中的断言与进一步调用

```java
void run();
```

## 相关成员标记

```json
{
  "checks/src/test/java/spec/CartTest.java": [
    "spec.CartTest#field:DATA",
    "spec.CartTest#uncertain()"
  ],
  "checks/src/test/java/support/BaseCase.java": [
    "support.BaseCase#field:cart",
    "support.BaseCase#prepare()",
    "support.BaseCase#clean()"
  ],
  "core/src/main/java/app/Cart.java": [
    "app.Cart#field:amount",
    "app.Cart#add(int)",
    "app.Cart#clear()"
  ],
  "core/src/main/java/app/Engine.java": [
    "app.Engine#run()"
  ]
}
```

## 未解析引用

```json
[
  {
    "kind": "RESOURCE_DYNAMIC_PATH",
    "reference": "getClass().getResourceAsStream",
    "caller": "spec.CartTest#uncertain()",
    "content": "getClass().getResourceAsStream(System.getProperty(\"fixture.path\"))",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 22,
      "end_line": 22,
      "start_offset_utf16": 762,
      "end_offset_utf16_exclusive": 828,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "资源路径不是可确认的字符串字面量或final字段"
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": "getClass().getResourceAsStream",
    "caller": "spec.CartTest#uncertain()",
    "content": "getClass().getResourceAsStream(System.getProperty(\"fixture.path\"))",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 22,
      "end_line": 22,
      "start_offset_utf16": 762,
      "end_offset_utf16_exclusive": 828,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": []
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": ".getClass",
    "caller": "spec.CartTest#uncertain()",
    "content": "getClass()",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 22,
      "end_line": 22,
      "start_offset_utf16": 762,
      "end_offset_utf16_exclusive": 772,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": [
      "spec.CartTest"
    ]
  },
  {
    "kind": "REFERENCE_UNRESOLVED",
    "reference": "System.getProperty",
    "caller": "spec.CartTest#uncertain()",
    "content": "System.getProperty(\"fixture.path\")",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 22,
      "end_line": 22,
      "start_offset_utf16": 793,
      "end_offset_utf16_exclusive": 827,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为",
    "candidates": []
  },
  {
    "kind": "DYNAMIC_IMPLEMENTATION_UNRESOLVED",
    "reference": "engine.run",
    "caller": "spec.CartTest#uncertain()",
    "content": "engine.run()",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 24,
      "end_line": 24,
      "start_offset_utf16": 870,
      "end_offset_utf16_exclusive": 882,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "找到接口或抽象声明，但未确定运行时实现",
    "candidates": [
      "app.Engine#run()"
    ]
  },
  {
    "kind": "OVERLOAD_AMBIGUOUS",
    "reference": "Over.check",
    "caller": "spec.CartTest#uncertain()",
    "content": "Over.check(1)",
    "source": {
      "file": "checks/src/test/java/spec/CartTest.java",
      "start_line": 25,
      "end_line": 25,
      "start_offset_utf16": 893,
      "end_offset_utf16_exclusive": 906,
      "sha256": "2c4c28cf3a6f26ea1e9e796ac59d36bda5e30a6a6ca85d3c65b7d2f1f066a8e0"
    },
    "reason": "仅按接收类型、名称与参数数量查找，无法唯一匹配",
    "candidates": [
      "support.Over#check(int)",
      "support.Over#check(String)"
    ]
  }
]
```

## 停止边界

```json
[
  {
    "kind": "IMPLICIT_DEFAULT_CONSTRUCTOR",
    "reference": "app.Cart",
    "source": {
      "file": "checks/src/test/java/support/BaseCase.java",
      "start_line": 6,
      "end_line": 6,
      "start_offset_utf16": 170,
      "end_offset_utf16_exclusive": 180,
      "sha256": "e93518abb396fefe061ec53dd115aa0b02762f1c6fce345ace9ed43ec9b8b1fb"
    },
    "reason": "无显式构造器，保留类型与字段初始化"
  }
]
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
