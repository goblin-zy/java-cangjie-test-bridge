package cjmustache

import std.io.*
import std.convert.*

/*  cjmustache 模板引擎中的一个工具类，专门用来处理字符串转义 */
public class Escapers {
    private static let strList: Array<Array<String>> = [
        ["&",  "&amp;"],
        ["'",  "&#39;"],
        ["\"", "&quot;"],
        ["<",  "&lt;"],
        [">",  "&gt;"],
        ["`",  "&#x60;"],
        ["=",  "&#x3D;"]
    ]
    /** 转义HTML实体 */
    public static let HTML: Escaper = simple(strList)

    /** 一个不转义的转义器 */
    public static let NONE: Escaper = NoneEscaper()

    /* 这个方法返回一个简单的转义器，使用传入的替换规则
     * （如 HTML 转义）将字符替换成相应的实体编码 
     * 如果替换字符为 7 位 ASCII，则使用 Lookup7bitEscaper，
     * 否则会创建一个逐个字符替换的转义器 
     */
    public static func simple(
            repls: Array<Array<String>>): Escaper {
        var lookupTable = Lookup7bitEscaper.createTable(repls)
        if (!lookupTable.isNone()) {
            var rlookupTable: Array<?String> = 
                lookupTable.getOrThrow()
            return Lookup7bitEscaper(rlookupTable)
        }

        return SimpleEscaper(repls)
    }
}

public class SimpleEscaper <: Escaper {
    public SimpleEscaper(
        let repls: Array<Array<String>>) {}
    public override func escape(text: String): String {
        var retText = text.clone()
        for (escape in repls) {
            retText = retText.
                replace(escape[0], escape[1])
        }
        return retText
    }
}

public class NoneEscaper <: Escaper {
    public override func escape(text: String): String {
        return text
    }
}

/* 是一个针对 7 位 ASCII 字符（0-127）的优化转义器。
 * 通过构建一个查找表（lookupTable），快速将某些字符替换为预定义的转义字符 
 */
public class Lookup7bitEscaper <: Escaper {
    /*
     * This only works for replacing the lower 7 bit ascii
     * characters
     */
    private let lookupTable: Array<?String>
    protected init(lookupTable: Array<?String>) {
        super()
        this.lookupTable = lookupTable
    }

    /* 方法创建一个 128 大小的数组，数组中的每个索引对应一个 ASCII 字符，
     * 如果该字符需要被转义，则存储它的转义值，否则为 null 
     */
    public static func createTable(
        mappings: Array<Array<String>>): ?Array<?String> {
        let table = Array<?String>(128, {_ => Option<String>.None})

        for (entry in mappings) {
            let key: String = entry[0]

            if (key.size != 1) {
                return Option<Array<?String>>.None
            }

            if (key.toRuneArray()[0] > r'\u{127}') {  /* 不属于ASCLL字符集 */
                return Option<Array<?String>>.None
            }

            table[Int64(key[0])] = entry[1]
        }

        return table
    }

    public override func escape(raw: String): String {
        let stringBuild = StringBuilder(raw.size)
        try {
            escape(stringBuild, None, raw)
        } catch (e: IOException) {
            throw UncheckedIOException()
        }

        return stringBuild.toString()
    }

    /* 负责将输入的文本逐个字符地查找并进行替换。
     * 它通过遍历输入的字符序列并查找是否存在需要转义的字符，
     * 来将这些字符替换为安全的字符序列
     */
    public override func escape(
        stringBuild: ?StringBuilder,
            out: ?OutputStream, raw: String): Unit {
        let rawRunes = raw.toRuneArray()
        let end = rawRunes.size
        var start = 0
        var i = 0
        
        while (i < end) {
            var c = rawRunes[i]
            var found = escapeChar(lookupTable, c)
            /* 虽然这可以通过一个循环来完成，但通过基准测试发现，
             * 通过让第一个循环假设字符串不变，可以为字符串创建一条无需转义的快速路径。
             */ 
            if (!found.isNone()) {
                appendOrWrite(
                    stringBuild, out, raw, 0, i)
                appendOrWrite(
                    stringBuild, out, found.
                        getOrThrow())
                i++
                start = i
                while (i < end) {
                    c = rawRunes[i]
                    found = escapeChar(lookupTable, c)
                    if (!found.isNone()) {
                        appendOrWrite(
                            stringBuild, out, raw, start, i)
                        appendOrWrite(
                            stringBuild, out, found.
                                getOrThrow())
                        start = i + 1
                    }
                    i++
                }
                appendOrWrite(
                    stringBuild, out, raw, start, end)
                return 
            }
            i++
        }

        appendOrWrite(stringBuild, out, raw)
    }

    public static func escapeChar(
        lookupTable: Array<?String>, c: Rune): ?String {
        if (!c.isAscii()) {
            return Option<String>.None
        }

        return lookupTable[Int64(c.toString()[0])]
    }

    public override func toString(): String {
        let stringBuild = StringBuilder()
        stringBuild.append("Escaper[")
        for (i in 0..lookupTable.size) {
            if (let Some(str) <- lookupTable[i]) {
                stringBuild.append("{'" + i.toString() + 
                "', '" + str + "'},")
            }
        }
        stringBuild.append("]")
        stringBuild.toString()
    }
}