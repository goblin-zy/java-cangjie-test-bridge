// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_Attributes_internalKey(dp: DataProvider): Int32 {
    //  public static func internalKey(key: String): String
    try {
        Attributes.internalKey(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_internalKey).startFuzz()

    return 0
}
