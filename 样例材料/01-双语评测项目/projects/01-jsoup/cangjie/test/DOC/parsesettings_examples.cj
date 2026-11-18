// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    let bothOn: ParseSettings = ParseSettings(true, true)
    let bothOff: ParseSettings = ParseSettings(false, false)
    if ("IMG" == bothOn.normalizeTag("IMG")) {
        println("pass1")
    }
    if ("ID" == bothOn.normalizeAttribute("ID")) {
        println("pass2")
    }
    if ("img" == bothOff.normalizeTag("IMG")) {
        println("pass3")
    }
    if ("id" == bothOff.normalizeTag("IMG")) {
        println("pass4")
    }
    let parseSettings: ParseSettings = ParseSettings(false, false)
    let normalizedAttribute: String = parseSettings.normalizeAttribute("HIDDEN")
    if ("hidden" == normalizedAttribute) {
        println("pass5")
    }
    if (!ParseSettings.htmlDefault.preserveTagCase()) {
        println("pass6")
    }
    if (!ParseSettings.htmlDefault.preserveAttributeCase()) {
        println("pass7")
    }
    if (ParseSettings.preserveCase.preserveTagCase()) {
        println("pass8")
    }
    if (ParseSettings.preserveCase.preserveAttributeCase()) {
        println("pass9")
    }

    return 0
}
