// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ele:Element = Element("ElementInstance")

func fuzz_Element_getElementsContainingOwnText(dp: DataProvider): Int32 {
    //  public func getElementsContainingOwnText(searchText: String): Elements
    try {
        ele.getElementsContainingOwnText(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_getElementsContainingOwnText).startFuzz()

    return 0
}
