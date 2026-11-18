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

let elementStr1: String = """
<html>
 <head></head>
 <body>
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
  </div>
 </body>
</html>"""

let elementStr2_1: String = """
<div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
  <template is="dom-if"></template>
 </dom-if>
</div>"""

let elementStr2_2: String = """
<div id="contentBottomSpacer"></div>"""

let elementStr3_1: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr3_2: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr4_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr5_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr6_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr7_1: String = """
<template is="dom-if"></template>"""

let elementStr8_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr9_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr10_1: String = """
<template is="dom-if"></template>"""

let elementStr11_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr12_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr13_1: String = """
"""

let elementStr14_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

@Test
public class SelectorSelect05Test {
    @TestCase
    func selectorSelect01(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst(":root", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr1)
    }

    @TestCase
    func selectorSelect02(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :nth-child(5)", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr2_1)

        var element2: Element = Selector.selectFirst("div :nth-child(15)", document).getOrThrow()
        @Assert(element2.outerHtml(), elementStr2_2)
    }

    @TestCase
    func selectorSelect03(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :nth-last-child(5)", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr3_1)

        var element2: Element = Selector.selectFirst("div :nth-last-child(15)", document).getOrThrow()
        @Assert(element2.outerHtml(), elementStr3_2)
    }

    @TestCase
    func selectorSelect04(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :nth-of-type(5)", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr4_1)

        var element2: ?Element = Selector.selectFirst("div :nth-of-type(15)", document)
        @Assert(element2 == None, true)
    }

    @TestCase
    func selectorSelect05(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :nth-last-of-type(5)", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr5_1)

        var element2: ?Element = Selector.selectFirst("div :nth-last-of-type(15)", document)
        @Assert(element2 == None, true)
    }

    @TestCase
    func selectorSelect06(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :first-child", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr6_1)
    }

    @TestCase
    func selectorSelect07(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :last-child", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr7_1)
    }

    @TestCase
    func selectorSelect08(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :first-of-type", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr8_1)
    }

    @TestCase
    func selectorSelect09(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :last-of-type", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr9_1)
    }

    @TestCase
    func selectorSelect10(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :only-child", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr10_1)
    }

    @TestCase
    func selectorSelect11(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :only-of-type", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr11_1)
    }

    @TestCase
    func selectorSelect12(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :empty", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr12_1)
    }

    @TestCase
    func selectorSelect13(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :matchText", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr13_1)
    }

    @TestCase
    func selectorSelect14(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :matchesWholeOwnText(\n)", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr14_1)
    }

    @TestCase
    func selectorSelect15(): Unit {
        var document: Document = Html4cj.parse(htmlStr)
        var element: Element = Selector.selectFirst("div :matchesWholeText(\\s{2,})", document).getOrThrow()
        @Assert(element.outerHtml(), elementStr15_1)
    }
}
