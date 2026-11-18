// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let str: EscCharsetProber = EscCharsetProber()
    str.reset()
    let src = str.getConfidence()
    println(src)
    if (src != 0.990000) {
        return 1
    }
    return 0
}

