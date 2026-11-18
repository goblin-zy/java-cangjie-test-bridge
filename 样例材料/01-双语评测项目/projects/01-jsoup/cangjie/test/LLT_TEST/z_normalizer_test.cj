package cangjie_tpc::html4cj

@Test
public class NormalizerTest {
    @TestCase
    public func lowerCaseTest(): Unit {
        Normalizer()
        var s1 = " ASDF "
        var s2 = " ASdf "
        var s3 = " 你好Sf "
        var s4 = "fgH"
        var s5 = "fgh"
        var s6 = "  f gh  "
        var s7 = "  f g h  "
        var s8 = "  f g h  \n"
        @Assert(" asdf ", Normalizer.lowerCase(s1))
        @Assert(" asdf ", Normalizer.lowerCase(s2))
        @Assert(" 你好sf ", Normalizer.lowerCase(s3))
        @Assert("fgh", Normalizer.lowerCase(s4))
        @Assert("fgh", Normalizer.lowerCase(s5))
        @Assert("  f gh  ", Normalizer.lowerCase(s6))
        @Assert("  f g h  ", Normalizer.lowerCase(s7))
        @Assert("  f g h  \n", Normalizer.lowerCase(s8))
    }

    @TestCase
    public func normalizeTest(): Unit {
        var s1 = " ASDF "
        var s2 = " ASdf "
        var s3 = " 你好Sf "
        var s4 = "fgH"
        var s5 = "fgh"
        var s6 = "  f gh  "
        var s7 = "  f g h  "
        var s8 = "  f g h  \n"
        @Assert("asdf", Normalizer.normalize(s1))
        @Assert("asdf", Normalizer.normalize(s2))
        @Assert("你好sf", Normalizer.normalize(s3))
        @Assert("fgh", Normalizer.normalize(s4))
        @Assert("fgh", Normalizer.normalize(s5))
        @Assert("f gh", Normalizer.normalize(s6))
        @Assert("f g h", Normalizer.normalize(s7))
        @Assert("f g h", Normalizer.normalize(s8))
    }

    @TestCase
    public func normalize2Test(): Unit {
        var s1 = " ASDF "
        var s2 = " ASdf "
        var s3 = " 你好Sf "
        var s4 = "fgH"
        var s5 = "fgh"
        var s6 = "  f gh  "
        var s7 = "  f g h  "
        var s8 = "  f g h  \n"
        @Assert(" asdf ", Normalizer.normalize(s1, true))
        @Assert(" asdf ", Normalizer.normalize(s2, true))
        @Assert(" 你好sf ", Normalizer.normalize(s3, true))
        @Assert("fgh", Normalizer.normalize(s4, true))
        @Assert("fgh", Normalizer.normalize(s5, true))
        @Assert("  f gh  ", Normalizer.normalize(s6, true))
        @Assert("  f g h  ", Normalizer.normalize(s7, true))
        @Assert("  f g h  \n", Normalizer.normalize(s8, true))
        @Assert("asdf", Normalizer.normalize(s1, false))
        @Assert("asdf", Normalizer.normalize(s2, false))
        @Assert("你好sf", Normalizer.normalize(s3, false))
        @Assert("fgh", Normalizer.normalize(s4, false))
        @Assert("fgh", Normalizer.normalize(s5, false))
        @Assert("f gh", Normalizer.normalize(s6, false))
        @Assert("f g h", Normalizer.normalize(s7, false))
        @Assert("f g h", Normalizer.normalize(s8, false))
    }
}
