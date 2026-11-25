/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is MatchToken
 * @since 0.38.2
 */
public class MatchToken <: Token {

    var emit: Emit

    public init(fragment: String, emit: Emit) {
        super(fragment)
        this.emit = emit
    }

    public func isMatch(): Bool {
        return true
    }

    public func getEmit(): ?Emit {
        return this.emit
    }

}
