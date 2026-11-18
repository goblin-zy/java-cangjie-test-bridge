// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
let payloadState_1: PayloadState<String> = PayloadState<String>(0)

func fuzz_PayloadState_nextState(dp: DataProvider): Int32 {
    // public func nextState(character: Rune): ?PayloadState<T>
    try {
        payloadState_1.nextState(dp.consumeChar())
    } catch (e: Exception) {
        returnFlag = -1
    }
    return returnFlag
}


main() {
    Fuzzer(fuzz_PayloadState_nextState).startFuzz()

    return 0
}
