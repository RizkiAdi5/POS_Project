<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
<cfif form.datefrom neq '' and form.dateto neq ''>
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	<cfif dd greater than '12'>
        <cfset ndateto=dateformat(dateadd('d',1,form.dateto),"YYYYMMDD")>
	<cfelse>
    	<cfset ndateto=dateformat(dateadd('m',1,form.dateto),"YYYYDDMM")>
	</cfif>
</cfif>
</cfif>
		
		<html>
		<head>
		<title>LOGIN AND LOGOUT REPORT</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>
		<body>

		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		  	<cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="8"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Login and Logout Report</strong></font></div></td>
			</tr>
			<cfif trim(form.userfrom) neq "" and trim(form.userto) neq "">
				<tr>
					<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">USER_NO: #form.userfrom# - #form.userto#</font></div></td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="6"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="9"><hr></td>
			</tr>
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">UserLogID</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">UserLogName</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">UserLogTime</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">IP Address</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">Status</font></td>				
			</tr>
			<tr>
				<td colspan="9"><hr></td>
			</tr>

				<cfquery name="users" datasource="main">
					select *,(select username from users where userid=a.userlogid) as username from userlog as a where udatabase='#dts#' and status in ('Success','Logout')
					
                    <cfif form.UserFrom neq "" and form.userto neq "">
                    and userlogid between '#form.UserFrom#' and '#form.userto#'
                    </cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and userlogtime >= '#ndatefrom#' and userlogtime <= '#ndateto#'
					<cfelse>
					and userlogtime> #getgeneral.lastaccyear#
					</cfif>
					order by userlogtime desc
				</cfquery>

				<cfloop query="users">
					
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#lcase(userlogid)#</font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#lcase(username)#</font></div></td>
					  <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#DATEFORMAT(users.userLogTime, "DD/MM/YYYY")# #TIMEFORMAT(users.userLogTime, "HH:MM:SS")#</font></div></td>
                      <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#users.uipaddress#</font></div></td>
                      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><cfif status eq 'Success'>Login<cfelseif status eq 'Logout'>Logout</cfif></font></div></td>
</tr>
				</cfloop>

		  </table>
		</cfoutput>

		<cfif users.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
