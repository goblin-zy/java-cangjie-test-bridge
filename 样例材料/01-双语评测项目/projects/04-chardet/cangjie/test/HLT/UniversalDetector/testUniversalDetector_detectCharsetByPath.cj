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
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""
    var file_1: File = File("../util_test/utf8.txt", OpenMode.Read)
    var file_2: File = File("../util_test/utf-16be.txt", OpenMode.Read)
    var file_3: File = File("../util_test/utf-16le.txt", OpenMode.Read)

    @TestCase
    func testUniversalDetector_detectCharsetByPath_01(): Unit {
        let path_1: Path = Path("../util_test/utf-16be.txt")
        try {
            resStr = UniversalDetector.detectCharset(path_1) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-16BE")
        resStr = detector.getDetectedCharset() 
        @Assert(resStr, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByPath_02(): Unit {
        let path_1: Path = Path("../util_test/utf-16le.cj") //对文件格式不做校验
        try {
            resStr = UniversalDetector.detectCharset(path_1) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-16LE")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUniversalDetector_detectCharsetByPath_03(): Unit {
        let path_1: Path = Path("../util_test/utf8.txt")
        try {
            resStr = UniversalDetector.detectCharset(path_1) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-8")
        let path_2: Path = Path("../util_test/utf8我不在.docx") //文件不存在
        try {
            resStr = UniversalDetector.detectCharset(path_2)
        } catch (e2: FSException) {
            @Assert(e2.toString().contains("does not exist or permission denied"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
