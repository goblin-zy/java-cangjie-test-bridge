// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import std.collection.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ins_1: Elements = Elements()
func fuzz_Elements_toggleClass(dp: DataProvider): Int32 {
    //  public func toggleClass(className: String): Elements
    try {
        ins_1.toggleClass(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Elements_toggleClass).startFuzz()

    return 0
}
