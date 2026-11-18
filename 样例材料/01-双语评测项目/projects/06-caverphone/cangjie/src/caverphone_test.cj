/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package caverphone
import std.unittest.*
import std.unittest.testmacro.*
import std.unicode.*
import std.regex.*
import std.fs.*
import encoding.json.*
import serialization.serialization.*

@Test
class caverphone_test {
    @TestCase
    func testHex(): Unit {
        let bytes = File.readFrom("C:\\Users\\huawei\\Desktop\\dev\\caverphone4cj\\src\\testdata.json")
        let a = String.fromUtf8(bytes)
        let json = JsonValue.fromStr(a)
        let arr = json.asArray()

        for (i in 0..arr.size()){
            var dm = DataModel.fromJson(arr[i])
            var A = Person.deserialize(dm)
            @Assert(caverphone(A.input), A.expected)
        }
    }
}

    