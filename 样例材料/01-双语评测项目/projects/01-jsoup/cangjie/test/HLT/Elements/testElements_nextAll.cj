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
    func testElements_nextAll_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p><p>test_2</p><p>test_3</p><p>test_4</p>")
        var ele_Res: Elements = els_1.nextAll()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,6)
        strRes = ""
        for (ele in elementArr) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_2test_3test_4test_3test_4test_4") // 同java
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_2</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_4</p>")
        var ele_Res2: Elements = els_1.nextAll("p:contains(test)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,6)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.text()
        }
        @Assert(strRes,"test_2test_3test_4test_3test_4test_4")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_2</p>")
    }

    @TestCase
    func testElements_nextAll_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("span")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.nextAll()
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,32)
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>1</em>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<svg> 4</svg>") // 同java
        var ele_Res2: Elements = els_1.nextAll("em:contains(4)")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,4)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.toString()
        }
        @Assert(strRes,"<em>4</em><em>4</em><em>4</em><em>4</em>")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<em>4</em>")
    }

    @TestCase
    func testElements_nextAll_03(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("SVG")
        strRes = els_1.outerHtml()
        var ele_Res: Elements = els_1.nextAll() // 12 8 4
        let elementArr: ArrayList<Element> = ele_Res.elementArr
        @Assert(elementArr.size,24)
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>2</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<svg> 4</svg>")
        var ele_Res2: Elements = els_1.nextAll("svg")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,6)
        strRes = ""
        for (ele in elementArr2) {
            strRes += ele.toString()
        }
        @Assert(sourceDataIns.parseString(strRes),"<svg>2</svg><svg>3</svg><svg>4</svg><svg>3</svg><svg>4</svg><svg>4</svg>")
        strRes = ele_Res2.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<svg> 2</svg>")
    }

    @TestCase
    func testElements_nextAll_04(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("p")
        try {
            var ele_Res: Elements = els_1.nextAll(" ")
            @Assert(ele_Res.elementArr.size,0)
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''"))
            returnFlag = 0
        }
        var ele_Res2: Elements = els_1.nextAll("哈喽")
        let elementArr2: ArrayList<Element> = ele_Res2.elementArr
        @Assert(elementArr2.size,0)
        @Assert(assertOptionNone<Element>(ele_Res2.first()),true)
        @Assert(returnFlag , 0)
    }
}
