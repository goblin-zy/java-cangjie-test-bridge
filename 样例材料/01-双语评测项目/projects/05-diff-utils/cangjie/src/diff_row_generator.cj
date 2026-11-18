/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

public class DiffRowGenerator {
    private var showInlineDiffs: Bool
    private var ignoreWhiteSpaces: Bool
    private var ignoreBlankLines: Bool
    private var InlineOldTag: String
    private var InlineNewTag: String
    private var InlineOldCssClass: String
    private var InlineNewCssClass: String
    private var columnWidth: Int64
    private var equalizer: Equalizer<String>

    /**
     * Creates a DiffRowGenerator
     * 
     * @param The Builder
     * 
     * @since 0.39.3
     */
    protected init(builder: Builder) {
        showInlineDiffs = builder.showInlineDiffs_
        ignoreWhiteSpaces = builder.ignoreWhiteSpaces_
        ignoreBlankLines = builder.ignoreBlankLines_
        InlineOldTag = builder.InlineOldTag_
        InlineNewTag = builder.InlineNewTag_
        InlineOldCssClass = builder.InlineOldCssClass_
        InlineNewCssClass = builder.InlineNewCssClass_
        columnWidth = builder.columnWidth_
        equalizer = Stringequalizer(builder.ignoreWhiteSpaces_)
    }

