// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class EncodingDetectorInputStreamTest {
    var enterStream: ByteBuffer = ByteBuffer()
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = 0
    var res: Int64 = 0

    @TestCase
    func testEncodingDetectorInputStream_read_01(): Unit {
        var bufdata: Array<Byte> = "testEncodingDetectorInputStream_read_01".toArray()
        enterStream.write(bufdata)
        var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream)
        var availableTag: Int32 = inputStream.available() // 0代表可用
        @Assert(availableTag, 0)
        res = inputStream.read(bufdata) 
        @Assert(res, 39)
        var bufdata_2: Array<Byte> = [116, 101, 115, 116, 69, 110, 99, 111, 100, 105, 110, 103, 68] // bufdata的子集
        try {
            res = inputStream.read(bufdata_2) 
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this input is empty"), true)
            returnFlag = 0
        }
        inputStream.close()
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorInputStream_read_02(): Unit {
        returnFlag = -1
        var bufdata: Array<Byte> = "testEncodingDetectorInputStream_read_01".toArray()
        enterStream.write(bufdata)
        var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream)
        try {
            res = inputStream.read(Array<Byte>()) 
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this buf is empty"), true)
            returnFlag = 0
        }

        var bufdata_2: Array<Byte> = [116, 101, 115, 116, 69, 110, 99, 111, 100, 105, 110, 103, 68, 49] // bufdata的子集
        res = inputStream.read(bufdata_2) 
        @Assert(res, 14)
        inputStream.close()
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorInputStream_read_03(): Unit {
        returnFlag = -1
        var inputStream_3: EncodingDetectorInputStream = EncodingDetectorInputStream(ByteBuffer()) // 缓冲区为空
        var bufdata_2: Array<Byte> = [116, 101, 115, 116, 69, 110, 99, 111, 100, 105, 110, 103, 68, 49] // bufdata的子集
        try {
            res = inputStream_3.read(bufdata_2)
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this input is empty"), true)
            returnFlag = 0
        }

        @Assert(returnFlag, 0)
    }
}
