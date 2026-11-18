// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var textNode1: TextNode = TextNode("这是一个文本")
    if (textNode1.nodeName() == "#text") {
        println("pass1")
    }
    if (textNode1.text() == "这是一个文本") {
        println("pass2")
    }
    textNode1.text("新文本")
    if (textNode1.text() == "新文本") {
        println("pass3")
    }
    if (!textNode1.isBlank()) {
        println("pass4")
    }
    if (textNode1.getWholeText() == "新文本") {
        println("pass5")
    }
    if (textNode1.toString() == "新文本") {
        println("pass6")
    }
    textNode1.text("")
    if (textNode1.isBlank()) {
        println("pass7")
    }
    textNode1.text("this is text")
    var textNode2: TextNode = textNode1.splitText(4)
    if (textNode1.text() == "this") {
        println("pass8")
    }
    if (textNode2.text() == " is text") {
        println("pass9")
    }
    var textNode3: TextNode = textNode1.clone()
    if (textNode1 != textNode3) {
        println("pass10")
    }
    if (!refEq(textNode1, textNode3)) {
        println("pass11")
    }
    var textNode4: TextNode = TextNode.createFromEncoded("textNode")
    if (textNode4.text() == "textNode") {
        println("pass12")
    }

    return 0
}
