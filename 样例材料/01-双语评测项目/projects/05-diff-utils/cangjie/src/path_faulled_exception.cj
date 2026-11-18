/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

public class PatchFailedException <: DiffException {    
    public init() {
        super("")
    }
    
    public init(msg: String) {
        super(msg)
    }

    public func toString(): String {
        return "PatchFailedException: " + message
    }
}