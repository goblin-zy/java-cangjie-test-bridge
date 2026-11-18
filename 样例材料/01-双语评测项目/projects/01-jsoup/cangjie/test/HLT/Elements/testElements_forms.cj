// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementsTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var htmlStr: String =
        "<div id=1> <form action=\"\" method=\"post\"> text:<input type=\"text\"> button:<input type=\"button\" value=\"val_button\"> submit:<input type=\"submit\" value=\"cangjie\"/> date:<input type=\"date\" name=\"date_name\" id=\"now\"> color:<input type=\"color\" name=\"col\" id=\"Red\"> </form> <form> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"></form> </form> </div>"

    @TestCase
    func testElements_forms_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("form[method=\"post\"]")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        @Assert(ele_Res.size,1)
        let els_Res_1: Elements = ele_Res[0].elements()
        strRes = els_Res_1.toString()
        let elementArr: ArrayList<Element> = els_Res_1.elementArr
        @Assert(elementArr.size,5)
        strRes = elementArr[0].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"text\">")
        strRes = elementArr[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"button\" value=\"val_button\">")
        strRes = elementArr[2].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"submit\" value=\"cangjie\">")
        strRes = elementArr[3].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"date\" name=\"date_name\" id=\"now\">")
        strRes = elementArr[4].id()
        @Assert(sourceDataIns.parseString(strRes,false),"Red")
    }

    @TestCase
    func testElements_forms_02(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form[method=\"get\"],form > textarea")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        @Assert(ele_Res.size,0)
        htmlStr = "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        doc = Html4cj.parse(htmlStr)
        els_1 = doc.select("form")
        ele_Res = els_1.forms()
        @Assert(ele_Res.size,1)
        let els_Res_1: Elements = ele_Res[0].elements()
        strRes = els_Res_1.toString()
        strRes = els_Res_1[0].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"text\">")
        strRes = els_Res_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea>")
        strRes = els_Res_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"button\" value=\"val_button\">")
    }
}
