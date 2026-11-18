/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

public abstract class Delta<T> where T <: Equal<T> & ToString {
    /** The original chunk. */
    private var original: Chunk<T>
    /** The revised chunk. */
    private var revised: Chunk<T>

    /**
     * Creates a delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T>) {
        this.original = original;
        this.revised = revised;
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType

    /**
     * Returns the getOriginal
     *
     * @return the getOriginal
     *
     * @since 0.38.2
     */
    public func getOriginal(): Chunk<T> {
        return original;
    }
    
    /**
     * Set the getOriginal
     *
     * @Param set the Original
     *
     * @since 0.38.2
     */
    public func setOriginal(original: Chunk<T>): Unit {
        this.original = original;
    }

    /**
     * Returns the Revised
     *
     * @return the Revised
     *
     * @since 0.38.2
     */
    public func getRevised(): Chunk<T> {
        return revised
    }
    
    /**
     * Set the getRevised
     *
     * @Param set the Revised
     *
     * @since 0.38.2
     */
    public func setRevised(revised: Chunk<T>) {
        this.revised = revised
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit

    /**
     * Returns is the Delta are same
     *
     * @return the Bool
     *
     * @since 0.39.3
     */
    public func equals(obj: Delta<T>): Bool {
        if(refEq(this, obj)) {
            return true
        }
        var other: Delta<T> = obj
        if (!original.equals(other.original)) {
            return false
        }
        if (!revised.equals(other.revised)) {
            return false
        }
        return true
    }
}

public enum DeltaType {
    /** A change in the original. */
    | CHANGE
    /** A delete from the original. */
    | DELETE
    /** An insert into the original. */
    | INSERT
}