// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    let p1: Tag = Tag.valueOf("P")
    var element1: Element = Element(p1, "")
    if (element1.baseUri() == "") {
        println("pass1")
    }
    if (element1.childNodeSize() == 0) {
        println("pass2")
    }
    if (element1.nodeName() == "P") {
        println("pass3")
    }
    if (element1.tag() == p1) {
        println("pass4")
    }
    if (element1.tagName() == "P") {
        println("pass5")
    }
    if (element1.isBlock()) {
        println("pass6")
    }
    var attributes2: Attributes = Attributes()
    attributes2.put("id", "1")
    attributes2.put("class", "html")
    let p2: Tag = Tag.valueOf("P")
    var element2: Element = Element(p2, "", attributes2)
    if (element2.id() == "1") {
        println("pass7")
    }
    element2.id("2")
    if (element2.id() == "2") {
        println("pass8")
    }
    var element3: Element = Element("body")
    var element4: Element = Element("p0")
    var element5: Element = Element("p1")
    var element6: Element = Element("p2")
    var element7: Element = Element("p3")
    var element8: Element = Element("p4")
    element3.appendChild(element4)
    element3.appendChild(element5)
    element3.prependChild(element6)
    if (element3.childrenSize() == 3) {
        println("pass9")
    }
    element4.before(element7)
    element4.after(element8)
    if (element3.childrenSize() == 5) {
        println("pass10")
    }
    element3.empty()
    if (element3.childrenSize() == 0) {
        println("pass11")
    }

    return 0
}
