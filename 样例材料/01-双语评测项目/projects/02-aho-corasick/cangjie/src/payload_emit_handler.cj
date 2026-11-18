/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The interface is PayloadEmitHandler
 * @since 0.38.2
 */
public interface PayloadEmitHandler<T> {
    func emit(emit: PayloadEmit<T>): Bool
}
