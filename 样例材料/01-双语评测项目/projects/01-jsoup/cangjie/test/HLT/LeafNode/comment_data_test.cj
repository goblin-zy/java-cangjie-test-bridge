// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CommentDataTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    let strAll2: String =
        "<!--TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode-->"

    @TestCase
    func commentData01(): Unit {
        var comment: Comment = Comment("")
        @Assert(comment.getData(), "")
        @Assert(comment.toString(), "<!---->")
        comment.setData(" ")
        @Assert(comment.getData(), " ")
        @Assert(comment.toString(), "<!-- -->")
    }

    @TestCase
    func commentData02(): Unit {
        var comment: Comment = Comment(" ")
        @Assert(comment.getData(), " ")
        @Assert(comment.toString(), "<!-- -->")
        comment.setData("")
        @Assert(comment.getData(), "")
        @Assert(comment.toString(), "<!---->")
        comment.setData(strAll1)
        @Assert(comment.getData(), strAll1)
        @Assert(comment.toString(), strAll2)
    }

    @TestCase
    func commentData03(): Unit {
        var comment: Comment = Comment(strAll1)
        @Assert(comment.getData(), strAll1)
        @Assert(comment.toString(), strAll2)
        comment.setData("commentData03")
        @Assert(comment.getData(), "commentData03")
        @Assert(comment.toString(), "<!--commentData03-->")
    }

    @TestCase
    func commentData04(): Unit {
        var comment: Comment = Comment("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(comment.getData(), "~!@#$%^&*(){}><asdasadsdadas")
        @Assert(comment.toString(), "<!--~!@#$%^&*(){}><asdasadsdadas-->")
        comment.setData("commentData04")
        @Assert(comment.getData(), "commentData04")
        @Assert(comment.toString(), "<!--commentData04-->")
    }

    @TestCase
    func commentData05(): Unit {
        var comment: Comment = Comment("<! dsadasdasdas>")
        @Assert(comment.getData(), "<! dsadasdasdas>")
        @Assert(comment.toString(), "<!--<! dsadasdasdas>-->")
        comment.setData("commentData05")
        @Assert(comment.getData(), "commentData05")
        @Assert(comment.toString(), "<!--commentData05-->")
    }

    @TestCase
    func commentData06(): Unit {
        var comment: Comment = Comment("<? dsadasdasdas>")
        @Assert(comment.getData(), "<? dsadasdasdas>")
        @Assert(comment.toString(), "<!--<? dsadasdasdas>-->")
        comment.setData("commentData06")
        @Assert(comment.getData(), "commentData06")
        @Assert(comment.toString(), "<!--commentData06-->")
    }
}
