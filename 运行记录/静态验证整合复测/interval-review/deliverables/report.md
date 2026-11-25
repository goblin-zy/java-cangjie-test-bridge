# 测试翻译静态验证报告

本轮对 IntervalTest 的九条最终译文作静态审阅，保留十二条源断言。

test_construct：构造区间(1,3)，依次检查起点1、终点3；仓颉显式Int32匹配业务签名。

test_size：构造区间(0,2)，调用真实size并要求3，保留端点包含的长度语义。

test_intervaloverlaps：区间(1,3)与(2,4)调用区间重载，要求重叠为真。

test_intervalDoesNotOverlap：区间(1,13)与(27,42)调用区间重载，要求重叠为假。

test_pointOverlaps：区间(1,3)对点2调用点重载，要求重叠为真。

test_pointDoesNotOverlap：区间(1,13)对点42调用点重载，要求重叠为假。

test_comparable：按(4,6)、(2,7)、(3,4)顺序放入同一有序集合，推进同一迭代器并依次断言起点2、3、4；IntervalBridge委托真实compareTo并转换Ordering。

test_checkToString：构造区间(4,6)，要求真实toString返回4:6。

test_compareToNegativeTest：构造区间(4,6)，传入不属于Intervalable的普通对象，要求真实compareTo返回-1；UnrelatedValue承担原new Object()的角色。

结论是在所列接口前提和当前范围内一致。标注与判断由当前Agent对照两侧源码整理，脚本固定回放；本轮没有执行两个独立盲审会话，未评估语义错误检出率。Java和仓颉各9条测试的真实运行日志另存于base。

## 范围与结果索引

路线 `whole`，选定 9 项，完成比较 9 项。
目标接口约定状态 `assumed`。版本指纹见 [结构化报告](report.json) 的 versions。

- U01 · test_construct · 在所列前提和范围内一致
- U02 · test_size · 在所列前提和范围内一致
- U03 · test_intervaloverlaps · 在所列前提和范围内一致
- U04 · test_intervalDoesNotOverlap · 在所列前提和范围内一致
- U05 · test_pointOverlaps · 在所列前提和范围内一致
- U06 · test_pointDoesNotOverlap · 在所列前提和范围内一致
- U07 · test_comparable · 在所列前提和范围内一致
- U08 · test_checkToString · 在所列前提和范围内一致
- U09 · test_compareToNegativeTest · 在所列前提和范围内一致

## 原文证据

行号指向交付包中带注释的源码。

