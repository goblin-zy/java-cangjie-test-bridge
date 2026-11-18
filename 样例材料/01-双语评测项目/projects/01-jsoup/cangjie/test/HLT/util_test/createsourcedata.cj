import std.random.*
import std.collection.*
import std.regex.*

public class SourceData <:Collection<String>{
    var memberStr: String
    public init(){
        this.memberStr = "enter"
    }
    public init(enter:String){
        this.memberStr = enter
    }

    let s1: String = ""
    public let s2 = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
    let s3 = "\"Hello Cangjie Lang\""
    let s4 = "Hello Cangjie Lang\n"
    public let s5 = "你好仓颉！【】"

    public let s6: String = """
                    """
    public let s7 = """
                Hello,
                Cangjie Lang
            """

    let s8: String = #""#
    public let s9 = ##"你好\n"##
    public let s10 = ###"
                Hello,
                Cangjie
                Lang
            "###        


    public func generateSourceDataWithString():(Array<String>,ArrayList<String>,HashSet<String>){
        let str_1:String = s1 + s3 + s5  //单+单
        let str_2:String = s2 + s4 + s7 + s9 //单+多
        let str_3:String = s7 + s8 + s9 + s10 //多+多
        let str_4:String = "插值==>${s5}::${s10}" //插值
        let strArr_D1:Array<String> = [s1,s3,s5,s9,s7,str_4,s10,str_3,str_1,str_2,str_4,s8]
        let strArrL_D1:ArrayList<String> = ArrayList<String>([str_1,str_2,str_3,str_4])
        let strSet_D1:HashSet<String> = HashSet<String>([s1,s3,s5,str_1,str_2,str_4,s8])
        let tuple_res:(Array<String>,ArrayList<String>,HashSet<String>) = (strArr_D1,strArrL_D1,strSet_D1)
        return tuple_res
    }

    public func getStrData(enter:Int64,resType:String) :(Array<String>,ArrayList<String>,HashSet<String>){
        let baseStr: String = "str_"
        var resArr: Array<String> = Array<String>(enter,repeat:"Q")
        var resArrL: ArrayList<String> = ArrayList<String>()
        var resSet: HashSet<String> = HashSet<String>(enter)
        match(resType){
            case "arr" => 
                for(i in 0..enter){
                    resArr[i] = "${baseStr}_arr_${i}"
                }

            case "arrL" => 
                for(j in 0..enter){
                    resArrL.add("${baseStr}_arrL_${j}")
                }

            case "set" => 
                for(k in 0..enter){
                    resSet.add("${baseStr}_set_${k}")
                }

            case _  => println("毁灭吧，累了")
            
        }
        let tuple_res:(Array<String>,ArrayList<String>,HashSet<String>) = (resArr,resArrL,resSet)
        return tuple_res
    }

    public func getRandomString(enter:Int64):String{
        var resStr:String = "str_start"
        let m: Random = Random()
        var i = 0
        while(i < enter){
            resStr += ":> ${m.nextInt64().toString()}"
            i++
        }
        return resStr
    }

    public func getLargeString(enter:Int64):String{
        var baseStr:String = "str_start>let tuple_res:(Array<String>,ArrayList<String>,HashSet<String>) = (resArr,resArrL,resSet)"
        var resStr:String = ""
        var i = 0
        while(i < enter){
            resStr += baseStr
            i++
        }
        return resStr
    }

    public prop size: Int64 {
        get() {
            return this.memberStr.size
        }
    }

    public func isEmpty(): Bool{
        if(this.memberStr.size == 0){
            return true
        }
        return false
    }

    public func toArray(): Array<String>{
        var baseStr:String = this.memberStr
        var arrStr:Array<String> = Array<String>(baseStr.size,repeat:"")
        if(baseStr.size > 0){
            for(i in 0..baseStr.size){
                arrStr[i] = "start with ${baseStr[i].toString()}_${i}"
            }
            return arrStr
        }
        return arrStr
    }

    public func iterator(): Iterator<String>{
        return ArrayList<String>(toArray()).iterator()
    }


    public func parseString(enter:String):String{
        var str1 = enter
        return str1.replace("\n","").replace(" ","")

    }

    public func parseString(enter:String,flag:Bool):String{
        var str1 = enter
        var strRes = ""
        if (flag == true) {
            strRes = str1.replace("\n","").replace("\r","").replace("\t","").replace(" ","")
        }else {
            strRes = str1.replace("\n","").trimAscii()
        }
        return strRes
    }

    public let arrLStr_Base:ArrayList<String> = ArrayList<String>([this.s1,this.s2,this.s3,this.s4,this.s5,this.s6,this.s7,this.s8,
                                                          this.s9,this.s10,this.s3+this.s5,this.s2+this.s7,this.s4+this.s10,this.s7+
                                                          this.s9,"插值==>${this.s5}::${this.s10}"])

