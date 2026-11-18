// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Element_check(dp: DataProvider): Int32 {
    let ele:Element = Element("Element")
    //  public func check(cssQuery: String): Bool
    try {
        ele.check(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_check).startFuzz()

    return 0
}
