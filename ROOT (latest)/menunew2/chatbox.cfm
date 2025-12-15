<!---
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<cfoutput>
<cfhttp url="https://www.google.com/talk/service/badge/Show?tk=z01q6amlquhmou3q64ahk07m5c4faijrgj4gcjpd7d82igiff0dfo2qu48sgvl92v99fhje8rvpcot2ff7jepmgp98l7klu8bgqbtfnf8rki2fv0j46jrnbm8mm5nnpntdc63t4ri5jdfrav6kqubhg7ne78sgbolvnd6knsdagp09pba2r0qc6i8hc510ocgic&amp;w=100&amp;h=60" resolveurl="yes" >
#cfhttp.FileContent#
<script type="text/javascript">
function getdata()
{
var i = 0;
var a = document.getElementsByTagName("a");
while (element = a[i++]) {
  if (element.className == "a") {
    a[i-1].onclick = function() {
	 _click('http://www.google.com/talk/service/badge/Start?tk\x3dz01q6amlquhmou3q64ahk07m5c4faijrgj4gcjpd7d82igiff0dfo2qu48sgvl92v99fhje8rvpcot2ff7jepmgp98l7klu8bgqbtfnf8rki2fv0j46jrnbm8mm5nnpntdc63t4ri5jdfrav6kqubhg7ne78sgbolvnd6knsdagp09pba2r0qc6i8hc510ocgic');
	  ajaxFunction(document.getElementById('getfield'),'/insertchatdata.cfm?type=IMS');	  
	  return false;
    }
  }
}
}
setTimeout('getdata();','1000');
 </script>
 <div id="getfield">
 </div>
</cfoutput>
<cfsetting showdebugoutput="no">
--->