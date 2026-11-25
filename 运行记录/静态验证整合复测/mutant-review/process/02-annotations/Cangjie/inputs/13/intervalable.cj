/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The interface is Intervalable
 * @since 0.38.2
 */
public interface Intervalable <: Hashable & Equatable<Intervalable> {

    func getStart(): Int32
    
    func getEnd(): Int32

    func size(): Int32

    func toString(): String

    func equals(o: Intervalable): Bool
}
