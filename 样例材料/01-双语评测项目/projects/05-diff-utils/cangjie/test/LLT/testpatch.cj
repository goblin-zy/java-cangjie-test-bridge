// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let patchTest = patchTest()
    patchTest.patchTest01()
    patchTest.patchTest02()
    patchTest.patchTest03()
    patchTest.patchTest04()
    patchTest.patchTest05()
    return 0
}

@Test
public class patchTest {
    
    @TestCase
    public func patchTest01(): Unit {
        var rev = ArrayList<String>(["hhh"])
        var orig= ArrayList<String>(["hhh", "jjj", "kkk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.patch(rev,patch )
        @Assert(res,orig)
    }

    @TestCase
    public func patchTest02(): Unit {
        var rev = ArrayList<String>()
        var orig= ArrayList<String>(["hhh", "jjj", "kkk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.patch(rev,patch)
        @Assert(res,orig)   
    }

    @TestCase
    public func patchTest03(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kkk"])
        var orig= ArrayList<String>()
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.patch(rev,patch)
        @Assert(res,orig)
    }

    @TestCase
    public func patchTest04(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kk"])
        var orig= ArrayList<String>(["asdas", "jjj", "kkk","kk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.patch(rev,patch)
        @Assert(res,orig)
    }

    @TestCase
    public func patchTest05(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kk","uiqywe"])
        var orig= ArrayList<String>(["asdas", "jjj", "kkk","kk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.patch(rev,patch)
        @Assert(res,orig)
    }
}