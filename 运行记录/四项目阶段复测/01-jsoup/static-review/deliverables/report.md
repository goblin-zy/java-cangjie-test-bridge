# 测试翻译静态验证报告

本轮限定于已配对用例。当前Agent联合复核固定提交，未执行双侧独立盲审。

testByTag：保留两段原HTML及DIV大小写查询，检查三个ID及span零命中。

byEscapedTag：保留HTML中的点和反斜杠，以及CSS选择器的两层转义，依次断言One和Two。

testById：同一HTML重复ID返回两个节点并保持原文本顺序；另一个HTML不存在foo，仍检查零命中。

byEscapedId：保留三个原ID和选择器转义，依次检查One、Two、Three。

testByClass：保留大小写类名、多个类名、缺失类以及带连字符类名的全部五条断言。

## 范围与结果索引

路线 `whole`，选定 5 项，完成比较 5 项。
目标接口约定状态 `assumed`。版本指纹见 [结构化报告](report.json) 的 versions。

- U01 · testByTag · 在所列前提和范围内一致
- U02 · byEscapedTag · 在所列前提和范围内一致
- U03 · testById · 在所列前提和范围内一致
- U04 · byEscapedId · 在所列前提和范围内一致
- U05 · testByClass · 在所列前提和范围内一致

## 原文证据

行号指向交付包中带注释的源码。

