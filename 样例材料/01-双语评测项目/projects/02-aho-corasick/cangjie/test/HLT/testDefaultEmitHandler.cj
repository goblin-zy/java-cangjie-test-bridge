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
    func testDefaultEmitHandler_01(): Unit {
        var defaultEmitHandler_1: DefaultEmitHandler = DefaultEmitHandler()
        var emit_1: Emit = Emit(0, 0, "CangjieTest")
        boolRes = defaultEmitHandler_1.emit(emit_1)
        @Assert(boolRes, true)
        var arrL = defaultEmitHandler_1.getEmits() // ArrayList<Emit<String>>
        @Assert(arrL.size, 1)
    }

    @TestCase
    func testDefaultPayloadEmitHandler_02(): Unit {
        var defaultEmitHandler_1: DefaultEmitHandler = DefaultEmitHandler()
        var emit_1: Emit = Emit(0, 0, "CangjieTest")
        boolRes = defaultEmitHandler_1.emit(emit_1)
        @Assert(boolRes, true)
        var EmitArrL = defaultEmitHandler_1.getEmits()
        @Assert(EmitArrL.size, 1)
        strRes = EmitArrL[0].toString()
        @Assert(strRes, "0:0=CangjieTest")
    }

    @TestCase
    func testDefaultPayloadEmitHandler_03(): Unit {
        returnFlag = -1
        var strings = ""
        var defaultEmitHandler_1: DefaultEmitHandler = DefaultEmitHandler()
        try {
            var emit_2: Emit = Emit(2, 0, "CangjieTest")
            boolRes = defaultEmitHandler_1.emit(emit_2)
        } catch (e1: IllegalArgumentException) {
            strings = e1.message
            returnFlag = 0
        }
        @Assert(strings.contains("The start length must be smaller than the end length"), true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testDefaultEmitHandler_04(): Unit {
        var defaultEmitHandler_1: DefaultEmitHandler = DefaultEmitHandler()
        var emit_1: Emit = Emit(-8, 1, "CangjieTest")
        boolRes = defaultEmitHandler_1.emit(emit_1)
        @Assert(boolRes, true)
        var arrL = defaultEmitHandler_1.getEmits() 
        @Assert(arrL.size, 1)
    }
}
