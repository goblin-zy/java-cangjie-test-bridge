// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ele:Element = Element("ElementInstance")
func fuzz_Selector_selectFirst(dp: DataProvider): Int32 {
    //  public static func selectFirst(cssQuery: String, root: Element): ?Element
    try {
        Selector.selectFirst(dp.consumeString(2),ele)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Selector_selectFirst).startFuzz()

    return 0
}
