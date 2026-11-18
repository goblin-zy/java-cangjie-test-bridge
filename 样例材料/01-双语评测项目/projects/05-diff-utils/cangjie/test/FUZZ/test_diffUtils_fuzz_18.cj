// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*
import std.collection.*

public func fuzzFunc_StringUtills_htmlEntites(dp:DataProvider):Int32 {
    try{
        StringUtills.htmlEntites(dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}

main(){
    Fuzzer(fuzzFunc_StringUtills_htmlEntites).startFuzz()
}