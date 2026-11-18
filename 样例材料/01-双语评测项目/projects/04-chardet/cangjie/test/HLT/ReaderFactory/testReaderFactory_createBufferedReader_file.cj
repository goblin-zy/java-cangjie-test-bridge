// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//data_file:../util_test/utf8.txt
//data_file:../util_test/utf-16be.txt
//data_file:../util_test/utf-16le.txt
import std.fs.*
import std.io.*
import chardet4cj.*
import charset4cj.charset.*

@Test
public class ReaderFactoryTest {
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var dataLen: Int64 = 0
    var file_1: File = File("../util_test/utf8.txt", OpenMode.Read)
    var file_2: File = File("../util_test/utf-16be.txt", OpenMode.Read)
    var file_3: File = File("../util_test/utf-16le.txt", OpenMode.Read)

    @TestCase
    func testReaderFactory_createBufferedReader_01(): Unit {
        var originalEncoding1: File = ReaderFactory.createBufferedReader(file_1)
        dataLen = originalEncoding1.length
        @Assert(dataLen, 1768)

        try {
            var originalEncoding2: File = ReaderFactory.createBufferedReader(file_2) //默认编码为utf8
            dataLen = originalEncoding2.length
        } catch (e1: FSException) {
            returnFlag = 1
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testReaderFactory_createBufferedReader_02(): Unit {
        returnFlag = -1
        try {
            var file_1: File = File("../../../util_test/utf8_16.txt", OpenMode.Read) //文件路径不存在
            ReaderFactory.createBufferedReader(file_1)
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not exist"), true) // FSException: The path `../../../util_test` does not exist.
            returnFlag = 0
        }

        @Assert(returnFlag, 0)
    }

    @TestCase
    func testReaderFactory_createBufferedReader_03(): Unit {
        returnFlag = -1
        var file_1: File = File("../util_test/utf8.txt", OpenMode.Append) //文件不可读
        try {
            ReaderFactory.createBufferedReader(file_1)
        } catch (e1: FSException) {
            @Assert(e1.toString().contains("does not have the read permission"), true) // FSException: The file `/home/wyf/gitcode/up/chardet4cj/test/tmp/test/HLT/ReaderFactory/../util_test/utf8.txt` does not have the read permission.
            returnFlag = 0
        }

        @Assert(returnFlag, 0)
    }
}
