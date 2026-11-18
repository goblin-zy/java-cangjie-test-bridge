package cangjie_tpc::html4cj

@Test
public class HtmTest {
    @TestCase
    public func baiduTest(): Unit {
        let inFile = File.readFrom("test/htmltests/baidu.htm")
        let content = String.fromUtf8(inFile)
        let doc = Html4cj.parse(content)
        @Assert(356371, doc.body().html().size)
    }
}
