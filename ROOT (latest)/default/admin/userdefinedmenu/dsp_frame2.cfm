<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css"/>

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_reply(this.recordset);</script>
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script language="JavaScript">
		
function getlevel3(code){
	//alert(code);
	parent.thirdframe.location.href="dsp_frame3.cfm?selectedcode=" + code + "&groupname=" + document.itemform.groupname.value;
}

function updaterights(groupid,pincode){
	var x = document.getElementById('cb_' + pincode);
	x.style.backgroundColor  = 'red';
	$.ajax({
		
			type:"POST",
			url:"databind/updaterights.cfm",
			data: {"groupid":groupid,"pincode":pincode},
			dataType:"html",
			cache:false,
			success: function(result){
				  $('#CustDiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			alert("Error update right!!");
			},
			complete: function(){
			alert('Update right successfully!!');
			}
  		});
	
 }
 
 function show_reply(rset){
 	rset.MoveFirst();
 	var codeid = 'cb_' + rset.fields("codeid").value;
 	var x = document.getElementById(codeid);
 	x.style.backgroundColor  = '';
 }
 
</script>
</head>
<body>

<cfparam name="selectedcode" default="9999">

<cfset tempcode = left(selectedcode,1)>	


<cfquery name="getuserpin2" datasource="#dts#">
	select * from userpin where code like '#tempcode#_000' and code not like '%0000'
</cfquery>
<form id="itemform" name="itemform">
	<cfoutput><input type="hidden" value="#groupname#" name="groupname"></cfoutput>
<table width="100%" height="100%" class="data">
	<tr><td height="10" colspan="5">&nbsp;</td></tr>
	<cfoutput>
	<cfloop query="getuserpin2">
		<cfset xcode = "H"&"#getuserpin2.code#">
		<cfquery name="getrights" datasource="#dts#">
			select #xcode# as xpin from userpin2 where level='#groupname#'
		</cfquery>
		<tr id="getuserpin2.code">
			<td>&nbsp;</td>
			<td>#getuserpin2.code#&nbsp;</td>
			<td onclick="getlevel3('#getuserpin2.code#');" style="cursor: hand;"><u>#getuserpin2.desp#</u></td>
			<td>&nbsp;</td>
			<td><input type="checkbox" id="cb_#xcode#" value="" onchange="updaterights('#groupname#','#xcode#');" <cfif getrights.xpin eq "T">checked</cfif>></td>
		</tr>
	</cfloop>
	</cfoutput>
</table>
</form>
</body>
</html>
