// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj

import fuzz.fuzz.*
import diffUtils4cj.*
import std.collection.*

public func fuzzFunc_DiffRow_setNewLine(dp:DataProvider):Int32 {
    let diffrow=DiffRow(Tag.INSERT,"diff old","diff new")
    try{
        diffrow.setNewLine(dp.consumeString(1024))
    }catch(e:Exception){}
    return 0
}
main(){
    Fuzzer(fuzzFunc_DiffRow_setNewLine).startFuzz()
}