// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class ChardetTest {
    var charsetp: CharsetProber = UTF8Prober()
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = -1
    var res: Int64 = 0
    @TestCase
    func testProber_filterWithEnglishLetters_01(): Unit {
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata, 0, Int32(bufdata.size - 10))
        let str: String = bytebuf_1.toString()
        @Assert(str, "ChardetByteBuffer: [offset=0 mark=-1 pos=0 lim=35 cap=35]")
        try {
            charsetp.filterWithoutEnglishLetters(bufdata, -1, Int32(bufdata.size - 10))
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            res = 1
            if (res != 1) {
                returnFlag = 1
            }
        }

        try {
            charsetp.filterWithoutEnglishLetters(bufdata, 0, -10)
        } catch (e2: ChardetException) {
            @Assert(e2.toString().contains("ChardetException"), true)
            res = 2
            if (res != 2) {
                returnFlag = 2
            }
        }

        try {
            charsetp.filterWithoutEnglishLetters(bufdata, 55, Int32(bufdata.size + 10))
        } catch (e3: IndexOutOfBoundsException) {
            @Assert(e3.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testProber_filterWithEnglishLetters_02(): Unit {
        returnFlag = -1
        var bufdata_2: Array<Byte> = Array<Byte>()
        try {
            var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata_2, 0, Int32(bufdata_2.size + 2))
            bytebuf_1.toString()
        } catch (e4: ChardetException) {
            @Assert(e4.toString().contains("ChardetException: this buf is empty"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testProber_filterWithEnglishLetters_03(): Unit {
        var bufdata_3: Array<Byte> = commonUtils_ins.getStrWithEnglishLetters(10).toArray() //源数据超长
        var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata_3, 0, Int32(bufdata_3.size))
        let str: String = bytebuf_1.toString()
        @Assert(bufdata_3.size, 431)
        @Assert(str, "ChardetByteBuffer: [offset=0 mark=-1 pos=0 lim=431 cap=431]")
    }

    @TestCase
    func testProber_filterWithEnglishLetters_04(): Unit {
        var bufdata_4: Array<Byte> =
            "testCharsetProber_UTF8_filterWithoutEnglishLetters_04元数据含中文哦".toArray()
        var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata_4, 0, Int32(bufdata_4.size - 5))
        let str: String = bytebuf_1.toString()
        @Assert(bufdata_4.size, 74)
        @Assert(str, "ChardetByteBuffer: [offset=0 mark=-1 pos=16 lim=69 cap=69]")
    }

    @TestCase
    func testProber_filterWithEnglishLetters_05(): Unit {
        var bufdata_5: Array<Byte> = "元数据全中文哦".toArray()
        var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata_5, 0, Int32(bufdata_5.size - 5))
        let str: String = bytebuf_1.toString()
        @Assert(bufdata_5.size, 21)
        @Assert(str, "ChardetByteBuffer: [offset=0 mark=-1 pos=16 lim=16 cap=16]")
    }

    @TestCase
    func testProber_filterWithEnglishLetters_06(): Unit {
        returnFlag = -1
        var bufdata_2: Array<Byte> = Array<Byte>()
        try {
            var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata_2, 0, Int32(bufdata_2.size))
            bytebuf_1.toString()
        } catch (e5: ChardetException) {
            @Assert(e5.toString().contains("ChardetException: this buf is empty"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
