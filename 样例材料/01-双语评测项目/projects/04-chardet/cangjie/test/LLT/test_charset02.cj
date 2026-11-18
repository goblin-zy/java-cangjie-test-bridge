// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var charsetp: CharsetProber = UTF8Prober()
    
    var bufdata: Array<Byte> = [0x50, 0x4b, 0x03, 0x04, 0x14, 0x00, 0x02, 0x00]
    var bytebuf: ChardetByteBuffer = charsetp.filterWithoutEnglishLetters(bufdata,0,8)
    let str: String = bytebuf.toString()
    println(str)
    if (str != "ChardetByteBuffer: [offset=0 mark=-1 pos=0 lim=8 cap=8]"){
        return 1
    }
    return 0
}

