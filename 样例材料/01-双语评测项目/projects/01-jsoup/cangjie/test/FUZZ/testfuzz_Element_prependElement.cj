// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_prependElement(dp: DataProvider): Int32 {
    let ele:Element = Element("Eles")
    //  public func prependElement(tagName: String): Element
    try {
        ele.prependElement(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_prependElement).startFuzz()

    return 0
}
