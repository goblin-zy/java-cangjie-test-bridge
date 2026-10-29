package study.translation;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class RectangleTest {
    // R01：检查构造后四个坐标是否被正确保存和读取。（改编原有测试）
    @Test void testConstructor() {
        var r = new Rectangle(1, 2, 3, 4);
        assertEquals(1, r.getLeft());
        assertEquals(2, r.getTop());
        assertEquals(3, r.getRight());
        assertEquals(4, r.getBottom());
    }
    // R02：检查坐标字符串的内容和格式。（改编原有测试）
    @Test void testToString() {
        assertEquals("[1,2,3,4]", new Rectangle(1, 2, 3, 4).toString());
    }
    // R03：检查重合、包含和两个分离方向的真假结果。（改编原有测试）
    @Test void testIntersection() {
        var r = new Rectangle(0, 0, 1, 1);
        assertTrue(r.intersectsWith(new Rectangle(0, 0, 1, 1)));
        assertTrue(r.intersectsWith(new Rectangle(-1, -5, 7, 8)));
        assertFalse(r.intersectsWith(new Rectangle(2, 2, 3, 3)));
        assertFalse(r.intersectsWith(new Rectangle(-2, -2, -1, -1)));
    }
    // R04：检查共享一条边时仍被判定为相交。（新增测试）
    @Test void testTouchingEdge() {
        assertTrue(new Rectangle(0, 0, 1, 1).intersectsWith(new Rectangle(1, 0, 2, 1)));
    }
    // R05：检查点矩形位于普通矩形内的边界情况。（新增测试）
    @Test void testPointRectangle() {
        assertTrue(new Rectangle(1, 1, 1, 1).intersectsWith(new Rectangle(0, 0, 2, 2)));
    }
    // R06：检查左右或上下顺序非法时抛出参数异常。（新增测试）
    @Test void testInvalidCoordinates() {
        assertThrows(IllegalArgumentException.class, () -> new Rectangle(3, 0, 1, 2));
        assertThrows(IllegalArgumentException.class, () -> new Rectangle(0, 3, 1, 2));
    }
}
