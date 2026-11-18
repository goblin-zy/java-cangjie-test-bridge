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
    func testAttributes_hasDeclaredValueForKey_01(): Unit {
        try {
            resBool = ins_1.hasDeclaredValueForKey("key不存在") //key不存在
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(resBool, false)
        strRes = ins_1.add("keY_1", Some(tuple_res[0][8])).toString()
        @Assert(strRes.toRuneArray().size, 46)
        resBool = ins_1.hasDeclaredValueForKey("KEY_1")
        @Assert(resBool, false)
        resBool = ins_1.hasDeclaredValueForKey("keY_1")
        @Assert(resBool, true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_hasDeclaredValueForKey_02(): Unit {
        let ins_2: Attributes = Attributes()
        strRes = ins_2.add("", Some(tuple_res[0][2])).toString()
        resInt = ins_2.size
        @Assert(resInt, 1)
        resBool = ins_2.hasDeclaredValueForKey("")
        @Assert(resBool, true)
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        resInt = ins_2.size
        @Assert(resInt, 6)
        var num: Int64 = 0
        for (i in 0..ins_2.size) {
            if (!(ins_2.hasDeclaredValueForKey("key_${i}"))) {
                num += i
            }
        }
        @Assert(num, 5)
        @Assert(returnFlag, 0)
    }
}
