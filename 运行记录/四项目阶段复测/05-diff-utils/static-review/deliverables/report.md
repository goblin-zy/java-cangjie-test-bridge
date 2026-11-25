# 测试翻译静态验证报告

本轮限定于已配对用例。当前Agent联合复核固定提交，未执行双侧独立盲审。

testDiff_Insert：保留hhh到hhh/jjj/kkk的输入；五项检查分别对应非空Patch、单个差异、最终类InsertDelta及位置1的原/新Chunk内容。

testDiff_Delete：保留ddd/fff/ggg到ggg的输入；五项检查分别对应非空Patch、单个差异、最终类DeleteDelta及位置0的原/新Chunk内容。

testDiff_Change：保留aaa/bbb/ccc到aaa/zzz/ccc的输入；五项检查分别对应非空Patch、单个差异、最终类ChangeDelta及位置1的bbb到zzz的Chunk。

## 范围与结果索引

路线 `whole`，选定 3 项，完成比较 3 项。
目标接口约定状态 `assumed`。版本指纹见 [结构化报告](report.json) 的 versions。

- U01 · testDiff_Insert · 在所列前提和范围内一致
- U02 · testDiff_Delete · 在所列前提和范围内一致
- U03 · testDiff_Change · 在所列前提和范围内一致

## 原文证据

行号指向交付包中带注释的源码。

- java/J009 · [DiffTest.java 第 76–76 行](DiffTest.java#L76)
- java/J010 · [DiffTest.java 第 84–84 行](DiffTest.java#L84)
- java/J011 · [DiffTest.java 第 92–92 行](DiffTest.java#L92)
- java/J012 · [DiffTest.java 第 100–100 行](DiffTest.java#L100)
- java/J013 · [DiffTest.java 第 108–108 行](DiffTest.java#L108)
- java/J014 · [DiffTest.java 第 116–116 行](DiffTest.java#L116)
- java/J015 · [DiffTest.java 第 124–124 行](DiffTest.java#L124)
- java/J016 · [DiffTest.java 第 132–132 行](DiffTest.java#L132)
- cangjie/C007 · [translated_test.cj 第 59–59 行](translated_test.cj#L59)
- cangjie/C008 · [translated_test.cj 第 67–67 行](translated_test.cj#L67)
- cangjie/C009 · [translated_test.cj 第 75–75 行](translated_test.cj#L75)
- cangjie/C010 · [translated_test.cj 第 83–83 行](translated_test.cj#L83)
- cangjie/C011 · [translated_test.cj 第 91–91 行](translated_test.cj#L91)
- cangjie/C012 · [translated_test.cj 第 99–99 行](translated_test.cj#L99)
- cangjie/C013 · [translated_test.cj 第 107–107 行](translated_test.cj#L107)
- cangjie/C014 · [translated_test.cj 第 115–115 行](translated_test.cj#L115)
- cangjie/C015 · [translated_test.cj 第 123–123 行](translated_test.cj#L123)
- java/J017 · [DiffTest.java 第 142–142 行](DiffTest.java#L142)
- java/J018 · [DiffTest.java 第 150–150 行](DiffTest.java#L150)
- java/J019 · [DiffTest.java 第 158–158 行](DiffTest.java#L158)
- java/J020 · [DiffTest.java 第 166–166 行](DiffTest.java#L166)
- java/J021 · [DiffTest.java 第 174–174 行](DiffTest.java#L174)
- java/J022 · [DiffTest.java 第 182–182 行](DiffTest.java#L182)
- java/J023 · [DiffTest.java 第 190–190 行](DiffTest.java#L190)
- java/J024 · [DiffTest.java 第 198–198 行](DiffTest.java#L198)
- cangjie/C016 · [translated_test.cj 第 132–132 行](translated_test.cj#L132)
- cangjie/C017 · [translated_test.cj 第 140–140 行](translated_test.cj#L140)
- cangjie/C018 · [translated_test.cj 第 148–148 行](translated_test.cj#L148)
- cangjie/C019 · [translated_test.cj 第 156–156 行](translated_test.cj#L156)
- cangjie/C020 · [translated_test.cj 第 164–164 行](translated_test.cj#L164)
- cangjie/C021 · [translated_test.cj 第 172–172 行](translated_test.cj#L172)
- cangjie/C022 · [translated_test.cj 第 180–180 行](translated_test.cj#L180)
- cangjie/C023 · [translated_test.cj 第 188–188 行](translated_test.cj#L188)
- cangjie/C024 · [translated_test.cj 第 196–196 行](translated_test.cj#L196)
- java/J025 · [DiffTest.java 第 208–208 行](DiffTest.java#L208)
- java/J026 · [DiffTest.java 第 216–216 行](DiffTest.java#L216)
- java/J027 · [DiffTest.java 第 224–224 行](DiffTest.java#L224)
- java/J028 · [DiffTest.java 第 233–233 行](DiffTest.java#L233)
- java/J029 · [DiffTest.java 第 241–241 行](DiffTest.java#L241)
- java/J030 · [DiffTest.java 第 249–249 行](DiffTest.java#L249)
- java/J031 · [DiffTest.java 第 257–257 行](DiffTest.java#L257)
- java/J032 · [DiffTest.java 第 265–265 行](DiffTest.java#L265)
- java/J033 · [DiffTest.java 第 273–273 行](DiffTest.java#L273)
- java/J034 · [DiffTest.java 第 281–281 行](DiffTest.java#L281)
- cangjie/C025 · [translated_test.cj 第 205–205 行](translated_test.cj#L205)
- cangjie/C026 · [translated_test.cj 第 213–213 行](translated_test.cj#L213)
- cangjie/C027 · [translated_test.cj 第 221–221 行](translated_test.cj#L221)
- cangjie/C028 · [translated_test.cj 第 229–229 行](translated_test.cj#L229)
- cangjie/C029 · [translated_test.cj 第 237–237 行](translated_test.cj#L237)
- cangjie/C030 · [translated_test.cj 第 245–245 行](translated_test.cj#L245)
- cangjie/C031 · [translated_test.cj 第 253–253 行](translated_test.cj#L253)
- cangjie/C032 · [translated_test.cj 第 261–261 行](translated_test.cj#L261)
- cangjie/C033 · [translated_test.cj 第 269–269 行](translated_test.cj#L269)
- cangjie/C034 · [translated_test.cj 第 277–277 行](translated_test.cj#L277)
- cangjie/C035 · [translated_test.cj 第 285–285 行](translated_test.cj#L285)
