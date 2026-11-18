// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CommentCloneTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    let strAll2: String =
        "<!--TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode-->"

    @TestCase
    func commentClone01(): Unit {
        var comment: Comment = Comment("")
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }

    @TestCase
    func commentClone02(): Unit {
        var comment: Comment = Comment(" ")
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }

    @TestCase
    func commentClone03(): Unit {
        var comment: Comment = Comment(strAll1)
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }

    @TestCase
    func commentClone04(): Unit {
        var comment: Comment = Comment("~!@#$%^&*(){}><asdasadsdadas")
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }

    @TestCase
    func commentClone05(): Unit {
        var comment: Comment = Comment("<! dsadasdasdas>")
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }

    @TestCase
    func commentClone06(): Unit {
        var comment: Comment = Comment("<? dsadasdasdas>")
        var comment1: Comment = comment.clone()
        @Assert(refEq(comment, comment1), false)
        @Assert(comment.nodeName(), comment1.nodeName())
        @Assert(comment.toString(), comment1.toString())
        @Assert(comment.getData(), comment1.getData())
    }
}
