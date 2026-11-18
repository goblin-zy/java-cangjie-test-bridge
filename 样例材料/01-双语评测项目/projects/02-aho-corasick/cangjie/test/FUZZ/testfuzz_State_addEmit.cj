// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
let rootState = State(0)
func fuzz_State_addEmit(dp: DataProvider): Int32 {
    // public func addEmit(keyword: String): Unit
    try {
        rootState.addEmit(dp.consumeAsciiString(100))
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_State_addEmit).startFuzz()

    return 0
}
