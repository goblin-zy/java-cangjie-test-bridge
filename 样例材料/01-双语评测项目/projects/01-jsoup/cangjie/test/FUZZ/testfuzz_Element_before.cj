// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_before(dp: DataProvider): Int32 {
    let ele:Element = Element("Element")
    //  public override func before(html: String): Element
    try {
        ele.before(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_before).startFuzz()

    return 0
}
