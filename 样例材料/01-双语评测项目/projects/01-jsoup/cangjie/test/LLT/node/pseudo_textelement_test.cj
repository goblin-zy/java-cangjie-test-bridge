// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let pseudoTextElementTest: PseudoTextElementTest = PseudoTextElementTest()

    pseudoTextElementTest.initTest()

    return 0
}

@Test
public class PseudoTextElementTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        PseudoTextElement(Tag.valueOf("from"), "", Attributes())

        println("Pass1")
    }
}