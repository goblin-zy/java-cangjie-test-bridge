// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let strs: EscCharsetProber = EscCharsetProber()
    let data: Array<Byte> = Array<Byte>()
    try {
        strs.handleData(data,0,Int32(data.size))
    } catch(e: Exception) {
        return 0
    }
    return 1
}


