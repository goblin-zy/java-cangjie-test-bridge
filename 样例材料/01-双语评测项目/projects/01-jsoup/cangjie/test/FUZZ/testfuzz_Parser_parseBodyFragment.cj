// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Parser_parseBodyFragment(dp: DataProvider): Int32 {
    //  public static func parseBodyFragment(bodyHtml: String, baseUri: String): Document
    try {
        Parser.parseBodyFragment(dp.consumeString(2), "")
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parseBodyFragment).startFuzz()

    return 0
}
