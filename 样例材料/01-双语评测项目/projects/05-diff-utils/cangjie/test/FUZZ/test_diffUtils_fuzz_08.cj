// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*

public func fuzzFunc_Builder_ignoreWhiteSpaces(dp:DataProvider):Int32 {
    let builder=Builder()
    try{
        builder.ignoreWhiteSpaces(dp.consumeBool())
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_Builder_ignoreWhiteSpaces).startFuzz()
}