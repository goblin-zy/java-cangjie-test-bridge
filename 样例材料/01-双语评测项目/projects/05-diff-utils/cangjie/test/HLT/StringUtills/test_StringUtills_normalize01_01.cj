// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func normalize(str: String): String
        测试场景:str包含<,>,&lt,&gt,《,》
    ***/
    @TestCase
    func testStringUtillsNormalize0101(): Unit {
        let str01="a\tb《c<d>d》ddf&ltds>d&gtf\tsd<f"
        let exp_re="a    b《c&lt;d&gt;d》ddf&ltds&gt;d&gtf    sd&lt;f"
        let re_normalize=StringUtills.normalize(str01)
        @Assert(re_normalize,exp_re)
    }
}