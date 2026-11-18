// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

let htmlStr01: String = """
"""

let htmlStr02: String = """
<!doctype html><html><head><title>Doctype test</title></head><body></body></html>"""

let htmlStr03: String = """
你好！@#￥%~@（￥*&￥%（￥）））#。sfdadsadasads"""

let htmlStr04: String = """
<div id="content" style="--color-new-tab-page-attribution-foreground: rgba(0, 0, 0, 1.00); --color-new-tab-page-most-visited-foreground: rgba(0, 0, 0, 1.00); --ntp-logo-color: inherit;"><ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe><dom-if style="display: none;"><template is="dom-if"></template></dom-if><dom-if style="display: none;"><template is="dom-if"></template></dom-if><ntp-logo id="logo"></ntp-logo><div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;"><template is="dom-if"></template></dom-if></div><cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited><dom-if style="display: none;"><template is="dom-if"></template></dom-if><ntp-middle-slot-promo></ntp-middle-slot-promo><dom-if style="display: none;"><template is="dom-if"></template></dom-if><dom-if style="display: none;"><template is="dom-if"></template></dom-if><a id="backgroundImageAttribution" hidden=""><div id="backgroundImageAttribution1Container"><div id="linkIcon" hidden=""></div><div id="backgroundImageAttribution1">
            
          </div></div><div id="backgroundImageAttribution2" hidden="">
          
        </div></a><div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId"><div id="customizeIcon"></div><div id="customizeText">
            自定义 Chrome
          </div></cr-button></div><div id="themeAttribution" hidden=""><div>主题背景创建者：</div><img src="undefined"><img></div><dom-if style="display: none;"><template></template></dom-if><div id="contentBottomSpacer"></div></div>"""

let baseUrlStr01: String = """
"""

let baseUrlStr02: String = """
你好acskafqwqew"""

let baseUrlStr03: String = """
http://example.com"""

let baseUrlStr04: String = """
http://google.com"""

let nodeStr2: String = """
&lt;!doctype html&gt;&lt;html&gt;&lt;head&gt;&lt;title&gt;Doctype test&lt;/title&gt;&lt;/head&gt;&lt;body&gt;&lt;/body&gt;&lt;/html&gt;"""

let nodeStr3: String = """
你好！@#￥%~@（￥*&amp;￥%（￥）））#。sfdadsadasads"""

let nodeStr4: String = """
&lt;div id="content" style="--color-new-tab-page-attribution-foreground: rgba(0, 0, 0, 1.00); --color-new-tab-page-most-visited-foreground: rgba(0, 0, 0, 1.00); --ntp-logo-color: inherit;"&gt;&lt;ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="&gt;&lt;/ntp-iframe&gt;&lt;dom-if style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;dom-if style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;ntp-logo id="logo"&gt;&lt;/ntp-logo&gt;&lt;div id="realboxContainer"&gt;&lt;ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""&gt;&lt;/ntp-realbox&gt;&lt;dom-if restamp="" style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;/div&gt;&lt;cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""&gt;&lt;/cr-most-visited&gt;&lt;dom-if style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;ntp-middle-slot-promo&gt;&lt;/ntp-middle-slot-promo&gt;&lt;dom-if style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;dom-if style="display: none;"&gt;&lt;template is="dom-if"&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;a id="backgroundImageAttribution" hidden=""&gt;&lt;div id="backgroundImageAttribution1Container"&gt;&lt;div id="linkIcon" hidden=""&gt;&lt;/div&gt;&lt;div id="backgroundImageAttribution1"&gt;
            
          &lt;/div&gt;&lt;/div&gt;&lt;div id="backgroundImageAttribution2" hidden=""&gt;
          
        &lt;/div&gt;&lt;/a&gt;&lt;div id="customizeButtonContainer"&gt;&lt;cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId"&gt;&lt;div id="customizeIcon"&gt;&lt;/div&gt;&lt;div id="customizeText"&gt;
            自定义 Chrome
          &lt;/div&gt;&lt;/cr-button&gt;&lt;/div&gt;&lt;div id="themeAttribution" hidden=""&gt;&lt;div&gt;主题背景创建者：&lt;/div&gt;&lt;img src="undefined"&gt;&lt;img&gt;&lt;/div&gt;&lt;dom-if style="display: none;"&gt;&lt;template&gt;&lt;/template&gt;&lt;/dom-if&gt;&lt;div id="contentBottomSpacer"&gt;&lt;/div&gt;&lt;/div&gt;"""

@Test
public class ParseParseFragmentInput02Test {
    @TestCase
    func parseParseFragmentInput01(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, element, baseUrlStr01)
        @Assert(nodeList.size, 0)
    }

    @TestCase
    func parseParseFragmentInput02(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, element, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr2)
    }

    @TestCase
    func parseParseFragmentInput03(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, element, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput04(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, element, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput05(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, element, baseUrlStr02)
        @Assert(nodeList.size, 0)
    }

    @TestCase
    func parseParseFragmentInput06(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, element, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr2)
    }

    @TestCase
    func parseParseFragmentInput07(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, element, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput08(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, element, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput09(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, element, baseUrlStr03)
        @Assert(nodeList.size, 0)
    }

    @TestCase
    func parseParseFragmentInput10(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, element, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr2)
    }

    @TestCase
    func parseParseFragmentInput11(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, element, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput12(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, element, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput13(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, element, baseUrlStr04)
        @Assert(nodeList.size, 0)
    }

    @TestCase
    func parseParseFragmentInput14(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, element, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr2)
    }

    @TestCase
    func parseParseFragmentInput15(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, element, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput16(): Unit {
        var parser: Parser = Parser.htmlParser()
        var element: Element = Element("title")
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, element, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }
}
