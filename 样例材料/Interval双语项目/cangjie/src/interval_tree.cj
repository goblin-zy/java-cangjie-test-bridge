/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is IntervalTree
 * @since 0.38.2
 */
public class IntervalTree {

    private let rootNode: IntervalNode

    public init(intervals: ArrayList<Intervalable>) {
        this.rootNode = IntervalNode.newInstance(intervals)
    }

    public func removeOverlaps(intervals: ArrayList<Intervalable>): ArrayList<Intervalable> {
        intervals.sortBy(stable: false, comparator: compareSize)
        var removeIntervals: ArrayList<Intervalable> = ArrayList<Intervalable>()
        for (i in 0..intervals.size) {
            // If the interval was already removed, ignore it
            if (removeIntervals.contains(intervals[i])) {
                continue
            }
            // Remove all overallping intervals
            removeIntervals.add(all: findOverlaps(intervals[i]))
        }
        // Remove all intervals that were overlapping
        for (removeInterval in removeIntervals) {
            intervals.removeIf({r: Intervalable => 
                if (r == removeInterval) {
                    return true
                } else {
                    return false
                }
            })
        }
        intervals.sortBy(stable: false, comparator: comparePosition)
        return intervals
    }

    public func findOverlaps(interval: Intervalable): ArrayList<Intervalable> {
        return rootNode.findOverlaps(interval)
    }

    private func compareSize(intervalable: Intervalable, intervalable2: Intervalable): Ordering {
        return intervalable2.size().compare(intervalable.size())
    }

    private func comparePosition(intervalable: Intervalable, intervalable2: Intervalable): Ordering {
        return intervalable.getStart().compare(intervalable2.getStart())
    }
}
