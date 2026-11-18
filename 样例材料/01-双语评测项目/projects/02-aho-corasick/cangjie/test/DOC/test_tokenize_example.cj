// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest05 = CharSearchTest05()
    charSearchTest05.testCharSearch01()
    return 0
}

@Test
public class CharSearchTest05 {

    @TestCase
    public func testCharSearch01(): Unit {

        let speech: String = "The Answer to the Great Question... Of Life, " +
            "the Universe and Everything... Is... Forty-two,' said " +
            "Deep Thought, with infinite majesty and calm."

        var trie = Trie.builder().ignoreOverlaps().onlyWholeWords().ignoreCase()
            .addKeyword("great question")
            .addKeyword("forty-two")
            .addKeyword("deep thought")
            .build()
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
        println(html)
    }
}
