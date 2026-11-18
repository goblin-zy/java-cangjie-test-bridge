// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorOutputStream = EncodingDetectorOutputStream(intput)
    str.write(6)
    let src = str.getDetectedCharset()
    println(src)
    if (!src.isEmpty()) {
        return 1
    }
    return 0
}

