// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var returnFlag: Int64 = -1

    @TestCase
    func testTrieConfig_01(): Unit {
        let trieConfig_1: TrieConfig = TrieConfig()
        boolRes = trieConfig_1.isStopOnHit()
        @Assert(boolRes,false)
        trieConfig_1.setStopOnHit(true)
        boolRes = trieConfig_1.isStopOnHit()
        @Assert(boolRes,true)

        boolRes = trieConfig_1.isAllowOverlaps()
        @Assert(boolRes,true)
        trieConfig_1.setAllowOverlaps(false)
        boolRes = trieConfig_1.isAllowOverlaps()
        @Assert(boolRes,false)

        boolRes = trieConfig_1.isOnlyWholeWords()
        @Assert(boolRes,false)
        trieConfig_1.setOnlyWholeWords(true)
        boolRes = trieConfig_1.isOnlyWholeWords()
        @Assert(boolRes,true)
    }

    @TestCase
    func testTrieConfig_02(): Unit {
        let trieConfig_1: TrieConfig = TrieConfig()
        boolRes = trieConfig_1.isOnlyWholeWordsWhiteSpaceSeparated()
        @Assert(boolRes,false)
        trieConfig_1.setOnlyWholeWordsWhiteSpaceSeparated(true)
        boolRes = trieConfig_1.isOnlyWholeWordsWhiteSpaceSeparated()
        @Assert(boolRes,true)

        boolRes = trieConfig_1.isCaseInsensitive()
        @Assert(boolRes,false)
        trieConfig_1.setCaseInsensitive(true)
        boolRes = trieConfig_1.isCaseInsensitive()
        @Assert(boolRes,true)
    }
}
