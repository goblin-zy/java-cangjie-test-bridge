# 初始上下文

翻译指定测试方法：保留所在类及生命周期，展开该方法的辅助依赖。

索引：8f6ff14575ccba66072a4aa3e611c7b6c353d37a057571530070b2f835c0bc95

源码快照：160dd4b594c3facc726a90bdb45564e0945568ea1357d12e2389dd21408ec06a

默认先读 agent_context.json；完整证据见同目录 initial_context.json。当前Markdown视图：compact

## org.ahocorasick.interval.IntervalTest

{"id": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/test/java/org/ahocorasick/interval/IntervalTest.java", "lines": [11, 11]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.IntervalTest#test_construct()

{"id": "c94991bd5f2541c9da9c0412c26f1799f834509448e461d525fce4184e45a6d0", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/test/java/org/ahocorasick/interval/IntervalTest.java", "lines": [13, 18]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval

{"id": "d75098f4ddf78129425577c1428d8a85208abc358c40fbb8274ff2f7e1b77f12", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [10, 10]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval#getStart()

{"id": "b17178369fdc1af090f26ae3239e324a9489c44123d63a3ce0e6c43b9d0a36f3", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [31, 32]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval#getEnd()

{"id": "2cd8efa2c4cf5fe56df74c926fd8a04c044a9f24b8eb273416efb9bc9a572f26", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [41, 42]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval#<init>(int,int)

{"id": "3fb9112731d2f7ba8cdcbfb42d319a0a5e77b690f2a244cd6fa6f07f8a03385f", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [21, 21]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval#field:start

{"id": "ea23eb55391c5c9a5ccb650531a03cc29ed0492ed3854c8d4548bb82718e0cef", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [12, 12]}}

CONTENT_NOT_INCLUDED_BUDGET

## org.ahocorasick.interval.Interval#field:end

{"id": "8c7e7718997d1d9635093bf764c832f1cf1bbf4f924b34dada7e1fe88f7c5321", "status": "CONTENT_NOT_INCLUDED_BUDGET", "source": {"file": "src/main/java/org/ahocorasick/interval/Interval.java", "lines": [13, 13]}}

CONTENT_NOT_INCLUDED_BUDGET

## selected_tests

```json
[
  "c94991bd5f2541c9da9c0412c26f1799f834509448e461d525fce4184e45a6d0"
]
```

## imports

```json
[
  {
    "file": "src/test/java/org/ahocorasick/interval/IntervalTest.java",
    "package": "org.ahocorasick.interval",
    "imports": [
      {
        "name": "org.junit.Test",
        "static": false
      },
      {
        "name": "java.util.Iterator",
        "static": false
      },
      {
        "name": "java.util.Set",
        "static": false
      },
      {
        "name": "java.util.TreeSet",
        "static": false
      },
      {
        "name": "org.junit.Assert.*",
        "static": true
      }
    ]
  },
  {
    "file": "src/main/java/org/ahocorasick/interval/Interval.java",
    "package": "org.ahocorasick.interval",
    "imports": [
      {
        "name": "org.ahocorasick.trie.Emit",
        "static": false
      },
      {
        "name": "org.ahocorasick.trie.PayloadEmit",
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
      "type": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "setup": [
    {
      "type": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "cleanup": [
    {
      "type": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5",
      "members": [],
      "within_type_order": "NOT_ESTABLISHED"
    }
  ],
  "class_cleanup": [
    {
      "type": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5",
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
      "member_key": "8c7e7718997d1d9635093bf764c832f1cf1bbf4f924b34dada7e1fe88f7c5321",
      "display_id": "org.ahocorasick.interval.Interval#field:end",
      "top_level_steps": [],
      "remaining_steps": 0,
      "recognized_checks": 0,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id 8c7e7718997d1d9635093bf764c832f1cf1bbf4f924b34dada7e1fe88f7c5321"
    },
    {
      "member_key": "c94991bd5f2541c9da9c0412c26f1799f834509448e461d525fce4184e45a6d0",
      "display_id": "org.ahocorasick.interval.IntervalTest#test_construct()",
      "top_level_steps": [
        {
          "key": "391de62c4821a232f9f3db8e136866f7f8acd181b3529595aed3de2bf252776a",
          "ast_kind": "ExpressionStmt",
          "lines": [
            15,
            15
          ]
        },
        {
          "key": "522c81bb9d0bbbb470c7ef7356dd6c3e53643e02d014f0c4dd4d8fbfd668e035",
          "ast_kind": "ExpressionStmt",
          "lines": [
            16,
            16
          ]
        },
        {
          "key": "6d45d00abfe089557a0272a22e39590db8fe99d43c5fdceebfa6ffbde81c50e7",
          "ast_kind": "ExpressionStmt",
          "lines": [
            17,
            17
          ]
        }
      ],
      "remaining_steps": 0,
      "recognized_checks": 2,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id c94991bd5f2541c9da9c0412c26f1799f834509448e461d525fce4184e45a6d0"
    },
    {
      "member_key": "ea23eb55391c5c9a5ccb650531a03cc29ed0492ed3854c8d4548bb82718e0cef",
      "display_id": "org.ahocorasick.interval.Interval#field:start",
      "top_level_steps": [],
      "remaining_steps": 0,
      "recognized_checks": 0,
      "assertion_candidates": 0,
      "deferred_checks": 0,
      "details_command": "analyze --id ea23eb55391c5c9a5ccb650531a03cc29ed0492ed3854c8d4548bb82718e0cef"
    }
  ],
  "ordering": "SOURCE_ORDER_ONLY_NOT_RUNTIME_TRACE",
  "cross_member_behavior": "FOLLOW_REFERENCES_NOT_INLINE_EXECUTION_TRACE",
  "details": "Use analyze for checks/guards and references for helper targets; shared records remain in shared_ref."
}
```

## unresolved

```json
[
  {
    "reference_key": "01f7de6c9a00603e76b7b39d1e70637e2c0f6a94a3122be323daed337b294fb2",
    "resolution": "unresolved",
    "file": "src/test/java/org/ahocorasick/interval/IntervalTest.java",
    "line": 16,
    "name": "assertEquals",
    "candidate_count": 0,
    "reason_summary": "UnsolvedSymbolException: Unsolved symbol : org.junit.Assert",
    "reason_abbreviated": false,
    "full_evidence_pointer": "/unresolved/0"
  },
  {
    "reference_key": "e85c9b91848bcf2a9db8b8e5ab91e38d617e9a7f766cae42ffb7b42904a11221",
    "resolution": "unresolved",
    "file": "src/test/java/org/ahocorasick/interval/IntervalTest.java",
    "line": 17,
    "name": "assertEquals",
    "candidate_count": 0,
    "reason_summary": "UnsolvedSymbolException: Unsolved symbol : org.junit.Assert",
    "reason_abbreviated": false,
    "full_evidence_pointer": "/unresolved/1"
  }
]
```

## required_not_included

```json
[
  {
    "id": "f8752fd88a26aedb0a35639b230657fb56c4bc15b08c8932355afeef5cef7ee5",
    "mode": "signature",
    "reason": "CHAR_BUDGET",
    "required_chars": 27
  },
  {
    "id": "c94991bd5f2541c9da9c0412c26f1799f834509448e461d525fce4184e45a6d0",
    "mode": "full",
    "reason": "CHAR_BUDGET",
    "required_chars": 169
  },
  {
    "id": "d75098f4ddf78129425577c1428d8a85208abc358c40fbb8274ff2f7e1b77f12",
    "mode": "signature",
    "reason": "CHAR_BUDGET",
    "required_chars": 47
  },
  {
    "id": "b17178369fdc1af090f26ae3239e324a9489c44123d63a3ce0e6c43b9d0a36f3",
    "mode": "signature",
    "reason": "CHAR_BUDGET",
    "required_chars": 36
  },
  {
    "id": "2cd8efa2c4cf5fe56df74c926fd8a04c044a9f24b8eb273416efb9bc9a572f26",
    "mode": "signature",
    "reason": "CHAR_BUDGET",
    "required_chars": 34
  },
  {
    "id": "3fb9112731d2f7ba8cdcbfb42d319a0a5e77b690f2a244cd6fa6f07f8a03385f",
    "mode": "signature",
    "reason": "CHAR_BUDGET",
    "required_chars": 48
  },
  {
    "id": "ea23eb55391c5c9a5ccb650531a03cc29ed0492ed3854c8d4548bb82718e0cef",
    "mode": "full",
    "reason": "CHAR_BUDGET",
    "required_chars": 24
  },
  {
    "id": "8c7e7718997d1d9635093bf764c832f1cf1bbf4f924b34dada7e1fe88f7c5321",
    "mode": "full",
    "reason": "CHAR_BUDGET",
    "required_chars": 22
  }
]
```

## boundaries

```json
[]
```

## budget

```json
{
  "max_depth": 6,
  "max_members": 200,
  "max_chars": 0,
  "included_chars": 0,
  "visited_members": 6
}
```

## input_issues

```json
{
  "DEPENDENCIES_NOT_RESOLVED": 1
}
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
[]
```

## boundary_counts

```json
{
  "BODY_AVAILABLE_ON_DEMAND": 3
}
```

## external_interfaces

```json
[]
```

## bodies_available_on_demand

```json
[
  "2cd8efa2c4cf5fe56df74c926fd8a04c044a9f24b8eb273416efb9bc9a572f26",
  "3fb9112731d2f7ba8cdcbfb42d319a0a5e77b690f2a244cd6fa6f07f8a03385f",
  "b17178369fdc1af090f26ae3239e324a9489c44123d63a3ce0e6c43b9d0a36f3"
]
```

## dependency_counts

```json
{
  "unresolved": 2,
  "resolved_static": 3
}
```
