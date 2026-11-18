// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_Parser_parse(dp: DataProvider): Int32 {
    //  public static func parse(html: String, baseUri: String): Document
    try {
        Parser.parse(dp.consumeAsciiString(2), "")
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Parser_parse).startFuzz()

    return 0
}
