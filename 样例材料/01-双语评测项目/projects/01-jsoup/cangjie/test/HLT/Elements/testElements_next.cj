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
    func testElements_next_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p><p>test_2</p><p>test_3</p><p>test_4</p>")
        var ele_Res: Elements = els_1.next()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,3)
        strRes = ""
        for (ele in elementArr) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_2test_3test_4")
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_2</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_4</p>")
        var ele_Res2: Elements = els_1.next("p:contains(3)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,1)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_3")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_3</p>")
    }

    @TestCase
    func testElements_next_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("span")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.next()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,4) // 4
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>4</em>")
        var ele_Res2: Elements = els_1.next("em:contains(4)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,1)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.text()
        }
        @Assert(strRes,"4")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>4</em>")
    }

    @TestCase
    func testElements_next_03(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("SVG")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.next()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,3)
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>2</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>4</p>")
        var ele_Res2: Elements = els_1.next("svg")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,0)
        @Assert(assertOptionNone<Element>(ele_Res2.first()),true)
    }

    @TestCase
    func testElements_next_04(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("p")
        try {
            els_1.next(" ")
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''"))
            returnFlag = 0
        }
        var ele_Res2: Elements = els_1.next("哈喽")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,0)
        @Assert(assertOptionNone<Element>(ele_Res2.first()),true)
        @Assert(returnFlag , 0)
    }
}
