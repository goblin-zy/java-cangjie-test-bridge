package runner_probe
import std.unittest.*
import std.unittest.testmacro.*

@Test
class SumTests {
    @TestCase
    func twoNumbers(): Unit { @Assert(add(2, 3) == 5i32) }
}
