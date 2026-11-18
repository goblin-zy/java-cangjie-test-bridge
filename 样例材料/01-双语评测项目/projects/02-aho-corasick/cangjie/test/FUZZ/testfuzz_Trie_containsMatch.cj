// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_Trie_containsMatch(dp: DataProvider): Int32 {
    var trie = Trie.builder().ignoreOverlaps().addKeyword("abfg").addKeyword("cbgfka").addKeyword("abatrwaaabc").build()
    // public func containsMatch(text: String): Bool
    try {
        trie.containsMatch(dp.consumeString(5))
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_Trie_containsMatch).startFuzz()

    return 0
}
