/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is DefaultToken
 * @since 0.38.2
 */
public class DefaultToken <: Token {

    private var payloadToken: PayloadToken<String>

    public init(payloadToken: PayloadToken<String>) {
        super(payloadToken.fragment)
        this.payloadToken = payloadToken
    }

    public func isMatch(): Bool {
        return payloadToken.isMatch()
    }

    public func getEmit(): ?Emit {
        let emit: ?PayloadEmit<String> = payloadToken.getEmit()
        return Emit(emit.getOrThrow().start, emit.getOrThrow().end, emit.getOrThrow().keyword)
    }

}
