/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The interface is StatefulPayloadEmitDelegateHandler
 * @since 0.38.2
 */
public class StatefulPayloadEmitDelegateHandler <: StatefulPayloadEmitHandler<String> {

    private var handler: StatefulEmitHandler

    public init(handler: StatefulEmitHandler) {
        this.handler = handler
    }

    private static func asEmits(emits: ArrayList<Emit>): ArrayList<PayloadEmit<String>> {
        var result: ArrayList<PayloadEmit<String>> = ArrayList<PayloadEmit<String>>()
        for (emit in emits) {
            result.add(PayloadEmit<String>(emit.start, emit.end, emit.keyword, None))
        }
        return result
    }

    public func emit(emit: PayloadEmit<String>): Bool {
        let newEmit: Emit = Emit(emit.start, emit.end, emit.keyword)
        return handler.emit(newEmit)
    }

    public func getEmits(): ArrayList<PayloadEmit<String>> {
        let emits: ArrayList<Emit> = this.handler.getEmits()
        return asEmits(emits)
    }

}
