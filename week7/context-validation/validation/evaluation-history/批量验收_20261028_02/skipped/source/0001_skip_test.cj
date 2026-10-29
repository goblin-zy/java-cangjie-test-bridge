package runner_probe
import std.unittest.*
import std.unittest.testmacro.*

@Test
class SkipTests {
    @TestCase
    @Skip[true]
    func intentionallySkipped(): Unit { @Assert(false) }
}
