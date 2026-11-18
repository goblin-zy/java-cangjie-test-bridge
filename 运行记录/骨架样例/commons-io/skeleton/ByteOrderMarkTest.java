/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.io;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.nio.charset.Charset;

import org.junit.jupiter.api.Test;

/**
 * Test for {@link ByteOrderMark}.
 */
public class ByteOrderMarkTest {

    private static final ByteOrderMark TEST_BOM_1 = new ByteOrderMark("test1", 1);
    private static final ByteOrderMark TEST_BOM_2 = new ByteOrderMark("test2", 1, 2);
    private static final ByteOrderMark TEST_BOM_3 = new ByteOrderMark("test3", 1, 2, 3);

    /** Tests that {@link ByteOrderMark#getCharsetName()} can be loaded as a {@link java.nio.charset.Charset} as advertised. */
    @Test
    public void testConstantCharsetNames() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests Exceptions */
    @Test
    public void testConstructorExceptions() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#equals(Object)} */
    @SuppressWarnings("EqualsWithItself")
    @Test
    public void testEquals() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#getBytes()} */
    @Test
    public void testGetBytes() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#getCharsetName()} */
    @Test
    public void testGetCharsetName() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#get(int)} */
    @Test
    public void testGetInt() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#hashCode()} */
    @Test
    public void testHashCode() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#length()} */
    @Test
    public void testLength() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    /** Tests {@link ByteOrderMark#toString()} */
    @Test
    public void testToString() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
