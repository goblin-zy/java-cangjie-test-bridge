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
    func testAttributes_html_01(): Unit {
        try {
            strRes = ins_1.html()
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "")
        strRes = ins_1.add("keY_1", Some(tuple_res[0][9])).toString()
        @Assert(strRes.toRuneArray().size, 135)
        strRes = ins_1.html()
        @Assert(strRes.contains("keY_1=\"Hello Cang!@#$%^&amp;*()_+:<>?|jie LangHello Cangjie Lang"), true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_html_02(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        resInt = ins_2.size
        @Assert(resInt, 5)
        strRes = ins_2.html() // key_0="value_0" key_1="value_1" key_2="value_2" key_3="value_3" key_4="value_4"
        @Assert(strRes.toRuneArray().size,80)
        ins_2.remove("key_3")
        strRes = ins_2.html() // key_0="value_0" key_1="value_1" key_2="value_2" key_4="value_4"
        @Assert(strRes.toRuneArray().size,64)
    }

    @TestCase
    func testAttributes_html_03(): Unit {
        let ins_3: Attributes = Attributes()
        var strRes: String = ""
        ins_3.add("/key", Some("/value_")).toString()
        strRes = ins_3.get("/key")
        @Assert(strRes, "/value_")
        for (i in 0..5) {
            strRes = ins_3.put("key_${i}", Some("value_${i}")).toString()
        }
        ins_3.put("data-animal-type", Some("value_data"))
        resInt = ins_3.size
        @Assert(resInt, 7)
        strRes = ins_3.html() // \key="\2value_" key_0="value_0" key_1="value_1" key_2="value_2" key_3="value_3" key_4="value_4" data-animal-type="value_data"
        @Assert(strRes.toRuneArray().size, 110)
    }
}
