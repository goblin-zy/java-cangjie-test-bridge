package runner_probe
import std.unittest.*
import std.unittest.testmacro.*

@Test
class ErrorTests {
    @TestCase
    func unexpectedException(): Unit { throw Exception("intentional runtime error") }
}
