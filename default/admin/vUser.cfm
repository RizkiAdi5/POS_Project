<html>
<head>
<title>View IMS Database</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfif husergrpid eq "super">
<script language="javascript" type="text/javascript" src="/scripts/collapse_expand_single_item.js"></script>
<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<script type="text/javascript">
function active(sta,custno)
{
var checkfield = "active"+custno;
if(document.getElementById(checkfield).checked == true && sta == "Y")
{
sta = "Y";
}
else if (document.getElementById(checkfield).checked == false && sta == "Y")
{
sta = "N";
}
else if (document.getElementById(checkfield).checked == true && sta == "N")
{
sta = "N";
}
else
{
sta = "Y";
}
  var urlload = '/default/admin/updateactive.cfm?sta='+sta+'&custno='+escape(custno);
	
    new Ajax.Request(urlload,
      {
        method:'get',
        onSuccess: function(flyback){
        },
        onFailure: function(){ 
		alert('Update Failed'); }
      });

}
</script>
</cfif>
</head>

<body>

<h4>
	<cfif husergrpid eq "Muser">
		<a href="/home2.cfm"><u>Home</u></a>
	</cfif>
</h4>

<h1>User Maintenance</h1>

<hr>
	<cfparam name="start" default="1">
	<cfparam name="no" default="1">
	
	<cfif husergrpid eq "super">
		<cfquery datasource='main' name="getUsers">
			select userbranch 
			from users 
			where userDept not in ('cyt_i','hom_i','mj_i','oilestates_a','pwd_i','steel05_i','steel_i','marujyu_i')
			and userDept not like '%_a'
            and comsta = "Y"
			group by userbranch order by userbranch;
		</cfquery>
	<cfelseif husergrpid eq "admin">
		<cfquery datasource='main' name="getUsers">
			select userbranch 
			from users 
			where userbranch='#hcomid#'
			group by userbranch order by userbranch;
		</cfquery>
	<cfelse>
		<cfquery datasource='main' name="getUsers">
			select userbranch 
			from users 
			where userid='#huserid#' 
			and userbranch='#hcomid#';
		</cfquery>
	</cfif>
	
	<cfif isdefined("url.start")>
		<cfset start = url.start>
	</cfif>
    <cfif husergrpid eq "super">
	<table align="center" class="data" width="80%">
		<tr>
			<th onClick="javascript:shoh('transaction_menu_page1');shoh('transaction_menu_page2');">Page 1<img src="/images/d.gif" name="imgtransaction_menu_page1" align="center"></th>
			<th onClick="javascript:shoh('transaction_menu_page2');shoh('transaction_menu_page1');">Page 2<img src="/images/u.gif" name="imgtransaction_menu_page2" align="center"></th>
		</tr>
	</table>
    </cfif>
	<table id="transaction_menu_page1" align="center" class="data" width="80%">
		<tr>
			<th width="10%">No.</th>
            <cfif HUserGrpID eq "SUPER" and left(huserid,5) eq "ultra">
            <th>GO</th>				
            </cfif>
    		<th width="20%">Company ID</th>
			<th width="40%">Company Name</th>
			<th width="10%">Last A/C Year Closing Date</th>
			<th width="10%">Future A/C Year Closing Date</th>
			<th width="10%">Current Period</th>
            <cfif husergrpid eq "super">
            <th width="10%">Active</th>	
            </cfif>				
		</tr>
		<cfoutput query="getUsers" startrow="#start#">
			<cfset dts = getUsers.userbranch>
			<cfquery name="getcominfo" datasource="main">
				select * from #dts#.gsetup
			</cfquery>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="center">#no#.</div></td>	
                <cfif HUserGrpID eq "SUPER" and left(huserid,5) eq "ultra">
                <td><input type="button" name="go_btn" id="go_btn" value="GOTO" onClick="if(confirm('Are You Sure You Want To Go To #getusers.userbranch#')){window.location.href='goto.cfm?comid=#getusers.userbranch#'}" /></td>
				</cfif>															
				<td>
					<a href="vuser1.cfm?comid=#getUsers.userbranch#">#ucase(getUsers.userbranch)#</a>
				</td>
				<td>#getcominfo.compro#</td>
				<td align="center"><cfif getcominfo.LastAccYear neq "">#dateformat(getcominfo.LastAccYear,"dd-mm-yyyy")#</cfif></td>
				<td align="center">
					<cfif getcominfo.LastAccYear neq "">
						<cfset futuredate = dateAdd("m",val(getcominfo.Period),getcominfo.LastAccYear)>
						#dateformat(futuredate,"dd-mm-yyyy")#
					</cfif>
				</td>
				<td align="center">
					<cfset lastaccyear = lsdateformat(getcominfo.LastAccYear, 'mm/dd/yyyy')>
					<cfset period = getcominfo.period>
					<cfset currentdate = lsdateformat(now(),'mm/dd/yyyy')>
		
					<cfset tmpYear = year(currentdate)>
					<cfset clsyear = year(lastaccyear)>

					<cfset tmpmonth = month(currentdate)>
					<cfset clsmonth = month(lastaccyear)>

					<cfset intperiod = (tmpyear-clsyear)*12+tmpmonth-clsmonth>

					<cfif intperiod gt 18 or intperiod lte 0>
						<cfset readperiod=99>
					<cfelse>
						<cfset readperiod = numberformat(intperiod,"00")>
					</cfif>
					#readperiod#
				</td><cfif husergrpid eq "super">
                <td>
                <input type="checkbox" name="active#ucase(getUsers.userbranch)#" id="active#ucase(getUsers.userbranch)#" checked onClick="active('Y','#ucase(getUsers.userbranch)#')" />
                </td>			
                </cfif>						
			</tr>
			<cfset no = no + 1>
		</cfoutput>
	</table>
    <cfif husergrpid eq "super">
    <cfquery datasource='main' name="getUsersNo">
			select userbranch 
			from users 
			where userDept not in ('cyt_i','hom_i','mj_i','oilestates_a','pwd_i','steel05_i','steel_i','marujyu_i')
			and userDept not like '%_a'
            and comsta = "N"
			group by userbranch order by userbranch;
		</cfquery>
        <cfset no = 1>
    	<table id="transaction_menu_page2" style="display:none" align="center" class="data" width="80%">
		<tr>
			<th width="10%">No.</th>				
    		<th width="20%">Company ID</th>
			<th width="40%">Company Name</th>
			<th width="10%">Last A/C Year Closing Date</th>
			<th width="10%">Future A/C Year Closing Date</th>
			<th width="10%">Current Period</th>
            <th width="10%">No Active</th>					
		</tr>
		<cfoutput query="getusersno">
			<cfset dts = getusersno.userbranch>
			<cfquery name="getcominfo" datasource="main">
				select * from #dts#.gsetup
			</cfquery>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="center">#no#.</div></td>																
				<td>
					<a href="vuser1.cfm?comid=#getusersno.userbranch#">#ucase(getusersno.userbranch)#</a>
				</td>
				<td>#getcominfo.compro#</td>
				<td align="center"><cfif getcominfo.LastAccYear neq "">#dateformat(getcominfo.LastAccYear,"dd-mm-yyyy")#</cfif></td>
				<td align="center">
					<cfif getcominfo.LastAccYear neq "">
						<cfset futuredate = dateAdd("m",val(getcominfo.Period),getcominfo.LastAccYear)>
						#dateformat(futuredate,"dd-mm-yyyy")#
					</cfif>
				</td>
				<td align="center">
					<cfset lastaccyear = lsdateformat(getcominfo.LastAccYear, 'mm/dd/yyyy')>
					<cfset period = getcominfo.period>
					<cfset currentdate = lsdateformat(now(),'mm/dd/yyyy')>
		
					<cfset tmpYear = year(currentdate)>
					<cfset clsyear = year(lastaccyear)>

					<cfset tmpmonth = month(currentdate)>
					<cfset clsmonth = month(lastaccyear)>

					<cfset intperiod = (tmpyear-clsyear)*12+tmpmonth-clsmonth>

					<cfif intperiod gt 18 or intperiod lte 0>
						<cfset readperiod=99>
					<cfelse>
						<cfset readperiod = numberformat(intperiod,"00")>
					</cfif>
					#readperiod#
				</td>
                <td>
                <input type="checkbox" name="active#ucase(getusersno.userbranch)#" id="active#ucase(getusersno.userbranch)#" checked onClick="active('N','#ucase(getusersno.userbranch)#')" />
                </td>									
			</tr>
			<cfset no = no + 1>
		</cfoutput>
	</table>
	</cfif>
<br>

</body>
</html>