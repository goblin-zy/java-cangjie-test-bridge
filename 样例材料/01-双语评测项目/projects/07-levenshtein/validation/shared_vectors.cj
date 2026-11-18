import leven4cj.*
import std.unittest.*
import std.unittest.testmacro.*

// Inputs and expectations from Java LevenshteinDistanceTest.testGetLevenshteinDistance_StringString.
@Test
class SharedLevenshteinVectors {
    @TestCase
    func compareJavaInputs(): Unit {
        let vectors: Array<(String, String, Int64)> = [
            ("", "", 0), ("", "a", 1), ("aaapppp", "", 7),
            ("frog", "fog", 1), ("fly", "ant", 3), ("elephant", "hippo", 7),
            ("hippo", "elephant", 7), ("hippo", "zzzzzzzz", 8),
            ("zzzzzzzz", "hippo", 8), ("hello", "hallo", 1)
        ]
        for ((left, right, expected) in vectors) {
            @Assert(leven(left, right), expected)
        }
    }
}
