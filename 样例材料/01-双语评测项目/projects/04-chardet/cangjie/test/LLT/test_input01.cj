// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorInputStream   = EncodingDetectorInputStream(intput)
    let src =  str.available()
    str.close()
    str.mark(0)
    println(src)
    if (src != 0) {
        return 1
    }
    return 0
}

