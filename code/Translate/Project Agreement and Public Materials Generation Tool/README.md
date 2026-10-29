# 项目约定与公共材料生成工具

这是为 **Java测试翻译成仓颉测试** 准备资料的工具。它把项目里的接口、对应候选、公共代码、配置和已有约定整理成带出处的材料，帮助后续翻译接入现有仓颉代码。

**使用方式：你向Codex提出一次任务，Codex调用本地程序并完成分析。无需另外接模型API，也不用在程序与聊天之间反复复制材料。**

> 当前交付是第一版代码。本阶段未编写/运行自动化测试，未运行Java／仓颉样例测试，也未做翻译效果或性能评测。Python语法/导入与帮助入口、Java助手构建的实际记录见 docs/IMPLEMENTATION.md。仓颉SDK在本机未找到，仓颉助手未构建、未运行；不要将“源码已提供”理解为“整套能力已验证”。

## 1. 程序和Codex各做什么

| 部分 | 负责什么 |
|---|---|
| Python主程序 | 筛选文件、保存快照、索引成员、记录调用、生成两侧候选、读取配置、查询证据、检查并保存结果 |
| Java解析助手 | 使用JavaParser与SymbolSolver识别声明，解析能力范围内的调用/字段关系 |
| 仓颉解析助手 | 使用官方std.ast读取语法树；Python按1.2版dump协议整理声明。未实现仓颉类型和跨文件调用绑定 |
| Codex与固定提示词 | 结合实现和文档判断候选、整理业务约定、判断公共材料范围、记录缺失与冲突 |

“快照”就是本次读取文件的保存副本。后续引用使用同一副本，避免原文件改变后引文对不上。输入项目只读，解析助手也读取工具生成的副本，不运行被分析程序。

**目标端可以没有测试，只有仓颉业务代码。** 生成仓颉测试是后续翻译环节，本工具不代替它，也不代替通用规则库或逐测试上下文收集器。

## 2. 使用前准备

需要：

1. Python 3.11或以上。
2. JDK 17：既有java，也有javac；配置时填写真实安装路径。
3. 若需程序提取仓颉结构，准备能运行的仓颉SDK 1.2.0。不要为本工具擅自修补SDK。
4. 一个具备文件、命令操作能力的Codex会话。
5. 本地Java业务/测试、已有仓颉业务，以及必要文档和构建配置。

进入工具目录。下面所有命令都在该目录运行，带空格的路径必须加引号：

~~~powershell
Set-Location 'D:\program_study\sc\yrys\一人一事\Translate\Project Agreement and Public Materials Generation Tool'
~~~

推荐在工具自己的虚拟环境安装Python依赖，不改系统环境：

~~~powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
~~~

后续示例用 `python` 简写；如未激活虚拟环境，把它替换为 `.\.venv\Scripts\python.exe`。也可使用已经有对应依赖的Python。固定依赖为Pydantic 2.10.3。

### 构建解析助手

Java助手的首次构建会从Maven Central下载固定版本JAR到本工具的 `.build/java/lib`，校验下载文件并保存SHA-256清单，不执行输入项目：

~~~powershell
python scripts/build_adapters.py --java --javac 'C:\Program Files\Java\jdk-17\bin\javac.exe'
~~~

没有Maven也可以使用此命令。以后离线重新构建可增加 `--offline`。Java依赖固定在脚本中；助手源码改变后需要重新构建。

仓颉助手需要先按SDK说明准备运行环境，再执行：

~~~powershell
python scripts/build_adapters.py --cangjie --cjc 'D:\你的仓颉SDK\bin\cjc.exe'
~~~

该仓颉命令是使用示例，本次未执行。默认产物为 `.build/cangjie/ast_dump.exe`；也可在项目配置中指定已有助手的完整路径。

若找不到SDK，其他模块仍可整理；仓颉文件会记录解析失败。**默认不把未完整分类的目标源码交给AI**，避免未知文件名的参考测试被误纳入。确认输入确实只有允许分析的业务代码后，才可显式设置 `allow_unparsed_target_evidence: true` 并新建扫描；这是有记录的放行，不代表结构提取成功。

## 3. 准备输入配置

运行以下命令，生成一份待填写配置：

~~~powershell
python pmtool.py init --output project_config.json
~~~

用编辑器打开，填写真实路径。没有某类输入时，删除整个对应来源项，不保留假路径。可参考 `examples/account.project.json`，其中的 `D:/work/...` 必须换成你的实际位置。

每个来源的主要字段：

