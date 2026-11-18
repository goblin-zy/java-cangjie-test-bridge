// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
let rootState = State(0)

func fuzz_State_addState(dp: DataProvider): Int32 {
    // public func addState(keyword: String): State
    try {
        rootState.addState(dp.consumeAsciiString(10))
    } catch (e: Exception) {
        returnFlag = -1
    }

    return returnFlag
}

main() {
        Fuzzer(fuzz_State_addState).startFuzz()

    return 0
}
