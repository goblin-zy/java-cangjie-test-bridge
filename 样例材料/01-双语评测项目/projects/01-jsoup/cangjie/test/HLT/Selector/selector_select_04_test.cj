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
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr2_2: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr2_3: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr2_4: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr2_5: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr2_6: String = """
<img src="undefined">"""

let elementStr2_7: String = """
<img src="undefined">"""

let elementStr3_1: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr3_2: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr3_3: String = """
<div id="linkIcon" hidden></div>"""

let elementStr3_4: String = """
<div id="customizeIcon"></div>"""

let elementStr3_5: String = """
<img src="undefined">"""

let elementStr3_6: String = """
<dom-if style="display: none;">
 <template></template>
</dom-if>"""

let elementStr3_7: String = """
<ntp-logo id="logo"></ntp-logo>"""

let elementStr4_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr4_2: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr4_3: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr4_4: String = """
<div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
  <div id="customizeIcon"></div>
  <div id="customizeText">
   自定义 Chrome
  </div>
 </cr-button>
</div>"""

let elementStr4_5: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr4_6: String = """
<img>"""

let elementStr5_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr5_2: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr5_3: String = """
<div id="linkIcon" hidden></div>"""

let elementStr5_4: String = """
<div id="customizeIcon"></div>"""

let elementStr5_5: String = """
<div id="themeAttribution" hidden>
 <div>
  主题背景创建者：
 </div><img src="undefined"><img>
</div>"""

let elementStr5_6: String = """
<img src="undefined">"""
let elementStr6_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr6_2: String = """
<template is="dom-if"></template>"""

let elementStr6_3: String = """
<template is="dom-if"></template>"""

let elementStr6_4: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr6_5: String = """
<template is="dom-if"></template>"""

let elementStr6_6: String = """
<template is="dom-if"></template>"""

let elementStr6_7: String = """
<template is="dom-if"></template>"""

let elementStr6_8: String = """
<template is="dom-if"></template>"""

let elementStr6_9: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr6_10: String = """
<div id="linkIcon" hidden></div>"""

let elementStr6_11: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr6_12: String = """
<div id="customizeIcon"></div>"""

let elementStr6_13: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr6_14: String = """
<template></template>"""

let elementStr7_1: String = """
<template is="dom-if"></template>"""

let elementStr7_2: String = """
<template is="dom-if"></template>"""

let elementStr7_3: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr7_4: String = """
<template is="dom-if"></template>"""

let elementStr7_5: String = """
<template is="dom-if"></template>"""

let elementStr7_6: String = """
<template is="dom-if"></template>"""

let elementStr7_7: String = """
<template is="dom-if"></template>"""

let elementStr7_8: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr7_9: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr7_10: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr7_11: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr7_12: String = """
<img>"""

let elementStr7_13: String = """
<template></template>"""

let elementStr7_14: String = """
<div id="contentBottomSpacer"></div>"""

let elementStr8_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr8_2: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr8_3: String = """
<template is="dom-if"></template>"""

let elementStr8_4: String = """
<template is="dom-if"></template>"""

let elementStr8_5: String = """
<ntp-logo id="logo"></ntp-logo>"""

let elementStr8_6: String = """
<div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
  <template is="dom-if"></template>
 </dom-if>
</div>"""

let elementStr8_7: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr8_8: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr8_9: String = """
<template is="dom-if"></template>"""

let elementStr8_10: String = """
<cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited>"""

let elementStr8_11: String = """
<template is="dom-if"></template>"""

let elementStr8_12: String = """
<ntp-middle-slot-promo></ntp-middle-slot-promo>"""

let elementStr8_13: String = """
<template is="dom-if"></template>"""

let elementStr8_14: String = """
<template is="dom-if"></template>"""

let elementStr8_15: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr8_16: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr8_17: String = """
<div id="linkIcon" hidden></div>"""

let elementStr8_18: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr8_19: String = """
<div id="customizeIcon"></div>"""

let elementStr8_20: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr8_21: String = """
<img src="undefined">"""

let elementStr8_22: String = """
<template></template>"""

let elementStr9_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr9_2: String = """
<template is="dom-if"></template>"""

let elementStr9_3: String = """
<template is="dom-if"></template>"""

