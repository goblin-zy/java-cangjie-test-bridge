// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class CodingStateMachineTest {
    let ins_UTF8SMModel: SMModel = UTF8SMModel()
    let ins_HZSMModel: SMModel = HZSMModel()
    let ins_ISO2022CNSMModel: SMModel = ISO2022CNSMModel()
    var returnFlag: Int64 = 0
    var res: Int32 = -1

    @TestCase
    func testUTF8SMModel_nextState_01(): Unit {
        let codingStateMachine_UTF8: CodingStateMachine = CodingStateMachine(ins_UTF8SMModel)
        res = codingStateMachine_UTF8.nextState(0)
        @Assert(res, 0)
        res = codingStateMachine_UTF8.nextState(23)
        @Assert(res, 0)
    }

    @TestCase
    func testHZSMModel_nextState_01(): Unit {
        let codingStateMachine_HZSMModel: CodingStateMachine = CodingStateMachine(ins_HZSMModel)
        returnFlag = 0
        try {
            res = codingStateMachine_HZSMModel.nextState(255)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(res, 1)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testISO2022CNSMModel_nextState_01(): Unit {
        let codingStateMachine_ISO2022CNSMModel: CodingStateMachine = CodingStateMachine(ins_ISO2022CNSMModel)
        res = codingStateMachine_ISO2022CNSMModel.nextState(0x02)
        @Assert(res, 0)
    }
}
