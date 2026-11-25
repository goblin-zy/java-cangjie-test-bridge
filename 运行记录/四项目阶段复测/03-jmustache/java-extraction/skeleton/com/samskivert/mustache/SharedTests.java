//
// JMustache - A Java implementation of the Mustache templating language
// http://github.com/samskivert/jmustache/blob/master/LICENSE

package com.samskivert.mustache;

import static java.util.Map.entry;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.io.Writer;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.Set;

import org.junit.Ignore;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestRule;
import org.junit.rules.TestWatcher;
import org.junit.runner.Description;

import com.samskivert.mustache.specs.SpecTest;

/**
 * Vestige from when JMustache supported both GWT and JVM.
 */
public abstract class SharedTests
{
    @Test public void testSimpleVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPrimitiveArrayVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPrimitiveArrayIndexVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPrimitiveArrayIndexOutOfBoundsVariable () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testOneShotSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testListSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testListIndexSection() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testListIndexOutOfBoundsSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testListItemSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMapEntriesSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testArraySection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testArrayIndexSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testArrayIndexOutOfBoundsSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testArrayItemSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testIteratorSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testIteratorIndexSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testIteratorIndexOutOfBoundsSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testIteratorItemSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testEmptyListSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testEmptyArraySection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testEmptyIteratorSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testFalseSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedListSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNullSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingNonStrictSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingStrictSection () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingStrictSectionNullValue () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingStrictSectionDefaultValue () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testSectionWithNonFalseyEmptyString () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testSectionWithFalseyEmptyString () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testComment () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCommentWithFunnyChars() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialUseWhenUnconfigured () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    Map<String,String> partials = new LinkedHashMap<>();

    @SafeVarargs
    protected final Mustache.TemplateLoader partials(Map.Entry<String, String> ... entries) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartial () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialIndent () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialBlankLines () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedPartialBlankLines () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedPartialBlankLinesCRLF () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedPartialIndent () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialIndentWithVariableAtTheStart () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialIndentWithBlock () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    @Test public void testPartialIndentInBlock () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialIndentWithBlockAtStart () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialIndentWithInlineBlock () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialPlusNestedContext () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testRecursivePartial () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testDelimiterChange () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testUnescapeHTML () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testDanglingTag () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testStrayTagCharacters () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testInvalidUnescapeHTML () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testEscapeHTML () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testUserDefinedEscaping() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPartialDelimiterMatch () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testTopLevelThis () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedThis () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedNullThis () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNewlineSkipping () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNewlineSkippingCRLF () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNewlineSkippingDelimsTag () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNoTrimNewlineFromNestedTagAt0 () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testTrimBlank () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    static class GetKeysVisitor implements Mustache.Visitor {
        public final Set<String> keys = new HashSet<String>();
        public void visitText (String text) {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
        public void visitVariable (String name) {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
        public boolean visitInclude (String name) {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
        public boolean visitSection (String name) {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
        public boolean visitInvertedSection (String name) {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
    }

    @Test public void testVisit() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testVisitNested() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected void testNewlineSkipping (String sep) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNewlineNonSkipping () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedContexts () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testShadowedContext () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testFirst () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLast () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testFirstLast () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testFirstLastCombo () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testInverseFirstLastCombo () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNotFirst () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNotLast () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testIndex () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedIndex () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLineReporting () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testStandardsModeWithNullValuesInLoop () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testStandardsModeWithNullValuesInInverseLoop () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testStandardsModeWithDotValue () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testStandardsModeWithNoParentContextSearching () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValue () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithDefaultNonEmptyString () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithDefaultSubstitution () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithDefaultSubstitution2 () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithDefaultSubstitution3 () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNullValueGetsDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMissingValueWithNullDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testInvalidTripleMustache () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNullValueGetsNullDefault () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCompilingDoesntChangeCompilersDelimiters() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLambda1 () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLambda2 () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testInvertibleLambda () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLambdaWithContext () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLambdaDecompile () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testLambdaFragExecTemplate () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNonStandardDefaultDelims () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected String name;

    @Rule public TestRule watcher = new TestWatcher() {
       protected void starting(Description description) {
           name = description.getDisplayName();
       }
    };

    protected void test(Mustache.Compiler compiler, String expected, String template, Object ctx) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected void check (String expected, String output) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected void test (String expected, String template, Object ctx) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected static String uncrlf (String text) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected static Object context (Object... data) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    protected static Object EMPTY = context();
}
