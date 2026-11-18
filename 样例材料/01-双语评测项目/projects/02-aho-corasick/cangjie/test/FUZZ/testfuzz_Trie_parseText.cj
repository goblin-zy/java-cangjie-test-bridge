// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Trie_parseText(dp: DataProvider): Int32 {
    returnFlag = 0
   let trieBuilder_1: TrieBuilder = Trie.builder()
    trieBuilder_1.addKeyword("helloq")
    trieBuilder_1.addKeyword("ello")
    trieBuilder_1.addKeyword("zzzolhh3Q")
    let trie1: Trie = trieBuilder_1.build()
    // public func parseText(text: String): Collection<Emit>
    try {
        trie1.parseText(dp.consumeString(10)) 
    } catch (e: Exception) {
        println("e:>> ${e.toString()}")
        returnFlag = -1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Trie_parseText).startFuzz()

    return 0
}
