// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributesTest {
    let ins_1: Attributes = Attributes()
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int64 = 0
    var resBool: Bool = false
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_hasKey_01(): Unit {
        try {
            resBool = ins_1.hasKey("key不存在") //key不存在
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(resBool, false)
        strRes = ins_1.add("keY_1", Some(tuple_res[0][8])).toString()
        @Assert(strRes.toRuneArray().size, 46)
        resBool = ins_1.hasKey("KEY_1")
        @Assert(resBool, false)
        resBool = ins_1.hasKeyIgnoreCase("key_1")
        @Assert(resBool, true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_hasKeyIgnoreCase_02(): Unit {
        let ins_2: Attributes = Attributes()
        strRes = ins_2.add("", Some(tuple_res[0][2])).toString()
        resInt = ins_2.size
        @Assert(resInt, 1)
        resBool = ins_2.hasKeyIgnoreCase("")
        @Assert(resBool, true)
        resBool = ins_2.hasKey("")
        @Assert(resBool, true)

        strRes = ins_2.getIgnoreCase(tuple_res[0][0])
        @Assert(strRes.toRuneArray().size, 7)
        strRes = ins_2.put("tuple_res中文键", Some("当前键已存在")).toString()
        resInt = ins_2.size
        @Assert(resInt, 2)
        strRes = ins_2.getIgnoreCase("TUpLE_RES中文键")
        @Assert(strRes, "当前键已存在")
        try {
            resBool = ins_2.hasKey("TUPLE_RES中文键")
        } catch (e2: NoneValueException) {
            returnFlag = 2
        }
        @Assert(resBool, false)
        resBool = ins_2.hasKeyIgnoreCase("TUPLE_RES中文键")
        @Assert(resBool, true)
        @Assert(returnFlag, 0)
    }
}
