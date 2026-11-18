/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

public class MyersDiff<T> <: DiffAlgorithm<T> where T <: Equal<T> & ToString{
    
    /** Default equalizer. */
    private let  DEFAULT_EQUALIZER: Equalizer<T> =  DefaultEqualizer<T>()
    private let  equalizer: Equalizer<T>

    /**
     * Constructs an instance of the Myers differencing algorithm.
     *
     * @since 0.38.2
     */
    public init() {
        this.equalizer = DEFAULT_EQUALIZER
    }

    /**
     * Constructs an instance of the Myers differencing algorithm.
     *
     * @Param set the Equalizer<T>
     *
     * @since 0.38.2
     */
    public init(equalizer: Equalizer<T>) {
        this.equalizer = equalizer
    }

    /**
     * Computes the difference between the original and revised list of elements
     * with default diff algorithm
     * 
     * @param original The original text. 
     * @param revised The revised text.
     * @return The patch describing the difference between the original and revised sequences.
     * @param algorithm The diff algorithm
     *   
     * @since 0.38.2
     */
    public func diff(original: Array<T>, revised: Array<T>): Patch<T> {
        var list1 = ArrayList<T>(original)
        var list2 = ArrayList<T>(revised)
        return diff(list1, list2)
    }

    /**
     * Computes the difference between the original and revised list of elements
     * with default diff algorithm
     * 
     * @param original The original text. 
     * @param revised The revised text.
     * @return The patch describing the difference between the original and revised sequences.
     * @param algorithm The diff algorithm. 
     *   
     * @since 0.38.2
     */
    public func diff(original: ArrayList<T>, revised: ArrayList<T>): Patch<T> {
        var path: PathNode
        try {
            path = buildPath(original, revised)
            return buildRevision(path, original, revised)
        } catch (e: DifferentiationFailedException) {
            throw DiffException("Differentiation filed")
        }
    }

    /**
     * buildPath
     *
     * @param orig original text.
     * @param rev revised text.
     * @return PathNode
     *   
     * @since 0.38.2
     */
    public func buildPath(orig:  ArrayList<T>, rev:  ArrayList<T>): PathNode{
        let N: Int64 = orig.size
        let M: Int64 = rev.size

        let MAX: Int64 = N + M + 1
        let size = 1 + 2 * MAX
        let middle = size / 2
        let diagonal: Array<PathNode> = Array<PathNode>(size,repeat: Snake(0, 0, Option<PathNode>.None))

        diagonal[middle + 1] =  Snake(0, -1, Option<PathNode>.None)
        var d: Int64 = 0
        while ( d < MAX ) {
            var  k = -d
            while ( k <= d) {
                let kmiddle: Int64 = middle + k
                let kplus: Int64 = kmiddle + 1
                let kminus: Int64 = kmiddle - 1
                var prev: Option<PathNode> = Option<PathNode>.None

                var ii: Int64
                if ( (k == -d) || (k != d && diagonal[kminus].i < diagonal[kplus].i) ) {
                    ii = diagonal[kplus].i
                    prev = diagonal[kplus]
                } else {
                    ii = diagonal[kminus].i + 1
                    prev = diagonal[kminus]
                }

                diagonal[kminus] = Snake(0, 0, Option<PathNode>.None) // no longer used

                var j = ii - k

                var node: PathNode = DiffNode(ii, j, prev)

                while (ii < N && j < M && equals(orig.get(ii).getOrThrow(), rev.get(j).getOrThrow())) {
                    ii++
                    j++
                }
                if (ii > node.i) {
                    node =  Snake(ii, j, node)
                }

                diagonal[kmiddle] = node

                if (ii >= N && j >= M) {
                    return diagonal[kmiddle]
                }

                k += 2
            }
            diagonal[middle + d - 1] = Snake(0, 0, Option<PathNode>.None)
            d++

        }
        throw  DifferentiationFailedException("could not find a diff path")
    }

    private func equals(orig: T, rev: T): Bool {
        return equalizer.equals(orig, rev)
    }

    /**
     * buildRevision
     *
     * @param path
     * @param orig original arraylist
     * @param rev revised arraylist
     * @return A path
     *
     * @since 0.38.2
     */
    public func buildRevision(path: PathNode, orig: ArrayList<T>, rev: ArrayList<T>): Patch<T> {
        var temppath: Option<PathNode> = Option<PathNode>.Some(path)
        var patch: Patch<T> = Patch<T>()
        if (path.isSnake()) {
            temppath = path.prev
        }
        while (!checkNull(temppath) && !checkNull(temppath.getOrThrow().prev) && temppath.getOrThrow().prev.getOrThrow().j >= 0) {
            if (temppath.getOrThrow().isSnake()) {
                throw DifferentiationFailedException("bad diffpath, found snake when looking for diff")
            }
            var i = temppath.getOrThrow().i
            var j = temppath.getOrThrow().j

            temppath = temppath.getOrThrow().prev
            var ianchor = temppath.getOrThrow().i
            var janchor = temppath.getOrThrow().j

            var original: Chunk<T> = Chunk<T>(ianchor, copyOfRange(orig, ianchor, i))
            var revised: Chunk<T> = Chunk<T>(janchor, copyOfRange(rev, janchor, j))
            var delta: Delta<T>
            if (original.size() == 0 && revised.size() != 0) {
                delta =  InsertDelta<T>(original, revised)
            } else if (original.size() > 0 && revised.size() == 0) {
                delta = DeleteDelta<T>(original, revised)
            } else {
                delta = ChangeDelta<T>(original, revised)
            }
            patch.addDelta(delta)
            if (temppath.getOrThrow().isSnake()) {
                temppath = temppath.getOrThrow().prev
            }
        }
        return patch
    }

    private func copyOfRange(original: ArrayList<T>, fromIndex: Int64, to: Int64 ): ArrayList<T> {
        if (fromIndex > original.size || to > original.size)  {
            throw IndexOutOfBoundsException("copy list out of range")
        }
        if (fromIndex == to) {
            return ArrayList<T>()
        }
        let r: Range<Int64> = fromIndex..to
        return ArrayList<T>( original.slice(r) )
    }
}

class DefaultEqualizer<T> <: Equalizer<T> where T <: Equal<T>{
    public func equals(original: T, revised: T): Bool {
        return original == revised
    }
}