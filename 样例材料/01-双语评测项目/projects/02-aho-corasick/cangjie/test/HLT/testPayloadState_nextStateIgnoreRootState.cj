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
    func testPayloadState_nextStateIgnoreRootState_01(): Unit {
        returnFlag = -1
        var str1: String = "^& 2<R>好"
        let payload_1: Payload<String> = Payload(str1, Option<String>.None)
        let payloadState_1: PayloadState<String> = PayloadState<String>(0)
        @Assert(payloadState_1.getStates().size, 0)
        payloadState_1.nextStateIgnoreRootState(r'2')
        @Assert(payloadState_1.getStates().isEmpty(), true)
        payloadState_1.addEmit(payload_1)
        payloadState_1.addState(r'<')
        try {
            payloadState_1.nextStateIgnoreRootState(r'R').getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        payloadState_1.nextStateIgnoreRootState(r'<')
        var charArrL: Collection<Rune> = payloadState_1.getTransitions()
        strRes = charArrL.toArray().toString()
        @Assert(strRes, "[<]")
        let payloadState_2: PayloadState<String> = PayloadState<String>(-6)
        payloadState_2.addState(r'<')
        payloadState_2.nextStateIgnoreRootState(r'<')
        var charArrL2: Collection<Rune> = payloadState_2.getTransitions()
        strRes = charArrL2.toArray().toString()
        @Assert(strRes, "[<]")
        @Assert(returnFlag, 0)
    }
}
