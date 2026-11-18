// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Trie_addKeyword(dp: DataProvider): Int32 {
    returnFlag = 0
   let trieBuilder_1: TrieBuilder = Trie.builder()
    // public func addKeyword(keyword: String): TrieBuilder
    try {
        trieBuilder_1.addKeyword(dp.consumeString(1000))
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_Trie_addKeyword).startFuzz()

    return 0
}
