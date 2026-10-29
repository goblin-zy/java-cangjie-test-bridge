/* MIT License; Copyright © 2014-2022 Ilkka Seppälä.
 * Modifications (c) 2026 starter-dataset contributors. See LICENSE-TransRepo.txt. */
package study.translation;
/** Axis-aligned closed rectangle. Adapted from TransRepo; see SOURCES.md. */
public final class Rectangle {
    private final int left, top, right, bottom;
    // 创建闭矩形：允许宽或高为零；左大于右、上大于下时抛出参数异常。
    public Rectangle(int left, int top, int right, int bottom) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 读取左边界横坐标，不修改矩形。
    public int getLeft() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 读取上边界纵坐标；本例纵坐标向下增大。
    public int getTop() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 读取右边界横坐标，不修改矩形。
    public int getRight() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 读取下边界纵坐标，不修改矩形。
    public int getBottom() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 判断与另一个矩形是否相交；先排除四种完全分离情况，共享边或角也算相交。
    public boolean intersectsWith(Rectangle r) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 返回固定格式的坐标字符串，例如[1,2,3,4]，不插入空格。
    @Override public String toString() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
