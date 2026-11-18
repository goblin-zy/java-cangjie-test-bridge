// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    var attributes: Attributes = Attributes()
    attributes.put("a", "a")
    attributes.put("B", "b")
    attributes.put("属性值为None", None)
    @Assert(" a=\"a\" B=\"b\" 属性值为None", attributes.toString())

    var attribute: Attribute = Attribute("属性值为None",None)
    @Assert("属性值为None", attribute.toString())

    return 0
}