    /**
     * Get the DiffRows describing the difference between original and revised texts using the
     * given patch. Useful for displaying side-by-side diff.
     *
     * @param original the original text
     * @param revised the revised text
     * @return the DiffRows between original and revised texts
     * 
     * @since 0.39.3
     */
    public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>): ArrayList<DiffRow> {
        return generateDiffRows(original, revised, DiffUtils.diff(original, revised, equalizer))
    }

    /**
     * Generates the DiffRows describing the difference between original and revised texts using the
     * given patch. Useful for displaying side-by-side diff.
     *
     * @param original the original text
     * @param revised the revised text
     * @param patch the given patch
     * @return the DiffRows between original and revised texts
     * 
     * @since 0.39.3
     */
    public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>, patch: Patch<String>): ArrayList<DiffRow> {
        // normalize the lines (expand tabs, escape html entities)
        var original_ = StringUtills.normalize(original)
        var revised_ = StringUtills.normalize(revised)

        // wrap to the column width
        original_ = StringUtills.wrapText(original, this.columnWidth)
        revised_ = StringUtills.wrapText(revised, this.columnWidth)

        var diffRows: ArrayList<DiffRow> = ArrayList<DiffRow>()
        var endPos: Int64 = 0
        let  deltaList: ArrayList<Delta<String>> = patch.getDeltas()
        var i: Int64 = 0
        while (i < deltaList.size) {
            var delta: Delta<String> = deltaList.get(i).getOrThrow()
            var orig: Chunk<String> = delta.getOriginal()
            var rev: Chunk<String> = delta.getRevised()

            // We should normalize and wrap lines in deltas too.
            setlineExtracted(original, diffRows, endPos, orig, rev)

            // Inserted DiffRow
            if (delta is InsertDelta<String>) {
                endPos = orig.last() + 1
                for (line in rev.getLines()) {
                    diffRows.add(DiffRow(Tag.INSERT, "", line))
                }
                i++
                continue
            }

            // Deleted DiffRow
            if (delta is DeleteDelta<String>) {
                endPos = orig.last() + 1
                for (line in orig.getLines()) {
                    diffRows.add(DiffRow(Tag.DELETE, line, ""))
                }
                i++
                continue
            }
            if (showInlineDiffs) { addInlineDiffs(delta) }
            //the changed size is match
            extracted(diffRows, orig, rev)
            endPos = orig.last() + 1
            i++
        }

        // Copy the final matching chunk if any.
        if (endPos == original.size) { return diffRows }
        for (line in original.slice(endPos..original.size)) {
            diffRows.add(DiffRow(Tag.EQUAL, line, line))
        }
        return diffRows
    }

    private static func extracted(diffRows: ArrayList<DiffRow> , orig: Chunk<String>, rev: Chunk<String>) {
        if (orig.size() == rev.size()) {
            var j = 0
            while (j < orig.size()) {
                diffRows.add(DiffRow(Tag.CHANGE, orig.getLines().get(j).getOrThrow(), rev.getLines().get(j).getOrThrow()))
                j++
            }
        } else if (orig.size() > rev.size()) {
            var j = 0
            while (j < orig.size()) {
                if (rev.getLines().size > j) {
                    diffRows.add(DiffRow(Tag.CHANGE, orig.getLines().get(j).getOrThrow(), rev.getLines().get(j).getOrThrow()))
                } else {
                    diffRows.add(DiffRow(Tag.CHANGE, orig.getLines().get(j).getOrThrow(), ""))
                }
                j++
            }
        } else {
            var j = 0
            while (j < rev.size()) {
                if (orig.getLines().size > j) {
                    diffRows.add(DiffRow(Tag.CHANGE, orig.getLines().get(j).getOrThrow(), rev.getLines().get(j).getOrThrow()))
                } else {
                    diffRows.add(DiffRow(Tag.CHANGE, "", rev.getLines().get(j).getOrThrow()))
                }
                j++
            }
        }
    }

    private func setlineExtracted(original: ArrayList<String>, diffRows: ArrayList<DiffRow>, endPos: Int64, orig: Chunk<String>, rev: Chunk<String>) {
        orig.setLines(StringUtills.normalize(orig.getLines()))
        rev.setLines(StringUtills.normalize(rev.getLines()))

        orig.setLines(StringUtills.wrapText(orig.getLines(), this.columnWidth))
        rev.setLines(StringUtills.wrapText(rev.getLines(), this.columnWidth))

        // catch the equal prefix for each chunk
        for (line in original.slice(endPos..orig.getPosition())) {
            diffRows.add(DiffRow(Tag.EQUAL, line, line))
        }
    }

    /**
     * Add the inline diffs for given delta
     *
     * @param delta the given delta
     * 
     * @since 0.39.3
     */
    private func addInlineDiffs(delta: Delta<String>): Unit {
        var orig = delta.getOriginal().getLines()
        var rev = delta.getRevised().getLines()
        var origList = ArrayList<String>()
        
        for (character in join(orig, "\n")) {
            origList.add(Rune(character).toString())
        }
        var revList = ArrayList<String>()
        for (character in join(rev, "\n")) {
            revList.add(Rune(character).toString())
        }
        var inlineDeltas: ArrayList<Delta<String>> = DiffUtils.diff(origList, revList).getDeltas()
        if (inlineDeltas.size < 3) {
            inlineDeltas.reverse()
            for (inlineDelta in inlineDeltas) {
                var inlineOrig = inlineDelta.getOriginal()
                var inlineRev = inlineDelta.getRevised()
                if (inlineDelta is DeleteDelta<String>) {
                    origList = wrapInTag(origList, inlineOrig.getPosition(), inlineOrig.getPosition()+ inlineOrig.size() + 1, this.InlineOldTag, this.InlineOldCssClass)
                } else if (inlineDelta is InsertDelta<String>) {
                    revList = wrapInTag(revList, inlineRev.getPosition(), inlineRev.getPosition()+ inlineRev.size() + 1, this.InlineNewTag, this.InlineNewCssClass)
                } else if (inlineDelta is ChangeDelta<String>) {
                    origList = wrapInTag(origList, inlineOrig.getPosition(), inlineOrig.getPosition()+ inlineOrig.size() + 1, this.InlineOldTag, this.InlineOldCssClass)
                    revList = wrapInTag(revList, inlineRev.getPosition(), inlineRev.getPosition()+ inlineRev.size() + 1, this.InlineNewTag, this.InlineNewCssClass)
                }
            }
            var origResult =  StringBuilder()
            var revResult =  StringBuilder()
            for (character in origList) {
                origResult.append(character)
            }
            for (character in revList) {
                revResult.append(character)
            }
            delta.getOriginal().setLines(ArrayList(origResult.toString().split("\n")))
            delta.getRevised().setLines(ArrayList(revResult.toString().split("\n")))
        }
    }

    /**
     * Wrap the elements in the sequence with the given tag
     *
     * @param startPosition the position from which tag should start. The counting start from a zero.
     * @param endPosition the position before which tag should should be closed.
     * @param tag the tag name without angle brackets, just a word
     * @param cssClass the optional css class
     * 
     * @since 0.39.3
     */
    public static func wrapInTag(sequence: ArrayList<String>, startPosition: Int64,
            endPosition: Int64,tag: String, cssClass: ?String): ArrayList<String> {
        var result = sequence.clone()
        var tagBuilder = StringBuilder()
        tagBuilder.append("<")
        tagBuilder.append(tag)
        if (let Some(v) <- cssClass) {
            tagBuilder.append(" class=\"")
            tagBuilder.append(v)
            tagBuilder.append("\"")
        }
        tagBuilder.append(">")
        var startTag = tagBuilder.toString()
        tagBuilder.reset()

        tagBuilder.append("</")
        tagBuilder.append(tag)
        tagBuilder.append(">")
        var endTag = tagBuilder.toString()

        result.add(startTag, at: startPosition)
        result.add(endTag, at: endPosition)
        return result
    }

    /**
     * Wrap the given line with the given tag
     *
     * @param line the given line
     * @param tag the tag name without angle brackets, just a word
     * @param cssClass the optional css class
     * @return the wrapped string
     * 
     * @since 0.39.3
     */
    public static func wrapInTag(line: String, tag: String, cssClass: ?String): String {
        var tagBuilder = StringBuilder()
        tagBuilder.append("<")
        tagBuilder.append(tag)
        if (let Some(v) <- cssClass) {
            tagBuilder.append(" class=\"")
            tagBuilder.append(v)
            tagBuilder.append("\"")
        }
        tagBuilder.append(">")
        var startTag = tagBuilder.toString()

        tagBuilder.reset()

        tagBuilder.append("</")
        tagBuilder.append(tag)
        tagBuilder.append(">")
        var endTag = tagBuilder.toString()

        return startTag + line + endTag
    }

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
    private static func join<T>(objs: Iterable<T>, delimiter: String): String where T <: ToString {
        var iter = objs.iterator()
        var buffer = StringBuilder()
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
}

