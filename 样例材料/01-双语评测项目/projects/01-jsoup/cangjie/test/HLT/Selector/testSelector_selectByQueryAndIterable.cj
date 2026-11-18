// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SelectorTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var htmlStr2: String = generateHTMLStr(4)
    var returnFlag: Int64 = 0

    @TestCase
    func testSelector_selectByQueryAndIterable_01(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        var eles_enter: Elements = doc.select("div#type")
        var eles: Elements = Selector.select("div#type", eles_enter.iterator()) // root:Document
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        strRes = eles.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        doc = Html4cj.parse(htmlStr2)
        eles_enter = doc.select("div#pseudo")
        eles = Selector.select("div#pseudo p:lt(2)", eles_enter.iterator())
        @Assert(eles.size,2)
        strRes = eles.toString()
        @Assert(eles[0].toString(),"<p>test_1</p>")
        @Assert(eles[0].text(),"test_1")
        @Assert(eles[1].toString(),"<p>test_2</p>")
    }

    @TestCase
    func testSelector_selectByQueryAndIterable_02(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles_enter: Elements = doc.select("div#only")
        var it_1: Iterator<Element> = eles_enter.iterator()
        var eles: Elements = Selector.select("div#only,div#type:contains(SOME TEXT before the) em", it_1)
        strRes = eles.toString()
        @Assert(eles.size,1)
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.select("div#only,div#type:contains(你好 SOME      &TEXT #) em", it_1)
        strRes = eles.toString()
        @Assert(eles.size,0)
        @Assert(sourceDataIns.parseString(strRes),"")
    }

    @TestCase
    func testSelector_selectByQueryAndIterable_03(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles_enter: Elements = doc.select("div#only")
        var it_1: Iterator<Element> = eles_enter.iterator()
        try {
            var eles: Elements = Selector.select(" ", it_1)
            @Assert(eles.elementArr.size,0)
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''"))
            returnFlag = 0
        }
        try {
            var eles: Elements = Selector.select("", it_1)
            @Assert(eles.elementArr.size,0)
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"))
            returnFlag = 0
        }
        try {
            var eles: Elements = Selector.select("div#only,div#type:contains(SOME TEXT before the) em",
                Elements().iterator())
            strRes = eles.toString()
            @Assert(eles.size,0)
            @Assert(strRes,"")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }

        @Assert(returnFlag ,0)
    }
}
