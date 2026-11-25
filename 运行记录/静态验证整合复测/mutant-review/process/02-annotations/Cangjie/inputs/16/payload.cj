/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is Payload
 * @since 0.38.2
 */
public class Payload<T> <: Hashable & Equatable<Payload<T>> {
    
    let keyword: String
    let data: ?T

    public init(keyword: String, data: ?T) {
        super()
        this.keyword = keyword
        this.data = data
    }

    public func getKeyword(): String {
        return keyword
    }

    public func getData(): ?T {
        return this.data
    }

    public operator func ==(rhs: Payload<T>): Bool {
        return this.keyword == rhs.keyword
    }

    public operator func !=(rhs: Payload<T>): Bool {
        return this.keyword != (rhs.keyword)
    }

    public func hashCode(): Int64 {
        var hash: Int64 = 0
        hash = 31 * hash + keyword.hashCode()
        return hash
    }

    public func compare(other: Payload<T>): Ordering {
        return keyword.compare(other.keyword)
    }
}
