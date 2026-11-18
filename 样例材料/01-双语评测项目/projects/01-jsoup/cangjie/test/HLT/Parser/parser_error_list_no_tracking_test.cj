// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParseErrorListNoTrackingTest {
    @TestCase
    func parseErrorListNoTracking01(): Unit {
        let errors: ParseErrorList = ParseErrorList.noTracking()
        @Assert(0, errors.size)
    }
}
