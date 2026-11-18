// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UniversalDetectorTest {
    var detector: UniversalDetector = UniversalDetector()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""

    @TestCase
    func testUniversalDetector_detectCharsetFromBOM_01(): Unit {
        var bufdata: Array<Byte> = "testUniversalDetector_detectCharsetFromBOM_01".toArray()
        try {
            resStr = UniversalDetector.detectCharsetFromBOM(bufdata)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        detector.dataEnd()
        @Assert(resStr, "")
        resStr = detector.getDetectedCharset() 
        @Assert(resStr, "")
        detector.reset() // 重置检测器
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetFromBOM_02(): Unit {
        var bufdata: Array<Byte> = "testUniversalDetector_detectCharsetFromBOM_01".toArray()
        try {
            resStr = UniversalDetector.detectCharsetFromBOM(bufdata)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        detector.dataEnd()
        @Assert(resStr, "")
        detector.reset() // 重置检测器
        resStr = detector.getDetectedCharset() 
        @Assert(resStr, "")
        try {
            resStr = UniversalDetector.detectCharsetFromBOM(Array<Byte>()) // 源数据buf为空时，业务返回为空，无异常抛出
        } catch (e2: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }
}
