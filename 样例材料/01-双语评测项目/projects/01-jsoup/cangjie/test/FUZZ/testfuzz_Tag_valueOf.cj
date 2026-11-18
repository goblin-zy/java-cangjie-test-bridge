// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0
func fuzz_Tag_valueOf(dp: DataProvider): Int32 {
    //  public static func valueOf(tagName: String): Tag
    try {
        Tag.valueOf(dp.consumeString(2))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Tag_valueOf).startFuzz()

    return 0
}
