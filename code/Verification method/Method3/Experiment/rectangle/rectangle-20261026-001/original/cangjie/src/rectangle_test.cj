package starter
import std.unittest.*
import std.unittest.testmacro.*

@Test
class RectangleTest {
    // R01：检查构造后四个坐标是否被正确保存和读取。（改编原有测试）
    @TestCase
    func testConstructor(): Unit {
        let r = Rectangle(1, 2, 3, 4)
        @Expect(r.left, 1)
        @Expect(r.top, 2)
        @Expect(r.right, 3)
        @Expect(r.bottom, 4)
    }
    // R02：检查坐标字符串的内容和格式。（改编原有测试）
    @TestCase
    func testToString(): Unit {
        @Expect(Rectangle(1, 2, 3, 4).toString(), "[1,2,3,4]")
    }
    // R03：检查重合、包含和两个分离方向的真假结果。（改编原有测试）
    @TestCase
    func testIntersection(): Unit {
        let r = Rectangle(0, 0, 1, 1)
        @Expect(r.intersectsWith(Rectangle(0, 0, 1, 1)), true)
        @Expect(r.intersectsWith(Rectangle(-1, -5, 7, 8)), true)
        @Expect(r.intersectsWith(Rectangle(2, 2, 3, 3)), false)
        @Expect(r.intersectsWith(Rectangle(-2, -2, -1, -1)), false)
    }
    // R04：检查共享一条边时仍被判定为相交。（新增测试）
    @TestCase
    func testTouchingEdge(): Unit {
        @Expect(Rectangle(0, 0, 1, 1).intersectsWith(Rectangle(1, 0, 2, 1)), true)
    }
    // R05：检查点矩形位于普通矩形内的边界情况。（新增测试）
    @TestCase
    func testPointRectangle(): Unit {
        @Expect(Rectangle(1, 1, 1, 1).intersectsWith(Rectangle(0, 0, 2, 2)), true)
    }
    // R06：检查左右或上下顺序非法时抛出参数异常。（新增测试）
    @TestCase
    func testInvalidCoordinates(): Unit {
        var first = false
        try { Rectangle(3, 0, 1, 2) } catch (_: IllegalArgumentException) { first = true }
        @Expect(first, true)
        var second = false
        try { Rectangle(0, 3, 1, 2) } catch (_: IllegalArgumentException) { second = true }
        @Expect(second, true)
    }
}
