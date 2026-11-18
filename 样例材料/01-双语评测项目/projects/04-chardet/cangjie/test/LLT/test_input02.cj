// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(intput)

    let src = str.markSupported()
	try {
        str.read()
    } catch(e: Exception) {
        return 0
    }
    if (src != false) {
        return 1
    }

    return 0
}

