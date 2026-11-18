/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

public class DifferentiationFailedException <: DiffException {
    public init(msg: String) {
        super(msg);
    }

    public func toString(): String {
        return "DifferentiationFailedException: " + message
    }
}
