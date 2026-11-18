// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_StringUtills_wrapText(dp:DataProvider):Int32 {
    try{
        StringUtills.wrapText(dp.consumeString(1024),dp.consumeInt64())
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_StringUtills_wrapText).startFuzz()
}