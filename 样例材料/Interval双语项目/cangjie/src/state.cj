/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is State
 * @since 0.38.2
 */
public class State {

    /**
     * effective the size of the keyword
     */
    private var depth: Int32 = 0

    /**
     * only used for the root state to refer to itself in case no matches have been
     * found
     */
    public var rootState: ?State = None

    /**
     * referred to in the white paper as the 'goto' structure. From a state it is
     * possible to go to other states, depending on the character passed.
     */
    private var success: HashMap<Rune, State> = HashMap<Rune, State>()

    /**
     * if no matching states are found, the failure state will be returned
     */
    private var failure: ?State = None

    /**
     * whenever this state is reached, it will emit the matches keywords for future
     * reference
     */
    private var emits: ?ArrayList<String> = ArrayList<String>()

    protected init() {
        this(0)
    }

    public init(depth: Int32) {
        this.depth = depth
        if (depth == 0) {
            this.rootState = this
        } else {
            this.rootState = None
        }
    }

    private func nextState(character: Rune, ignoreRootState: Bool): ?State {
        var nextState: ?State = this.success.get(character)
        if (!ignoreRootState) {
            if (let None <- nextState) {
                if (let Some(_) <- rootState) {
                    nextState = this.rootState
                }
            }
        }
        return nextState
    }

    public func nextState(character: Rune): ?State {
        return nextState(character, false)
    }

    public func nextStateIgnoreRootState(character: Rune): ?State {
        return nextState(character, true)
    }

    public func addState(keyword: String): State {
        var state: State = this
        for (i in 0..keyword.size) {
            state = state.addState(Rune(keyword[i]))
        }
        return state
    }

    public func addState(character: Rune): State {
        var nextState: ?State = nextStateIgnoreRootState(character)
        if (let None <- nextState) {
            nextState = State(this.depth + 1)
            this.success.add(character, nextState.getOrThrow())
        }
        return nextState.getOrThrow()
    }

    public func getDepth(): Int32 {
        return this.depth
    }

    public func addEmit(keyword: String): Unit {
        if (let None <- this.emits) {
            this.emits = ArrayList<String>()
        }
        this.emits.getOrThrow().add(keyword)
    }

    public func addEmit(emits: ArrayList<String>): Unit {
        let arr = unsafe { emits.getRawArray() }
        for(i in 0..emits.size) {
            addEmit(arr[i])
        }
    }

    public func emit(): ArrayList<String> {
        if (let None <- this.emits) {
            return ArrayList<String>()
        }
        return this.emits.getOrThrow()
    }

    public func failures(): ?State {
        return this.failure
    }

    public func setFailure(failState: State): Unit {
        return this.failure = failState
    }

    public func getStates(): Collection<State> {
        return this.success.values()
    }

    public func getTransitions(): Collection<Rune> {
        return this.success.keys()
    }
}
