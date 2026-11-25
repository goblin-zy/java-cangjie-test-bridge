package org.jsoup.select;

import org.jsoup.Jsoup;
import org.jsoup.MultiLocaleExtension.MultiLocaleTest;
import org.jsoup.TextUtil;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.junit.jupiter.api.Test;

import java.util.Locale;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests that the selector selects correctly.
 *
 * @author Jonathan Hedley, jonathan@hedley.net
 */
public class SelectorTest {
    @Test public void testByTag() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void byEscapedTag() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testById() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void byEscapedId() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testByClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void byEscapedClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testByClassCaseInsensitive() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }


    @MultiLocaleTest
    public void testByAttribute(Locale locale) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNamespacedTag() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testWildcardNamespacedTag() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testWildcardNamespacedXmlTag() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testWildCardNamespacedCaseVariations() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @MultiLocaleTest
    public void testByAttributeStarting(Locale locale) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testByAttributeRegex() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testByAttributeRegexCharacterClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testByAttributeRegexCombined() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testCombinedWithContains() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testAllElements() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testAllWithClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testGroupOr() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testGroupOrAttribute() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void descendant() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void and() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void deeperDescendant() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void parentChildElement() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void parentWithClassChild() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void parentChildStar() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void multiChildDescent() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void caseInsensitive() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void adjacentSiblings() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void adjacentSiblingsWithId() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void notAdjacent() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void mixCombinator() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void mixCombinatorGroup() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void generalSiblings() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    // for http://github.com/jhy/jsoup/issues#issue/10
    @Test public void testCharactersInIdAndClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    // for http://github.com/jhy/jsoup/issues#issue/13
    @Test public void testSupportsLeadingCombinator() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoLessThan() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoGreaterThan() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoEquals() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoBetween() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoCombined() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPseudoHas() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testNestedHas() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @MultiLocaleTest
    public void testPseudoContains(Locale locale) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testPsuedoContainsWithParentheses() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test void containsWholeText() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test void containsWholeOwnText() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @MultiLocaleTest
    public void containsOwn(Locale locale) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testMatches() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void matchesOwn() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void matchesWholeText() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void matchesWholeOwnText() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void testRelaxedTags() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void notParas() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void notAll() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void notClass() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void handlesCommasInSelector() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectSupplementaryCharacter() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void selectClassWithSpace() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectSameElements() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void attributeWithBrackets() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @MultiLocaleTest
    public void containsData(Locale locale) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void containsWithQuote() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectFirst() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectFirstWithAnd() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectFirstWithOr() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void matchText() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void nthLastChildWithNoParent() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void splitOnBr() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void matchTextAttributes() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void findBetweenSpan() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void startsWithBeginsWithSpace() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void endsWithEndsWithSpaces() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    // https://github.com/jhy/jsoup/issues/1257
    private final String mixedCase =
        "<html xmlns:n=\"urn:ns\"><n:mixedCase>text</n:mixedCase></html>";
    private final String lowercase =
        "<html xmlns:n=\"urn:ns\"><n:lowercase>text</n:lowercase></html>";

    @Test
    public void html_mixed_case_simple_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void html_mixed_case_wildcard_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void html_lowercase_simple_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void html_lowercase_wildcard_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void xml_mixed_case_simple_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void xml_mixed_case_wildcard_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void xml_lowercase_simple_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void xml_lowercase_wildcard_name() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void trimSelector() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void xmlWildcardNamespaceTest() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void childElements() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void selectFirstLevelChildrenOnly() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void wildcardNamespaceMatchesNoNamespace() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test void containsTextQueryIsNormalized() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test public void selectorExceptionNotStringFormatException() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
