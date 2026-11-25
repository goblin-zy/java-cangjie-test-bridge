/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is PayloadEmit
 * @since 0.38.2
 */
public class PayloadEmit<T> <: Interval & Intervalable {

    let keyword: String

    let payload: ?T

    /**
     * Created a PayloadEmit
     * 
     * @param start   Start of the matched search term.
     * @param end     End of the matched search term.
     * @param keyword Keyword that matched.
     * @param payload Emitted payload data.
     */
    @Frozen
    public init(start: Int32, end: Int32, keyword: String, payload: ?T) {
        super(start,end)
        this.keyword = keyword
        this.payload = payload
        if ((end - start) < 0) {
            throw IllegalArgumentException("The start length must be smaller than the end length")
        }
    }

    public func getKeyword(): String {
        return this.keyword
    }

    /**
     * Returns the payload associated to this emit.
     * 
     * @return the associated payload
     */
    public func getPayload(): ?T {
        return this.payload
    }

    public func toString(): String {
        return super.toString() + "=" + this.keyword + "->"
    }

    public operator func ==(rhs: Intervalable): Bool {
        if (this.toString() == rhs.toString()) {
            return true
        }
        return false
    }

    public operator func !=(rhs: Intervalable): Bool {
        if (this.toString() != rhs.toString()) {
            return true
        }
        return false
    }

    public func hashCode(): Int64 {
        var hash: Int64 = 0
        hash = 31 * hash + keyword.hashCode()
        return hash
    }

}
