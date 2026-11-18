// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let parser: Parser = Parser.htmlParser()

func fuzz_Parser_parseFragmentInput(dp: DataProvider): Int32 {
    //  public func parseFragmentInput(fragment: String, context: ?Element, baseUri: String): ArrayList<Node>
    try {
        parser.parseFragmentInput(dp.consumeString(2),None, "")
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parseFragmentInput).startFuzz()

    return 0
}
