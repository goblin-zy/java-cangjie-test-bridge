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
        "<form> text:<input type=\"text\"> <textarea id=\"area\" cols=\"30\" rows=\"10\"></textarea> <form action=\"\" method=\"get\"> button:<input type=\"button\" value=\"val_button\"> </form> </form>"
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_traverse_01(): Unit {
        var sb: StringBuilder = StringBuilder()
        let ins_1: MyVisitor = (MyVisitor(sb, 3))
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("form > input:first-child")
        var els_Res_1: Elements = els_1.traverse(ins_1)
        strRes = els_Res_1.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input type=\"text\">")
        els_1 = doc.select("form[action]")
        els_Res_1 = els_1.traverse(ins_1)
        strRes = els_Res_1.toString()
        @Assert(strRes,"") //同java
        sb = ins_1.accum
        strRes = sb.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"?input_3?|>input_3<|")
    }
}

class MyVisitor <: NodeVisitor {
    let accum: StringBuilder
    var depth: Int64
    init(accum: StringBuilder, depth: Int64) {
        this.accum = accum
        this.depth = depth
    }
    public func head(node: Node, depth: Int64): Unit {
        var depth1 = depth
        depth1 = this.depth
        accum.append("?")
        accum.append("${node.nodeName()}_${this.depth}")
        accum.append("?")
    }
    public func tail(node: Node, depth: Int64): Unit {
        var depth2 = depth
        depth2 = this.depth
        accum.append("|>")
        accum.append("${node.nodeName()}_${this.depth}")
        accum.append("<|")
    }
}
