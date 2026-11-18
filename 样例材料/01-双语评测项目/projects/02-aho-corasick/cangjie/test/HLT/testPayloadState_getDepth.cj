// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testPayloadState_getDepth_01(): Unit {
        let payloadState_1: PayloadState<String> = PayloadState<String>(0)
        let payloadState_2: PayloadState<String> = PayloadState<String>(1)
        @Assert(payloadState_1.getDepth(), 0)
        @Assert(payloadState_2.getDepth(), 1)
    }
}
