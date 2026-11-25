# 测试翻译静态验证报告

本轮限定于已配对用例。当前Agent联合复核固定提交，未执行双侧独立盲审。

testGetLevenshteinDistance_StringString：原UNLIMITED_DISTANCE为无阈值、无跨次可变状态的距离对象，适配为实际leven函数；保留同一方法内十组ASCII输入及全部原期望值0、1、7、1、3、7、7、8、8、1。

## 范围与结果索引

路线 `whole`，选定 1 项，完成比较 1 项。
目标接口约定状态 `assumed`。版本指纹见 [结构化报告](report.json) 的 versions。

- U01 · testGetLevenshteinDistance_StringString · 在所列前提和范围内一致

## 原文证据

行号指向交付包中带注释的源码。

- java/J025 · [LevenshteinDistanceTest.java 第 236–236 行](LevenshteinDistanceTest.java#L236)
- java/J026 · [LevenshteinDistanceTest.java 第 244–244 行](LevenshteinDistanceTest.java#L244)
- java/J027 · [LevenshteinDistanceTest.java 第 252–252 行](LevenshteinDistanceTest.java#L252)
- java/J028 · [LevenshteinDistanceTest.java 第 260–260 行](LevenshteinDistanceTest.java#L260)
- java/J029 · [LevenshteinDistanceTest.java 第 268–268 行](LevenshteinDistanceTest.java#L268)
- java/J030 · [LevenshteinDistanceTest.java 第 276–276 行](LevenshteinDistanceTest.java#L276)
- java/J031 · [LevenshteinDistanceTest.java 第 284–284 行](LevenshteinDistanceTest.java#L284)
- java/J032 · [LevenshteinDistanceTest.java 第 292–292 行](LevenshteinDistanceTest.java#L292)
- java/J033 · [LevenshteinDistanceTest.java 第 300–300 行](LevenshteinDistanceTest.java#L300)
- java/J034 · [LevenshteinDistanceTest.java 第 308–308 行](LevenshteinDistanceTest.java#L308)
- java/J035 · [LevenshteinDistanceTest.java 第 316–316 行](LevenshteinDistanceTest.java#L316)
- java/J036 · [LevenshteinDistanceTest.java 第 324–324 行](LevenshteinDistanceTest.java#L324)
- cangjie/C006 · [translated_test.cj 第 51–51 行](translated_test.cj#L51)
- cangjie/C007 · [translated_test.cj 第 59–59 行](translated_test.cj#L59)
- cangjie/C008 · [translated_test.cj 第 67–67 行](translated_test.cj#L67)
- cangjie/C009 · [translated_test.cj 第 75–75 行](translated_test.cj#L75)
- cangjie/C010 · [translated_test.cj 第 83–83 行](translated_test.cj#L83)
- cangjie/C011 · [translated_test.cj 第 91–91 行](translated_test.cj#L91)
- cangjie/C012 · [translated_test.cj 第 99–99 行](translated_test.cj#L99)
- cangjie/C013 · [translated_test.cj 第 107–107 行](translated_test.cj#L107)
- cangjie/C014 · [translated_test.cj 第 115–115 行](translated_test.cj#L115)
- cangjie/C015 · [translated_test.cj 第 123–123 行](translated_test.cj#L123)
- cangjie/C016 · [translated_test.cj 第 131–131 行](translated_test.cj#L131)
- cangjie/C017 · [translated_test.cj 第 139–139 行](translated_test.cj#L139)
