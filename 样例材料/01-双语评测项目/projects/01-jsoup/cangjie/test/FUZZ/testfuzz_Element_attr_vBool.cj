// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_attr_vBool(dp: DataProvider): Int32 {
    let ele:Element = Element("Element")
    //  public func attr(attributeKey: String, attributeValue: Bool): Element
    try {
        ele.attr(dp.consumeString(2),dp.consumeBool())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_attr_vBool).startFuzz()

    return 0
}
