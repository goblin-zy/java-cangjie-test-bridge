// 片段编号：C001
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：package cangjie_tpc::html4cj
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：translated_test.cj原文第1行
// 待确认：无；完整接口前提见联合比较约定
package cangjie_tpc::html4cj
// 片段编号：C002
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import std.unittest.*
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：translated_test.cj原文第2行
// 待确认：无；完整接口前提见联合比较约定
import std.unittest.*
// 片段编号：C003
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import std.unittest.testmacro.*
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：translated_test.cj原文第3行
// 待确认：无；完整接口前提见联合比较约定
import std.unittest.testmacro.*


// 片段编号：C004
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：@Test
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：translated_test.cj原文第6行
// 待确认：无；完整接口前提见联合比较约定
@Test
// 片段编号：C005
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：class SelectorTranslationTest {
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：translated_test.cj原文第7行
// 待确认：无；完整接口前提见联合比较约定
class SelectorTranslationTest {

    // 片段编号：C006
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@TestCase
    // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第9行
    // 待确认：无；完整接口前提见联合比较约定
    @TestCase
    // 片段编号：C007
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：func testByTag(): Unit {
    // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第10行
    // 待确认：无；完整接口前提见联合比较约定
    func testByTag(): Unit {
        // 片段编号：C008
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let els = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV")
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第11行
        // 待确认：无；完整接口前提见联合比较约定
        let els = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV")
        // 片段编号：C009
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(3), els.size)
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第12行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(3), els.size)
        // 片段编号：C010
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("1", els[0].id())
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第13行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("1", els[0].id())
        // 片段编号：C011
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("2", els[1].id())
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第14行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("2", els[1].id())
        // 片段编号：C012
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("3", els[2].id())
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第15行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("3", els[2].id())
        // 片段编号：C013
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let none = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span")
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第16行
        // 待确认：无；完整接口前提见联合比较约定
        let none = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span")
        // 片段编号：C014
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(0), none.size)
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第17行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(0), none.size)
    }
    // 片段编号：C015
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@TestCase
    // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第19行
    // 待确认：无；完整接口前提见联合比较约定
    @TestCase
    // 片段编号：C016
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：func byEscapedTag(): Unit {
    // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第20行
    // 待确认：无；完整接口前提见联合比较约定
    func byEscapedTag(): Unit {
        // 片段编号：C017
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let doc = Html4cj.parse("<p.p>One</p.p> <p\\p>Two</p\\p>")
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第21行
        // 待确认：无；完整接口前提见联合比较约定
        let doc = Html4cj.parse("<p.p>One</p.p> <p\\p>Two</p\\p>")
        // 片段编号：C018
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let one = doc.expectFirst("p\\.p")
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第22行
        // 待确认：无；完整接口前提见联合比较约定
        let one = doc.expectFirst("p\\.p")
        // 片段编号：C019
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("One", one.text())
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第23行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("One", one.text())
        // 片段编号：C020
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let two = doc.expectFirst("p\\\\p")
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第24行
        // 待确认：无；完整接口前提见联合比较约定
        let two = doc.expectFirst("p\\\\p")
        // 片段编号：C021
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("Two", two.text())
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第25行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("Two", two.text())
    }
    // 片段编号：C022
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@TestCase
    // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第27行
    // 待确认：无；完整接口前提见联合比较约定
    @TestCase
    // 片段编号：C023
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：func testById(): Unit {
    // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第28行
    // 待确认：无；完整接口前提见联合比较约定
    func testById(): Unit {
        // 片段编号：C024
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let els = Html4cj.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo")
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第29行
        // 待确认：无；完整接口前提见联合比较约定
        let els = Html4cj.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo")
        // 片段编号：C025
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(2), els.size)
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第30行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(2), els.size)
        // 片段编号：C026
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("Hello", els[0].text())
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第31行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("Hello", els[0].text())
        // 片段编号：C027
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("Foo two!", els[1].text())
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第32行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("Foo two!", els[1].text())
        // 片段编号：C028
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let none = Html4cj.parse("<div id=1></div>").select("#foo")
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第33行
        // 待确认：无；完整接口前提见联合比较约定
        let none = Html4cj.parse("<div id=1></div>").select("#foo")
        // 片段编号：C029
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(0), none.size)
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第34行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(0), none.size)
    }
    // 片段编号：C030
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@TestCase
    // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第36行
    // 待确认：无；完整接口前提见联合比较约定
    @TestCase
    // 片段编号：C031
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：func byEscapedId(): Unit {
    // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第37行
    // 待确认：无；完整接口前提见联合比较约定
    func byEscapedId(): Unit {
        // 片段编号：C032
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let doc = Html4cj.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>")
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第38行
        // 待确认：无；完整接口前提见联合比较约定
        let doc = Html4cj.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>")
        // 片段编号：C033
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let one = doc.expectFirst("#i\\.d")
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第39行
        // 待确认：无；完整接口前提见联合比较约定
        let one = doc.expectFirst("#i\\.d")
        // 片段编号：C034
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("One", one.text())
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第40行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("One", one.text())
        // 片段编号：C035
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let two = doc.expectFirst("#i\\\\d")
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第41行
        // 待确认：无；完整接口前提见联合比较约定
        let two = doc.expectFirst("#i\\\\d")
        // 片段编号：C036
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("Two", two.text())
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第42行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("Two", two.text())
        // 片段编号：C037
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let third = doc.expectFirst("p#one-two\\/three")
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第43行
        // 待确认：无；完整接口前提见联合比较约定
        let third = doc.expectFirst("p#one-two\\/three")
        // 片段编号：C038
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("Three", third.text())
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第44行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("Three", third.text())
    }
    // 片段编号：C039
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@TestCase
    // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第46行
    // 待确认：无；完整接口前提见联合比较约定
    @TestCase
    // 片段编号：C040
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：func testByClass(): Unit {
    // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：translated_test.cj原文第47行
    // 待确认：无；完整接口前提见联合比较约定
    func testByClass(): Unit {
        // 片段编号：C041
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let els = Html4cj.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select("P.One")
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第48行
        // 待确认：无；完整接口前提见联合比较约定
        let els = Html4cj.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select("P.One")
        // 片段编号：C042
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(2), els.size)
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第49行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(2), els.size)
        // 片段编号：C043
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("0", els[0].id())
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第50行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("0", els[0].id())
        // 片段编号：C044
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert("1", els[1].id())
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第51行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert("1", els[1].id())
        // 片段编号：C045
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let none = Html4cj.parse("<div class='one'></div>").select(".foo")
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第52行
        // 待确认：无；完整接口前提见联合比较约定
        let none = Html4cj.parse("<div class='one'></div>").select(".foo")
        // 片段编号：C046
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(0), none.size)
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第53行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(0), none.size)
        // 片段编号：C047
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：let els2 = Html4cj.parse("<div class='One-Two'></div>").select(".one-two")
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第54行
        // 待确认：无；完整接口前提见联合比较约定
        let els2 = Html4cj.parse("<div class='One-Two'></div>").select(".one-two")
        // 片段编号：C048
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：@Assert(Int64(1), els2.size)
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：translated_test.cj原文第55行
        // 待确认：无；完整接口前提见联合比较约定
        @Assert(Int64(1), els2.size)
    }
}
