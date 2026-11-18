package cjmustache

import stdx.serialization.serialization.*
import std.io.*

public func appendOrWrite(
    sb: ?StringBuilder, 
    out: ?OutputStream, raw: String): Unit {
    if (let Some(extractedStringBuilder) <- sb) {
        extractedStringBuilder.append(raw)
    }
    if (let Some(extractedOutputStream) <- out) {
        extractedOutputStream.
        write(raw.toArray())
    }
}

public func appendOrWrite(
    sb: ?StringBuilder, 
    out: ?OutputStream, raw: String,
        start: Int64, end: Int64): Unit {
    if (let Some(extractedStringBuilder) <- sb) {
        extractedStringBuilder.append(raw.slice(begin: start, end: end))
    }
    if (let Some(extractedOutputStream) <- out) {
        extractedOutputStream.
        write(raw.slice(begin: start, end: end).toArray())
    }
}


public func isNO_FETCHER_FOUND(data: DataModel): Bool {
    return match (data) {
        case str: DataModelString => str
                    str.getValue().equalsIgnoreAsciiCase(Template.NO_FETCHER_FOUND)
        case _ => false
    }
}


