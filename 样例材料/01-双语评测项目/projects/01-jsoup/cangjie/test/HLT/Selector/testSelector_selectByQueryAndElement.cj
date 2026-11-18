// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SelectorTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    let HTMLStr: ArrayList<String> = sourceDataIns.generateHTMLStr()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var htmlStr2: String = generateHTMLStr(4)
    var formHtml_1 =
        "<form action=\"\" method=\"post\"> text:<input type=\"text\"> button:<input type=\"button\" value=\"val_button\"> date:<input type=\"date\" name=\"date_name\" id=\"now\"> </form>"
    var returnFlag: Int64 = -1
    var attrs_1: Attributes = Attributes()
    var ele_1: Element = Element(Tag.valueOf("form"), "", None)
    var formElement1: FormElement = FormElement(Tag.valueOf("div1"), "", None)

    @TestCase
    func testSelector_selectByQueryAndElement_01(): Unit {
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("仓颉", "Cangjie_!")
        var pseudoTextElement1: PseudoTextElement = PseudoTextElement(Tag.valueOf("div1"), "", attrs_1)
        var eles: Elements = Selector.select("htmlStr", pseudoTextElement1) 
        strRes = eles.toString()
        @Assert(strRes, "")
        var html_1 =
            "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        var doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        let ele_1 = ele_Res[0].elements()[0]
        @Assert(sourceDataIns.parseString(ele_1.toString(),false),"<input type=\"text\">")
        var pseudoTextElement2: PseudoTextElement = PseudoTextElement(Tag.valueOf("div2"), "https://www.baidu.com/",
            ele_1.attributes())
        eles = Selector.select("input", pseudoTextElement2) // 
        strRes = eles.toString()
        @Assert(strRes, "")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_02(): Unit {
        var ele_1: Element = Element("span")
        ele_1.attr("id", "hello")
        ele_1.attr("class", "html")
        var eles: Elements = Selector.select("span", ele_1) 
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(ele_1.toString(),false),"<span id=\"hello\" class=\"html\"></span>")
        eles = Selector.select("span#hello", ele_1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(ele_1.toString(),false),"<span id=\"hello\" class=\"html\"></span>")
        var doc: Document = Html4cj.parse(formHtml_1)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        var formElement: FormElement = ele_Res[0]
        eles = Selector.select("input", formElement) 
        strRes = eles.toString()
        strRes = eles.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"date\" name=\"date_name\" id=\"now\">")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_03(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        var eles: Elements = Selector.select("div#type", doc) 
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        strRes = eles.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        doc = Html4cj.parse(htmlStr2)
        eles = Selector.select("div#pseudo p:lt(2)", doc)
        @Assert(eles.size,2)
        strRes = eles.toString()
        @Assert(eles[0].toString(),"<p>test_1</p>")
        @Assert(eles[0].text(),"test_1")
        @Assert(eles[1].toString(),"<p>test_2</p>")
        eles = Selector.select("div#pseudo p:gt(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(eles.last().getOrThrow().toString(),"<p>test_4</p>")
        @Assert(eles[0].text(),"test_4")
        eles = Selector.select("div#pseudo p:gt(0):lt(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(eles.last().getOrThrow().toString(),"<p>test_2</p>")
        eles = Selector.select("div#pseudo p:gt(3)", doc)
        @Assert(eles.size,0)
        eles = Selector.select("div#pseudo p:gt(5)", doc)
        @Assert(eles.size,0)
        eles = Selector.select("div#pseudo p:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(eles.last().getOrThrow().toString(),"<p>test_3</p>")
        @Assert(eles[0].text(),"test_3")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_04(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:has(span) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        eles = Selector.select("div#type:has(> p) span:gt(0):lt(2)", doc)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span>1</span>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_05(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:not(li) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        eles = Selector.select("div#type:not(div#type:has(> p) span:gt(1)) p", doc)
        strRes = eles.toString()
        @Assert(eles.size,4)
        @Assert(eles[0].toString(),"<p>1</p>")
        @Assert(eles.last().getOrThrow().toString(),"<p>4</p>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_06(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:contains(2) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        eles = Selector.select("div#only,div#type:contains(SOME TEXT before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:contains(你好 SOME      &TEXT #) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_07(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:containsOwn(2) em:eq(2)", doc)
        @Assert(eles.size,0)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"") // 同java
        eles = Selector.select("div#only,div#type:containsOwn(SOME TEXT before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:containsOwn(你好 SOME      &TEXT #) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_08(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:containsData(2) em:eq(2)", doc)
        @Assert(eles.size,0)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"") // 同java
        eles = Selector.select("div#only,div#type:containsData(SOME TEXT before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:containsData(你好 SOME      &TEXT #) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_09(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:containsWholeText(2) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>") // 同java
        eles = Selector.select("div#only,div#type:containsWholeText(SOME TEXT   before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:containsWholeText(你好 SOME      &TEXT #) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_10(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:containsWholeOwnText(2) em:eq(2)", doc)
        @Assert(eles.size,0)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"") // 同java
        eles = Selector.select("div#only,div#type:containsWholeOwnText(SOME TEXT   before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:containsWholeOwnText(你好 SOME \\r    &TEXT #) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_11(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:matches(2) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>") // 同java
        eles = Selector.select("div#only,div#type:matches(你好 SOME TEXT     before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:matches((?i)SOme):has(i) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_12(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles: Elements = Selector.select("div#type:matchesWholeText(2) em:eq(2)", doc)
        @Assert(eles.size,1)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>") // 同java
        eles = Selector.select("div#only,div#type:matchesWholeText(你好 SOME TEXT     before the) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:matchesWholeText((?i)SOme):has(i) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:matchesWholeText(\\s{1,}):has(i) em", doc)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
    }

    @TestCase
    func testSelector_selectByQueryAndElement_13(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        try {
            var eles: Elements = Selector.select(" ", doc)
            @Assert(eles.elementArr.size,0)
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''")) // java
            returnFlag = 0
        }
        try {
            var eles: Elements = Selector.select(" 无匹配数据", doc)
            strRes = eles.toString()
            @Assert(sourceDataIns.parseString(strRes,false),"")
        } catch (e1:  NoneValueException) {
            returnFlag = 1
        }

        @Assert(returnFlag ,0)
    }
}
