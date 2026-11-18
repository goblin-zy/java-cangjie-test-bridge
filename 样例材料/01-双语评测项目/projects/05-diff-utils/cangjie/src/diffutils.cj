/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj
import std.regex.*
import std.convert.*
import std.collection.*

public class DiffUtils {

    private static let unifiedDiffChunkRe: Regex = Regex("^@@\\s+-(?:(\\d+)(?:,(\\d+))?)\\s+\\+(?:(\\d+)(?:,(\\d+))?)\\s+@@$")
    
    /**
     * Computes the difference between the original and revised list of elements
     * with default diff algorithm
     * 
     * @param original The original text. 
     * @param revised The revised text.
     * @return The patch describing the difference between the original and revised sequences.
     *   
     * @since 0.38.2
     */
    public static func diff<T>( original: ArrayList<T>, revised: ArrayList<T>): Patch<T> where T <: Equal<T> & ToString {
        return DiffUtils.diff(original, revised,  MyersDiff<T>())
    }

    /**
     * Computes the difference between the original and revised list of elements
     * with default diff algorithm
     * 
     * @param original The original text. 
     * @param revised The revised text.
     * @return The patch describing the difference between the original and revised sequences.
     * @param algorithm The diff algorithm.
     *   
     * @since 0.38.2
     */
    public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,
            algorithm: DiffAlgorithm<T>): Patch<T> where T <: Equal<T> & ToString{
        return algorithm.diff(original, revised)
    }

    /**
     * Computes the difference between the original and revised list of elements
     * with default diff algorithm
     * 
     * @param original The original text. 
     * @param revised The revised text.
     * @return The patch describing the difference between the original and revised sequences.
     * @param equalizer the equalizer object to replace the default compare algorithm
     * 
     * @since 0.38.2
     */
    public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,
            equalizer: Equalizer<T>): Patch<T> where T <: Equal<T> & ToString{
        return DiffUtils.diff(original, revised,MyersDiff<T>(equalizer))
    }

    /**
     * Patch the original text with given patch
     * 
     * @param original the original text
     * @param patch the given patch
     * @return the revised text
     *   
     * @since 0.39.3
     */
    public static func patch<T>(original: ArrayList<T>, patch: Patch<T>): ArrayList<T> 
            where T <: Equal<T> & ToString{
        return patch.applyTo(original)
    }

    /**
     * Unpatch the revised text for a given patch
     * 
     * @param revised the revised text
     * @param patch the given patch
     * @return the original text
     *   
     * @since 0.39.3
     */
    public static func unpatch<T>(revised: ArrayList<T>, patch: Patch<T>): ArrayList<T>
            where T <: Equal<T> & ToString{
        return patch.restore(revised)
    }

    /**
     * Parse the given text in unified format and creates the list of deltas for
     * it.
     * 
     * @param diff the text in unified format
     * @return the patch with deltas.
     *   
     * @since 0.39.3
     */
    public static func parseUnifiedDiff(diff: ArrayList<String>): Patch<String> {
        var inPrelude = true
        var rawChunk = ArrayList<Array<String>>()
        var patch = Patch<String>()

        var old_ln = 0
        var new_ln = 0
        var tag: String
        var rest: String

        for (line in diff) {
            // Skip leading lines until after we've seen one starting with '+++'
            if (inPrelude) {
                if (line.startsWith("+++")) { inPrelude = false }
                continue
            }
            var m = unifiedDiffChunkRe.find(line, group: true)

            if (let Some(v) <- m) {
                // Process the lines in the previous chunk
                if (rawChunk.size != 0) { extracted(rawChunk, patch, old_ln, new_ln) }
                //Parse the @@ header
                try {
                    old_ln =Int64.parse(v.matchString(1))
                } catch (e: Exception) {
                    old_ln = 1
                }
                try {
                    new_ln =Int64.parse(v.matchString(3))
                } catch (e: Exception) {
                    new_ln = 1
                }
                if (old_ln == 0) { old_ln += 1 }
                if (new_ln == 0) { new_ln += 1 }
            } 
            if (let None <- m) { checkval(rawChunk, line) }
        }

        // Process the lines in the last chunk
        if (rawChunk.size != 0) {
            var oldChunkLines = ArrayList<String>()
            var newChunkLines = ArrayList<String>()

            for (raw_line in rawChunk) {
                tag = raw_line[0]
                rest = raw_line[1]
                if (tag == (" ") || tag == ("-")) { oldChunkLines.add(rest) }
                if (tag == (" ") || tag == ("+")) { newChunkLines.add(rest) }
            }
            patch.addDelta(ChangeDelta<String>(Chunk<String>(old_ln - 1, oldChunkLines), Chunk<String>(new_ln - 1,newChunkLines)))
            rawChunk.clear()
        }

        return patch
    }

    private static func checkval(rawChunk: ArrayList<Array<String>>,  line: String) {
        var tag: String
        var rest: String
        if (line.size > 0) {
            tag = line[..1]
            rest = line[1..]
           if (tag == (" ") || tag == ("+") || tag == ("-")) { rawChunk.add([tag, rest]) }
        } else { 
            rawChunk.add([" ", ""])
        }
    }

    private static func extracted(rawChunk: ArrayList<Array<String>>,  patch: Patch<String>, old_ln: Int64, new_ln: Int64) {
        var tag: String
        var rest: String
        var oldChunkLines = ArrayList<String>()
        var newChunkLines = ArrayList<String>()

        for (raw_line in rawChunk) {
            tag = raw_line[0]
            rest = raw_line[1]
            if (tag == (" ") || tag == ("-")) { oldChunkLines.add(rest) }
            if (tag == (" ") || tag == ("+")) { newChunkLines.add(rest) }
        }
        patch.addDelta(ChangeDelta<String>(Chunk<String>( old_ln - 1, oldChunkLines), Chunk<String>(new_ln - 1, newChunkLines)))
        rawChunk.clear()
    }

    /**
     * generateUnifiedDiff takes a Patch and some other arguments, returning the
     * Unified Diff format text representing the Patch.
     * 
     * @param original Filename of the original (unrevised file)
     * @param revised Filename of the revised file
     * @param originalLines Lines of the original file
     * @param patch Patch created by the diff() function
     * @param contextSize - number of lines of context output around each difference in the file.
     * @return List of strings representing the Unified Diff representation of the Patch argument.
     *   
     * @since 0.39.3
     */
    public static func generateUnifiedDiff(original: String,
            revised: String, originalLines: ArrayList<String>, patch: Patch<String>,
            contextSize: Int64): ArrayList<String> {
        if (!patch.getDeltas().isEmpty()) {
            var ret = ArrayList<String>()
            ret.add("--- " + original)
            ret.add("+++ " + revised)

            var patchDeltas: ArrayList<Delta<String>> = ArrayList<Delta<String>>(
                    patch.getDeltas())

            // code outside the if block also works for single-delta issues.
            var deltas: ArrayList<Delta<String>> = ArrayList<Delta<String>>() // current
                                                                                                                        // list
                                                                                                                        // of
            // Delta's to
            // process
            var delta: Delta<String> = patchDeltas.get(0).getOrThrow()
            deltas.add(delta) // add the first Delta to the current set
            // if there's more than 1 Delta, we may need to output them together
            if (patchDeltas.size > 1) {
                var i = 1
                while (i < patchDeltas.size) {
                    var position = delta.getOriginal().getPosition() // store
                                                                                                // the
                                                                                                // current
                                                                                                // position
                                                                                                // of
                    // the first Delta

                    // Check if the next Delta is too close to the current
                    // position.
                    // And if it is, add it to the current set
                    var nextDelta: Delta<String> = patchDeltas.get(i).getOrThrow()
                    if ((position + delta.getOriginal().size() + contextSize) >= (nextDelta
                            .getOriginal().getPosition() - contextSize)) {
                        deltas.add(nextDelta)
                    } else {
                        // if it isn't, output the current set,
                        // then create a new set and add the current Delta to
                        // it.
                        var curBlock: ArrayList<String> = processDeltas(originalLines,
                                deltas, contextSize)
                        ret.add(all: curBlock)
                        deltas.clear()
                        deltas.add(nextDelta)
                    }
                    delta = nextDelta
                    i++
                }

            }
            // don't forget to process the last set of Deltas
            var curBlock: ArrayList<String> = processDeltas(originalLines, deltas,
                    contextSize)
            ret.add(all: curBlock)
            return ret
        }
        return ArrayList<String>()
    }

    /**
     * processDeltas takes a list of Deltas and outputs them together in a
     * single block of Unified-Diff-format text.
     * 
     * @param origLines - the lines of the original file
     * @param deltas - the Deltas to be output as a single block
     * @param contextSize - the number of lines of context to place around block
     * @return List of strings representing the Unified Diff representation of the Patch argument.
     *   
     * @since 0.39.3
     */
    private static func processDeltas(origLines: ArrayList<String>,
             deltas: ArrayList<Delta<String>>, contextSize: Int64): ArrayList<String> {
        var buffer =  ArrayList<String>()
        var origTotal: Int64 = 0 // counter for total lines output from Original
        var revTotal: Int64 = 0 // counter for total lines output from Original

        var curDelta: Delta<String> = deltas.get(0).getOrThrow()

        // NOTE: +1 to overcome the 0-offset Position
        var origStart = curDelta.getOriginal().getPosition() + 1 - contextSize

        var revStart = curDelta.getRevised().getPosition() + 1 - contextSize

        // find the start of the wrapper context code
        var contextStart = curDelta.getOriginal().getPosition() - contextSize
        (origStart,revStart,contextStart) = checkVal(origStart,revStart,contextStart)
        // output the context before the first Delta
        var line: Int64 = contextStart
        while (line < curDelta.getOriginal().getPosition()) { //
            buffer.add(" " + origLines.get(line).getOrThrow())
            origTotal++
            revTotal++
            line++
        }

        // output the first Delta
        buffer.add(all: getDeltaText(curDelta))
        origTotal += curDelta.getOriginal().getLines().size
        revTotal += curDelta.getRevised().getLines().size

        var deltaIndex = 1
        while (deltaIndex < deltas.size) { // for each of the other Deltas
            var nextDelta: Delta<String> = deltas.get(deltaIndex).getOrThrow()
            var intermediateStart = curDelta.getOriginal().getPosition()+ curDelta.getOriginal().getLines().size
            line = intermediateStart
            while ( line < nextDelta.getOriginal().getPosition() ) {
                // output the code between the last Delta and this one
                buffer.add(" " + origLines.get(line).getOrThrow())
                origTotal++
                revTotal++
                line++
            }
            buffer.add(all: getDeltaText(nextDelta)) // output the Delta
            origTotal += nextDelta.getOriginal().getLines().size
            revTotal += nextDelta.getRevised().getLines().size
            curDelta = nextDelta
            deltaIndex++
        }

        // Now output the post-Delta context code, clamping the end of the file
        contextStart = curDelta.getOriginal().getPosition()    + curDelta.getOriginal().getLines().size
        line = contextStart
        while ( (line < (contextStart + contextSize))&& (line < origLines.size)) {
            buffer.add(" " + origLines.get(line).getOrThrow())
            origTotal++
            revTotal++
            line++
        }

        // Create and insert the block header, conforming to the Unified Diff
        // standard
        var header = appendHeader(origStart,origTotal,revStart,revTotal)
        buffer.add(header.toString(), at: 0)
        return buffer
    }


    private static func appendHeader(origStart: Int64,origTotal: Int64,revStart: Int64,revTotal: Int64): StringBuilder{
        var header = StringBuilder()
        header.append("@@ -")
        header.append(origStart)
        header.append(",")
        header.append(origTotal)
        header.append(" +")
        header.append(revStart)
        header.append(",")
        header.append(revTotal)
        header.append(" @@")
        return header
    }

    private static func checkVal(origStart: Int64,revStart: Int64,contextStart: Int64): (Int64,Int64,Int64) {
        var val1: Int64 = origStart
        var val2: Int64 = revStart
        var val3: Int64 = contextStart
        if (val1 < 1) {
            val1 = 1
        }
        if (val2 < 1) {
            val2 = 1
        }
        if (val3 < 0) {
            val3 = 0 // clamp to the start of the file
        }
        return (val1,val2,val3)
    }

    /**
     * getDeltaText returns the lines to be added to the Unified Diff text from
     * the Delta parameter
     * 
     * @param delta  - the Delta to output
     * @return list of String lines of code.
     *   
     * @since 0.39.3
     */
    private static func getDeltaText(delta: Delta<String>): ArrayList<String> {
        var buffer: ArrayList<String> = ArrayList<String>()
        for (line in delta.getOriginal().getLines()) {
            buffer.add("-" + line)
        }
        for (line in delta.getRevised().getLines()) {
            buffer.add("+" + line)
        }
        return buffer
    }
}