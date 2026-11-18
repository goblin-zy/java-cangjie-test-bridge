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
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>
<meta http-equiv="Content-Type" content="text/html">
<!-- CSS Tabs is licensed under Creative Commons Attribution 3.0 - http://creativecommons.org/licenses/by/3.0/ -->
<style type="text/css">

body {
font: 100% verdana, arial, sans-serif;
background-color: #fff;
}

/* begin css tabs */

ul#tabnav { /* general settings */
text-align: left; /* set to left, right or center */
margin: 8px 0 0 0; /* set margins as desired */
font: bold 11px verdana, arial, sans-serif; /* set font as desired */
border-bottom: 1px solid #6c6; /* set border COLOR as desired */
list-style-type: none;
padding: 3px 10px 0px 10px;
}

ul#tabnav li { /* do not change */
display: inline-block;
}

ul#tabnav li.selected { /* settings for selected tab */
border-bottom: 1px solid #fff; /* set border color to page background color */
background-color: #fff; /* set background color to match above border color */
}


ul#tabnav li { /* settings for all tab links */
padding: 3px 4px;
border: 1px solid #6c6; /* set border COLOR as desired; usually matches border color specified in #tabnav */
border-bottom: 1px solid #cfc;
background-color: #cfc; /* set unselected tab background color as desired */
color: #666; /* set unselected tab link color as desired */
margin-right: 0px; /* set additional spacing between tabs as desired */
text-decoration: none;
cursor: pointer;
}

ul#tabnav li:hover { /* settings for hover effect */
background: #afa; /* set desired hover color */
}

/* end css tabs */

/* FF 100% height iframe */
html, body, div, iframe { margin:0; padding:0; }
iframe { display:block; width:100%; border:none; }

h1
{
    display: inline;
    float: left;
    font-size: small;
    margin: 0;
    padding: 0 10px;
}

h2
{
    display: inline;
    float: right;
    font-size: small;
    margin: 0;
    padding: 0 10px;
}

</style>

<script type="text/javascript">
function updateBody(tabId, page) {
    document.getElementById(selectedTab).setAttribute("class", "unselected");
    tab = document.getElementById(tabId)
    tab.setAttribute("class", "selected");
    selectedTab = tabId;
    iframe = document.getElementById("myframe");
    iframe.src = encodeURIComponent(tab.getAttribute("value")).replace(/%2F/g, '/');
}
function init(tabId){
	updateBody(tabId);
	updateViewport();
	
	window.onresize = updateViewport;
}

function updateViewport(){
	 var viewportheight;

	 // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight

	 if (typeof window.innerWidth != 'undefined')
	 {
	      viewportheight = window.innerHeight
	 }

	// IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

	 else if (typeof document.documentElement != 'undefined'
	     && typeof document.documentElement.clientWidth !=
	     'undefined' && document.documentElement.clientWidth != 0)
	 {
	       viewportheight = document.documentElement.clientHeight
	 }
	// older versions of IE
	 else
	 { 
	       viewportheight = document.getElementsByTagName('body')[0].clientHeight
	 }
	
	iframe = document.getElementById("myframe");
	iframe.style.height = (viewportheight-30)+'px';
}
var selectedTab = "tab1"
</script>

</head>

<body onload="init('tab1');">

<h1><a id="hudson_link" href="/jenkins/job/ci_daily_check/">Back to ci_daily_check</a></h1>
<h2><a id="zip_link" href="*zip*/_e680bb_e4bd93_e79c8b_e69dbf.zip">Zip</a></h2>

<ul id="tabnav">
<li id="tab1" class="selected" onclick="updateBody('tab1')" value="index.html">index</li><script type="text/javascript">document.getElementById("hudson_link").innerHTML="Back to ci_daily_check";</script><script type="text/javascript">document.getElementById("hudson_link").href="/jenkins/job/ci_daily_check/";</script><script type="text/javascript">document.getElementById("zip_link").href="*zip*/_e680bb_e4bd93_e79c8b_e69dbf.zip";</script></ul>
<div>
<iframe id="myframe" height="100%" width="100%" frameborder="0" src="index.html" style="height: 1949px;"></iframe>
</div>



</body></html>"""

let baseUrlStr01: String = """
"""

let baseUrlStr02: String = """
你好acskafqwqew"""

let baseUrlStr03: String = """
http://example.com"""

let baseUrlStr04: String = """
http://google.com"""

let docStr01: String = """
<html>
 <head></head>
 <body></body>
</html>"""

let docStr02: String = """
<!doctype html>
<html>
 <head>
  <title>Doctype test</title>
 </head>
 <body></body>
</html>"""

let docStr03: String = """
<html>
 <head></head>
 <body>
  你好！@#￥%~@（￥*&amp;￥%（￥）））#。sfdadsadasads
 </body>
</html>"""

