package cjmustache
import std.unittest.*
import std.unittest.testmacro.*
import stdx.serialization.serialization.*
import std.collection.*

private func makeModel(fields: Array<Field>): DataModelStruct {
    return DataModelStruct(ArrayList<Field>(fields))
}

@Test
class MustacheTranslationTest {

    @TestCase
    func testSimpleVariable(): Unit {
        /* FRAGMENT_BEGIN:P1 */
        throw Exception("SKELETON_PLACEHOLDER:P1")
        /* FRAGMENT_END:P1 */
    }
    @TestCase
    func testPrimitiveArrayVariable(): Unit {
        /* FRAGMENT_BEGIN:P2 */
        throw Exception("SKELETON_PLACEHOLDER:P2")
        /* FRAGMENT_END:P2 */
    }
    @TestCase
    func testPrimitiveArrayIndexVariable(): Unit {
        /* FRAGMENT_BEGIN:P3 */
        throw Exception("SKELETON_PLACEHOLDER:P3")
        /* FRAGMENT_END:P3 */
    }
    @TestCase
    func testPrimitiveArrayIndexOutOfBoundsVariable(): Unit {
        /* FRAGMENT_BEGIN:P4 */
        throw Exception("SKELETON_PLACEHOLDER:P4")
        /* FRAGMENT_END:P4 */
    }
    @TestCase
    func testOneShotSection(): Unit {
        /* FRAGMENT_BEGIN:P5 */
        throw Exception("SKELETON_PLACEHOLDER:P5")
        /* FRAGMENT_END:P5 */
    }
    @TestCase
    func testListSection(): Unit {
        /* FRAGMENT_BEGIN:P6 */
        throw Exception("SKELETON_PLACEHOLDER:P6")
        /* FRAGMENT_END:P6 */
    }
}
