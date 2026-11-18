package cangjie_tpc::html4cj

@Test
public class Html4cjExceptionTest {
    @TestCase
    public func UncheckedIOExceptionTest(): Unit {
        // 1
        var uncheckedIOException: UncheckedIOException = UncheckedIOException("error")
        @Assert(uncheckedIOException.message, "error")
        var uncheckedIOException1: UncheckedIOException = UncheckedIOException(IOException("error1"))
        @Assert(uncheckedIOException1.message, "error1")
        UncheckedIOException(IOException("error2"))
        // @Assert(uncheckedIOException2.ioException().message, "error2")

        println("Pass1")
    }

    @TestCase
    public func SerializationExceptionTest(): Unit {
        // 2
        SerializationException()
        var serializationException1: SerializationException = SerializationException("error")
        @Assert(serializationException1.message, "error")
        var serializationException2: SerializationException = SerializationException(Exception("error1"))
        @Assert(serializationException2.message, "error1")
        var serializationException3: SerializationException = SerializationException("error2", Exception("error3"))
        @Assert(serializationException3.message, "error2 : error3")

        println("Pass2")
    }

    @TestCase
    public func SelectorParseExceptionTest(): Unit {
        // 3
        var selectorParseException: SelectorParseException = SelectorParseException("error")
        @Assert(selectorParseException.message, "error")

        println("Pass3")
    }
}
