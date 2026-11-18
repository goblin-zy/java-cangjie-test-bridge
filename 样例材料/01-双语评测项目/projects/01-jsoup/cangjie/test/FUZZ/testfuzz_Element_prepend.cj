// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_prepend(dp: DataProvider): Int32 {
let ele:Element = Element("Eles")
    //  public func prepend(html: String): Element
    try {
        ele.prepend(dp.consumeString(1))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_prepend).startFuzz()

    return 0
}
