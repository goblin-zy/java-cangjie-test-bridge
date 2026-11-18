// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj

import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UniversalDetectorTest {
    var detector: UniversalDetector = UniversalDetector()
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var isDone: Bool = false
    var resStr: String = ""

    @TestCase
    func testUniversalDetector_handleData_01(): Unit {
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        try {
            detector.handleData(bufdata)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        isDone = detector.isDone()
        @Assert(isDone, false)
        resStr = detector.getDetectedCharset()
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_handleData_02(): Unit {
        var detector_2: UniversalDetector = UniversalDetector(Option<CharsetListener>.None)
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        try {
            detector_2.handleData(bufdata)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        isDone = detector_2.isDone()
        @Assert(isDone, false)
        detector_2.handleData(bufdata, 0, 10)
        resStr = detector_2.getDetectedCharset() 
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_handleData_03(): Unit {
        returnFlag = -1
        var detector_3: UniversalDetector = UniversalDetector(Option<CharsetListener>.None)
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        isDone = detector_3.isDone()
        @Assert(isDone, false)
        @Assert(bufdata.size, 45)
        try {
            detector_3.handleData(bufdata, 46, 3)
            resStr = detector_3.getDetectedCharset()
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_handleData_04(): Unit {
        returnFlag = -1
        var detector_4: UniversalDetector = UniversalDetector(Option<CharsetListener>.None)
        var bufdata: Array<Byte> = Array<Byte>()
        @Assert(bufdata.size, 0)
        try {
            detector_4.handleData(bufdata, 1, 6)
            resStr = detector_4.getDetectedCharset()
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this buf is empty"), true)
            returnFlag = 0
        }
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }
}
