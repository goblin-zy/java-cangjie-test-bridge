// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
let settings_1:ParseSettings = ParseSettings.htmlDefault
func fuzz_ParseSettings_normalizeTag(dp: DataProvider): Int32 {
    //  public func normalizeTag(name:String): String
    try {
        settings_1.normalizeTag(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_ParseSettings_normalizeTag).startFuzz()

    return 0
}
