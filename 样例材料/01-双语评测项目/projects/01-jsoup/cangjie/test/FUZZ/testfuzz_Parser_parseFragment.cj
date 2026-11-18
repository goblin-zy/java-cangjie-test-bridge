// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Parser_parseFragment(dp: DataProvider): Int32 {
    //  public static func parseFragment(fragmentHtml: String, context: ?Element, baseUri: String): ArrayList<Node>
    try {
        Parser.parseFragment(dp.consumeString(2),None, "")
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parseFragment).startFuzz()

    return 0
}
