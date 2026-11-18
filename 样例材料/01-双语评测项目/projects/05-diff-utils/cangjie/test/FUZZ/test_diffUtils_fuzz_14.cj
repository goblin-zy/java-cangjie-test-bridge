// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_Builder_columnWidth(dp:DataProvider):Int32 {
    let builder=Builder()
    try{
        builder.columnWidth(dp.consumeInt64())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_Builder_columnWidth).startFuzz()
}