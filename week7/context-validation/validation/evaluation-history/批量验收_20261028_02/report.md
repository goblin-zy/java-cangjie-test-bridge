# 可执行性评价汇总

组合数：13。编译成功：11/12。

| 组合 | 状态 | 预期 | 发现 | 执行 | 通过 | 失败 | 错误 | 跳过 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| normal_account | PASSED | 2 | 2 | 2 | 2 | 0 | 0 | 0 |
| assertion_failure | ASSERTION_FAILED | 2 | 2 | 2 | 1 | 1 | 0 | 0 |
| runtime_error | TEST_ERROR | 1 | 1 | 1 | 0 | 0 | 1 | 0 |
| compile_failure | COMPILE_FAILED | 1 | 未取得 | 未取得 | 未取得 | 未取得 | 未取得 | 未取得 |
| no_tests | NO_TESTS_FOUND | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| skipped | ZERO_TESTS_EXECUTED | 1 | 1 | 0 | 0 | 0 | 0 | 1 |
| partial_filter | TEST_SET_MISMATCH | 2 | 2 | 1 | 1 | 0 | 0 | 1 |
| all_filtered | ZERO_TESTS_EXECUTED | 2 | 2 | 0 | 0 | 0 | 0 | 2 |
| wrong_expected_name | TEST_SET_MISMATCH | 1 | 2 | 2 | 2 | 0 | 0 | 0 |
| missing_source | INVALID_INPUT | 2 | 未取得 | 未取得 | 未取得 | 未取得 | 未取得 | 未取得 |
| count_only | PASSED | 2 | 2 | 2 | 2 | 0 | 0 | 0 |
| another_sample | PASSED | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
| timeout | RUN_TIMEOUT | 1 | 1 | 未取得 | 未取得 | 未取得 | 未取得 | 未取得 |

JSON为详细记录，CSV及本报告由同一结果生成。所有输入代码保持只读，快照及完整分阶段日志保存在各组合目录。

退出码0仅在所有组合均PASSED时返回。诊断批次故意包含失败，退出码1是预期现象。
