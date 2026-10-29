package starter
public class Rectangle <: ToString {
    public let left: Int64
    public let top: Int64
    public let right: Int64
    public let bottom: Int64
    // 创建矩形并保存四个边界；左≤右、上≤下，允许退化为线段或点。
    public init(left: Int64, top: Int64, right: Int64, bottom: Int64) {
        if (left > right || top > bottom) { throw IllegalArgumentException("invalid rectangle") }
        this.left = left; this.top = top; this.right = right; this.bottom = bottom
    }
    // 排除左右上下完全分离的情况；共享边或角时返回true。
    public func intersectsWith(r: Rectangle): Bool {
        return !(r.left > right || r.right < left || r.top > bottom || r.bottom < top)
    }
    // 按[左,上,右,下]输出坐标，格式与Java侧一致。
    public func toString(): String { return "[${top},${left},${right},${bottom}]" }
}
