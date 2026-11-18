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
    func testElements_filter_01(): Unit {
        let sb: StringBuilder = StringBuilder()
        var doc: Document = Html4cj.parse(htmlStr)
        let headFunc: filterFunc = {
            node, depth =>
            sb.append("<")
            sb.append("${node.nodeName()}${depth}_$head$")
            sb.append(">")
            return FilterResult.CONTINUE
        }
        let tailFunc: filterFunc = {
            node, depth =>
            sb.append("|>")
            sb.append("${node.nodeName()}${depth}_$tail$")
            sb.append("<|")
            return if ("textarea" == node.nodeName()) {
                FilterResult.STOP
            } else {
                FilterResult.CONTINUE
            }
        }
        let filter = MyNodeFilter(headFunc, tailFunc)
        doc.select("form > input:first-child").filter(filter)
        strRes = sb.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<input0_$head$>|>input0_$tail$<|")
    }
}

type filterFunc = (Node, Int64) -> FilterResult
class MyNodeFilter <: NodeFilter {
    let headFunc: filterFunc
    let tailFunc: filterFunc
    init(headFunc: filterFunc, tailFunc: filterFunc) {
        this.headFunc = headFunc
        this.tailFunc = tailFunc
    }
    public override func head(node: Node, depth: Int64): FilterResult {
        return headFunc(node, depth)
    }
    public override func tail(node: Node, depth: Int64): FilterResult {
        return tailFunc(node, depth)
    }
}
