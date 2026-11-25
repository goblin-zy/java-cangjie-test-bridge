# 本轮接口前提与实际源码证据

Java List<String>适配为ArrayList<String>，DiffUtils.diff仍调用实际目标业务。

目标Patch为非空引用类型，显式Patch类型检查对应原非空检查；未用常量或替代业务生成结果。

InsertDelta/DeleteDelta/ChangeDelta均为未声明open的最终类，因此is类型检查与源getClass的精确类型要求在本轮对应。

Chunk相等检查调用实际Chunk.equals，保留行列表与位置两部分。

testDiff_Insert：保留hhh到hhh/jjj/kkk的输入；五项检查分别对应非空Patch、单个差异、最终类InsertDelta及位置1的原/新Chunk内容。

testDiff_Delete：保留ddd/fff/ggg到ggg的输入；五项检查分别对应非空Patch、单个差异、最终类DeleteDelta及位置0的原/新Chunk内容。

testDiff_Change：保留aaa/bbb/ccc到aaa/zzz/ccc的输入；五项检查分别对应非空Patch、单个差异、最终类ChangeDelta及位置1的bbb到zzz的Chunk。

diffutils.cj SHA-256=8b6c51547dba1b9b5156240af7419b10781de90bcb0a1c07d599f95180a98dda

```cangjie

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

```

patch.cj SHA-256=bf38d6f130f132c1dcead038831c3845566b44c129a3704ec41039081ccc42fb

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*
import std.sort.*

/**
 * Describes the patch holding all deltas between the original and revised texts.
 */
public class Patch<T> where T <: Equal<T> & ToString {
    private var deltas:  ArrayList<Delta<T>> = ArrayList<Delta<T>>()

    /**
     * Set the deltas
     *
     * @Param set the deltas
     *
     * @since 0.38.2
     */
    public func addDelta(delta: Delta<T>): Unit {
        deltas.add(delta)
    }

    /**
     * Returns the deltas
     *
     * @return the deltas
     *
     * @since 0.38.2
     */
    public func getDeltas(): ArrayList<Delta<T>> {
        sort(deltas, by: DeltaComparator<T>.deltaComparator, descending: false)
        return deltas
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): ArrayList<T> {
        var result: ArrayList<T> =  ArrayList<T>(target)
        var deltas = getDeltas()
        var size = deltas.size
        while (size > 0) {
            deltas[size-1].applyTo(result)
            size --
        }
        return result
    }

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): ArrayList<T> {
        var result: ArrayList<T> =  ArrayList<T>(target)
        var deltas = getDeltas()
        var size = deltas.size
        while (size > 0) {
            deltas[size-1].restore(result)
            size --
        }
        return result
    }
}


```

delta.cj SHA-256=7d4051560096af7c3f9c8102cce57967850814b549be1fdf716841b443610475

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

public abstract class Delta<T> where T <: Equal<T> & ToString {
    /** The original chunk. */
    private var original: Chunk<T>
    /** The revised chunk. */
    private var revised: Chunk<T>

    /**
     * Creates a delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T>) {
        this.original = original;
        this.revised = revised;
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType

    /**
     * Returns the getOriginal
     *
     * @return the getOriginal
     *
     * @since 0.38.2
     */
    public func getOriginal(): Chunk<T> {
        return original;
    }
    
    /**
     * Set the getOriginal
     *
     * @Param set the Original
     *
     * @since 0.38.2
     */
    public func setOriginal(original: Chunk<T>): Unit {
        this.original = original;
    }

    /**
     * Returns the Revised
     *
     * @return the Revised
     *
     * @since 0.38.2
     */
    public func getRevised(): Chunk<T> {
        return revised
    }
    
    /**
     * Set the getRevised
     *
     * @Param set the Revised
     *
     * @since 0.38.2
     */
    public func setRevised(revised: Chunk<T>) {
        this.revised = revised
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit

    /**
     * Returns is the Delta are same
     *
     * @return the Bool
     *
     * @since 0.39.3
     */
    public func equals(obj: Delta<T>): Bool {
        if(refEq(this, obj)) {
            return true
        }
        var other: Delta<T> = obj
        if (!original.equals(other.original)) {
            return false
        }
        if (!revised.equals(other.revised)) {
            return false
        }
        return true
    }
}

public enum DeltaType {
    /** A change in the original. */
    | CHANGE
    /** A delete from the original. */
    | DELETE
    /** An insert into the original. */
    | INSERT
}

```

