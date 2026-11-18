// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let settings_1:ParseSettings = ParseSettings(true, false)
func fuzz_ParseSettings_normalizeAttribute(dp: DataProvider): Int32 {
    //  public func normalizeAttribute(name:String): String
    try {
        settings_1.normalizeAttribute(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_ParseSettings_normalizeAttribute).startFuzz()

    return 0
}
