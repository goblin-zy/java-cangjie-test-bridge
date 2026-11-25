package probe
import std.unittest.*
import std.unittest.testmacro.*
@Test
class ChildCase {
@TestCase
func testFromBase(): Unit {
throw Exception("INTERFACE_SCOPE_ONLY")
}
@TestCase
func testOwn(): Unit {
throw Exception("INTERFACE_SCOPE_ONLY")
}
}
