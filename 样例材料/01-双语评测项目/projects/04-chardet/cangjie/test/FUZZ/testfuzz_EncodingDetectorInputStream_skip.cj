// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset
import chardet4cj.*
import fuzz.fuzz.*
import std.io.*

var returnFlag: Int32 = 0
var enterStream: ByteBuffer = ByteBuffer()

@OverflowWrapping
func fuzz_skip(dp: DataProvider): Int32 {
    var bufdata: Array<Byte> = "testEncodingDetectorInputStream_read_01".toUtf8Array()
    enterStream.write(bufdata)
    var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream)
    // public func skip(n: Int64): Int64
    var num: Int64 = dp.consumeInt64()
    try {
        inputStream.skip(num)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_skip).startFuzz()

    return 0
}
