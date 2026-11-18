// DEPENDENCE: utf8.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*
import std.fs.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x4b, 0x03, 0x00, 0x03,0x4b, 0x03, 0x00, 0x03]
    intput.write(data)
    var testFile: File = File("./utf8.txt",OpenMode.Read)
    let str: EncodingDetectorInputStream = EncodingDetectorInputStream(testFile)
    let bufs: Array<Byte> = Array<Byte>(5, repeat: 0)
    str.read(bufs)
    let src = str.skip(0)
    str.getDetectedCharset()
    println(src)
    if (src != 0) {
        return 1
    }
    return 0
}

