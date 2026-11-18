// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Attributes_hasDeclaredValueForKey(dp: DataProvider): Int32 {
    let ins_1:Attributes = Attributes()
    ins_1.put("AttributeK","Attribute_V1")
    //  public func hasDeclaredValueForKey(key: String): Bool
    try {
        ins_1.hasDeclaredValueForKey(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_hasDeclaredValueForKey).startFuzz()

    return 0
}
