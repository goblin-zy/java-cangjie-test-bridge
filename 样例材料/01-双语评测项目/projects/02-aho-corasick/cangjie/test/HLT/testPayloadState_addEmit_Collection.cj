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
    func testPayloadState_addEmit_Collection_01(): Unit {
        var str1: String = "^%#$#@#"
        let payload_1: Payload<String> = Payload(str1, Option<String>.None)
        let payloadState_1: PayloadState<String> = PayloadState<String>(0)
        @Assert(payloadState_1.emit().size, 0)
        payloadState_1.addEmit(ArrayList<Payload<String>>())
        var payloadArrL: Collection<Payload<String>> = payloadState_1.emit()
        @Assert(payloadArrL.size, 0)
        let payload_2: Payload<String> = Payload("str1", "Option<String>.Some")
        let payloadArr: ArrayList<Payload<String>> = ArrayList<Payload<String>>([payload_1, payload_2])
        payloadState_1.addEmit(payloadArr)
        @Assert(payloadState_1.emit().size, 2)
        str1 = "你好 cangjie"
        let payloadState_2: PayloadState<String> = PayloadState<String>(-6)
        let payload_3: Payload<String> = Payload(str1, str1)
        let payloadSet: ArrayList<Payload<String>> = ArrayList<Payload<String>>([payload_3, payload_1])
        payloadState_2.addEmit(payloadSet)
        let payloadRes = payloadState_2.emit()
        @Assert(payloadRes.size, 2)
        @Assert(payloadRes.toArray()[0].getData().getOrThrow(), "你好 cangjie")
    }

    @TestCase
    func testPayloadState_addEmit_Collection_02(): Unit {
        let payloadState_1: PayloadState<String> = PayloadState<String>(0)
        @Assert(payloadState_1.emit().size, 0)
        let payloadArrL: ArrayList<Payload<String>> = ArrayList<Payload<String>>()
        for (i in 0..200) {
            payloadArrL.add(Payload("Payload_key_${i}", "Payload_data_${i}"))
        }
        payloadState_1.addEmit(payloadArrL)
        var payloadArrL2: Collection<Payload<String>> = payloadState_1.emit()
        @Assert(payloadArrL2.size, 200)
        @Assert(payloadArrL2.toArray()[199].getData().getOrThrow(), "Payload_data_199")
    }
}
