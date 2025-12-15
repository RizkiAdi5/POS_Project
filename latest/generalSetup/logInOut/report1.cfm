<html>
<head>
	<title>View User Login History</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	<style type="text/css" media="print">
		.noprint { display: none; }
	</style>
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>
<cfif form.datefrom neq "" and form.dateto neq "">
	<cfset date1 = createDate(ListGetAt(form.datefrom,3,"/"),ListGetAt(form.datefrom,2,"/"),ListGetAt(form.datefrom,1,"/"))>
	<cfset date2 = createDate(ListGetAt(form.dateto,3,"/"),ListGetAt(form.dateto,2,"/"),ListGetAt(form.dateto,1,"/"))>
<cfset date2=dateadd('d',1,date2)>
</cfif>


<cfquery name="getinfo" datasource="main">
        Select a.userlogid,a.userlogtime,a.uipaddress,a.status,b.username from userlog a
        left join users as b on a.userLogID=b.userID 
        where a.udatabase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#"> 
        and b.userGrpID <> 'super'
        <cfif form.datefrom neq "" and form.dateto neq "">
				and a.userlogtime >= #date1# and a.userlogtime <= #date2#
		</cfif>
        order by a.userlogtime desc 
</cfquery>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<cfoutput>
		<tr>
			<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>View User Login History</strong></font></div></td>
		</tr>
		<tr>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<td colspan="3"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="10"><hr></td>
		</tr>
		<tr>
			<td><div align="center"><font size="2" face="Times New Roman, Times, serif">NO.</font></div></td>
			<td><div align="center"><font size="2" face="Times New Roman, Times, serif">USERID</font></div></td>
            <td><div align="center"><font size="2" face="Times New Roman, Times, serif">USER NAME</font></div></td>
			<td><div align="center"><font size="2" face="Times New Roman, Times, serif">Log In Time</font></div></td>
			<td><div align="center"><font size="2" face="Times New Roman, Times, serif">IP Address</font></div></td>
            <td><div align="center"><font size="2" face="Times New Roman, Times, serif">Status</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<cfloop query="getinfo">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.currentrow#.</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.userlogid#</font></div></td>
                <td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.username#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.userlogtime#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.uipaddress#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getinfo.status#</font></div></td>
			</tr>
		</cfloop>
	</cfoutput>
	</table>
</body>
</html>