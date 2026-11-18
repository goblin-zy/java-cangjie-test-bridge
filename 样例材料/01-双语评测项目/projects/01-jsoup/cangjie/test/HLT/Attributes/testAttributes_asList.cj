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
    var resArrL: ArrayList<Attribute> = ArrayList<Attribute>()
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_asList_01(): Unit {
        resArrL = ins_1.asList()
        @Assert(resArrL.size, 0)
        strRes = ins_1.add("keY_1", Some(tuple_res[0][9])).toString()
        @Assert(strRes.toRuneArray().size, 135)
        strRes = ins_1.getIgnoreCase("key_1")
        @Assert(strRes.toRuneArray().size, 122)
        resArrL = ins_1.asList()
        @Assert(resArrL.size, 1)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_asList_02(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        resInt = ins_2.size
        @Assert(resInt, 5)
        resArrL = ins_2.asList()
        @Assert(resArrL.size, 5)
        @Assert(resArrL[1].toString(),"key_1=\"value_1\"" )
        ins_2.remove("key_3")
        resArrL = ins_2.asList()
        @Assert(resArrL.size, 4)
    }

    @TestCase
    func testAttributes_asList_03(): Unit {
        let ins_3: Attributes = Attributes()
        var strRes: String = ""
        ins_3.put("/key", Some("/2value_")).toString()
        for (i in 0..5) {
            strRes = ins_3.put("key_${i}", Some("value_${i}")).toString()
        }
        ins_3.put("data-animal-type", Some("value_data"))
        resInt = ins_3.size
        @Assert(resInt, 7)
        resArrL = ins_3.asList() // 不包含\开头的属性
        @Assert(resArrL.size, 6)
    }
}
