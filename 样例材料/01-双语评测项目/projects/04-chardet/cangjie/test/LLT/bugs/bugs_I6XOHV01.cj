// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var charsetp: CharsetProber = UTF8Prober()
    
    var bufdata: Array<Byte> = [0x50, 0x4b, 0x03, 0x04, 0x14, 0x00, 0x02, 0x00]
    try {
        charsetp.filterWithoutEnglishLetters(bufdata,0,0)
    } catch(e: Exception) {
        return 0
    }
    var data: Array<Byte> = Array<Byte>()
    try {
        charsetp.filterWithoutEnglishLetters(data,0,8)
    } catch(e: Exception) {
        return 0
    }
    return 1
}
