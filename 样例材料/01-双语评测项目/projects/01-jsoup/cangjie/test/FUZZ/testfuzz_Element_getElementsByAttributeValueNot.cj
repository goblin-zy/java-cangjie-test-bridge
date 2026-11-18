// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ele:Element = Element("ElementInstance")

func fuzz_Element_getElementsByAttributeValueNot(dp: DataProvider): Int32 {
    //  public func getElementsByAttributeValueNot(key: String, value: String): Elements
    try {
        ele.getElementsByAttributeValueNot(dp.consumeString(2),dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_getElementsByAttributeValueNot).startFuzz()

    return 0
}
