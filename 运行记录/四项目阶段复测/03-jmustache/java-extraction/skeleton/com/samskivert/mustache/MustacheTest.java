//
// JMustache - A Java implementation of the Mustache templating language
// http://github.com/samskivert/jmustache/blob/master/LICENSE

package com.samskivert.mustache;

import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Optional;
import java.util.TimeZone;

import org.junit.Test;
import static org.junit.Assert.fail;

/**
 * Mustache tests that can only be run on the JVM. Most tests should go in BaseMustacheTest so
 * that they can be run on GWT and the JVM to ensure they work in both places.
 */
public class MustacheTest extends SharedTests
{
    @Test public void testFieldVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMethodVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPropertyVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCustomContext() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCharSequenceVariable() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public interface HasDefault {
        default String getFoo () {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
    }
    public interface Interloper extends HasDefault {
        default String getFoo () {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
    }
    @Test public void testDefaultMethodVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testBooleanPropertyVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPrimitiveBooleanPropertyVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testSkipVoidReturn () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCallSiteReuse () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCallSiteChange () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testSectionWithNonFalseyZero () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testSectionWithFalseyZero () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testOptionalSupportingCollector () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCompoundVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNullComponentInCompoundVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingComponentInCompoundVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNullComponentInCompoundVariableWithDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingComponentInCompoundVariableWithDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCompoundVariableAsPlain () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testShadowedContextWithNull () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testContextPokingLambda () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCustomFormatter () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMapEntriesPlusReflectSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNoAccesCoercion () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
