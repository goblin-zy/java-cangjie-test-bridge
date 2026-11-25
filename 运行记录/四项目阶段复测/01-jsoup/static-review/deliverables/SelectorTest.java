// 片段编号：J001
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：package org.jsoup.select;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第1行
// 待确认：无；完整接口前提见联合比较约定
package org.jsoup.select;

// 片段编号：J002
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.Jsoup;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第3行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.Jsoup;
// 片段编号：J003
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.MultiLocaleExtension.MultiLocaleTest;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第4行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.MultiLocaleExtension.MultiLocaleTest;
// 片段编号：J004
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.TextUtil;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第5行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.TextUtil;
// 片段编号：J005
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.nodes.Document;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第6行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.nodes.Document;
// 片段编号：J006
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.nodes.Element;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第7行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.nodes.Element;
// 片段编号：J007
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.jsoup.parser.Parser;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第8行
// 待确认：无；完整接口前提见联合比较约定
import org.jsoup.parser.Parser;
// 片段编号：J008
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.junit.jupiter.api.Test;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第9行
// 待确认：无；完整接口前提见联合比较约定
import org.junit.jupiter.api.Test;

// 片段编号：J009
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import java.util.Locale;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第11行
// 待确认：无；完整接口前提见联合比较约定
import java.util.Locale;

// 片段编号：J010
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import static org.junit.jupiter.api.Assertions.*;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第13行
// 待确认：无；完整接口前提见联合比较约定
import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests that the selector selects correctly.
 *
 * @author Jonathan Hedley, jonathan@hedley.net
 */
