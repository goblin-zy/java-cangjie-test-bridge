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
    func testAttributes_put_ViaBool_01(): Unit {
        strRes = ins_1.put(tuple_res[0][1], true).toString() // tuple_res[0][1] ="\"Hello Cangjie Lang\""
        @Assert(strRes.trimAscii(), "HelloCangjieLang")
        strRes = ins_1.get(tuple_res[0][1])
        @Assert(strRes.toRuneArray().size, 0) // 新增这条属性，其值为None
        strRes = ins_1.put("key_1", "value_1").toString() // HelloCangjieLang key_1="value_1"
        @Assert(strRes.trimAscii(), "HelloCangjieLang key_1=\"value_1\"")
        strRes = ins_1.get("key_1")
        @Assert(strRes, "value_1")
        strRes = ins_1.put("key_1", true).toString() // 当前键已存在，替换这条属性，其值为None
        @Assert(strRes.trimAscii(), "HelloCangjieLang key_1")
        strRes = ins_1.get("key_1")
        @Assert(strRes.toRuneArray().size, 0) // 替换这条属性，其值为None
        strRes = ins_1.put("key_1", false).toString() // 删除这条属性
        @Assert(strRes.trimAscii(), "HelloCangjieLang")
        try {
            strRes = ins_1.get("key_1")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_put_ViaBool_02(): Unit {
        let ins_2: Attributes = Attributes()
        strRes = ins_2.put("中文键", true).toString()
        @Assert(strRes, " 中文键")
        strRes = ins_2.put("data-key1", true).toString()
        @Assert(strRes, " 中文键 data-key1")
        strRes = ins_2.put("/-key1", true).toString()
        @Assert(strRes, " 中文键 data-key1")
        strRes = ins_2.get("data-key1")
        @Assert(strRes.toRuneArray().size, 0)
        @Assert(ins_2.dataSize, 1)
    }
}
