// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var formElement: FormElement = FormElement(Tag.valueOf("from"), "", None)
    var formElement1: FormElement = FormElement(Tag.valueOf("from1"), "", None)
    var formElement2: FormElement = FormElement(Tag.valueOf("from2"), "", None)
    var elements: Elements = formElement.elements()
    if (elements.size == 0) {
        println("pass1")
    }
    formElement.addElement(formElement1)
    formElement.addElement(formElement2)
    if (elements.size == 2) {
        println("pass2")
    }
    var formElement3: FormElement = formElement.clone()
    var elements3: Elements = formElement3.elements()
    if (elements3.size == 2) {
        println("pass3")
    }

    return 0
}
