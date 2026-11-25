/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is AbstractStatefulEmitHandler
 * @since 0.38.2
 */
public abstract class AbstractStatefulEmitHandler<T> <: StatefulEmitHandler {

    var emits: ArrayList<Emit> = ArrayList<Emit>()

    public func addEmit(emit: Emit): Unit {
        this.emits.add(emit)
    }

    public func getEmits(): ArrayList<Emit> {
        return this.emits
    }
}
