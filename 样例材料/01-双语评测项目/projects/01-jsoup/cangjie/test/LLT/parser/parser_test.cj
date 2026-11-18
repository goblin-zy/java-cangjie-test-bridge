// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.collection.*

main(): Int64 {
    let tester = ParserTest()
    tester.unescapeEntities()
    tester.unescapeEntitiesHandlesLargeInput()
    tester.testUtf8()
    tester.handlesDeepStack()
    0
}

@Test
public class ParserTest {
    @TestCase
    public func unescapeEntities(): Unit {
        let s: String = Parser.unescapeEntities("One &amp; Two", false)
        @Assert("One & Two", s)
    }

    // 2034000 ns
    @TestCase
    public func unescapeEntitiesHandlesLargeInput(): Unit {
        let longBody: StringBuilder = StringBuilder()
        do {
            longBody.append("SomeNonEncodedInput")
        } while (longBody.size < 64 * 1024)

        let body: String = longBody.toString()
        @Assert(body, Parser.unescapeEntities(body, false))
    }

    @TestCase
    public func testUtf8(): Unit {
        // testcase for https://github.com/jhy/jsoup/issues/1557. no repro.
        // let parsed:Document = Html4cj.parse(new ByteArrayInputStream("<p>H\u00E9llo, w\u00F6rld!".getBytes(StandardCharsets.UTF_8)), null, "")
        let parsed: Document = Html4cj.parse("<p>H\u{00E9}llo, w\u{00F6}rld!", "")
        let text: String = parsed.selectFirst("p").getOrThrow().wholeText()
        @Assert("H${'\u{00E9}'}llo, w${'\u{00F6}'}rld!", text)
    }

    // disabled by default now, as there more specific unconsume tests
    // 863111601600 ns (863s)
    @Skip
    @TestCase
    public func testIssue1251(): Unit {
        // https://github.com/jhy/jsoup/issues/1251
        let str: StringBuilder = StringBuilder("<a href=\"\"ca")
        for (countSpaces in 0..100000) {
            try {
                Parser.htmlParser().setTrackErrors(1).parseInput(str.toString(), "")
            } catch (e: Exception) {
                println("failed at length ${str.size}")
                throw e
            }
            str.append(countSpaces, ' ')
        }
    }

    // 2811661200 ns
    @TestCase
    public func handlesDeepStack(): Unit {
        // inspired by http://sv.stargate.wikia.com/wiki/M2J and https://github.com/jhy/jsoup/issues/955
        
        // Arrange
        let longBody: StringBuilder = StringBuilder()
        for (i in 0..25000) {
            longBody.append(i)
            longBody.append("<dl><dd>")
        }
        for (i in 0..25000) {
            longBody.append(i)
            longBody.append("</dd></dl>")
        }

        // Act
        let start: DateTime = DateTime.now()
        let doc: Document = Parser.parseBodyFragment(longBody.toString(), "")

        // Assert
        @Assert(2, doc.body().childNodeSize())
        @Assert(25000, doc.select("dd").size)
        @Assert(DateTime.now() - start < Duration.millisecond*20000)
    }
}