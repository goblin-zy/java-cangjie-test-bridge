// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testState_01(): Unit {
        var state = State(0)
        var sBool: Bool = true
        if (let None <- state.rootState) {
            sBool = false
        }
        @Assert(sBool,true)

        var state2 = State(4)
        var sBool2: Bool = true
        if (let None <- state2.rootState) {
            sBool2 = false
        }
        @Assert(sBool2,false)
    }

    @TestCase
    func testState_02(): Unit {
        var rootState = State(0)
        rootState.addState(r'a').addState(r'b').addState(r'c')
        var currentState: ?State = rootState.nextState(r'a')
        @Assert(currentState.getOrThrow().getDepth(), 1)
        currentState = currentState.getOrThrow().nextState(r'b')
        @Assert(currentState.getOrThrow().getDepth(), 2)
        currentState = currentState.getOrThrow().nextState(r'c')
        @Assert(currentState.getOrThrow().getDepth(), 3)
        currentState = currentState.getOrThrow().nextState(r'f')
        var currentStateBool: Bool = true
        if (let None <- currentState) {
            currentStateBool = false
        }
        @Assert(currentStateBool,false)
    }

    @TestCase
    func testState_03(): Unit {
        var rootState = State(0)
        rootState.addState(r'a').addState(r'b').addState(r'c')
        var currentState: ?State = rootState.nextStateIgnoreRootState(r'a')
        var currentStateBool1: Bool = true
        if (let None <- currentState) {
            currentStateBool1 = false
        }
        @Assert(currentStateBool1,true)
        currentState = currentState.getOrThrow().nextStateIgnoreRootState(r'f')
        var currentStateBool: Bool = true
        if (let None <- currentState) {
            currentStateBool = false
        }
        @Assert(currentStateBool,false)
    }

    @TestCase
    func testState_04(): Unit {
        var rootState = State(0)
        rootState.addState("abc")
        var currentState: ?State = rootState.nextState(r'a')
        @Assert(currentState.getOrThrow().getDepth(), 1)
        currentState = currentState.getOrThrow().nextState(r'b')
        @Assert(currentState.getOrThrow().getDepth(), 2)
        currentState = currentState.getOrThrow().nextState(r'c')
        @Assert(currentState.getOrThrow().getDepth(), 3)
        currentState = currentState.getOrThrow().nextState(r'f')
        var currentStateBool: Bool = true
        if (let None <- currentState) {
            currentStateBool = false
        }
        @Assert(currentStateBool,false)
    }

    @TestCase
    func testState_05(): Unit {
        var rootState = State(0)
        rootState.addState("")
        let emitColl_1: Collection<Rune> = rootState.getTransitions()
        @Assert(emitColl_1.size,0)
    }

    @TestCase
    func testState_06(): Unit {
        var rootState = State(0)
        rootState.addState("foo")
        let states: Collection<State> = rootState.getStates()
        @Assert(states.size,1)
    }

    @TestCase
    func testState_07(): Unit {
        var rootState = State(0)
        rootState.addState("foo")
        let transitions: Collection<Rune> = rootState.getTransitions()
        @Assert(transitions.size,1)
        var transitionChar = transitions.toArray().get(0)
        @Assert(transitionChar,r'f')
    }

    @TestCase
    func testState_08(): Unit {
        var failureState = State(5)
        var rootState = State(0)
        rootState.setFailure(failureState)
        @Assert(rootState.failures().getOrThrow().getDepth(),failureState.getDepth())
    }

    @TestCase
    func testState_09(): Unit {
        var rootState = State(0)
        rootState.addState(r'a').addEmit(ArrayList<String>(["tag", "kuvv"]))
        rootState.addState(r'b').addEmit(ArrayList<String>(["btag", "bkuvv"]))
        rootState.addState(r'b').addEmit(ArrayList<String>(["btag2", "bkuvv2"]))
        let actual: Collection<String> = rootState.nextState(r'a').getOrThrow().emit()
        let actualB: Collection<String> = rootState.nextState(r'b').getOrThrow().emit()
        @Assert(actual.toArray().get(0),"tag")
        @Assert(actual.toArray().get(1),"kuvv")
        @Assert(actualB.toArray().get(0),"btag")
        @Assert(actualB.toArray().get(1),"bkuvv")
        @Assert(actualB.toArray().get(2),"btag2")
        @Assert(actualB.toArray().get(3),"bkuvv2")
    }

    @TestCase
    func testState_10(): Unit {
        var rootState = State(0)
        rootState.addState(r'a').addEmit(ArrayList<String>(["tag", "kuvv"]))
        let actual: Collection<String> = rootState.nextState(r'a').getOrThrow().emit()
        @Assert(actual.toArray().get(0),"tag")
        @Assert(actual.toArray().get(1),"kuvv")
    }
}
