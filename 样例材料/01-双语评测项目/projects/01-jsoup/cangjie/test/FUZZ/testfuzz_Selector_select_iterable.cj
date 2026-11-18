// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import std.collection.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ins_1: Elements = Elements()
let it_1:Iterator<Element> = ins_1.iterator()

func fuzz_Selector_select_iterable(dp: DataProvider): Int32 {
    //  public static func select(query: String, roots: Iterable<Element>): Elements
    try {
        Selector.select(dp.consumeString(2),it_1)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Selector_select_iterable).startFuzz()

    return 0
}
