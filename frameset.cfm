<html>
<script language="JavaScript" type="text/javascript">

var firstpos=top.location.href.lastIndexOf('/')+1;
var lastpos=top.location.href.length;
var file=top.location.href.substring(firstpos,lastpos);
if (file=='index.html'){file='../newBody.cfm'};
if (file=='top.html'){file='../newBody.cfm'};
if (file=='left.html'){file='../newBody.cfm'};
if (file==''){file='../newBody.cfm'};

var ls = location.search.substr(1);
var currentpage = (ls && (ls.substr(0,4) == "url=")) ? unescape(ls.substr(4)) : file;
var MyFrameSet = '<frameset rows="71,*" cols="*" frameborder="yes" border="0" framespacing="0">\n';
MyFrameSet += '<frame src="../header.cfm" name="topFrame" scrolling="NO" noresize >\n';
//MyFrameSet += '<frameset cols="150,*" frameborder="yes" border="0" framespacing="0">\n';

//MyFrameSet += ' <frame src="../menu/left2.cfm" name="leftFrame" scrolling="no"  noresize>\n';


MyFrameSet += ' <frame src="../newBody.cfm" name="mainFrame">\n';

MyFrameSet += ' <noframes><body>\n';
MyFrameSet += ' [text for search engins here]\n';
MyFrameSet += ' <\/body><\/noframes>\n';
//MyFrameSet += '<\/frameset>\n';
MyFrameSet += '<\/frameset>\n';
document.write(MyFrameSet)

</script>
<noscript>
[you could put the frameset in normal html here for browsers that don't support javascript]
</noscript>



</html>