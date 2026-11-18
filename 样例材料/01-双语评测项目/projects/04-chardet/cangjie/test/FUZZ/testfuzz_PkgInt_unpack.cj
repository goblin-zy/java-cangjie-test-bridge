// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset
import chardet4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_unpack(dp: DataProvider): Int32 {
    var dataArr: Array<Int32> = dp.consumeInt32s(100)
    let pkgInt_ins1: PkgInt = PkgInt(0, 2, 0, -1, dataArr)
    var num: Int32 = dp.consumeInt32()
    // public func unpack(i: Int32): Int32
    if (num < 0 || num >= Int32(dataArr.size)) {
        returnFlag = -1
    } else {
        pkgInt_ins1.unpack(num)
    }

    return returnFlag
}

main() {
    Fuzzer(fuzz_unpack).startFuzz()

    return 0
}
