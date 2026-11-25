# 本轮目标接口依据

来源：样例材料/Interval双语项目/cangjie/src/interval.cj
SHA-256：36b288af3598c7b56a37a92726bf941ae5a31f244df85cdff90e0debd5bcbe7f

本轮接口前提（test_construct）：构造区间(1,3)，依次检查起点1、终点3；仓颉显式Int32匹配业务签名。

本轮接口前提（test_size）：构造区间(0,2)，调用真实size并要求3，保留端点包含的长度语义。

本轮接口前提（test_intervaloverlaps）：区间(1,3)与(2,4)调用区间重载，要求重叠为真。

本轮接口前提（test_intervalDoesNotOverlap）：区间(1,13)与(27,42)调用区间重载，要求重叠为假。

本轮接口前提（test_pointOverlaps）：区间(1,3)对点2调用点重载，要求重叠为真。

本轮接口前提（test_pointDoesNotOverlap）：区间(1,13)对点42调用点重载，要求重叠为假。

本轮接口前提（test_comparable）：按(4,6)、(2,7)、(3,4)顺序放入同一有序集合，推进同一迭代器并依次断言起点2、3、4；IntervalBridge委托真实compareTo并转换Ordering。

本轮接口前提（test_checkToString）：构造区间(4,6)，要求真实toString返回4:6。

本轮接口前提（test_compareToNegativeTest）：构造区间(4,6)，传入不属于Intervalable的普通对象，要求真实compareTo返回-1；UnrelatedValue承担原new Object()的角色。

原业务定义：
```cangjie
/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is Interval
 * @since 0.38.2
 */
public open class Interval <: Intervalable {

    let start: Int32
    let end: Int32

    /**
     * Constructs an interval with a start and end position.
     *
     * @param start The interval's starting text position.
     * @param end   The interval's ending text position.
     */
    public init(start: Int32, end: Int32) {
        this.start = start
        this.end = end
        if ((end - start) < 0) {
            throw IllegalArgumentException("The start length must be smaller than the end length")
        }
    }

    /**
     * Returns the starting offset into the text for this interval.
     *
     * @return A number between 0 (start of text) and the text length.
     */
    public func getStart(): Int32 {
        return this.start
    }

    /**
     * Returns the ending offset into the text for this interval.
     *
     * @return A number between getStart() + 1 and the text length.
     */
    public func getEnd(): Int32 {
        return this.end
    }

    /**
     * Returns the length of the interval.
     *
     * @return The end position less the start position, plus one.
     */
    public func size(): Int32 {
        return end - start + 1
    }

    /**
     * Answers whether the given interval overlaps this interval
     * instance.
     *
     * @param other the other interval to check for overlap
     * @return true The intervals overlap.
     */
    public func overlapsWith(other: Interval): Bool {
        return this.start <= other.end && this.end >= other.start
    }

    public func overlapsWith(point: Int32): Bool {
        return this.start <= point && point <= this.end
    }

    public func equals(other: Intervalable): Bool {
        return this.start == other.getStart() && this.end == other.getEnd()
    }

    public func compareTo(o: Object): Int32 {
        if (!(o is Intervalable)) {
            return -1
        }
        var other: Intervalable = (o as Intervalable).getOrThrow()
        let comparison = this.start - other.getStart()
        if (comparison != 0) {
            return comparison
        } else {
            return this.end - other.getEnd()
        }
    }

    /**
     * Returns the starting offset and ending offset separated
     * by a full colon (:).
     *
     * @return A non-null String, never empty.
     */
    public open func toString(): String {
        return this.start.toString() + ":" + this.end.toString()
    }

    public open operator func ==(rhs: Intervalable): Bool {
        if (this.toString() == rhs.toString()) {
            return true
        }
        return false
    }

    public open operator func !=(rhs: Intervalable): Bool {
        if (this.toString() != rhs.toString()) {
            return true
        }
        return false
    }

    public open func hashCode(): Int64 {
        return Int64(this.start % 100 + this.end % 100)
    }
}

```

上述前提限定于本轮输入与已执行测试，不构成任意输入上的等价证明。
