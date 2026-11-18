// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var int32Res: Int32 = -1
    var strRes: String = ""
    var boolRes: Bool = false
    var returnFlag: Int64 = -1

    @TestCase
    func testPayloadTrie_01(): Unit {
        let payloadTrieBuilder_1: PayloadTrieBuilder<String> = PayloadTrie<String>.builder()
        payloadTrieBuilder_1.addKeyword("helloq")
        payloadTrieBuilder_1.addKeyword("ello", Option<String>.None)
        payloadTrieBuilder_1.addKeyword("zzzolhh3Q", Option<String>.Some("JqK"))
        let payloadTrie1: PayloadTrie<String> = payloadTrieBuilder_1.build()
        let payloadEmitColl_1: Collection<PayloadEmit<String>> = payloadTrie1.parseText("helloqhh3Q")
        @Assert(payloadEmitColl_1.size,2)
        var it_1 = payloadEmitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"1:4=ello->0:5=helloq->")
        let emitHandler_1: PayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        payloadTrie1.parseText("helloqhh3Q", emitHandler_1)
        let emitHandler_2: StatefulPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        let payloadEmitColl_2: Collection<PayloadEmit<String>> = payloadTrie1.parseText("helloqhh3Q", emitHandler_2)
        @Assert(payloadEmitColl_2.size,2)
        var it_2 = payloadEmitColl_2.iterator()
        strRes = ""
        for (obj in it_2) {
            strRes += obj.toString()
        }
        @Assert(strRes,"1:4=ello->0:5=helloq->")
    }

    @TestCase
    func testPayloadTrie_02(): Unit {
        let payloadTrieBuilder_1: PayloadTrieBuilder<String> = PayloadTrieBuilder<String>()
        payloadTrieBuilder_1.addKeyword("")
        payloadTrieBuilder_1.addKeyword("  hello")
        payloadTrieBuilder_1.addKeyword("<&^$kill me please$>")
        payloadTrieBuilder_1.addKeyword("你好，【淦】", Option<String>.None)
        payloadTrieBuilder_1.addKeyword("你好，")
        payloadTrieBuilder_1.addKeyword("你好，走开")
        var str1 = """
                hello \nbye"""

        var str2 = ##"
                hello \nbye
              "##
        payloadTrieBuilder_1.addKeyword(str1)
        payloadTrieBuilder_1.addKeyword(str2)
        let payloadTrie1: PayloadTrie<String> = payloadTrieBuilder_1.build()
        let payloadEmitColl_1: Collection<PayloadEmit<String>> = payloadTrie1.parseText("  hello <&^$kill me please$>")
        @Assert(payloadEmitColl_1.size,2)
        strRes = ""
        var it_1 = payloadEmitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"0:6=  hello->8:27=<&^$kill me please$>->")
        strRes = ""
        var num: Int64 = 0
        var it_2 = payloadTrie1.parseText("你好，走开").iterator()
        for (obj in it_2) {
            strRes += obj.toString()
            num++
        }
        @Assert(num,2)
        @Assert(strRes,"0:8=你好，->0:14=你好，走开->")
        strRes = ""
        num = 0
        var it_3 = payloadTrie1.parseText("${str1}").iterator()
        for (obj in it_3) {
            strRes += obj.toString()
            num++
        }
        @Assert(num,2)
        @Assert(strRes.size,48)
        @Assert(strRes,"14:20=  hello->0:25=                hello \nbye->")
    }

    @TestCase
    func testPayloadTrie_03(): Unit {
        let payloadTrieBuilder_1: PayloadTrieBuilder<String> = PayloadTrieBuilder<String>()
        payloadTrieBuilder_1.addKeyword("00")
        payloadTrieBuilder_1.addKeyword("0012")
        payloadTrieBuilder_1.addKeyword("<&00&>")
        payloadTrieBuilder_1.addKeyword(",", Option<String>.None)
        payloadTrieBuilder_1.addKeyword(",,.")
        payloadTrieBuilder_1.addKeyword("..,00")
        let payloadTrie1: PayloadTrie<String> = payloadTrieBuilder_1.build()
        let payloadEmitColl_1: Collection<PayloadEmit<String>> = payloadTrie1.parseText(" <&0012&>",
            DefaultPayloadEmitHandler<String>())
        @Assert(payloadEmitColl_1.size,2)
        strRes = ""
        var it_1 = payloadEmitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"3:4=00->3:6=0012->")
        strRes = ""
        var num: Int64 = 0
        var it_2 = payloadTrie1.parseText("..,00").iterator()
        for (obj in it_2) {
            strRes += obj.toString()
            num++
        }
        @Assert(num,3)
        @Assert(strRes,"2:2=,->3:4=00->0:4=..,00->")
        strRes = ""
        num = 0
        var it_3 = payloadTrie1.parseText("<&00&>,,").iterator()
        for (obj in it_3) {
            strRes += obj.toString()
            num++
        }
        @Assert(num,4)
        @Assert(strRes,"2:3=00->0:5=<&00&>->6:6=,->7:7=,->")
    }

    @TestCase
    func testPayloadTrie_04(): Unit {
        let payloadTrieBuilder_1: PayloadTrieBuilder<String> = PayloadTrieBuilder<String>()
        payloadTrieBuilder_1.addKeyword("hello")
        payloadTrieBuilder_1.addKeyword("olloe")
        payloadTrieBuilder_1.addKeyword("elle")
        payloadTrieBuilder_1.addKeyword("llohe", Option<String>.None)
        let payloadTrie1: PayloadTrie<String> = payloadTrieBuilder_1.build() 
        let payloadEmitColl_1: Collection<PayloadEmit<String>> = payloadTrie1.parseText("helloelles",
            DefaultPayloadEmitHandler<String>())
        @Assert(payloadEmitColl_1.size,2)
        strRes = ""
        var it_1 = payloadEmitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"0:4=hello->5:8=elle->")
        strRes = ""
        var num: Int64 = 0
        var it_2 = payloadTrie1.parseText("lloheelle").iterator()
        for (obj in it_2) {
            strRes += obj.toString()
            num++
        }
        @Assert(num,2)
        @Assert(strRes,"0:4=llohe->5:8=elle->")
    }
}
