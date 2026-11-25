package leven4cj
import std.unittest.*
import std.unittest.testmacro.*


@Test
class LevenshteinTranslationTest {

    @TestCase
    func testGetLevenshteinDistance_StringString(): Unit {
        @Assert(Int64(0), leven("", ""))
        @Assert(Int64(1), leven("", "a"))
        @Assert(Int64(7), leven("aaapppp", ""))
        @Assert(Int64(1), leven("frog", "fog"))
        @Assert(Int64(3), leven("fly", "ant"))
        @Assert(Int64(7), leven("elephant", "hippo"))
        @Assert(Int64(7), leven("hippo", "elephant"))
        @Assert(Int64(8), leven("hippo", "zzzzzzzz"))
        @Assert(Int64(8), leven("zzzzzzzz", "hippo"))
        @Assert(Int64(1), leven("hello", "hallo"))
    }
}
