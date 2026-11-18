// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let escapeModeTest = EscapeModeTest()

    escapeModeTest.initTest()

    return 0
}

@Test
public class EscapeModeTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var escapeMode1: EscapeMode = EscapeMode.xhtml
        var escapeMode2: EscapeMode = EscapeMode.base
        var escapeMode3: EscapeMode = EscapeMode.extended
        @Assert("xhtml", escapeMode1.toString())
        @Assert("base", escapeMode2.toString())
        @Assert("extended", escapeMode3.toString())
        @Assert(true, escapeMode1 != escapeMode2)
        @Assert(true, escapeMode1 != escapeMode3)
        @Assert(true, escapeMode2 != escapeMode3)
        @Assert(false, escapeMode3 == escapeMode2)
        @Assert(false, escapeMode3 == escapeMode1)
        @Assert(false, escapeMode2 == escapeMode1)

        println("Pass1")
    }
}