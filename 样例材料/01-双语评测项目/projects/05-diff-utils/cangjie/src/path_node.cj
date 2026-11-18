/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*


public abstract class PathNode {
    /** Position in the original sequence. */
    public let i: Int64
    /** Position in the revised sequence. */
    public let j: Int64
    /** The previous node in the path. */
    public let prev: Option<PathNode>
    
    /**
     * Concatenates a new path node with an existing diffpath.
     *
     * @param i The position in the original sequence for the new node.
     * @param j The position in the revised sequence for the new node.
     * @param prev The previous node in the path.
     * 
     * @since 0.38.2
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>) {
        this.i = i
        this.j = j
        this.prev = prev
    }
    
    /**
     * 
     * @return Bool
     * 
     * @since 0.38.2
     */
    public func isSnake(): Bool
    
    /**
     * Returns is it Bootstrap value
     *
     * @return Bool
     *
     * @since 0.38.2
     */
    public func isBootstrap(): Bool {
        return i < 0 || j < 0
    }
    
    /**
     * Returns the previous Snake node
     *
     * @return the PathNode
     *
     * @since 0.38.2
     */
    public func previousSnake(): Option<PathNode> {
        if (isBootstrap()) {
            return Option<PathNode>.None
        }
        if (!isSnake()) {
            match(prev) {
                case Some(v) => return v.previousSnake()
                case None => return this
            }
        }
        return this
    }
    
    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        var buf: StringBuilder =  StringBuilder("[")
        var node: Option<PathNode> = this
        while (!checkNull(node)) {
            buf.append("(")
            buf.append(node.getOrThrow().i)
            buf.append(",")
            buf.append(node.getOrThrow().j)
            buf.append(")")
            node = node.getOrThrow().prev
        }
        buf.append("]");
        return buf.toString()
    }
}

func checkNull(v: Option<PathNode>): Bool {
    match(v) {
        case None => return true
        case _ => return false
    }
}