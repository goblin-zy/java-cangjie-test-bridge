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
    func testPkgInt_unpack_01(): Unit {
        var arr1: Array<Int32> = [12, 23, -12, 598, 127, -1, 0, 12454684]
        let pkgInt_ins1: PkgInt = PkgInt(1, 2, 3, -1, arr1)
        res = pkgInt_ins1.unpack(0) 
        @Assert(res, 12)
        res = pkgInt_ins1.unpack(5) 
        @Assert(res, -12)

        try {
            res = pkgInt_ins1.unpack(12) 
        } catch (e1: IndexOutOfBoundsException) {
            returnFlag = 1
        }
        @Assert(res, 0)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testPkgInt_unpack_02(): Unit {
        returnFlag = -1
        var arr1: Array<Int32> = [12, 23, -12, 598, 127, -1, 0, 12454684]
        let pkgInt_ins1: PkgInt = PkgInt(0, 2, 3, -1, arr1)
        res = pkgInt_ins1.unpack(0) 
        @Assert(res, 12)
        res = pkgInt_ins1.unpack(5)
        @Assert(res, -1)

        try {
            res = pkgInt_ins1.unpack(12) // 索引越界，java：ArrayIndexOutOfBoundsException: Index 12 out of bounds for length 8
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testPkgInt_unpack_03(): Unit {
        returnFlag = -1
        var arr1: Array<Int32> = [12, 23, -12, 598, 127, -1, 0, 12454684]
        let pkgInt_ins1: PkgInt = PkgInt(0, 2, 0, -1, arr1)
        res = pkgInt_ins1.unpack(0) 
        @Assert(res, 12)
        res = pkgInt_ins1.unpack(7) 
        @Assert(res, 3113671)

        try {
            res = pkgInt_ins1.unpack(12) // 索引越界，java：ArrayIndexOutOfBoundsException: Index 12 out of bounds for length 8
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }
}
