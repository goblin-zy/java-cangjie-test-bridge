/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj;

import std.collection.*

/**
 * The general interface for computing diffs between two lists of elements of type T. 
 */
public interface DiffAlgorithm<T> where T <: Equal<T> & ToString{
    /**
     * Computes the difference between the original sequence and the revised
     * 
     * @param original The original sequence. Must not be {@code null}.
     * @param revised The revised sequence. Must not be {@code null}.
     * @return The patch representing the diff of the given sequences. Never {@code null}.
     * 
     * @since 0.38.2
     */
    func diff(original: Array<T>, revised: Array<T>): Patch<T>
    
    /**
     * Computes the difference between the original sequence and the revised
     * 
     * @param original The original sequence. Must not be {@code null}.
     * @param revised The revised sequence. Must not be {@code null}.
     * @return The patch representing the diff of the given sequences. Never {@code null}.
     * 
     * @since 0.38.2
     */
    func diff(original : ArrayList<T>, revised: ArrayList<T>): Patch<T>
}
