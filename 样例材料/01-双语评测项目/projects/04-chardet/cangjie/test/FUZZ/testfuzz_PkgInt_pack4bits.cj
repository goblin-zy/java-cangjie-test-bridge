// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset

import chardet4cj.*
import fuzz.fuzz.*

var returnFlag: Int32 = 0

func fuzz_pack4bits(dp:DataProvider): Int32 {
   var dataArr:Array<Int32> = dp.consumeInt32s(8)
      // public static func pack4bits(a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32, g: Int32, h: Int32): Int32
        PkgInt.pack4bits(dataArr[0],dataArr[1],dataArr[2],dataArr[3],dataArr[4],dataArr[5],dataArr[6],dataArr[7])
     return returnFlag
   }


main() {
    Fuzzer(fuzz_pack4bits).startFuzz()

    return 0
}
