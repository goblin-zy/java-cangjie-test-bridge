// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_Attributes_add(dp: DataProvider): Int32 {
    let ins_1:Attributes = Attributes()
    //  public func add(key: String, value: ?String): Attributes
    var ss = "K"+dp.consumeString(1)
    try {
        ins_1.add(ss,None)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Attributes_add).startFuzz()

    return 0
}
