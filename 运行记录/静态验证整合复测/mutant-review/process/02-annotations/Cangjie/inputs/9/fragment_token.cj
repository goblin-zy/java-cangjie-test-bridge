/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package ahoCorasick4cj

/*
 * The class is FragmentToken
 * @since 0.38.2
 */
public class FragmentToken <: Token {

    public init(fragment: String) {
        super(fragment)
    }

    public func isMatch(): Bool {
        return false
    }

    public func getEmit(): ?Emit {
        return None
    }

}
