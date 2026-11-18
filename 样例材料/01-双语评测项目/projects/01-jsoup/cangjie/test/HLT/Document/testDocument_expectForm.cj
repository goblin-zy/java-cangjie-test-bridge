// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class DocumentTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int16 = -1

    @TestCase
    func testDocument_expectForm_01(): Unit {
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        try {
            doc.expectForm("表单")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("No form elements matched the query '表单' in the document"),true)
        }
        var doc_2: Document = Document("")
        try {
            doc_2.expectForm("#form")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("No form elements matched the query '#form' in the document"),true)
            returnFlag = 0
        }
        let html_2: String =
            "<body> <form id=\"001\" action=\"click\"> <input type=\"checkbox\" name=\"vehicle\">我想要小牛<br> <input type=\"checkbox\" name=\"vehicle\" >我只有两块钱<br> <input type=\"checkbox\" name=\"vehicle\" value=\"Bike\">要啥自行车 </form> </body>"
        var doc_3: Document = Html4cj.parse(html_2)
        strRes = doc_3.expectForm("#001").getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<formid=\"001\"action=\"click\"><inputtype=\"checkbox\"name=\"vehicle\">我想要小牛<br><inputtype=\"checkbox\"name=\"vehicle\">我只有两块钱<br><inputtype=\"checkbox\"name=\"vehicle\"value=\"Bike\">要啥自行车</form>")
        @Assert(returnFlag,0)
    }

    @TestCase
    func testDocument_forms_02(): Unit {
        strRes = ""
        returnFlag = -1
        let html_1: String =
            "<body> <form id= <> action=click> <input type=checkbox name=vehicle>我想要小牛<br> <表单 id= 算了吧><input type=checkbox name=vehicle value=Bike>要啥自行车 </form> </body>"
        var doc_1: Document = Html4cj.parse(html_1)
        try {
            doc_1.expectForm("#算了吧")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("No form elements matched the query '#算了吧' in the document"),true)
        }

        try {
            strRes = doc_1.expectForm("#<>").getOrThrow().toString()
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("String must not be empty"),true)
        }

        let html_2: String =
            "<body> <form> <input name=vehicle><form><input>我想要小牛<br> <form id= 算了吧><input type=checkbox name=vehicle value=Bike>要啥自行车 </form> </body>"
        var doc_2: Document = Html4cj.parse(html_2)
        try {
            strRes = doc_2.expectForm("[name = vehicle]").getOrThrow().toString()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("No form elements matched the query '[name = vehicle]' in the document"),true)
            returnFlag = 0
        }
        @Assert(returnFlag,0)
    }
}
