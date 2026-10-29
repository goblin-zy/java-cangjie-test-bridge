# 仓颉参考测试：VS Code复现步骤

更新日期：2026-10-27。适用于“蔡俊杰week7”分支根目录项目。

本流程使用项目配置的VS Code任务，自动调用编译器和参考测试脚本。使用者只需点选菜单和填写测试名，不需要手工输入PowerShell命令。它不是仓颉源码行号旁的原生测试按钮。

## 一、打开正确的项目目录

在VS Code中选择“文件 → 打开文件夹”，切换到“蔡俊杰week7”分支，直接打开含有pom.xml及.vscode的仓库根目录，无需进入额外的week7文件夹。需要保留：

- `.vscode/tasks.json`：包含“运行仓颉参考测试（24项）”和“运行单个仓颉测试”。
- `.vscode/settings.json`：`CangjieSdkPath.CJNativeBackend`指向本机实际可用的SDK根目录。
- `scripts/run-reference-cangjie.ps1`：编译、运行、筛选和保存结果。
- `reference/cangjie/implementation/`：仓颉业务源码。
- `reference/cangjie/tests/`：仓颉参考测试源码。
- `reference/cases.json`：24个测试的预期执行清单。

当前已验收环境使用仓颉1.2.0基础上的独立localfix运行库；该差异、修改内容和哈希须随实验结果记录，不能写成原版SDK通过。任务直接调用cjc，不要求LSP语言服务器已经启动。

## 二、先进入“运行任务”，再选择仓颉任务

1. 按 **Ctrl＋Shift＋P**，打开命令面板。
2. 输入下面的命令名称：

   ```text
   Tasks: Run Task
   ```

3. 选择 **“任务：运行任务”**。
4. VS Code会打开**第二个任务选择框**，这时再输入“仓颉”，选择下一节所需的任务。

**注意两个选择框的区别：**第一个框用于查找VS Code命令，第二个框用于查找本项目的自定义任务。直接在第一个框搜索“仓颉”不等于进入项目任务列表，因此可能找不到我们配置的任务。

也可通过顶部菜单“终端 → 运行任务”直接打开第二个选择框。

## 三、运行全部24个仓颉参考测试

在任务选择框中选择：

```text
运行仓颉参考测试（24项）
```

任务自动加载已配置SDK，编译业务和测试源码，然后执行全部参考测试。结果显示在VS Code下方任务终端。

预期结果：

```text
Summary: TOTAL: 24
PASSED: 24, SKIPPED: 0, ERROR: 0
FAILED: 0
```

## 四、只运行一个测试函数

1. 通过第二节进入任务选择框。
2. 选择：

   ```text
   运行单个仓颉测试
   ```

3. 弹窗会要求输入“测试类.测试方法”。例如只检查正常取款：

   ```text
   AccountTest.testWithdraw
   ```

4. 按回车，等待编译和执行。

预期结果：

```text
TCS: AccountTest
[ PASSED ] CASE: testWithdraw
Summary: TOTAL: 24
PASSED: 1, SKIPPED: 23, ERROR: 0
FAILED: 0
```

这里TOTAL表示工程定义的24个测试，**实际只执行了1个，其余23个因筛选被跳过**。不是24个全部执行。

其他可用示例：

|想检查的场景|输入的测试名|
|---|---|
|正常取款|`AccountTest.testWithdraw`|
|余额不足及失败后状态|`AccountTest.testInsufficientFunds`|
|矩形共享边|`RectangleTest.testTouchingEdge`|
|字符串正负整数转换|`InstructionParserTest.testSignedNumbers`|

名称区分大小写。这里填写的是测试函数，不是直接填写业务函数`withdraw`。

## 五、运行某个测试类

仍选择“运行单个仓颉测试”，在输入框使用通配符，例如：

```text
RectangleTest.*
```

它会运行矩形的6个测试，预期：

```text
PASSED: 6, SKIPPED: 18, ERROR: 0
FAILED: 0
```

`AccountTest.*`和`InstructionParserTest.*`分别选择对应类的9个测试。筛选决定执行哪些测试，编译阶段仍会编译相关工程源码。

## 六、查看保存的结果

每次运行会新建一个目录：

```text
validation/reference-年月日-时分秒毫秒/
```

任务结束时会打印`Reference results: .../results.json`，据此打开本次目录。主要文件：

|文件|内容|
|---|---|
|`compile.log`|编译输出|
|`test.log`|测试原始输出|
|`results.json`|选中的测试、逐项状态、数量和退出码|
|`invocation.txt`|时间、命令、筛选条件、环境标记|
|`source-sha256.json`|本次使用的源码哈希|
|`LOCAL-RUNTIME-FIX.json`|本机localfix运行库的修改说明；使用该副本时保存|

`results.json`中的`expected`是选中数量，`filter_excluded`是因筛选排除的数量，`skipped`只统计选中后却跳过的测试。测试名拼错会在编译前被拒绝，不能把零测试执行当作通过。

## 七、常见问题

### 1. 命令面板搜“仓颉”找不到任务

先选择`Tasks: Run Task／任务：运行任务`，再到第二个选择框中搜索“仓颉”。检查当前打开的是上述整个项目目录，而非单个文件或其他旧目录。

### 2. `cjpm build`提示缺少`cjpm.toml`

当前根目录是Java Maven项目，未配置仓颉CJPM工程。上述自定义任务使用`cjc --test`，不依赖根目录的`cjpm.toml`。运行任务即可；原生CJPM测试按钮需要额外工程配置，本流程没有把它声明为已完成。

### 3. 仓颉语言服务器报`LSPServer.exe ENOENT`

这是编辑器语言服务问题。检查工作区SDK配置及该SDK的`tools/bin/LSPServer.exe`；语言服务的重启与测试任务运行分开处理。编译任务使用实际编译器，LSP失败不等于测试代码编译失败。

### 4. 当前打开的是`generated/.../skeleton/*.java`

这是提取出的Java结构骨架，其中的`SKELETON_PLACEHOLDER`是占位异常。它不是仓颉参考测试，也不是可用于检查业务正确性的完整Java测试。仓颉测试任务始终读取`reference/cangjie/tests/`中的实际.cj文件，不依据当前编辑器打开的文件决定输入。

### 5. 输出显示FAILED或ERROR

记录本次`results.json`和对应日志，区分断言失败、执行错误与编译失败，不修改预期值来强行获得通过。四个故意改错验收的失败属于预先设计的独立实验，不应混入正常源码。

## 八、本机已执行的核对

|范围|实际结果|证据目录|
|---|---|---|
|全部|24通过、0跳过|`validation/cangjie-filter-all-001/`|
|`AccountTest.testWithdraw`|1通过、23项筛选排除|`validation/cangjie-filter-single-001/`|
|`RectangleTest.*`|6通过、18项筛选排除|`validation/cangjie-filter-class-001/`|

以上编译与运行结果来自与任务配置相同的进程入口实际执行；没有把尚未完成的原生按钮配置当作验证结果。当前记录只支持已检查场景，不能证明全部程序行为完全等价。
