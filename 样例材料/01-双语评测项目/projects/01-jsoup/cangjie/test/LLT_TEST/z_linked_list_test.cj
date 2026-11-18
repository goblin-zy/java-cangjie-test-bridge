package cangjie_tpc::html4cj

@Test
public class LinkedListTest {
    @TestCase
    public func clearTest(): Unit {
        // 1
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        @Assert(3, linkedList.size)
        linkedList.clear()
        @Assert(0, linkedList.size)

        println("Pass1")
    }

    @TestCase
    public func getFirstTest(): Unit {
        // 2
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        @Assert(0, linkedList.getFirst())

        println("Pass2")
    }

    @TestCase
    public func getLastTest(): Unit {
        // 3
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        @Assert(2, linkedList.getLast())

        println("Pass3")
    }

    @TestCase
    public func getIndexTest(): Unit {
        // 4
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        @Assert(0, linkedList.get(0))
        @Assert(1, linkedList.get(1))
        @Assert(2, linkedList.get(2))

        println("Pass4")
    }

    @TestCase
    public func setIndexTest(): Unit {
        // 5
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.set(0, 1)
        linkedList.set(0, 2)
        @Assert(2, linkedList.get(0))

        println("Pass5")
    }

    @TestCase
    public func appendAllTest(): Unit {
        // 6
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        var linkedList1: LinkedList<Int64> = LinkedList<Int64>()
        linkedList1.append(3)
        linkedList1.append(4)
        linkedList1.append(5)
        linkedList.appendAll(linkedList1)
        @Assert(6, linkedList.size)

        println("Pass6")
    }

    @TestCase
    public func removeTest(): Unit {
        // 7
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.prepend(0)
        linkedList.prepend(1)
        linkedList.prepend(2)
        @Assert(3, linkedList.size)
        linkedList.remove(1)
        @Assert(2, linkedList.size)

        println("Pass7")
    }

    @TestCase
    public func removeLastTest(): Unit {
        // 8
        var linkedList: LinkedList<Int64> = LinkedList<Int64>()
        linkedList.append(0)
        linkedList.append(1)
        linkedList.append(2)
        @Assert(3, linkedList.size)
        linkedList.removeLast()
        @Assert(2, linkedList.size)

        println("Pass8")
    }
}
