// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var doc: Document = Html4cj.parse("<p>Hello</p>")
    doc.text("Replaced")
    if (doc.text() == "Replaced") {
        println("pass1")
    }
    if (doc.body().text() == "Replaced") {
        println("pass2")
    }
    if (doc.select("head").size == 1) {
        println("pass3")
    }

    return 0
}
