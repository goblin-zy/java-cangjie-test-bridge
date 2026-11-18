package cjmustache.test

import cjmustache.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*

@Test
public class helpersTest {
    private var str1 = "Hello, "
    private var str2 = "World"
    private var str3 = "!!!!!"
    @TestCase
    public func appendOrWriteTest1() {
        let sb = StringBuilder(str1)
        appendOrWrite(sb, None, str2)
        @Expect(sb.toString(), "Hello, World")

        appendOrWrite(sb, None, str3, 0, 3)
        @Expect(sb.toString(), "Hello, World!!!")
    }

    @TestCase
    public func appendOrWriteTest2() {
        let bf = ByteBuffer()
        let bufferOutputStream = BufferedOutputStream(bf)
        bufferOutputStream.write(str1.toArray())
        appendOrWrite(None, bufferOutputStream, str2)

        bufferOutputStream.flush()
        @Expect(String.fromUtf8(readToEnd(bf)), 
        "Hello, World")

        appendOrWrite(None, bufferOutputStream, str3, 0, 4)
        bufferOutputStream.flush()
        @Expect(String.fromUtf8(readToEnd(bf)), 
        "!!!!")
    }
}