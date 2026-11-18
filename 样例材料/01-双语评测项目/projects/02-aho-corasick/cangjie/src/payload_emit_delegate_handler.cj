/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is PayloadEmitDelegateHandler
 * @since 0.38.2
 */
public class PayloadEmitDelegateHandler <: PayloadEmitHandler<String> {

    private var handler: EmitHandler

    public init(handler: EmitHandler) {
        this.handler = handler
    }

    public func emit(emit: PayloadEmit<String>): Bool {
        let newEmit: Emit = Emit(emit.start, emit.end, emit.keyword)
        return handler.emit(newEmit)
    }

}
