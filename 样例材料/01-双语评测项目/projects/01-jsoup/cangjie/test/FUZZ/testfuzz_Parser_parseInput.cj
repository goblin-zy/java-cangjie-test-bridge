// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let parser: Parser = Parser.htmlParser()

func fuzz_Parser_parseInput(dp: DataProvider): Int32 {
    //  public func parseInput(html: String, baseUri: String): Document
    try {
        parser.parseInput(dp.consumeString(2), "")
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parseInput).startFuzz()

    return 0
}
