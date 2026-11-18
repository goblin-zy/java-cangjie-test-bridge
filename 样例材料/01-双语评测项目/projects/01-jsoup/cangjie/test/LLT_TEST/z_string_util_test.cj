package cangjie_tpc::html4cj

@Test
public class StringUtilsTest {
    @TestCase
    public func join(): Unit {
        // 1 
        @Assert("", StringUtil.join(ArrayList<String>([""]), " "))
        @Assert("one", StringUtil.join(ArrayList<String>(["one"]), " "))
        @Assert("one two three", StringUtil.join(ArrayList<String>(["one", "two", "three"]), " "))

        println("Pass1")
    }

    @TestCase
    public func padding(): Unit {
        // 2 
        @Assert("", StringUtil.padding(0))
        @Assert(" ", StringUtil.padding(1))
        @Assert("  ", StringUtil.padding(2))
        @Assert("               ", StringUtil.padding(15))

        // we default to tap out at 30
        @Assert("                              ", StringUtil.padding(45))

        // memoization is up to 21 blocks (0 to 20 spaces) and exits early before min checks making maxPaddingWidth unused
        @Assert("", StringUtil.padding(0, -1))
        @Assert("                    ", StringUtil.padding(20, -1))

        // this test escapes memoization and continues through
        @Assert("                     ", StringUtil.padding(21, -1))

        // this test escapes memoization and using unlimited length (-1) will allow requested spaces
        @Assert("                              ", StringUtil.padding(30, -1))
        @Assert("                                             ", StringUtil.padding(45, -1))

        // we tap out at 0 for this test
        @Assert("", StringUtil.padding(0, 0))

        // as memoization is escaped, setting zero for max padding will not allow any requested width
        @Assert("", StringUtil.padding(21, 0))

        // we tap out at 30 for these tests making > 30 use 30
        @Assert("", StringUtil.padding(0, 30))
        @Assert(" ", StringUtil.padding(1, 30))
        @Assert("  ", StringUtil.padding(2, 30))
        @Assert("               ", StringUtil.padding(15, 30))
        @Assert("                              ", StringUtil.padding(45, 30))

        // max applies regardless of memoized
        @Assert(5, StringUtil.padding(20, 5).size)

        println("Pass2")
    }

    @TestCase
    public func paddingInACan(): Unit {
        // 3 
        let padding: Array<String> = StringUtil.paddingList
        @Assert(21, padding.size)
        for (i in 0..padding.size) {
            @Assert(i, padding[i].size)
        }

        println("Pass3")
    }

    @TestCase
    public func isBlank(): Unit {
        // 4 
        @Assert(StringUtil.isBlank(""), true)
        @Assert(StringUtil.isBlank("      "), true)
        @Assert(StringUtil.isBlank("   \r\n  "), true)
        @Assert(StringUtil.isBlank("hello"), false)
        @Assert(StringUtil.isBlank("   hello   "), false)

        println("Pass4")
    }

    @TestCase
    public func isNumeric(): Unit {
        // 5 
        @Assert(StringUtil.isNumeric(" "), false)
        @Assert(StringUtil.isNumeric("123 546"), false)
        @Assert(StringUtil.isNumeric("hello"), false)
        @Assert(StringUtil.isNumeric("123.334"), false)
        @Assert(StringUtil.isNumeric("1"), true)
        @Assert(StringUtil.isNumeric("1234"), true)

        println("Pass5")
    }

    @TestCase
    public func isWhitespace(): Unit {
        // 6
        @Assert(StringUtil.isWhitespace(r'\t'), true)
        @Assert(StringUtil.isWhitespace(r'\n'), true)
        @Assert(StringUtil.isWhitespace(r'\r'), true)
        @Assert(StringUtil.isWhitespace(r'\f'), true)
        @Assert(StringUtil.isWhitespace(r' '), true)
        @Assert(StringUtil.isWhitespace('\u{00a0}'), false)
        @Assert(StringUtil.isWhitespace('\u{2000}'), false)
        @Assert(StringUtil.isWhitespace('\u{3000}'), false)

        println("Pass6")
    }

    @TestCase
    public func normaliseWhiteSpace(): Unit {
        // 7 
        @Assert(" ", StringUtil.normaliseWhitespace("    \r \n \r\n"))
        @Assert(" hello there ", StringUtil.normaliseWhitespace("   hello   \r \n  there    \n"))
        @Assert("hello", StringUtil.normaliseWhitespace("hello"))
        @Assert("hello there", StringUtil.normaliseWhitespace("hello\nthere"))

        println("Pass7")
    }

    @TestCase
    public func normaliseWhiteSpaceHandlesHighSurrogates(): Unit {
        // 8 
        var test71540chars: String = "${'\u{2a6b2}'}${'\u{304b}'}${'\u{309a}'}  1"
        var test71540charsExpectedSingleWhitespace: String = "${'\u{2a6b2}'}${'\u{304b}'}${'\u{309a}'} 1"
        @Assert(test71540charsExpectedSingleWhitespace, StringUtil.normaliseWhitespace(test71540chars))
        var extractedText: String = Html4cj.parse(test71540chars).text()
        @Assert(test71540charsExpectedSingleWhitespace, extractedText)

        println("Pass8")
    }

