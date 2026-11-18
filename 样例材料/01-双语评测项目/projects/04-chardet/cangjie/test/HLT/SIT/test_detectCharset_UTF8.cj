// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset
//data_file:../util_test/utf8.txt
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

    @TestCase
    func test_detectCharset_UTF8(): Unit {
        try {
            resStr = UniversalDetector.detectCharset(file_1) // UTF-8
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(resStr, "UTF-8")
        @Assert(returnFlag, 0)
    }
}
