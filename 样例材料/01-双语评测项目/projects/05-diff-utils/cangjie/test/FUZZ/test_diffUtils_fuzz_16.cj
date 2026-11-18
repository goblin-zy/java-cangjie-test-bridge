// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_Snake_Init(dp:DataProvider):Int32 {
    try{
        Snake(dp.consumeInt64(),dp.consumeInt64(),Option<PathNode>.None)
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_Snake_Init).startFuzz()
}