- java/J012 · [SelectorTest.java 第 105–105 行](SelectorTest.java#L105)
- java/J013 · [SelectorTest.java 第 114–114 行](SelectorTest.java#L114)
- java/J014 · [SelectorTest.java 第 122–122 行](SelectorTest.java#L122)
- java/J015 · [SelectorTest.java 第 130–130 行](SelectorTest.java#L130)
- java/J016 · [SelectorTest.java 第 138–138 行](SelectorTest.java#L138)
- java/J017 · [SelectorTest.java 第 146–146 行](SelectorTest.java#L146)
- java/J018 · [SelectorTest.java 第 155–155 行](SelectorTest.java#L155)
- java/J019 · [SelectorTest.java 第 163–163 行](SelectorTest.java#L163)
- cangjie/C006 · [translated_test.cj 第 51–51 行](translated_test.cj#L51)
- cangjie/C007 · [translated_test.cj 第 59–59 行](translated_test.cj#L59)
- cangjie/C008 · [translated_test.cj 第 67–67 行](translated_test.cj#L67)
- cangjie/C009 · [translated_test.cj 第 75–75 行](translated_test.cj#L75)
- cangjie/C010 · [translated_test.cj 第 83–83 行](translated_test.cj#L83)
- cangjie/C011 · [translated_test.cj 第 91–91 行](translated_test.cj#L91)
- cangjie/C012 · [translated_test.cj 第 99–99 行](translated_test.cj#L99)
- cangjie/C013 · [translated_test.cj 第 107–107 行](translated_test.cj#L107)
- cangjie/C014 · [translated_test.cj 第 115–115 行](translated_test.cj#L115)
- java/J020 · [SelectorTest.java 第 173–173 行](SelectorTest.java#L173)
- java/J021 · [SelectorTest.java 第 182–182 行](SelectorTest.java#L182)
- java/J022 · [SelectorTest.java 第 191–191 行](SelectorTest.java#L191)
- java/J023 · [SelectorTest.java 第 199–199 行](SelectorTest.java#L199)
- java/J024 · [SelectorTest.java 第 208–208 行](SelectorTest.java#L208)
- java/J025 · [SelectorTest.java 第 216–216 行](SelectorTest.java#L216)
- cangjie/C015 · [translated_test.cj 第 124–124 行](translated_test.cj#L124)
- cangjie/C016 · [translated_test.cj 第 132–132 行](translated_test.cj#L132)
- cangjie/C017 · [translated_test.cj 第 140–140 行](translated_test.cj#L140)
- cangjie/C018 · [translated_test.cj 第 148–148 行](translated_test.cj#L148)
- cangjie/C019 · [translated_test.cj 第 156–156 行](translated_test.cj#L156)
- cangjie/C020 · [translated_test.cj 第 164–164 行](translated_test.cj#L164)
- cangjie/C021 · [translated_test.cj 第 172–172 行](translated_test.cj#L172)
- java/J026 · [SelectorTest.java 第 226–226 行](SelectorTest.java#L226)
- java/J027 · [SelectorTest.java 第 234–234 行](SelectorTest.java#L234)
- java/J028 · [SelectorTest.java 第 242–242 行](SelectorTest.java#L242)
- java/J029 · [SelectorTest.java 第 250–250 行](SelectorTest.java#L250)
- java/J030 · [SelectorTest.java 第 258–258 行](SelectorTest.java#L258)
- java/J031 · [SelectorTest.java 第 267–267 行](SelectorTest.java#L267)
- java/J032 · [SelectorTest.java 第 275–275 行](SelectorTest.java#L275)
- cangjie/C022 · [translated_test.cj 第 181–181 行](translated_test.cj#L181)
- cangjie/C023 · [translated_test.cj 第 189–189 行](translated_test.cj#L189)
- cangjie/C024 · [translated_test.cj 第 197–197 行](translated_test.cj#L197)
- cangjie/C025 · [translated_test.cj 第 205–205 行](translated_test.cj#L205)
- cangjie/C026 · [translated_test.cj 第 213–213 行](translated_test.cj#L213)
- cangjie/C027 · [translated_test.cj 第 221–221 行](translated_test.cj#L221)
- cangjie/C028 · [translated_test.cj 第 229–229 行](translated_test.cj#L229)
- cangjie/C029 · [translated_test.cj 第 237–237 行](translated_test.cj#L237)
- java/J033 · [SelectorTest.java 第 285–285 行](SelectorTest.java#L285)
- java/J034 · [SelectorTest.java 第 293–293 行](SelectorTest.java#L293)
- java/J035 · [SelectorTest.java 第 302–302 行](SelectorTest.java#L302)
- java/J036 · [SelectorTest.java 第 310–310 行](SelectorTest.java#L310)
- java/J037 · [SelectorTest.java 第 319–319 行](SelectorTest.java#L319)
- java/J038 · [SelectorTest.java 第 327–327 行](SelectorTest.java#L327)
- java/J039 · [SelectorTest.java 第 336–336 行](SelectorTest.java#L336)
- java/J040 · [SelectorTest.java 第 344–344 行](SelectorTest.java#L344)
- cangjie/C030 · [translated_test.cj 第 246–246 行](translated_test.cj#L246)
- cangjie/C031 · [translated_test.cj 第 254–254 行](translated_test.cj#L254)
- cangjie/C032 · [translated_test.cj 第 262–262 行](translated_test.cj#L262)
- cangjie/C033 · [translated_test.cj 第 270–270 行](translated_test.cj#L270)
- cangjie/C034 · [translated_test.cj 第 278–278 行](translated_test.cj#L278)
- cangjie/C035 · [translated_test.cj 第 286–286 行](translated_test.cj#L286)
- cangjie/C036 · [translated_test.cj 第 294–294 行](translated_test.cj#L294)
- cangjie/C037 · [translated_test.cj 第 302–302 行](translated_test.cj#L302)
- cangjie/C038 · [translated_test.cj 第 310–310 行](translated_test.cj#L310)
- java/J041 · [SelectorTest.java 第 354–354 行](SelectorTest.java#L354)
- java/J042 · [SelectorTest.java 第 362–362 行](SelectorTest.java#L362)
- java/J043 · [SelectorTest.java 第 370–370 行](SelectorTest.java#L370)
- java/J044 · [SelectorTest.java 第 378–378 行](SelectorTest.java#L378)
- java/J045 · [SelectorTest.java 第 386–386 行](SelectorTest.java#L386)
- java/J046 · [SelectorTest.java 第 395–395 行](SelectorTest.java#L395)
- java/J047 · [SelectorTest.java 第 403–403 行](SelectorTest.java#L403)
- java/J048 · [SelectorTest.java 第 412–412 行](SelectorTest.java#L412)
- java/J049 · [SelectorTest.java 第 420–420 行](SelectorTest.java#L420)
- cangjie/C039 · [translated_test.cj 第 319–319 行](translated_test.cj#L319)
- cangjie/C040 · [translated_test.cj 第 327–327 行](translated_test.cj#L327)
- cangjie/C041 · [translated_test.cj 第 335–335 行](translated_test.cj#L335)
- cangjie/C042 · [translated_test.cj 第 343–343 行](translated_test.cj#L343)
- cangjie/C043 · [translated_test.cj 第 351–351 行](translated_test.cj#L351)
- cangjie/C044 · [translated_test.cj 第 359–359 行](translated_test.cj#L359)
- cangjie/C045 · [translated_test.cj 第 367–367 行](translated_test.cj#L367)
- cangjie/C046 · [translated_test.cj 第 375–375 行](translated_test.cj#L375)
- cangjie/C047 · [translated_test.cj 第 383–383 行](translated_test.cj#L383)
- cangjie/C048 · [translated_test.cj 第 391–391 行](translated_test.cj#L391)
