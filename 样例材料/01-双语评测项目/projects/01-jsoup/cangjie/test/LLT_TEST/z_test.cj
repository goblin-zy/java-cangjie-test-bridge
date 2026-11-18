package cangjie_tpc::html4cj

// from std import regex.*
import std.io.ByteArrayStream
import std.sort.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*

public class TextUtil {
    static let stripper: Regex = Regex("\\r?\\n\\s*")
    static let stripLines: Regex = Regex("\\r?\\n?")
    static let spaceCollapse: Regex = Regex("\\s{2,}")
    static let tagSpaceCollapse: Regex = Regex(">\\s+<")
    static let _stripCRs: Regex = Regex("\\r*")

    public static func stripNewlines(text: String): String {
        return stripper.matcher(text).replaceAll("")
    }

    public static func normalizeSpaces(text: String): String {
        var txt: String
        txt = stripLines.matcher(text).replaceAll("")
        txt = stripper.matcher(text).replaceAll("")
        txt = spaceCollapse.matcher(text).replaceAll(" ")
        txt = tagSpaceCollapse.matcher(text).replaceAll("><")
        return txt
    }

    public static func stripCRs(text: String): String {
        return _stripCRs.matcher(text).replaceAll("")
    }
}

@Test
class Test1 {
    @TestCase
    func case1(): Unit {
        let doc: Document = Html4cj.parseBodyFragment("<head><script>aaaa</script></head><tag2/>")
        let doc1: Document = Html4cj.parse("<script>aaaa</script><tag1/><body><tag2/></body>")

        println(doc)
        println(doc1)
    }
}
