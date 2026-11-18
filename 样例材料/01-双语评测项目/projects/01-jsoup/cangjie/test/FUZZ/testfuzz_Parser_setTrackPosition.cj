// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let parser: Parser = Parser.htmlParser()
func fuzz_Parser_setTrackPosition(dp: DataProvider): Int32 {
    //  public func setTrackPosition(trackPosition: Bool): Parser
    try {
        parser.setTrackPosition(dp.consumeBool())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_setTrackPosition).startFuzz()

    return 0
}
