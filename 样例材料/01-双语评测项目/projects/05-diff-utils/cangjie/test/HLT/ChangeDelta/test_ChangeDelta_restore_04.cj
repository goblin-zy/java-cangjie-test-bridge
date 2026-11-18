// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChangeDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func restore(target: ArrayList<T>): Unit
        测试场景:revised.getPosition()<0
    ***/
    @TestCase
    func testChangeDeltaRestore03(): Unit {
        var original=Chunk(2,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(-1,[7,8,9,10,11,12])
        let changeDelta=ChangeDelta(original,revised)
        var target=ArrayList<Int64>([-7,-8,-9,-10,-11,-12,-13,-14,-14,-14,-14])
        var flag=1
        try{
            changeDelta.restore(target)
        }catch(e:DiffException){
            if(e.toString().contains("the position of chunk < 0")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}