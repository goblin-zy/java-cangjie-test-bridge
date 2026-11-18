package hibase32cj

import std.collection.*
import std.unicode.*

var BASE32_ENCODE_CHAR = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'.split('')
var BASE32_DECODE_CHAR = HashMap<String, Int64>(
    [("A", 0), ("B", 1), ("C", 2), ("D", 3), ("E", 4), ("F", 5), ("G", 6), ("H", 7), ("I", 8), ("J", 9), ("K", 10),
    ("L", 11), ("M", 12), ("N", 13), ("O", 14), ("P", 15), ("Q", 16), ("R", 17), ("S", 18), ("T", 19), ("U", 20),
    ("V", 21), ("W", 22), ("X", 23), ("Y", 24), ("Z", 25), ("2", 26), ("3", 27), ("4", 28), ("5", 29), ("6", 30),
    ("7", 31)])

public func encode(input: Array<UInt8>): String {
    return encodeBytes(input)
}

public func encode(input: String): String {
    return encodeBytes(input.toArray())
}

public func decodeAsString(base32Str: String): String {
    return String.fromUtf8(decodeAsBytes(base32Str))
}

public func decodeAsBytes(base32Str: String): Array<UInt8> {
    var bytes = ArrayList<UInt8>(100)

    if (base32Str.isEmpty()) {
        return bytes.toArray()
    } else if (!testVaildBase32(base32Str)) {
        throw Exception("Invalid base32 characters")
    }

    let base32Runes = base32Str.trimEnd("=").toRuneArray()

    var v1: Int64
    var v2: Int64
    var v3: Int64
    var v4: Int64
    var v5: Int64
    var v6: Int64
    var v7: Int64
    var v8: Int64
    var length = base32Runes.size
    var count = length >> 3 << 3
    var i = 0

    while (i < count) {
        v1 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v2 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v3 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v4 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v5 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v6 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v7 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v8 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        bytes.add(UInt8((v1 << 3 | unsignedRightShift(v2, 2)) & 255))
        bytes.add(UInt8((v2 << 6 | v3 << 1 | unsignedRightShift(v4, 4)) & 255))
        bytes.add(UInt8((v4 << 4 | unsignedRightShift(v5, 1)) & 255))
        bytes.add(UInt8((v5 << 7 | v6 << 2 | unsignedRightShift(v7, 3)) & 255))
        bytes.add(UInt8((v7 << 5 | v8) & 255))
    }

    var remain = length - count
    if (remain == 2) {
        v1 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v2 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        bytes.add(UInt8((v1 << 3 | unsignedRightShift(v2, 2)) & 255))
    } else if (remain == 4) {
        v1 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v2 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v3 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v4 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        bytes.add(UInt8((v1 << 3 | unsignedRightShift(v2, 2)) & 255))
        bytes.add(UInt8((v2 << 6 | v3 << 1 | unsignedRightShift(v4, 4)) & 255))
    } else if (remain == 5) {
        v1 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v2 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v3 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v4 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v5 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        bytes.add(UInt8((v1 << 3 | unsignedRightShift(v2, 2)) & 255))
        bytes.add(UInt8((v2 << 6 | v3 << 1 | unsignedRightShift(v4, 4)) & 255))
        bytes.add(UInt8((v4 << 4 | unsignedRightShift(v5, 1)) & 255))
    } else if (remain == 7) {
        v1 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v2 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v3 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v4 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v5 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v6 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        v7 = BASE32_DECODE_CHAR[base32Runes[i].toString()]
        i = i + 1
        bytes.add(UInt8((v1 << 3 | unsignedRightShift(v2, 2)) & 255))
        bytes.add(UInt8((v2 << 6 | v3 << 1 | unsignedRightShift(v4, 4)) & 255))
        bytes.add(UInt8((v4 << 4 | unsignedRightShift(v5, 1)) & 255))
        bytes.add(UInt8((v5 << 7 | v6 << 2 | unsignedRightShift(v7, 3)) & 255))
    }
    return bytes.toArray()
}

