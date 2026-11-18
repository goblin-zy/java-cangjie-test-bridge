package cangjie_tpc::html4cj

@Test
public class HtmlTreeBuilderTest {
    @TestCase
    public func ensureSearchArraysAreSorted(): Unit {
        let constants: Array<Array<String>> = [
            HtmlTreeBuilder.TagsSearchInScope,
            HtmlTreeBuilder.TagSearchList,
            HtmlTreeBuilder.TagSearchButton,
            HtmlTreeBuilder.TagSearchTableScope,
            HtmlTreeBuilder.TagSearchSelectScope,
            HtmlTreeBuilder.TagSearchEndTags,
            HtmlTreeBuilder.TagThoroughSearchEndTags,
            HtmlTreeBuilder.TagSearchSpecial
        ]
        HtmlTreeBuilderStateTest.ensureSorted(constants)
        @Assert(8, constants.size)
    }
}
