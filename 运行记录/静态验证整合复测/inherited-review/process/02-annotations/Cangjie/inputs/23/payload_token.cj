/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is PayloadToken
 * @since 0.38.2
 */
public abstract class PayloadToken<T> {

    var fragment: String

    public init(fragment: String) {
        this.fragment = fragment
    }

    public func getFragment(): String {
        return this.fragment
    }

    /**
     * Return {@code true} if a search term matched.
     * @return {@code true} if this is a match
     */
    public func isMatch(): Bool

    /**
     * @return the payload
     */
    public func getEmit(): ?PayloadEmit<T>

}
