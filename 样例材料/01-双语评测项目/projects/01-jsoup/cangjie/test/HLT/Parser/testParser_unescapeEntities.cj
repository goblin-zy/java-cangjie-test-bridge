// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    let sourceDataIns: SourceData = SourceData()
    let HTMLStr: ArrayList<String> = sourceDataIns.generateHTMLStr()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"

    @TestCase
    func testParser_unescapeEntities_01(): Unit {
        strRes = Parser.unescapeEntities(htmlStr, true)
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>")
        strRes = Parser.unescapeEntities(htmlStr, false) //同java
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>")
        htmlStr = """
                 """
        strRes = Parser.unescapeEntities(htmlStr, false) //同java
        @Assert(sourceDataIns.parseString(strRes,false),"")
    }

    @TestCase
    func testParser_unescapeEntities_02(): Unit {
        htmlStr = "<12> id='pseudo'> </?!>"
        strRes = Parser.unescapeEntities(htmlStr, true)
        @Assert(sourceDataIns.parseString(strRes,false),"<12> id='pseudo'> </?!>")
        strRes = Parser.unescapeEntities(htmlStr, false) //同java
        @Assert(sourceDataIns.parseString(strRes,false),"<12> id='pseudo'> </?!>")
        htmlStr = """
                    你好仓颉！【】|</<>>
                 """
        strRes = Parser.unescapeEntities(htmlStr, true) //同java
        @Assert(sourceDataIns.parseString(strRes,false),"你好仓颉！【】|</<>>")
    }
}
