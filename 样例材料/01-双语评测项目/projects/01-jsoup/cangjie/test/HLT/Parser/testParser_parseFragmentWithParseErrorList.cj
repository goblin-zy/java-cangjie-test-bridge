// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    let HTMLStr: ArrayList<String> = sourceDataIns.generateHTMLStr()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var returnFlag: Int64 = -1
    let errorList_1: ParseErrorList = ParseErrorList.noTracking()
    let errorList_2: ParseErrorList = ParseErrorList.tracking(8)

    @TestCase
    func testParser_parseFragmentWithParseErrorList_01(): Unit {
        var nodeArrL: ArrayList<Node> = Parser.parseFragment(htmlStr, None, baseURL[16], errorList_1) // "http://jsoup.org/" 
        @Assert(nodeArrL.size,1)
        var node_1: Node = nodeArrL[0]
        strRes = node_1.toString()
        strRes = node_1.nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"html")
        @Assert(node_1.attributesSize(),0)
        strRes = node_1.baseUri()
        @Assert(sourceDataIns.parseString(strRes,false),"http://jsoup.org/")
        var ele: Element = Element("div")
        nodeArrL = Parser.parseFragment(htmlStr, ele, baseURL[16], errorList_1)
        @Assert(nodeArrL.size,6) //同java
        strRes = nodeArrL[0].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"#text") //同java
        strRes = nodeArrL[3].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"div")
        strRes = nodeArrL[3].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"pseudo\"> <p>test_1</p> <div id=\"type\"><span>1</span> </div></div>")
    }

    @TestCase
    func testParser_parseFragmentWithParseErrorList_02(): Unit {
        htmlStr = """
                  """
        var nodeArrL: ArrayList<Node> = Parser.parseFragment(htmlStr, None, baseURL[16], errorList_1) // "http://jsoup.org/" 
        @Assert(nodeArrL.size,1)
        var node_1: Node = nodeArrL[0]
        strRes = node_1.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body></body></html>")
        htmlStr = HTMLStr[3]
        var ele: Element = Element("meta")
        nodeArrL = Parser.parseFragment(htmlStr, ele, baseURL[16], errorList_1)
        @Assert(nodeArrL.size,6) //同java
        strRes = nodeArrL[0].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"#text") //同java
        strRes = nodeArrL[1].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"meta")
        strRes = nodeArrL[3].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<title>SoupTest</title>")
        strRes = nodeArrL[3].baseUri()
        @Assert(sourceDataIns.parseString(strRes,false),"http://jsoup.org/")
    }

    @TestCase
    func testParser_parseFragmentWithParseErrorList_03(): Unit {
        htmlStr = """
                  """
        var nodeArrL: ArrayList<Node> = Parser.parseFragment(htmlStr, None, "", errorList_2) // html  uri均为空
        @Assert(nodeArrL.size,1)
        var node_1: Node = nodeArrL[0]
        strRes = nodeArrL[0].baseUri()
        @Assert(sourceDataIns.parseString(strRes,false),"")
        strRes = node_1.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body></body></html>")
        htmlStr = "<meta charset=\"utf-8\"> <title>HTML5新元素</title> </head> <body>  <video width=\"320\" height=\"240\" controls> <source src=\"movie.mp4\" type=\"video/mp4\"> <source src=\"movie.ogg\" type=\"video/ogg\"> 您的浏览器不支持 HTML5 video 标签。 </video>"
        var ele: Element = Element("source")
        nodeArrL = Parser.parseFragment(htmlStr, ele, "baseURL在这", errorList_2)
        @Assert(nodeArrL.size,7) //同java
        strRes = nodeArrL[0].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"meta")
        strRes = nodeArrL[1].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"#text")
        strRes = nodeArrL[2].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<title>HTML5新元素</title>")
        strRes = nodeArrL[3].baseUri()
        @Assert(sourceDataIns.parseString(strRes,false),"baseURL在这")
        ele = Element("style")
        nodeArrL = Parser.parseFragment(htmlStr, ele, "baseURL在这", errorList_2)
        @Assert(nodeArrL.size,1) //同java
        strRes = nodeArrL[0].nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"#data")
    }
}
