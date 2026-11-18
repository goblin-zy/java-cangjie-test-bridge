// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class DocumentTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testDocument_createElement_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        try {
            ins_1.createElement(" ")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty") , true)
            returnFlag = 0
        }
        var ele_1 = ins_1.createElement(sourceDataIns.arrLStr_Base[4]) //你好仓颉！【】
        strRes = ele_1.toString()
        @Assert(strRes,"<你好仓颉！【】></你好仓颉！【】>")
        strRes = ""
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var ele_2: Element = ins_2.createElement("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        strRes = ele_2.toString()
        @Assert(strRes,"<Hello Cang!@#$%^&*()_+:<>?|jie Lang></Hello Cang!@#$%^&*()_+:<>?|jie Lang>")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testDocument_createElement_02(): Unit {
        strRes = ""
        var html_1: String = sourceDataIns.generateHTMLStr()[3]
        var doc_1: Document = Html4cj.parse(html_1)
        let ele_1 = doc_1.createElement("\"Cang_jie\"")
        strRes = ele_1.toString()
        @Assert(strRes,"<\"Cang_jie\"></\"Cang_jie\">")
        let ele_2 = doc_1.createElement("转\f义")
        strRes = ele_2.toString()
        @Assert(strRes,"<转\f义></转\f义>")
        let ele_3 = doc_1.createElement("HELLO^_^Cangjie")
        strRes = ele_3.toString()
        @Assert(strRes,"<HELLO^_^Cangjie></HELLO^_^Cangjie>")
        let ele_4 = doc_1.createElement("<-1>")
        strRes = ele_4.toString()
        @Assert(strRes,"<<-1>></<-1>>")
        let ele_5 = doc_1.createElement("</(?)>")
        strRes = ele_5.toString()
        @Assert(strRes,"<</(?)>></</(?)>>")
        let ele_6 = doc_1.createElement("</    H>")
        strRes = ele_6.toString()
        @Assert(strRes,"<</    H>></</    H>>")
        let ele_7 = doc_1.createElement("span")
        strRes = ele_7.toString()
        @Assert(strRes,"<span></span>")
    }
}
