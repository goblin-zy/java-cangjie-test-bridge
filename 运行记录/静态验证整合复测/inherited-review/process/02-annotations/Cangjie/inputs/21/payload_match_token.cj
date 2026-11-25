/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is PayloadMatchToken
 * @since 0.38.2
 */
public class PayloadMatchToken<T> <: PayloadToken<T> {

    var emit: PayloadEmit<T>

    public init(fragment: String, emit: PayloadEmit<T>) {
        super(fragment)
        this.emit = emit
    }

    public func isMatch(): Bool {
        return true
    }

    public func getEmit(): ?PayloadEmit<T> {
        return this.emit
    }

}
