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
<cfset tempcode = left(selectedcode,2)>	

<cfquery name="getuserpin3" datasource="#dts#">
	select * from userpin where code not like '%000' and code not like '%0000' and code like '#tempcode#_00' and code not like 'C%'
</cfquery>
<form id="itemform" name="itemform">
<table width="100%" height="100%" class="data">
	<tr><td height="10"></td></tr>
    <cfset code1=''>
    <cfset code2=''>
	<cfloop query="getuserpin3">
		<cfset xcode = "H"&"#getuserpin3.code#">
		<cfquery name="getrights" datasource="#dts#">
			select #xcode# as xpin from userpin2 where level='#groupname#'
		</cfquery>
        <cfset code1=mid(getuserpin3.code,3,1)>
        <cfif code2 neq ''>
        <cfif code1 neq code2>
        <tr>
        <td colspan="100%"><hr></td>
        </tr>
        </cfif>
        </cfif>
		<tr>
			<td>&nbsp;</td>
			<cfoutput>
			<td>#getuserpin3.code#&nbsp;</td>
			<td>#getuserpin3.desp#</td>
			<td>&nbsp;</td>
			<td><input type="checkbox" id="cb_#xcode#" onChange="updaterights('#groupname#','#xcode#');" value="" <cfif getrights.xpin eq "T">checked</cfif>></td>
			</cfoutput>
		</tr>
        <cfset code2=mid(getuserpin3.code,3,1)>
	</cfloop>
</table>
</form>
</body>
</html>