chunk.cj SHA-256=1fea5e1de4d160e834e3eea46ee01e5ec4846f488baa310be5d3b6a71218d4af

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Holds the information about the part of text involved in the diff process
 */
public class Chunk<T> where T <: Equal<T> & ToString {
    private var position: Int64
    private var lines: ArrayList<T>
    
    /**
     * Creates a chunk and saves a copy of affected lines
     * 
     * @param position the start position
     * @param lines the affected lines
     *
     * @since 0.38.2
     */
    public init(position: Int64, lines: ArrayList<T>) {
        this.position = position
        this.lines = lines
    }
    
    /**
     * Creates a chunk and saves a copy of affected lines
     * 
     * @param position the start position
     * @param lines the affected lines
     *
     * @since 0.38.2
     */
    public init(position: Int64, lines: Array<T>) {
        this.position = position
        this.lines = ArrayList<T>(lines)
    }
    
    /**
     * Returns the Position
     *
     * @return the Position
     *
     * @since 0.38.2
     */
    public func getPosition(): Int64 {
        return position
    }

    /**
     * Set the Lines
     *
     * @param set the Lines
     *
     * @since 0.38.2
     */
    public func setLines(lines: ArrayList<T>): Unit {
        this.lines = lines
    }

    /**
     * Returns the Lines
     *
     * @return the Lines
     *
     * @since 0.38.2
     */
    public func getLines(): ArrayList<T> {
        return lines
    }

    /**
     * Returns the Line size
     *
     * @return the size
     *
     * @since 0.38.2
     */
    public func size(): Int64 {
        return lines.size
    }
    
    /**
     * Returns the last position
     *
     * @return the last position
     *
     * @since 0.38.2
     */
    public func last(): Int64 {
        return getPosition() + size() - 1
    }
    
    /**
     * Returns is the Chunk are same
     *
     * @return the Bool
     *
     * @since 0.38.2
     */
    public func equals(obj: Chunk<T>): Bool {
        if (lines.isEmpty()) {
            if (!obj.lines.isEmpty()) {
                return false
            }
        } else if ( obj.lines.size != lines.size) {
            return false
        } else {
            var i = obj.lines.size - 1
            while( i>=0 ) {
                if (!(lines[i] == obj.lines[i])) {
                    return false
                }
                i--
            }
        }
        if (position != obj.position) {
            return false
        }
        return true
    }
    
    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[position: ${position}" + ", size: ${size()}" + ", lines: ${lines.toString()}" + "]"
    }

    /**
     * Verifies that this chunk's saved text matches the corresponding text in
     * the given sequence.
     * 
     * @param target the sequence to verify against.
     *
     * @since 0.38.2
     */
    public func verify(target: ArrayList<T>): Unit{
        if (last() > target.size) {
            throw PatchFailedException("Incorrect Chunk, the position of chunk > target size");
        }
        var i = 0
        while (i < size()) {
            if (!(target.get(position + i).getOrThrow()==(lines.get(i).getOrThrow()))) {
                throw PatchFailedException(
                        "Incorrect Chunk, the chunk content doesn't match the target");
            }
            i++
        }
    }
}

```

insert_delta.cj SHA-256=7c946ea3f8687f7d2f001b4fb9646359344e3f229b54650dae142f449b9cb9ba

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Describes the insert-delta between original and revised texts.
 */
public class InsertDelta<T> <: Delta<T> where T <: Equal<T> & ToString{
    /**
     * Creates a insert delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T> ) {
        super(original, revised);
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType {
        return  DeltaType.INSERT
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit {
        verify(target)
        var position: Int64 = getOriginal().getPosition()
        var lines: ArrayList<T> = this.getRevised().getLines()
        var i: Int64 = 0
        while (i < lines.size) {
            target.add(lines.get(i).getOrThrow(), at: position + i)
            i++
        }
    }

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit {
        var position: Int64 = getRevised().getPosition()
        var size: Int64 = getRevised().size()
        var i: Int64 = 0
        try {
            while (i < size) {
                target.remove(at: position)
                i++
            }
        } catch(e: IndexOutOfBoundsException) {
            throw DiffException("the position of chunk < 0")
        }
    }

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit {
        if (getOriginal().getPosition() > target.size) {
            throw PatchFailedException("Incorrect patch for delta, " + "delta original position > target size");
        }
    }

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[InsertDelta, position: ${getOriginal().getPosition()}" + ", lines: ${getRevised().getLines()}" + "]"
    }
}


```

