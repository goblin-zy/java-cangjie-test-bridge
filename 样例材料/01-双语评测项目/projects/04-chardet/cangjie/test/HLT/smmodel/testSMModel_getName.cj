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
    var res: String = ""

    @TestCase
    func testSMModel_getName_01(): Unit {
        res = ins_UTF8SMModel.getName() 
        @Assert(res, "UTF-8")
        res = ins_HZSMModel.getName() 
        @Assert(res, "HZ-GB-2312")

        res = ins_ISO2022CNSMModel.getName() 
        @Assert(res, "ISO-2022-CN")
    }
}
