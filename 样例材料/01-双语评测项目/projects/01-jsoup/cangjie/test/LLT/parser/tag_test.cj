// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let tester = TagTest()

    tester.isCaseSensitive()
    tester.canBeInsensitive()
    tester.trims()
    tester.equality()
    tester.divSemantics()
    tester.pSemantics()
    tester.imgSemantics()
    tester.defaultSemantics()
    tester.valueOfChecksNotEmpty()
    tester.knownTags()
    tester.initTest()

    0
}

@Test
public class TagTest {
    @TestCase
    public func isCaseSensitive(): Unit {
        // 1
        let p1: Tag = Tag.valueOf("P")
        let p2: Tag = Tag.valueOf("p")
        @Assert(refEq(p1, p2), false)

        println("Pass1")
    }

    @TestCase
    public func canBeInsensitive(): Unit {
        // 2
        let script1: Tag = Tag.valueOf("script", ParseSettings.htmlDefault)
        let script2: Tag = Tag.valueOf("SCRIPT", ParseSettings.htmlDefault)
        @Assert(script1 == script2)

        println("Pass2")
    }

    @TestCase
    public func trims(): Unit {
        // 3
        let p1: Tag = Tag.valueOf("p")
        let p2: Tag = Tag.valueOf(" p ")
        @Assert(p1 == p2)

        println("Pass3")
    }

    @TestCase
    public func equality(): Unit {
        // 4
        let p1: Tag = Tag.valueOf("p")
        let p2: Tag = Tag.valueOf("p")
        @Assert(p1 == p2)
        @Assert(refEq(p1, p2))

        println("Pass4")
    }

    @TestCase
    public func divSemantics(): Unit {
        // 5
        let div: Tag = Tag.valueOf("div")
        @Assert(div.isBlock())
        @Assert(div.formatAsBlock())

        println("Pass5")
    }

    @TestCase
    public func pSemantics(): Unit {
        // 6
        let p: Tag = Tag.valueOf("p")
        @Assert(p.isBlock())
        @Assert(p.formatAsBlock(), false)

        println("Pass6")
    }

    @TestCase
    public func imgSemantics(): Unit {
        // 7
        let img: Tag = Tag.valueOf("img")
        @Assert(img.isInline())
        @Assert(img.isSelfClosing())
        @Assert(img.isBlock(), false)

        println("Pass7")
    }

    @TestCase
    public func defaultSemantics(): Unit {
        // 8
        // not defined
        let foo: Tag = Tag.valueOf("FOO")
        let foo2: Tag = Tag.valueOf("FOO")
        @Assert(foo == foo2)
        @Assert(foo.isInline())
        @Assert(foo.formatAsBlock())

        println("Pass8")
    }

    @TestCase
    public func valueOfChecksNotEmpty(): Unit {
        // 9
        var isBool = false
        try {
            Tag.valueOf(" ")
        } catch (e: ValidationException) {
            (e)
            isBool = true
        }
        @Assert(isBool, true)

        println("Pass9")
    }

    @TestCase
    public func knownTags(): Unit {
        // 10
        @Assert(Tag.checkKnownTag("div"))
        @Assert(Tag.checkKnownTag("explain"), false)

        println("Pass10")
    }

    @TestCase
    public func initTest(): Unit {
        // 11
        let foo1: Tag = Tag.valueOf("FOO")
        let foo2: Tag = Tag.valueOf("FOO")
        @Assert(foo1.hashCode(), foo2.hashCode())
        @Assert(false, foo2.isEmpty())
        @Assert(false, foo2.isKnownTag())
        @Assert(false, foo2.preserveWhitespace())
        @Assert(false, foo2.isFormListed())
        @Assert(false, foo2.isFormSubmittable())

        // foo2.setSelfClosing()
        // @Assert(foo1.hashCode() == foo2.hashCode(), false)
        println("Pass11")
    }
}