let elementStr9_4: String = """
<ntp-logo id="logo"></ntp-logo>"""

let elementStr9_5: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr9_6: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr9_7: String = """
<template is="dom-if"></template>"""

let elementStr9_8: String = """
<cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited>"""

let elementStr9_9: String = """
<template is="dom-if"></template>"""

let elementStr9_10: String = """
<ntp-middle-slot-promo></ntp-middle-slot-promo>"""

let elementStr9_11: String = """
<template is="dom-if"></template>"""

let elementStr9_12: String = """
<template is="dom-if"></template>"""

let elementStr9_13: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr9_14: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr9_15: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr9_16: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr9_17: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr9_18: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr9_19: String = """
<img>"""

let elementStr9_20: String = """
<dom-if style="display: none;">
 <template></template>
</dom-if>"""

let elementStr9_21: String = """
<template></template>"""

let elementStr9_22: String = """
<div id="contentBottomSpacer"></div>"""

let elementStr10_1: String = """
<template is="dom-if"></template>"""

let elementStr10_2: String = """
<template is="dom-if"></template>"""

let elementStr10_3: String = """
<template is="dom-if"></template>"""

let elementStr10_4: String = """
<template is="dom-if"></template>"""

let elementStr10_5: String = """
<template is="dom-if"></template>"""

let elementStr10_6: String = """
<template is="dom-if"></template>"""

let elementStr10_7: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr10_8: String = """
<template></template>"""

let elementStr11_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr11_2: String = """
<template is="dom-if"></template>"""

let elementStr11_3: String = """
<template is="dom-if"></template>"""

let elementStr11_4: String = """
<ntp-logo id="logo"></ntp-logo>"""

let elementStr11_5: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr11_6: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr11_7: String = """
<template is="dom-if"></template>"""

let elementStr11_8: String = """
<cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited>"""

let elementStr11_9: String = """
<template is="dom-if"></template>"""

let elementStr11_10: String = """
<ntp-middle-slot-promo></ntp-middle-slot-promo>"""

let elementStr11_11: String = """
<template is="dom-if"></template>"""

let elementStr11_12: String = """
<template is="dom-if"></template>"""

let elementStr11_13: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr11_14: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr11_15: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr11_16: String = """
<template></template>"""

let elementStr12_1: String = """
<ntp-iframe id="oneGoogleBar" allow="camera chrome-untrusted://new-tab-page; display-capture chrome-untrusted://new-tab-page" src="chrome-untrusted://new-tab-page/one-google-bar?paramsencoded="></ntp-iframe>"""

let elementStr12_2: String = """
<template is="dom-if"></template>"""

let elementStr12_3: String = """
<template is="dom-if"></template>"""

let elementStr12_4: String = """
<ntp-logo id="logo"></ntp-logo>"""

let elementStr12_5: String = """
<ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox>"""

let elementStr12_6: String = """
<template is="dom-if"></template>"""

let elementStr12_7: String = """
<cr-most-visited id="mostVisited" visible_="" custom-links-enabled_=""></cr-most-visited>"""

let elementStr12_8: String = """
<template is="dom-if"></template>"""

let elementStr12_9: String = """
<ntp-middle-slot-promo></ntp-middle-slot-promo>"""

let elementStr12_10: String = """
<template is="dom-if"></template>"""

let elementStr12_11: String = """
<template is="dom-if"></template>"""

let elementStr12_12: String = """
<div id="linkIcon" hidden></div>"""

let elementStr12_13: String = """
<div id="customizeIcon"></div>"""

let elementStr12_14: String = """
<img src="undefined">"""

let elementStr12_15: String = """
<img>"""

let elementStr12_16: String = """
<template></template>"""

let elementStr12_17: String = """
<div id="contentBottomSpacer"></div>"""

let elementStr13_1: String = """
"""

let elementStr13_2: String = """
"""

let elementStr13_3: String = """
"""

let elementStr13_4: String = """
"""

let elementStr13_5: String = """
"""

let elementStr13_6: String = """
"""

let elementStr13_7: String = """
"""

let elementStr13_8: String = """
"""

let elementStr13_9: String = """
"""

let elementStr13_10: String = """
"""

