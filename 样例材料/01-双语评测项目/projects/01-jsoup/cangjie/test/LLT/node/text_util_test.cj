public import std.regex.*

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