    @TestCase
    public func resolvesRelativeUrls(): Unit {
        // 9 
        @Assert("http://example.com/one/two?three", StringUtil.resolve("http://example.com", "./one/two?three"))
        @Assert("http://example.com/one/two?three", StringUtil.resolve("http://example.com?one", "./one/two?three"))
        @Assert("http://example.com/one/two?three#four", StringUtil.resolve("http://example.com", "./one/two?three#four"))
        @Assert("https://example.com/one", StringUtil.resolve("http://example.com/", "https://example.com/one"))
        @Assert("http://example.com/one/two.html", StringUtil.resolve("http://example.com/two/", "../one/two.html"))
        @Assert("https://example2.com/one", StringUtil.resolve("https://example.com/", "//example2.com/one"))
        @Assert("https://example.com:8080/one", StringUtil.resolve("https://example.com:8080", "./one"))
        @Assert("https://example2.com/one", StringUtil.resolve("http://example.com/", "https://example2.com/one"))
        @Assert("https://example.com/one", StringUtil.resolve("wrong", "https://example.com/one"))
        @Assert("https://example.com/one", StringUtil.resolve("https://example.com/one", ""))
        @Assert("", StringUtil.resolve("wrong", "also wrong"))
        @Assert("ftp://example.com/one", StringUtil.resolve("ftp://example.com/two/", "../one"))
        @Assert("ftp://example.com/one/two.c", StringUtil.resolve("ftp://example.com/one/", "./two.c"))
        @Assert("ftp://example.com/one/two.c", StringUtil.resolve("ftp://example.com/one/", "two.c"))

        // examples taken from rfc3986 section 5.4.2
        @Assert("http://example.com/g", StringUtil.resolve("http://example.com/b/c/d;p?q", "../../../g"))
        @Assert("http://example.com/g", StringUtil.resolve("http://example.com/b/c/d;p?q", "../../../../g"))
        @Assert("http://example.com/g", StringUtil.resolve("http://example.com/b/c/d;p?q", "/./g"))
        @Assert("http://example.com/g", StringUtil.resolve("http://example.com/b/c/d;p?q", "/../g"))
        @Assert("http://example.com/b/c/g.", StringUtil.resolve("http://example.com/b/c/d;p?q", "g."))
        @Assert("http://example.com/b/c/.g", StringUtil.resolve("http://example.com/b/c/d;p?q", ".g"))
        @Assert("http://example.com/b/c/g..", StringUtil.resolve("http://example.com/b/c/d;p?q", "g.."))
        @Assert("http://example.com/b/c/..g", StringUtil.resolve("http://example.com/b/c/d;p?q", "..g"))
        @Assert("http://example.com/b/g", StringUtil.resolve("http://example.com/b/c/d;p?q", "./../g"))
        @Assert("http://example.com/b/c/g/", StringUtil.resolve("http://example.com/b/c/d;p?q", "./g/."))
        @Assert("http://example.com/b/c/g/h", StringUtil.resolve("http://example.com/b/c/d;p?q", "g/./h"))
        @Assert("http://example.com/b/c/h", StringUtil.resolve("http://example.com/b/c/d;p?q", "g/../h"))
        @Assert("http://example.com/b/c/g;x=1/y", StringUtil.resolve("http://example.com/b/c/d;p?q", "g;x=1/./y"))
        @Assert("http://example.com/b/c/y", StringUtil.resolve("http://example.com/b/c/d;p?q", "g;x=1/../y"))
        @Assert("http://example.com/b/c/g?y/./x", StringUtil.resolve("http://example.com/b/c/d;p?q", "g?y/./x"))
        @Assert("http://example.com/b/c/g?y/../x", StringUtil.resolve("http://example.com/b/c/d;p?q", "g?y/../x"))
        @Assert("http://example.com/b/c/g#s/./x", StringUtil.resolve("http://example.com/b/c/d;p?q", "g#s/./x"))
        @Assert("http://example.com/b/c/g#s/../x", StringUtil.resolve("http://example.com/b/c/d;p?q", "g#s/../x"))

        println("Pass9")
    }

    @TestCase
    public func stripsControlCharsFromUrls(): Unit {
        // 10 
        // should resovle to an absolute url:
        @Assert("foo:bar", StringUtil.resolve("\nhttps://\texample.com/", "\r\nfo\to:ba\br"))

        println("Pass10")
    }

    @TestCase
    public func allowsSpaceInUrl(): Unit {
        // 11   
        // @Assert("https://example.com/foo bar", StringUtil.resolve("HTTPS://example.com/example/", "../foo bar/"))
        @Assert("https://example.com/foo%20bar/", StringUtil.resolve("HTTPS://example.com/example/", "../foo bar/"))

        println("Pass11")
    }

    @TestCase
    public func isAscii(): Unit {
        // 12 
        @Assert(StringUtil.isAscii(""), true)
        @Assert(StringUtil.isAscii("example.com"), true)
        @Assert(StringUtil.isAscii("One Two"), true)
        @Assert(StringUtil.isAscii("🧔"), false)
        @Assert(StringUtil.isAscii("测试"), false)
        @Assert(StringUtil.isAscii("测试.com"), false)

        println("Pass12")
    }

    @TestCase
    public func startsWithNewlineTest(): Unit {
        // 13
        @Assert(StringUtil.startsWithNewline(""), false)
        @Assert(StringUtil.startsWithNewline("example.com"), false)
        @Assert(StringUtil.startsWithNewline("One Two"), false)
        @Assert(StringUtil.startsWithNewline("🧔"), false)
        @Assert(StringUtil.startsWithNewline("测试"), false)
        @Assert(StringUtil.startsWithNewline("测试.com"), false)
        @Assert(StringUtil.startsWithNewline("\n测试.com"), true)

        println("Pass13")
    }

    @TestCase
    public func inSortedTest(): Unit {
        // 14
        @Assert(StringUtil.inSorted("A",["one"]), false)
        @Assert(StringUtil.inSorted("A",["1", "2"]), false)
        @Assert(StringUtil.inSorted("A",["A"]), true)
        @Assert(StringUtil.inSorted("A",["one", "A"]), true)

        println("Pass14")
    }
}
