<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "11, 95, 2122, 2123, 2124, 2125, 23, 440, 6, 2126, 563, 1303, 2127">
<cfinclude template="/latest/words.cfm">


<cfoutput>
<h1>#words[2122]#</h1>
<table width="600px" height="500px">
<cfform name="deliverydetail" method="post" id="deliverydetail" action="delprocess.cfm">

<tr>
<th width="150px">
#words[2123]#
</th>
<td>:</td>
<td>
<input type="text" name="deliverydate" id="deliverydate" value="" /><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('deliverydate'));">&nbsp;(DD/MM/YYYY)
</td>
</tr>
<tr>
<th width="150px">
#words[2124]#
</th>
<td>:</td>
<td>
<input type="text" name="deliverytime" id="deliverytime" value="" />
</td>
</tr>
<tr>
<th colspan="3">#words[1303]#</th>
</tr>
<tr>
<th>#words[2125]#</th>
<td>:</td>
<td>
<cfinput type="text" name="memberidsearch" id="memberidsearch" size="35" readonly="yes">&nbsp;&nbsp;<input type="button" name="searchmembet_btn" id="searchmember_btn" onclick="document.getElementById('main').value='in';ColdFusion.Window.show('searchmember');" value="#words[11]#" />
</td>
</tr>
<tr>
<th>#words[23]#</th>
<td>:</td>
<td>
<cfinput type="text" name="membernamesearch" id="membernamesearch" size="35">
</td>
</tr>
<tr>
<th>#words[440]#:</th>
<td>:</td>
<td>
<cfinput type="text" name="membertelsearch" id="membertelsearch" size="35">
</td>
</tr>
<tr>
<th>#words[6]#</th>
<td>:</td>
<td>
<cfinput type="text" name="memberadd1search" id="memberadd1search" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd2search" id="memberadd2search" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd3search" id="memberadd3search" size="45">
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="del_btn" id="del_btn" value="#words[2127]#" onclick="updatemember(
escape(encodeURI(document.getElementById('membernamesearch').value))
,escape(encodeURI(document.getElementById('membertelsearch').value))
,escape(encodeURI(document.getElementById('memberadd1search').value))
,escape(encodeURI(document.getElementById('memberadd2search').value))
,escape(encodeURI(document.getElementById('memberadd3search').value))
,escape(encodeURI(document.getElementById('memberidsearch').value))
,escape(encodeURI(document.getElementById('deliverydate').value))
,escape(encodeURI(document.getElementById('deliverytime').value)));" />
</td>
</tr>

</cfform>
<tr><td colspan="100%">
<h1>#words[2126]#</h1></td></tr>
<cfform action="neweuprocess.cfm" method="post" id="euform" name="euform">

<tr>
<th>#words[2125]#</th>
<td>:</td>
<td>
<cfinput type="text" name="memberid" id="memberid" required="yes" message="Member Id is Required" maxlength="10" size="35">
</td>
</tr>
<tr>
<th>#words[23]#</th>
<td>:</td>
<td>
<cfinput type="text" name="membername" id="membername" required="yes" message="Name is Required" size="35">
</td>
</tr>
<tr>
<th>#words[440]#:</th>
<td>:</td>
<td>
<cfinput type="text" name="membertel" id="membertel" required="yes" message="Telephone is Required" size="35">
</td>
</tr>

<tr>
<th>#words[563]#:</th>
<td>:</td>
<td>
<cfinput type="text" name="dob" id="dob"  size="10" maxlength="10" validate="eurodate" message="Kindly Check Date Format"> <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(dob);">DD/MM/YYYY
</td>
</tr>

<tr>
<th>#words[6]#</th>
<td>:</td>
<td>
<cfinput type="text" name="memberadd1" id="memberadd1" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd2" id="memberadd2" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd3" id="memberadd3" size="45">
</td>
</tr>
<tr>
<td colspan="3" align="center"><input type="button" name="sub_btn" id="sub_btn" value="#words[95]#" onclick="createmember(
escape(encodeURI(document.getElementById('membername').value))
,escape(encodeURI(document.getElementById('membertel').value))
,escape(encodeURI(document.getElementById('memberadd1').value))
,escape(encodeURI(document.getElementById('memberadd2').value))
,escape(encodeURI(document.getElementById('memberadd3').value))
,escape(encodeURI(document.getElementById('memberid').value))
,escape(encodeURI(document.getElementById('dob').value))
);"></td>
</tr>

</cfform>
</table>
</cfoutput>