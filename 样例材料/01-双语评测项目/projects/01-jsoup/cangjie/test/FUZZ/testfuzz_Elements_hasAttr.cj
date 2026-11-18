// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import std.collection.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ins_1: Elements = Elements()
func fuzz_Elements_hasAttr(dp: DataProvider): Int32 {
    //  public func hasAttr(attributeKey: String): Bool
    try {
        ins_1.hasAttr(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Elements_hasAttr).startFuzz()

    return 0
}
