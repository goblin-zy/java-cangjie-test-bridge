// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.fs.*
import std.io.*
import chardet4cj.*

main() {

    var bufdata: Array<Byte> = [0x50, 0x4b, 0x03, 0x04, 0x14, 0x00, 0x02, 0x00]
    let str = UniversalDetector.detectCharsetFromBOM(bufdata)
    println(str)
    if (str != "") {
        return 1
    }
    return 0
}

