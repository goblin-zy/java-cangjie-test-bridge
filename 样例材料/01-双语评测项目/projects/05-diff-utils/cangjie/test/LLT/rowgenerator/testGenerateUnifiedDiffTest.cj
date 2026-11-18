// DEPENDENCE: ./original.txt
// DEPENDENCE: ./revised.txt
// DEPENDENCE: ./a.txt
// DEPENDENCE: ./b.txt
// DEPENDENCE: ./one_delta_test_original.txt
// DEPENDENCE: ./one_delta_test_revised.txt
// DEPENDENCE: ./issue10_base.txt
// DEPENDENCE: ./issue10_patch.txt
// DEPENDENCE: ./issue11_1.txt
// DEPENDENCE: ./issue11_2.txt
// DEPENDENCE: ./5A.txt
// DEPENDENCE: ./5B.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.io.*
import std.fs.*
import std.unittest.*
import std.unittest.testmacro.*


main(): Int64 {
    let test = UnifiedTest()
    test.testGenerateUnified()
    test.testGenerateUnified2()
    test.testGenerateUnifiedWithOneDelta()
    test.testGenerateUnifiedDiffWithoutAnyDeltas()
    test.testDiff_Issue10()
    test.testPatchWithNoDeltas()
    test.testDiff5()
    test.testDiffWithHeaderLineInText()
    return 0
}

@Test
public class UnifiedTest {

    @TestCase
    public func testGenerateUnified() {
        var origLines = fileToLines("./a.txt")
        var revLines = fileToLines("./b.txt")
        verify(origLines, revLines, "./a.txt", "./b.txt")
    }

    @TestCase
    public func testGenerateUnified2() {
        var origLines = fileToLines("./original.txt")
        var revLines = fileToLines("./revised.txt")
        verify(origLines, revLines, "./original.txt", "./revised.txt")
    }

    @TestCase
    public func testGenerateUnifiedWithOneDelta() {
        var origLines = fileToLines("./one_delta_test_original.txt")
        var revLines = fileToLines("./one_delta_test_revised.txt")
        verify(origLines, revLines, "./one_delta_test_original.txt", "./one_delta_test_revised.txt")
    }

    @TestCase
    public func testGenerateUnifiedDiffWithoutAnyDeltas() {
        var test: ArrayList<String> = ArrayList<String>(["abc"])
        var patch = DiffUtils.diff(test, test)
        DiffUtils.generateUnifiedDiff("abc", "abc", test, patch, 0)
    }

    @TestCase
    public func testDiff_Issue10() {
        var baseLines = fileToLines("./issue10_base.txt")
        var patchLines = fileToLines("./issue10_patch.txt")
        var p = DiffUtils.parseUnifiedDiff(patchLines);
        try {
            DiffUtils.patch(baseLines, p)
        } catch (e: PatchFailedException) {
            println(e.message)
        }
    }

    @TestCase
    public func testPatchWithNoDeltas() {
        var lines1 = fileToLines("./issue11_1.txt")
        var lines2 = fileToLines("./issue11_2.txt")
        verify(lines1, lines2, "issue11_1.txt", "issue11_2.txt")
    }

    @TestCase
    public func testDiff5() {
        var lines1= fileToLines("./5A.txt");
        var lines2= fileToLines( "./5B.txt");
        verify(lines1, lines2, "5A.txt", "5B.txt");
    }

    @TestCase
    public func testDiffWithHeaderLineInText() {
        var original = ArrayList<String>()
        var revised  = ArrayList<String>()

        original.add("test line1")
        original.add("test line2")
        original.add("test line 4")
        original.add("test line 5")

        revised.add("test line1")
        revised.add("test line2")
        revised.add("@@ -2,6 +2,7 @@")
        revised.add("test line 4")
        revised.add("test line 5")

        var patch:Patch<String> = DiffUtils.diff(original, revised);
        var udiff = DiffUtils.generateUnifiedDiff("original", "revised",
                original, patch, 10);
        DiffUtils.parseUnifiedDiff(udiff)
    }

    private func fileToLines(filename: String): ArrayList<String> {
        var lines =  ArrayList<String>()
        try {
            var reader = StringReader(File(filename, OpenMode.Read))
            while(true) {
                match (reader.readln()) {
                    case Some(v) => lines.add(v)
                    case None => break
                }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return lines
    }

    private func verify(origLines: ArrayList<String>, revLines: ArrayList<String>,originalFile: String, revisedFile: String): Unit {
        var patch: Patch<String> = DiffUtils.diff(origLines, revLines);
        var unifiedDiff: ArrayList<String> = DiffUtils.generateUnifiedDiff(originalFile, revisedFile,origLines, patch, 10)
        var fromUnifiedPatch: Patch<String> = DiffUtils.parseUnifiedDiff(unifiedDiff)
        var patchedLines: ArrayList<String>
        patchedLines = fromUnifiedPatch.applyTo(origLines)
        @Assert(patchedLines,revLines)
        var i = 0
        while (i < revLines.size) {
            var l1 = revLines.get(i).getOrThrow()
            var l2 = patchedLines.get(i).getOrThrow()
            if (!(l1 == l2)) {
                println("Line ${(i + 1)}" + " of the patched file did not match the revised original")
            }
            i++
        }
    }
}