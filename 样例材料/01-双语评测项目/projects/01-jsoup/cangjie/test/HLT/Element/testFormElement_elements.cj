// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class FormElementTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    var strRes: String = ""
    var intRes: Int64 = -1
    let sourceDataIns: SourceData = SourceData()
    var returnFlag: Int64 = -1

    @TestCase
    func testFormElement_elements_01(): Unit {
        var ele_1: FormElement = FormElement(Tag.valueOf("FormElement_1"), None, None)
        var eles: Elements = ele_1.elements()
        @Assert(strRes, "")
        try {
            ele_1 = FormElement(Tag.valueOf(""), None, None)
            eles = ele_1.elements()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"), true)
            returnFlag = 0
        }
        @Assert(strRes, "")
        @Assert(returnFlag,0)
    }

    @TestCase
    func testFormElement_elements_02(): Unit {
        returnFlag = 0
        var ele_1: FormElement = FormElement(Tag.valueOf("FormElement_1"), "https://www.baidu.com/", None)
        var eles: Elements = ele_1.elements()
        @Assert(strRes, "")
        try {
            ele_1 = FormElement(Tag.valueOf("FormElement_1"), "", None)
            eles = ele_1.elements()
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(strRes, "")
        @Assert(returnFlag,0)
    }

    @TestCase
    func testFormElement_elements_03(): Unit {
        var attrs_1: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("仓颉", "Cangjie_!")
        var ele_1: FormElement = FormElement(Tag.valueOf("form"), "https://www.baidu.com/", attrs_1)
        var eles: Elements = ele_1.elements()
        @Assert(strRes, "")
        var htmlStr =
            "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        attrs_1 = ele_Res[0].elements()[0].attributes()
        @Assert(sourceDataIns.parseString(attrs_1.toString()),"type=\"text\"")
        ele_1 = FormElement(Tag.valueOf("form"), "https://www.baidu.com/", attrs_1)
        eles = ele_1.elements()
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes),"")
    }
}
