// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SelectorTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var htmlStr2: String = generateHTMLStr(4)

    @TestCase
    func testSelector_selectByEvaluator_01(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        strRes = doc.toString()
        var enter_Evaluator: Evaluator = myEvaluator("type")
        var eles: Elements = Selector.select(enter_Evaluator, doc) 
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        @Assert(eles.size,1)
        strRes = eles.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
        enter_Evaluator = myEvaluator("enter_Evaluator")
        eles = Selector.select(enter_Evaluator, doc)
        strRes = eles.toString()
        @Assert(strRes,"")
    }

    @TestCase
    func testSelector_selectByEvaluator_02(): Unit {
        var doc: Document = Html4cj.parse(htmlStr2)
        strRes = doc.toString()
        var enter_Evaluator: Evaluator = myEvaluator("only")
        var eles: Elements = Selector.select(enter_Evaluator, doc)
        strRes = eles.toString()
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        @Assert(eles.size,1)
        var ele_1: Element = eles.last().getOrThrow()
        strRes = ele_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<divid=\"only\">Sometextbeforethe<em>only</em>childinthisdiv</div>")
        strRes = enter_Evaluator.toString()
        @Assert(strRes,"#only")
        @Assert(enter_Evaluator.matches(None,ele_1),true)
    }
}

class myEvaluator <: Evaluator {
    private var id: String

    init(id: String) {
        this.id = id
    }

    public override func matches(root: ?Element, element: Element): Bool {
        return (root == None || id == element.id())
    }

    public func toString(): String {
        return "#${id}"
    }
}
