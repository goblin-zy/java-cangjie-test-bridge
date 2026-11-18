// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//data_file:../util_test/utf8.txt
//data_file:../util_test/utf-16be.txt
//data_file:../util_test/utf-16le.txt
//data_file:../util_test/utf-16le.cj
//data_file:../util_test/iso_2022_cn.txt


import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UniversalDetectorTest {
    var detector: UniversalDetector = UniversalDetector()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""
    var file_1: File = File("../util_test/utf8.txt", OpenMode.Read)
    var file_2: File = File("../util_test/utf-16be.txt", OpenMode.Read)
    var file_3: File = File("../util_test/utf-16le.txt", OpenMode.Read)

    @TestCase
    func testUniversalDetector_detectCharsetByFile_01(): Unit {
        try {
            resStr = UniversalDetector.detectCharset(file_1) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-8")
        resStr = detector.getDetectedCharset() 
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByFile_02(): Unit {
        returnFlag = -1
        try {
            var file2_1: File = File("../util_test/utf-16be.py", OpenMode.Read)
            resStr = UniversalDetector.detectCharset(file2_1) // UTF-16BE
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not exist or permission denied"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/UniversalDetector/../util_test/utf-16be.py` does not exist or permission denied!
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByFile_03(): Unit {
        returnFlag = -1
        try {
            resStr = UniversalDetector.detectCharset(file_2) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-16BE")

        try {
            var file3_1: File = File("../util_test/仓颉utf-16be.txt", OpenMode.Read) //文件不存在
            resStr = UniversalDetector.detectCharset(file3_1)
        } catch (e2: FSException) {
            @Assert(e2.toString().contains("does not exist or permission denied"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/UniversalDetector/../util_test/仓颉utf-16be.txt` does not exist or permission denied!
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByFile_04(): Unit {
        returnFlag = -1
        resStr = UniversalDetector.detectCharset(file_3) 
        @Assert(resStr, "UTF-16LE")
        try {
            var file4_1: File = File("../util_test/utf-16le.txt", OpenMode.Append)
            resStr = UniversalDetector.detectCharset(file4_1)
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not have the read permission"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/UniversalDetector/../util_test/utf-16le.txt` does not have the read permission.
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByFile_05(): Unit {
        returnFlag = 0
        var file5_1: File = File("../util_test/iso_2022_cn.txt", OpenMode.Read) // iso_2022_cn.txt 的中文字符经java检测为UTF-8
        try {
            resStr = UniversalDetector.detectCharset(file5_1) // UTF-8  对标java
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-8")
        @Assert(returnFlag, 0)
    }
}