| 字段 | 怎样填写 |
|---|---|
| name | 唯一的英文简称，如java_business；它会成为文件ID的一部分 |
| path | 文件或目录；推荐用带正斜杠的绝对路径 |
| language | java、cangjie或documents |
| role | business业务、test测试、mixed混合、documentation文档 |
| include / exclude | 包含/排除的相对路径规则，例如 `**/*.java`、`**/src/test/**` |
| encoding | 默认utf-8-sig；其他编码需明确指定，保存的解析副本会统一为UTF-8 |

其他重要配置：

- `output_dir`：本次扫描输出目录。每次新扫描用新目录，不能覆盖旧索引。
- `allow_target_tests`：默认false。按测试文件名、来源角色和可识别的测试宏排除目标参考测试。只有实验明确允许时才开启。
- `allow_unparsed_target_evidence`：默认false，控制未完整分类目标代码的正文是否可以作为AI证据。
- `max_file_bytes`：默认单文件3MB，超出会记录跳过，不静默当作已读取。
- `parsers.java / javac / cjc`：可执行程序名或完整路径。
- `parsers.java_source_roots`：Java源码包路径的起点，如 `.../src/main/java`，不是某个具体包目录。
- `parsers.java_classpath`：已存在的依赖JAR完整路径。JUnit等依赖缺失时相关引用可能无法解析；工具不自动执行Maven或Gradle下载输入项目依赖。
- `parsers.java_language_level`：默认JAVA_17。
- `parsers.timeout_seconds`：解析助手调用的超时秒数。

**相对路径按配置文件所在目录解释，不按当前终端目录解释。** 多个来源不要重复包含同一个文件；重叠会明确报错。root目录名、相邻构建描述文件用于模块分组；不是完整的Maven/Gradle模块解析。

Java解析助手只读取本次已收集源码的隔离副本。java_source_roots用于这些副本的包查找，不会擅自读取被排除的Java源码依赖；需要的外部源码应明确纳入sources。声明提取保存显式修饰符，隐含访问规则仍需结合语言版本核对。

## 4. 最方便的使用方式：给Codex一次完整指令

复制下面内容，替换配置路径：

> 请阅读本工具README.md和prompts/WORKFLOW.md，使用已填写的project_config.json生成项目约定与公共材料。请由你运行所需命令、读取所有相关证据分片、按prompts/ANALYSIS.md整理并保存结果，不让我复制中间材料。目标端可以没有测试，默认排除目标参考测试。依据schema区分直接事实、文档声明、候选和分析推断；每项保留来源与状态。遇到环境缺失、解析失败和证据不足时如实记录。使用新的输出目录，保留人工修改，不运行输入项目或测试。

Codex通常依次完成：检查环境 → 扫描 → 程序草稿 → 分模块证据包 → AI贡献 → 合并与来源检查 → 最终导出。

不必安装全局Skill或接入API。根目录AGENTS.md会指向项目内工作流；即使不依赖自动发现，也可像上面那样明确要求读取工作流文件。

## 5. 命令分别做什么

以下是**未执行的使用示例**，不是本次运行记录。它们展示一条完整流程；实际输出内容只有执行后才能得到。

### 5.1 检查环境和扫描

~~~powershell
python pmtool.py doctor --config project_config.json
python pmtool.py scan --config project_config.json
~~~

doctor只检查工具路径和构建产物，不证明解析可用。scan收集快照、解析、建立SQLite索引和候选，不运行业务代码。

scan退出码为0只表示扫描记录完成，不表示所有文件解析成功；必须同时检查scan.json中的状态数量和issues。

假设配置的output_dir是outputs/run-001，会生成：

~~~text
outputs/run-001/
  scan.json              本次范围、版本、哈希、数量和状态
  index.sqlite           完整快照、成员、引用、事实、候选和问题
  parser_artifacts/      解析任务、隔离副本和必要的原始解析输出
~~~

出现parse_failure时先看问题，不能据此认定目标没有某个接口。

### 5.2 查找成员和读取源码

~~~powershell
python pmtool.py query --index outputs/run-001/index.sqlite --table members --name withdraw
python pmtool.py query --index outputs/run-001/index.sqlite --table issues
python pmtool.py query --index outputs/run-001/index.sqlite --table candidates
~~~

query默认每页100条，返回total及next_offset。还有内容时继续指定 `--offset 100` 等；不能只读第一页就声称全部检查。

把下面占位项换成query返回的真实ID：

~~~powershell
python pmtool.py show --index outputs/run-001/index.sqlite --member '这里填真实成员ID'
python pmtool.py show --index outputs/run-001/index.sqlite --file-id '这里填真实文件ID' --start 1 --end 30
~~~

show读取快照，包含真实行号。完整成员ID能区分所属类和重载；不要只凭方法名选中某个成员。被隔离目标文件不允许通过show绕过默认范围。

### 5.3 生成草稿和证据包

