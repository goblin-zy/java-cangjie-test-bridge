// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset

import chardet4cj.*
import fuzz.fuzz.*
import std.io.*

var returnFlag: Int32 = 0
let inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(ByteBuffer())

func fuzz_mark(dp: DataProvider): Int32 {
    // public func mark(readlimit: Int32): Unit
    var num: Int32 = dp.consumeInt32()
    try {
        inputStream.mark(num) // readlimit非0抛异常
    } catch (e1: Exception) {
        returnFlag = num
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_mark).startFuzz()

    return 0
}
