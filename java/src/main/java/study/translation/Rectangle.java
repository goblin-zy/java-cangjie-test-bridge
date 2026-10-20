/* MIT License; Copyright © 2014-2022 Ilkka Seppälä.
 * Modifications (c) 2026 starter-dataset contributors. See LICENSE-TransRepo.txt. */
package study.translation;
/** Axis-aligned closed rectangle. Adapted from TransRepo; see SOURCES.md. */
public final class Rectangle {
    private final int left, top, right, bottom;
    // 创建闭矩形：允许宽或高为零；左大于右、上大于下时抛出参数异常。
    public Rectangle(int left, int top, int right, int bottom) {
        if (left > right || top > bottom)
            throw new IllegalArgumentException("invalid rectangle");
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }
    // 读取左边界横坐标，不修改矩形。
    public int getLeft() { return left; }
    // 读取上边界纵坐标；本例纵坐标向下增大。
    public int getTop() { return top; }
    // 读取右边界横坐标，不修改矩形。
    public int getRight() { return right; }
    // 读取下边界纵坐标，不修改矩形。
    public int getBottom() { return bottom; }
    // 判断与另一个矩形是否相交；先排除四种完全分离情况，共享边或角也算相交。
    public boolean intersectsWith(Rectangle r) {
        return !(r.left > right || r.right < left || r.top > bottom || r.bottom < top);
    }
    // 返回固定格式的坐标字符串，例如[1,2,3,4]，不插入空格。
    @Override public String toString() {
        return String.format("[%d,%d,%d,%d]", left, top, right, bottom);
    }
}
