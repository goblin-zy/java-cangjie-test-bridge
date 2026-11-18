// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_57_01(): Unit {
        let cou = "<input value='one' /><textarea>two</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("input")
        let sc = str.val()
        @Assert(3,sc.size)
        @Assert(sc.toString().contains("one"),true)
    }

    @TestCase
    func testElement_57_02(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let sc = str.val()
        @Assert(5,sc.size)
        @Assert(sc.toString().contains("twoss"),true)
    }

    @TestCase
    func testElement_57_03(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let sc = str.val("你好仓颉！【】")
        @Assert(28,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<textarea>你好仓颉！【】</textarea>"),true)
    }

    @TestCase
    func testElement_57_04(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let sc = str.val("")
        @Assert(21,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<textarea></textarea>"),true)
    }

    @TestCase
    func testElement_57_05(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let sc = str.val("data-sse")
        @Assert(29,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<textarea>data-sse</textarea>"),true)
    }

    @TestCase
    func testElement_57_06(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let sc = str.val("/ttn")
        @Assert(25,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<textarea>/ttn</textarea>"),true)
    }

    @TestCase
    func testElement_57_07(): Unit {
        let cou = "<input value='one' /><textarea>twoss</textarea>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("textarea")
        let darss = generateHTMLStr().toString()
        let sc = str.val(darss)
        @Assert(1858,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("&lt;/body&gt; &lt;/html&gt;, &lt;html&gt; &lt;"),true)
    }
}
public func generateHTMLStr(): ArrayList<String> {
    var arrL: ArrayList<String> = ArrayList<String>()
    arrL.add(
        "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
    )
    arrL.add(
        "<html> <head> <title>SoupTest</title> </head> <body> <p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> </body> </html>"
    )
    arrL.add("<html> <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>")
    arrL.add("<head> <meta charset=\"utf-16\"> <title>SoupTest</title> </head> </html>")
    arrL.add("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>")
    arrL.add("  <head> <meta charset=\"ASCII\"> <title>SoupTest</title>")
    arrL.add("<meta charset=\"utf-8\"> <title>SoupTest</title> </head>")
    arrL.add("<body> <p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> ")
    arrL.add("<p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> </body>")
    arrL.add("<body> <p id=\"id_P\"> 刺昂仓，\n季叶杰 <span class=\"cla_1\"> hel\rlo </span> </p> </body>")
    arrL.add("<head> hello <meta charset=\"utf-8\">你好呀 <title>SoupTest</title> </head>")
    arrL.add("<head_Soup> <meta charset=\"utf-8\"> <title22>SoupTest</title22> </head_Soup>")
    arrL.add(
        "<!DOCTYPE html> <html> <head> <script language=\"javascript\"> document.location = \"http://www.baidu.com\"; </script> </head> </html>"
    )
    arrL.add("<BODY> <P ID=\"ID_P\"> <SPAN CLASS=\"CLA_1\"> HELLO </SPAN> </P> </BODY>")
    arrL.add("<BODY> <p ID=\"id_p\"> <SPAN CLASS=\"cla_1\"> hello </SPAN> </p> </body>")
    arrL.add("<body> <输入type=\"text\"> <范围> 打我呀 </范围> </body>")

    return arrL
}
