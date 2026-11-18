// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x4b, 0x03, 0x00]
    intput.write(data)
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(intput)
    let bufs: Array<Byte> = Array<Byte>(1, repeat: 0)
    str.read(bufs)
    let src = str.skip(0)
    println(src)
    if (src != -1) {
        return 1
    }
    return 0
}

