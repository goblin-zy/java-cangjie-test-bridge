// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset

import chardet4cj.*
import fuzz.fuzz.*
import std.io.*

var returnFlag: Int32 = 0
var enterStream: ByteBuffer = ByteBuffer()
var charsetp: EscCharsetProber = EscCharsetProber()

func fuzz_handleData(dp: DataProvider): Int32 {
    var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toUtf8Array()
    var num: Int32 = dp.consumeInt32()
    try {
        charsetp.handleData(bufdata,0,num)
    } catch (e1: Exception) {
        returnFlag = num
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_handleData).startFuzz()

    return 0
}
