package runner_probe
import std.unittest.*
import std.unittest.testmacro.*

@Test
class BrokenTests {
    @TestCase
    func invalidType(): Unit { let value: Int32 = "intentional type error" }
}
