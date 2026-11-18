// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

let htmlStr: String = """
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

let elementStr1_1: String = """
<div id="content" style="--color-new-tab-page-attribution-foreground: rgba(0, 0, 0, 1.00); --color-new-tab-page-most-visited-foreground: rgba(0, 0, 0, 1.00); --ntp-logo-color: inherit;"><ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe><dom-if style="display: none;">
  <template is="dom-if"></template>
 </dom-if><dom-if style="display: none;">
  <template is="dom-if"></template>
 </dom-if><ntp-logo id="logo"></ntp-logo>
 <div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
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
 <div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
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
</div>"""

let elementStr1_2: String = """
<div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
  <template is="dom-if"></template>
 </dom-if>
</div>"""

let elementStr1_3: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr1_4: String = """
<div id="linkIcon" hidden></div>"""

let elementStr1_5: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr1_6: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr1_7: String = """
<div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
  <div id="customizeIcon"></div>
  <div id="customizeText">
   自定义 Chrome
  </div>
 </cr-button>
</div>"""

let elementStr1_8: String = """
<div id="customizeIcon"></div>"""

let elementStr1_9: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr1_10: String = """
<div id="themeAttribution" hidden>
 <div>
  主题背景创建者：
 </div><img src="undefined"><img>
</div>"""

let elementStr1_11: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr1_12: String = """
<div id="contentBottomSpacer"></div>"""

let elementStr2_1: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

@Test
public class SelectorSelect03Test {
    @TestCase
    func selectorSelect01(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var elements: Elements = Selector.select(EvaluatorTagEndsWithTest("div"), document)
        @Assert(elements.size, 12)
        @Assert(elements[0].outerHtml(), elementStr1_1)
        @Assert(elements[1].outerHtml(), elementStr1_2)
        @Assert(elements[2].outerHtml(), elementStr1_3)
        @Assert(elements[3].outerHtml(), elementStr1_4)
        @Assert(elements[4].outerHtml(), elementStr1_5)
        @Assert(elements[5].outerHtml(), elementStr1_6)
        @Assert(elements[6].outerHtml(), elementStr1_7)
        @Assert(elements[7].outerHtml(), elementStr1_8)
        @Assert(elements[8].outerHtml(), elementStr1_9)
        @Assert(elements[9].outerHtml(), elementStr1_10)
        @Assert(elements[10].outerHtml(), elementStr1_11)
        @Assert(elements[11].outerHtml(), elementStr1_12)
    }

    @TestCase
    func selectorSelect02(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var elements: Elements = Selector.select(EvaluatorIdTest("backgroundImageAttribution"), document)
        @Assert(elements.size, 1)
        @Assert(elements[0].outerHtml(), elementStr2_1)
    }
}

class EvaluatorTagEndsWithTest <: Evaluator {
    private var tagName: String

    init(tagName: String) {
        this.tagName = tagName
    }

    public override func matches(root: ?Element, element: Element): Bool {
        root
        return (element.normalName().endsWith(tagName))
    }

    public func toString(): String {
        return tagName
    }
}

/*
 * Evaluator for element id
 */
class EvaluatorIdTest <: Evaluator {
    private var id: String

    init(id: String) {
        this.id = id
    }

    public override func matches(root: ?Element, element: Element): Bool {
        root
        return (id == element.id())
    }

    public func toString(): String {
        return "#${id}"
    }
}