- java/J008 · [IntervalTest.java 第 69–69 行](IntervalTest.java#L69)
- java/J009 · [IntervalTest.java 第 77–77 行](IntervalTest.java#L77)
- java/J010 · [IntervalTest.java 第 85–85 行](IntervalTest.java#L85)
- java/J011 · [IntervalTest.java 第 93–93 行](IntervalTest.java#L93)
- java/J012 · [IntervalTest.java 第 101–101 行](IntervalTest.java#L101)
- cangjie/C012 · [interval_test.cj 第 98–98 行](interval_test.cj#L98)
- cangjie/C013 · [interval_test.cj 第 106–106 行](interval_test.cj#L106)
- cangjie/C014 · [interval_test.cj 第 114–114 行](interval_test.cj#L114)
- cangjie/C015 · [interval_test.cj 第 122–122 行](interval_test.cj#L122)
- cangjie/C016 · [interval_test.cj 第 130–130 行](interval_test.cj#L130)
- java/J013 · [IntervalTest.java 第 111–111 行](IntervalTest.java#L111)
- java/J014 · [IntervalTest.java 第 119–119 行](IntervalTest.java#L119)
- java/J015 · [IntervalTest.java 第 127–127 行](IntervalTest.java#L127)
- cangjie/C017 · [interval_test.cj 第 139–139 行](interval_test.cj#L139)
- cangjie/C018 · [interval_test.cj 第 147–147 行](interval_test.cj#L147)
- cangjie/C019 · [interval_test.cj 第 155–155 行](interval_test.cj#L155)
- java/J016 · [IntervalTest.java 第 137–137 行](IntervalTest.java#L137)
- java/J017 · [IntervalTest.java 第 145–145 行](IntervalTest.java#L145)
- java/J018 · [IntervalTest.java 第 153–153 行](IntervalTest.java#L153)
- cangjie/C020 · [interval_test.cj 第 164–164 行](interval_test.cj#L164)
- cangjie/C021 · [interval_test.cj 第 172–172 行](interval_test.cj#L172)
- cangjie/C022 · [interval_test.cj 第 180–180 行](interval_test.cj#L180)
- java/J019 · [IntervalTest.java 第 163–163 行](IntervalTest.java#L163)
- java/J020 · [IntervalTest.java 第 171–171 行](IntervalTest.java#L171)
- java/J021 · [IntervalTest.java 第 179–179 行](IntervalTest.java#L179)
- cangjie/C023 · [interval_test.cj 第 189–189 行](interval_test.cj#L189)
- cangjie/C024 · [interval_test.cj 第 197–197 行](interval_test.cj#L197)
- cangjie/C025 · [interval_test.cj 第 205–205 行](interval_test.cj#L205)
- java/J022 · [IntervalTest.java 第 189–189 行](IntervalTest.java#L189)
- java/J023 · [IntervalTest.java 第 197–197 行](IntervalTest.java#L197)
- java/J024 · [IntervalTest.java 第 205–205 行](IntervalTest.java#L205)
- cangjie/C026 · [interval_test.cj 第 214–214 行](interval_test.cj#L214)
- cangjie/C027 · [interval_test.cj 第 222–222 行](interval_test.cj#L222)
- cangjie/C028 · [interval_test.cj 第 230–230 行](interval_test.cj#L230)
- java/J025 · [IntervalTest.java 第 215–215 行](IntervalTest.java#L215)
- java/J026 · [IntervalTest.java 第 223–223 行](IntervalTest.java#L223)
- java/J027 · [IntervalTest.java 第 231–231 行](IntervalTest.java#L231)
- cangjie/C029 · [interval_test.cj 第 239–239 行](interval_test.cj#L239)
- cangjie/C030 · [interval_test.cj 第 247–247 行](interval_test.cj#L247)
- cangjie/C031 · [interval_test.cj 第 255–255 行](interval_test.cj#L255)
- java/J028 · [IntervalTest.java 第 241–241 行](IntervalTest.java#L241)
- java/J029 · [IntervalTest.java 第 249–249 行](IntervalTest.java#L249)
- java/J030 · [IntervalTest.java 第 257–257 行](IntervalTest.java#L257)
- java/J031 · [IntervalTest.java 第 265–265 行](IntervalTest.java#L265)
- java/J032 · [IntervalTest.java 第 273–273 行](IntervalTest.java#L273)
- java/J033 · [IntervalTest.java 第 281–281 行](IntervalTest.java#L281)
- java/J034 · [IntervalTest.java 第 289–289 行](IntervalTest.java#L289)
- java/J035 · [IntervalTest.java 第 297–297 行](IntervalTest.java#L297)
- java/J036 · [IntervalTest.java 第 305–305 行](IntervalTest.java#L305)
- java/J037 · [IntervalTest.java 第 313–313 行](IntervalTest.java#L313)
- cangjie/C032 · [interval_test.cj 第 264–264 行](interval_test.cj#L264)
- cangjie/C033 · [interval_test.cj 第 272–272 行](interval_test.cj#L272)
- cangjie/C034 · [interval_test.cj 第 280–280 行](interval_test.cj#L280)
- cangjie/C035 · [interval_test.cj 第 288–288 行](interval_test.cj#L288)
- cangjie/C036 · [interval_test.cj 第 296–296 行](interval_test.cj#L296)
- cangjie/C037 · [interval_test.cj 第 304–304 行](interval_test.cj#L304)
- cangjie/C038 · [interval_test.cj 第 312–312 行](interval_test.cj#L312)
- cangjie/C039 · [interval_test.cj 第 320–320 行](interval_test.cj#L320)
- cangjie/C040 · [interval_test.cj 第 328–328 行](interval_test.cj#L328)
- cangjie/C041 · [interval_test.cj 第 336–336 行](interval_test.cj#L336)
- cangjie/C005 · [interval_test.cj 第 41–41 行](interval_test.cj#L41)
- cangjie/C008 · [interval_test.cj 第 65–65 行](interval_test.cj#L65)
- java/J038 · [IntervalTest.java 第 323–323 行](IntervalTest.java#L323)
- java/J039 · [IntervalTest.java 第 331–331 行](IntervalTest.java#L331)
- java/J040 · [IntervalTest.java 第 339–339 行](IntervalTest.java#L339)
- cangjie/C042 · [interval_test.cj 第 345–345 行](interval_test.cj#L345)
- cangjie/C043 · [interval_test.cj 第 353–353 行](interval_test.cj#L353)
- cangjie/C044 · [interval_test.cj 第 361–361 行](interval_test.cj#L361)
- java/J041 · [IntervalTest.java 第 349–349 行](IntervalTest.java#L349)
- java/J042 · [IntervalTest.java 第 357–357 行](IntervalTest.java#L357)
- java/J043 · [IntervalTest.java 第 365–365 行](IntervalTest.java#L365)
- cangjie/C045 · [interval_test.cj 第 370–370 行](interval_test.cj#L370)
- cangjie/C046 · [interval_test.cj 第 378–378 行](interval_test.cj#L378)
- cangjie/C047 · [interval_test.cj 第 386–386 行](interval_test.cj#L386)
- cangjie/C009 · [interval_test.cj 第 74–74 行](interval_test.cj#L74)
