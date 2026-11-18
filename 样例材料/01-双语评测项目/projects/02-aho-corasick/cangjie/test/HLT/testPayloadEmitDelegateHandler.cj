// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testPayloadEmitDelegateHandler_00(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        let t1 = ped.emit(PayloadEmit<String>(0, 11, "c", None))
        @Assert(t1, true)
    }

    @TestCase
    func testPayloadEmitDelegateHandler_01(): Unit {
        var ped1: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(EmitPayloadEmitDelegateHandler())
        let t0 = ped1.emit(PayloadEmit<String>(0, 11, "c", None))
        @Assert(t0, false)
    }
}

public class EmitPayloadEmitDelegateHandler <: EmitHandler {
    private var emits: ArrayList<Emit> = ArrayList<Emit>()

    public override func emit(emit: Emit): Bool {
        emits.add(emit)
        return false
    }

    public func getEmits(): ArrayList<Emit> {
        return this.emits
    }
}
