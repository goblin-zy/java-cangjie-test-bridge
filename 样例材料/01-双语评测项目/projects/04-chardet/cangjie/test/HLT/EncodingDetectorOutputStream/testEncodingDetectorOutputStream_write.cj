// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class EncodingDetectorOutputStreamTest {
    var enterStream: ByteBuffer = ByteBuffer()
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = -1
    var res: Int64 = 0
    var bufdata_2: Array<Byte> = [116, 101, 115, 116, 69, 110, 99, 111, 100, 105, 110, 103, 68, 49]

    @TestCase
    func testEncodingDetectorOutputStream_write_01(): Unit {
        var bufdata: Array<Byte> = "testEncodingDetectorInputStream_read_01".toArray()
        enterStream.write(bufdata)
        @Assert(bufdata.size, 39)
        var outputStream: EncodingDetectorOutputStream = EncodingDetectorOutputStream(enterStream)
        outputStream.write(12)
        res = enterStream.length 
        @Assert(res, 40)
        outputStream.write(bufdata_2)
        res = enterStream.length
        @Assert(res, 54)

        try {
            outputStream.write(256) // 超出UInt8范围
        } catch (e1: OverflowException) {
            @Assert(e1.toString().contains("OverflowException: The result would be greater than UInt8.Max."), true)
            res = 0
            if (res != 0) {
                returnFlag = 1
            }
        }

        outputStream.close()
        try {
            outputStream.write(12) // 流已经关闭，预期抛异常
        } catch (e2: ChardetException) {
            @Assert(e2.toString().contains("ChardetException: this output stream close"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorOutputStream_write_02(): Unit {
        var bufdata: Array<Byte> = "testEncodingDetectorOutputStream_write_02".toArray()
        @Assert(bufdata.size, 41)
        var out = ByteBuffer()
        var outputStream2: EncodingDetectorOutputStream = EncodingDetectorOutputStream(out)
        outputStream2.flush()
        outputStream2.write(12)
        res = out.length 
        @Assert(res, 1)
        outputStream2.write(bufdata)
        res = out.length 
        @Assert(res, 42)
    }
}
