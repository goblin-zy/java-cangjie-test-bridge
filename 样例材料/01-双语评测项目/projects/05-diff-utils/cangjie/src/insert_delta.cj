/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Describes the insert-delta between original and revised texts.
 */
public class InsertDelta<T> <: Delta<T> where T <: Equal<T> & ToString{
    /**
     * Creates a insert delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T> ) {
        super(original, revised);
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType {
        return  DeltaType.INSERT
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit {
        verify(target)
        var position: Int64 = getOriginal().getPosition()
        var lines: ArrayList<T> = this.getRevised().getLines()
        var i: Int64 = 0
        while (i < lines.size) {
            target.add(lines.get(i).getOrThrow(), at: position + i)
            i++
        }
    }

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit {
        var position: Int64 = getRevised().getPosition()
        var size: Int64 = getRevised().size()
        var i: Int64 = 0
        try {
            while (i < size) {
                target.remove(at: position)
                i++
            }
        } catch(e: IndexOutOfBoundsException) {
            throw DiffException("the position of chunk < 0")
        }
    }

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit {
        if (getOriginal().getPosition() > target.size) {
            throw PatchFailedException("Incorrect patch for delta, " + "delta original position > target size");
        }
    }

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[InsertDelta, position: ${getOriginal().getPosition()}" + ", lines: ${getRevised().getLines()}" + "]"
    }
}
