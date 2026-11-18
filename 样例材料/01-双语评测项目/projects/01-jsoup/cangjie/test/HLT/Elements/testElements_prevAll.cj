// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementsTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    var strRes: String = ""
    var htmlStr: String = generateHTMLStr(4)
    var returnFlag: Int64 = -1
    var num: Int64 = 1

    @TestCase
    func testElements_prevAll_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p><p>test_2</p><p>test_3</p><p>test_4</p>")
        var ele_Res: Elements = els_1.prevAll()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,6)
        strRes = ""
        for (ele in elementArr) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_1test_2test_1test_3test_2test_1")
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        var ele_Res2: Elements = els_1.prevAll("p:contains(2)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,2)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_2test_2")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_2</p>")
    }

    @TestCase
    func testElements_prevAll_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("span")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.prevAll()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,28) // 1 5 9 13
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>1</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>1</p>")
        var ele_Res2: Elements = els_1.prevAll("svg:contains(3)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,1)
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<svg>3</svg>")
    }

    @TestCase
    func testElements_prevAll_03(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("SVG")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.prevAll()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,36) // 3 7 11 15
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>1</p>")
        var ele_Res2: Elements = els_1.prevAll("p:contains(3)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.toString()
        }
        @Assert(strRes,"<p>3</p><p>3</p>")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>3</p>")
    }

    @TestCase
    func testElements_prevAll_04(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("p")
        try {
            var ele_Res: Elements = els_1.prevAll(" ")
            @Assert(ele_Res.elementArr.size,0)
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''")) // java
            returnFlag = 0
        }
        try {
            var ele_Res2: Elements = els_1.prevAll("&^%$##@！")
            let elementArr2: ArrayList<Element> = ele_Res2.elementArr
            @Assert(elementArr2.size,0)
            @Assert(assertOptionNone<Element>(ele_Res2.first()),true)
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '&^%$##@！': unexpected token at '&^%$##@！'")) // java
            returnFlag = 0
        }
        @Assert(returnFlag , 0)
    }
}
