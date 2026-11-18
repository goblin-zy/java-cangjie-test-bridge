/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Holds the information about the part of text involved in the diff process
 */
public class Chunk<T> where T <: Equal<T> & ToString {
    private var position: Int64
    private var lines: ArrayList<T>
    
    /**
     * Creates a chunk and saves a copy of affected lines
     * 
     * @param position the start position
     * @param lines the affected lines
     *
     * @since 0.38.2
     */
    public init(position: Int64, lines: ArrayList<T>) {
        this.position = position
        this.lines = lines
    }
    
    /**
     * Creates a chunk and saves a copy of affected lines
     * 
     * @param position the start position
     * @param lines the affected lines
     *
     * @since 0.38.2
     */
    public init(position: Int64, lines: Array<T>) {
        this.position = position
        this.lines = ArrayList<T>(lines)
    }
    
    /**
     * Returns the Position
     *
     * @return the Position
     *
     * @since 0.38.2
     */
    public func getPosition(): Int64 {
        return position
    }

    /**
     * Set the Lines
     *
     * @param set the Lines
     *
     * @since 0.38.2
     */
    public func setLines(lines: ArrayList<T>): Unit {
        this.lines = lines
    }

    /**
     * Returns the Lines
     *
     * @return the Lines
     *
     * @since 0.38.2
     */
    public func getLines(): ArrayList<T> {
        return lines
    }

    /**
     * Returns the Line size
     *
     * @return the size
     *
     * @since 0.38.2
     */
    public func size(): Int64 {
        return lines.size
    }
    
    /**
     * Returns the last position
     *
     * @return the last position
     *
     * @since 0.38.2
     */
    public func last(): Int64 {
        return getPosition() + size() - 1
    }
    
    /**
     * Returns is the Chunk are same
     *
     * @return the Bool
     *
     * @since 0.38.2
     */
    public func equals(obj: Chunk<T>): Bool {
        if (lines.isEmpty()) {
            if (!obj.lines.isEmpty()) {
                return false
            }
        } else if ( obj.lines.size != lines.size) {
            return false
        } else {
            var i = obj.lines.size - 1
            while( i>=0 ) {
                if (!(lines[i] == obj.lines[i])) {
                    return false
                }
                i--
            }
        }
        if (position != obj.position) {
            return false
        }
        return true
    }
    
    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[position: ${position}" + ", size: ${size()}" + ", lines: ${lines.toString()}" + "]"
    }

    /**
     * Verifies that this chunk's saved text matches the corresponding text in
     * the given sequence.
     * 
     * @param target the sequence to verify against.
     *
     * @since 0.38.2
     */
    public func verify(target: ArrayList<T>): Unit{
        if (last() > target.size) {
            throw PatchFailedException("Incorrect Chunk, the position of chunk > target size");
        }
        var i = 0
        while (i < size()) {
            if (!(target.get(position + i).getOrThrow()==(lines.get(i).getOrThrow()))) {
                throw PatchFailedException(
                        "Incorrect Chunk, the chunk content doesn't match the target");
            }
            i++
        }
    }
}