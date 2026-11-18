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
    var returnFlag: Int64 = 0
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_compare01(): Unit {
        var hashCode_1 = ins_1.hashCode()
        var attr_1 = ins_1.clone()
        var hashCode_2 = attr_1.hashCode()
        @Assert(hashCode_1 != hashCode_2, true)
        @Assert(ins_1 == attr_1 ,true )
        attr_1.put(tuple_res[0][1], Some(tuple_res[0][9])) //修改属性值后再次判等
        var hashCode_3 = attr_1.hashCode()
        @Assert(hashCode_3 != hashCode_2,true )
        @Assert(ins_1 != attr_1,true )
        @Assert(hashCode_1 ,ins_1.hashCode())
        let ins_2: Attributes = Attributes()
        ins_2.add("/key", Some("/value_"))
        for (i in 0..350) {
            ins_2.put("key_${i}", Some("value_${i}"))
        }
        var hashCode_4 = ins_2.hashCode()
        @PowerAssert(hashCode_4 != 0)
        @Assert(returnFlag, 0)
    }
}
