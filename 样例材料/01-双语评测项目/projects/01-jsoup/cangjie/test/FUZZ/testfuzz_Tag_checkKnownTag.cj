// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_Tag_checkKnownTag(dp: DataProvider): Int32 {
    //  public static func checkKnownTag(tagName: String): Bool
    try {
        Tag.checkKnownTag(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Tag_checkKnownTag).startFuzz()

    return 0
}
