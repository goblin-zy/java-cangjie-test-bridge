// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Trie_tokenize(dp: DataProvider): Int32 {
    returnFlag = 0
   var trie = Trie.builder().ignoreOverlaps().onlyWholeWords().ignoreCase()
            .addKeyword("greatquestion")
            .addKeyword("forty-two")
            .addKeyword("deepthought")
            .build()
    // public func tokenize(text: String): Collection<Token>
    try {
        trie.tokenize(dp.consumeString(100)) 
    } catch (e: Exception) {
        println("e:>> ${e.toString()}")
        returnFlag = -1
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_Trie_tokenize).startFuzz()

    return 0
}
