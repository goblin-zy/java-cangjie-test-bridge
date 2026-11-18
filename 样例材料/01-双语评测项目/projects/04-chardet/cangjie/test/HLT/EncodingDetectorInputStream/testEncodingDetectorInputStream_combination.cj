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
    var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(ByteBuffer())
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = 0
    var res: Int64 = 0

    @TestCase
    func testEncodingDetectorInputStream_01(): Unit {
        var availableTag: Int32 = inputStream.available() 
        @Assert(availableTag, 0)
        inputStream.close()
        availableTag = inputStream.available() 
        @Assert(availableTag, 0)
        try {
            res = inputStream.read()
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("Exception: this input stream close"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorInputStream_02(): Unit {
        var availableTag: Int32 = inputStream.available() // 0代表可用
        @Assert(availableTag, 0)
        try {
            inputStream.reset()
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("mark/reset not supported"), true)
        }
        availableTag = inputStream.available() 
        @Assert(availableTag, 0)
        var charset: String = inputStream.getDetectedCharset() 
        @Assert(charset, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEncodingDetectorInputStream_03(): Unit {
        var availableTag: Int32 = inputStream.available() // 0代表可用
        @Assert(availableTag, 0)
        try {
            inputStream.mark(12) // readlimit非0抛异常
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("mark is not null"), true)
        }
        var markTag: Bool = inputStream.markSupported()
        @Assert(markTag, false)
        inputStream.mark(0)
        var charset: String = inputStream.getDetectedCharset() 
        @Assert(charset, "")
        @Assert(returnFlag, 0)
    }
}