let elementStr13_11: String = """
"""

let elementStr13_12: String = """
"""

let elementStr13_13: String = """
"""

let elementStr13_14: String = """
"""

let elementStr13_15: String = """
"""

let elementStr13_16: String = """
"""

let elementStr13_17: String = """
 """

let elementStr13_18: String = """
"""

let elementStr13_19: String = """
"""

let elementStr13_20: String = """
"""

let elementStr13_21: String = """
"""

let elementStr13_22: String = """
 """

let elementStr13_23: String = """
"""

let elementStr13_24: String = """
"""

let elementStr13_25: String = """
"""

let elementStr13_26: String = """
"""

let elementStr13_27: String = """
"""

let elementStr13_28: String = """

 自定义 Chrome"""

let elementStr13_29: String = """
"""

let elementStr13_30: String = """
"""

let elementStr13_31: String = """
"""

let elementStr13_32: String = """
"""

let elementStr13_33: String = """

 主题背景创建者："""

let elementStr13_34: String = """
"""

let elementStr13_35: String = """
"""

let elementStr13_36: String = """
"""

let elementStr13_37: String = """
"""

let elementStr13_38: String = """
"""

let elementStr14_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_2: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_3: String = """
<div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
  <template is="dom-if"></template>
 </dom-if>
</div>"""

let elementStr14_4: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_5: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_6: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_7: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr14_8: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr14_9: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr14_10: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr14_11: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr14_12: String = """
<div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
  <div id="customizeIcon"></div>
  <div id="customizeText">
   自定义 Chrome
  </div>
 </cr-button>
</div>"""

let elementStr14_13: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr14_14: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr14_15: String = """
<div id="themeAttribution" hidden>
 <div>
  主题背景创建者：
 </div><img src="undefined"><img>
</div>"""

let elementStr14_16: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr14_17: String = """
<dom-if style="display: none;">
 <template></template>
</dom-if>"""

let elementStr15_1: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_2: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_3: String = """
<div id="realboxContainer"><ntp-realbox id="realbox" realbox-lens-search-enabled="" realbox-lens-search-enabled_="" shown="" can-show-secondary-side=""></ntp-realbox><dom-if restamp="" style="display: none;">
  <template is="dom-if"></template>
 </dom-if>
</div>"""

let elementStr15_4: String = """
<dom-if restamp="" style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_5: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_6: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_7: String = """
<dom-if style="display: none;">
 <template is="dom-if"></template>
</dom-if>"""

let elementStr15_8: String = """
<a id="backgroundImageAttribution" hidden>
 <div id="backgroundImageAttribution1Container">
  <div id="linkIcon" hidden></div>
  <div id="backgroundImageAttribution1">
  </div>
 </div>
 <div id="backgroundImageAttribution2" hidden>
 </div></a>"""

let elementStr15_9: String = """
<div id="backgroundImageAttribution1Container">
 <div id="linkIcon" hidden></div>
 <div id="backgroundImageAttribution1">
 </div>
</div>"""

let elementStr15_10: String = """
<div id="backgroundImageAttribution1">
</div>"""

let elementStr15_11: String = """
<div id="backgroundImageAttribution2" hidden>
</div>"""

let elementStr15_12: String = """
<div id="customizeButtonContainer"><cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
  <div id="customizeIcon"></div>
  <div id="customizeText">
   自定义 Chrome
  </div>
 </cr-button>
</div>"""

let elementStr15_13: String = """
<cr-button id="customizeButton" title="自定义此页" aria-pressed="false" role="button" tabindex="0" aria-disabled="false" data-native-id="NewTabPageUI::kCustomizeChromeButtonElementId">
 <div id="customizeIcon"></div>
 <div id="customizeText">
  自定义 Chrome
 </div>
</cr-button>"""

let elementStr15_14: String = """
<div id="customizeText">
 自定义 Chrome
</div>"""

let elementStr15_15: String = """
<div id="themeAttribution" hidden>
 <div>
  主题背景创建者：
 </div><img src="undefined"><img>
</div>"""

let elementStr15_16: String = """
<div>
 主题背景创建者：
</div>"""

let elementStr15_17: String = """
<dom-if style="display: none;">
 <template></template>
