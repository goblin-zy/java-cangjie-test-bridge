# Java→仓颉初期实验材料：任务2与任务3

材料版本1.2.0 · 更新2026-10-20 · 3个模块、24个测试方法。

本包准备例子程序、测试、对应仓颉业务实现、用例说明、测试分析、数据集与真实运行记录。不包含自动测试翻译方法或Agent，不包含论文阅读卡。

## 交付文档

1. [任务2：实验材料与两侧场景核对](docs/任务2-实验材料与对应核对.md)
2. [详细用例说明与测试分析](docs/用例说明与测试分析.md)
3. [测试类型覆盖表](docs/类型覆盖表.md)
4. [功能约定与接口映射](docs/功能约定与接口映射.md)
5. [任务3：Java三阶段运行记录](docs/任务3-Java运行记录.md)
6. [环境版本记录](docs/环境版本记录.md)
7. [任务2与任务3交付核对表](docs/任务2与任务3-交付核对.md)

## 当前验证结果

|阶段|执行|通过|失败|错误|跳过|
|---|---:|---:|---:|---:|---:|
|Java正常|24|24|0|0|0|
|Java故意改错|24|20|4|0|0|
|Java恢复|24|24|0|0|0|
|仓颉参考检查（localfix）|24|24|0|0|0|

改错只将账户取款的减法临时改成加法，A03—A06断言失败符合预期。最终交付源码已恢复正确版本。最新证据在validation/v1.2/；旧日志保留供追溯。各阶段有时间、执行人说明、命令、源码哈希和报告。

仓颉使用1.2.0基础上的隔离本地修复运行库，**不是未经修改的官方SDK验证通过**。原版Windows启动问题、两处修正及运行库哈希见[本地修复说明](docs/仓颉本地修复与复现.md)。SDK和修改后的二进制不随材料zip分发。

## 源码与数据集

- Java业务：java/src/main/java/study/translation/；JUnit：java/src/test/java/study/translation/；配置：java/pom.xml。
- 仓颉业务及参考测试：cangjie/src/。普通.cj实现业务，_test.cj文件检查业务行为。
- dataset/cases.json包含24个方法的输入、步骤、预期、具体断言、上下文、源码定位与执行结果；cases.csv提供基础索引。
- Rectangle改编自TransRepo；指令解析与账户为新编教学样例，见SOURCES.md和sources/transrepo/。不是全部来自开源仓库。
- 业务、测试和辅助函数已添加适量中文注释；13个源码文件的有效代码词法序列与加注释前一致。
- cangjie/build/typecheck是历史诊断副本，日常查看和修改src；构建目录不进入zip。

## 复现

本机JDK：E:\jdk17；Maven3.9.4；JUnit5.13.4。以下命令在材料包根目录PowerShell执行：

```powershell
# 正常、改错、恢复三阶段；实际执行人按自己的身份填写
.\scripts\verify-java.ps1 -JavaHome 'E:\jdk17' -OutputRoot 'validation/reproduce-001' -Runner '填写实际执行人' -MaterialVersion '1.2.0'

# 对应仓颉参考检查；使用本机已准备的独立localfix SDK
.\scripts\verify-cangjie.ps1 -SdkHome 'C:\Users\14728\Documents\Codex\2026-10-19\xia\work\cangjie-localfix\cangjie' -OutputRoot 'validation/reproduce-001' -Runner '填写实际执行人' -MaterialVersion '1.2.0'
```

OutputRoot应选新目录以保留本批证据。其他机器按实际安装目录调整，运行库的localfix标记和哈希需一致；准备方法见本地修复说明。

本仓库保存任务2与任务3的材料；本次未修改飞书。提交者仍应阅读并能够解释所提交的程序和样例，保留来源、AI辅助整理及本地修复环境说明。参考测试通过只支持已检查场景，不证明全部输入完全等价。
