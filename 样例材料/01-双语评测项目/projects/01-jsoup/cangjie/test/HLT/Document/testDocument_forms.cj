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

    @TestCase
    func testDocument_forms_01(): Unit {
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        @Assert(doc.forms().size,0)
        var doc_2: Document = Document("")
        @Assert(doc_2.forms().size,0)
        let html_2: String =
            "<body> <form id=\"001\" action=\"click\"> <input type=\"checkbox\" name=\"vehicle\">我想要小牛<br> <input type=\"checkbox\" name=\"vehicle\" >我只有两块钱<br> <input type=\"checkbox\" name=\"vehicle\" value=\"Bike\">要啥自行车 </form> </body>"
        var doc_3: Document = Html4cj.parse(html_2)
        let resArrL: ArrayList<FormElement> = doc_3.forms()
        @Assert(resArrL.size,1)
        let buf = StringBuilder()
        for (form in resArrL) {
            buf.append(form.elements().toString())
        }
        @Assert(sourceDataIns.parseString(buf.toString()),"<inputtype=\"checkbox\"name=\"vehicle\"><inputtype=\"checkbox\"name=\"vehicle\"><inputtype=\"checkbox\"name=\"vehicle\"value=\"Bike\">")
    }

    @TestCase
    func testDocument_forms_02(): Unit {
        strRes = ""
        let html_1: String =
            "<body> <form id= 001 action=click> <input type=checkbox name=vehicle>我想要小牛<br> <表单 id= 算了吧><input type=checkbox name=vehicle value=Bike>要啥自行车 </form> </body>"
        var doc_1: Document = Html4cj.parse(html_1)
        let resArrL_1: ArrayList<FormElement> = doc_1.forms()
        @Assert(resArrL_1.size,1) // 同java
        let buf_1 = StringBuilder()
        for (form in resArrL_1) {
            buf_1.append(form.elements().toString())
        }
        strRes = buf_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<inputtype=\"checkbox\"name=\"vehicle\"><inputtype=\"checkbox\"name=\"vehicle\"value=\"Bike\">") // 同java
        strRes = ""
        let html_2: String =
            "<body> <form> <input name=vehicle><form><input>我想要小牛<br> <form id= 算了吧><input type=checkbox name=vehicle value=Bike>要啥自行车 </form> </body>"
        var doc_2: Document = Html4cj.parse(html_2)
        let resArrL_2: ArrayList<FormElement> = doc_2.forms()
        @Assert(resArrL_2.size,1)
        let buf_2 = StringBuilder()
        for (form in resArrL_2) {
            buf_2.append(form.elements().toString())
        }
        strRes = buf_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<inputname=\"vehicle\"><input><inputtype=\"checkbox\"name=\"vehicle\"value=\"Bike\">") // 同java
    }
}
