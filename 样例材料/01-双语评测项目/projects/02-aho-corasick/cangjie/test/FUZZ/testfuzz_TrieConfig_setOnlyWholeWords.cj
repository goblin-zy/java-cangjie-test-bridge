// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
let trieConfig_1: TrieConfig = TrieConfig()

func fuzz_TrieConfig_setOnlyWholeWords(dp: DataProvider): Int32 {
    returnFlag = 0
   // public func setOnlyWholeWords(onlyWholeWords: Bool): Unit
    try {
        trieConfig_1.setOnlyWholeWords(dp.consumeBool())
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}


main() {
    Fuzzer(fuzz_TrieConfig_setOnlyWholeWords).startFuzz()

    return 0
}
