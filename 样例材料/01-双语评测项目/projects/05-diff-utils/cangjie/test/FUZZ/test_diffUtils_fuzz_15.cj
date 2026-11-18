// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_DiffUtils_generateUnifiedDiff(dp:DataProvider):Int32 {
    try{
        DiffUtils.generateUnifiedDiff(dp.consumeString(1024),dp.consumeString(1024),ArrayList<String>(),Patch<String>(),dp.consumeInt64())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_DiffUtils_generateUnifiedDiff).startFuzz()
}