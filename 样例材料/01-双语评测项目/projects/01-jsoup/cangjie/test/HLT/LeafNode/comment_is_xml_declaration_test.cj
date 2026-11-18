// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CommentIsXmlDeclarationTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    let strAll2: String =
        "<!--TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode-->"

    @TestCase
    func commentIsXmlDeclaration01(): Unit {
        var comment: Comment = Comment("")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration02(): Unit {
        var comment: Comment = Comment(" ")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration03(): Unit {
        var comment: Comment = Comment(strAll1)
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration04(): Unit {
        var comment: Comment = Comment("~!@#$%^&*(){}><asdasadsdadas")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration05(): Unit {
        var comment: Comment = Comment("<! dsadasdasdas>")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration06(): Unit {
        var comment: Comment = Comment("<? dsadasdasdas>")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, false)
    }

    @TestCase
    func commentIsXmlDeclaration07(): Unit {
        var comment: Comment = Comment("? dsadasdasdas")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, true)
    }

    @TestCase
    func commentIsXmlDeclaration08(): Unit {
        var comment: Comment = Comment("! dsadasdasdas")
        var isBool: Bool = comment.isXmlDeclaration()
        @Assert(isBool, true)
    }
}
