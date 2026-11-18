// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let parser: Parser = Parser.htmlParser()
func fuzz_Parser_setTrackErrors(dp: DataProvider): Int32 {
    //  public func setTrackErrors(maxErrors: Int64): Parser
    try {
        parser.setTrackErrors(dp.consumeInt64())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_setTrackErrors).startFuzz()

    return 0
}