~~~powershell
python pmtool.py draft --index outputs/run-001/index.sqlite --output outputs/run-001/draft.json
python pmtool.py packet --index outputs/run-001/index.sqlite --output outputs/run-001/packets
~~~

draft生成实际结构事实、配置声明和待核对候选，阶段是program_draft，**还没有完成AI分析**。

packet把资料分成多个JSON文件，manifest.json记录所有分片、模块、文件和覆盖范围。Codex需要逐片读取。大项目可用 `--module '实际模块ID'` 分批导出，跨模块缺少定义时继续query/show。

`--max-chars` 默认70000，单位是紧凑JSON字符数，不是模型token。源码按行分片，不静默丢弃；单行或单条结构记录过大时明确失败，需调高预算或缩小模块范围，并使用新证据包目录。

### 5.4 Codex分析并合并

Codex读取 `prompts/ANALYSIS.md`，生成每模块的贡献JSON，如analysis_001.json。贡献必须声明snapshot_id、reviewed_file_ids、reviewed_categories和非空analysis_notes，并记录条目与问题。

~~~powershell
python pmtool.py merge --index outputs/run-001/index.sqlite --base outputs/run-001/draft.json --analysis outputs/run-001/analysis_001.json --output outputs/run-001/reviewed-partial.json
~~~

普通merge只表示部分分析，阶段为codex_partial。完整阅读可分析文件、处理十一类后，可以合并全部贡献并增加 `--mark-complete`；程序检查声明范围是否完整，**不能证明Codex真的读懂全部材料**。

例如，若analysis_001.json已覆盖全部可分析文件和十一类，可生成完整范围的整理结果：

~~~powershell
python pmtool.py merge --index outputs/run-001/index.sqlite --base outputs/run-001/draft.json --analysis outputs/run-001/analysis_001.json --mark-complete --output outputs/run-001/reviewed.json
~~~

多个模块贡献可在--analysis后连续列出文件路径。覆盖不足时不能使用完整阶段，应继续保留partial或补读。

同ID内容不同会报错。需要修订程序草稿中的未确认候选时，增加 `--replace-id '实际条目ID'`，并保留旧值审计。已确认或人工记录不自动替换。不同内容的issue也不能静默覆盖。

### 5.5 检查和导出

~~~powershell
python pmtool.py check --index outputs/run-001/index.sqlite --materials outputs/run-001/reviewed.json --live
python pmtool.py export --index outputs/run-001/index.sqlite --materials outputs/run-001/reviewed.json --output outputs/run-001/final
~~~

check检查字段、快照、引文、成员定位和重复项；--live另核对原文件、助手和依赖是否变化。变化时应重新扫描，不能把旧贡献并入新快照。

export从同一份JSON确定生成Markdown，因此不会另加一套推断。草稿/部分材料也可导出，但会明确展示阶段。最终文件默认不覆盖；确需覆盖时先保留人工内容，再明确使用--overwrite。

### 5.6 其他入口

~~~powershell
python pmtool.py schema --output schemas --overwrite
python pmtool.py fetch --url https://github.com/goblin-zy/java-cangjie-test-bridge.git --commit 9b5b13e1dd02a026650f46185ab6a3ee093268d8 --destination 'D:\work\java-cangjie-test-bridge'
~~~

schema输出配置、最终材料和AI贡献的格式定义；随项目已经提供schemas，--overwrite用于明确更新这些生成格式文件，不用于覆盖项目材料。fetch只克隆到新目录并检出完整提交，不修改远端、不执行仓库脚本；目标目录存在时拒绝改动。

## 6. 输出怎样阅读

final目录包含project_materials.json与project_materials.md。先看Markdown中的：

1. **阶段和读取范围**：是程序草稿、部分分析还是可分析范围已整理；仍可能有未解析和未确认事项。
2. **十一类材料**：接口、对应、公共代码、业务约定、依赖、环境与装配条件。
3. **来源和状态**：每条都能回到快照文件/成员/行号；空分类不等于项目不存在。
4. **问题清单**：缺失、冲突、解析失败、未解析引用、排除、覆盖和待确认事项。

依据类型basis包括：
- source_fact：源码/配置可直接提取的事实。
- document_statement：文档声明，未必已经和实现核对。
- heuristic_candidate：程序生成的候选，只能是pending。
- ai_analysis：AI综合分析。
- human_confirmation：确实经过人工确认，不能伪造。

状态status包括extracted、pending、confirmed、conflict、missing。confirmed需要明确确认说明；有引文不等于结论成立。AI分析不是本次运行验证，结构检查也不证明翻译等价。

模型、字段和贡献格式详见 schemas/。所有最终记录使用当前snapshot_id，来源file_id在query结果中获得，不能自行编造。

十一类目录如下；程序主要填直接事实和候选，业务含义等仍需Codex分析：

