// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x4b, 0x03, 0x03, 0x04, 0x15, 0x00, 0x02, 0x00]
    intput.write(data)
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(intput)
    try{
        let src = str.skip(-1)
        if (src != -1) {
            return 1
        }
        return 0
    } catch (e: ChardetException) {
        return 1
    }
}
