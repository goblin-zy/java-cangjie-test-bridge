# 初始上下文

翻译整个测试类：测试原文、辅助实现、初始化和相关业务接口。

索引：d9644bed028bb9b4fd5f045017a2733ac5cdeb431b5c4c3dae1c83578225d3cc

源码快照：699b94ead0c53c9687b55ed5cb7c42afd4e316afbd2903c0817a0d32c6c09893

默认先读 agent_context.json；完整证据见同目录 initial_context.json。当前Markdown视图：compact

## p.ChildCase

{"id": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/ChildCase.java", "lines": [1, 1]}}

```java
public class ChildCase extends BaseCase { public void testOwn() { assert value>0; } }
```

## p.BaseCase

{"id": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/BaseCase.java", "lines": [1, 1]}}

```java
public abstract class BaseCase extends TestCase {
```

## p.BaseCase#field:value

{"id": "397b3aff2bd34ca1e205923c1e8d2dd15e57567862e1fdfcf2a15a517a9f8ae1", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/BaseCase.java", "lines": [1, 1]}}

```java
protected int value=1;
```

## p.BaseCase#setUp()

{"id": "bd30d1dfd30af4272eb4454efd7d3e580e5d0c44af26882b0f38ef74a996e110", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/BaseCase.java", "lines": [1, 1]}}

```java
protected void setUp() { value=2; }
```

## p.BaseCase#testFromBase()

{"id": "9c74b46a9b5016de0275d399ed4cb920da57e94d42d955e0205c586a543728b9", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/BaseCase.java", "lines": [1, 1]}}

```java
public void testFromBase() { assert value==2; }
```

## selected_tests

```json
[
  "f15efbb4ec332d0d65b7abdb163b4a4e6730d5747ac1e633e62cf05a1dd1ebe1",
  "9c74b46a9b5016de0275d399ed4cb920da57e94d42d955e0205c586a543728b9"
]
```

## test_invocations

```json
[
  {
    "source_member_id": "p/ChildCase.java::p.ChildCase#testOwn()",
    "declaring_class": "p.ChildCase",
    "execution_class": "p.ChildCase",
    "selector": "p.ChildCase#testOwn()",
    "framework": "junit3",
    "basis": "HASH_CHECKED_SOURCE_NOT_RUNTIME_DISCOVERY",
    "source_member_key": "f15efbb4ec332d0d65b7abdb163b4a4e6730d5747ac1e633e62cf05a1dd1ebe1",
    "execution_type_key": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
    "declaring_type_key": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
    "table": "artifacts/java-members/0-members.json",
    "context_selector": "p.ChildCase#testOwn()"
  },
  {
    "source_member_id": "p/BaseCase.java::p.BaseCase#testFromBase()",
    "declaring_class": "p.BaseCase",
    "execution_class": "p.ChildCase",
    "selector": "p.ChildCase#testFromBase()",
    "framework": "junit3",
    "basis": "HASH_CHECKED_SOURCE_NOT_RUNTIME_DISCOVERY",
    "source_member_key": "9c74b46a9b5016de0275d399ed4cb920da57e94d42d955e0205c586a543728b9",
    "execution_type_key": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
    "declaring_type_key": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
    "table": "artifacts/java-members/0-members.json",
    "context_selector": "p.ChildCase#testFromBase()"
  }
]
```

## imports

```json
[
  {
    "file": "src/test/java/p/BaseCase.java",
    "package": "p",
    "imports": [
      {
        "name": "junit.framework.TestCase",
        "static": false
      }
    ]
  },
  {
    "file": "src/test/java/p/ChildCase.java",
    "package": "p",
    "imports": []
  }
]
```

## lifecycle

```json
{
  "class_setup": [
    {
      "type": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    },
    {
      "type": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "setup": [
    {
      "type": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
      "members": [
        "bd30d1dfd30af4272eb4454efd7d3e580e5d0c44af26882b0f38ef74a996e110"
      ],
      "within_type_order": "NOT_ESTABLISHED"
    },
    {
      "type": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "cleanup": [
    {
      "type": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    },
    {
      "type": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "class_cleanup": [
    {
      "type": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    },
    {
      "type": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ]
}
```

## initialization

```json
[
  {
    "key": "397b3aff2bd34ca1e205923c1e8d2dd15e57567862e1fdfcf2a15a517a9f8ae1",
    "owner_type_key": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
    "kind": "field",
    "start": 108,
    "modifiers": [
      "protected"
    ]
  }
]
```

## resources

```json
[]
```

## test_structure

```json
{
  "schema_version": "member-internal-analysis-1.0",
  "capabilities": {
    "statement_structure": true,
    "assertion_evidence": true,
    "compatibility_feature_detection": true,
    "source_transformation": "UNSUPPORTED",
    "executable_test_prefix_generation": "UNSUPPORTED",
    "runtime_control_flow": "NOT_ESTABLISHED",
    "operation_assertion_causality": "NOT_ESTABLISHED"
  },
  "members": [
    {
      "member_key": "397b3aff2bd34ca1e205923c1e8d2dd15e57567862e1fdfcf2a15a517a9f8ae1",
      "display_id": "p.BaseCase#field:value",
      "top_level_steps": [],
      "remaining_steps": 0,
      "recognized_checks": 0,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id 397b3aff2bd34ca1e205923c1e8d2dd15e57567862e1fdfcf2a15a517a9f8ae1"
    },
    {
      "member_key": "9c74b46a9b5016de0275d399ed4cb920da57e94d42d955e0205c586a543728b9",
      "display_id": "p.BaseCase#testFromBase()",
      "top_level_steps": [
        {
          "key": "d7835931deb2ad4aba963e6fdcc77722b9eaab60a99856f2c26d2e0c3b0065a0",
          "ast_kind": "AssertStmt",
          "lines": [
            1,
            1
          ]
        }
      ],
      "remaining_steps": 0,
      "recognized_checks": 1,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id 9c74b46a9b5016de0275d399ed4cb920da57e94d42d955e0205c586a543728b9"
    },
    {
      "member_key": "bd30d1dfd30af4272eb4454efd7d3e580e5d0c44af26882b0f38ef74a996e110",
      "display_id": "p.BaseCase#setUp()",
      "top_level_steps": [
        {
          "key": "2767b3a0710c53da546a80c58278b1d81c63dab9bcea5669ad7a7d2395a91f75",
          "ast_kind": "ExpressionStmt",
          "lines": [
            1,
            1
          ]
        }
      ],
      "remaining_steps": 0,
      "recognized_checks": 0,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id bd30d1dfd30af4272eb4454efd7d3e580e5d0c44af26882b0f38ef74a996e110"
    },
    {
      "member_key": "f15efbb4ec332d0d65b7abdb163b4a4e6730d5747ac1e633e62cf05a1dd1ebe1",
      "display_id": "p.ChildCase#testOwn()",
      "top_level_steps": [
        {
          "key": "9f8d46febc0bed7c167c0fcec6fd88c042b6704269d2ca18f0f025260858b5c6",
          "ast_kind": "AssertStmt",
          "lines": [
            1,
            1
          ]
        }
      ],
      "remaining_steps": 0,
      "recognized_checks": 1,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id f15efbb4ec332d0d65b7abdb163b4a4e6730d5747ac1e633e62cf05a1dd1ebe1"
    }
  ],
  "ordering": "SOURCE_ORDER_ONLY_NOT_RUNTIME_TRACE",
  "cross_member_behavior": "FOLLOW_REFERENCES_NOT_INLINE_EXECUTION_TRACE",
  "details": "Use analyze for checks/guards and references for helper targets; shared records remain in shared_ref."
}
```

## unresolved

```json
[]
```

## required_not_included

```json
[]
```

## boundaries

```json
[
  {
    "kind": "PARENT_NOT_BOUND",
    "type": "c2be7d415c2a219ca4824dc8a59f79a3ad5720bd7b312a6e2ede4fd3006ca350",
    "candidates": []
  }
]
```

## budget

```json
{
  "max_depth": 6,
  "max_members": 200,
  "max_chars": 30000,
  "included_chars": 238,
  "visited_members": 4
}
```

## input_issues

```json
{}
```

## semantic_problems

```json
[]
```

## semantic_completeness

```json
"NOT_ESTABLISHED"
```

## artifacts

```json
{}
```

## limitations

```json
[
  "static declared targets, not runtime dispatch",
  "JUnit roles supported by source imports, not runtime discovery",
  "missing external JARs remain unresolved",
  "data providers and extensions require explicit review",
  "Initialization is source order evidence, not a runtime execution trace.",
  "Lifecycle ordering assumes ordinary JUnit inheritance; extensions, nested/enclosing instances and providers need review.",
  "Only resolved call/field edges are expanded; type-use and reflection dependencies may require queries."
]
```

## covered_by_source

```json
[
  {
    "source": "008bb86c7dd9ea267cf88900fec7168562c6256d20e87ab5c627dfe6ebee18c3",
    "members": [
      {
        "id": "f15efbb4ec332d0d65b7abdb163b4a4e6730d5747ac1e633e62cf05a1dd1ebe1",
        "display_id": "p.ChildCase#testOwn()"
      }
    ]
  }
]
```

## boundary_counts

```json
{
  "PARENT_NOT_BOUND": 1
}
```

## external_interfaces

```json
[]
```

## bodies_available_on_demand

```json
[]
```

## dependency_counts

```json
{
  "resolved_static": 3
}
```
