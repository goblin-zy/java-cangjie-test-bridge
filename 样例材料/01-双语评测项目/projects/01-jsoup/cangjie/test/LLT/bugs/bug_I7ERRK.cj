// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let reference: String =
        "<div id=div1><p>Hello</p><p>Another <b>element</b></p><div id=div2><img src=foo.png></div></div>"
    var doc: Document = Html4cj.parse(reference)
    @Assert(doc.hashCode() != 0, true)

    return 0
}
