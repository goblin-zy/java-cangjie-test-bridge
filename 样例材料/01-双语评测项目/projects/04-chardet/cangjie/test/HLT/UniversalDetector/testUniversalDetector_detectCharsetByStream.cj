// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//data_file:../util_test/utf8.txt
//data_file:../util_test/utf-16be.txt
//data_file:../util_test/utf-16le.txt
//data_file:../util_test/utf-16le.cj

import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UniversalDetectorTest {
    var detector: UniversalDetector = UniversalDetector()
    var enterStream: ByteBuffer = ByteBuffer()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""
    var file_1: File = File("../util_test/utf8.txt", OpenMode.Read)
    var file_2: File = File("../util_test/utf-16be.txt", OpenMode.Read)
    var file_3: File = File("../util_test/utf-16le.txt", OpenMode.Read)

    @TestCase
    func testUniversalDetector_detectCharsetByStream_01(): Unit {
        var bufdata: Array<Byte> = "testUniversalDetector_detectCharsetByStream_01".toArray()
        enterStream.write(bufdata)
        let unicodeBOMInputStreamIns_1: UnicodeBOMInputStream = UnicodeBOMInputStream(enterStream)
        try {
            resStr = UniversalDetector.detectCharset(unicodeBOMInputStreamIns_1) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "US-ASCII")
        resStr = detector.getDetectedCharset() 
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByStream_02(): Unit {
        returnFlag = -1
        let ByteBufferIns_1: ByteBuffer = ByteBuffer() // 缓冲区为空
        try {
            resStr = UniversalDetector.detectCharset(ByteBufferIns_1)
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this inputStream is empty"), true)
            returnFlag = 0
        }

        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByStream_03(): Unit {
        returnFlag = -1
        var enterStream_1: ByteBuffer = ByteBuffer()
        var inputStream: EncodingDetectorInputStream = EncodingDetectorInputStream(enterStream_1)
        try {
            resStr = UniversalDetector.detectCharset(inputStream)
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this inputStream is empty"), true)
            returnFlag = 0
        }
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }
}
