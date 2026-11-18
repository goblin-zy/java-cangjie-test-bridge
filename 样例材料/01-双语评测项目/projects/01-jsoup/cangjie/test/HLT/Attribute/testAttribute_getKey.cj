// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributeTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "Attribute_V1")
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testAttribute_getKey_01(): Unit {
        strRes = ins_1.getKey()
        @Assert(strRes, "Attribute_K1")
        ins_1.setKey("setKey: 新键_K1")
        strRes = ins_1.getKey()
        @Assert(strRes, "setKey: 新键_K1")
        strRes = ins_1.getValue()
        @Assert(strRes, "Attribute_V1")
    }

    @TestCase
    func testAttribute_getKey_02(): Unit {
        let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString(
        )
        let ins_2: Attribute = Attribute(tuple_res[0][1], tuple_res[0][9])
        strRes = ins_2.getKey()
        @Assert(strRes, "\"Hello Cangjie Lang\"")
        ins_2.setKey(tuple_res[1][3]) //插值str
        strRes = ins_2.getKey()
        @Assert(strRes.toRuneArray().size, 82)
        strRes = ins_2.getValue()
        @Assert(strRes.toRuneArray().size, 122)
    }

    @TestCase
    func testAttribute_getKey_03(): Unit {
        let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString(
        )
        try {
            let ins_3: Attribute = Attribute("", tuple_res[0][9])
            strRes = ins_3.getKey()
            try {
                strRes = ins_3.getValue()
            } catch (e1: NoneValueException) {
                returnFlag = 1
            }
        } catch (e2: ValidationException) {
            @Assert(e2.message,"String must not be empty")
            returnFlag = 0
        }
        @Assert(strRes.toRuneArray().size, 122)
    }

    @TestCase
    func testAttribute_getKey_04(): Unit {
        let str: String = sourceDataIns.getLargeString(5000) //超长
        let ins_3: Attribute = Attribute(str, "key_键一")
        strRes = ins_3.getKey()
        @Assert(strRes.toRuneArray().size, 495000)
    }
}
