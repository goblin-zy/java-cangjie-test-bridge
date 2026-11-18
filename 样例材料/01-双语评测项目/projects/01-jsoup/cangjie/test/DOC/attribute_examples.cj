// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var attr: Attribute = Attribute("key", "value &")
    if (attr.html() == "key=\"value &amp;\"") {
        println("pass1")
    }
    if (attr.toString() == attr.html()) {
        println("pass2")
    }
    if (attr.getKey() == "key") {
        println("pass3")
    }
    if (attr.getValue() == "value &") {
        println("pass4")
    }
    if (attr.hasDeclaredValue()) {
        println("pass5")
    }
    var attr1: Attribute = attr.clone()
    if (attr == attr1) {
        println("pass6")
    }
    if (attr.hashCode() == attr1.hashCode()) {
        println("pass7")
    }
    var attr2: Attribute = Attribute("key", "value1", Attributes())
    if (attr != attr2) {
        println("pass8")
    }

    return 0
}