private func encodeBytes(bytes: Array<UInt8>): String {
    var v1: Int64
    var v2: Int64
    var v3: Int64
    var v4: Int64
    var v5: Int64
    var base32Sb = StringBuilder()
    var length = bytes.size
    var i = 0
    var count = (length / 5) * 5

    while (i < count) {
        v1 = Int64(bytes[i])
        i = i + 1
        v2 = Int64(bytes[i])
        i = i + 1
        v3 = Int64(bytes[i])
        i = i + 1
        v4 = Int64(bytes[i])
        i = i + 1
        v5 = Int64(bytes[i])
        i = i + 1
        base32Sb.append(BASE32_ENCODE_CHAR[unsignedRightShift(v1, 3)])
        base32Sb.append(BASE32_ENCODE_CHAR[(v1 << 2 | unsignedRightShift(v2, 6)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v2, 1)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v2 << 4 | unsignedRightShift(v3, 4)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v3 << 1 | unsignedRightShift(v4, 7)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v4, 2)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v4 << 3 | unsignedRightShift(v5, 5)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[v5 & 31])
    }

    var remain = length - count
    if (remain == 1) {
        v1 = Int64(bytes[i])
        base32Sb.append(BASE32_ENCODE_CHAR[unsignedRightShift(v1, 3)])
        base32Sb.append(BASE32_ENCODE_CHAR[(v1 << 2) & 31])
        base32Sb.append('======')
    } else if (remain == 2) {
        v1 = Int64(bytes[i])
        i = i + 1
        v2 = Int64(bytes[i])
        base32Sb.append(BASE32_ENCODE_CHAR[unsignedRightShift(v1, 3)])
        base32Sb.append(BASE32_ENCODE_CHAR[(v1 << 2 | unsignedRightShift(v2, 6)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v2, 1)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v2 << 4) & 31])
        base32Sb.append('====')
    } else if (remain == 3) {
        v1 = Int64(bytes[i])
        i = i + 1
        v2 = Int64(bytes[i])
        i = i + 1
        v3 = Int64(bytes[i])
        base32Sb.append(BASE32_ENCODE_CHAR[unsignedRightShift(v1, 3)])
        base32Sb.append(BASE32_ENCODE_CHAR[(v1 << 2 | unsignedRightShift(v2, 6)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v2, 1)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v2 << 4 | unsignedRightShift(v3, 4)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v3 << 1) & 31])
        base32Sb.append('===')
    } else if (remain == 4) {
        v1 = Int64(bytes[i])
        i = i + 1
        v2 = Int64(bytes[i])
        i = i + 1
        v3 = Int64(bytes[i])
        i = i + 1
        v4 = Int64(bytes[i])
        base32Sb.append(BASE32_ENCODE_CHAR[unsignedRightShift(v1, 3)])
        base32Sb.append(BASE32_ENCODE_CHAR[(v1 << 2 | unsignedRightShift(v2, 6)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v2, 1)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v2 << 4 | unsignedRightShift(v3, 4)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v3 << 1 | unsignedRightShift(v4, 7)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(unsignedRightShift(v4, 2)) & 31])
        base32Sb.append(BASE32_ENCODE_CHAR[(v4 << 3) & 31])
        base32Sb.append('=')
    }
    return base32Sb.toString()
}

public func unsignedRightShift(value: Int64, shift: Int64): Int64 {
    let tmpshift = shift % 32

    if (tmpshift == 0) {
        return value
    } else {
        var shifted: Int64 = value >> tmpshift
        var mask: Int64 = (1 << (32 - tmpshift)) - 1
        return shifted & mask
    }
}

public func testVaildBase32(str: String): Bool {
    let runeArray = str.toRuneArray()
    let validRunes = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=".toRuneArray()

    for (rune in runeArray) {
        if (!validRunes.contains(rune)) {
            return false
        }
    }
    return true
}