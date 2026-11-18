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
    var returnFlag: Int64 = -1
    var tag: Int64 = -1
    var res: Int32 = -1

    @TestCase
    func testUTF8SMModel_getNextState_01(): Unit {
        res = ins_UTF8SMModel.getNextState(0, 1) 
        @Assert(res, 1)
        res = ins_UTF8SMModel.getNextState(-1, 2) 
        @Assert(res, 1)

        try {
            res = ins_UTF8SMModel.getNextState(255, 2) 
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testHZSMModel_getNextState_01(): Unit {
        returnFlag = 0
        res = ins_HZSMModel.getNextState(1, 5) 
        @Assert(res, 1)

        try {
            res = ins_HZSMModel.getNextState(12, -12) 
        } catch (e1: IndexOutOfBoundsException) {
            tag = 1
            if (tag != 1) {
                returnFlag = 1
            }
        }

        try {
            res = ins_HZSMModel.getNextState(25, 251) 
        } catch (e2: IndexOutOfBoundsException) {
            tag = 2
            if (tag != 2) {
                returnFlag = 2
            }
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testISO2022CNSMModel_getNextState_01(): Unit {
        returnFlag = -1
        res = ins_ISO2022CNSMModel.getNextState(1, 0) 
        @Assert(res, 3)
        res = ins_ISO2022CNSMModel.getNextState(12, -1) 
        @Assert(res, 0)

        try {
            res = ins_ISO2022CNSMModel.getNextState(-252, 23) 
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
