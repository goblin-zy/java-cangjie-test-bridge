package diffUtils4cj
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*


@Test
class DiffTranslationTest {

    @TestCase
    func testDiff_Insert(): Unit {
        let patch = DiffUtils.diff<String>(ArrayList<String>(["hhh"]), ArrayList<String>(["hhh", "jjj", "kkk"]))
        @Assert(patch is Patch<String>)
        @Assert(Int64(1), patch.getDeltas().size)
        let delta = patch.getDeltas()[0]
        @Assert(delta is InsertDelta<String>)
        @Assert(Chunk<String>(1, ArrayList<String>()).equals(delta.getOriginal()))
        @Assert(Chunk<String>(1, ArrayList<String>(["jjj", "kkk"])).equals(delta.getRevised()))
    }
    @TestCase
    func testDiff_Delete(): Unit {
        let patch = DiffUtils.diff<String>(ArrayList<String>(["ddd", "fff", "ggg"]), ArrayList<String>(["ggg"]))
        @Assert(patch is Patch<String>)
        @Assert(Int64(1), patch.getDeltas().size)
        let delta = patch.getDeltas()[0]
        @Assert(delta is DeleteDelta<String>)
        @Assert(Chunk<String>(0, ArrayList<String>(["ddd", "fff"])).equals(delta.getOriginal()))
        @Assert(Chunk<String>(0, ArrayList<String>()).equals(delta.getRevised()))
    }
    @TestCase
    func testDiff_Change(): Unit {
        let before = ArrayList<String>(["aaa", "bbb", "ccc"])
        let after = ArrayList<String>(["aaa", "zzz", "ccc"])
        let patch = DiffUtils.diff<String>(before, after)
        @Assert(patch is Patch<String>)
        @Assert(Int64(1), patch.getDeltas().size)
        let delta = patch.getDeltas()[0]
        @Assert(delta is ChangeDelta<String>)
        @Assert(Chunk<String>(1, ArrayList<String>(["bbb"])).equals(delta.getOriginal()))
        @Assert(Chunk<String>(1, ArrayList<String>(["zzz"])).equals(delta.getRevised()))
    }
}
