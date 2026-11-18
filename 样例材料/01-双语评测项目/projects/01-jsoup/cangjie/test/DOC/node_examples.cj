// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var doc: Document = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
    var a: Element = doc.select("a").first().getOrThrow()
    if (a.attr("href") == "/foo") {
        println("pass1")
    }
    if (a.attr("abs:href") == "https://jsoup.org/foo") {
        println("pass2")
    }
    if (a.hasAttr("abs:href")) {
        println("pass3")
    }

    return 0
}
