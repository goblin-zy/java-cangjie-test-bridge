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
    var res: Int32 = -1

    @TestCase
    func testUTF8SMModel_getClass_01(): Unit {
        res = ins_UTF8SMModel.getClass(0) 
        @Assert(res, 1)
        res = ins_UTF8SMModel.getClass(23) 
        @Assert(res, 1)
    }

    @TestCase
    func testHZSMModel_getClass_01(): Unit {
        returnFlag = 0
        try {
            res = ins_HZSMModel.getClass(255) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(res, 1)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testISO2022CNSMModel_getClass_01(): Unit {
        res = ins_ISO2022CNSMModel.getClass(12)
        @Assert(res, 0)
    }
}
