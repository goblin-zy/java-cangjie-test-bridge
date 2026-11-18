/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is DefaultEmitHandler
 * @since 0.38.2
 */
public class DefaultEmitHandler <: StatefulEmitHandler {

    let emits: ArrayList<Emit> = ArrayList<Emit>()

    public func emit(emit: Emit): Bool {
        this.emits.add(emit)
        return true
    }

    public func getEmits(): ArrayList<Emit> {
        return this.emits
    }
}
