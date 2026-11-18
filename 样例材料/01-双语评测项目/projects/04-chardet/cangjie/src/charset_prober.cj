/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public abstract class CharsetProber {

    public static let SHORTCUT_THRESHOLD: Float32 = 0.95

    public static let ASCII_A: Int32 = 0x61
    public static let ASCII_Z: Int32 = 0x7A
    public static let ASCII_A_CAPITAL: Int32 = 0x41
    public static let ASCII_Z_CAPITAL: Int32 = 0x5A
    public static let ASCII_LT: Int32 = 0x3C
    public static let ASCII_GT: Int32 = 0x3E
    public static let ASCII_SP: Int32 = 0x20

    private var active: Bool = true

    public init() {
    }

    public func getCharSetName(): String

    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState

    public func getState(): ProbingState

    public func reset(): Unit

    public func getConfidence(): Float32

    public func filterWithoutEnglishLetters(buf: Array<Byte>, offset: Int32, length: Int32): ChardetByteBuffer {
        if (buf.size == 0) {
            throw ChardetException("this buf is empty")
        }
        var out: ChardetByteBuffer = ChardetByteBuffer.allocate(Int64(length))

        var meetMSB: Bool = false
        var c: Byte = 0

        var prevPtr: Int32 = offset
        var curPtr: Int32 = offset
        var maxPtr: Int32 = offset + length
        if (maxPtr <= 0) {
            throw ChardetException("this length is null")
        }
        for (_ in curPtr..maxPtr) {
            c = buf[Int64(curPtr)]
            if (!isAscii(c)) {
                meetMSB = true
            } else if (isAsciiSymbol(c)) {

                if (meetMSB && curPtr > prevPtr) {
                    // this segment contains more than single symbol,
                    // and it has upper ASCII, we need to keep it
                    out.put(buf, Int64(prevPtr), Int64(curPtr-prevPtr))
                    out.put(UInt8(ASCII_SP))
                    prevPtr = curPtr + 1
                    meetMSB = false
                } else {
                    prevPtr = curPtr + 1
                }

            }
            curPtr++
        }

        if (meetMSB && curPtr > prevPtr) {
            out.put(buf, Int64(prevPtr), Int64(curPtr-prevPtr))
        }
        return out
    }

    public func filterWithEnglishLetters(buf: Array<Byte>, offset: Int32, length: Int32): ChardetByteBuffer {
        if (buf.size == 0) {
            throw ChardetException("this buf is empty")
        }
        var out: ChardetByteBuffer = ChardetByteBuffer.allocate(Int64(length))
        var isInTag: Bool = false
        var c: Byte = 0

        var prevPtr: Int32 = offset
        var curPtr: Int32 = offset
        var maxPtr: Int32 = offset + length
        if (maxPtr <= 0) {
            throw ChardetException("this length is null")
        }
        for (_ in curPtr..maxPtr) {
            c = buf[Int64(curPtr)]

            if (Int32(c) == ASCII_GT) {
                isInTag = false
            } else if (Int32(c) == ASCII_LT) {
                isInTag = true
            }

            if (isAscii(c) && isAsciiSymbol(c)) {
                if (curPtr > prevPtr && !isInTag) {
                    // Current segment contains more than just a symbol
                    // and it is not inside a tag, keep it.
                    out.put(buf, Int64(prevPtr), Int64(curPtr-prevPtr))
                    out.put(UInt8(ASCII_SP))
                    prevPtr = curPtr + 1
                } else {
                    prevPtr = curPtr + 1
                }
            }
            curPtr++
        }

        if (!isInTag && curPtr > prevPtr) {
            out.put(buf, Int64(prevPtr), Int64(curPtr-prevPtr))
        }
        return out
    }

    private func isAscii(b: Byte): Bool {
		return ((Int64(b) & 0x80) == 0)
	}

    private func isAsciiSymbol(b: Byte): Bool {
        let c: Int32 = Int32(Int64(b) & 0xFF)
        return ((c < ASCII_A_CAPITAL) ||
                (c > ASCII_Z_CAPITAL && c < ASCII_A) ||
                (c > ASCII_Z))
    }

    public func isActive(): Bool {
		return active
	}

    public func setActive(active: Bool): Unit {
		this.active = active
	}
}
public enum ProbingState <: Equatable<ProbingState> & ToString{
    | DETECTING
    | FOUND_IT
    | NOT_ME

    public func toString(): String {
        match(this) {
            case DETECTING => return "DETECTING"
            case FOUND_IT  => return "FOUND_IT"
            case NOT_ME  => return "NOT_ME"
        }
    }

    public operator func == (that: ProbingState): Bool {
        if (this.toString() == that.toString()) {
            return true
        }
        return false
    }

    public operator func != (that: ProbingState): Bool {
        return !(this == that)
    }
}