| 分类 | 主要内容 |
|---|---|
| C01 项目结构与模块关系 | 文件、目录、包与模块 |
| C02 项目符号对应表 | 源目标成员及未确认候选 |
| C03 目标接口与数据结构 | 参数、返回、访问方式和类型 |
| C04 项目公共业务约定 | 有依据的公共行为和数据表示 |
| C05 公共测试基础设施及迁移状态 | 公共工厂、断言、基类及缺失目标定义 |
| C06 依赖替代与兼容方案 | 实际采用的目标依赖和适配 |
| C07 已完成目标代码与允许范例 | 可定位的现有定义与使用方式 |
| C08 工具链与构建配置 | 版本、依赖及运行入口 |
| C09 公共资源与环境约定 | 资源位置、编码、服务等条件 |
| C10 翻译和装配约束 | 固定接口、引用及保存位置要求 |
| C11 支持范围与特殊处理决定 | 已有方案、未支持和待确认情况 |

### Account会整理出什么

在可用解析环境和实际分析完成后，可能得到：
- Java withdraw(int)与仓颉withdraw(Int64)的对应及类型差异。
- 目标getBalance返回Int64，balance是私有字段。
- 两侧余额不足异常定义及父类差异。
- Java有MAX_BALANCE而目标没有同名常量。
- 根据实现整理“先检查再扣款、拒绝时不改余额”，并附出处。

这是内容示意，不是本次生成的材料或测试结果。setUp中的100、测试取款30/预期70属于具体测试上下文；私有prepareSequence及其中断言需要迁移，不能当成目标现成公共代码。

## 7. 常见问题

| 现象 | 怎样处理 |
|---|---|
| 找不到pydantic | 使用安装了requirements的Python；检查是否误用另一个Python |
| Java入口卡住或失败 | 填写真实JDK bin/java.exe路径，避免无效跳转入口；检查javac路径 |
| 助手未构建/源码已变化 | 运行对应build_adapters命令；不是修改样例项目 |
| 没有仓颉SDK或助手不能启动 | 保留失败与隔离记录；在可用SDK环境构建，禁止静默正则降级或修补SDK |
| 出现未解析调用 | 检查Java源码根和依赖JAR；复杂动态调用可能不支持，不能按同名强行关联 |
| 输入范围重叠 | 调整来源路径/include/exclude，确保文件只由一个来源收集 |
| 输出目录已有扫描 | 换一个新run目录，保留旧索引与人工贡献 |
| 引文不匹配 | 用show重新取快照，核对行号，不引用已改变的原文件 |
| snapshot_id不同 | 不同扫描不能混用，重新针对当前快照分析 |
| packet失败后留下部分文件 | 保留问题记录，换新的包目录重试，不把不完整目录当作完整清单 |
| merge提示编号冲突 | 查看双方内容；未确认条目需显式replace-id，已确认项人工处理 |
| fetch失败留下工作副本目录 | 不自动删除目录；检查网络/提交，选新目录或人工处理已有副本 |

## 8. 已实现代码范围与限制

- 已提供：只读收集与UTF-8解析副本、SQLite快照/索引、Java声明/常规调用/构造委托/字段引用提取、候选、配置声明、查询、分片、草稿、贡献合并、结构/来源检查及导出代码。
- Java依赖解析需要源码根和JAR。方法引用尚未绑定；反射、完整动态分派、Lombok/其他生成成员、Maven/Gradle有效模型不在本版保证范围。
- record显式组件与紧凑构造器有提取代码，编译器合成成员不枚举。
- 仓颉助手与1.2 dump归一化代码已提供，但本机无SDK，未构建/运行。缺少源码位置、未知声明、宏及调用绑定会报告覆盖问题；不能承诺复杂仓颉工程完整解析。
- POM只提取声明及本文件属性替换，TOML读取键值，Gradle/脚本只作为文本证据，不执行。配置定位可能是声明的上下文行，不能等同于有效依赖树。
- 解析环境指纹记录已识别的助手、JAR和元数据，不保证穷尽系统动态库。
- 所有功能正确性、复杂项目覆盖和性能仍待下一阶段测试。此处“代码已提供”与“已通过测试”严格区分。

## 9. 项目文件

~~~text
pmtool.py                   无需安装包的命令入口
src/pmtool/                 主程序、模型、索引、提取与材料处理
adapters/java/              Java解析助手及Maven依赖声明
adapters/cangjie/           仓颉std.ast助手
scripts/build_adapters.py   只构建工具助手
prompts/WORKFLOW.md          Codex执行流程
prompts/ANALYSIS.md          材料分析与证据要求
examples/account.project.json  待替换路径的输入示例
schemas/                    由模型生成的数据格式定义
docs/IMPLEMENTATION.md       本次实际实现与检查记录
~~~

