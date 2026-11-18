// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let commentTest: CommentTest = CommentTest()

    commentTest.nodeName()
    commentTest.getData()
    commentTest.testToString()
    commentTest.testHtmlNoPretty()
    commentTest.testClone()

    commentTest.isXmlDeclaration()
    commentTest.asXmlDeclaration()

    return 0
}

@Test
public class CommentTest {
    private let comment: Comment = html4cj.Comment(" This is one heck of a comment! ")

    private let decl: Comment = html4cj.Comment("?xml encoding='ISO-8859-1'?")

    @TestCase
    public func nodeName(): Unit {
        // 1
        @Assert("#comment", comment.nodeName())

        println("Pass1")
    }

    @TestCase
    public func getData(): Unit {
        // 2
        @Assert(" This is one heck of a comment! ", comment.getData())

        println("Pass2")
    }

    @TestCase
    public func testToString(): Unit {
        // 3
        @Assert("<!-- This is one heck of a comment! -->", comment.toString())
        var doc: Document = Html4cj.parse("<div><!-- comment--></div>")
        @Assert("<div>\n <!-- comment-->\n</div>", doc.body().html())
        doc = Html4cj.parse("<p>One<!-- comment -->Two</p>")
        @Assert("<p>One<!-- comment -->Two</p>", doc.body().html())
        @Assert("OneTwo", doc.text())

        println("Pass3")
    }

    @TestCase
    public func testHtmlNoPretty(): Unit {
        // 4
        var doc: Document = Html4cj.parse("<!-- a simple comment -->")
        doc.outputSettings().prettyPrint(false)
        @Assert("<!-- a simple comment --><html><head></head><body></body></html>", doc.html())
        var node: Node = doc.childNode(0)
        var c1: Comment = (node as Comment).getOrThrow()
        @Assert("<!-- a simple comment -->", c1.outerHtml())

        println("Pass4")
    }

    @TestCase
    public func testClone(): Unit {
        // 5
        var c1: Comment = comment.clone()
        @Assert(refEq(comment, c1), false)
        @Assert(comment.getData(), comment.getData())
        c1.setData("New")
        @Assert("New", c1.getData())
        @Assert((c1.getData() != comment.getData()), true)

        println("Pass5")
    }

    @TestCase
    public func isXmlDeclaration(): Unit {
        // 6
        @Assert(comment.isXmlDeclaration(), false)
        @Assert(decl.isXmlDeclaration(), true)

        println("Pass6")
    }

    @TestCase
    public func asXmlDeclaration(): Unit {
        // 7
        decl.asXmlDeclaration().getOrThrow()

        println("Pass7")
    }

    @TestCase
    public func initTest(): Unit {
        // 8
        var commentNode: Comment = html4cj.Comment("public override func clone(): Comment")
        @Assert(commentNode.nodeName(), "#comment")
        @Assert(commentNode.getData(), "public override func clone(): Comment")
        commentNode.setData("注释")
        @Assert(commentNode.getData(), "注释")
        @Assert(commentNode.toString(), "<!--注释-->")
        @Assert(commentNode.isXmlDeclaration(), false)
        commentNode.asXmlDeclaration()

        var commentNode1: Comment = html4cj.Comment("?xml encoding='ISO-8859-1'?")
        @Assert(commentNode1.nodeName(), "#comment")
        @Assert(commentNode1.getData(), "?xml encoding='ISO-8859-1'?")
        @Assert(commentNode1.toString(), "<!--?xml encoding='ISO-8859-1'?-->")
        @Assert(commentNode1.isXmlDeclaration(), true)
        var xmlDeclarat1: XmlDeclaration = commentNode1.asXmlDeclaration().getOrThrow()
        @Assert(xmlDeclarat1.toString(), "<?xml encoding=\"ISO-8859-1\"?>")

        println("Pass8")
    }
}
