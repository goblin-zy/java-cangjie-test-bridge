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
    func testPkgInt_pack8bits_01(): Unit {
        res = PkgInt.pack8bits(Int32(0), Int32(2), Int32(0), Int32(0)) 
        @Assert(res, 512)

        try {
            res = PkgInt.pack8bits(Int32(0), Int32(0), Int32(0), Int32(0))
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(res, 0)

        try {
            res = PkgInt.pack8bits(Int32(-2), Int32(0), Int32(25654), Int32(0)) 
        } catch (e2: ChardetException) {
            returnFlag = 2
        }
        @Assert(res, -2)

        try {
            res = PkgInt.pack8bits(Int32(25654), Int32(0), Int32(-2), Int32(-231)) 
        } catch (e3: ChardetException) {
            returnFlag = 3
        }
        @Assert(res, -105418)
        @Assert(returnFlag, 0)
    }
}
