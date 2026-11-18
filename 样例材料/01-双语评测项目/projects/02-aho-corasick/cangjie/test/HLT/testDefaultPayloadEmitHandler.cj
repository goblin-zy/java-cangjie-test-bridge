// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var strRes: String = ""
    var boolRes: Bool = false
    var returnFlag: Int64 = -1

    @TestCase
    func testDefaultPayloadEmitHandler_01(): Unit {
        var defaultPayloadEmitHandler_1: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        var emit_1: PayloadEmit<String> = PayloadEmit<String>(0, 0, "CangjieTest", None)
        boolRes = defaultPayloadEmitHandler_1.emit(emit_1)
        @Assert(boolRes, true)
        var arrL = defaultPayloadEmitHandler_1.getEmits()
        @Assert(arrL.size, 1)
    }

    @TestCase
    func testDefaultPayloadEmitHandler_02(): Unit {
        var defaultPayloadEmitHandler_1: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        var payload_1: Option<String> = Option<String>.Some("strData")
        var emit_2: PayloadEmit<String> = PayloadEmit<String>(0, 0, "CangjieTest", payload_1)
        boolRes = defaultPayloadEmitHandler_1.emit(emit_2)
        @Assert(boolRes, true)
        var payloadEmitArrL = defaultPayloadEmitHandler_1.getEmits()
        @Assert(payloadEmitArrL.size, 1)
        strRes = payloadEmitArrL[0].toString()
        @Assert(strRes, "0:0=CangjieTest->")
    }

    @TestCase
    func testDefaultPayloadEmitHandler_03(): Unit {
        returnFlag = -1
        var defaultPayloadEmitHandler_1: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        var payload_1: Option<String> = Option<String>.Some("strData")
        try {
            var emit_2: PayloadEmit<String> = PayloadEmit<String>(2, 0, "CangjieTest", payload_1)
            boolRes = defaultPayloadEmitHandler_1.emit(emit_2)
        } catch (e1: IllegalArgumentException) {
            @Assert(e1.toString().contains("The start length must be smaller than the end length"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testDefaultPayloadEmitHandler_04(): Unit {
        var defaultPayloadEmitHandler_1: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        var payload_1: Option<String> = Option<String>.Some("strData")
        var emit_2: PayloadEmit<String> = PayloadEmit<String>(-8, -1, "CangjieTest", payload_1)
        boolRes = defaultPayloadEmitHandler_1.emit(emit_2)
        @Assert(boolRes, true)
        var payloadEmitArrL = defaultPayloadEmitHandler_1.getEmits()
        @Assert(payloadEmitArrL.size, 1)
    }
}
