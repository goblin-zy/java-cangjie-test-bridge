// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x4b, 0x03, 0x04, 0x14, 0x00, 0x02, 0x00]
    intput.write(data)
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(intput)
    let datas: Array<Byte> = Array<Byte>(1,repeat: 0)
    let src = str.read(datas)
    println(src)
    if (src != 1) {
        return 1
    }
    return 0
}

