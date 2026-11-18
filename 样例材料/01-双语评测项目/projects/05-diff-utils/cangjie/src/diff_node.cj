/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package diffUtils4cj

/**
 * A diffnode in a diffpath.
 */
public class DiffNode <: PathNode {
    /**
     * Constructs a DiffNode.
     *
     * DiffNodes are compressed. That means that
     * the path pointed to by the <code>prev</code> parameter
     * will be followed using {@link PathNode#previousSnake}
     * until a non-diff node is found.
     *
     * @param the position in the original sequence
     * @param the position in the revised sequence
     * @param prev the previous node in the path.
     * 
     * @since 0.38.2
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>) {
        super(i, j, initPrev(prev))
    }

    private func initPrev(prev: Option<PathNode>): Option<PathNode> {
        if (checkNull(prev)) {
            return prev
        } else {
            return prev.getOrThrow().previousSnake()
        }
    }
    
    /**
     * 
     * @return false always
     * 
     * @since 0.38.2
     */
    public func isSnake(): Bool {
        return false
    }
}