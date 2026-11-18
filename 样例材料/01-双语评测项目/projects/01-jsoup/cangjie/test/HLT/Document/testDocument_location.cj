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
    func testDocument_location_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        strRes = ins_1.location()
        @Assert(strRes, "")
        let ins_2: Document = Document(baseURL[10] + baseURL[12]) // cj字面量组合
        strRes = ins_2.location()
        @Assert(strRes.contains("你好仓颉！【】Hello Cangjie Lang"), true)
        let ins_3: Document = Document(baseURL[15]) // https协议，地址可达
        strRes = ins_3.location()
        @Assert(strRes, "https://www.iana.org/domains/reserved")
    }

    @TestCase
    func testDocument_location_02(): Unit {
        let ins_1: Document = Document.createShell(baseURL[0]) // 空str
        strRes = ins_1.location()
        @Assert(strRes, "")
        let ins_2: Document = Document.createShell(baseURL[10] + baseURL[12]) // cj字面量组合
        strRes = ins_2.location()
        @Assert(strRes.contains("你好仓颉！【】Hello Cangjie Lang"), true)
        let ins_3: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        strRes = ins_3.location()
        @Assert(strRes, "https://www.iana.org/domains/reserved")
    }

    @TestCase
    func testDocument_location_03(): Unit {
        let ins_1: Document = Document(baseURL[19]) // http协议，地址可达，全大写
        strRes = ins_1.location()
        @Assert(strRes, "HTTP://JSOUP.ORG/")
        let ins_2: Document = Document.createShell(baseURL[20]) // https协议，地址可达，兼大小写
        strRes = ins_2.location()
        @Assert(strRes, "https://JSOUP.org/")
        let ins_3: Document = Document(baseURL[18]) // 地址不可达，全中文
        strRes = ins_3.location()
        @Assert(strRes, "中文路径，无实意")
        let ins_4: Document = Document.createShell(baseURL[17]) // 地址不可达，英混中
        strRes = ins_4.location()
        @Assert(strRes, "http://jsoup哈喽.org/")
    }

    @TestCase
    func testDocument_location_04(): Unit {
        let arrL: ArrayList<String> = sourceDataIns.generateHTMLStr()
        var doc: Document = Html4cj.parse(arrL[12])
        strRes = doc.location() // "" ?
        @Assert(strRes, "")
        doc = Html4cj.parse(arrL[12], "http://www.baidu.com")
        strRes = doc.location()
        @Assert(strRes, "http://www.baidu.com")
    }
}
