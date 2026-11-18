// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
    var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
    var srcRange: SrcRange = SrcRange(srcPosition, srcPosition1)
    if (srcRange.start() == srcPosition) {
        println("pass1")
    }    
    if (srcRange.end() == srcPosition1) {
        println("pass2")
    }   
    if (srcRange.isTracked()) {
        println("pass3")
    }
    if (srcRange == srcRange) {
        println("pass4")
    }
    if (srcRange.toString() == "1,1:10-2,2:20") {
        println("pass5")
    }

    return 0
}
