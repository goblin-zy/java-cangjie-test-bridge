// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorInputStream   = EncodingDetectorInputStream(intput)
    str.available()
    str.close()
    try {
        str.mark(1)
    } catch (e: ChardetException) {
        return 0
    }
    return 1
    
}