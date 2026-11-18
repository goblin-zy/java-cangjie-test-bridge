package cjmustache.test

import cjmustache.*

import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.collection.*

@Test
public class CompileTest {
    @TestCase func compileTEst() {
        try {
            let compile = Mustache.compiler().compile(
                convertEscapes(String.fromUtf8(
                    File.readFrom(Path("src/test/templates/main.html")))))
            @Expect(true)
        } catch (e: Exception) {
            @Expect(false)
        }
    }

    private let ESCAPE_MAP = HashMap<String, String>([
        ("\\\\", "\\"),
        ("\\n", "\n"),
        ("\\r", "\r"),
        ("\\t", "\t"),
        ("\\b", "\b"),
        ("\\f", "\f"),
        ("\r\n\r\n", "")
    ])

    private func convertEscapes(content: String): String {
        var result = content
        for (entry in ESCAPE_MAP.toArray()) {
            result = result.replace(entry[0], entry[1])
        }
        return result
    }
}