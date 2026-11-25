# 运行与使用

需要 Python 3.10 或更高版本，仅使用标准库。模型部分需要能够创建两个独立会话的 Agent。程序负责读取和验证文件，模型负责写注释、比较、回查及报告正文。程序本身不调用云端模型，也无需配置 API 密钥。

## 用 Agent 开始新一轮

打开 [验证总控提示词](prompts/验证总控提示词.md)，将以下内容交给 Agent。验证输出位置需为尚未创建的目录。下例从两条测试开始，目标接口约定留空。

```text
按《验证总控提示词》启动测试翻译静态验证。
翻译结果目录：D:\program_study\yrys\Translation-all\output\points-wallet-coverage
验证路线：整体翻译（whole）
验证范围：本轮全部选定测试
目标接口约定文件：
验证输出位置：<本分支根目录>\runs\points-wallet-whole-02
```

选 `fragment` 可检查片段装配后的最终测试。每轮处理一个 Java 测试文件及一个目标文件。可重复传 `--test` 按方法名或源成员编号缩小范围。项目迁移后可传 `--project-root` 指向 Java 原项目；翻译结果中记录的其他外部材料路径也需对应当前环境。

## 程序与模型怎样配合

在 PowerShell 进入本目录。以下命令构成一次完整流程，中间明确标出了需要模型产生的文件。示例中使用的提交字段可直接参照 [实际运行](../../../运行记录/静态验证/points-wallet-whole/process)。新一轮分析需要生成与本轮材料相符的提交。

```powershell
$translation = '../../../样例材料/静态验证钱包/Translation-all/output/points-wallet-coverage'
$run = '../../../本地运行/points-wallet-whole-02'
$process = Join-Path $run 'process'
python -B verify_tool.py init --translation $translation --route whole --run $run
```

**第一步：核对范围。** `source_scope.json` 列出源测试，`alignment.json` 记录每条在两侧的位置以及输入指纹。对目标位置不唯一的单元，按 [定位提示词](prompts/第一步-翻译单元对齐.md) 提交源目标对应理由与完整目标方法引文，在开始标注前执行 `resolve --run … --input …`。证据不足可保留定位受阻。Java 原文版本变化时，默认全量运行要求先刷新成员表，以免漏掉新增加的测试。

**第二步：独立标注。** 总控用 `side-input` 取本侧任务清单，加 `--index 0` 可取本侧源码，其余序号按清单选取。分别给两个没有聊天历史的会话发送本侧内容；有条件时禁用它们的文件工具，仅回收生成的 JSON。程序提供白名单取材入口，独立会话与工具权限由宿主 Agent 配置。混合的项目材料与接口约定放到联合比较阶段使用。

```powershell
python -B verify_tool.py side-input --run $run --side java
python -B verify_tool.py side-input --run $run --side cangjie --index 0
# 按单侧提示词保存 annotations_java.json、context_java.json 及仓颉对应文件后执行
python -B verify_tool.py annotate --run $run --side java
python -B verify_tool.py annotate --run $run --side cangjie
```

**第三步：比较并回查。** `compare` 生成各测试的材料包。模型核实原文，为每项判断写明类型、状态、两侧片段、原因和必要的回查说明。允许一处 Java 表达式对应多处仓颉代码。修改过的注释会改变材料指纹，需要对新材料重新提交；修订已有结果要给出 `revision_reason`。

```powershell
python -B verify_tool.py compare --run $run
$compare = Join-Path $process '03-comparison'
# 模型在该目录写好本次 submission_U01.json、submission_U02.json 后执行
python -B verify_tool.py submit --run $run --input "$compare/submission_U01.json"
python -B verify_tool.py submit --run $run --input "$compare/submission_U02.json"
```

**第四、五步：清点、汇总并交付。** `audit` 从原始源清单清点。如果有可定位但漏做的测试，补做后再汇总。模型写下是否需要类级补查及其依据；若已经比较的测试仍受类级未知影响，应在其结果中提交 `class_review: true` 且状态为“信息不足”的对应检查项。程序汇总后由模型据实撰写 `narrative.md`，生成最终报告。一次运行由一个总控顺序提交；交付后重新分析须新建运行目录。

```powershell
python -B verify_tool.py audit --run $run
$decision = Join-Path $process '04-audit/class_review.json'
$narrative = Join-Path $process '05-report/narrative.md'
python -B verify_tool.py summary --run $run --decision $decision
python -B verify_tool.py deliver --run $run --decision $decision --narrative $narrative
```

退出码 0 表示命令完成，1 表示输入、版本、引文或其他检查未满足，2 在 `audit` 中表示发现漏做（命令参数错误也会返回 2）。交付包包含 `report.md`、`report.json` 和两份带注释的源码。结构化报告的 `evidence` 中同时保留原始行号、标注后的行号与引文，便于人或模型复核。

## 目标接口约定可缺省

- **未提供、指定路径无效、文件为空或无法按 UTF-8 读取。** 第一阶段登记 `contract.status=missing`，带着此状态继续。参数数值、同一对象、断言条件、检查次数与顺序等仍可逐项判断。
- **判断依赖目标业务语义。** 提交为 `kind=interface`。缺约定时程序只接受“信息不足”，并要求记录查过的源码、仍缺哪项依据。模型须主动识别业务依赖；完全没有业务接口的测试可以填写 `no_interface_reason`。程序无法单凭片段编号发现模型把判断分错类。
- **上游日后产出约定。** 初始化时加 `--contract '目标接口约定.md'`，也可用 UTF-8 JSON。程序复制原文件并记录 SHA-256，将状态标为 `assumed`。联合比较时逐项判断构造参数、单位、返回值、异常等；要据此确认一致或差异，提交 `contract_reference.quote`（快照中的原文）及 `contract_reference.assumption`（所依赖的假设）。文件存在且未覆盖本次调用时，仍应记信息不足。引用校验能确认原文存在，条目是否真的支持该判断由模型说明。
- **汇总不会抹掉其他结论。** 例如译文把期望余额 70 改为 80，源码差异可以直接成立，同时保留接口语义未知。目标约定日后更新时，另起一轮，保留旧版报告和快照以便比较。

## 适用范围与核查

以 Translation-all 的现有输出结构、常规带花括号的方法声明、UTF-8 源码为第一版范围。源码标注采用插入整行注释的方式，保留原有缩进和语句；遇到不能安全处理的原始字符串、转义或不明定位会报告原因。复杂语法、模型漏注语义、结论是否有说服力仍需人工或模型回查。历史 Java 覆盖可辅助定位，测试执行与验证器准确率需要另行评测。

```powershell
python -B -m unittest discover -s tests -v
```

回归检查使用临时副本，输入为仓库内的钱包运行记录与样例材料/静态验证钱包/Translation-all，无需相邻的个人目录。



第二版上下文与 week12 骨架的准备入口见 [集成使用说明](../README.md)。先用 prepare_static_validation.py 组织整体任务和最终译文，再按本页五步进行。
