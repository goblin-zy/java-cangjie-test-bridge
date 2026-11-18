// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_ParserErrorList_tracking(dp: DataProvider): Int32 {
    //  public static func tracking(maxSize: Int64): ParseErrorList
    try {
        ParseErrorList.tracking(dp.consumeInt64())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_ParserErrorList_tracking).startFuzz()

    return 0
}
