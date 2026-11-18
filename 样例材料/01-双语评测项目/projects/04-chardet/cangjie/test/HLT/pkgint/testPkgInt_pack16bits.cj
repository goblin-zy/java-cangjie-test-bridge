// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset
import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class PkgIntTest {
    var returnFlag: Int64 = 0
    var res: Int32 = 0

    @TestCase
    func testPkgInt_pack16bits_01(): Unit {
        res = PkgInt.pack16bits(Int32(0), Int32(2)) 
        @Assert(res, 131072)

        try {
            res = PkgInt.pack16bits(Int32(0), Int32(0)) 
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(res, 0)

        try {
            res = PkgInt.pack16bits(Int32(-2), Int32(0)) 
        } catch (e2: ChardetException) {
            returnFlag = 2
        }
        @Assert(res, -2)

        try {
            res = PkgInt.pack16bits(Int32(25654), Int32(0)) 
        } catch (e3: ChardetException) {
            returnFlag = 3
        }
        @Assert(res, 25654)

        try {
            res = PkgInt.pack16bits(Int32(25654), Int32(-231)) 
        } catch (e4: ChardetException) {
            returnFlag = 4
        }
        @Assert(res, -15113162)
        @Assert(returnFlag, 0)
    }
}
