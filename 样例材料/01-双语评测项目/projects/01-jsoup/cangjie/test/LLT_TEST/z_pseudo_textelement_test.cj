package cangjie_tpc::html4cj

@Test
public class PseudoTextElementTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        PseudoTextElement(Tag.valueOf("from"), "", Attributes())

        println("Pass1")
    }
}
