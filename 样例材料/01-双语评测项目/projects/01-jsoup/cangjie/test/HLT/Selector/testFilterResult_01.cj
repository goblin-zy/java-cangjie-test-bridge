// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    let filter_1: FilterResult = FilterResult.CONTINUE
    let filter_2: FilterResult = FilterResult.SKIP_CHILDREN
    let filter_3: FilterResult = FilterResult.SKIP_ENTIRELY
    let filter_4: FilterResult = FilterResult.REMOVE
    let filter_5: FilterResult = FilterResult.STOP
    var returnFlag: Int64 = -1

    @TestCase
    func testfilter_01(): Unit {
        let str1 = filter_1.toString()
        @Assert(str1, "CONTINUE")

        let str2 = filter_2.toString()
        @Assert(str2, "SKIP_CHILDREN")

        let str3 = filter_3.toString()
        @Assert(str3, "SKIP_ENTIRELY")

        let str4 = filter_4.toString()
        @Assert(str4, "REMOVE")

        let str5 = filter_5.toString()
        @Assert(str5, "STOP")
    }

    @TestCase
    func testfilter_02(): Unit {
        if (filter_1 != filter_1) {
            returnFlag = 0
        }
        @Assert(returnFlag, -1)

        if (filter_1 != filter_2) {
            returnFlag = 2
        }
        @Assert(returnFlag, 2)

        if (filter_1 != filter_3) {
            returnFlag = 3
        }
        @Assert(returnFlag, 3)

        if (filter_1 != filter_4) {
            returnFlag = 4
        }
        @Assert(returnFlag, 4)

        if (filter_1 != filter_5) {
            returnFlag = 5
        }
        @Assert(returnFlag, 5)
    }

    @TestCase
    func testfilter_03(): Unit {
        if (filter_1 == FilterResult.CONTINUE) {
            returnFlag = 1
        }
        @Assert(returnFlag, 1)

        if (filter_2 == FilterResult.SKIP_CHILDREN) {
            returnFlag = 2
        }
        @Assert(returnFlag, 2)

        if (filter_3 == FilterResult.SKIP_ENTIRELY) {
            returnFlag = 3
        }
        @Assert(returnFlag, 3)

        if (filter_4 == FilterResult.REMOVE) {
            returnFlag = 4
        }
        @Assert(returnFlag, 4)

        if (filter_5 == FilterResult.STOP) {
            returnFlag = 5
        }
        @Assert(returnFlag, 5)
    }
}
