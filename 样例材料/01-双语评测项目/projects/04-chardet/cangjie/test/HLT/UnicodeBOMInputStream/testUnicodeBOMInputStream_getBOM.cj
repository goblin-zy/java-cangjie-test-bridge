// 3rd_party_lib:chardet4cj/build/release/chardet4cj
// 3rd_party_lib:chardet4cj/build/release/charset
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/chardet4cj
// 3rd_party_lib_ohos:chardet4cj/build/release/aarch64-linux-ohos/charset

//dependence:../util_test/util_common.cj

import std.fs.*
import std.io.*
import chardet4cj.*

@Test
public class UnicodeBOMInputStreamTest {
    var enterStream: ByteBuffer = ByteBuffer()
    var returnFlag: Int64 = 0
    var res: Int64 = 0
    var resStr: String = ""
    var resData: Array<Byte> = Array<Byte>()

    @TestCase
    func testUnicodeBOMInputStream_getBOM_01(): Unit {
        var bufdata: Array<Byte> = "testUnicodeBOMInputStream_getBOM_01".toArray()
        enterStream.write(bufdata)
        let ins_1: UnicodeBOMInputStream = UnicodeBOMInputStream(enterStream)
        var bom: BOM = ins_1.getBOM()
        resStr = bom.toString() 
        @Assert(resStr, "NONE")
        @Assert(bufdata.size, 35)
        res = bom.getBytes().size 
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUnicodeBOMInputStream_getBOM_02(): Unit {
        returnFlag = 0
        let ins_1: UnicodeBOMInputStream = UnicodeBOMInputStream(enterStream) //缓冲区为空
        try {
            var bom: BOM = ins_1.getBOM()
            resStr = bom.toString() 
            @Assert(resStr, "NONE")
            res = bom.getBytes().size 
            @Assert(res, 0)
        } catch (e1: ChardetException) {
            returnFlag = 1
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testUnicodeBOMInputStream_getBOM_03(): Unit {
        var bufdata: Array<Byte> = "testUnicodeBOMInputStream_getBOM_03".toArray()
        enterStream.write(bufdata)
        let ins_1: UnicodeBOMInputStream = UnicodeBOMInputStream(enterStream, true)
        var bom: BOM = ins_1.getBOM()
        resStr = bom.toString() 
        @Assert(resStr, "NONE")
        @Assert(bufdata.size, 35)
        let ins_2: UnicodeBOMInputStream = UnicodeBOMInputStream(enterStream, false)
        res = ins_2.getBOM().getBytes().size 
        @Assert(res, 0)
    }
}