</dom-if>"""

@Test
public class SelectorSelect03Test {
    @TestCase
    func selectorSelect01(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select(":root", elements1)
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
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :nth-child(2)", elements1)
        @Assert(elements.size, 6)
        @Assert(elements[0].outerHtml(), elementStr2_1)
        @Assert(elements[1].outerHtml(), elementStr2_2)
        @Assert(elements[2].outerHtml(), elementStr2_3)
        @Assert(elements[3].outerHtml(), elementStr2_4)
        @Assert(elements[4].outerHtml(), elementStr2_5)
        @Assert(elements[5].outerHtml(), elementStr2_6)

        var elements2: Elements = Selector.select("div :nth-child(12)", elements1)
        @Assert(elements2.size, 1)
        @Assert(elements2[0].outerHtml(), elementStr1_7)
    }

    @TestCase
    func selectorSelect03(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :nth-last-child(2)", elements1)
        @Assert(elements.size, 6)
        @Assert(elements[0].outerHtml(), elementStr3_1)
        @Assert(elements[1].outerHtml(), elementStr3_2)
        @Assert(elements[2].outerHtml(), elementStr3_3)
        @Assert(elements[3].outerHtml(), elementStr3_4)
        @Assert(elements[4].outerHtml(), elementStr3_5)
        @Assert(elements[5].outerHtml(), elementStr3_6)

        var elements2: Elements = Selector.select("div :nth-last-child(12)", elements1)
        @Assert(elements2.size, 1)
        @Assert(elements2[0].outerHtml(), elementStr3_7)
    }

    @TestCase
    func selectorSelect04(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :nth-of-type(2)", elements1)
        @Assert(elements.size, 6)
        @Assert(elements[0].outerHtml(), elementStr4_1)
        @Assert(elements[1].outerHtml(), elementStr4_2)
        @Assert(elements[2].outerHtml(), elementStr4_3)
        @Assert(elements[3].outerHtml(), elementStr4_4)
        @Assert(elements[4].outerHtml(), elementStr4_5)
        @Assert(elements[5].outerHtml(), elementStr4_6)

        var elements2: Elements = Selector.select("div :nth-of-type(12)", elements1)
        @Assert(elements2.size, 0)
    }

    @TestCase
    func selectorSelect05(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :nth-last-of-type(2)", elements1)
        @Assert(elements.size, 6)
        @Assert(elements[0].outerHtml(), elementStr5_1)
        @Assert(elements[1].outerHtml(), elementStr5_2)
        @Assert(elements[2].outerHtml(), elementStr5_3)
        @Assert(elements[3].outerHtml(), elementStr5_4)
        @Assert(elements[4].outerHtml(), elementStr5_5)
        @Assert(elements[5].outerHtml(), elementStr5_6)

        var elements2: Elements = Selector.select("div :nth-last-of-type(12)", elements1)
        @Assert(elements2.size, 0)
    }

    @TestCase
    func selectorSelect06(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :first-child", elements1)
        @Assert(elements.size, 14)
        @Assert(elements[0].outerHtml(), elementStr6_1)
        @Assert(elements[1].outerHtml(), elementStr6_2)
        @Assert(elements[2].outerHtml(), elementStr6_3)
        @Assert(elements[3].outerHtml(), elementStr6_4)
        @Assert(elements[4].outerHtml(), elementStr6_5)
        @Assert(elements[5].outerHtml(), elementStr6_6)
        @Assert(elements[6].outerHtml(), elementStr6_7)
        @Assert(elements[7].outerHtml(), elementStr6_8)
        @Assert(elements[8].outerHtml(), elementStr6_9)
        @Assert(elements[9].outerHtml(), elementStr6_10)
        @Assert(elements[10].outerHtml(), elementStr6_11)
        @Assert(elements[11].outerHtml(), elementStr6_12)
        @Assert(elements[12].outerHtml(), elementStr6_13)
        @Assert(elements[13].outerHtml(), elementStr6_14)
    }

    @TestCase
    func selectorSelect07(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :last-child", elements1)
        @Assert(elements.size, 14)
        @Assert(elements[0].outerHtml(), elementStr7_1)
        @Assert(elements[1].outerHtml(), elementStr7_2)
        @Assert(elements[2].outerHtml(), elementStr7_3)
        @Assert(elements[3].outerHtml(), elementStr7_4)
        @Assert(elements[4].outerHtml(), elementStr7_5)
        @Assert(elements[5].outerHtml(), elementStr7_6)
        @Assert(elements[6].outerHtml(), elementStr7_7)
        @Assert(elements[7].outerHtml(), elementStr7_8)
        @Assert(elements[8].outerHtml(), elementStr7_9)
        @Assert(elements[9].outerHtml(), elementStr7_10)
        @Assert(elements[10].outerHtml(), elementStr7_11)
        @Assert(elements[11].outerHtml(), elementStr7_12)
        @Assert(elements[12].outerHtml(), elementStr7_13)
        @Assert(elements[13].outerHtml(), elementStr7_14)
    }

    @TestCase
    func selectorSelect08(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :first-of-type", elements1)
        @Assert(elements.size, 22)
        @Assert(elements[0].outerHtml(), elementStr8_1)
        @Assert(elements[1].outerHtml(), elementStr8_2)
        @Assert(elements[2].outerHtml(), elementStr8_3)
        @Assert(elements[3].outerHtml(), elementStr8_4)
        @Assert(elements[4].outerHtml(), elementStr8_5)
        @Assert(elements[5].outerHtml(), elementStr8_6)
        @Assert(elements[6].outerHtml(), elementStr8_7)
        @Assert(elements[7].outerHtml(), elementStr8_8)
        @Assert(elements[8].outerHtml(), elementStr8_9)
        @Assert(elements[9].outerHtml(), elementStr8_10)
        @Assert(elements[10].outerHtml(), elementStr8_11)
        @Assert(elements[11].outerHtml(), elementStr8_12)
        @Assert(elements[12].outerHtml(), elementStr8_13)
        @Assert(elements[13].outerHtml(), elementStr8_14)
        @Assert(elements[14].outerHtml(), elementStr8_15)
        @Assert(elements[15].outerHtml(), elementStr8_16)
        @Assert(elements[16].outerHtml(), elementStr8_17)
        @Assert(elements[17].outerHtml(), elementStr8_18)
        @Assert(elements[18].outerHtml(), elementStr8_19)
        @Assert(elements[19].outerHtml(), elementStr8_20)
        @Assert(elements[20].outerHtml(), elementStr8_21)
        @Assert(elements[21].outerHtml(), elementStr8_22)
    }

    @TestCase
    func selectorSelect09(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :last-of-type", elements1)
        @Assert(elements.size, 22)
        @Assert(elements[0].outerHtml(), elementStr9_1)
        @Assert(elements[1].outerHtml(), elementStr9_2)
        @Assert(elements[2].outerHtml(), elementStr9_3)
        @Assert(elements[3].outerHtml(), elementStr9_4)
        @Assert(elements[4].outerHtml(), elementStr9_5)
        @Assert(elements[5].outerHtml(), elementStr9_6)
        @Assert(elements[6].outerHtml(), elementStr9_7)
        @Assert(elements[7].outerHtml(), elementStr9_8)
        @Assert(elements[8].outerHtml(), elementStr9_9)
        @Assert(elements[9].outerHtml(), elementStr9_10)
        @Assert(elements[10].outerHtml(), elementStr9_11)
        @Assert(elements[11].outerHtml(), elementStr9_12)
        @Assert(elements[12].outerHtml(), elementStr9_13)
        @Assert(elements[13].outerHtml(), elementStr9_14)
        @Assert(elements[14].outerHtml(), elementStr9_15)
        @Assert(elements[15].outerHtml(), elementStr9_16)
        @Assert(elements[16].outerHtml(), elementStr9_17)
        @Assert(elements[17].outerHtml(), elementStr9_18)
        @Assert(elements[18].outerHtml(), elementStr9_19)
        @Assert(elements[19].outerHtml(), elementStr9_20)
        @Assert(elements[20].outerHtml(), elementStr9_21)
        @Assert(elements[21].outerHtml(), elementStr9_22)
    }

    @TestCase
    func selectorSelect10(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :only-child", elements1)
        @Assert(elements.size, 8)
        @Assert(elements[0].outerHtml(), elementStr10_1)
        @Assert(elements[1].outerHtml(), elementStr10_2)
        @Assert(elements[2].outerHtml(), elementStr10_3)
        @Assert(elements[3].outerHtml(), elementStr10_4)
        @Assert(elements[4].outerHtml(), elementStr10_5)
        @Assert(elements[5].outerHtml(), elementStr10_6)
        @Assert(elements[6].outerHtml(), elementStr10_7)
        @Assert(elements[7].outerHtml(), elementStr10_8)
    }

    @TestCase
    func selectorSelect11(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :only-of-type", elements1)
        @Assert(elements.size, 16)
        @Assert(elements[0].outerHtml(), elementStr11_1)
        @Assert(elements[1].outerHtml(), elementStr11_2)
        @Assert(elements[2].outerHtml(), elementStr11_3)
        @Assert(elements[3].outerHtml(), elementStr11_4)
        @Assert(elements[4].outerHtml(), elementStr11_5)
        @Assert(elements[5].outerHtml(), elementStr11_6)
        @Assert(elements[6].outerHtml(), elementStr11_7)
        @Assert(elements[7].outerHtml(), elementStr11_8)
        @Assert(elements[8].outerHtml(), elementStr11_9)
        @Assert(elements[9].outerHtml(), elementStr11_10)
        @Assert(elements[10].outerHtml(), elementStr11_11)
        @Assert(elements[11].outerHtml(), elementStr11_12)
        @Assert(elements[12].outerHtml(), elementStr11_13)
        @Assert(elements[13].outerHtml(), elementStr11_14)
        @Assert(elements[14].outerHtml(), elementStr11_15)
        @Assert(elements[15].outerHtml(), elementStr11_16)
    }

    @TestCase
    func selectorSelect12(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :empty", elements1)
        @Assert(elements.size, 17)
        @Assert(elements[0].outerHtml(), elementStr12_1)
        @Assert(elements[1].outerHtml(), elementStr12_2)
        @Assert(elements[2].outerHtml(), elementStr12_3)
        @Assert(elements[3].outerHtml(), elementStr12_4)
        @Assert(elements[4].outerHtml(), elementStr12_5)
        @Assert(elements[5].outerHtml(), elementStr12_6)
        @Assert(elements[6].outerHtml(), elementStr12_7)
        @Assert(elements[7].outerHtml(), elementStr12_8)
        @Assert(elements[8].outerHtml(), elementStr12_9)
        @Assert(elements[9].outerHtml(), elementStr12_10)
        @Assert(elements[10].outerHtml(), elementStr12_11)
        @Assert(elements[11].outerHtml(), elementStr12_12)
        @Assert(elements[12].outerHtml(), elementStr12_13)
        @Assert(elements[13].outerHtml(), elementStr12_14)
        @Assert(elements[14].outerHtml(), elementStr12_15)
        @Assert(elements[15].outerHtml(), elementStr12_16)
        @Assert(elements[16].outerHtml(), elementStr12_17)
    }

    @TestCase
    func selectorSelect13(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :matchText", elements1)
        @Assert(elements.size, 38)
        @Assert(elements[0].outerHtml(), elementStr13_1)
        @Assert(elements[1].outerHtml(), elementStr13_2)
        @Assert(elements[2].outerHtml(), elementStr13_3)
        @Assert(elements[3].outerHtml(), elementStr13_4)
        @Assert(elements[4].outerHtml(), elementStr13_5)
        @Assert(elements[5].outerHtml(), elementStr13_6)
        @Assert(elements[6].outerHtml(), elementStr13_7)
        @Assert(elements[7].outerHtml(), elementStr13_8)
        @Assert(elements[8].outerHtml(), elementStr13_9)
        @Assert(elements[9].outerHtml(), elementStr13_10)
        @Assert(elements[10].outerHtml(), elementStr13_11)
        @Assert(elements[11].outerHtml(), elementStr13_12)
        @Assert(elements[12].outerHtml(), elementStr13_13)
        @Assert(elements[13].outerHtml(), elementStr13_14)
        @Assert(elements[14].outerHtml(), elementStr13_15)
        @Assert(elements[15].outerHtml(), elementStr13_16)
        @Assert(elements[16].outerHtml(), elementStr13_17)
        @Assert(elements[17].outerHtml(), elementStr13_18)
        @Assert(elements[18].outerHtml(), elementStr13_19)
        @Assert(elements[19].outerHtml(), elementStr13_20)
        @Assert(elements[20].outerHtml(), elementStr13_21)
        @Assert(elements[21].outerHtml(), elementStr13_22)
        @Assert(elements[22].outerHtml(), elementStr13_23)
        @Assert(elements[23].outerHtml(), elementStr13_24)
        @Assert(elements[24].outerHtml(), elementStr13_25)
        @Assert(elements[25].outerHtml(), elementStr13_26)
        @Assert(elements[26].outerHtml(), elementStr13_27)
        @Assert(elements[27].outerHtml(), elementStr13_28)
        @Assert(elements[28].outerHtml(), elementStr13_29)
        @Assert(elements[29].outerHtml(), elementStr13_30)
        @Assert(elements[30].outerHtml(), elementStr13_31)
        @Assert(elements[31].outerHtml(), elementStr13_32)
        @Assert(elements[32].outerHtml(), elementStr13_33)
        @Assert(elements[33].outerHtml(), elementStr13_34)
        @Assert(elements[34].outerHtml(), elementStr13_35)
        @Assert(elements[35].outerHtml(), elementStr13_36)
        @Assert(elements[36].outerHtml(), elementStr13_37)
        @Assert(elements[37].outerHtml(), elementStr13_38)
    }

    @TestCase
    func selectorSelect14(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :matchesWholeOwnText(\n)", elements1)
        @Assert(elements.size, 17)
        @Assert(elements[0].outerHtml(), elementStr14_1)
        @Assert(elements[1].outerHtml(), elementStr14_2)
        @Assert(elements[2].outerHtml(), elementStr14_3)
        @Assert(elements[3].outerHtml(), elementStr14_4)
        @Assert(elements[4].outerHtml(), elementStr14_5)
        @Assert(elements[5].outerHtml(), elementStr14_6)
        @Assert(elements[6].outerHtml(), elementStr14_7)
        @Assert(elements[7].outerHtml(), elementStr14_8)
        @Assert(elements[8].outerHtml(), elementStr14_9)
        @Assert(elements[9].outerHtml(), elementStr14_10)
        @Assert(elements[10].outerHtml(), elementStr14_11)
        @Assert(elements[11].outerHtml(), elementStr14_12)
        @Assert(elements[12].outerHtml(), elementStr14_13)
        @Assert(elements[13].outerHtml(), elementStr14_14)
        @Assert(elements[14].outerHtml(), elementStr14_15)
        @Assert(elements[15].outerHtml(), elementStr14_16)
        @Assert(elements[16].outerHtml(), elementStr14_17)
    }

    @TestCase
    func selectorSelect15(): Unit {
        var elements1: Elements = Html4cj.parse(htmlStr).select("div")
        var elements: Elements = Selector.select("div :matchesWholeText(\\s{2,})", elements1)
        @Assert(elements.size, 17)
        @Assert(elements[0].outerHtml(), elementStr15_1)
        @Assert(elements[1].outerHtml(), elementStr15_2)
        @Assert(elements[2].outerHtml(), elementStr15_3)
        @Assert(elements[3].outerHtml(), elementStr15_4)
        @Assert(elements[4].outerHtml(), elementStr15_5)
        @Assert(elements[5].outerHtml(), elementStr15_6)
        @Assert(elements[6].outerHtml(), elementStr15_7)
        @Assert(elements[7].outerHtml(), elementStr15_8)
        @Assert(elements[8].outerHtml(), elementStr15_9)
        @Assert(elements[9].outerHtml(), elementStr15_10)
        @Assert(elements[10].outerHtml(), elementStr15_11)
        @Assert(elements[11].outerHtml(), elementStr15_12)
        @Assert(elements[12].outerHtml(), elementStr15_13)
        @Assert(elements[13].outerHtml(), elementStr15_14)
        @Assert(elements[14].outerHtml(), elementStr15_15)
        @Assert(elements[15].outerHtml(), elementStr15_16)
        @Assert(elements[16].outerHtml(), elementStr15_17)
    }
}