let docStr04: String = """
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
 <head>
  <meta http-equiv="Content-Type" content="text/html"><!-- CSS Tabs is licensed under Creative Commons Attribution 3.0 - http://creativecommons.org/licenses/by/3.0/ -->
  <style type="text/css">

body {
font: 100% verdana, arial, sans-serif;
background-color: #fff;
}

/* begin css tabs */

ul#tabnav { /* general settings */
text-align: left; /* set to left, right or center */
margin: 8px 0 0 0; /* set margins as desired */
font: bold 11px verdana, arial, sans-serif; /* set font as desired */
border-bottom: 1px solid #6c6; /* set border COLOR as desired */
list-style-type: none;
padding: 3px 10px 0px 10px;
}

ul#tabnav li { /* do not change */
display: inline-block;
}

ul#tabnav li.selected { /* settings for selected tab */
border-bottom: 1px solid #fff; /* set border color to page background color */
background-color: #fff; /* set background color to match above border color */
}


ul#tabnav li { /* settings for all tab links */
padding: 3px 4px;
border: 1px solid #6c6; /* set border COLOR as desired; usually matches border color specified in #tabnav */
border-bottom: 1px solid #cfc;
background-color: #cfc; /* set unselected tab background color as desired */
color: #666; /* set unselected tab link color as desired */
margin-right: 0px; /* set additional spacing between tabs as desired */
text-decoration: none;
cursor: pointer;
}

ul#tabnav li:hover { /* settings for hover effect */
background: #afa; /* set desired hover color */
}

/* end css tabs */

/* FF 100% height iframe */
html, body, div, iframe { margin:0; padding:0; }
iframe { display:block; width:100%; border:none; }

h1
{
    display: inline;
    float: left;
    font-size: small;
    margin: 0;
    padding: 0 10px;
}

h2
{
    display: inline;
    float: right;
    font-size: small;
    margin: 0;
    padding: 0 10px;
}

</style>
  <script type="text/javascript">
function updateBody(tabId, page) {
    document.getElementById(selectedTab).setAttribute("class", "unselected");
    tab = document.getElementById(tabId)
    tab.setAttribute("class", "selected");
    selectedTab = tabId;
    iframe = document.getElementById("myframe");
    iframe.src = encodeURIComponent(tab.getAttribute("value")).replace(/%2F/g, '/');
}
function init(tabId){
	updateBody(tabId);
	updateViewport();
	
	window.onresize = updateViewport;
}

function updateViewport(){
	 var viewportheight;

	 // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight

	 if (typeof window.innerWidth != 'undefined')
	 {
	      viewportheight = window.innerHeight
	 }

	// IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

	 else if (typeof document.documentElement != 'undefined'
	     && typeof document.documentElement.clientWidth !=
	     'undefined' && document.documentElement.clientWidth != 0)
	 {
	       viewportheight = document.documentElement.clientHeight
	 }
	// older versions of IE
	 else
	 { 
	       viewportheight = document.getElementsByTagName('body')[0].clientHeight
	 }
	
	iframe = document.getElementById("myframe");
	iframe.style.height = (viewportheight-30)+'px';
}
var selectedTab = "tab1"
</script>
 </head>
 <body onload="init('tab1');">
  <h1><a id="hudson_link" href="/jenkins/job/ci_daily_check/">Back to ci_daily_check</a></h1>
  <h2><a id="zip_link" href="*zip*/_e680bb_e4bd93_e79c8b_e69dbf.zip">Zip</a></h2>
  <ul id="tabnav">
   <li id="tab1" class="selected" onclick="updateBody('tab1')" value="index.html">index</li>
   <script type="text/javascript">document.getElementById("hudson_link").innerHTML="Back to ci_daily_check";</script>
   <script type="text/javascript">document.getElementById("hudson_link").href="/jenkins/job/ci_daily_check/";</script>
   <script type="text/javascript">document.getElementById("zip_link").href="*zip*/_e680bb_e4bd93_e79c8b_e69dbf.zip";</script>
  </ul>
  <div><iframe id="myframe" height="100%" width="100%" frameborder="0" src="index.html" style="height: 1949px;"></iframe>
  </div>
 </body>
</html>"""

@Test
public class ParseParseInputTest {
    @TestCase
    func parseParseInput01(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr01, baseUrlStr01)
        @Assert(doc.outerHtml(), docStr01)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput02(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr01, baseUrlStr02)
        @Assert(doc.outerHtml(), docStr01)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput03(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr01, baseUrlStr03)
        @Assert(doc.outerHtml(), docStr01)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput04(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr01, baseUrlStr04)
        @Assert(doc.outerHtml(), docStr01)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput05(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr02, baseUrlStr01)
        @Assert(doc.outerHtml(), docStr02)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput06(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr02, baseUrlStr02)
        @Assert(doc.outerHtml(), docStr02)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput07(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr02, baseUrlStr03)
        @Assert(doc.outerHtml(), docStr02)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput08(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr02, baseUrlStr04)
        @Assert(doc.outerHtml(), docStr02)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput09(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr03, baseUrlStr01)
        @Assert(doc.outerHtml(), docStr03)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput10(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr03, baseUrlStr02)
        @Assert(doc.outerHtml(), docStr03)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput11(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr03, baseUrlStr03)
        @Assert(doc.outerHtml(), docStr03)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput12(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr03, baseUrlStr04)
        @Assert(doc.outerHtml(), docStr03)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput13(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr04, baseUrlStr01)
        @Assert(doc.outerHtml(), docStr04)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput14(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr04, baseUrlStr02)
        @Assert(doc.outerHtml(), docStr04)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput15(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr04, baseUrlStr03)
        @Assert(doc.outerHtml(), docStr04)
        @Assert(doc.nodeName(), "#document")
    }

    @TestCase
    func parseParseInput16(): Unit {
        var parser: Parser = Parser.htmlParser()
        var doc: Document = parser.parseInput(htmlStr04, baseUrlStr04)
        @Assert(doc.outerHtml(), docStr04)
        @Assert(doc.nodeName(), "#document")
    }
}
