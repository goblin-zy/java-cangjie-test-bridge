// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*

public func fuzzFunc_DiffRowGenerator_wrapInTag01(dp:DataProvider):Int32 {
    try{
        DiffRowGenerator.wrapInTag(ArrayList<String>(["123","456"]),dp.consumeInt64(),dp.consumeInt64(),dp.consumeString(1024),Option<String>.Some(dp.consumeString(1024)))
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_DiffRowGenerator_wrapInTag01).startFuzz()
}