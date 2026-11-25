/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is Token
 * @since 0.38.2
 */
public abstract class Token {

    var fragment: String

    public init(fragment: String) {
        this.fragment = fragment
    }

    public func getFragment(): String {
        return this.fragment
    }

    public func isMatch(): Bool

    public func getEmit(): ?Emit

}
