// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj

import ahoCorasick4cj.*
import std.time.*
import std.math.*
import std.collection.*

main() {
    println("TCS: ahoCorasick4cj, time elapsed: 1 ns, RESULT:")
    let threadCount = 500
    let loopCount = 100000
    let trieBuilder_1: TrieBuilder = Trie.builder()
    trieBuilder_1.addKeyword("helloq")
    trieBuilder_1.addKeyword("ello")
    trieBuilder_1.addKeyword("zzzolhh3Q")
    trieBuilder_1.addKeyword("hehhq3Q")
    let trie1:Trie = trieBuilder_1.build()
    
    let futures = ArrayList<Future<ArrayList<String>>>()
    let start = DateTime.now()
    for (_ in 0..threadCount) {
        let thread = spawn {
            var result=ArrayList<String>()
                for (_ in 0..loopCount) {
                    try {
                        let emitColl_1:Collection<Emit> = trie1.parseText("helloqhh3Q")
                        if(emitColl_1.size == 2){
                            result.add("success")
                        }else{
                            result.add("fail")
                        }
                    } catch (e: Exception) {
                        println("e> ${e.toString()}")
                        result.add("fail")
                        continue
                    }
                }
                return result
        }
        futures.add(thread)
    }

    for (f in futures) {
        f.get()
    }

    let end = Duration.since(start).toSeconds()
    var count_fail=0
    for (f in futures){
        var temp_re=f.get()
        for (j in temp_re){
            if(j=="fail"){ 
                count_fail+=1
            }
        }
    }
    println("TestSuiteAhoCorasick4cj_${threadCount}*${loopCount}: TotalTime:${end} s  TPS: ${Int64((threadCount*loopCount)/end)}  FailRate: ${count_fail/(threadCount*loopCount)*100} %")

    return 0
}
