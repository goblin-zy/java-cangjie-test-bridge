package cangjie_tpc::html4cj

@Test
public class ValidateTest {
    @TestCase
    public func testNotNull(): Unit {
        // 1
        Validate.notNull("foo")
        var threw: Bool = false
        try {
            Validate.notNull(Option<Any>.None)
        } catch (e: Exception) {
            threw = true
        }
        @Assert(threw, true)

        println("Pass1")
    }

    @TestCase
    public func stacktraceFiltersOutValidateClass(): Unit {
        // 2
        var threw1: Bool = false
        try {
            Validate.notNull(Option<Any>.None)
        } catch (e: ValidationException) {
            threw1 = true
            @Assert(e.message, "Object must not be null")
        }
        @Assert(threw1, true)

        println("Pass2")
    }

    @TestCase
    public func nonnullParam(): Unit {
        // 3
        try {
            Validate.notNullParam(Option<Any>.None, "foo")
        } catch (e: ValidationException) {
            @Assert(e.message, "The parameter 'foo' must not be null.")
        }

        println("Pass3")
    }

    @TestCase
    public func isFalseTest(): Unit {
        // 4
        try {
            Validate.isFalse(true)
        } catch (e: ValidationException) {
            @Assert(e.message, "Must be false")
        }
        try {
            Validate.isFalse(true, "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "error")
        }

        println("Pass4")
    }

    @TestCase
    public func isTrueTest(): Unit {
        // 5
        try {
            Validate.isTrue(false)
        } catch (e: ValidationException) {
            @Assert(e.message, "Must be true")
        }
        try {
            Validate.isTrue(false, "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "error")
        }

        println("Pass5")
    }

    @TestCase
    public func noNullElementsTest(): Unit {
        // 6
        var obj: Array<?Object> = [Attributes()]
        Validate.noNullElements(obj)
        var obj1: Array<?Object> = [None]
        try {
            Validate.noNullElements(obj1)
        } catch (e: ValidationException) {
            @Assert(e.message, "Array must not contain any null objects")
        }

        println("Pass6")
    }

    @TestCase
    public func noNullElements1Test(): Unit {
        // 7
        try {
            Validate.notEmptyParam(None, "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "The 'error' parameter must not be empty.")
        }
        try {
            Validate.notEmptyParam("", "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "The 'error' parameter must not be empty.")
        }
        Validate.notEmptyParam("ssss", "error")

        println("Pass7")
    }

    @TestCase
    public func notEmptyTest(): Unit {
        // 8
        try {
            Validate.notEmpty(None, "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "error")
        }
        try {
            Validate.notEmpty("", "error")
        } catch (e: ValidationException) {
            @Assert(e.message, "error")
        }
        Validate.notEmptyParam("ssss", "error")

        println("Pass8")
    }

    @TestCase
    public func wtfTest(): Unit {
        // 9
        try {
            Validate.wtf("error")
        } catch (e: Exception) {
            @Assert(e.message, "IllegalStateException : error")
        }

        println("Pass9")
    }

    @TestCase
    public func failTest(): Unit {
        // 10
        try {
            Validate.fail("error")
        } catch (e: ValidationException) {
            @Assert(e.message, "error")
        }

        println("Pass10")
    }

    @TestCase
    public func notNullTest(): Unit {
        // 11
        var attr: Attribute = Attribute("key", "value &")
        Validate.notNull(attr, "error")
        var threw: Bool = false
        try {
            Validate.notNull(Option<Any>.None, "error")
        } catch (e: ValidationException) {
            threw = true
            @Assert(e.message, "error")
        }
        @Assert(threw, true)

        println("Pass11")
    }

    @TestCase
    public func ensureNotNullTest(): Unit {
        // 12
        var attr: Attribute = Attribute("key", "value &")
        Validate.ensureNotNull(attr)
        var threw: Bool = false
        try {
            Validate.ensureNotNull(Option<Any>.None)
        } catch (e: ValidationException) {
            threw = true
            @Assert(e.message, "Object must not be null")
        }
        @Assert(threw, true)

        println("Pass12")
    }
}
