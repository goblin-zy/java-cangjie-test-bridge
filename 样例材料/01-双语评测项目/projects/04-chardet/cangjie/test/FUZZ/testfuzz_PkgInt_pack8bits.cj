// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset

import chardet4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_pack8bits(dp:DataProvider): Int32 {
   var dataArr:Array<Int32> = dp.consumeInt32s(4)
      // public static func pack8bits(a: Int32, b: Int32, c: Int32, d: Int32): Int32
        PkgInt.pack8bits(dataArr[0],dataArr[1],dataArr[2],dataArr[3])
     return returnFlag
   }


main() {
    Fuzzer(fuzz_pack8bits).startFuzz()

    return 0
}
