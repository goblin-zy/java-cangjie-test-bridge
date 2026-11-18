package cangjie_tpc::html4cj

@Test
public class CharacterReaderTest {
    @TestCase
    public func advance(): Unit {
        let r = CharacterReader("One Two Three")
        @Assert(r'O', r.consume())
        r.advance();
        @Assert(r'e', r.consume())
    }

    @TestCase
    public func buffer_up(): Unit {
        let note = "HelloThere"
        let loopCount = 64
        let sb = StringBuilder()
        for (i in 0..loopCount) {
            i
            sb.append(note)
            sb.append("!")
        }

        let s = sb.toString()

        let r = CharacterReader(s)
        for (i in 0..loopCount) {
            i
            let pull = r.consumeTo(r'!')
            @Assert(note, pull)
            @Assert(r'!', r.current())
            r.advance()
        }

        @Assert(r.isEmpty())
    }

    @TestCase
    public func caches_strings(): Unit {
        let r = CharacterReader("Check\tCheck\tCheck\tCHOKE\tA string that is longer than 16 chars")
        let one = r.consumeTo(r'\t')
        r.consume()
        let two = r.consumeTo(r'\t')
        r.consume()
        let three = r.consumeTo(r'\t')
        r.consume()
        let four = r.consumeTo(r'\t')
        r.consume()
        let five = r.consumeTo(r'\t')

        @Assert("Check", one)
        @Assert("Check", two)
        @Assert("Check", three)
        @Assert("CHOKE", four)
        @Assert(one== two)
        @Assert(two== three)
        @Assert(three!= four)
        @Assert(four!=five)
        @Assert(five, "A string that is longer than 16 chars")
    }

    @TestCase
    public func can_enable_and_disable_line_number_tracking(): Unit {
        let reader = CharacterReader("Hello!")
        @Assert(reader.isTrackNewlines(), false)
        reader.trackNewlines(true)
        @Assert(reader.isTrackNewlines())
        reader.trackNewlines(false)
        @Assert(reader.isTrackNewlines(), false)
    }