class Stringequalizer <: Equalizer<String> {
    private var ignoreWhiteSpaces_: Bool
    protected init (ignoreWhiteSpaces: Bool) {
        this.ignoreWhiteSpaces_ = ignoreWhiteSpaces
    }

    /**
     * Returns is the str are same
     *
     * @param val the original str
     * @param val the revised str
     * @return the Bool
     *
     * @since 0.39.3
     */
   public func equals(original: String, revised: String): Bool{
        var a: String = original
        var b: String = revised
        if (ignoreWhiteSpaces_) {
            a = original.trimAscii().replace("\\s+", " ")
            b = revised.trimAscii().replace("\\s+", " ")
        }
        return a == b
    }
}

public class Builder {
    protected var showInlineDiffs_: Bool = false
    protected var ignoreWhiteSpaces_: Bool = false
    protected var ignoreBlankLines_: Bool = false
    protected var InlineOldTag_: String = "span"
    protected var InlineNewTag_: String = "span"
    protected var InlineOldCssClass_: String = "editOldInline"
    protected var InlineNewCssClass_: String = "editNewInline"
    protected var columnWidth_: Int64 = 80

    /**
     * Show inline diffs in generating diff rows or not.
     *
     * @param val the value to set. Default: false.
     * @return builder with configured showInlineDiff parameter
     *
     * @since 0.39.3
     */
    public func showInlineDiffs(val: Bool): Builder {
        showInlineDiffs_ = val
        return this
    }

    /**
     * Ignore white spaces in generating diff rows or not.
     *
     * @param val the value to set. Default: true.
     * @return builder with configured ignoreWhiteSpaces parameter
     *
     * @since 0.39.3
     */
    public func ignoreWhiteSpaces(val: Bool): Builder {
        ignoreWhiteSpaces_ = val
        return this
    }

    /**
     * Ignore blank lines in generating diff rows or not.
     * @param val the value to set. Default: true.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func ignoreBlankLines(val: Bool): Builder {
        ignoreBlankLines_ = val
        return this
    }

    /**
     * Set the tag used for displaying changes in the original text.
     *
     * @param tag the tag to set. Without angle brackets. Default: span.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func InlineOldTag(tag: String): Builder {
        InlineOldTag_ = tag
        return this
    }

    /**
     * Set the tag used for displaying changes in the revised text.
     *
     * @param tag the tag to set. Without angle brackets. Default: span.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func InlineNewTag(tag: String): Builder {
        InlineNewTag_ = tag
        return this
    }

    /**
     * Set the css class used for displaying changes in the original text.
     *
     * @param cssClass the tag to set. Without any quotes, just word. Default: editOldInline.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func InlineOldCssClass(cssClass: String): Builder {
        InlineOldCssClass_ = cssClass
        return this
    }

    /**
     * Set the css class used for displaying changes in the revised text.
     *
     * @param cssClass the tag to set. Without any quotes, just word. Default: editNewInline.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func InlineNewCssClass(cssClass: String): Builder {
        InlineNewCssClass_ = cssClass
        return this
    }

    /**
     * Set the column with of generated lines of original and revised texts.
     *
     * @param width the width to set. Making it < 0 doesn't have any sense. Default 80.
     * @return builder with configured ignoreBlankLines parameter
     *
     * @since 0.39.3
     */
    public func columnWidth(width: Int64): Builder {
        if (width > 0) {
            columnWidth_ = width
        }
        return this
    }

    /**
     * Build the DiffRowGenerator. If some parameters is not set, the default values are used.
     *
     * @return the customized DiffRowGenerator
     *
     * @since 0.39.3
     */
    public func build(): DiffRowGenerator {
        return DiffRowGenerator(this)
    }
}