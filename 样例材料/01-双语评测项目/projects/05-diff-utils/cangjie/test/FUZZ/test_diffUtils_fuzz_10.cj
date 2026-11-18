// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_Builder_InlineOldTag(dp:DataProvider):Int32 {
    let builder=Builder()
    try{
        builder.InlineOldTag(dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_Builder_InlineOldTag).startFuzz()
}