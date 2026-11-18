// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestInsertDeltaB001{
    /***
        public init(original: Chunk<T>, revised: Chunk<T>)
        public func getType(): DeltaType
        测试场景:获取类型准确
    ***/
    @TestCase
    func testInsertDeltaGetType01(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var chunk02=Chunk(123,[1,2,3,4,5,6])
        let insertDelta=InsertDelta(chunk01,chunk02)
        var flag=1
        match(insertDelta.getType()){
            case DeltaType.INSERT => flag=0
            case _ => flag=-1
        }
        @Assert(flag,0)
    }
}