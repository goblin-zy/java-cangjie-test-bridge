// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeltaTypeB001{
    /***
        CHANGE|DELETE|INSERT
        测试场景:
    ***/
    @TestCase
    func testDeltaType01(): Unit {
        var delta01=DeltaType.CHANGE
        var delta02=DeltaType.DELETE
        var delta03=DeltaType.INSERT
        var flag=0
        match(delta01){
            case DeltaType.CHANGE =>flag=1
            case _ =>flag=-1
        }
        @Assert(flag,1)
        match(delta02){
            case DeltaType.DELETE =>flag=2
            case _ =>flag=-2
        }
        @Assert(flag,2)
        match(delta03){
            case DeltaType.INSERT =>flag=3
            case _ =>flag=-3
        }
        @Assert(flag,3)
    }
}