// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x4b, 0x03]
    intput.write(data)
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(intput)
    var exc = ""
    try{
        str.reset()
    } catch (e: ChardetException){
        exc = e.toString()
    }
    if (exc != "ChardetException: mark/reset not supported") {
        return 1
    }
    return 0
}