    @TestCase
    public func can_track_newlines(): Unit {
        let builder = StringBuilder()
        builder.append("<foo>\n<bar>\n<qux>\n")
        while (builder.size < CharacterReader.maxBufferLen) {
            builder.append("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
        builder.append("[foo]\n[bar]")
        let content = builder.toString()

        let noTrack = CharacterReader(content)
        @Assert(noTrack.isTrackNewlines(), false)
        let track = CharacterReader(content)
        track.trackNewlines(true)
        @Assert(track.isTrackNewlines())

        @Assert(0, noTrack.pos())
        @Assert(1, noTrack.lineNumber())
        @Assert(1, noTrack.columnNumber())
        noTrack.consumeTo("<qux>")
        @Assert(12, noTrack.pos())
        @Assert(1, noTrack.lineNumber())
        @Assert(13, noTrack.columnNumber())
        @Assert("1:13", noTrack.cursorPos())

        while (!noTrack.matches("[foo]")) {
            noTrack.consumeTo("[foo]")
        }
        @Assert(32778, noTrack.pos())
        @Assert(1, noTrack.lineNumber())
        @Assert(noTrack.pos()+1, noTrack.columnNumber())
        @Assert("1:32779", noTrack.cursorPos())

        println("-----011-${track.pos()} ${track.cursorPos()}")
        @Assert(0, track.pos())
        @Assert(1, track.lineNumber())
        @Assert(1, track.columnNumber())

        track.consumeTo(r'\n')
        println("-----516-${track.pos()} ${track.cursorPos()}")
        @Assert(1, track.lineNumber())
        @Assert(6, track.columnNumber())

        track.consume()
        println("-----621-${track.pos()} ${track.cursorPos()}")
        @Assert(2, track.lineNumber())
        @Assert(1, track.columnNumber())

        @Assert("<bar>", track.consumeTo(r'\n'))
        println("-----1126-${track.pos()} ${track.cursorPos()}")
        @Assert(2, track.lineNumber())
        @Assert(6, track.columnNumber())

        @Assert("\n", track.consumeTo("<qux>"))
        @Assert(12, track.pos())
        @Assert(3, track.lineNumber())
        @Assert(1, track.columnNumber())
        @Assert("3:1", track.cursorPos())
        @Assert("<qux>", track.consumeTo(r'\n'))
        @Assert("3:6", track.cursorPos())

        while (!track.matches("[foo]")) {
            track.consumeTo("[foo]")
        }
        @Assert(32778, track.pos())
        @Assert(4, track.lineNumber())
        @Assert(32761, track.columnNumber())
        @Assert("4:32761", track.cursorPos())
        track.consumeTo(r'\n')
        @Assert("4:32766", track.cursorPos())

        track.consumeTo("[bar]")
        @Assert(5, track.lineNumber())
        @Assert("5:1", track.cursorPos())
        track.consumeToEnd()
        @Assert("5:6", track.cursorPos())
    }

    @TestCase
    public func consume_letter_sequence(): Unit {
        let r = CharacterReader("One &bar; qux")
        @Assert("One", r.consumeLetterSequence())
        @Assert(" &", r.consumeTo("bar;"))
        @Assert("bar", r.consumeLetterSequence())
        @Assert("; qux", r.consumeToEnd())
    }

    @TestCase
    public func consume_letter_then_digit_sequence(): Unit {
        let r = CharacterReader("One12 Two &bar; qux")
        @Assert("One12", r.consumeLetterThenDigitSequence())
        @Assert(r' ', r.consume())
        @Assert("Two", r.consumeLetterThenDigitSequence())
        @Assert(" &bar; qux", r.consumeToEnd())
    }

    @TestCase
    public func consume_to_any(): Unit {
        let r = CharacterReader("One &bar; qux")
        let a = r.consumeToAny([r'&', r';'])
        println("-----${a}")
        @Assert("One ", a)
        @Assert(r.matches(r'&'))
        @Assert(r.matches("&bar;"))
        @Assert(r'&', r.consume())
        @Assert("bar", r.consumeToAny([r'&', r';']))
        @Assert(r';', r.consume())
        @Assert(" qux", r.consumeToAny([r'&', r';']))
    }

    @TestCase
    public func consume_to_char(): Unit {
        let r = CharacterReader("One Two Three");
        @Assert("One ", r.consumeTo(r'T'))
        @Assert("", r.consumeTo(r'T'))
        @Assert(r'T', r.consume())
        @Assert("wo ", r.consumeTo(r'T'))
        @Assert(r'T', r.consume())
        @Assert("hree", r.consumeTo(r'T'))
    }

    @TestCase
    public func consume_to_end(): Unit {
        let inStr = "one two three"
        let r = CharacterReader(inStr)
        let toEnd = r.consumeToEnd()
        @Assert(inStr, toEnd)
        @Assert(r.isEmpty())
    }

    @TestCase
    public func consume_to_nonexistent_end_when_at_and(): Unit {
        let r = CharacterReader("<!")
        @Assert(r.matchConsume("<!"))
        @Assert(r.isEmpty())

        let after = r.consumeTo(r'>')
        @Assert("", after)

        @Assert(r.isEmpty())
    }

    @TestCase
    public func consume_to_string(): Unit {
        let r = CharacterReader("One Two Two Four")
        @Assert("One ", r.consumeTo("Two"))
        @Assert(r'T', r.consume())
        @Assert("wo ", r.consumeTo("Two"))
        @Assert(r'T', r.consume())

        let builder = StringBuilder()
        var part: String
        do {
            part = r.consumeTo("Qux")
            builder.append(part)
        } while (!part.isEmpty())
        @Assert("wo Four", builder.toString())
    }

    @TestCase
    public func consume(): Unit {
        let r = CharacterReader("one")
        @Assert(0, r.pos())
        @Assert(r'o', r.current())
        @Assert(r'o', r.consume())
        @Assert(1, r.pos())
        @Assert(r'n', r.current())
        @Assert(1, r.pos())
        @Assert(r'n', r.consume())
        @Assert(r'e', r.consume())
        @Assert(r.isEmpty(), true)
        @Assert(CharacterReader.EOF, r.consume())
        @Assert(r.isEmpty(),true)
        @Assert(CharacterReader.EOF, r.consume())
    }

    @TestCase
    public func contains_ignore_case_buffer(): Unit {
        let html = "<p><p><p></title><p></TITLE><p>" + BufferBuster("Foo Bar Qux ") + "<foo><bar></title>"
        let r = CharacterReader(html)

        @Assert(r.containsIgnoreCase("</title>"))
        @Assert(r.containsIgnoreCase("</not>"), false)
        @Assert(r.containsIgnoreCase("</not>"), false)
        @Assert(r.containsIgnoreCase("</title>"))
        r.consumeTo("</title>")
        @Assert(r.containsIgnoreCase("</title>"))
        r.consumeTo("<p>")
        @Assert(r.matches("<p>"))

        @Assert(r.containsIgnoreCase("</title>"))
        @Assert(r.containsIgnoreCase("</title>"))
        @Assert(r.containsIgnoreCase("</not>"), false)
        @Assert(r.containsIgnoreCase("</not>"), false)

        r.consumeTo("</TITLE>")
        r.consumeTo("<p>")
        @Assert(r.matches("<p>"))
        @Assert(r.containsIgnoreCase("</title>"), false)
        r.consumeTo("<foo>")
        @Assert(r.matches("<foo>"), false)
        r.consumeTo("<foo>")
        @Assert(r.matches("<foo>"))
        @Assert(r.containsIgnoreCase("</TITLE>"))
        @Assert(r.containsIgnoreCase("</title>"))
    }

    public func BufferBuster(content: String): String {
        let builder = StringBuilder()
        while (builder.size < CharacterReader.maxBufferLen) {
            builder.append(content)
        }
        return builder.toString()
    }

    @TestCase
    public func contains_ignore_case(): Unit {
        let r = CharacterReader("One TWO three")
        @Assert(r.containsIgnoreCase("two"))
        @Assert(r.containsIgnoreCase("three"))

        @Assert(r.containsIgnoreCase("one"), false)
    }

    @TestCase
    public func counts_columns_over_buffer_when_no_newlines(): Unit {
        let builder = StringBuilder()
        while (builder.size < CharacterReader.maxBufferLen * 4) {
            builder.append("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
        let content = builder.toString()
        let reader = CharacterReader(content)
        reader.trackNewlines(true)

        @Assert("1:1", reader.cursorPos())
        while (!reader.isEmpty()) {
            reader.consume()
        }
        @Assert(131096, reader.pos())
        @Assert(reader.pos() + 1, reader.columnNumber())
        @Assert(1, reader.lineNumber())
    }

    @TestCase
    public func empty(): Unit {
        var r = CharacterReader("One")
        @Assert(r.matchConsume("One"))
        @Assert(r.isEmpty())

        r = CharacterReader("Two")
        let two = r.consumeToEnd()
        @Assert("Two", two)
    }

    @TestCase
    public func linenumbers_agree_with_editor(): Unit {
        let bytes = File.readFrom("test/htmltests/large.html")
        let content = String.fromUtf8(bytes)
        let reader = CharacterReader(content)
        reader.trackNewlines(true)

        let scan = "<p>VESTIBULUM"
        while (!reader.matches(scan)) {
            reader.consumeTo(scan)
        }

        @Assert(280218, reader.pos())
        @Assert(1002, reader.lineNumber())
        @Assert(1, reader.columnNumber())
        reader.consumeTo(r' ')
        @Assert(1002, reader.lineNumber())
        @Assert(14, reader.columnNumber())
    }

    @TestCase
    public func mark(): Unit {
        let r = CharacterReader("one")
        r.consume()
        r.mark()
        @Assert(1, r.pos())
        @Assert(r'n', r.consume())
        @Assert(r'e', r.consume())
        @Assert(r.isEmpty())
        r.rewindToMark()
        @Assert(1, r.pos())
        @Assert(r'n', r.consume())
        @Assert(r.isEmpty(),false)
        @Assert(2, r.pos())
    }

    @TestCase
    public func matches_any(): Unit {
        let scan = [r' ', r'\n', r'\t']
        let r = CharacterReader("One\nTwo\tThree")
        @Assert(r.matchesAny(scan), false)
        @Assert("One", r.consumeToAny(scan))
        @Assert(r.matchesAny(scan))
        @Assert(r'\n', r.consume())
        @Assert(r.matchesAny(scan), false)
    }

    @TestCase
    public func matches_ignore_case(): Unit {
        let r = CharacterReader("One Two Three")
        @Assert(r.matchesIgnoreCase("O"))
        @Assert(r.matchesIgnoreCase("o"))
        @Assert(r.matches(r'O'))
        @Assert(r.matches(r'o'), false)
        @Assert(r.matchesIgnoreCase("One Two Three"))
        @Assert(r.matchesIgnoreCase("ONE two THREE"))
        @Assert(r.matchesIgnoreCase("One"))
        @Assert(r.matchesIgnoreCase("one"))
        @Assert(r'O', r.consume())
        @Assert(r.matchesIgnoreCase("One"), false)
        @Assert(r.matchesIgnoreCase("NE Two Three"))
        @Assert(r.matchesIgnoreCase("ne Two Three Four"), false)
        @Assert("ne Two Three", r.consumeToEnd())
        @Assert(r.matchesIgnoreCase("ne"), false)
    }

    @TestCase
    public func matches(): Unit {
        let r = CharacterReader("One Two Three")
        @Assert(r.matches(r'O'))
        @Assert(r.matches("One Two Three"))
        @Assert(r.matches("One"))
        @Assert(r.matches("one"), false)
        @Assert(r'O', r.consume())
        @Assert(r.matches("One"), false)
        @Assert(r.matches("ne Two Three"))
        @Assert(r.matches("ne Two Three Four"), false)
        @Assert("ne Two Three", r.consumeToEnd())
        @Assert(r.matches("ne"), false)
        @Assert(r.isEmpty())
    }

    @TestCase
    public func next_index_of_char(): Unit {
        let inStr = "blah blah"
        let r = CharacterReader(inStr)

        @Assert(-1, r.nextIndexOf(r'x'))
        @Assert(3, r.nextIndexOf(r'h'))
        let pull = r.consumeTo(r'h')
        @Assert("bla", pull)
        r.consume()
        @Assert(2, r.nextIndexOf(r'l'))
        @Assert(" blah", r.consumeToEnd())
        @Assert(-1, r.nextIndexOf(r'x'))
    }

    @TestCase
    public func next_index_of_string(): Unit {
        let inStr = "One Two something Two Three Four"
        let r = CharacterReader(inStr)

        @Assert(-1, r.nextIndexOf("Foo"))
        @Assert(4, r.nextIndexOf("Two"))
        @Assert("One Two ", r.consumeTo("something"))
        @Assert(10, r.nextIndexOf("Two"))
        @Assert("something Two Three Four", r.consumeToEnd())
        @Assert(-1, r.nextIndexOf("Two"))
    }

    @TestCase
    public func next_index_of_unmatched(): Unit {
        let r = CharacterReader("<[[one]]")
        @Assert(-1, r.nextIndexOf("]]>"))
    }

    @TestCase
    public func not_empty_at_buffer_split_point(): Unit {
        let r = CharacterReader("How about now")
        @Assert("How", r.consumeTo(r' '))
        @Assert(r.isEmpty(), false)

        @Assert(r' ', r.consume())
        @Assert(r.isEmpty(), false)
        @Assert(4, r.pos())
        @Assert(r'a', r.consume())
        @Assert(5, r.pos())
        @Assert(r'b', r.consume())
        @Assert(r'o', r.consume())
        @Assert(r'u', r.consume())
        @Assert(r't', r.consume())
        @Assert(r' ', r.consume())
        @Assert(r'n', r.consume())
        @Assert(r'o', r.consume())
        @Assert(r'w', r.consume())
        @Assert(r.isEmpty())
    }

    @TestCase
    public func range_equals(): Unit {
        let r = CharacterReader("Check\tCheck\tCheck\tCHOKE")
        @Assert(r.rangeEquals(0, 5, "Check"))
        @Assert(r.rangeEquals(0, 5, "CHOKE"), false)
        @Assert(r.rangeEquals(0, 5, "Chec"), false)

        @Assert(r.rangeEquals(6, 5, "Check"))
        @Assert(r.rangeEquals(6, 5, "Chuck"), false)

        @Assert(r.rangeEquals(12, 5, "Check"))
        @Assert(r.rangeEquals(12, 5, "Cheeky"), false)

        @Assert(r.rangeEquals(18, 5, "CHOKE"))
        @Assert(r.rangeEquals(18, 5, "CHIKE"), false)
    }

    @TestCase
    public func unconsume(): Unit {
        let r = CharacterReader("one")
        @Assert(r'o', r.consume())
        @Assert(r'n', r.current())
        r.unconsume()
        @Assert(r'o', r.current())

        @Assert(r'o', r.consume())
        @Assert(r'n', r.consume())
        @Assert(r'e', r.consume())
        @Assert(r.isEmpty())
        r.unconsume()
        @Assert(r.isEmpty(),false)
        @Assert(r'e', r.current())
        @Assert(r'e', r.consume())
        @Assert(r.isEmpty())

        @Assert(CharacterReader.EOF, r.consume())
        r.unconsume()
        @Assert(r.isEmpty())
        r.unconsume()
        @Assert(r.isEmpty(),false)

        @Assert(r'e', r.consume())
        @Assert(r.isEmpty())

        @Assert(CharacterReader.EOF, r.consume())
        @Assert(r.isEmpty())
    }

    @TestCase
    public func test1(): Unit {
        // let r = CharacterReader("one")
        // @Assert(r.toString(), "one")
    }

    @TestCase
    public func test2(): Unit {
        let r = CharacterReader("")
        @Assert(r.matchesDigit(), false)
    }

    @TestCase
    public func test3(): Unit {
        let r = CharacterReader("")
        @Assert(r.matchesAny(), false)
    }

    @TestCase
    public func test4(): Unit {
        let r = CharacterReader("asd")
        try {
            r.rewindToMark()
        } catch (e: UncheckedIOException) {
            @Assert(e.message, "Mark invalid")
            return
        }
        throw Exception()
    }

    @TestCase
    public func test5(): Unit {
        let r = CharacterReader("asd")
        try {
            r.unconsume()
        } catch (e: UncheckedIOException) {
            @Assert(e.message, "WTF: No buffer left to unconsume.")
            return
        }
        throw Exception()
    }

    @TestCase
    public func test6(): Unit {
        let r = CharacterReader(StringReader("asdn\n13131313\nline3"))
        r.trackNewlines(true)
        let s1 = r.consumeToAnySorted(r'3')
        println(s1)
        let s2 = r.consumeData()
        println(s2)
        r.close()
    }
}
