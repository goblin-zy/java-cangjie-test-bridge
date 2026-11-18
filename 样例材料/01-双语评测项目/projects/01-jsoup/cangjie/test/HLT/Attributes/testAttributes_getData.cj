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
    var strRes2: String = ""
    var returnFlag: Int64 = 0
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_getData_01(): Unit {
        try {
            strRes = ins_1.getData("hao吃").getOrThrow() //key不存在
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
        }
        @Assert(strRes, "")
        ins_1.put(tuple_res[0][1], Some(tuple_res[0][9])) // 不含data-的键
        @Assert(ins_1.dataSize, 0)
        try {
            strRes = ins_1.getData(tuple_res[0][1]).getOrThrow()
        } catch (e2: NoneValueException) {
            @Assert(e2.toString().contains("NoneValueException"), true)
        }
        ins_1.putData("K_1", "data-value")
        strRes = ins_1.getData("K_1").getOrThrow()
        @Assert(strRes, "data-value")
        @Assert(ins_1.dataSize, 1)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_getData_02(): Unit {
        let ins_2: Attributes = Attributes()
        ins_2.putData("data-K1", "data-value")
        strRes = ins_2.getData("data-K1").getOrThrow()
        @Assert(strRes, "data-value")
        ins_2.put("K1", Some(tuple_res[0][9])) // 不含data-的键
        try {
            strRes = ins_2.getData("K1").getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
        }
    }

    @TestCase
    func testAttributes_getData_03(): Unit {
        strRes = ""
        let ins_3: Attributes = Attributes()
        ins_3.putData("/cangjie", "data-/cangjie_V")
        strRes = ins_3.getData("/cangjie").getOrThrow()
        @Assert(strRes, "data-/cangjie_V")
        ins_3.putData("中文键", "你好，山姆")
        strRes = ins_3.getData("中文键").getOrThrow()
        @Assert(strRes, "你好，山姆")
        ins_3.putData("\"Hello Cangjie\\f Lang", "转义字符")
        strRes = ins_3.getData("\"Hello Cangjie\\f Lang").getOrThrow()
        @Assert(strRes, "转义字符")
        @Assert(ins_3.dataSize, 3)
        strRes = ins_3.toString()
        let str =
            "data-cangjie=\"data-/cangjie_V\"data-中文键=\"你好，山姆\"data-HelloCangjie\\fLang=\"转义字符\""
        @Assert(strRes.replace("\n","").replace(" ",""),str)
    }

    @TestCase
    func testAttributes_getData_04(): Unit {
        returnFlag = -1
        let ins_4: Attributes = Attributes()
        ins_4.putData("K_teST", "混合键")
        try {
            strRes = ins_4.getData("K_test").getOrThrow()
        } catch (e2: NoneValueException) {
            @Assert(e2.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        strRes = ins_4.getData("K_teST").getOrThrow()
        @Assert(strRes, "混合键")
        ins_4.putData("!@~#@$%^$%&^%*(&*>?|+*)", "特殊字符")
        try {
            strRes = ins_4.getData("!@~#@$%^$%&^%*(&*>?|+*)").getOrThrow()
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "特殊字符")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_getData_05(): Unit {
        returnFlag = -1
        let ins_5: Attributes = Attributes()
        ins_5.putData("v_None", None)
        try {
            strRes = ins_5.getData("v_None").getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        try {
            strRes2 = ins_5.putData("v_old", "putFirst").getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        strRes = ins_5.getData("v_old").getOrThrow()
        @Assert(strRes, "putFirst")
        strRes2 = ins_5.putData("v_old", "putSecond").getOrThrow()
        @Assert(strRes2, "putFirst")
        try {
            strRes = ins_5.getData("v_old").getOrThrow()
        } catch (e2: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "putSecond")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_getData_06(): Unit {
        returnFlag = 0
        strRes = ""
        let ins_6: Attributes = Attributes()
        ins_6.putData("", "空键")
        @Assert(ins_6.getData("") == None, true)
        ins_6.put("data-", "空键2")
        @Assert(ins_6.get("data-") == "空键2", true)
        ins_6.putData("空值", "")
        strRes = ""
        try {
            strRes = ins_6.getData("空值").getOrThrow()
        } catch (e2: NoneValueException) {
            returnFlag = 2
        }
        @Assert(strRes, "")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_getData_07(): Unit {
        returnFlag = 0
        strRes = ""
        let ins_7: Attributes = Attributes()
        var str1 = sourceDataIns.getLargeString(500)
        ins_7.putData(str1, "超长键")
        try {
            strRes = ins_7.getData(str1).getOrThrow()
        } catch (e2: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "超长键")
        ins_7.putData("超长值", str1)
        strRes = ""
        try {
            strRes = ins_7.getData("超长值").getOrThrow()
        } catch (e2: NoneValueException) {
            returnFlag = 2
        }
        @Assert(strRes.endsWith("HashSet<String>) = (resArr,resArrL,resSet)"), true)
        @Assert(strRes.toRuneArray().size, 49500)
        @Assert(returnFlag, 0)
    }
}
