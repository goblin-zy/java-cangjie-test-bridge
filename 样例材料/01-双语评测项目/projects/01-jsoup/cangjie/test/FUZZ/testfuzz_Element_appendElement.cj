// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_appendElement(dp: DataProvider): Int32 {
    let ele:Element = Element("Element")
    //  public func appendElement(tagName: String): Element
    try {
        ele.appendElement(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_appendElement).startFuzz()

    return 0
}
