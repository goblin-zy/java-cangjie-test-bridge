// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var attributes1: Attributes = Attributes()
    attributes1.put("Tot", "a&p")
    attributes1.put("Hello", "There")
    attributes1.put("data-name", "Jsoup")
    if (attributes1.size == 3) {
        println("pass1")
    }
    if (attributes1.get("Tot") == "a&p") {
        println("pass2")
    }
    attributes1.remove("Tot")
    if (attributes1.get("Tot") == "") {
        println("pass3")
    }
    if (attributes1.size == 2) {
        println("pass4")
    }
    if (attributes1.get("HELLO") == "") {
        println("pass5")
    }
    if (attributes1.getIgnoreCase("HELLO") == "There") {
        println("pass6")
    }
    if (!attributes1.hasKey("HELLO")) {
        println("pass7")
    }
    if (attributes1.hasKeyIgnoreCase("HELLO")) {
        println("pass8")
    }
    if (attributes1.dataSize == 1) {
        println("pass9")
    }
    if (attributes1.getData("name").getOrThrow() == "Jsoup") {
        println("pass10")
    }
    var attr: Attribute = Attribute("key", "value &")
    attributes1.put(attr)
    if (attributes1.size == 3) {
        println("pass11")
    }
    if (!attributes1.isEmpty()) {
        println("pass12")
    }
    if (attributes1.toString() == attributes1.html()) {
        println("pass13")
    }
    if (attributes1.hasDeclaredValueForKeyIgnoreCase("key")) {
        println("pass14")
    }
    var attributes2: Attributes = attributes1.clone()
    if (attributes1 == attributes2) {
        println("pass15")
    }
    var attributes3: Attributes = Attributes()
    if (attributes1 != attributes3) {
        println("pass16")
    }

    return 0
}
