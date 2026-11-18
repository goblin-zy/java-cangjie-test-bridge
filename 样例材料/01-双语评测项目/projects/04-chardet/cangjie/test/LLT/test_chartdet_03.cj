// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.fs.*
import std.io.*
import chardet4cj.*

main() {

    var detector: UniversalDetector = UniversalDetector()
    let sc = CharsetListener()
    detector.setListener(sc)
    detector.getListener()
    let data: Array<Byte> = [0x50, 0x4b, 0x03]
    detector.handleData(data)
    detector.dataEnd()
    let sdet = detector.getDetectedCharset()
    println(sdet)
    if (sdet != "") {
        return 1
    }
    return 0
}

