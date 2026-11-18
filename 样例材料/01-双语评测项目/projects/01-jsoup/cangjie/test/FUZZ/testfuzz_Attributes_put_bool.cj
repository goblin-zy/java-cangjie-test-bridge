// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Attributes_put_bool(dp: DataProvider): Int32 {
    let ins_1:Attributes = Attributes()
    //  public func put(key: String, value: Bool): Attributes
    try {
        ins_1.put(dp.consumeString(2),dp.consumeBool())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_put_bool).startFuzz()

    return 0
}
