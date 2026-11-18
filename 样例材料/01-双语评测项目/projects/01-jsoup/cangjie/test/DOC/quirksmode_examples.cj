// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var quirksMode1: QuirksMode = QuirksMode.noQuirks
    var quirksMode2: QuirksMode = QuirksMode.quirks
    var quirksMode3: QuirksMode = QuirksMode.limitedQuirks
    if ("noQuirks" == quirksMode1.toString()) {
        println("pass1")
    }
    if ("quirks" == quirksMode2.toString()) {
        println("pass2")
    }
    if ("limitedQuirks" == quirksMode3.toString()) {
        println("pass3")
    }
    if (quirksMode1 != quirksMode2) {
        println("pass4")
    }
    if (quirksMode3 == quirksMode3) {
        println("pass5")
    }

    return 0
}
