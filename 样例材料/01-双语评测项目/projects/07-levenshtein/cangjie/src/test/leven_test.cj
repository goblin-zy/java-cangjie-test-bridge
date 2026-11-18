package leven4cj.test

import std.unittest.*
import std.unittest.testmacro.*
import leven4cj.*

@Test
class levenTest {
    @TestCase
    func test() {
        @Assert(leven("123","123"),0)
        @Assert(leven("","123asd"),6)
        @Assert(leven("123asd",""),6)

        @Assert(leven("a","b"),1)
        @Assert(leven("ab","ac"),1)
        @Assert(leven("ac","bc"),1)
        @Assert(leven("abc","axc"),1)
        @Assert(leven("kitten","sitting"),3)
        @Assert(leven("xabxcdxxefxgx","1ab2cd34ef5g6"),6)
        @Assert(leven("cat", "cow"), 2)
        @Assert(leven("xabxcdxxefxgx", "abcdefg"), 6)
        @Assert(leven("javawasneat", "scalaisgreat"), 7)
        @Assert(leven("example", "samples"), 3)
        @Assert(leven("sturgeon", "urgently"), 6)
        @Assert(leven("levenshtein", "frankenstein"), 6)
        @Assert(leven("distance", "difference"), 5)

        @Assert(leven("因为我是中国人所以我会说中文", "因为我是英国人所以我会说英文"), 2)
        @Assert(leven("hello你好","helle我好"),2)
    }
}
