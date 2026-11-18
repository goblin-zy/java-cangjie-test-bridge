// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var strRes: String = ""
    var intRes: Int64 = -1
    var returnFlag: Int64 = -1

    @TestCase
    func testEmit_01(): Unit {
        let emit_1: Emit = Emit(0, 0, "hello")
        strRes = emit_1.getKeyword()
        @Assert(strRes, "hello")
        intRes = emit_1.hashCode()
        @Assert(intRes, -5973392143591194711)
        strRes = emit_1.toString()
        @Assert(strRes, "0:0=hello")
        let emit_2: Emit = Emit(-2, -1, "hello")
        strRes = emit_2.getKeyword()
        @Assert(strRes, "hello")
        intRes = emit_2.hashCode()
        @Assert(intRes, -5973392143591194711)
        @Assert(emit_2.hashCode() == emit_1.hashCode(), true)
        strRes = emit_2.toString()
        @Assert(strRes, "-2:-1=hello")
    }

    @TestCase
    func testEmit_02(): Unit {
        var str1: String = ""
        let emit_1: Emit = Emit(0, 0, str1)
        strRes = emit_1.getKeyword()
        @Assert(strRes, "")
        intRes = emit_1.hashCode()
        @Assert(intRes, 2302960717771869484)
        strRes = emit_1.toString()
        @Assert(strRes, "0:0=")
        str1 = """
            cangjie
            test
          """
        let emit_2: Emit = Emit(-2, 0, str1)
        strRes = emit_2.getKeyword()
        @Assert(strRes.replace("\n","").replace(" ",""), "cangjietest")
        let emit_3: Emit = Emit(-2, 0, str1)
        intRes = emit_3.hashCode()
        @Assert(emit_3.hashCode() == emit_2.hashCode(), true)
        @Assert(emit_3 == emit_2, true)
        strRes = emit_3.toString()
        @Assert(strRes.replace("\n","").replace(" ",""), "-2:0=cangjietest")
    }

    @TestCase
    func testEmit_03(): Unit {
        var str1: String = "^%#$#@#"
        let emit_1: Emit = Emit(0, 0, str1)
        strRes = emit_1.getKeyword()
        @Assert(strRes, "^%#$#@#")
        intRes = emit_1.hashCode()
        @Assert(intRes, 4227979451565640154)
        strRes = emit_1.toString()
        @Assert(strRes, "0:0=^%#$#@#")
        str1 = "\"\f\\\""
        let emit_2: Emit = Emit(1, 9, str1)
        strRes = emit_2.getKeyword()
        @Assert(strRes.replace("\f","").replace(" ",""), "\"\\\"")
        str1 = "中文关键字"
        let emit_3: Emit = Emit(-2, 0, str1)
        @Assert(emit_3 == emit_2, false)
        strRes = emit_3.toString()
        @Assert(strRes.replace("\n","").replace(" ",""), "-2:0=中文关键字")
    }

    @TestCase
    func testEmit_04(): Unit {
        returnFlag = -1
        var str1: String = "^%#$#@#"
        try {
            let emit_1: Emit = Emit(6, 1, str1)
            strRes = emit_1.getKeyword()
        } catch (e1: IllegalArgumentException) {
            @Assert(e1.toString().contains("The start length must be smaller than the end length"),true)
            returnFlag = 0
        }

        try {
            let emit_2: Emit = Emit(-6, -1, "-6==>-1")
            strRes = emit_2.getKeyword()
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(strRes, "-6==>-1")

        try {
            let emit_3: Emit = Emit(-1, -6, str1)
            strRes = emit_3.getKeyword()
        } catch (e1: IllegalArgumentException) {
            @Assert(e1.toString().contains("The start length must be smaller than the end length"),true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
