// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributeTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testAttribute_getValue_01(): Unit {
        strRes = ins_1.getValue()
        @Assert(strRes, "中文值【哈喽！】")
        ins_1.setValue(Option<String>.Some("setKey: 新键_K1"))
        strRes = ins_1.getValue()
        @Assert(strRes, "setKey: 新键_K1")
    }

    @TestCase
    func testAttribute_getValue_02(): Unit {
        returnFlag = 0
        strRes = ins_1.getValue()
        @Assert(strRes, "setKey: 新键_K1")
        ins_1.setValue(Option<String>.None)
        try {
            strRes = ins_1.getValue()
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttribute_getValue_03(): Unit {
        returnFlag = 0
        let ins_3: Attribute = Attribute("hello", "")
        try {
            strRes = ins_3.getValue()
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(strRes, "")
        ins_3.setValue(Option<String>.Some("Hello Cang!@#$%^&*()_+:<>?|jie Lang你好！"))
        strRes = ins_3.getValue()
        @Assert(strRes, "Hello Cang!@#$%^&*()_+:<>?|jie Lang你好！")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttribute_getValue_04(): Unit {
        let str: String = sourceDataIns.getLargeString(20000) //超长
        returnFlag = 0
        let ins_4: Attribute = Attribute("hello", str)
        try {
            strRes = ins_4.getValue()
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        ins_4.setValue(Option<String>.Some("Hello Cang!@#$%^&*()_+:<>?|jie Lang你好！"))
        strRes = ins_4.getValue()
        @Assert(strRes, "Hello Cang!@#$%^&*()_+:<>?|jie Lang你好！")
        @Assert(returnFlag, 0)
    }
}
