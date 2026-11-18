// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*

public func fuzzFunc_DiffNode_Init(dp:DataProvider):Int32 {
    try{
        DiffNode(dp.consumeInt64(),dp.consumeInt64(),Option<PathNode>.None)
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_DiffNode_Init).startFuzz()
}