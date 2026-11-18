// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var charsetp: CharsetProber = UTF8Prober()
    
    var bufdata: Array<Byte> = [0x50, 0x4b, 0x03]
    try {
        charsetp.filterWithEnglishLetters(bufdata,0,0)
    } catch(e: Exception) {
        return 0
    }
    var datas: Array<Byte> = Array<Byte>()
    try {
        charsetp.filterWithEnglishLetters(datas,0,8)
    } catch(e: Exception) {
        return 0
    }
    return 1
}
