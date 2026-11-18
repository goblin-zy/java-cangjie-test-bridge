import std.random.*

public  class CommonUtils {
    public func getRandomStr(enter:UInt64):String{
        let m: Random = Random(32)
        var res:String = ""
        for(_ in 0..enter){
            res += m.nextUInt64(enter).toString()
        }
        return res
    }

    public func getStrWithEnglishLetters(enter:Int64):String{
        let base: String = "AWQREAXFUXCVSOIHVJHvcdfsfaclkuhgtriugHFWTYRDJKYWVCShjyugfuyrniaudgbviwuergoqwiuegfbcuweryfHDAXFTHFDSJHGSvhgfvvjchvdapweugfyweuefouqJFDUYWFtoiunmkbzdyvy"
        var res:String = ""
        for(i in 1..enter){
            for(j in 0..base.size:i){
                res += String.fromUtf8(base[j])
            }
        }
        // println("res.size:>>>  ${res.size}")
        return res
    }



}