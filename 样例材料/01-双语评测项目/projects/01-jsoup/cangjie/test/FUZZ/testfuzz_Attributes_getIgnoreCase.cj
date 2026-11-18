// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Attributes_getIgnoreCase(dp: DataProvider): Int32 {
    let ins_1:Attributes = Attributes()
    ins_1.put("你好HS","<cangjie>")
    //  public func getIgnoreCase(key: String): String
    try {
        ins_1.getIgnoreCase(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_getIgnoreCase).startFuzz()

    return 0
}
