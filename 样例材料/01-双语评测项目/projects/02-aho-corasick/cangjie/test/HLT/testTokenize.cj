// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testToken_Collection_00(): Unit {
        let speech: String = "The Answer to the Great Question... Of Life, " +
            "the Universe and Everything... Is... Forty-two,' said " + "Deep Thought, with infinite majesty and calm."
        var trie =
            Trie.builder().ignoreOverlaps().onlyWholeWords().ignoreCase().addKeyword("great question").addKeyword(
            "forty-two").addKeyword("deep thought").build()
        var tokens = trie.tokenize(speech)
        var html: StringBuilder = StringBuilder()
        html.append("<html><body><p>")
        for (token in tokens) {
            if (token.isMatch()) {
                html.append("<i>")
            }
            html.append(token.getFragment())
            if (token.isMatch()) {
                html.append("</i>")
            }
        }
        html.append("</p></body></html>")
    }

    @TestCase
    func testToken_Collection_01(): Unit {
        let speech: String = "Hear: Alpha team first, Beta from the rear, Gamma in reserve"
        var trie = Trie.builder().addKeyword("Alpha").addKeyword("Beta").addKeyword("Gamma").build()
        var tokens = trie.tokenize(speech)
        var fragments: Array<String> = ["Hear: ", "Alpha", " team first, ", "Beta", " from the rear, ", "Gamma",
        " in reserve"]
        var i = 0
        for (token in tokens) {
            @Assert(fragments[i], token.getFragment())
            i = i + 1
        }
        @Assert(7, i)
    }

    @TestCase
    func testToken_Collection_02(): Unit {
        let speech: String = ""
        var trie = Trie.builder().addKeyword("Alpha").addKeyword("Beta").addKeyword("Gamma").build()
        var tokens = trie.tokenize(speech)
        var i = 0
        for (token in tokens) {
            @Assert("", token.getFragment())
            i = i + 1
        }
        @Assert(0, i)
    }

    @TestCase
    func testToken_Collection_03(): Unit {
        let speech: String = "Hear: Alpha team first, Beta from the rear, Gamma in reserve"
        var trie = Trie.builder().addKeyword("Alpha").build()
        var tokens = trie.tokenize(speech)
        var fragments: Array<String> = ["Hear: ", "Alpha", " team first, Beta from the rear, Gamma in reserve"]
        var i = 0
        for (token in tokens) {
            @Assert(fragments[i], token.getFragment())
            i = i + 1
        }
        @Assert(3, i)
    }

    @TestCase
    func testToken_Collection_04(): Unit {
        let speech: String = "Hear: Alpha team first, Beta from the rear, Gamma in reserve"
        var trie = Trie.builder().addKeyword("*^&%&%").build()
        var tokens = trie.tokenize(speech)
        @Assert(1, tokens.size)
        var i = 0
        for (token in tokens) {
            @Assert("Hear: Alpha team first, Beta from the rear, Gamma in reserve", token.getFragment())
            i = i + 1
        }
        @Assert(1, i)
    }
}
