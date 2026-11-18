// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let str: EscCharsetProber = EscCharsetProber()
    str.reset()
    let src = str.getCharSetName()
    println(src)
    if (!src.isEmpty()) {
        return 1
    }
    return 0
}

