// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class SMModelTest {
    let ins_UTF8SMModel: SMModel = UTF8SMModel()
    let ins_HZSMModel: SMModel = HZSMModel()
    let ins_ISO2022CNSMModel: SMModel = ISO2022CNSMModel()
    var returnFlag: Int64 = 0
    var tag: Int32 = -1
    var res: Int32 = -1

    @TestCase
    func testUTF8SMModel_getCharLen_01(): Unit {
        res = ins_UTF8SMModel.getCharLen(0) 
        @Assert(res, 0)

        try {
            res = ins_UTF8SMModel.getCharLen(5) 
        } catch (e1: IndexOutOfBoundsException) {
            returnFlag = 2
        }
        @Assert(res, 0)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testHZSMModel_getCharLen_01(): Unit {
        returnFlag = -1
        try {
            res = ins_UTF8SMModel.getCharLen(23) 
        } catch (e1: IndexOutOfBoundsException) {
            returnFlag = 0
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testISO2022CNSMModel_getCharLen_01(): Unit {
        returnFlag = -1
        try {
            res = ins_ISO2022CNSMModel.getCharLen(-252) 
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(res, 0)
        @Assert(returnFlag, 0)
    }
}
