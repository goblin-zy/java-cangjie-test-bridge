/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

public class StringUtills {
    /**
     * The helper method for joining collections
     *
     * @param <T>
     * @param objs the collection to join
     * @param delimiter the delimiter to use
     * @return the joined string
     *
     * @since 0.39.3
     */
    public static func join<T>(objs: Iterable<T>, delimiter: String): String where T <: ToString {
        var iter = objs.iterator()
        var buffer: StringBuilder = StringBuilder()
        match(iter.next()) {
            case None => return ""
            case Some(v) => buffer.append(v)
        }
        while (true) {
            match(iter.next()) {
                case None => break
                case Some(v) => buffer.append(delimiter)
                buffer.append(v)
            }
        }
        return buffer.toString()
    }

    /**
     * Replaces all tabs with 4 spaces.
     *
     * @param str The string.
     * @return the string
     *
     * @since 0.39.3
     */
    public static func expandTabs( str: String): String {
        return str.replace("\t", "    ")
    }

    /**
     * Replaces all opening an closing tags with <code>&lt;</code> or <code>&gt;</code>.
     *
     * @param str
     * @return the str
     *
     * @since 0.39.3
     */
    public static func htmlEntites(str: String): String {
        return str.replace("<", "&lt;").replace(">", "&gt;")
    }

    /**
     * normalize the text
     *
     * @param str the text
     * @return the normalized text
     *
     * @since 0.39.3
     */
    public static func normalize(str: String): String {
        return expandTabs(htmlEntites(str))
    }

    /**
     * normalize the text list
     *
     * @param list the text
     * @return the normalized text list
     *
     * @since 0.39.3
     */
    public static func normalize(list: ArrayList<String>): ArrayList<String> {
        var result: ArrayList<String> =  ArrayList<String>()
        for (line in list) {
            result.add(normalize(line))
        }
        return result
    }

    /**
     * Wrap the text with the given column width
     *
     * @param list the text
     * @param columnWidth the given column
     * @return the wrapped text list
     *
     * @since 0.39.3
     */
    public static func wrapText( list: ArrayList<String>, columnWidth: Int64): ArrayList<String> {
        var result: ArrayList<String> =  ArrayList<String>()
        for (line in list) {
            result.add(wrapText(line, columnWidth));
        }
        return result;
    }

    /**
     * Wrap the text with the given column width
     *
     * @param line the text
     * @param columnWidth the given column
     * @return the wrapped text
     *
     * @since 0.39.3
     */
    public static func wrapText(line: String, columnWidth: Int64): String {
        var res = line
        var lenght: Int64 = line.size
        var delimiter: Int64 = "<br>".size
        var widthIndex: Int64 = columnWidth
        var count: Int64 = 0
        while (lenght > widthIndex ) {
            res = res[0..widthIndex + delimiter * count] + "<br>" + res[widthIndex + delimiter * count..]
            widthIndex += columnWidth
            count++
        }
        return res
    }
}
