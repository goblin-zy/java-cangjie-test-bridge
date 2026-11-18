// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset
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
    var file: File = File("../util_test/utf-16le.txt", OpenMode.Read)

    @TestCase
    func test_detectCharset_UTF16LE(): Unit {
        returnFlag = -1
        resStr = UniversalDetector.detectCharset(file) // UTF-16LE
        @Assert(resStr, "UTF-16LE")
        try {
            var file_2: File = File("../util_test/utf-16le.txt", OpenMode.Append)
            resStr = UniversalDetector.detectCharset(file_2)
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not have the read permission"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/SIT/../util_test/utf-16le.txt` does not have the read permission.
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
