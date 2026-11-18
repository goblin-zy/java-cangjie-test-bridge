// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class FormElementTest {
    var strRes: String = ""
    let sourceDataIns: SourceData = SourceData()

    @TestCase
    func testFormElement_addElement_01(): Unit {
        var formEle_1: FormElement = FormElement(Tag.valueOf("FormElement_1"), None, None)
        var ele_1: Element = Element(Tag.valueOf("form"), "", None)
        var ele_res: FormElement = formEle_1.addElement(ele_1)
        strRes = ele_res.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<FormElement_1></FormElement_1>")
        strRes = ""
        var htmlStr =
            "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        ele_1 = ele_Res[0].elements()[0]
        @Assert(sourceDataIns.parseString(ele_1.toString(),false),"<input type=\"text\">")
        ele_res = formEle_1.addElement(ele_1)
        strRes = ele_res.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<FormElement_1></FormElement_1>")
    }

    @TestCase
    func testFormElement_addElement_02(): Unit {
        var formEle_1: FormElement = FormElement(Tag.valueOf("FormElement_2"), None, None)
        var formElement1: FormElement = FormElement(Tag.valueOf("div1"), "", None)
        var formElement2: FormElement = FormElement(Tag.valueOf("div2"), "", None)
        var ele_res: FormElement = formEle_1.addElement(formElement1)
        ele_res = formEle_1.addElement(formElement2)
        strRes = ele_res.toString()
        var eles = formEle_1.elements()
        @Assert(eles.size, 2)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div1></div1><div2></div2>")
        strRes = ""
        var htmlStr =
            "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        var ele_1: Element = ele_Res[0]
        ele_res = formEle_1.addElement(ele_1.clone())
        strRes = ele_res.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<FormElement_2></FormElement_2>")
        eles = formEle_1.elements()
        @Assert(eles.size, 3)
        strRes = eles.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea>  button:<input type=\"button\" value=\"val_button\"></form>")
    }

    @TestCase
    func testFormElement_addElement_03(): Unit {
        var formEle_1: FormElement = FormElement(Tag.valueOf("FormElement_2"), None, None)
        var attrs_1: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("仓颉", "Cangjie_!")
        var pseudoTextElement1: PseudoTextElement = PseudoTextElement(Tag.valueOf("div1"), "", attrs_1)
        var ele_res: FormElement = formEle_1.addElement(pseudoTextElement1)
        var eles = formEle_1.elements()
        @Assert(eles.size, 1)
        strRes = eles.toString()
        strRes = ""
        var htmlStr =
            "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form")
        var ele_Res: ArrayList<FormElement> = els_1.forms()
        attrs_1 = ele_Res[0].elements()[0].attributes()
        var pseudoTextElement2: PseudoTextElement = PseudoTextElement(Tag.valueOf("div2"), "https://www.baidu.com/",
            attrs_1)
        ele_res = formEle_1.addElement(pseudoTextElement2)
        strRes = ele_res.toString()
        eles = formEle_1.elements()
        @Assert(eles.size, 2)
    }
}
