// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var strRes: String = ""
    var intRes: Int64 = -1
    var int32Res: Int32 = -1
    var returnFlag: Int64 = -1

    @TestCase
    func testPayload_01(): Unit {
        var str1: String = "^%#$#@#"
        let payload_1: Payload<String> = Payload(str1, Option<String>.None)
        strRes = payload_1.getKeyword()
        @Assert(strRes, "^%#$#@#")
        @Assert(payload_1.getData(),Option<String>.None)
        @Assert(payload_1.hashCode(),4227979451565640154)
        let payload_2: Payload<String> = Payload(str1, None)
        @Assert(payload_2.hashCode(),payload_1.hashCode())
        @Assert(payload_2 == payload_1 ,true)
        @Assert(payload_2 != payload_1 ,false)
        @Assert(payload_2.compare(payload_1) == EQ ,true)
        @Assert(payload_2.compare(payload_1).toString() ,"Ordering.EQ")
    }

    @TestCase
    func testPayload_02(): Unit {
        var str1: String = "你好"
        let payload_1: Payload<String> = Payload(str1, Option<String>.None)
        strRes = payload_1.getKeyword()
        @Assert(strRes, "你好")
        @Assert(payload_1.getData(),None)
        str1 = ""
        let payload_2: Payload<String> = Payload(str1, Option<String>.None)
        @Assert(payload_2.getKeyword(),"")
        str1 = """
            cangjie
            test
          """
        let payload_3: Payload<String> = Payload(str1, str1)
        @Assert(payload_3 == payload_1 ,false)
        @Assert(payload_3.getData().getOrThrow().replace("\n","").replace(" ",""), "cangjietest")
        @Assert(payload_2.compare(payload_1).toString() ,"Ordering.LT")
        @Assert(payload_3.compare(payload_2) == GT ,true)
    }
}
