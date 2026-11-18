// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    var element: Element = Element("P")
    var varBool: Bool = false
    try {
        element.tagName(" ")
    } catch (e: Exception) {
        varBool = true
        @Assert("String must not be empty", e.message)
    }
    @Assert(true, varBool)

    return 0
}
