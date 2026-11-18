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
    var boolRes: Bool = false
    let ele_sub1: Document = Document("https://www.baidu.com/")
    let ele_sub2: Document = Document("Tag_$1")

    @TestCase
    func testDocument_clone_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        let doc_1: Document = ins_1.clone()
        @Assert(doc_1 != ins_1, true)
        doc_1.appendChild(ele_sub1)
        ele_sub1.appendChild(ele_sub2)
        let doc_2: Document = Html4cj.parse("<div id=1>Text 1 <p>One</p> Text 2 <p>Two<p>Three</div><div id=2>")
        doc_1.appendChild(doc_2)
        @Assert(doc_1.childNodeSize(),2)
        @Assert(doc_2.parentElement() == doc_1,true)
        let doc_3: Document = doc_2.clone()
        @Assert(doc_3 == doc_2, false)
        @Assert(doc_3.childNodeSize(),1)
        var num = doc_3.select("p").size
        @Assert(num,3)
        var strRes = doc_3.select("p").toString()
        @Assert(sourceDataIns.parseString(strRes),"<p>One</p><p>Two</p><p>Three</p>")
        let doc_4: Document = doc_1.clone()
        @Assert(doc_4 == doc_1, false)
        @Assert(doc_4.siblingElements().size,0)
        let doc_5: Document = ele_sub1.clone()
        @Assert(doc_5 == doc_1, false)
        @Assert(doc_5.childNodeSize(),1)
        @Assert(assertOptionNone<Element>(doc_5.parentElement()) , true)
    }
}
