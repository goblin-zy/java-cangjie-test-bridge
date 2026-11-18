// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let test = StringTest()
    test.stringTest01()
    test.stringTest02()
    test.stringTest03()
    test.stringTest04()
    test.stringTest05()
    test.stringTest06()
    test.stringTest07()
    return 0
}

@Test
public class StringTest {
    
    @TestCase
    public func stringTest01(): Unit {
        var arr = ArrayList<String>([" ","","test1","test2"])
        var res = StringUtills.join(arr, "/")
        @Assert(res," //test1/test2")
    }

    @TestCase
    public func stringTest02(): Unit {
        var res = StringUtills.expandTabs("te\tst")
        @Assert(res,"te    st")
    }

    @TestCase
    public func stringTest03(): Unit {
        var res = StringUtills.htmlEntites("<span>")
        @Assert(res,"&lt;span&gt;")
    }

    @TestCase
    public func stringTest04(): Unit {
        var res = StringUtills.normalize("<s\tpan>\t")
        @Assert(res,"&lt;s    pan&gt;    ")
    }

    @TestCase
    public func stringTest05(): Unit {
        var arr = ArrayList<String>([" ","","<te\tst1","test2>"])
        var res = StringUtills.normalize(arr)
        @Assert(res.toString(),"[ , , &lt;te    st1, test2&gt;]")
    }

    @TestCase
    public func stringTest06(): Unit {
        var res = StringUtills.wrapText("terasdlkahsd",5)
        @Assert(res.toString(),"teras<br>dlkah<br>sd")
    }

    @TestCase
    public func stringTest07(): Unit {
        var arr = ArrayList<String>([" ","","test1","test2"])
        var res = StringUtills.wrapText(arr,1)
        @Assert(res.toString(),"[ , , t<br>e<br>s<br>t<br>1, t<br>e<br>s<br>t<br>2]")
    }
}