package runner_probe
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TimeoutTests {
    @TestCase
    func neverReturns(): Unit { while (true) {} }
}
