// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import std.collection.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ins_1: Elements = Elements()
func fuzz_Elements_prevAll(dp: DataProvider): Int32 {
    //  public func prevAll(query: String): Elements
    try {
        ins_1.prevAll(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Elements_prevAll).startFuzz()

    return 0
}
