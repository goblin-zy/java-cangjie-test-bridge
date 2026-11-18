// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    let intput1: ByteBuffer = ByteBuffer()
    let intput2: ByteBuffer = ByteBuffer()
    let data: Array<Byte> = [0x50, 0x4b, 0x03]
    let data1: Array<Byte> = [0x50, 0x4b]
    let data2: Array<Byte> = [0x50]
    intput.write(data)
    intput1.write(data1)
    intput2.write(data2)
    let str: UnicodeBOMInputStream = UnicodeBOMInputStream(intput,false)
    
    let boms = str.getBOM().toString()
    println(boms)
    if (boms != "NONE") {
        return 1
    }
    return 0
}

