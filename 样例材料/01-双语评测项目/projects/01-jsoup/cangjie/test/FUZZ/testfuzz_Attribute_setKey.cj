// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let ins_1:Attribute = Attribute("AttributeK1","Attribute_V1")

func fuzz_Attribute_setKey(dp: DataProvider): Int32 {
    //  public func setKey(key: String): Unit
    try {
        ins_1.setKey(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attribute_setKey).startFuzz()

    return 0
}
