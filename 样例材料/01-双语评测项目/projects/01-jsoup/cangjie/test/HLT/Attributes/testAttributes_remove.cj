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
    var returnFlag: Int64 = -1
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_remove_01(): Unit {
        returnFlag = 0
        ins_1.remove("key不存在") //key不存在，业务不会有显式异常
        strRes = ins_1.add("keY_1", Some(tuple_res[0][9])).toString()
        @Assert(strRes.toRuneArray().size, 135)
        strRes = ins_1.getIgnoreCase("key_1")
        @Assert(strRes.toRuneArray().size, 122)
        @Assert(ins_1.size, 1)
        ins_1.remove("keY_1")
        @Assert(ins_1.size, 0)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_remove_02(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        resInt = ins_2.size
        @Assert(resInt, 5)
        ins_2.remove("key_3")
        resInt = ins_2.size
        @Assert(resInt, 4)
    }
}
