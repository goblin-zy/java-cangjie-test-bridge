// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Trie_firstMatch(dp: DataProvider): Int32 {
    returnFlag = 0
   var trie = Trie.builder()
            .addKeyword("abcjhdasjg")
            .addKeyword("bcdcs")
            .addKeyword("cdefw")
            .build()
    // public func firstMatch(text: String): ?Emit
    try {
        trie.firstMatch(dp.consumeString(5)) 
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_Trie_firstMatch).startFuzz()

    return 0
}
