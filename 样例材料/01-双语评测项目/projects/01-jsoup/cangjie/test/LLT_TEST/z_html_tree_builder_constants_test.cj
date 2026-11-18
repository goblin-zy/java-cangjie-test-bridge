package cangjie_tpc::html4cj

@Test
public class HtmlTreeBuilderStateTest {
    static let constants: Array<Array<String>> = [
        Constants.InHeadEmpty,
        Constants.InHeadRaw,
        Constants.InHeadEnd,
        Constants.AfterHeadBody,
        Constants.BeforeHtmlToHead,
        Constants.InHeadNoScriptHead,
        Constants.InBodyStartToHead,
        Constants.InBodyStartPClosers,
        Constants.Headings,
        Constants.InBodyStartLiBreakers,
        Constants.DdDt,
        Constants.InBodyStartApplets,
        Constants.InBodyStartMedia,
        Constants.InBodyStartInputAttribs,
        Constants.InBodyStartDrop,
        Constants.InBodyEndClosers,
        Constants.InBodyEndAdoptionFormatters,
        Constants.InBodyEndTableFosters,
        Constants.InTableToBody,
        Constants.InTableAddBody,
        Constants.InTableToHead,
        Constants.InCellNames,
        Constants.InCellBody,
        Constants.InCellTable,
        Constants.InCellCol,
        Constants.InTableEndErr,
        Constants.InTableFoster,
        Constants.InTableBodyExit,
        Constants.InTableBodyEndIgnore,
        Constants.InRowMissing,
        Constants.InRowIgnore,
        Constants.InSelectEnd,
        Constants.InSelectTableEnd,
        Constants.InTableEndIgnore,
        Constants.InHeadNoscriptIgnore,
        Constants.InCaptionIgnore,
        Constants.InTemplateToHead,
        Constants.InTemplateToTable
    ]
    static func ensureSorted(constants: Array<Array<String>>): Unit {
        for (array in constants) {
            let copy = array.clone()
            array.sort()
            for (i in 0..array.size) {
                @Assert(array[i], copy[i])
            }
        }
    }

    @TestCase
    public func ensureArraysAreSorted(): Unit {
        ensureSorted(constants)
        @Assert(38, constants.size)
    }

    @TestCase
    public func ensureTagSearchesAreKnownTags(): Unit {
        for (constant in constants) {
            for (tagName in constant) {
                if (StringUtil.inSorted(tagName, Constants.InBodyStartInputAttribs)) {
                    continue
                    // odd one out in the constant
                }
                @Assert(Tag.checkKnownTag(tagName)) // "Unknown tag name: ${tagName}"
            }
        }
    }

    @TestCase
    public func nestedAnchorElements01(): Unit {
        let html: String =
            #"<html>
  <body>
    <a href='#1'>
        <div>
          <a href='#2'>child</a>
        </div>
    </a>
  </body>
</html>"#
        let s: String = Html4cj.parse(html).toString()
        let expect = """
<html>
 <head></head>
 <body><a href=\"#1\"> </a>
  <div>
   <a href=\"#1\"> </a><a href=\"#2\">child</a>
  </div>
 </body>
</html>"""
        @Assert(expect, s)
    }

    @TestCase
    public func nestedAnchorElements02(): Unit {
        let html: String =
            #"<html>
  <body>
    <a href='#1'>
      <div>
        <div>
          <a href='#2'>child</a>
        </div>
      </div>
    </a>
  </body>
</html>"#
        let s: String = Html4cj.parse(html).toString()
        let expect = """
<html>
 <head></head>
 <body><a href=\"#1\"> </a>
  <div>
   <a href=\"#1\"> </a>
   <div>
    <a href=\"#1\"> </a><a href=\"#2\">child</a>
   </div>
  </div>
 </body>
</html>"""
        @Assert(expect, s)
    }
}
