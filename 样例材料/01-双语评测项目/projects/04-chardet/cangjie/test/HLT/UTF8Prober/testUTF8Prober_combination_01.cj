// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UTF8ProberTest {
    var charsetp: UTF8Prober = UTF8Prober()
    var res: Int64 = 0
    @TestCase
    func testUTF8Prober_combination_01(): Unit {
        var bufdata: Array<Byte> = "testCharsetProber_filterWithEnglishLetters_01".toArray()
        var bytebuf_1: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata, 0, Int32(bufdata.size - 10))
        let str: String = bytebuf_1.toString()
        @Assert(str, "ChardetByteBuffer: [offset=0 mark=-1 pos=0 lim=35 cap=35]")
        var strRes: String = charsetp.getCharSetName()
        @Assert(strRes, "UTF-8")
        var state: ProbingState = charsetp.getState() 
        @Assert(state.toString(), "DETECTING")
        var confidence: Float32 = charsetp.getConfidence() 
        @Assert(confidence.toString(), "0.010000")
        charsetp.reset()
        state = charsetp.getState() 
        @Assert(state.toString(), "DETECTING")
    }
}
