// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
// dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributesTest {
    let ins_1: Attributes = Attributes()
    let sourceDataIns: SourceData = SourceData()
    var returnFlag: Int64 = 0
    var resInt: Int64 = -1
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()

    @TestCase
    func testAttributes_dataset_01(): Unit {
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("data-${i}", Some("value_${i}")).toString()
        }
        var it: Iterator<(String, ?String)> = ins_2.dataset() // 只包含data- 开头的属性
        var str1: String = ""
        var i = 0
        while (i < ins_2.size) {
            var nextData = it.next().getOrThrow()
            if (nextData[1] != None) {
                str1 += nextData[0]
            }
            i++
        }
        @Assert(str1, "data-0data-1data-2data-3data-4")
        ins_2.put("data-animal-type", Some("value_data"))
        @Assert(ins_2.size, 6)
    }

    @TestCase
    func testAttributes_dataset_02(): Unit {
        returnFlag = -1
        let ins_2: Attributes = Attributes()
        var strRes: String = ""
        for (i in 0..5) {
            strRes = ins_2.put("key_${i}", Some("value_${i}")).toString()
        }
        var it: Iterator<(String, ?String)> = ins_2.dataset() // 只包含data- 开头的属性
        var str1: String = ""
        var i = 0
        while (i < ins_2.size) {
            try {
                var nextData = it.next().getOrThrow()
                if (nextData[1] != None) {
                    str1 += nextData[0]
                }
            } catch (e1: NoneValueException) {
                @Assert(e1.toString().contains("NoneValueException"), true)
                returnFlag = 0
            }
            i++
        }
        @Assert(ins_2.size, 5)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testAttributes_dataset_03(): Unit {
        returnFlag = -1
        let ins_3: Attributes = Attributes()
        try {
            var it: Iterator<(String, ?String)> = ins_3.dataset()
            it.next().getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        @Assert(ins_3.size, 0)
        @Assert(returnFlag, 0)
    }
}
