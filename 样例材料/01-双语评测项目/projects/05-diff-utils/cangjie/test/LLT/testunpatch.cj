// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let unpatchTest = unpatchTest()
    unpatchTest.unpatchTest01()
    unpatchTest.unpatchTest02()
    unpatchTest.unpatchTest03()
    unpatchTest.unpatchTest04()
    return 0
}

@Test
public class unpatchTest {
    
    @TestCase
    public func unpatchTest01(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kk"])
        var orig= ArrayList<String>(["aaa", "jjj", "kk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.unpatch(orig,patch)
        println(res)
        @Assert(res,rev)
    }

    @TestCase
    public func unpatchTest02(): Unit {
        var rev = ArrayList<String>(["hhh"])
        var orig= ArrayList<String>(["hhh", "jjj", "kkk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.unpatch(orig,patch)
        println(res)
        @Assert(res,rev)
    }

    @TestCase
    public func unpatchTest03(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kkk"])
        var orig= ArrayList<String>()
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.unpatch(orig,patch)
        println(res)
        @Assert(res,rev)
    }

    @TestCase
    public func unpatchTest04(): Unit {
        var rev = ArrayList<String>(["hhh", "jjj", "kk"])
        var orig= ArrayList<String>(["asdas", "jjj", "kkk","kk"])
        var patch:  Patch<String>= DiffUtils.diff(rev, orig)
        var res = DiffUtils.unpatch(orig,patch)
        println(res)
        @Assert(res,rev)
    }
}