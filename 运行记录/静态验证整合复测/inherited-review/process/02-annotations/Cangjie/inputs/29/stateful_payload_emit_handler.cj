/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The interface is StatefulPayloadEmitHandler
 * @since 0.38.2
 */
public interface StatefulPayloadEmitHandler<T> <: PayloadEmitHandler<T> {
    func getEmits(): ArrayList<PayloadEmit<T>>
}
