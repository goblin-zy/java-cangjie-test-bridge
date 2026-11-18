// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorInputStream   = EncodingDetectorInputStream(intput)
    if (!str.markSupported()) {
        try {
            str.mark(0)
        } catch (e: ChardetException) {
            return 1
        }
        return 0
    }
    return 1
}