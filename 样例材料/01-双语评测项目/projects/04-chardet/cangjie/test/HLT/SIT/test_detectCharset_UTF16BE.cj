// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset
//data_file:../util_test/utf-16be.txt
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UniversalDetectorTest {
    var detector: UniversalDetector = UniversalDetector()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""
    var file_2: File = File("../util_test/utf-16be.txt", OpenMode.Read)

    @TestCase
    func test_detectCharset_UTF16BE(): Unit {
        returnFlag = -1
        try {
            resStr = UniversalDetector.detectCharset(file_2) // UTF-16BE
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-16BE")

        try {
            var file3_1: File = File("../util_test/仓颉utf-16be.txt", OpenMode.Read) //文件不存在
            resStr = UniversalDetector.detectCharset(file3_1)
        } catch (e2: FSException) {
            @Assert(e2.toString().contains("does not exist or permission denied!"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/SIT/../util_test/仓颉utf-16be.txt` does not exist or permission denied!
            returnFlag = 0
        }

        @Assert(returnFlag, 0)
    }
}
