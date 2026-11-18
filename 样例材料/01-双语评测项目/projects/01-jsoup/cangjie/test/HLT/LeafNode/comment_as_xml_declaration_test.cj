// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CommentAsXmlDeclarationTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    let strAll2: String =
        "<?extNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNod?>"

    @TestCase
    func commentAsXmlDeclaration01(): Unit {
        var comment: Comment = Comment("仓")
        var isBool: Bool = false
        @AssertThrows[IndexOutOfBoundsException](comment.asXmlDeclaration())
    }

    @TestCase
    func commentAsXmlDeclaration02(): Unit {
        var comment: Comment = Comment(" ")
        var isBool: Bool = false
        @AssertThrows[IndexOutOfBoundsException](comment.asXmlDeclaration())
    }

    @TestCase
    func commentAsXmlDeclaration03(): Unit {
        var comment: Comment = Comment(strAll1)
        var xmlDeclaration: XmlDeclaration = comment.asXmlDeclaration().getOrThrow()
        @Assert(xmlDeclaration.toString(), strAll2)
    }

    @TestCase
    func commentAsXmlDeclaration04(): Unit {
        var comment: Comment = Comment("~!@#$%^&*(){}><asdasadsdadas")
        var xmlDeclaration: ?XmlDeclaration = comment.asXmlDeclaration()
        var isBool: Bool = match (xmlDeclaration) {
            case None => true
            case _ => false
        }
        @Assert(isBool, true)
    }

    @TestCase
    func commentAsXmlDeclaration05(): Unit {
        var comment: Comment = Comment("<! dsadasdasdas>")
        var xmlDeclaration: ?XmlDeclaration = comment.asXmlDeclaration()
        var isBool: Bool = match (xmlDeclaration) {
            case None => true
            case _ => false
        }
        @Assert(isBool, true)
    }

    @TestCase
    func commentAsXmlDeclaration06(): Unit {
        var comment: Comment = Comment("<? dsadasdasdas>")
        var xmlDeclaration: ?XmlDeclaration = comment.asXmlDeclaration()
        var isBool: Bool = match (xmlDeclaration) {
            case None => true
            case _ => false
        }
        @Assert(isBool, true)
    }

    @TestCase
    func commentAsXmlDeclaration07(): Unit {
        var comment: Comment = Comment("? dsadasdasdas?")
        var xmlDeclaration: ?XmlDeclaration = comment.asXmlDeclaration()
        var isBool: Bool = match (xmlDeclaration) {
            case None => true
            case _ => false
        }
        @Assert(isBool, true)
    }

    @TestCase
    func commentAsXmlDeclaration08(): Unit {
        var comment: Comment = Comment("! dsadasdasdas!")
        var xmlDeclaration: ?XmlDeclaration = comment.asXmlDeclaration()
        var isBool: Bool = match (xmlDeclaration) {
            case None => true
            case _ => false
        }
        @Assert(isBool, true)
    }

    @TestCase
    func commentAsXmlDeclaration09(): Unit {
        var comment: Comment = Comment("?xml encoding='ISO-8859-1'?")
        var xmlDeclaration: XmlDeclaration = comment.asXmlDeclaration().getOrThrow()
        @Assert(xmlDeclaration.toString(), "<?xml encoding=\"ISO-8859-1\"?>")
    }
}
