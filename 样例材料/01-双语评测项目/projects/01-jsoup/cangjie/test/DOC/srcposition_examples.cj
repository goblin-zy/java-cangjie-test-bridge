// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
    var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
    if (srcPosition != srcPosition1) {
        println("pass1")
    }  
    if (srcPosition.pos() == 10) {
        println("pass2")
    } 
    if (srcPosition.lineNumber() == 1) {
        println("pass3")
    } 
    if (srcPosition.columnNumber() == 1) {
        println("pass4")
    } 
    if (srcPosition.isTracked()) {
        println("pass5")
    } 

    return 0
}