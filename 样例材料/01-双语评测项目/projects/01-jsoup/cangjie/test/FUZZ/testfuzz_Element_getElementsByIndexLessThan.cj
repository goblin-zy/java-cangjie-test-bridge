// 3rd_party_lib:html4cj/build/html4cj
import cangjie_tpc::html4cj.*
import stdx.fuzz.fuzz.*
import std.collection.*


var returnFlag: Int32 = 0
let ele:Element = Element("ElementInstance")
let eleArrL:ArrayList<Node> = getDataBase()

func getDataBase():ArrayList<Node>{
    var eleArrL:ArrayList<Node> = ArrayList<Node>()
    for(i in 0..3){
      eleArrL.append(Element(Tag.valueOf("Tag${i+1}"),"",None))
    }
    return eleArrL
}

func fuzz_Element_getElementsByIndexLessThan(dp: DataProvider): Int32 {
    ele.insertChildren(0,eleArrL)
    //  public func getElementsByIndexLessThan(index: Int64): Elements
    try {
        ele.getElementsByIndexLessThan(dp.consumeInt64())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_Element_getElementsByIndexLessThan).startFuzz()

    return 0
}
