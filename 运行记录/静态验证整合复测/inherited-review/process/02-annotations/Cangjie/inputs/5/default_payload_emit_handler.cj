/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is DefaultPayloadEmitHandler
 * @since 0.38.2
 */
public class DefaultPayloadEmitHandler<T> <: StatefulPayloadEmitHandler<T> {

    let emits: ArrayList<PayloadEmit<T>> = ArrayList<PayloadEmit<T>>()

    @Frozen
    public init() {}

    @Frozen
    public func emit(emit: PayloadEmit<T>): Bool {
        this.emits.add(emit)
        return true
    }

    public func getEmits(): ArrayList<PayloadEmit<T>> {
        return this.emits
    }
}
