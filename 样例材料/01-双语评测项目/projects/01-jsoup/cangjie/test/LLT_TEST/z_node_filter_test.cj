package cangjie_tpc::html4cj

@Test
public class FilterResultTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var filterResult1: FilterResult = FilterResult.CONTINUE
        var filterResult2: FilterResult = FilterResult.SKIP_CHILDREN
        var filterResult3: FilterResult = FilterResult.SKIP_ENTIRELY
        var filterResult4: FilterResult = FilterResult.REMOVE
        var filterResult5: FilterResult = FilterResult.STOP
        @Assert("CONTINUE", filterResult1.toString())
        @Assert("SKIP_CHILDREN", filterResult2.toString())
        @Assert("SKIP_ENTIRELY", filterResult3.toString())
        @Assert("REMOVE", filterResult4.toString())
        @Assert("STOP", filterResult5.toString())
        @Assert(true, filterResult1 != filterResult2)
        @Assert(true, filterResult1 != filterResult3)
        @Assert(true, filterResult1 != filterResult4)
        @Assert(true, filterResult1 != filterResult5)
        @Assert(false, filterResult1 == filterResult5)

        println("Pass1")
    }
}
