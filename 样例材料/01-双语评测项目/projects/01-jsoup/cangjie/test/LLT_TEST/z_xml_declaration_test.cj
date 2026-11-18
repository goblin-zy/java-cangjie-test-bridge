package cangjie_tpc::html4cj

@Test
public class XmlDeclarationTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var xmlDeclaration: XmlDeclaration = XmlDeclaration("xml", false)
        @Assert(xmlDeclaration.nodeName(), "#declaration")
        @Assert(xmlDeclaration.name(), "xml")
        xmlDeclaration.attr("version", "1.0")
        xmlDeclaration.attr("encoding", "UTF-8")
        @Assert(xmlDeclaration.getWholeDeclaration(), "version=\"1.0\" encoding=\"UTF-8\"")
        @Assert(xmlDeclaration.toString(), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")

        var xmlDeclaration1: XmlDeclaration = XmlDeclaration("xml", true)
        @Assert(xmlDeclaration1.nodeName(), "#declaration")
        @Assert(xmlDeclaration1.name(), "xml")
        xmlDeclaration1.attr("version", "1.0")
        xmlDeclaration1.attr("encoding", "UTF-8")
        @Assert(xmlDeclaration1.getWholeDeclaration(), "version=\"1.0\" encoding=\"UTF-8\"")
        @Assert(xmlDeclaration1.toString(), "<!xml version=\"1.0\" encoding=\"UTF-8\"!>")

        var xmlDeclaration2: XmlDeclaration = xmlDeclaration1.clone()
        @Assert(refEq(xmlDeclaration1, xmlDeclaration2), false)
        @Assert(xmlDeclaration1 == xmlDeclaration2, false)

        println("Pass1")
    }
}
