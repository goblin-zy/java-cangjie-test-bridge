/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

/**
 * Base class for all exceptions emanating from this package.
 */
public open class DiffException <: Exception {    
    public init(msg: String) {
        super(msg);
    }

    public open func toString(): String {
        return "DiffException: " + message
    }
}
