// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

main(): Int64 {
    let bugfixTest = BugfixTest02()
    bugfixTest.testCharSearch()
    return 0
}

@Test
public class BugfixTest02 {

    @TestCase
    public func testCharSearch(): Unit {
        let payloadTrieBuilder_1: PayloadTrieBuilder<String> = PayloadTrieBuilder<String>()
        payloadTrieBuilder_1.addKeyword("hello")
        payloadTrieBuilder_1.addKeyword("olloe")
        payloadTrieBuilder_1.addKeyword("elle")
        payloadTrieBuilder_1.addKeyword("llohe",Option.None)
        let payloadTrie1:PayloadTrie<String> = payloadTrieBuilder_1.build()
        let payloadEmitColl_1:Collection<PayloadEmit<String>> = payloadTrie1.parseText("helloelles",DefaultPayloadEmitHandler<String>())
        @Assert(payloadEmitColl_1.size,2)
        var strRes = ""
        var it_1 = payloadEmitColl_1.iterator()
        for (obj in it_1) {
            strRes +=  obj.toString()
        }
        println("strRes_1:> ${strRes}")
        @Assert(strRes,"0:4=hello->5:8=elle->")
        strRes = ""
        var num:Int64 = 0
        var it_2 = payloadTrie1.parseText("lloheelle").iterator()
        for (obj in it_2) {
            strRes +=  obj.toString()
            num++
        }
        @Assert(num,2)
        println("strRes_2:> ${strRes}")
        @Assert(strRes,"0:4=llohe->5:8=elle->")
    }

}
