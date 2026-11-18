// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Attributes_removeData(dp: DataProvider): Int32 {
    let ins_1:Attributes = Attributes()
    ins_1.put("data-HSAag","<cangjie>")
    //  public func removeData(key: String): Unit
    try {
        ins_1.removeData(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_removeData).startFuzz()

    return 0
}
