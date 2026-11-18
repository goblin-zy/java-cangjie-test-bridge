package cangjie_tpc::html4cj

@Test
public class FormElementTest {
    @TestCase
    public func hasAssociatedControls(): Unit {
        // 1
        //"button", "fieldset", "input", "keygen", "object", "output", "select", "textarea"
        var html: String =
            "<form id=1><button id=1><fieldset id=2 /><input id=3><keygen id=4><object id=5><output id=6>" +
            "<select id=7><option></select><textarea id=8><p id=9>"
        var doc: Document = Html4cj.parse(html)
        var form: FormElement = (doc.select("form").first().getOrThrow() as FormElement).getOrThrow()
        @Assert(8, form.elements().size)

        println("Pass1")
    }

    @TestCase
    public func formsAddedAfterParseAreFormElements(): Unit {
        // 2
        var doc: Document = Html4cj.parse("<body />")
        doc.body().html("<form action='http://example.com/search'><input name='q' value='search'>")
        var formEl: Element = doc.select("form").first().getOrThrow()
        @Assert((formEl is FormElement), true)
        var form: FormElement = (formEl as FormElement).getOrThrow()
        @Assert(1, form.elements().size)

        println("Pass2")
    }

    @TestCase
    public func controlsAddedAfterParseAreLinkedWithForms(): Unit {
        // 3
        var doc: Document = Html4cj.parse("<body />")
        doc.body().html("<form />")
        var formEl: Element = doc.select("form").first().getOrThrow()
        formEl.append("<input name=foo value=bar>")
        @Assert((formEl is FormElement), true)
        var form: FormElement = (formEl as FormElement).getOrThrow()
        @Assert(1, form.elements().size)

        println("Pass3")
    }

    @TestCase
    public func initTest(): Unit {
        // 4
        var formElement: FormElement = FormElement(Tag.valueOf("from"), "", None)
        var formElement1: FormElement = FormElement(Tag.valueOf("from1"), "", None)
        var formElement2: FormElement = FormElement(Tag.valueOf("from2"), "", None)
        var elements: Elements = formElement.elements()
        @Assert(elements.size, 0)
        formElement.addElement(formElement1)
        formElement.addElement(formElement2)
        @Assert(elements.size, 2)
        var formElement3: FormElement = formElement.clone()
        var elements3: Elements = formElement3.elements()
        @Assert(elements3.size, 2)

        println("Pass4")
    }
}
