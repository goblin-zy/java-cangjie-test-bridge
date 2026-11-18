// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var escapeMode1: EscapeMode = EscapeMode.xhtml
    var escapeMode2: EscapeMode = EscapeMode.base
    var escapeMode3: EscapeMode = EscapeMode.extended
    if ("xhtml" == escapeMode1.toString()) {
        println("pass1")
    }
    if ("base" == escapeMode2.toString()) {
        println("pass2")
    }
    if ("extended" == escapeMode3.toString()) {
        println("pass3")
    }
    if (escapeMode1 != escapeMode2) {
        println("pass4")
    }
    if (escapeMode3 == escapeMode3) {
        println("pass5")
    }

    return 0
}