    public func generateBaseURL():ArrayList<String>{
        var arrL:ArrayList<String> = ArrayList<String>()
        arrL = arrLStr_Base.clone()
        arrL.add("https://www.iana.org/domains/reserved")  // 地址可达  15
        arrL.add("http://jsoup.org/") // 地址可达 16
        arrL.add("http://jsoup哈喽.org/") // 地址不可达 17
        arrL.add("中文路径，无实意") // 地址不可达 18
        arrL.add("HTTP://JSOUP.ORG/") // 地址可达 19
        arrL.add("https://JSOUP.org/") // 地址可达 20
        arrL.add("https://JSO UP.org/") // 地址不可达 21
        arrL.add("https ://jsoup.org/")
        arrL.add("https: //JSOUP.org/")
        arrL.add("https:/ /JSOUP.org/")
        return arrL

    }

        
    public func generateHTMLStr():ArrayList<String>{
        var arrL:ArrayList<String> = ArrayList<String>()
        arrL.add("<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>")  // 0
        arrL.add("<html> <head> <title>SoupTest</title> </head> <body> <p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> </body> </html>") // 1
        arrL.add("<html> <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>") //html后标签不封闭  2
        arrL.add("<head> <meta charset=\"utf-16\"> <title>SoupTest</title> </head> </html>") //html前标签不封闭  3
        arrL.add("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>") // 4
        arrL.add("  <head> <meta charset=\"ASCII\"> <title>SoupTest</title>") //head后标签不封闭  5
        arrL.add("<meta charset=\"utf-8\"> <title>SoupTest</title> </head>") //head前标签不封闭   6
        arrL.add("<body> <p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> ") //body后标签不封闭   7
        arrL.add("<p id=\"id_P\"> <span class=\"cla_1\"> hello </span> </p> </body>") //body前标签不封闭   8
        arrL.add("<body> <p id=\"id_P\"> 刺昂仓，\n季叶杰 <span class=\"cla_1\"> hel\rlo </span> </p> </body>") //html文本含转义  9
        arrL.add("<head> hello <meta charset=\"utf-8\">你好呀 <title>SoupTest</title> </head>") // 不符合html语法  10
        arrL.add("<head_Soup> <meta charset=\"utf-8\"> <title22>SoupTest</title22> </head_Soup>")  //不符合html语法  11
        arrL.add("<!DOCTYPE html> <html> <head> <script language=\"javascript\"> document.location = \"http://www.baidu.com\"; </script> </head> </html>") // 重定向  12
        arrL.add("<BODY> <P ID=\"ID_P\"> <SPAN CLASS=\"CLA_1\"> HELLO </SPAN> </P> </BODY>") // 全大写  13
        arrL.add("<BODY> <p ID=\"id_p\"> <SPAN CLASS=\"cla_1\"> hello </SPAN> </p> </body>") // 大小写   14
        arrL.add("<body> <输入type=\"text\"> <范围> 打我呀 </范围> </body>") // 无效标签  15
        return arrL

    }

    public func getConsoleOutStr(logStr:String,logTag:String):String{
        let buf = StringBuilder()
        for (entry in logStr.split("\n")) {
            let temp =  entry.split(" [${logTag}] ")
            if (temp.size >= 2) {
                buf.append(temp[1])
            }            
        }
        return buf.toString()
    }
     

}

public func assertOptionNone<T>(enter:?T):Bool{
    var flag:Bool = false
    match (enter) {
        case None => flag = true
        case _ => flag = false
    }
    return flag
}

 public func parseData_Arr_D2<T>(enter:Array<Array<T>>):(String,Int64) where T <: ToString{
    var str_res:String = ""
    for (arr_D1 in enter) {
        for (obj in arr_D1) {
            str_res += obj.toString()
        }
    }
    return (str_res,str_res.size)
}

public func generateHTMLStr(enter:Int64):String {
        let sb: StringBuilder = StringBuilder("<html><head></head><body>")
        sb.append("<div id='pseudo'>")
        for (i in 1..=enter) {
            sb.append("<p>test_${i}</p>")
        }
        sb.append("</div>")
        sb.append("<div id='type'>")
        for (i in 1..=enter) {
            sb.append("<p>${i}</p>")
            sb.append("<span>${i}</span>")
            sb.append("<em>${i}</em>")
            sb.append("<svg>${i}</svg>")
        }
        sb.append("</div>")
        sb.append("<span id='onlySpan'><br /></span>")
        sb.append("<p class='empty'><!-- Comment only is still empty! --></p>")
        sb.append("<div id='only'>")
        sb.append("Some text before the <em>only</em> child in this div")
        sb.append("</div>")
        sb.append("</body></html>")
    return  sb.toString()
}