// 片段编号：J011
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：public class SelectorTest {
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：SelectorTest.java原文第20行
// 待确认：无；完整接口前提见联合比较约定
public class SelectorTest {
    // 片段编号：J012
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByTag() {
    // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：SelectorTest.java原文第21行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByTag() {
        // should be case insensitive
        // 片段编号：J013
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = Jsoup.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV");
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第23行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = Jsoup.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV");
        // 片段编号：J014
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, els.size());
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第24行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, els.size());
        // 片段编号：J015
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", els.get(0).id());
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第25行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", els.get(0).id());
        // 片段编号：J016
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", els.get(1).id());
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第26行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", els.get(1).id());
        // 片段编号：J017
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", els.get(2).id());
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第27行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", els.get(2).id());

        // 片段编号：J018
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements none = Jsoup.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span");
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第29行
        // 待确认：无；完整接口前提见联合比较约定
        Elements none = Jsoup.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span");
        // 片段编号：J019
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, none.size());
        // 关联：testByTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第30行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, none.size());
    }

    // 片段编号：J020
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void byEscapedTag() {
    // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：SelectorTest.java原文第33行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void byEscapedTag() {
        // tested same result as js document.querySelector
        // 片段编号：J021
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p.p>One</p.p> <p\\p>Two</p\\p>");
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第35行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p.p>One</p.p> <p\\p>Two</p\\p>");

        // 片段编号：J022
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element one = doc.expectFirst("p\\.p");
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第37行
        // 待确认：无；完整接口前提见联合比较约定
        Element one = doc.expectFirst("p\\.p");
        // 片段编号：J023
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", one.text());
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第38行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", one.text());

        // 片段编号：J024
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element two = doc.expectFirst("p\\\\p");
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第40行
        // 待确认：无；完整接口前提见联合比较约定
        Element two = doc.expectFirst("p\\\\p");
        // 片段编号：J025
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", two.text());
        // 关联：byEscapedTag本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第41行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", two.text());
    }

    // 片段编号：J026
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testById() {
    // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：SelectorTest.java原文第44行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testById() {
        // 片段编号：J027
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = Jsoup.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo");
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第45行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = Jsoup.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo");
        // 片段编号：J028
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, els.size());
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第46行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, els.size());
        // 片段编号：J029
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", els.get(0).text());
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第47行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", els.get(0).text());
        // 片段编号：J030
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Foo two!", els.get(1).text());
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第48行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Foo two!", els.get(1).text());

        // 片段编号：J031
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements none = Jsoup.parse("<div id=1></div>").select("#foo");
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第50行
        // 待确认：无；完整接口前提见联合比较约定
        Elements none = Jsoup.parse("<div id=1></div>").select("#foo");
        // 片段编号：J032
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, none.size());
        // 关联：testById本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第51行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, none.size());
    }

    // 片段编号：J033
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void byEscapedId() {
    // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：SelectorTest.java原文第54行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void byEscapedId() {
        // 片段编号：J034
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>");
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第55行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>");

        // 片段编号：J035
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element one = doc.expectFirst("#i\\.d");
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第57行
        // 待确认：无；完整接口前提见联合比较约定
        Element one = doc.expectFirst("#i\\.d");
        // 片段编号：J036
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", one.text());
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第58行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", one.text());

        // 片段编号：J037
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element two = doc.expectFirst("#i\\\\d");
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第60行
        // 待确认：无；完整接口前提见联合比较约定
        Element two = doc.expectFirst("#i\\\\d");
        // 片段编号：J038
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", two.text());
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第61行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", two.text());

        // 片段编号：J039
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element thr = doc.expectFirst("p#one-two\\/three");
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第63行
        // 待确认：无；完整接口前提见联合比较约定
        Element thr = doc.expectFirst("p#one-two\\/three");
        // 片段编号：J040
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", thr.text());
        // 关联：byEscapedId本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第64行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", thr.text());
    }

    // 片段编号：J041
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByClass() {
    // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：SelectorTest.java原文第67行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByClass() {
        // 片段编号：J042
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = Jsoup.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select("P.One");
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第68行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = Jsoup.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select("P.One");
        // 片段编号：J043
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, els.size());
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第69行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, els.size());
        // 片段编号：J044
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("0", els.get(0).id());
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第70行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("0", els.get(0).id());
        // 片段编号：J045
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", els.get(1).id());
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第71行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", els.get(1).id());

        // 片段编号：J046
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements none = Jsoup.parse("<div class='one'></div>").select(".foo");
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第73行
        // 待确认：无；完整接口前提见联合比较约定
        Elements none = Jsoup.parse("<div class='one'></div>").select(".foo");
        // 片段编号：J047
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, none.size());
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第74行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, none.size());

        // 片段编号：J048
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els2 = Jsoup.parse("<div class='One-Two'></div>").select(".one-two");
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第76行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els2 = Jsoup.parse("<div class='One-Two'></div>").select(".one-two");
        // 片段编号：J049
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els2.size());
        // 关联：testByClass本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：SelectorTest.java原文第77行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els2.size());
    }

    // 片段编号：J050
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void byEscapedClass() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第80行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void byEscapedClass() {
        // 片段编号：J051
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element els = Jsoup.parse("<p class='one.two#three'>One</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第81行
        // 待确认：无；完整接口前提见联合比较约定
        Element els = Jsoup.parse("<p class='one.two#three'>One</p>");

        // 片段编号：J052
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element one = els.expectFirst("p.one\\.two\\#three");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第83行
        // 待确认：无；完整接口前提见联合比较约定
        Element one = els.expectFirst("p.one\\.two\\#three");
        // 片段编号：J053
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", one.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第84行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", one.text());
    }

    // 片段编号：J054
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByClassCaseInsensitive() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第87行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByClassCaseInsensitive() {
        // 片段编号：J055
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p Class=foo>One <p Class=Foo>Two <p class=FOO>Three <p class=farp>Four";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第88行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p Class=foo>One <p Class=Foo>Two <p class=FOO>Three <p class=farp>Four";
        // 片段编号：J056
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements elsFromClass = Jsoup.parse(html).select("P.Foo");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第89行
        // 待确认：无；完整接口前提见联合比较约定
        Elements elsFromClass = Jsoup.parse(html).select("P.Foo");
        // 片段编号：J057
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements elsFromAttr = Jsoup.parse(html).select("p[class=foo]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第90行
        // 待确认：无；完整接口前提见联合比较约定
        Elements elsFromAttr = Jsoup.parse(html).select("p[class=foo]");

        // 片段编号：J058
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(elsFromAttr.size(), elsFromClass.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第92行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(elsFromAttr.size(), elsFromClass.size());
        // 片段编号：J059
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, elsFromClass.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第93行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, elsFromClass.size());
        // 片段编号：J060
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", elsFromClass.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第94行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", elsFromClass.get(1).text());
    }


    // 片段编号：J061
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@MultiLocaleTest
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第98行
    // 待确认：无；完整接口前提见联合比较约定
    @MultiLocaleTest
    // 片段编号：J062
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testByAttribute(Locale locale) {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第99行
    // 待确认：无；完整接口前提见联合比较约定
    public void testByAttribute(Locale locale) {
        // 片段编号：J063
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Locale.setDefault(locale);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第100行
        // 待确认：无；完整接口前提见联合比较约定
        Locale.setDefault(locale);

        // 片段编号：J064
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第102行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
                // 片段编号：J065
                // 环节：初始化与准备
                // 维度：声明与准备
                // 内容：保留声明、对象或操作："<div data-name='with spaces'/>";
                // 关联：供本类测试使用的包、框架、声明或辅助结构。
                // 依据：SelectorTest.java原文第103行
                // 待确认：无；完整接口前提见联合比较约定
                "<div data-name='with spaces'/>";
        // 片段编号：J066
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第104行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J067
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements withTitle = doc.select("[title]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第106行
        // 待确认：无；完整接口前提见联合比较约定
        Elements withTitle = doc.select("[title]");
        // 片段编号：J068
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(4, withTitle.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第107行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(4, withTitle.size());

        // 片段编号：J069
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements foo = doc.select("[TITLE=foo]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第109行
        // 待确认：无；完整接口前提见联合比较约定
        Elements foo = doc.select("[TITLE=foo]");
        // 片段编号：J070
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, foo.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第110行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, foo.size());

        // 片段编号：J071
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements foo2 = doc.select("[title=\"foo\"]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第112行
        // 待确认：无；完整接口前提见联合比较约定
        Elements foo2 = doc.select("[title=\"foo\"]");
        // 片段编号：J072
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, foo2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第113行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, foo2.size());

        // 片段编号：J073
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements foo3 = doc.select("[title=\"Foo\"]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第115行
        // 待确认：无；完整接口前提见联合比较约定
        Elements foo3 = doc.select("[title=\"Foo\"]");
        // 片段编号：J074
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, foo3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第116行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, foo3.size());

        // 片段编号：J075
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataName = doc.select("[data-name=\"with spaces\"]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第118行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataName = doc.select("[data-name=\"with spaces\"]");
        // 片段编号：J076
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, dataName.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第119行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, dataName.size());
        // 片段编号：J077
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("with spaces", dataName.first().attr("data-name"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第120行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("with spaces", dataName.first().attr("data-name"));

        // 片段编号：J078
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements not = doc.select("div[title!=bar]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第122行
        // 待确认：无；完整接口前提见联合比较约定
        Elements not = doc.select("div[title!=bar]");
        // 片段编号：J079
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(5, not.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第123行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(5, not.size());
        // 片段编号：J080
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Foo", not.first().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第124行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Foo", not.first().attr("title"));

        // 片段编号：J081
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements starts = doc.select("[title^=ba]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第126行
        // 待确认：无；完整接口前提见联合比较约定
        Elements starts = doc.select("[title^=ba]");
        // 片段编号：J082
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, starts.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第127行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, starts.size());
        // 片段编号：J083
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Bar", starts.first().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第128行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Bar", starts.first().attr("title"));
        // 片段编号：J084
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Balim", starts.last().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第129行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Balim", starts.last().attr("title"));

        // 片段编号：J085
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ends = doc.select("[title$=im]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第131行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ends = doc.select("[title$=im]");
        // 片段编号：J086
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, ends.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第132行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, ends.size());
        // 片段编号：J087
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Balim", ends.first().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第133行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Balim", ends.first().attr("title"));
        // 片段编号：J088
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("SLIM", ends.last().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第134行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("SLIM", ends.last().attr("title"));

        // 片段编号：J089
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements contains = doc.select("[title*=i]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第136行
        // 待确认：无；完整接口前提见联合比较约定
        Elements contains = doc.select("[title*=i]");
        // 片段编号：J090
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, contains.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第137行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, contains.size());
        // 片段编号：J091
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Balim", contains.first().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第138行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Balim", contains.first().attr("title"));
        // 片段编号：J092
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("SLIM", contains.last().attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第139行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("SLIM", contains.last().attr("title"));
    }

    // 片段编号：J093
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testNamespacedTag() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第142行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testNamespacedTag() {
        // 片段编号：J094
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第143行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>");
        // 片段编号：J095
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTag = doc.select("abc|def");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第144行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTag = doc.select("abc|def");
        // 片段编号：J096
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byTag.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第145行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byTag.size());
        // 片段编号：J097
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byTag.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第146行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byTag.first().id());
        // 片段编号：J098
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTag.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第147行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTag.last().id());

        // 片段编号：J099
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byAttr = doc.select(".bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第149行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byAttr = doc.select(".bold");
        // 片段编号：J100
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第150行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byAttr.size());
        // 片段编号：J101
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第151行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byAttr.last().id());

        // 片段编号：J102
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTagAttr = doc.select("abc|def.bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第153行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTagAttr = doc.select("abc|def.bold");
        // 片段编号：J103
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byTagAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第154行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byTagAttr.size());
        // 片段编号：J104
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTagAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第155行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTagAttr.last().id());

        // 片段编号：J105
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byContains = doc.select("abc|def:contains(e)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第157行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byContains = doc.select("abc|def:contains(e)");
        // 片段编号：J106
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byContains.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第158行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byContains.size());
        // 片段编号：J107
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byContains.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第159行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byContains.first().id());
        // 片段编号：J108
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byContains.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第160行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byContains.last().id());
    }

    // 片段编号：J109
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testWildcardNamespacedTag() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第163行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testWildcardNamespacedTag() {
        // 片段编号：J110
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第164行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>");
        // 片段编号：J111
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTag = doc.select("*|def");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第165行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTag = doc.select("*|def");
        // 片段编号：J112
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byTag.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第166行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byTag.size());
        // 片段编号：J113
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byTag.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第167行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byTag.first().id());
        // 片段编号：J114
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTag.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第168行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTag.last().id());

        // 片段编号：J115
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byAttr = doc.select(".bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第170行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byAttr = doc.select(".bold");
        // 片段编号：J116
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第171行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byAttr.size());
        // 片段编号：J117
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第172行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byAttr.last().id());

        // 片段编号：J118
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTagAttr = doc.select("*|def.bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第174行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTagAttr = doc.select("*|def.bold");
        // 片段编号：J119
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byTagAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第175行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byTagAttr.size());
        // 片段编号：J120
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTagAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第176行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTagAttr.last().id());

        // 片段编号：J121
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byContains = doc.select("*|def:contains(e)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第178行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byContains = doc.select("*|def:contains(e)");
        // 片段编号：J122
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byContains.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第179行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byContains.size());
        // 片段编号：J123
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byContains.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第180行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byContains.first().id());
        // 片段编号：J124
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byContains.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第181行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byContains.last().id());
    }

    // 片段编号：J125
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testWildcardNamespacedXmlTag() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第184行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testWildcardNamespacedXmlTag() {
        // 片段编号：J126
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第185行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(
            // 片段编号：J127
            // 环节：初始化与准备
            // 维度：声明与准备
            // 内容：保留声明、对象或操作："<div><Abc:Def id=1>Hello</Abc:Def></div> <Abc:Def class=bold id=2>There</abc:def>",
            // 关联：供本类测试使用的包、框架、声明或辅助结构。
            // 依据：SelectorTest.java原文第186行
            // 待确认：无；完整接口前提见联合比较约定
            "<div><Abc:Def id=1>Hello</Abc:Def></div> <Abc:Def class=bold id=2>There</abc:def>",
            // 片段编号：J128
            // 环节：初始化与准备
            // 维度：声明与准备
            // 内容：保留声明、对象或操作："", Parser.xmlParser()
            // 关联：供本类测试使用的包、框架、声明或辅助结构。
            // 依据：SelectorTest.java原文第187行
            // 待确认：无；完整接口前提见联合比较约定
            "", Parser.xmlParser()
        // 片段编号：J129
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第188行
        // 待确认：无；完整接口前提见联合比较约定
        );

        // 片段编号：J130
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTag = doc.select("*|Def");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第190行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTag = doc.select("*|Def");
        // 片段编号：J131
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byTag.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第191行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byTag.size());
        // 片段编号：J132
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byTag.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第192行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byTag.first().id());
        // 片段编号：J133
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTag.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第193行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTag.last().id());

        // 片段编号：J134
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byAttr = doc.select(".bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第195行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byAttr = doc.select(".bold");
        // 片段编号：J135
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第196行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byAttr.size());
        // 片段编号：J136
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第197行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byAttr.last().id());

        // 片段编号：J137
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byTagAttr = doc.select("*|Def.bold");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第199行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byTagAttr = doc.select("*|Def.bold");
        // 片段编号：J138
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, byTagAttr.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第200行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, byTagAttr.size());
        // 片段编号：J139
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byTagAttr.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第201行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byTagAttr.last().id());

        // 片段编号：J140
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements byContains = doc.select("*|Def:contains(e)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第203行
        // 待确认：无；完整接口前提见联合比较约定
        Elements byContains = doc.select("*|Def:contains(e)");
        // 片段编号：J141
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, byContains.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第204行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, byContains.size());
        // 片段编号：J142
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", byContains.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第205行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", byContains.first().id());
        // 片段编号：J143
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", byContains.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第206行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", byContains.last().id());
    }

    // 片段编号：J144
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testWildCardNamespacedCaseVariations() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第209行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testWildCardNamespacedCaseVariations() {
        // 片段编号：J145
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<One:Two>One</One:Two><three:four>Two</three:four>", "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第210行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<One:Two>One</One:Two><three:four>Two</three:four>", "", Parser.xmlParser());
        // 片段编号：J146
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els1 = doc.select("One|Two");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第211行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els1 = doc.select("One|Two");
        // 片段编号：J147
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els2 = doc.select("one|two");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第212行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els2 = doc.select("one|two");
        // 片段编号：J148
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els3 = doc.select("Three|Four");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第213行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els3 = doc.select("Three|Four");
        // 片段编号：J149
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els4 = doc.select("three|Four");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第214行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els4 = doc.select("three|Four");

        // 片段编号：J150
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(els1, els2);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第216行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(els1, els2);
        // 片段编号：J151
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(els3, els4);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第217行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(els3, els4);
        // 片段编号：J152
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", els1.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第218行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", els1.text());
        // 片段编号：J153
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第219行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els1.size());
        // 片段编号：J154
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", els3.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第220行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", els3.text());
        // 片段编号：J155
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第221行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els2.size());
    }

    // 片段编号：J156
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@MultiLocaleTest
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第224行
    // 待确认：无；完整接口前提见联合比较约定
    @MultiLocaleTest
    // 片段编号：J157
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testByAttributeStarting(Locale locale) {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第225行
    // 待确认：无；完整接口前提见联合比较约定
    public void testByAttributeStarting(Locale locale) {
        // 片段编号：J158
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Locale.setDefault(locale);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第226行
        // 待确认：无；完整接口前提见联合比较约定
        Locale.setDefault(locale);

        // 片段编号：J159
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第228行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>");
        // 片段编号：J160
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements withData = doc.select("[^data-]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第229行
        // 待确认：无；完整接口前提见联合比较约定
        Elements withData = doc.select("[^data-]");
        // 片段编号：J161
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, withData.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第230行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, withData.size());
        // 片段编号：J162
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", withData.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第231行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", withData.first().id());
        // 片段编号：J163
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", withData.last().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第232行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", withData.last().id());

        // 片段编号：J164
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：withData = doc.select("p[^data-]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第234行
        // 待确认：无；完整接口前提见联合比较约定
        withData = doc.select("p[^data-]");
        // 片段编号：J165
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, withData.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第235行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, withData.size());
        // 片段编号：J166
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", withData.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第236行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", withData.first().id());

        // 片段编号：J167
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("[^attrib]").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第238行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("[^attrib]").size());
    }

    // 片段编号：J168
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByAttributeRegex() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第241行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByAttributeRegex() {
        // 片段编号：J169
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif><img></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第242行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif><img></p>");
        // 片段编号：J170
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements imgs = doc.select("img[src~=(?i)\\.(png|jpe?g)]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第243行
        // 待确认：无；完整接口前提见联合比较约定
        Elements imgs = doc.select("img[src~=(?i)\\.(png|jpe?g)]");
        // 片段编号：J171
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, imgs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第244行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, imgs.size());
        // 片段编号：J172
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", imgs.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第245行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", imgs.get(0).id());
        // 片段编号：J173
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", imgs.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第246行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", imgs.get(1).id());
        // 片段编号：J174
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", imgs.get(2).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第247行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", imgs.get(2).id());
    }

    // 片段编号：J175
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByAttributeRegexCharacterClass() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第250行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByAttributeRegexCharacterClass() {
        // 片段编号：J176
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif id=4></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第251行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif id=4></p>");
        // 片段编号：J177
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements imgs = doc.select("img[src~=[o]]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第252行
        // 待确认：无；完整接口前提见联合比较约定
        Elements imgs = doc.select("img[src~=[o]]");
        // 片段编号：J178
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, imgs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第253行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, imgs.size());
        // 片段编号：J179
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", imgs.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第254行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", imgs.get(0).id());
        // 片段编号：J180
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("4", imgs.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第255行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("4", imgs.get(1).id());
    }

    // 片段编号：J181
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testByAttributeRegexCombined() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第258行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testByAttributeRegexCombined() {
        // 片段编号：J182
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><table class=x><td>Hello</td></table></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第259行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><table class=x><td>Hello</td></table></div>");
        // 片段编号：J183
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("div table[class~=x|y]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第260行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("div table[class~=x|y]");
        // 片段编号：J184
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第261行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J185
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", els.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第262行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", els.text());
    }

    // 片段编号：J186
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testCombinedWithContains() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第265行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testCombinedWithContains() {
        // 片段编号：J187
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>One</p><p>Two +</p><p>Three +</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第266行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>One</p><p>Two +</p><p>Three +</p>");
        // 片段编号：J188
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("p#1 + :contains(+)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第267行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("p#1 + :contains(+)");
        // 片段编号：J189
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第268行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J190
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two +", els.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第269行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two +", els.text());
        // 片段编号：J191
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", els.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第270行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", els.first().tagName());
    }

    // 片段编号：J192
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testAllElements() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第273行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testAllElements() {
        // 片段编号：J193
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div><p>Hello</p><p><b>there</b></p></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第274行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div><p>Hello</p><p><b>there</b></p></div>";
        // 片段编号：J194
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第275行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J195
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements allDoc = doc.select("*");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第276行
        // 待确认：无；完整接口前提见联合比较约定
        Elements allDoc = doc.select("*");
        // 片段编号：J196
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements allUnderDiv = doc.select("div *");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第277行
        // 待确认：无；完整接口前提见联合比较约定
        Elements allUnderDiv = doc.select("div *");
        // 片段编号：J197
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(8, allDoc.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第278行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(8, allDoc.size());
        // 片段编号：J198
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, allUnderDiv.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第279行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, allUnderDiv.size());
        // 片段编号：J199
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", allUnderDiv.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第280行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", allUnderDiv.first().tagName());
    }

    // 片段编号：J200
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testAllWithClass() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第283行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testAllWithClass() {
        // 片段编号：J201
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<p class=first>One<p class=first>Two<p>Three";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第284行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<p class=first>One<p class=first>Two<p>Three";
        // 片段编号：J202
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第285行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J203
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("*.first");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第286行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("*.first");
        // 片段编号：J204
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第287行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, ps.size());
    }

    // 片段编号：J205
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testGroupOr() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第290行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testGroupOr() {
        // 片段编号：J206
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div title=foo /><div title=bar /><div /><p></p><img /><span title=qux>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第291行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div title=foo /><div title=bar /><div /><p></p><img /><span title=qux>";
        // 片段编号：J207
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第292行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J208
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("p,div,[title]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第293行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("p,div,[title]");

        // 片段编号：J209
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(5, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第295行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(5, els.size());
        // 片段编号：J210
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", els.get(0).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第296行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", els.get(0).tagName());
        // 片段编号：J211
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("foo", els.get(0).attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第297行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("foo", els.get(0).attr("title"));
        // 片段编号：J212
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", els.get(1).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第298行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", els.get(1).tagName());
        // 片段编号：J213
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("bar", els.get(1).attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第299行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("bar", els.get(1).attr("title"));
        // 片段编号：J214
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", els.get(2).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第300行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", els.get(2).tagName());
        // 片段编号：J215
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, els.get(2).attr("title").length()); // missing attributes come back as empty string
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第301行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, els.get(2).attr("title").length()); // missing attributes come back as empty string
        // 片段编号：J216
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertFalse(els.get(2).hasAttr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第302行
        // 待确认：无；完整接口前提见联合比较约定
        assertFalse(els.get(2).hasAttr("title"));
        // 片段编号：J217
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", els.get(3).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第303行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", els.get(3).tagName());
        // 片段编号：J218
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", els.get(4).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第304行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", els.get(4).tagName());
    }

    // 片段编号：J219
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testGroupOrAttribute() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第307行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testGroupOrAttribute() {
        // 片段编号：J220
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div id=1 /><div id=2 /><div title=foo /><div title=bar />";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第308行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div id=1 /><div id=2 /><div title=foo /><div title=bar />";
        // 片段编号：J221
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = Jsoup.parse(h).select("[id],[title=foo]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第309行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = Jsoup.parse(h).select("[id],[title=foo]");

        // 片段编号：J222
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第311行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, els.size());
        // 片段编号：J223
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", els.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第312行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", els.get(0).id());
        // 片段编号：J224
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", els.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第313行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", els.get(1).id());
        // 片段编号：J225
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("foo", els.get(2).attr("title"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第314行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("foo", els.get(2).attr("title"));
    }

    // 片段编号：J226
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void descendant() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第317行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void descendant() {
        // 片段编号：J227
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div class=head><p class=first>Hello</p><p>There</p></div><p>None</p>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第318行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div class=head><p class=first>Hello</p><p>There</p></div><p>None</p>";
        // 片段编号：J228
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第319行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J229
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element root = doc.getElementsByClass("HEAD").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第320行
        // 待确认：无；完整接口前提见联合比较约定
        Element root = doc.getElementsByClass("HEAD").first();

        // 片段编号：J230
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = root.select(".head p");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第322行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = root.select(".head p");
        // 片段编号：J231
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第323行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, els.size());
        // 片段编号：J232
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", els.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第324行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", els.get(0).text());
        // 片段编号：J233
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("There", els.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第325行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("There", els.get(1).text());

        // 片段编号：J234
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p = root.select("p.first");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第327行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p = root.select("p.first");
        // 片段编号：J235
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第328行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p.size());
        // 片段编号：J236
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", p.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第329行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", p.get(0).text());

        // 片段编号：J237
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements empty = root.select("p .first"); // self, not descend, should not match
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第331行
        // 待确认：无；完整接口前提见联合比较约定
        Elements empty = root.select("p .first"); // self, not descend, should not match
        // 片段编号：J238
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, empty.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第332行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, empty.size());

        // 片段编号：J239
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements aboveRoot = root.select("body div.head");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第334行
        // 待确认：无；完整接口前提见联合比较约定
        Elements aboveRoot = root.select("body div.head");
        // 片段编号：J240
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, aboveRoot.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第335行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, aboveRoot.size());
    }

    // 片段编号：J241
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void and() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第338行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void and() {
        // 片段编号：J242
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div id=1 class='foo bar' title=bar name=qux><p class=foo title=bar>Hello</p></div";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第339行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div id=1 class='foo bar' title=bar name=qux><p class=foo title=bar>Hello</p></div";
        // 片段编号：J243
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第340行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J244
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements div = doc.select("div.foo");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第342行
        // 待确认：无；完整接口前提见联合比较约定
        Elements div = doc.select("div.foo");
        // 片段编号：J245
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, div.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第343行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, div.size());
        // 片段编号：J246
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", div.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第344行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", div.first().tagName());

        // 片段编号：J247
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p = doc.select("div .foo"); // space indicates like "div *.foo"
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第346行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p = doc.select("div .foo"); // space indicates like "div *.foo"
        // 片段编号：J248
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第347行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p.size());
        // 片段编号：J249
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", p.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第348行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", p.first().tagName());

        // 片段编号：J250
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements div2 = doc.select("div#1.foo.bar[title=bar][name=qux]"); // very specific!
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第350行
        // 待确认：无；完整接口前提见联合比较约定
        Elements div2 = doc.select("div#1.foo.bar[title=bar][name=qux]"); // very specific!
        // 片段编号：J251
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, div2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第351行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, div2.size());
        // 片段编号：J252
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", div2.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第352行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", div2.first().tagName());

        // 片段编号：J253
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p2 = doc.select("div *.foo"); // space indicates like "div *.foo"
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第354行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p2 = doc.select("div *.foo"); // space indicates like "div *.foo"
        // 片段编号：J254
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第355行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p2.size());
        // 片段编号：J255
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", p2.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第356行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", p2.first().tagName());
    }

    // 片段编号：J256
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void deeperDescendant() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第359行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void deeperDescendant() {
        // 片段编号：J257
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div class=head><p><span class=first>Hello</div><div class=head><p class=first><span>Another</span><p>Again</div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第360行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div class=head><p><span class=first>Hello</div><div class=head><p class=first><span>Another</span><p>Again</div>";
        // 片段编号：J258
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第361行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J259
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element root = doc.getElementsByClass("head").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第362行
        // 待确认：无；完整接口前提见联合比较约定
        Element root = doc.getElementsByClass("head").first();

        // 片段编号：J260
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = root.select("div p .first");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第364行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = root.select("div p .first");
        // 片段编号：J261
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第365行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J262
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", els.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第366行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", els.first().text());
        // 片段编号：J263
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", els.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第367行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", els.first().tagName());

        // 片段编号：J264
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements aboveRoot = root.select("body p .first");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第369行
        // 待确认：无；完整接口前提见联合比较约定
        Elements aboveRoot = root.select("body p .first");
        // 片段编号：J265
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, aboveRoot.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第370行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, aboveRoot.size());
    }

    // 片段编号：J266
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void parentChildElement() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第373行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void parentChildElement() {
        // 片段编号：J267
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div id=1><div id=2><div id = 3></div></div></div><div id=4></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第374行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div id=1><div id=2><div id = 3></div></div></div><div id=4></div>";
        // 片段编号：J268
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第375行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J269
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divs = doc.select("div > div");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第377行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divs = doc.select("div > div");
        // 片段编号：J270
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, divs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第378行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, divs.size());
        // 片段编号：J271
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", divs.get(0).id()); // 2 is child of 1
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第379行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", divs.get(0).id()); // 2 is child of 1
        // 片段编号：J272
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", divs.get(1).id()); // 3 is child of 2
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第380行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", divs.get(1).id()); // 3 is child of 2

        // 片段编号：J273
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements div2 = doc.select("div#1 > div");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第382行
        // 待确认：无；完整接口前提见联合比较约定
        Elements div2 = doc.select("div#1 > div");
        // 片段编号：J274
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, div2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第383行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, div2.size());
        // 片段编号：J275
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", div2.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第384行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", div2.get(0).id());
    }

    // 片段编号：J276
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void parentWithClassChild() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第387行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void parentWithClassChild() {
        // 片段编号：J277
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<h1 class=foo><a href=1 /></h1><h1 class=foo><a href=2 class=bar /></h1><h1><a href=3 /></h1>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第388行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<h1 class=foo><a href=1 /></h1><h1 class=foo><a href=2 class=bar /></h1><h1><a href=3 /></h1>";
        // 片段编号：J278
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第389行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J279
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements allAs = doc.select("h1 > a");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第391行
        // 待确认：无；完整接口前提见联合比较约定
        Elements allAs = doc.select("h1 > a");
        // 片段编号：J280
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, allAs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第392行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, allAs.size());
        // 片段编号：J281
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("a", allAs.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第393行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("a", allAs.first().tagName());

        // 片段编号：J282
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements fooAs = doc.select("h1.foo > a");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第395行
        // 待确认：无；完整接口前提见联合比较约定
        Elements fooAs = doc.select("h1.foo > a");
        // 片段编号：J283
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, fooAs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第396行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, fooAs.size());
        // 片段编号：J284
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("a", fooAs.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第397行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("a", fooAs.first().tagName());

        // 片段编号：J285
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements barAs = doc.select("h1.foo > a.bar");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第399行
        // 待确认：无；完整接口前提见联合比较约定
        Elements barAs = doc.select("h1.foo > a.bar");
        // 片段编号：J286
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, barAs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第400行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, barAs.size());
    }

    // 片段编号：J287
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void parentChildStar() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第403行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void parentChildStar() {
        // 片段编号：J288
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div id=1><p>Hello<p><b>there</b></p></div><div id=2><span>Hi</span></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第404行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div id=1><p>Hello<p><b>there</b></p></div><div id=2><span>Hi</span></div>";
        // 片段编号：J289
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第405行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J290
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divChilds = doc.select("div > *");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第406行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divChilds = doc.select("div > *");
        // 片段编号：J291
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, divChilds.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第407行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, divChilds.size());
        // 片段编号：J292
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", divChilds.get(0).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第408行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", divChilds.get(0).tagName());
        // 片段编号：J293
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", divChilds.get(1).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第409行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", divChilds.get(1).tagName());
        // 片段编号：J294
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", divChilds.get(2).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第410行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", divChilds.get(2).tagName());
    }

    // 片段编号：J295
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void multiChildDescent() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第413行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void multiChildDescent() {
        // 片段编号：J296
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div id=foo><h1 class=bar><a href=http://example.com/>One</a></h1></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第414行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div id=foo><h1 class=bar><a href=http://example.com/>One</a></h1></div>";
        // 片段编号：J297
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第415行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J298
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("div#foo > h1.bar > a[href*=example]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第416行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("div#foo > h1.bar > a[href*=example]");
        // 片段编号：J299
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第417行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J300
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("a", els.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第418行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("a", els.first().tagName());
    }

    // 片段编号：J301
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void caseInsensitive() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第421行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void caseInsensitive() {
        // 片段编号：J302
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<dIv tItle=bAr><div>"; // mixed case so a simple toLowerCase() on value doesn't catch
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第422行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<dIv tItle=bAr><div>"; // mixed case so a simple toLowerCase() on value doesn't catch
        // 片段编号：J303
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第423行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J304
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, doc.select("DiV").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第425行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, doc.select("DiV").size());
        // 片段编号：J305
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("DiV[TiTLE]").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第426行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("DiV[TiTLE]").size());
        // 片段编号：J306
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("DiV[TiTLE=BAR]").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第427行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("DiV[TiTLE=BAR]").size());
        // 片段编号：J307
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("DiV[TiTLE=BARBARELLA]").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第428行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("DiV[TiTLE=BARBARELLA]").size());
    }

    // 片段编号：J308
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void adjacentSiblings() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第431行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void adjacentSiblings() {
        // 片段编号：J309
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<ol><li>One<li>Two<li>Three</ol>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第432行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<ol><li>One<li>Two<li>Three</ol>";
        // 片段编号：J310
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第433行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J311
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements sibs = doc.select("li + li");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第434行
        // 待确认：无；完整接口前提见联合比较约定
        Elements sibs = doc.select("li + li");
        // 片段编号：J312
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, sibs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第435行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, sibs.size());
        // 片段编号：J313
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", sibs.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第436行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", sibs.get(0).text());
        // 片段编号：J314
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", sibs.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第437行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", sibs.get(1).text());
    }

    // 片段编号：J315
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void adjacentSiblingsWithId() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第440行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void adjacentSiblingsWithId() {
        // 片段编号：J316
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第441行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 片段编号：J317
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第442行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J318
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements sibs = doc.select("li#1 + li#2");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第443行
        // 待确认：无；完整接口前提见联合比较约定
        Elements sibs = doc.select("li#1 + li#2");
        // 片段编号：J319
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, sibs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第444行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, sibs.size());
        // 片段编号：J320
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", sibs.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第445行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", sibs.get(0).text());
    }

    // 片段编号：J321
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void notAdjacent() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第448行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void notAdjacent() {
        // 片段编号：J322
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第449行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 片段编号：J323
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第450行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J324
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements sibs = doc.select("li#1 + li#3");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第451行
        // 待确认：无；完整接口前提见联合比较约定
        Elements sibs = doc.select("li#1 + li#3");
        // 片段编号：J325
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, sibs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第452行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, sibs.size());
    }

    // 片段编号：J326
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void mixCombinator() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第455行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void mixCombinator() {
        // 片段编号：J327
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第456行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>";
        // 片段编号：J328
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第457行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J329
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements sibs = doc.select("body > div.foo li + li");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第458行
        // 待确认：无；完整接口前提见联合比较约定
        Elements sibs = doc.select("body > div.foo li + li");

        // 片段编号：J330
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, sibs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第460行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, sibs.size());
        // 片段编号：J331
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", sibs.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第461行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", sibs.get(0).text());
        // 片段编号：J332
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", sibs.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第462行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", sibs.get(1).text());
    }

    // 片段编号：J333
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void mixCombinatorGroup() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第465行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void mixCombinatorGroup() {
        // 片段编号：J334
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第466行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>";
        // 片段编号：J335
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第467行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J336
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select(".foo > ol, ol > li + li");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第468行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select(".foo > ol, ol > li + li");

        // 片段编号：J337
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第470行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, els.size());
        // 片段编号：J338
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("ol", els.get(0).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第471行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("ol", els.get(0).tagName());
        // 片段编号：J339
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", els.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第472行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", els.get(1).text());
        // 片段编号：J340
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", els.get(2).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第473行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", els.get(2).text());
    }

    // 片段编号：J341
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void generalSiblings() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第476行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void generalSiblings() {
        // 片段编号：J342
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第477行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>";
        // 片段编号：J343
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第478行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);
        // 片段编号：J344
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("#1 ~ #3");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第479行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("#1 ~ #3");
        // 片段编号：J345
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第480行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J346
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", els.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第481行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", els.first().text());
    }

    // for http://github.com/jhy/jsoup/issues#issue/10
    // 片段编号：J347
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testCharactersInIdAndClass() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第485行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testCharactersInIdAndClass() {
        // using CSS spec for identifiers (id and class): a-z0-9, -, _. NOT . (which is OK in html spec, but not css)
        // 片段编号：J348
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div><p id='a1-foo_bar'>One</p><p class='b2-qux_bif'>Two</p></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第487行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div><p id='a1-foo_bar'>One</p><p class='b2-qux_bif'>Two</p></div>";
        // 片段编号：J349
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第488行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J350
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element el1 = doc.getElementById("a1-foo_bar");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第490行
        // 待确认：无；完整接口前提见联合比较约定
        Element el1 = doc.getElementById("a1-foo_bar");
        // 片段编号：J351
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", el1.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第491行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", el1.text());
        // 片段编号：J352
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element el2 = doc.getElementsByClass("b2-qux_bif").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第492行
        // 待确认：无；完整接口前提见联合比较约定
        Element el2 = doc.getElementsByClass("b2-qux_bif").first();
        // 片段编号：J353
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", el2.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第493行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", el2.text());

        // 片段编号：J354
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element el3 = doc.select("#a1-foo_bar").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第495行
        // 待确认：无；完整接口前提见联合比较约定
        Element el3 = doc.select("#a1-foo_bar").first();
        // 片段编号：J355
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", el3.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第496行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", el3.text());
        // 片段编号：J356
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element el4 = doc.select(".b2-qux_bif").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第497行
        // 待确认：无；完整接口前提见联合比较约定
        Element el4 = doc.select(".b2-qux_bif").first();
        // 片段编号：J357
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", el4.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第498行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", el4.text());
    }

    // for http://github.com/jhy/jsoup/issues#issue/13
    // 片段编号：J358
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testSupportsLeadingCombinator() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第502行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testSupportsLeadingCombinator() {
        // 片段编号：J359
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String h = "<div><p><span>One</span><span>Two</span></p></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第503行
        // 待确认：无；完整接口前提见联合比较约定
        String h = "<div><p><span>One</span><span>Two</span></p></div>";
        // 片段编号：J360
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第504行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(h);

        // 片段编号：J361
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element p = doc.select("div > p").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第506行
        // 待确认：无；完整接口前提见联合比较约定
        Element p = doc.select("div > p").first();
        // 片段编号：J362
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements spans = p.select("> span");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第507行
        // 待确认：无；完整接口前提见联合比较约定
        Elements spans = p.select("> span");
        // 片段编号：J363
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, spans.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第508行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, spans.size());
        // 片段编号：J364
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", spans.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第509行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", spans.first().text());

        // make sure doesn't get nested
        // 片段编号：J365
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：h = "<div id=1><div id=2><div id=3></div></div></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第512行
        // 待确认：无；完整接口前提见联合比较约定
        h = "<div id=1><div id=2><div id=3></div></div></div>";
        // 片段编号：J366
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：doc = Jsoup.parse(h);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第513行
        // 待确认：无；完整接口前提见联合比较约定
        doc = Jsoup.parse(h);
        // 片段编号：J367
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element div = doc.select("div").select(" > div").first();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第514行
        // 待确认：无；完整接口前提见联合比较约定
        Element div = doc.select("div").select(" > div").first();
        // 片段编号：J368
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", div.id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第515行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", div.id());
    }

    // 片段编号：J369
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoLessThan() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第518行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoLessThan() {
        // 片段编号：J370
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第519行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 片段编号：J371
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("div p:lt(2)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第520行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("div p:lt(2)");
        // 片段编号：J372
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第521行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, ps.size());
        // 片段编号：J373
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", ps.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第522行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", ps.get(0).text());
        // 片段编号：J374
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", ps.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第523行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", ps.get(1).text());
        // 片段编号：J375
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Four", ps.get(2).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第524行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Four", ps.get(2).text());
    }

    // 片段编号：J376
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoGreaterThan() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第527行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoGreaterThan() {
        // 片段编号：J377
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</p></div><div><p>Four</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第528行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</p></div><div><p>Four</p>");
        // 片段编号：J378
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("div p:gt(0)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第529行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("div p:gt(0)");
        // 片段编号：J379
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第530行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, ps.size());
        // 片段编号：J380
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", ps.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第531行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", ps.get(0).text());
        // 片段编号：J381
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", ps.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第532行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", ps.get(1).text());
    }

    // 片段编号：J382
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoEquals() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第535行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoEquals() {
        // 片段编号：J383
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第536行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 片段编号：J384
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("div p:eq(0)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第537行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("div p:eq(0)");
        // 片段编号：J385
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第538行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, ps.size());
        // 片段编号：J386
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", ps.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第539行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", ps.get(0).text());
        // 片段编号：J387
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Four", ps.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第540行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Four", ps.get(1).text());

        // 片段编号：J388
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps2 = doc.select("div:eq(0) p:eq(0)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第542行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps2 = doc.select("div:eq(0) p:eq(0)");
        // 片段编号：J389
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第543行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps2.size());
        // 片段编号：J390
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", ps2.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第544行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", ps2.get(0).text());
        // 片段编号：J391
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p", ps2.get(0).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第545行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p", ps2.get(0).tagName());
    }

    // 片段编号：J392
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoBetween() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第548行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoBetween() {
        // 片段编号：J393
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第549行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>");
        // 片段编号：J394
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("div p:gt(0):lt(2)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第550行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("div p:gt(0):lt(2)");
        // 片段编号：J395
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第551行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps.size());
        // 片段编号：J396
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", ps.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第552行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", ps.get(0).text());
    }

    // 片段编号：J397
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoCombined() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第555行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoCombined() {
        // 片段编号：J398
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div class='foo'><p>One</p><p>Two</p></div><div><p>Three</p><p>Four</p></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第556行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div class='foo'><p>One</p><p>Two</p></div><div><p>Three</p><p>Four</p></div>");
        // 片段编号：J399
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("div.foo p:gt(0)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第557行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("div.foo p:gt(0)");
        // 片段编号：J400
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第558行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps.size());
        // 片段编号：J401
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", ps.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第559行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", ps.get(0).text());
    }

    // 片段编号：J402
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPseudoHas() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第562行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPseudoHas() {
        // 片段编号：J403
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div id=0><p><span>Hello</span></p></div> <div id=1><span class=foo>There</span></div> <div id=2><p>Not</p></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第563行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div id=0><p><span>Hello</span></p></div> <div id=1><span class=foo>There</span></div> <div id=2><p>Not</p></div>");

        // 片段编号：J404
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divs1 = doc.select("div:has(span)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第565行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divs1 = doc.select("div:has(span)");
        // 片段编号：J405
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, divs1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第566行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, divs1.size());
        // 片段编号：J406
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("0", divs1.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第567行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("0", divs1.get(0).id());
        // 片段编号：J407
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", divs1.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第568行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", divs1.get(1).id());

        // 片段编号：J408
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divs2 = doc.select("div:has([class])");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第570行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divs2 = doc.select("div:has([class])");
        // 片段编号：J409
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, divs2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第571行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, divs2.size());
        // 片段编号：J410
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", divs2.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第572行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", divs2.get(0).id());

        // 片段编号：J411
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divs3 = doc.select("div:has(span, p)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第574行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divs3 = doc.select("div:has(span, p)");
        // 片段编号：J412
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, divs3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第575行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, divs3.size());
        // 片段编号：J413
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("0", divs3.get(0).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第576行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("0", divs3.get(0).id());
        // 片段编号：J414
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", divs3.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第577行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", divs3.get(1).id());
        // 片段编号：J415
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", divs3.get(2).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第578行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", divs3.get(2).id());

        // 片段编号：J416
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els1 = doc.body().select(":has(p)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第580行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els1 = doc.body().select(":has(p)");
        // 片段编号：J417
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, els1.size()); // body, div, div
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第581行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, els1.size()); // body, div, div
        // 片段编号：J418
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("body", els1.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第582行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("body", els1.first().tagName());
        // 片段编号：J419
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("0", els1.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第583行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("0", els1.get(1).id());
        // 片段编号：J420
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", els1.get(2).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第584行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", els1.get(2).id());

        // 片段编号：J421
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els2 = doc.body().select(":has(> span)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第586行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els2 = doc.body().select(":has(> span)");
        // 片段编号：J422
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2,els2.size()); // p, div
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第587行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2,els2.size()); // p, div
        // 片段编号：J423
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("p",els2.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第588行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("p",els2.first().tagName());
        // 片段编号：J424
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", els2.get(1).id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第589行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", els2.get(1).id());
    }

    // 片段编号：J425
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testNestedHas() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第592行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testNestedHas() {
        // 片段编号：J426
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p><span>One</span></p></div> <div><p>Two</p></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第593行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p><span>One</span></p></div> <div><p>Two</p></div>");
        // 片段编号：J427
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements divs = doc.select("div:has(p:has(span))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第594行
        // 待确认：无；完整接口前提见联合比较约定
        Elements divs = doc.select("div:has(p:has(span))");
        // 片段编号：J428
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, divs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第595行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, divs.size());
        // 片段编号：J429
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", divs.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第596行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", divs.first().text());

        // test matches in has
        // 片段编号：J430
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：divs = doc.select("div:has(p:matches((?i)two))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第599行
        // 待确认：无；完整接口前提见联合比较约定
        divs = doc.select("div:has(p:matches((?i)two))");
        // 片段编号：J431
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, divs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第600行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, divs.size());
        // 片段编号：J432
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", divs.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第601行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", divs.first().tagName());
        // 片段编号：J433
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", divs.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第602行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", divs.first().text());

        // test contains in has
        // 片段编号：J434
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：divs = doc.select("div:has(p:contains(two))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第605行
        // 待确认：无；完整接口前提见联合比较约定
        divs = doc.select("div:has(p:contains(two))");
        // 片段编号：J435
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, divs.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第606行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, divs.size());
        // 片段编号：J436
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", divs.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第607行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", divs.first().tagName());
        // 片段编号：J437
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", divs.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第608行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", divs.first().text());
    }

    // 片段编号：J438
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@MultiLocaleTest
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第611行
    // 待确认：无；完整接口前提见联合比较约定
    @MultiLocaleTest
    // 片段编号：J439
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testPseudoContains(Locale locale) {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第612行
    // 待确认：无；完整接口前提见联合比较约定
    public void testPseudoContains(Locale locale) {
        // 片段编号：J440
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Locale.setDefault(locale);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第613行
        // 待确认：无；完整接口前提见联合比较约定
        Locale.setDefault(locale);

        // 片段编号：J441
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p>The Rain.</p> <p class=light>The <i>RAIN</i>.</p> <p>Rain, the.</p></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第615行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p>The Rain.</p> <p class=light>The <i>RAIN</i>.</p> <p>Rain, the.</p></div>");

        // 片段编号：J442
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps1 = doc.select("p:contains(Rain)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第617行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps1 = doc.select("p:contains(Rain)");
        // 片段编号：J443
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, ps1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第618行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, ps1.size());

        // 片段编号：J444
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps2 = doc.select("p:contains(the rain)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第620行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps2 = doc.select("p:contains(the rain)");
        // 片段编号：J445
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, ps2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第621行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, ps2.size());
        // 片段编号：J446
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("The Rain.", ps2.first().html());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第622行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("The Rain.", ps2.first().html());
        // 片段编号：J447
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("The <i>RAIN</i>.", ps2.last().html());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第623行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("The <i>RAIN</i>.", ps2.last().html());

        // 片段编号：J448
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps3 = doc.select("p:contains(the Rain):has(i)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第625行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps3 = doc.select("p:contains(the Rain):has(i)");
        // 片段编号：J449
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第626行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps3.size());
        // 片段编号：J450
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("light", ps3.first().className());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第627行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("light", ps3.first().className());

        // 片段编号：J451
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps4 = doc.select(".light:contains(rain)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第629行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps4 = doc.select(".light:contains(rain)");
        // 片段编号：J452
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps4.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第630行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps4.size());
        // 片段编号：J453
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("light", ps3.first().className());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第631行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("light", ps3.first().className());

        // 片段编号：J454
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps5 = doc.select(":contains(rain)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第633行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps5 = doc.select(":contains(rain)");
        // 片段编号：J455
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(8, ps5.size()); // html, body, div,...
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第634行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(8, ps5.size()); // html, body, div,...

        // 片段编号：J456
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps6 = doc.select(":contains(RAIN)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第636行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps6 = doc.select(":contains(RAIN)");
        // 片段编号：J457
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(8, ps6.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第637行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(8, ps6.size());
    }

    // 片段编号：J458
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testPsuedoContainsWithParentheses() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第640行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testPsuedoContainsWithParentheses() {
        // 片段编号：J459
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p id=1>This (is good)</p><p id=2>This is bad)</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第641行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p id=1>This (is good)</p><p id=2>This is bad)</p>");

        // 片段编号：J460
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps1 = doc.select("p:contains(this (is good))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第643行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps1 = doc.select("p:contains(this (is good))");
        // 片段编号：J461
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第644行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps1.size());
        // 片段编号：J462
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", ps1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第645行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", ps1.first().id());

        // 片段编号：J463
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps2 = doc.select("p:contains(this is bad\\))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第647行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps2 = doc.select("p:contains(this is bad\\))");
        // 片段编号：J464
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第648行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps2.size());
        // 片段编号：J465
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", ps2.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第649行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", ps2.first().id());
    }

    // 片段编号：J466
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test void containsWholeText() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第652行
    // 待确认：无；完整接口前提见联合比较约定
    @Test void containsWholeText() {
        // 片段编号：J467
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser</div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第653行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser</div>");
        // 片段编号：J468
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("p");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第654行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("p");

        // 片段编号：J469
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements es1 = doc.select("p:containsWholeText( jsoup\n The HTML Parser)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第656行
        // 待确认：无；完整接口前提见联合比较约定
        Elements es1 = doc.select("p:containsWholeText( jsoup\n The HTML Parser)");
        // 片段编号：J470
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements es2 = doc.select("p:containsWholeText(jsoup The HTML Parser)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第657行
        // 待确认：无；完整接口前提见联合比较约定
        Elements es2 = doc.select("p:containsWholeText(jsoup The HTML Parser)");
        // 片段编号：J471
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, es1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第658行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, es1.size());
        // 片段编号：J472
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, es2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第659行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, es2.size());
        // 片段编号：J473
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(ps.get(0), es1.first());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第660行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(ps.get(0), es1.first());
        // 片段编号：J474
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(ps.get(1), es2.first());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第661行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(ps.get(1), es2.first());

        // 片段编号：J475
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("div:containsWholeText(jsoup the html parser)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第663行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("div:containsWholeText(jsoup the html parser)").size());
        // 片段编号：J476
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("div:containsWholeText(jsoup\n the html parser)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第664行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("div:containsWholeText(jsoup\n the html parser)").size());

        // 片段编号：J477
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：doc = Jsoup.parse("<div><p></p><p> </p><p>.  </p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第666行
        // 待确认：无；完整接口前提见联合比较约定
        doc = Jsoup.parse("<div><p></p><p> </p><p>.  </p>");
        // 片段编号：J478
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements blanks = doc.select("p:containsWholeText(  )");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第667行
        // 待确认：无；完整接口前提见联合比较约定
        Elements blanks = doc.select("p:containsWholeText(  )");
        // 片段编号：J479
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, blanks.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第668行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, blanks.size());
        // 片段编号：J480
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(".  ", blanks.first().wholeText());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第669行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(".  ", blanks.first().wholeText());
    }

    // 片段编号：J481
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test void containsWholeOwnText() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第672行
    // 待确认：无；完整接口前提见联合比较约定
    @Test void containsWholeOwnText() {
        // 片段编号：J482
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser<br></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第673行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser<br></div>");
        // 片段编号：J483
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("p");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第674行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("p");

        // 片段编号：J484
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements es1 = doc.select("p:containsWholeOwnText( jsoup\n The  Parser)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第676行
        // 待确认：无；完整接口前提见联合比较约定
        Elements es1 = doc.select("p:containsWholeOwnText( jsoup\n The  Parser)");
        // 片段编号：J485
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements es2 = doc.select("p:containsWholeOwnText(jsoup The HTML Parser\n)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第677行
        // 待确认：无；完整接口前提见联合比较约定
        Elements es2 = doc.select("p:containsWholeOwnText(jsoup The HTML Parser\n)");
        // 片段编号：J486
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, es1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第678行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, es1.size());
        // 片段编号：J487
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, es2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第679行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, es2.size());
        // 片段编号：J488
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(ps.get(0), es1.first());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第680行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(ps.get(0), es1.first());
        // 片段编号：J489
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(ps.get(1), es2.first());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第681行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(ps.get(1), es2.first());

        // 片段编号：J490
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("div:containsWholeOwnText(jsoup the html parser)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第683行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("div:containsWholeOwnText(jsoup the html parser)").size());
        // 片段编号：J491
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("div:containsWholeOwnText(jsoup\n the  parser)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第684行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("div:containsWholeOwnText(jsoup\n the  parser)").size());

        // 片段编号：J492
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：doc = Jsoup.parse("<div><p></p><p> </p><p>.  </p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第686行
        // 待确认：无；完整接口前提见联合比较约定
        doc = Jsoup.parse("<div><p></p><p> </p><p>.  </p>");
        // 片段编号：J493
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements blanks = doc.select("p:containsWholeOwnText(  )");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第687行
        // 待确认：无；完整接口前提见联合比较约定
        Elements blanks = doc.select("p:containsWholeOwnText(  )");
        // 片段编号：J494
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, blanks.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第688行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, blanks.size());
        // 片段编号：J495
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(".  ", blanks.first().wholeText());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第689行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(".  ", blanks.first().wholeText());
    }

    // 片段编号：J496
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@MultiLocaleTest
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第692行
    // 待确认：无；完整接口前提见联合比较约定
    @MultiLocaleTest
    // 片段编号：J497
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void containsOwn(Locale locale) {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第693行
    // 待确认：无；完整接口前提见联合比较约定
    public void containsOwn(Locale locale) {
        // 片段编号：J498
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Locale.setDefault(locale);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第694行
        // 待确认：无；完整接口前提见联合比较约定
        Locale.setDefault(locale);

        // 片段编号：J499
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>Hello <b>there</b> igor</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第696行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>Hello <b>there</b> igor</p>");
        // 片段编号：J500
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("p:containsOwn(Hello IGOR)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第697行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("p:containsOwn(Hello IGOR)");
        // 片段编号：J501
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第698行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps.size());
        // 片段编号：J502
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", ps.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第699行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", ps.first().id());

        // 片段编号：J503
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("p:containsOwn(there)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第701行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("p:containsOwn(there)").size());

        // 片段编号：J504
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc2 = Jsoup.parse("<p>Hello <b>there</b> IGOR</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第703行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc2 = Jsoup.parse("<p>Hello <b>there</b> IGOR</p>");
        // 片段编号：J505
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc2.select("p:containsOwn(igor)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第704行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc2.select("p:containsOwn(igor)").size());

    }

    // 片段编号：J506
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testMatches() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第708行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testMatches() {
        // 片段编号：J507
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>The <i>Rain</i></p> <p id=2>There are 99 bottles.</p> <p id=3>Harder (this)</p> <p id=4>Rain</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第709行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>The <i>Rain</i></p> <p id=2>There are 99 bottles.</p> <p id=3>Harder (this)</p> <p id=4>Rain</p>");

        // 片段编号：J508
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p1 = doc.select("p:matches(The rain)"); // no match, case sensitive
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第711行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p1 = doc.select("p:matches(The rain)"); // no match, case sensitive
        // 片段编号：J509
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, p1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第712行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, p1.size());

        // 片段编号：J510
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p2 = doc.select("p:matches((?i)the rain)"); // case insense. should include root, html, body
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第714行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p2 = doc.select("p:matches((?i)the rain)"); // case insense. should include root, html, body
        // 片段编号：J511
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第715行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p2.size());
        // 片段编号：J512
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", p2.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第716行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", p2.first().id());

        // 片段编号：J513
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p4 = doc.select("p:matches((?i)^rain$)"); // bounding
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第718行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p4 = doc.select("p:matches((?i)^rain$)"); // bounding
        // 片段编号：J514
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p4.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第719行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p4.size());
        // 片段编号：J515
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("4", p4.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第720行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("4", p4.first().id());

        // 片段编号：J516
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p5 = doc.select("p:matches(\\d+)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第722行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p5 = doc.select("p:matches(\\d+)");
        // 片段编号：J517
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p5.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第723行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p5.size());
        // 片段编号：J518
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", p5.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第724行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", p5.first().id());

        // 片段编号：J519
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p6 = doc.select("p:matches(\\w+\\s+\\(\\w+\\))"); // test bracket matching
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第726行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p6 = doc.select("p:matches(\\w+\\s+\\(\\w+\\))"); // test bracket matching
        // 片段编号：J520
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p6.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第727行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p6.size());
        // 片段编号：J521
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", p6.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第728行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", p6.first().id());

        // 片段编号：J522
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p7 = doc.select("p:matches((?i)the):has(i)"); // multi
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第730行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p7 = doc.select("p:matches((?i)the):has(i)"); // multi
        // 片段编号：J523
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p7.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第731行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p7.size());
        // 片段编号：J524
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", p7.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第732行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", p7.first().id());
    }

    // 片段编号：J525
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void matchesOwn() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第735行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void matchesOwn() {
        // 片段编号：J526
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>Hello <b>there</b> now</p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第736行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>Hello <b>there</b> now</p>");

        // 片段编号：J527
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p1 = doc.select("p:matchesOwn((?i)hello now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第738行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p1 = doc.select("p:matchesOwn((?i)hello now)");
        // 片段编号：J528
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第739行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p1.size());
        // 片段编号：J529
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", p1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第740行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", p1.first().id());

        // 片段编号：J530
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("p:matchesOwn(there)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第742行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("p:matchesOwn(there)").size());
    }

    // 片段编号：J531
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void matchesWholeText() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第745行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void matchesWholeText() {
        // 片段编号：J532
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第746行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3></p>");

        // 片段编号：J533
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p1 = doc.select("p:matchesWholeText((?i)hello there\n now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第748行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p1 = doc.select("p:matchesWholeText((?i)hello there\n now)");
        // 片段编号：J534
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第749行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p1.size());
        // 片段编号：J535
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", p1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第750行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", p1.first().id());

        // 片段编号：J536
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("p:matchesWholeText(there\n now)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第752行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("p:matchesWholeText(there\n now)").size());
        // 片段编号：J537
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("p:matchesWholeText(There\n now)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第753行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("p:matchesWholeText(There\n now)").size());

        // 片段编号：J538
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p2 = doc.select("p:matchesWholeText(^\\s+$)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第755行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p2 = doc.select("p:matchesWholeText(^\\s+$)");
        // 片段编号：J539
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第756行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p2.size());
        // 片段编号：J540
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", p2.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第757行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", p2.first().id());

        // 片段编号：J541
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p3 = doc.select("p:matchesWholeText(^$)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第759行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p3 = doc.select("p:matchesWholeText(^$)");
        // 片段编号：J542
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第760行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p3.size());
        // 片段编号：J543
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", p3.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第761行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", p3.first().id());
    }

    // 片段编号：J544
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void matchesWholeOwnText() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第764行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void matchesWholeOwnText() {
        // 片段编号：J545
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3><i>Text</i></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第765行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3><i>Text</i></p>");

        // 片段编号：J546
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p1 = doc.select("p:matchesWholeOwnText((?i)hello \n now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第767行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p1 = doc.select("p:matchesWholeOwnText((?i)hello \n now)");
        // 片段编号：J547
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第768行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p1.size());
        // 片段编号：J548
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", p1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第769行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", p1.first().id());

        // 片段编号：J549
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("p:matchesWholeOwnText(there\n now)").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第771行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("p:matchesWholeOwnText(there\n now)").size());

        // 片段编号：J550
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p2 = doc.select("p:matchesWholeOwnText(^\\s+$)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第773行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p2 = doc.select("p:matchesWholeOwnText(^\\s+$)");
        // 片段编号：J551
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第774行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p2.size());
        // 片段编号：J552
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", p2.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第775行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", p2.first().id());

        // 片段编号：J553
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements p3 = doc.select("p:matchesWholeOwnText(^$)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第777行
        // 待确认：无；完整接口前提见联合比较约定
        Elements p3 = doc.select("p:matchesWholeOwnText(^$)");
        // 片段编号：J554
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, p3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第778行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, p3.size());
        // 片段编号：J555
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("3", p3.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第779行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("3", p3.first().id());
    }

    // 片段编号：J556
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void testRelaxedTags() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第782行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void testRelaxedTags() {
        // 片段编号：J557
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<abc_def id=1>Hello</abc_def> <abc-def id=2>There</abc-def>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第783行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<abc_def id=1>Hello</abc_def> <abc-def id=2>There</abc-def>");

        // 片段编号：J558
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el1 = doc.select("abc_def");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第785行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el1 = doc.select("abc_def");
        // 片段编号：J559
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, el1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第786行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, el1.size());
        // 片段编号：J560
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", el1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第787行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", el1.first().id());

        // 片段编号：J561
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el2 = doc.select("abc-def");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第789行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el2 = doc.select("abc-def");
        // 片段编号：J562
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, el2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第790行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, el2.size());
        // 片段编号：J563
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", el2.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第791行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", el2.first().id());
    }

    // 片段编号：J564
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void notParas() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第794行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void notParas() {
        // 片段编号：J565
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p id=1>One</p> <p>Two</p> <p><span>Three</span></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第795行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p id=1>One</p> <p>Two</p> <p><span>Three</span></p>");

        // 片段编号：J566
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el1 = doc.select("p:not([id=1])");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第797行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el1 = doc.select("p:not([id=1])");
        // 片段编号：J567
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, el1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第798行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, el1.size());
        // 片段编号：J568
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", el1.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第799行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", el1.first().text());
        // 片段编号：J569
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", el1.last().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第800行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", el1.last().text());

        // 片段编号：J570
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el2 = doc.select("p:not(:has(span))");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第802行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el2 = doc.select("p:not(:has(span))");
        // 片段编号：J571
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, el2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第803行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, el2.size());
        // 片段编号：J572
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", el2.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第804行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", el2.first().text());
        // 片段编号：J573
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", el2.last().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第805行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", el2.last().text());
    }

    // 片段编号：J574
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void notAll() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第808行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void notAll() {
        // 片段编号：J575
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p>Two</p> <p><span>Three</span></p>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第809行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p>Two</p> <p><span>Three</span></p>");

        // 片段编号：J576
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el1 = doc.body().select(":not(p)"); // should just be the span
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第811行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el1 = doc.body().select(":not(p)"); // should just be the span
        // 片段编号：J577
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, el1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第812行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, el1.size());
        // 片段编号：J578
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("body", el1.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第813行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("body", el1.first().tagName());
        // 片段编号：J579
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", el1.last().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第814行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", el1.last().tagName());
    }

    // 片段编号：J580
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void notClass() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第817行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void notClass() {
        // 片段编号：J581
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div class=left>One</div><div class=right id=1><p>Two</p></div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第818行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div class=left>One</div><div class=right id=1><p>Two</p></div>");

        // 片段编号：J582
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements el1 = doc.select("div:not(.left)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第820行
        // 待确认：无；完整接口前提见联合比较约定
        Elements el1 = doc.select("div:not(.left)");
        // 片段编号：J583
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, el1.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第821行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, el1.size());
        // 片段编号：J584
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", el1.first().id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第822行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", el1.first().id());
    }

    // 片段编号：J585
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void handlesCommasInSelector() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第825行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void handlesCommasInSelector() {
        // 片段编号：J586
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p name='1,2'>One</p><div>Two</div><ol><li>123</li><li>Text</li></ol>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第826行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p name='1,2'>One</p><div>Two</div><ol><li>123</li><li>Text</li></ol>");

        // 片段编号：J587
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements ps = doc.select("[name=1,2]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第828行
        // 待确认：无；完整接口前提见联合比较约定
        Elements ps = doc.select("[name=1,2]");
        // 片段编号：J588
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, ps.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第829行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, ps.size());

        // 片段编号：J589
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements containers = doc.select("div, li:matches([0-9,]+)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第831行
        // 待确认：无；完整接口前提见联合比较约定
        Elements containers = doc.select("div, li:matches([0-9,]+)");
        // 片段编号：J590
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, containers.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第832行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, containers.size());
        // 片段编号：J591
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", containers.get(0).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第833行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", containers.get(0).tagName());
        // 片段编号：J592
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("li", containers.get(1).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第834行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("li", containers.get(1).tagName());
        // 片段编号：J593
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("123", containers.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第835行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("123", containers.get(1).text());
    }

    // 片段编号：J594
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectSupplementaryCharacter() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第838行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectSupplementaryCharacter() {
        // 片段编号：J595
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String s = new String(Character.toChars(135361));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第839行
        // 待确认：无；完整接口前提见联合比较约定
        String s = new String(Character.toChars(135361));
        // 片段编号：J596
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div k" + s + "='" + s + "'>^" + s +"$/div>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第840行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div k" + s + "='" + s + "'>^" + s +"$/div>");
        // 片段编号：J597
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", doc.select("div[k" + s + "]").first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第841行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", doc.select("div[k" + s + "]").first().tagName());
        // 片段编号：J598
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("div", doc.select("div:containsOwn(" + s + ")").first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第842行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("div", doc.select("div:containsOwn(" + s + ")").first().tagName());
    }

    // 片段编号：J599
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第845行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J600
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void selectClassWithSpace() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第846行
    // 待确认：无；完整接口前提见联合比较约定
    public void selectClassWithSpace() {
        // 片段编号：J601
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：final String html = "<div class=\"value\">class without space</div>\n"
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第847行
        // 待确认：无；完整接口前提见联合比较约定
        final String html = "<div class=\"value\">class without space</div>\n"
                          // 片段编号：J602
                          // 环节：初始化与准备
                          // 维度：声明与准备
                          // 内容：保留声明、对象或操作：+ "<div class=\"value \">class with space</div>";
                          // 关联：供本类测试使用的包、框架、声明或辅助结构。
                          // 依据：SelectorTest.java原文第848行
                          // 待确认：无；完整接口前提见联合比较约定
                          + "<div class=\"value \">class with space</div>";

        // 片段编号：J603
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第850行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);

        // 片段编号：J604
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements found = doc.select("div[class=value ]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第852行
        // 待确认：无；完整接口前提见联合比较约定
        Elements found = doc.select("div[class=value ]");
        // 片段编号：J605
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, found.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第853行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, found.size());
        // 片段编号：J606
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("class without space", found.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第854行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("class without space", found.get(0).text());
        // 片段编号：J607
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("class with space", found.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第855行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("class with space", found.get(1).text());

        // 片段编号：J608
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：found = doc.select("div[class=\"value \"]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第857行
        // 待确认：无；完整接口前提见联合比较约定
        found = doc.select("div[class=\"value \"]");
        // 片段编号：J609
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, found.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第858行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, found.size());
        // 片段编号：J610
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("class without space", found.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第859行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("class without space", found.get(0).text());
        // 片段编号：J611
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("class with space", found.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第860行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("class with space", found.get(1).text());

        // 片段编号：J612
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：found = doc.select("div[class=\"value\\ \"]");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第862行
        // 待确认：无；完整接口前提见联合比较约定
        found = doc.select("div[class=\"value\\ \"]");
        // 片段编号：J613
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, found.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第863行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, found.size());
    }

    // 片段编号：J614
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectSameElements() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第866行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectSameElements() {
        // 片段编号：J615
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：final String html = "<div>one</div><div>one</div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第867行
        // 待确认：无；完整接口前提见联合比较约定
        final String html = "<div>one</div><div>one</div>";

        // 片段编号：J616
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第869行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J617
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("div");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第870行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("div");
        // 片段编号：J618
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第871行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, els.size());

        // 片段编号：J619
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements subSelect = els.select(":contains(one)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第873行
        // 待确认：无；完整接口前提见联合比较约定
        Elements subSelect = els.select(":contains(one)");
        // 片段编号：J620
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, subSelect.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第874行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, subSelect.size());
    }

    // 片段编号：J621
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void attributeWithBrackets() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第877行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void attributeWithBrackets() {
        // 片段编号：J622
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<div data='End]'>One</div> <div data='[Another)]]'>Two</div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第878行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<div data='End]'>One</div> <div data='[Another)]]'>Two</div>";
        // 片段编号：J623
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第879行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J624
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", doc.select("div[data='End]']").first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第880行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", doc.select("div[data='End]']").first().text());
        // 片段编号：J625
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", doc.select("div[data='[Another)]]']").first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第881行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", doc.select("div[data='[Another)]]']").first().text());
        // 片段编号：J626
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", doc.select("div[data=\"End]\"]").first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第882行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", doc.select("div[data=\"End]\"]").first().text());
        // 片段编号：J627
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", doc.select("div[data=\"[Another)]]\"]").first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第883行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", doc.select("div[data=\"[Another)]]\"]").first().text());
    }

    // 片段编号：J628
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@MultiLocaleTest
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第886行
    // 待确认：无；完整接口前提见联合比较约定
    @MultiLocaleTest
    // 片段编号：J629
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void containsData(Locale locale) {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第887行
    // 待确认：无；完整接口前提见联合比较约定
    public void containsData(Locale locale) {
        // 片段编号：J630
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Locale.setDefault(locale);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第888行
        // 待确认：无；完整接口前提见联合比较约定
        Locale.setDefault(locale);

        // 片段编号：J631
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>function</p><script>FUNCTION</script><style>item</style><span><!-- comments --></span>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第890行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>function</p><script>FUNCTION</script><style>item</style><span><!-- comments --></span>";
        // 片段编号：J632
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第891行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J633
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element body = doc.body();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第892行
        // 待确认：无；完整接口前提见联合比较约定
        Element body = doc.body();

        // 片段编号：J634
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataEls1 = body.select(":containsData(function)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第894行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataEls1 = body.select(":containsData(function)");
        // 片段编号：J635
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataEls2 = body.select("script:containsData(function)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第895行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataEls2 = body.select("script:containsData(function)");
        // 片段编号：J636
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataEls3 = body.select("span:containsData(comments)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第896行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataEls3 = body.select("span:containsData(comments)");
        // 片段编号：J637
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataEls4 = body.select(":containsData(o)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第897行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataEls4 = body.select(":containsData(o)");
        // 片段编号：J638
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements dataEls5 = body.select("style:containsData(ITEM)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第898行
        // 待确认：无；完整接口前提见联合比较约定
        Elements dataEls5 = body.select("style:containsData(ITEM)");

        // 片段编号：J639
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, dataEls1.size()); // body and script
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第900行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, dataEls1.size()); // body and script
        // 片段编号：J640
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, dataEls2.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第901行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, dataEls2.size());
        // 片段编号：J641
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(dataEls1.last(), dataEls2.first());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第902行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(dataEls1.last(), dataEls2.first());
        // 片段编号：J642
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("<script>FUNCTION</script>", dataEls2.outerHtml());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第903行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("<script>FUNCTION</script>", dataEls2.outerHtml());
        // 片段编号：J643
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, dataEls3.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第904行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, dataEls3.size());
        // 片段编号：J644
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", dataEls3.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第905行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", dataEls3.first().tagName());
        // 片段编号：J645
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, dataEls4.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第906行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, dataEls4.size());
        // 片段编号：J646
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("body", dataEls4.first().tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第907行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("body", dataEls4.first().tagName());
        // 片段编号：J647
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("script", dataEls4.get(1).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第908行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("script", dataEls4.get(1).tagName());
        // 片段编号：J648
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("span", dataEls4.get(2).tagName());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第909行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("span", dataEls4.get(2).tagName());
        // 片段编号：J649
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, dataEls5.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第910行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, dataEls5.size());
    }

    // 片段编号：J650
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void containsWithQuote() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第913行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void containsWithQuote() {
        // 片段编号：J651
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>One'One</p><p>One'Two</p>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第914行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>One'One</p><p>One'Two</p>";
        // 片段编号：J652
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第915行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J653
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("p:contains(One\\'One)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第916行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("p:contains(One\\'One)");
        // 片段编号：J654
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第917行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J655
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One'One", els.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第918行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One'One", els.text());
    }

    // 片段编号：J656
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectFirst() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第921行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectFirst() {
        // 片段编号：J657
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>One<p>Two<p>Three";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第922行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>One<p>Two<p>Three";
        // 片段编号：J658
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第923行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J659
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", doc.selectFirst("p").text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第924行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", doc.selectFirst("p").text());
    }

    // 片段编号：J660
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectFirstWithAnd() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第927行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectFirstWithAnd() {
        // 片段编号：J661
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>One<p class=foo>Two<p>Three";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第928行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>One<p class=foo>Two<p>Three";
        // 片段编号：J662
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第929行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J663
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", doc.selectFirst("p.foo").text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第930行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", doc.selectFirst("p.foo").text());
    }

    // 片段编号：J664
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectFirstWithOr() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第933行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectFirstWithOr() {
        // 片段编号：J665
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>One<p>Two<p>Three<div>Four";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第934行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>One<p>Two<p>Three<div>Four";
        // 片段编号：J666
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第935行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J667
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", doc.selectFirst("p, div").text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第936行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", doc.selectFirst("p, div").text());
    }

    // 片段编号：J668
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void matchText() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第939行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void matchText() {
        // 片段编号：J669
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<p>One<br>Two</p>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第940行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<p>One<br>Two</p>";
        // 片段编号：J670
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第941行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);
        // 片段编号：J671
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：doc.outputSettings().prettyPrint(false);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第942行
        // 待确认：无；完整接口前提见联合比较约定
        doc.outputSettings().prettyPrint(false);
        // 片段编号：J672
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String origHtml = doc.html();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第943行
        // 待确认：无；完整接口前提见联合比较约定
        String origHtml = doc.html();

        // 片段编号：J673
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements one = doc.select("p:matchText:first-child");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第945行
        // 待确认：无；完整接口前提见联合比较约定
        Elements one = doc.select("p:matchText:first-child");
        // 片段编号：J674
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", one.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第946行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", one.first().text());

        // 片段编号：J675
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements two = doc.select("p:matchText:last-child");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第948行
        // 待确认：无；完整接口前提见联合比较约定
        Elements two = doc.select("p:matchText:last-child");
        // 片段编号：J676
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", two.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第949行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", two.first().text());

        // 片段编号：J677
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(origHtml, doc.html());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第951行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(origHtml, doc.html());

        // 片段编号：J678
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", doc.select("p:matchText + br + *").text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第953行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", doc.select("p:matchText + br + *").text());
    }

    // 片段编号：J679
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void nthLastChildWithNoParent() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第956行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void nthLastChildWithNoParent() {
        // 片段编号：J680
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element el = new Element("p").text("Orphan");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第957行
        // 待确认：无；完整接口前提见联合比较约定
        Element el = new Element("p").text("Orphan");
        // 片段编号：J681
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = el.select("p:nth-last-child(1)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第958行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = el.select("p:nth-last-child(1)");
        // 片段编号：J682
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第959行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, els.size());
    }

    // 片段编号：J683
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void splitOnBr() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第962行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void splitOnBr() {
        // 片段编号：J684
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<div><p>One<br>Two<br>Three</p></div>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第963行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<div><p>One<br>Two<br>Three</p></div>";
        // 片段编号：J685
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第964行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);

        // 片段编号：J686
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("p:matchText");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第966行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("p:matchText");
        // 片段编号：J687
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(3, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第967行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(3, els.size());
        // 片段编号：J688
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", els.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第968行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", els.get(0).text());
        // 片段编号：J689
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", els.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第969行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", els.get(1).text());
        // 片段编号：J690
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three", els.get(2).toString());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第970行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three", els.get(2).toString());
    }

    // 片段编号：J691
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void matchTextAttributes() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第973行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void matchTextAttributes() {
        // 片段编号：J692
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<div><p class=one>One<br>Two<p class=two>Three<br>Four");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第974行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<div><p class=one>One<br>Two<p class=two>Three<br>Four");
        // 片段编号：J693
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("p.two:matchText:last-child");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第975行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("p.two:matchText:last-child");

        // 片段编号：J694
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第977行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J695
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Four", els.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第978行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Four", els.text());
    }

    // 片段编号：J696
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void findBetweenSpan() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第981行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void findBetweenSpan() {
        // 片段编号：J697
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p><span>One</span> Two <span>Three</span>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第982行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p><span>One</span> Two <span>Three</span>");
        // 片段编号：J698
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("span ~ p:matchText"); // the Two becomes its own p, sibling of the span
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第983行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("span ~ p:matchText"); // the Two becomes its own p, sibling of the span
        // todo - think this should really be 'p:matchText span ~ p'. The :matchText should behave as a modifier to expand the nodes.

        // 片段编号：J699
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第986行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J700
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", els.text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第987行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", els.text());
    }

    // 片段编号：J701
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void startsWithBeginsWithSpace() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第990行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void startsWithBeginsWithSpace() {
        // 片段编号：J702
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<small><a href=\" mailto:abc@def.net\">(abc@def.net)</a></small>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第991行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<small><a href=\" mailto:abc@def.net\">(abc@def.net)</a></small>");
        // 片段编号：J703
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("a[href^=' mailto']");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第992行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("a[href^=' mailto']");

        // 片段编号：J704
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第994行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
    }

    // 片段编号：J705
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void endsWithEndsWithSpaces() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第997行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void endsWithEndsWithSpaces() {
        // 片段编号：J706
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<small><a href=\" mailto:abc@def.net \">(abc@def.net)</a></small>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第998行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<small><a href=\" mailto:abc@def.net \">(abc@def.net)</a></small>");
        // 片段编号：J707
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select("a[href$='.net ']");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第999行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select("a[href$='.net ']");

        // 片段编号：J708
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1001行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
    }

    // https://github.com/jhy/jsoup/issues/1257
    // 片段编号：J709
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：private final String mixedCase =
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1005行
    // 待确认：无；完整接口前提见联合比较约定
    private final String mixedCase =
        // 片段编号：J710
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作："<html xmlns:n=\"urn:ns\"><n:mixedCase>text</n:mixedCase></html>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1006行
        // 待确认：无；完整接口前提见联合比较约定
        "<html xmlns:n=\"urn:ns\"><n:mixedCase>text</n:mixedCase></html>";
    // 片段编号：J711
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：private final String lowercase =
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1007行
    // 待确认：无；完整接口前提见联合比较约定
    private final String lowercase =
        // 片段编号：J712
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作："<html xmlns:n=\"urn:ns\"><n:lowercase>text</n:lowercase></html>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1008行
        // 待确认：无；完整接口前提见联合比较约定
        "<html xmlns:n=\"urn:ns\"><n:lowercase>text</n:lowercase></html>";

    // 片段编号：J713
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1010行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J714
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void html_mixed_case_simple_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1011行
    // 待确认：无；完整接口前提见联合比较约定
    public void html_mixed_case_simple_name() {
        // 片段编号：J715
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(mixedCase, "", Parser.htmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1012行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(mixedCase, "", Parser.htmlParser());
        // 片段编号：J716
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("mixedCase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1013行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("mixedCase").size());
    }

    // 片段编号：J717
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1016行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J718
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void html_mixed_case_wildcard_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1017行
    // 待确认：无；完整接口前提见联合比较约定
    public void html_mixed_case_wildcard_name() {
        // 片段编号：J719
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(mixedCase, "", Parser.htmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1018行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(mixedCase, "", Parser.htmlParser());
        // 片段编号：J720
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("*|mixedCase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1019行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("*|mixedCase").size());
    }

    // 片段编号：J721
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1022行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J722
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void html_lowercase_simple_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1023行
    // 待确认：无；完整接口前提见联合比较约定
    public void html_lowercase_simple_name() {
        // 片段编号：J723
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(lowercase, "", Parser.htmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1024行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(lowercase, "", Parser.htmlParser());
        // 片段编号：J724
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("lowercase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1025行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("lowercase").size());
    }

    // 片段编号：J725
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1028行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J726
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void html_lowercase_wildcard_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1029行
    // 待确认：无；完整接口前提见联合比较约定
    public void html_lowercase_wildcard_name() {
        // 片段编号：J727
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(lowercase, "", Parser.htmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1030行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(lowercase, "", Parser.htmlParser());
        // 片段编号：J728
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("*|lowercase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1031行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("*|lowercase").size());
    }

    // 片段编号：J729
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1034行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J730
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void xml_mixed_case_simple_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1035行
    // 待确认：无；完整接口前提见联合比较约定
    public void xml_mixed_case_simple_name() {
        // 片段编号：J731
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(mixedCase, "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1036行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(mixedCase, "", Parser.xmlParser());
        // 片段编号：J732
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("mixedCase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1037行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("mixedCase").size());
    }

    // 片段编号：J733
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1040行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J734
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void xml_mixed_case_wildcard_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1041行
    // 待确认：无；完整接口前提见联合比较约定
    public void xml_mixed_case_wildcard_name() {
        // 片段编号：J735
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(mixedCase, "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1042行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(mixedCase, "", Parser.xmlParser());
        // 片段编号：J736
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("*|mixedCase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1043行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("*|mixedCase").size());
    }

    // 片段编号：J737
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1046行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J738
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void xml_lowercase_simple_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1047行
    // 待确认：无；完整接口前提见联合比较约定
    public void xml_lowercase_simple_name() {
        // 片段编号：J739
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(lowercase, "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1048行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(lowercase, "", Parser.xmlParser());
        // 片段编号：J740
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, doc.select("lowercase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1049行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, doc.select("lowercase").size());
    }

    // 片段编号：J741
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1052行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J742
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void xml_lowercase_wildcard_name() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1053行
    // 待确认：无；完整接口前提见联合比较约定
    public void xml_lowercase_wildcard_name() {
        // 片段编号：J743
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(lowercase, "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1054行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(lowercase, "", Parser.xmlParser());
        // 片段编号：J744
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, doc.select("*|lowercase").size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1055行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, doc.select("*|lowercase").size());
    }

    // 片段编号：J745
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1058行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J746
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void trimSelector() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1059行
    // 待确认：无；完整接口前提见联合比较约定
    public void trimSelector() {
        // https://github.com/jhy/jsoup/issues/1274
        // 片段编号：J747
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p><span>Hello");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1061行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p><span>Hello");
        // 片段编号：J748
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements els = doc.select(" p span ");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1062行
        // 待确认：无；完整接口前提见联合比较约定
        Elements els = doc.select(" p span ");
        // 片段编号：J749
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, els.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1063行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, els.size());
        // 片段编号：J750
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Hello", els.first().text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1064行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Hello", els.first().text());
    }

    // 片段编号：J751
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1067行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J752
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void xmlWildcardNamespaceTest() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1068行
    // 待确认：无；完整接口前提见联合比较约定
    public void xmlWildcardNamespaceTest() {
        // https://github.com/jhy/jsoup/issues/1208
        // 片段编号：J753
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<ns1:MyXmlTag>1111</ns1:MyXmlTag><ns2:MyXmlTag>2222</ns2:MyXmlTag>", "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1070行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<ns1:MyXmlTag>1111</ns1:MyXmlTag><ns2:MyXmlTag>2222</ns2:MyXmlTag>", "", Parser.xmlParser());
        // 片段编号：J754
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements select = doc.select("*|MyXmlTag");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1071行
        // 待确认：无；完整接口前提见联合比较约定
        Elements select = doc.select("*|MyXmlTag");
        // 片段编号：J755
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, select.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1072行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, select.size());
        // 片段编号：J756
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1111", select.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1073行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1111", select.get(0).text());
        // 片段编号：J757
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2222", select.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1074行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2222", select.get(1).text());
    }

    // 片段编号：J758
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1077行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J759
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void childElements() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1078行
    // 待确认：无；完整接口前提见联合比较约定
    public void childElements() {
        // https://github.com/jhy/jsoup/issues/1292
        // 片段编号：J760
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<body><span id=1>One <span id=2>Two</span></span></body>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1080行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<body><span id=1>One <span id=2>Two</span></span></body>";
        // 片段编号：J761
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1081行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);

        // 片段编号：J762
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element outer = doc.selectFirst("span");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1083行
        // 待确认：无；完整接口前提见联合比较约定
        Element outer = doc.selectFirst("span");
        // 片段编号：J763
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element span = outer.selectFirst("span");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1084行
        // 待确认：无；完整接口前提见联合比较约定
        Element span = outer.selectFirst("span");
        // 片段编号：J764
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element inner = outer.selectFirst("* span");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1085行
        // 待确认：无；完整接口前提见联合比较约定
        Element inner = outer.selectFirst("* span");

        // 片段编号：J765
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", outer.id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1087行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", outer.id());
        // 片段编号：J766
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("1", span.id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1088行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("1", span.id());
        // 片段编号：J767
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("2", inner.id());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1089行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("2", inner.id());
        // 片段编号：J768
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(outer, span);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1090行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(outer, span);
        // 片段编号：J769
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertNotEquals(outer, inner);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1091行
        // 待确认：无；完整接口前提见联合比较约定
        assertNotEquals(outer, inner);
    }

    // 片段编号：J770
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1094行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J771
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void selectFirstLevelChildrenOnly() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1095行
    // 待确认：无；完整接口前提见联合比较约定
    public void selectFirstLevelChildrenOnly() {
        // testcase for https://github.com/jhy/jsoup/issues/984
        // 片段编号：J772
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String html = "<div><span>One <span>Two</span></span> <span>Three <span>Four</span></span>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1097行
        // 待确认：无；完整接口前提见联合比较约定
        String html = "<div><span>One <span>Two</span></span> <span>Three <span>Four</span></span>";
        // 片段编号：J773
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(html);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1098行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(html);

        // 片段编号：J774
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Element div = doc.selectFirst("div");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1100行
        // 待确认：无；完整接口前提见联合比较约定
        Element div = doc.selectFirst("div");
        // 片段编号：J775
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertNotNull(div);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1101行
        // 待确认：无；完整接口前提见联合比较约定
        assertNotNull(div);

        // want to select One and Three only - the first level children
        // 片段编号：J776
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements spans = div.select(":root > span");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1104行
        // 待确认：无；完整接口前提见联合比较约定
        Elements spans = div.select(":root > span");
        // 片段编号：J777
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, spans.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1105行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, spans.size());
        // 片段编号：J778
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One Two", spans.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1106行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One Two", spans.get(0).text());
        // 片段编号：J779
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Three Four", spans.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1107行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Three Four", spans.get(1).text());
    }

    // 片段编号：J780
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1110行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J781
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void wildcardNamespaceMatchesNoNamespace() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1111行
    // 待确认：无；完整接口前提见联合比较约定
    public void wildcardNamespaceMatchesNoNamespace() {
        // https://github.com/jhy/jsoup/issues/1565
        // 片段编号：J782
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：String xml = "<package><meta>One</meta><opf:meta>Two</opf:meta></package>";
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1113行
        // 待确认：无；完整接口前提见联合比较约定
        String xml = "<package><meta>One</meta><opf:meta>Two</opf:meta></package>";
        // 片段编号：J783
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse(xml, "", Parser.xmlParser());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1114行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse(xml, "", Parser.xmlParser());

        // 片段编号：J784
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements metaEls = doc.select("meta");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1116行
        // 待确认：无；完整接口前提见联合比较约定
        Elements metaEls = doc.select("meta");
        // 片段编号：J785
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, metaEls.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1117行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, metaEls.size());
        // 片段编号：J786
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", metaEls.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1118行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", metaEls.get(0).text());

        // 片段编号：J787
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements nsEls = doc.select("*|meta");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1120行
        // 待确认：无；完整接口前提见联合比较约定
        Elements nsEls = doc.select("*|meta");
        // 片段编号：J788
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(2, nsEls.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1121行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(2, nsEls.size());
        // 片段编号：J789
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("One", nsEls.get(0).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1122行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("One", nsEls.get(0).text());
        // 片段编号：J790
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("Two", nsEls.get(1).text());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1123行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("Two", nsEls.get(1).text());
    }

    // 片段编号：J791
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test void containsTextQueryIsNormalized() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1126行
    // 待确认：无；完整接口前提见联合比较约定
    @Test void containsTextQueryIsNormalized() {
        // 片段编号：J792
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Document doc = Jsoup.parse("<p><p id=1>Hello  there now<em>!</em>");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1127行
        // 待确认：无；完整接口前提见联合比较约定
        Document doc = Jsoup.parse("<p><p id=1>Hello  there now<em>!</em>");
        // 片段编号：J793
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements a = doc.select("p:contains(Hello   there  now!)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1128行
        // 待确认：无；完整接口前提见联合比较约定
        Elements a = doc.select("p:contains(Hello   there  now!)");
        // 片段编号：J794
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements b = doc.select(":containsOwn(hello   there  now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1129行
        // 待确认：无；完整接口前提见联合比较约定
        Elements b = doc.select(":containsOwn(hello   there  now)");
        // 片段编号：J795
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements c = doc.select("p:contains(Hello there now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1130行
        // 待确认：无；完整接口前提见联合比较约定
        Elements c = doc.select("p:contains(Hello there now)");
        // 片段编号：J796
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements d = doc.select(":containsOwn(hello There now)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1131行
        // 待确认：无；完整接口前提见联合比较约定
        Elements d = doc.select(":containsOwn(hello There now)");
        // 片段编号：J797
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Elements e = doc.select("p:contains(HelloThereNow)");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1132行
        // 待确认：无；完整接口前提见联合比较约定
        Elements e = doc.select("p:contains(HelloThereNow)");

        // 片段编号：J798
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(1, a.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1134行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(1, a.size());
        // 片段编号：J799
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(a, b);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1135行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(a, b);
        // 片段编号：J800
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(a, c);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1136行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(a, c);
        // 片段编号：J801
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(a, d);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1137行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(a, d);
        // 片段编号：J802
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals(0, e.size());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1138行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals(0, e.size());
        // 片段编号：J803
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertNotEquals(a, e);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1139行
        // 待确认：无；完整接口前提见联合比较约定
        assertNotEquals(a, e);
    }

    // 片段编号：J804
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test public void selectorExceptionNotStringFormatException() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：SelectorTest.java原文第1142行
    // 待确认：无；完整接口前提见联合比较约定
    @Test public void selectorExceptionNotStringFormatException() {
        // 片段编号：J805
        // 环节：初始化与准备
        // 维度：声明与准备
        // 内容：保留声明、对象或操作：Selector.SelectorParseException ex = new Selector.SelectorParseException("%&");
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1143行
        // 待确认：无；完整接口前提见联合比较约定
        Selector.SelectorParseException ex = new Selector.SelectorParseException("%&");
        // 片段编号：J806
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertEquals("%&", ex.getMessage());
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：SelectorTest.java原文第1144行
        // 待确认：无；完整接口前提见联合比较约定
        assertEquals("%&", ex.getMessage());
    }
}
