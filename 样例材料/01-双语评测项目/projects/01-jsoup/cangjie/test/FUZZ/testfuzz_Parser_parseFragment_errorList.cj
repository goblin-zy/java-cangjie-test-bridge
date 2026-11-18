// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let errorList_1: ParseErrorList = ParseErrorList.noTracking()

func fuzz_Parser_parseFragment_errorList(dp: DataProvider): Int32 {
    //  public static func parseFragment(fragmentHtml: String, context: ?Element, baseUri: String, errorList: ParseErrorList): ArrayList<Node>
    try {
        Parser.parseFragment(dp.consumeString(2),None, "",errorList_1)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parseFragment_errorList).startFuzz()

    return 0
}
