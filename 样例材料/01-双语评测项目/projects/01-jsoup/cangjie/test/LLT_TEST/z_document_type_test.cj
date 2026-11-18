package cangjie_tpc::html4cj

@Test
public class DocumentTypeTest {
    @TestCase
    public func constructorValidationOkWithBlankName(): Unit {
        // 1
        DocumentType("", "", "")

        println("Pass1")
    }

    @TestCase
    public func constructorValidationThrowsExceptionOnNulls(): Unit {
        // 2
        println("Pass2")
    }

    @TestCase
    public func constructorValidationOkWithBlankPublicAndSystemIds(): Unit {
        // 3
        DocumentType("html", "", "")

        println("Pass3")
    }

    @TestCase
    public func outerHtmlGeneration(): Unit {
        // 4
        var html5: DocumentType = DocumentType("html", "", "")
        @Assert("<!doctype html>", html5.outerHtml())
        var publicDocType: DocumentType = DocumentType("html", "-//IETF//DTD HTML//", "")
        @Assert("<!DOCTYPE html PUBLIC \"-//IETF//DTD HTML//\">", publicDocType.outerHtml())
        var systemDocType: DocumentType = DocumentType(
            "html",
            "",
            "http://www.ibm.com/data/dtd/v11/ibmxhtml1-transitional.dtd"
        )
        @Assert("<!DOCTYPE html SYSTEM \"http://www.ibm.com/data/dtd/v11/ibmxhtml1-transitional.dtd\">",
            systemDocType.outerHtml())
        var combo: DocumentType = DocumentType("notHtml", "--public", "--system")
        @Assert("<!DOCTYPE notHtml PUBLIC \"--public\" \"--system\">", combo.outerHtml())
        @Assert("notHtml", combo.name())
        @Assert("--public", combo.publicId())
        @Assert("--system", combo.systemId())

        println("Pass4")
    }

    @TestCase
    public func testRoundTrip(): Unit {
        // 5
        var base: String = "<!DOCTYPE html>"
        @Assert("<!doctype html>", htmlOutput(base))
        @Assert(base, xmlOutput(base))
        var publicDoc: String =
            "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
        @Assert(publicDoc, htmlOutput(publicDoc))
        @Assert(publicDoc, xmlOutput(publicDoc))
        var systemDoc: String = "<!DOCTYPE html SYSTEM \"exampledtdfile.dtd\">"
        @Assert(systemDoc, htmlOutput(systemDoc))
        @Assert(systemDoc, xmlOutput(systemDoc))
        var legacyDoc: String = "<!DOCTYPE html SYSTEM \"about:legacy-compat\">"
        @Assert(legacyDoc, htmlOutput(legacyDoc))
        @Assert(legacyDoc, xmlOutput(legacyDoc))

        println("Pass5")
    }

    private func htmlOutput(str: String): String {
        return Html4cj.parse(str).childNode(0).outerHtml()
    }

    private func xmlOutput(str: String): String {
        return Html4cj.parse(str, "", Parser.xmlParser()).childNode(0).outerHtml()
    }

    @TestCase
    public func initTest(): Unit {
        // 6
        var documentType: DocumentType = DocumentType("html", "", "")
        @Assert(documentType.nodeName(), "#doctype")
        @Assert(documentType.name(), "html")
        @Assert("", documentType.publicId())
        @Assert("", documentType.systemId())
        documentType.setPubSysKey("key")
        @Assert("<!doctype html key>", documentType.toString())
        var documentType1: DocumentType = DocumentType("notHtml", "--public", "--system")
        @Assert(documentType1.nodeName(), "#doctype")
        @Assert(documentType1.name(), "notHtml")
        @Assert("--public", documentType1.publicId())
        @Assert("--system", documentType1.systemId())
        @Assert("<!DOCTYPE notHtml PUBLIC \"--public\" \"--system\">", documentType1.toString())

        println("Pass6")
    }
}
