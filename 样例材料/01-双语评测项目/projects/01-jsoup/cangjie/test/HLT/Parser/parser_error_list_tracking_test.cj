// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.math.*

@Test
public class ParseErrorListTrackingTest {
    @TestCase
    func parseErrorListTracking01(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(-1)
        @Assert(0, errors.size)
    }

    @TestCase
    func parseErrorListTracking02(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(0)
        @Assert(0, errors.size)
    }

    @TestCase
    func parseErrorListTracking03(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(20)
        @Assert(0, errors.size)
    }

    @TestCase
    func parseErrorListTracking04(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(Int64.Max)
        @Assert(0, errors.size)
    }
}
