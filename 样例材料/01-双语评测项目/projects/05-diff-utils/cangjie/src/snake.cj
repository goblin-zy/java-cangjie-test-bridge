/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package diffUtils4cj

/**
 *  Represents a snake in a diffpath.
 */
public  class Snake <: PathNode {
    /**
     * Constructs a snake node.
     *
     * @param the position in the original sequence
     * @param the position in the revised sequence
     * @param prev the previous node in the path.
     * 
     * @since 0.38.2
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>) {
        super(i, j, prev)
    }
    
    /**
     * 
     * @return true always
     * 
     * @since 0.38.2
     */
    public func isSnake(): Bool {
        return true
    }
}