// AST bridge protocol: cj-stdast-dump-1.2. This reads code, never executes it.
import std.ast.*
import std.fs.*
import std.io.*

main(args: Array<String>): Int64 {
    if (args.size != 1) {
        eprintln("Usage: ast_dump <source.cj>")
        return 2
    }
    try {
        let file = File(args[0], Read)
        try {
            let reader = StringReader<File>(file)
            let code = reader.readToEnd()
            let tokens = cangjieLex(code)
            let node = parseProgram(tokens)
            println("PMTOOL_CJ_AST_1_2")
            node.dump()
        } finally {
            file.close()
        }
        return 0
    } catch (e: Exception) {
        eprintln(e.toString())
        return 1
    }
}

