// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//data_file:../util_test/utf8.txt
import std.fs.*
import std.io.*
import chardet4cj.*
import charset4cj.charset.*

@Test
public class ReaderFactoryTest {
    var returnFlag: Int64 = -1
    var res: Int32 = 0
    var dataLen: Int64 = 0

    @TestCase
    func testReaderFactory_createReaderFromFile_01(): Unit {
        var file_1: File = File("../util_test/utf8.txt", OpenMode.Read) //文件utf8格式
        var originalEncoding1: File = ReaderFactory.createReaderFromFile(file_1, Charsets.UTF8)
        dataLen = originalEncoding1.length
        @Assert(dataLen, 1768)

        try {
            var originalEncoding2: File = ReaderFactory.createReaderFromFile(file_1, Charsets.UTF16BE) 
            dataLen = originalEncoding2.length
        } catch (e1: ChardetException) {
            @Assert(e1.toString().contains("ChardetException: this inputStream is empty"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testReaderFactory_createReaderFromFile_02(): Unit {
        returnFlag = -1
        try {
            var file_1: File = File("../util_test/utf8_0000.cj", OpenMode.Read) //文件路径不存在
            ReaderFactory.createReaderFromFile(file_1, Charsets.UTF8)
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not exist or permission denied"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/ReaderFactory/../util_test/utf8_0000.cj` does not exist or permission denied!
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
