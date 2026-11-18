// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*

public func fuzzFunc_DiffRow_Init(dp:DataProvider):Int32 {
    try{
        DiffRow(Tag.INSERT,dp.consumeString(1024),dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_DiffRow_Init).startFuzz()
}