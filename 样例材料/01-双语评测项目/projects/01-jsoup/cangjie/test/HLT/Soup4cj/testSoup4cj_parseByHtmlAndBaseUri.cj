// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class Html4cjTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    let HTMLStr: ArrayList<String> = sourceDataIns.generateHTMLStr()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var returnFlag: Int64 = -1

    @TestCase
    func testHtml4cj_parseByHtmlAndBaseUri_01(): Unit {
        var doc: Document = Html4cj.parse(htmlStr, baseURL[16]) // "http://jsoup.org/" 
        strRes = doc.head().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<head></head>")
        strRes = doc.body().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<body> <div id=\"pseudo\">  <p>test_1</p>  <div id=\"type\"><span>1</span>  </div> </div></body>")
        var els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        doc = Html4cj.parse(htmlStr, baseURL[6]) // uri不可达
        strRes = doc.nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"#document")
        doc = Html4cj.parse(htmlStr, baseURL[18]) // uri不可达 中文
        strRes = doc.charset()
        @Assert(sourceDataIns.parseString(strRes,false),"UTF-8")
        els_1 = doc.select("div#type")
        strRes = els_1.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"type\"><span>1</span></div>")
    }

    @TestCase
    func testHtml4cj_parseByHtmlAndBaseUri_02(): Unit {
        htmlStr = """
                  """
        var doc: Document = Html4cj.parse(htmlStr, baseURL[16]) // "http://jsoup.org/" html为空
        strRes = doc.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body></body></html>")
        htmlStr = HTMLStr[3]
        doc = Html4cj.parse(htmlStr, "") // uri空
        strRes = doc.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head>  <meta charset=\"utf-16\">  <title>SoupTest</title> </head> <body></body></html>")
        strRes = doc.head().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<head> <meta charset=\"utf-16\"> <title>SoupTest</title></head>")
        strRes = doc.body().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<body></body>")
        strRes = doc.title()
        @Assert(sourceDataIns.parseString(strRes,false),"SoupTest")
    }

    @TestCase
    func testHtml4cj_parseByHtmlAndBaseUri_03(): Unit {
        strRes = ""
        htmlStr = """
                  """
        var doc: Document = Html4cj.parse(htmlStr, "") //  html  uri均为空
        strRes = doc.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<html> <head></head> <body></body></html>")
        htmlStr = "<meta charset=\"utf-8\"> <title>HTML5新元素</title> </head> <body>  <video width=\"320\" height=\"240\" controls> <source src=\"movie.mp4\" type=\"video/mp4\"> <source src=\"movie.ogg\" type=\"video/ogg\"> 您的浏览器不支持 HTML5 video 标签。 </video>"
        doc = Html4cj.parse(htmlStr, "") // uri空
        strRes = doc.outerHtml()
        strRes = doc.head().toString()
        @Assert(sourceDataIns.parseString(strRes),"<head><metacharset=\"utf-8\"><title>HTML5新元素</title></head>")
        var eles_1: Elements = doc.body().select("source")
        strRes = eles_1[0].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<source src=\"movie.mp4\" type=\"video/mp4\">")
        strRes = eles_1[1].outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<source src=\"movie.ogg\" type=\"video/ogg\">")
        strRes = doc.title()
        @Assert(sourceDataIns.parseString(strRes,false),"HTML5新元素")
    }

    @TestCase
    func testHtml4cj_parseByHtmlAndBaseUri_04(): Unit {
        strRes = ""
        htmlStr = "<div身份='pseudo'><标签头>test_1 </标签尾></【加油 >"
        var doc: Document = Html4cj.parse(htmlStr, baseURL[15]) //uri可达
        strRes = doc.outerHtml()
        var eles_1: Elements = doc.select("div")
        strRes = eles_1.toString()
        @Assert(strRes,"")
        eles_1 = doc.body().select("标签头")
        strRes = eles_1.toString()
        @Assert(strRes,"")
        htmlStr = "<li> <div身份><标签头>test_1 </标签尾></【加油 >"
        doc = Html4cj.parse(htmlStr, "")
        eles_1 = doc.select("li")
        strRes = eles_1.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<li><div身份>  &lt;标签头&gt;test_1 <!--/标签尾--><!--/【加油 --> </div身份></li>") // 同java
        var ele_Res: ArrayList<Comment> = eles_1.comments()
        @Assert(ele_Res.size , 0)
    }

    @TestCase
    func testHtml4cj_parseByHtmlAndBaseUri_05(): Unit {
        strRes = ""
        htmlStr = generateHTMLStr(650) // html超长
        var doc: Document = Html4cj.parse(htmlStr, baseURL[16]) //uri可达
        var eles_1: Elements = doc.select("div#type").select("p")
        @Assert(eles_1.size ,650)
        strRes = eles_1.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>1</p>")
        strRes = eles_1.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>650</p>")
    }
}
