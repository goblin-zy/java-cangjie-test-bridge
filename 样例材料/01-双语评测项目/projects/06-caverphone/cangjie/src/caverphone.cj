/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package caverphone
import std.unicode.*
import std.regex.*
import std.fs.*
import encoding.json.*
import serialization.serialization.*

func replaceString(word: String, regex: String, targetStr: String):String {
    var r = Regex(regex);
    var m = Matcher(r, word);
    return m.replaceAll(targetStr);
}
public func caverphone(word: String): String {

    var result = word.toLower()
    result = replaceString(result, "[^a-z]", "")
    result = replaceString(result, "e$", "")
    result = replaceString(result, "^cough", "cou2f")
    result = replaceString(result, "^rough", "rou2f")
    result = replaceString(result, "^tough", "tou2f")
    result = replaceString(result, "^enough", "enou2f")
    result = replaceString(result, "^trough", "trou2f")
    result = replaceString(result, "^gn", "2n")
    result = replaceString(result, "mb$", "m2")
    result = replaceString(result, "cq", "2q")
    result = replaceString(result, "ci", "si")
    result = replaceString(result, "ce", "se")
    result = replaceString(result, "cy", "sy")
    result = replaceString(result, "tch", "2ch")
    result = replaceString(result, "c", "k")
    result = replaceString(result, "q", "k")
    result = replaceString(result, "x", "k")
    result = replaceString(result, "v", "f")
    result = replaceString(result, "dg", "2g")
    result = replaceString(result, "tio", "sio")
    result = replaceString(result, "tia", "sia")
    result = replaceString(result, "d", "t")
    result = replaceString(result, "ph", "fh")
    result = replaceString(result, "b", "p")
    result = replaceString(result, "sh", "s2")
    result = replaceString(result, "z", "s")
    result = replaceString(result, "^[aeiou]", "A")
    result = replaceString(result, "[aeiou]", "3")
    result = replaceString(result, "j", "y")
    result = replaceString(result, "^y3", "Y3")
    result = replaceString(result, "^y", "A")
    result = replaceString(result, "y", "3")
    result = replaceString(result, "3gh3", "3kh3")
    result = replaceString(result, "gh", "22")
    result = replaceString(result, "g", "k")
    result = replaceString(result, "s+", "S")
    result = replaceString(result, "t+", "T")
    result = replaceString(result, "p+", "P")
    result = replaceString(result, "k+", "K")
    result = replaceString(result, "f+", "F")
    result = replaceString(result, "m+", "M")
    result = replaceString(result, "n+", "N")
    result = replaceString(result, "w3", "W3")
    result = replaceString(result, "wh3", "Wh3")
    result = replaceString(result, "w$", "3")
    result = replaceString(result, "w", "2")
    result = replaceString(result, "^h", "A")
    result = replaceString(result, "h", "2")
    result = replaceString(result, "r3", "R3")
    result = replaceString(result, "r$", "3")
    result = replaceString(result, "r", "2")
    result = replaceString(result, "l3", "L3")
    result = replaceString(result, "l$", "3")
    result = replaceString(result, "l", "2")
    result = replaceString(result, "2", "")
    result = replaceString(result, "3$", "A")
    result = replaceString(result, "3", "")

    result = result + "1111111111"
    return result[0..10]
}

class Person <: Serializable<Person> {
    var input: String = ""
    var expected: String = ""

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("input", input)).add(field<String>("expected", expected))
    }

    public static func deserialize(dm: DataModel): Person {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Person()
        result.input = String.deserialize(dms.get("input"))
        result.expected = String.deserialize(dms.get("expected"))
        return result
    }
}

main(): Int64 {
    return 0
}