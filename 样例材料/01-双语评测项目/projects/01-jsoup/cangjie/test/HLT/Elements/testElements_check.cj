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
    var boolRes: Bool = false
    var htmlStr: String = generateHTMLStr(4)
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_check_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p><p>test_2</p><p>test_3</p><p>test_4</p>")
        boolRes = els_1.check("p:contains(3)")
        @Assert(boolRes,true)
        boolRes = els_1.check("b:contains(3)") // 当前选择器无法匹配元素
        @Assert(boolRes,false)
        boolRes = els_1.check("*")
        @Assert(boolRes,true)
        try {
            boolRes = els_1.check(".")
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("String must not be empty"))
            returnFlag = 0
        }
        boolRes = els_1.check("#id_1")
        @Assert(boolRes,false)
    }

    @TestCase
    func testElements_check_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("p")
        try {
            boolRes = els_1.check(" ")
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''")) // java
            returnFlag = 0
        }
        try {
            boolRes = els_1.check("*&%$%#_哈喽")
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '*&%$%#_哈喽': unexpected token at '&%$%#_哈喽'"))
            returnFlag = 0
        }
        boolRes = els_1.check("p")
        @Assert(boolRes,true)
        @Assert(returnFlag , 0)
    }
}
