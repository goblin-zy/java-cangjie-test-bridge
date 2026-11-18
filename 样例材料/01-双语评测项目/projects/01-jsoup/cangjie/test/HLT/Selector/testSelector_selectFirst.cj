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

    @TestCase
    func testSelector_selectFirst_01(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        var eles = Selector.selectFirst("div#type", doc)
        strRes = eles.getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        doc = Html4cj.parse(htmlStr2)
        eles = Selector.selectFirst("div#pseudo p:lt(2)", doc)
        strRes = eles.getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        @Assert(eles.getOrThrow().text(),"test_1")
    }

    @TestCase
    func testSelector_selectFirst_02(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        var eles = Selector.selectFirst("div#only,div#type:contains(SOME TEXT before the) em", doc)
        strRes = eles.getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        eles = Selector.selectFirst("div#only,div#type:contains(你好 SOME      &TEXT #) em", doc)
        strRes = eles.getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")

        eles = Selector.selectFirst("span:contains(压根就没有) haha", doc)
        @Assert(assertOptionNone<Element>(eles),true)
    }
}