delete_delta.cj SHA-256=bcd0063059a1c8d08a1f99f75f0629d0fb67d7ff5a7252bba907e42d0998b531

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Describes the insert-delta between original and revised texts.
 */
public class DeleteDelta<T> <:  Delta<T> where T <: Equal<T> & ToString {
    /**
     * Creates a delete delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T> ) {
        super(original, revised);
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType {
        return  DeltaType.DELETE
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit {
        verify(target)
        var position: Int64 = getOriginal().getPosition()
        var size: Int64 = getOriginal().size()
        var i: Int64 = 0
        while (i < size) {
            target.remove(at: position)
            i++
        }
    }

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit {
        var position: Int64 = getRevised().getPosition()
        var lines: ArrayList<T> = this.getOriginal().getLines()
        var i: Int64 = 0
        try {
            while (i < lines.size) {
                target.add(lines.get(i).getOrThrow(), at: position + i)
                i++
            }
        } catch(e: IndexOutOfBoundsException) {
            throw DiffException("the position of chunk < 0")
        }
    }

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit {
        getOriginal().verify(target)
    }

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[DeleteDelta, position: ${getOriginal().getPosition()}" + ", lines: ${getOriginal().getLines()}" + "]"
    }
}

```

change_delta.cj SHA-256=098578562751bbe788b5e4166a2164ddf8a0434cad9751dc5c5b9a3623fe1aba

```cangjie

/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

import std.collection.*

/**
 * Describes the change-delta between original and revised texts.
 */
public class ChangeDelta<T> <:  Delta<T> where T <: Equal<T> & ToString {
    
    /**
     * Creates a change delta with the two given chunks.
     * 
     * @param original The original chunk. 
     * @param revised The original chunk.
     * 
     * @since 0.38.2
     */
    public init(original: Chunk<T>, revised: Chunk<T> ) {
        super(original, revised);
    }

    /**
     * Returns the type of delta
     *
     * @return the type enum
     *
     * @since 0.38.2
     */
    public func getType(): DeltaType {
        return  DeltaType.CHANGE
    }

    /**
     * Applies this delta as the patch for a given target
     * 
     * @param target the given target
     *
     * @since 0.39.3
     */
    public func applyTo(target: ArrayList<T>): Unit {
        verify(target)
        var position: Int64 = getOriginal().getPosition()
        var size: Int64 = getOriginal().size()
        var i: Int64 = 0
        while (i < size) {
            target.remove(at: position)
            i++
        }
        i = 0;
        for (line in getRevised().getLines()) {
            target.add(line, at: position + i)
            i++
        }
    }

    /**
     * Cancel this delta for a given revised text. The action is opposite to
     * patch.
     * 
     * @param target the given revised text
     *
     * @since 0.39.3
     */
    public func restore(target: ArrayList<T>): Unit {
        var position: Int64 = getRevised().getPosition()
        var size: Int64 = getRevised().size()
        var i: Int64 = 0
        try {
            while (i < size) {
                if (position < target.size) {
                    target.remove(at: position)
                } else {
                    break
                }
                i++
            }
            i = 0
            for (line in getOriginal().getLines()) {
                if ((position + i) == target.size) {
                    target.add(line)
                } else {
                    target.add(line, at: position + i)
                }
                i++
            }
        } catch(e: IndexOutOfBoundsException) {
            throw DiffException("the position of chunk < 0")
        }
    }

    /**
     * Verifies that this delta can be used to patch the given text.
     * 
     * @param target the text to patch.
     *
     * @since 0.39.3
     */
    public func verify(target: ArrayList<T>): Unit {
        getOriginal().verify(target)
        if (getOriginal().getPosition() > target.size) {
            throw PatchFailedException("Incorrect patch for delta, " + "delta original position > target size")
        }
    }

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.38.2
     */
    public func toString(): String {
        return "[ChangeDelta, position: ${getOriginal().getPosition()}" + ", lines: ${getOriginal().getLines()}" + " to ${getRevised().getLines()}" + "]"
    }

}

```