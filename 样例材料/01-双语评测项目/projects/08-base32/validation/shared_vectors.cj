import hibase32cj.*
import std.unittest.*
import std.unittest.testmacro.*

// BASE32_TEST_CASES from the Java upstream Base32Test.
@Test
class SharedBase32Vectors {
    @TestCase
    func compareJavaInputs(): Unit {
        let vectors = [
            ("", ""), ("f", "MY======"), ("fo", "MZXQ===="),
            ("foo", "MZXW6==="), ("foob", "MZXW6YQ="),
            ("fooba", "MZXW6YTB"), ("foobar", "MZXW6YTBOI======")
        ]
        for ((input, expected) in vectors) {
            @Assert(encode(input), expected)
        }
    }
}
