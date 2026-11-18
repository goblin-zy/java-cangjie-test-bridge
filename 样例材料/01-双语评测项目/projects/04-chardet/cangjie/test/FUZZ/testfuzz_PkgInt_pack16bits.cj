// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset

import chardet4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_pack16bits(dp:DataProvider): Int32 {
   var dataArr:Array<Int32> = dp.consumeInt32s(2)
      // public static func pack16bits(a: Int32, b: Int32): Int32
        PkgInt.pack16bits(dataArr[0],dataArr[1])
     return returnFlag
   }


main() {
    Fuzzer(fuzz_pack16bits).startFuzz()

    return 0
}
