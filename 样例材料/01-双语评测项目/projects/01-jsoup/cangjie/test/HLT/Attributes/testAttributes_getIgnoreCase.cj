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
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_getIgnoreCase_01(): Unit {
        try {
            strRes = ins_1.getIgnoreCase("hao吃") //key不存在
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "")
        strRes = ins_1.add("keY_1", Some(tuple_res[0][9])).toString()
        @Assert(strRes.toRuneArray().size, 135)
        strRes = ins_1.get("KEY_1")
        @Assert(strRes.toRuneArray().size, 0)
        strRes = ins_1.getIgnoreCase("key_1")
        @Assert(strRes.toRuneArray().size, 122)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_getIgnoreCase_02(): Unit {
        let ins_2: Attributes = Attributes()
        strRes = ins_2.add(tuple_res[0][1], Some(tuple_res[0][2])).toString()
        resInt = ins_2.size
        @Assert(strRes.toRuneArray().size, 27)
        @Assert(resInt, 1)
        strRes = ins_2.get(tuple_res[0][1])
        @Assert(strRes.toRuneArray().size, 7)
        strRes = ins_2.getIgnoreCase(tuple_res[0][1])
        @Assert(strRes.toRuneArray().size, 7)
        strRes = ins_2.put("tuple_res[0][1]", Some("当前键已存在")).toString()
        resInt = ins_2.size
        @Assert(strRes.toRuneArray().size, 52)
        @Assert(resInt, 2)
        strRes = ins_2.getIgnoreCase("TUpLE_rES[0][1]") // 你好仓颉！【】 会有两个键为HelloCangjieLang的值，不会覆盖
        @Assert(strRes, "当前键已存在")
        @Assert(returnFlag, 0)
    }
}
