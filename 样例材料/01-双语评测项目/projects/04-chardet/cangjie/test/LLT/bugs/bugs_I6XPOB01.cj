// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x50, 0x4b, 0x03, 0x04, 0x14]
    intput.write(data)
    let str: EncodingDetectorOutputStream = EncodingDetectorOutputStream(intput)
    str.close()
    let bufs: Array<Byte> = Array<Byte>(3, repeat: 0)
    try {
        str.write(bufs)
    } catch(e: Exception) {
        return 0
    }
    return 1
}

