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

let nodeStr1: String = """
<html>
 <head></head>
 <body></body>
</html>"""

let nodeStr2_1: String = """
<!doctype html>"""

let nodeStr2_2: String = """
<html>
 <head>
  <title>Doctype test</title>
 </head>
 <body></body>
</html>"""

let nodeStr3: String = """
<html>
 <head></head>
 <body>
  你好！@#￥%~@（￥*&amp;￥%（￥）））#。sfdadsadasads
 </body>
</html>"""

let nodeStr4: String = """
<html>
 <head></head>
 <body>
  <div id="content" style="--color-new-tab-page-attribution-foreground: rgba(0, 0, 0, 1.00); --color-new-tab-page-most-visited-foreground: rgba(0, 0, 0, 1.00); --ntp-logo-color: inherit;">
   <ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe><dom-if style="display: none;">
    <template is="dom-if"></template>
   </dom-if><dom-if style="display: none;">
    <template is="dom-if"></template>
   </dom-if><ntp-logo id="logo"></ntp-logo>
   <div id="realboxContainer">
    <ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
     <template is="dom-if"></template>
    </dom-if>
   </div><cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited><dom-if style="display: none;">
    <template is="dom-if"></template>
   </dom-if><ntp-middle-slot-promo></ntp-middle-slot-promo><dom-if style="display: none;">
    <template is="dom-if"></template>
   </dom-if><dom-if style="display: none;">
    <template is="dom-if"></template>
   </dom-if><a id="backgroundImageAttribution" hidden>
    <div id="backgroundImageAttribution1Container">
     <div id="linkIcon" hidden></div>
     <div id="backgroundImageAttribution1">
     </div>
    </div>
    <div id="backgroundImageAttribution2" hidden>
    </div></a>
   <div id="customizeButtonContainer">
    <cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
     <div id="customizeIcon"></div>
     <div id="customizeText">
      自定义 Chrome
     </div>
    </cr-button>
   </div>
   <div id="themeAttribution" hidden>
    <div>
     主题背景创建者：
    </div><img src="undefined"><img>
   </div><dom-if style="display: none;">
    <template></template>
   </dom-if>
   <div id="contentBottomSpacer"></div>
  </div>
 </body>
</html>"""

@Test
public class ParseParseFragmentInput01Test {
    @TestCase
    func parseParseFragmentInput01(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, None, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr1)
    }

    @TestCase
    func parseParseFragmentInput02(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, None, baseUrlStr01)
        @Assert(nodeList.size, 2)
        @Assert(nodeList[0].outerHtml(), nodeStr2_1)
        @Assert(nodeList[1].outerHtml(), nodeStr2_2)
    }

    @TestCase
    func parseParseFragmentInput03(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, None, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput04(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, None, baseUrlStr01)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput05(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, None, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr1)
    }

    @TestCase
    func parseParseFragmentInput06(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, None, baseUrlStr02)
        @Assert(nodeList.size, 2)
        @Assert(nodeList[0].outerHtml(), nodeStr2_1)
        @Assert(nodeList[1].outerHtml(), nodeStr2_2)
    }

    @TestCase
    func parseParseFragmentInput07(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, None, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput08(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, None, baseUrlStr02)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput09(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, None, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr1)
    }

    @TestCase
    func parseParseFragmentInput10(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, None, baseUrlStr03)
        @Assert(nodeList.size, 2)
        @Assert(nodeList[0].outerHtml(), nodeStr2_1)
        @Assert(nodeList[1].outerHtml(), nodeStr2_2)
    }

    @TestCase
    func parseParseFragmentInput11(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, None, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput12(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, None, baseUrlStr03)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }

    @TestCase
    func parseParseFragmentInput13(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr01, None, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr1)
    }

    @TestCase
    func parseParseFragmentInput14(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr02, None, baseUrlStr04)
        @Assert(nodeList.size, 2)
        @Assert(nodeList[0].outerHtml(), nodeStr2_1)
        @Assert(nodeList[1].outerHtml(), nodeStr2_2)
    }

    @TestCase
    func parseParseFragmentInput15(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr03, None, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr3)
    }

    @TestCase
    func parseParseFragmentInput16(): Unit {
        var parser: Parser = Parser.htmlParser()
        var nodeList: ArrayList<Node> = parser.parseFragmentInput(htmlStr04, None, baseUrlStr04)
        @Assert(nodeList.size, 1)
        @Assert(nodeList[0].outerHtml(), nodeStr4)
    }
}
