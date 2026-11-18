// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributesTest {
    let ins_1: Attributes = Attributes()
    var strRes: String = ""
    var returnFlag: Int64 = -1
    var resInt: Int64 = -1

    @TestCase
    func testAttributes_internalKey_01(): Unit {
        strRes = Attributes.internalKey("key不存在") //key不存在，业务不会有显式异常
        @Assert(strRes, "/key不存在")
    }

    @TestCase
    func testAttributes_internalKey_02(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        resInt = ins_2.size
        @Assert(resInt, 5)
        strRes = Attributes.internalKey("key_3")
        @Assert(strRes, "/key_3")
        strRes = Attributes.internalKey("")
        @Assert(strRes, "/")
    }
}
