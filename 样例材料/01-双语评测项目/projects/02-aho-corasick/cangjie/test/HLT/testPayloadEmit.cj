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
    func testPayloadEmit_01(): Unit {
        var str1: String = "^%#$#@#"
        var emit_1: PayloadEmit<String> = PayloadEmit<String>(0, 0, str1, None)
        strRes = emit_1.getKeyword()
        @Assert(strRes, "^%#$#@#")
        @Assert(emit_1.getPayload(),Option<String>.None)
        @Assert(emit_1.hashCode(),4227979451565640154)
        var emit_2: PayloadEmit<String> = PayloadEmit<String>(0, 0, "^%#$#@#", None)
        @Assert(emit_2.hashCode(),emit_1.hashCode())
        @Assert(emit_2 != emit_1 ,false)
        @Assert(emit_2.toString(),"0:0=^%#$#@#->")
    }

    @TestCase
    func testPayloadEmit_02(): Unit {
        var str1: String = "你好"
        var emit_1: PayloadEmit<String> = PayloadEmit<String>(-2, 0, str1, None)
        strRes = emit_1.getKeyword()
        @Assert(strRes, "你好")
        @Assert(emit_1.getPayload(),Option<String>.None)
        str1 = ""
        var emit_2: PayloadEmit<String> = PayloadEmit<String>(-2, 0, str1, None)
        @Assert(emit_2.getKeyword(),"")
        str1 = """
            cangjie
            test
          """
        @Assert(emit_2 == emit_1 ,false)
        var emit_3: PayloadEmit<String> = PayloadEmit<String>(2, 9, str1, "payload_test")
        @Assert(emit_3 != emit_1 ,true)
        @Assert(emit_3.getPayload().getOrThrow(), "payload_test")
    }
}
