// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
import ahoCorasick4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0
let payloadState_1: PayloadState<String> = PayloadState<String>(0)

func fuzz_PayloadState_addState(dp: DataProvider): Int32 {
    // public func addState(character: Rune): PayloadState<T>
    try {
        payloadState_1.addState(dp.consumeChar())
    } catch (e: Exception) {
        returnFlag = -1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_PayloadState_addState).startFuzz()
    return 0
}
