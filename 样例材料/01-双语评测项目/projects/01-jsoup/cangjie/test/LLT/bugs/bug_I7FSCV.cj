// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let doc: Document = Html4cj.parse("<div>")
    var varBool: Bool = false
    try {
        doc.select(" ")
    } catch (e: SelectorParseException) {
        varBool = true
        @Assert("Could not parse query '': unexpected token at ''", e.message)
    }
    @Assert(true, varBool)

    return 0
}
