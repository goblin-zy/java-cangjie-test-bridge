/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package diffUtils4cj

public interface Equalizer<T> {
    func equals(original: T, revised: T): Bool
}
