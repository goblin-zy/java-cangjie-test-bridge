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
    func testPayloadState_addEmit_01(): Unit {
        var str1: String = "^%#$#@#"
        let payload_1: Payload<String> = Payload(str1, Option<String>.None)
        let payloadState_1: PayloadState<String> = PayloadState<String>(0)
        @Assert(payloadState_1.emit().size, 0)
        payloadState_1.addEmit(payload_1)
        var payloadArrL: Collection<Payload<String>> = payloadState_1.emit()
        @Assert(payloadArrL.size, 1)
        var arr1 = payloadArrL.toArray()
        @Assert(arr1[0].getKeyword(), "^%#$#@#")
        str1 = "你好 cangjie"
        let payloadState_2: PayloadState<String> = PayloadState<String>(-6)
        let payload_2: Payload<String> = Payload(str1, str1)
        payloadState_2.addEmit(payload_2)
        payloadArrL = payloadState_2.emit()
        arr1 = payloadArrL.toArray()
        @Assert(arr1[0].getData().getOrThrow(), "你好 cangjie")
    }
}
