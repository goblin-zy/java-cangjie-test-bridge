// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    let p1: Tag = Tag.valueOf("P")
    let p2: Tag = Tag.valueOf("p")
    if (p1 == p2) {
        println("pass1")
    }
    let div: Tag = Tag.valueOf("div")
    if (div.isBlock()) {
        println("pass2")
    }
    if (div.formatAsBlock()) {
        println("pass3")
    }
    let p: Tag = Tag.valueOf("p")
    if (p.isBlock()) {
        println("pass4")
    }
    if (!p.formatAsBlock()) {
        println("pass5")
    }
    let img: Tag = Tag.valueOf("img")
    if (img.isInline()) {
        println("pass6")
    }
    if (img.isSelfClosing()) {
        println("pass7")
    }
    if (!img.isBlock()) {
        println("pass8")
    }

    return 0
}
