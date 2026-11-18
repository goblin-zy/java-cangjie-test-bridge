// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class EscCharsetProberTest {
    var charsetp: EscCharsetProber = EscCharsetProber()
    var commonUtils_ins: CommonUtils = CommonUtils()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var state: ProbingState = ProbingState.NOT_ME
    @TestCase
    func testEscCharsetProber_handleData_01(): Unit {
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        state = charsetp.handleData(bufdata, 0, Int32(bufdata.size - 10))
        @Assert(state == DETECTING,true)

        try {
            state = charsetp.handleData(bufdata, -1, Int32(bufdata.size - 10))
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            res = 1
            if (res != 1) {
                returnFlag = 1
            }
        }

        try {
            state = charsetp.handleData(bufdata, 0, -10)
        } catch (e2: ChardetException) {
            @Assert(e2.toString().contains("ChardetException: this length is null"), true)
            res = 2
            if (res != 2) {
                returnFlag = 2
            }
        }
        @Assert(state == DETECTING,true)

        try {
            state = charsetp.handleData(bufdata, 2, Int32(bufdata.size + 2))
        } catch (e3: IndexOutOfBoundsException) {
            @Assert(e3.toString().contains("IndexOutOfBoundsException"), true)
            res = 3
            if (res != 3) {
                returnFlag = 3
            }
        }
        @Assert(state == DETECTING,true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEscCharsetProber_handleData_02(): Unit {
        returnFlag = -1
        var bufdata_2: Array<Byte> = Array<Byte>() //源数据为空,预期抛异常 
        try {
            state = charsetp.handleData(bufdata_2, 0, Int32(bufdata_2.size))
        } catch (e4: ChardetException) {
            @Assert(e4.toString().contains("ChardetException: this buf is empty"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testEscCharsetProber_handleData_03(): Unit {
        var bufdata_3: Array<Byte> = commonUtils_ins.getStrWithEnglishLetters(10).toArray() //源数据超长
        state = charsetp.handleData(bufdata_3, 0, Int32(bufdata_3.size))
        @Assert(state == DETECTING,true)
        @Assert(bufdata_3.size, 431)
        @Assert(charsetp.getConfidence(), 0.990000)
    }

    @TestCase
    func testEscCharsetProber_handleData_04(): Unit {
        returnFlag = 0
        var bufdata_4: Array<Byte> = "testCharsetProber_UTF8_handleData_04元数据含中文哦".toArray()
        try {
            state = charsetp.handleData(bufdata_4, 0, Int32(bufdata_4.size - 5))
        } catch (e5: ChardetException) {
            returnFlag = 1
        }
        @Assert(bufdata_4.size, 57)
        @Assert(state == NOT_ME,true)
        @Assert(returnFlag,0)
    }

    @TestCase
    func testEscCharsetProber_handleData_05(): Unit {
        returnFlag = 0
        var bufdata_5: Array<Byte> = "元数据全中文哦".toArray()
        try {
            state = charsetp.handleData(bufdata_5, 0, Int32(bufdata_5.size - 5))
        } catch (e6: ChardetException) {
            returnFlag = 1
        }
        @Assert(bufdata_5.size, 21)
        @Assert(state == NOT_ME,true)
        @Assert(returnFlag,0)
    }
}
