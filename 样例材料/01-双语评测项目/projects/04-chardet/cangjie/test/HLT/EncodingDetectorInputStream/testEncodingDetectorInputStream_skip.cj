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
    var returnFlag: Int64 = -1
    var res: Int64 = 0

    @TestCase
    func testEncodingDetectorInputStream_skip_01(): Unit {
        returnFlag = 0
        var bufdata: Array<Byte> = "testEncodingDetectorInputStream_read_01".toArray()
        enterStream.write(bufdata)
        var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream)
        var availableTag: Int32 = inputStream.available() // 0代表可用
        @Assert(availableTag, 0)
        try {
            res = inputStream.skip(0) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(res, -1)
        res = inputStream.skip(4) 
        println("res:>> ${res}")
        @Assert(res, 3)
        try {
            res = inputStream.skip(-5) 
        } catch (e2: ChardetException) {
            returnFlag = 2
        }
        @Assert(res, -1)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorInputStream_skip_02(): Unit {
        returnFlag = -1
        var enterStream: ByteBuffer = ByteBuffer()
        var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream) // 缓冲区为空
        var availableTag: Int32 = inputStream.available() // 0代表可用
        @Assert(availableTag, 0)
        try {
            res = inputStream.skip(5) 
        } catch (e2: ChardetException) {
            @Assert(e2.toString().contains("ChardetException: this input is empty"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
