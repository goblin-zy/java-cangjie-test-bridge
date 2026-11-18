// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorInputStream   = EncodingDetectorInputStream(intput)
    if (str.available() ==0) {
        try {
            str.mark(58)
        } catch (e: ChardetException) {
            return 0
        }
        return 1
    }
    return 1
}