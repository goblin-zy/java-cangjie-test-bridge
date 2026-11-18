// 3rd_party_lib:chardet4cj/build/chardet4cj
// 3rd_party_lib:chardet4cj/build/charset
//data_file:../util_test/utf8.txt
import chardet4cj.*
import std.io.*
import std.fs.*
import std.time.*
import std.math.*
import std.collection.*

main() {
    println("TCS: chardet4cj, time elapsed: 1 ns, RESULT:")
    let threadCount = 200
    let loopCount = 50000
    let futures = ArrayList<Future<ArrayList<String>>>()
    let start = DateTime.now()
    for (_ in 0..threadCount) {
        let thread = spawn {
            var result = ArrayList<String>()
            for (_ in 0..loopCount) {
                var file_1: File = File("../util_test/utf8.txt", OpenMode.Read)
                try {
                    var resStr: String = UniversalDetector.detectCharset(file_1)
                    if (resStr == "UTF-8") {
                        result.append("success")
                    } else {
                        result.append("fail")
                    }
                } catch (e: Exception) {
                    println("e> ${e.toString()}")
                    result.append("fail")
                    continue
                }
                file_1.close()
            }
            return result
        }
        futures.append(thread)
    }

    for (f in futures) {
        f.get()
    }

    let end = Duration.since(start).toSeconds()
    var count_fail = 0
    for (f in futures) {
        var temp_re = f.get()
        for (j in temp_re) {
            if (j == "fail") {
                count_fail += 1
            }
        }
    }
    println(
        "TestSuiteChardet4cj_${threadCount}*${loopCount}: TotalTime:${end} s  TPS: ${Int64((threadCount*loopCount)/end)}  FailRate: ${count_fail/(threadCount*loopCount)*100} %"
    )
    return 0
}
