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
    func testAttributes_toString_01(): Unit {
        try {
            strRes = ins_1.toString() // 空
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "")
        ins_1.add("keY_1", Some(tuple_res[0][9]))
        strRes = ins_1.toString()
        @Assert(strRes.toRuneArray().size, 135)
        @Assert(strRes.contains("keY_1=\"Hello Cang!@#$%^&amp;*()_+:<>?|jie LangHello Cangjie Lang"), true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_toString_02(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            ins_2.put("key_${i}", Some("value_${i}"))
        }
        resInt = ins_2.size
        @Assert(resInt, 5)
        strRes = ins_2.toString() // key_0="value_0" key_1="value_1" key_2="value_2" key_3="value_3" key_4="value_4"
        @Assert(strRes.toRuneArray().size,80)
        ins_2.remove("key_3")
        strRes = ins_2.toString() // key_0="value_0" key_1="value_1" key_2="value_2" key_4="value_4"
        @Assert(strRes.toRuneArray().size,64)
    }

    @TestCase
    func testAttributes_toString_03(): Unit {
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
        strRes = ins_3.toString() // \key="\2value_" key_0="value_0" key_1="value_1" key_2="value_2" key_3="value_3" key_4="value_4" data-animal-type="value_data"
        @Assert(strRes.toRuneArray().size, 110)
    }

    @TestCase
    func testAttributes_toString_04(): Unit {
        let ins_4: Attributes = Attributes()
        var strRes: String = ""
        ins_4.add("转义值", Some("\"Hello Cangjie\\f Lang"))
        strRes = ins_4.toString()
        ins_4.add("\"Hello Cangjie\\f Lang", "转义键")
        strRes = ins_4.toString()
        @Assert(strRes, " 转义值=\"&quot;Hello Cangjie\\f Lang\" HelloCangjie\\fLang=\"转义键\"") //   转义值="&quot;Hello Cangjie\f Lang" HelloCangjie\fLang="转义键"
        ins_4.put("中文键", None)
        ins_4.put("属性值为None", None)
        strRes = ins_4.toString()
        @Assert(strRes, " 转义值=\"&quot;Hello Cangjie\\f Lang\" HelloCangjie\\fLang=\"转义键\" 中文键 属性值为None")
    }
}
