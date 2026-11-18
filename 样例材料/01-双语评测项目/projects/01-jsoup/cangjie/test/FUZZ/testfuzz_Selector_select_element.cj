// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

let ele:Element = Element("ElementInstance")
func fuzz_Selector_select_element(dp: DataProvider): Int32 {
    //  public static func select(query: String, root: Element): Elements
    try {
        Selector.select(dp.consumeString(2),ele)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Selector_select_element).startFuzz()

    return 0
}
