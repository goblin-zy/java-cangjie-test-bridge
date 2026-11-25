# 初始上下文

翻译整个测试类：测试原文、辅助实现、初始化和相关业务接口。

索引：d9644bed028bb9b4fd5f045017a2733ac5cdeb431b5c4c3dae1c83578225d3cc

源码快照：699b94ead0c53c9687b55ed5cb7c42afd4e316afbd2903c0817a0d32c6c09893

默认先读 agent_context.json；完整证据见同目录 initial_context.json。当前Markdown视图：compact

## p.FourCase

{"id": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069", "status": "CONTENT_INCLUDED", "source": {"file": "src/test/java/p/FourCase.java", "lines": [1, 1]}}

```java
public class FourCase { @Test(expected=IllegalArgumentException.class, timeout=250) public void check() { throw new IllegalArgumentException(); } }
```

## selected_tests

```json
[
  "e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f"
]
```

## test_invocations

```json
[
  {
    "source_member_id": "p/FourCase.java::p.FourCase#check()",
    "declaring_class": "p.FourCase",
    "execution_class": "p.FourCase",
    "selector": "p.FourCase#check()",
    "framework": "junit4",
    "basis": "HASH_CHECKED_SOURCE_NOT_RUNTIME_DISCOVERY",
    "source_member_key": "e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f",
    "execution_type_key": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
    "declaring_type_key": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
    "table": "artifacts/java-members/0-members.json",
    "context_selector": "p.FourCase#check()"
  }
]
```

## imports

```json
[
  {
    "file": "src/test/java/p/FourCase.java",
    "package": "p",
    "imports": [
      {
        "name": "org.junit.Test",
        "static": false
      }
    ]
  }
]
```

## lifecycle

```json
{
  "class_setup": [
    {
      "type": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "setup": [
    {
      "type": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "cleanup": [
    {
      "type": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "class_cleanup": [
    {
      "type": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ]
}
```

## initialization

```json
[]
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
      "member_key": "e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f",
      "display_id": "p.FourCase#check()",
      "top_level_steps": [
        {
          "key": "63a56467f6dd517e939342aa46353ffe1e46580b16e6d6010be31b8b939dd260",
          "ast_kind": "ThrowStmt",
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
      "details_command": "analyze --id e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f"
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
    "kind": "TEST_EXECUTION_SEMANTICS_REQUIRE_REVIEW",
    "member": "e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f",
    "semantics": [
      {
        "framework": "junit4",
        "annotation_arguments": {
          "expected": "IllegalArgumentException.class",
          "timeout": "250"
        },
        "basis": "SOURCE_ANNOTATION_NOT_EXECUTION"
      }
    ]
  }
]
```

## budget

```json
{
  "max_depth": 6,
  "max_members": 200,
  "max_chars": 30000,
  "included_chars": 147,
  "visited_members": 1
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
    "source": "b55311829fcd570ff550c39747e2538be99866eb9677bb05bc72caee6c3a2069",
    "members": [
      {
        "id": "e7302335cf05af7fee28ec563126044f8d32d94d0dee825ba6c854977c70952f",
        "display_id": "p.FourCase#check()"
      }
    ]
  }
]
```

## boundary_counts

```json
{
  "TEST_EXECUTION_SEMANTICS_REQUIRE_REVIEW": 1,
  "EXTERNAL_DECLARATION": 1
}
```

## external_interfaces

```json
[
  "java.lang.IllegalArgumentException.IllegalArgumentException()"
]
```

## bodies_available_on_demand

```json
[]
```

## dependency_counts

```json
{
  "external": 1
}
```
