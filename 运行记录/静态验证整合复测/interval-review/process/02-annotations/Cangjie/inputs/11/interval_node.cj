/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is IntervalNode
 * @since 0.38.2
 */
public class IntervalNode {

    var left: ?IntervalNode = None
    var right: ?IntervalNode = None
    var point: Int32 = 0
    var intervals: ArrayList<Intervalable> = ArrayList<Intervalable>()

    private init() {}

    public static func newInstance(intervals: ArrayList<Intervalable>): IntervalNode {
        let node: IntervalNode = IntervalNode()
        node.point = determineMedian(intervals)

        let toLeft: ArrayList<Intervalable> = ArrayList<Intervalable>()
        let toRight: ArrayList<Intervalable> = ArrayList<Intervalable>()
        for (i in 0..intervals.size) {
            if (intervals[i].getEnd() < node.point) {
                toLeft.add(intervals[i])
            } else if (intervals[i].getStart() > node.point) {
                toRight.add(intervals[i])
            } else {
                node.intervals.add(intervals[i])
            }
        }

        if (!toLeft.isEmpty()) {
            node.left = IntervalNode.newInstance(toLeft)
        }

        if (!toRight.isEmpty()) {
            node.right = IntervalNode.newInstance(toRight)
        }

        return node
    }

    public static func determineMedian(intervals: ArrayList<Intervalable>): Int32 {
        var start: Int32 = -1
        var end: Int32 = -1
        for (i in 0..intervals.size) {
            var currentStart: Int32 = intervals[i].getStart()
            var currentEnd: Int32 = intervals[i].getEnd()
            if (start == -1 || currentStart < start) {
                start = currentStart
            }
            if (end == -1 || currentEnd > end) {
                end = currentEnd
            }
        }
        return (start + end) / 2
    }

    public func findOverlaps(interval: Intervalable): ArrayList<Intervalable> {
        var overlaps: ArrayList<Intervalable> = ArrayList<Intervalable>()
        if (this.point < interval.getStart()) {
            // Tends to the right
            addToOverlaps(interval, overlaps, findOverlappingRanges(this.right, interval))
            addToOverlaps(interval, overlaps, checkForOverlapsToTheRight(interval))
        } else if (this.point > interval.getEnd()) {
            // Tends to the left
            addToOverlaps(interval, overlaps, findOverlappingRanges(this.left, interval))
            addToOverlaps(interval, overlaps, checkForOverlapsToTheLeft(interval))
        } else {
            // Somewhere in the middle
            addToOverlaps(interval, overlaps, this.intervals)
            addToOverlaps(interval, overlaps, findOverlappingRanges(this.left, interval))
            addToOverlaps(interval, overlaps, findOverlappingRanges(this.right, interval))
        }
        return overlaps
    }

    protected func addToOverlaps(interval: Intervalable, overlaps: ArrayList<Intervalable>, newOverlaps: ArrayList<Intervalable>): Unit {
        for (i in 0..newOverlaps.size) {
            if (!newOverlaps[i].equals(interval)) {
                overlaps.add(newOverlaps[i])
            }
        }
    }

    protected func checkForOverlapsToTheLeft(interval: Intervalable): ArrayList<Intervalable> {
        return checkForOverlaps(interval, Direction.LEFT)
    }

    protected func checkForOverlapsToTheRight(interval: Intervalable): ArrayList<Intervalable> {
        return checkForOverlaps(interval, Direction.RIGHT)
    }

    private func checkForOverlaps(interval: Intervalable, direction: Direction): ArrayList<Intervalable> {
        var overlaps: ArrayList<Intervalable> = ArrayList<Intervalable>()
        for (i in 0..this.intervals.size) {
            match (direction) {
                case LEFT =>
                    if (this.intervals[i].getStart() <= interval.getEnd()) {
                        overlaps.add(this.intervals[i])
                    }
                    break
                case RIGHT =>
                    if (this.intervals[i].getEnd() >= interval.getStart()) {
                        overlaps.add(this.intervals[i])
                    }
                    break
            }
        }
        return overlaps
    }

    protected func findOverlappingRanges(node: ?IntervalNode, interval: Intervalable): ArrayList<Intervalable> {
        if (let None <- node) {
            return ArrayList<Intervalable>()
        }
        return node.getOrThrow().findOverlaps(interval)
    }

}

enum Direction {
    LEFT |
    RIGHT
}
