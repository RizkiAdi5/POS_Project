<html>
<head>
<title>Agent Sales By Weekly Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",___.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<body>
<cfoutput>
<cfif isdefined("form.include") and form.include eq "yes">
	<h1 align="center">PRINT #url.trantype# SALES WEEKLY REPORT (Included DN/CN)</h1>
<cfelse>
	<h1 align="center">PRINT #url.trantype# SALES WEEKLY REPORT (Excluded DN/CN)</h1>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
    	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">MONTH: #form.monthfrom#</font></div></td>
    </tr>
    <cfif form.agentfrom neq "" and form.agentto neq "">
        <tr>
          	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
        </tr>
    </cfif>
    <cfif form.teamfrom neq "" and form.teamto neq "">
        <tr>
          	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
        </tr>
    </cfif>
    <cfif form.areafrom neq "" and form.areato neq "">
        <tr>
        	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
        </tr>
    </cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
        <tr>
        	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
        </tr>
    </cfif>
    <tr>
      	<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro neq "">#getgeneral.compro#</cfif></font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="10"><hr></td>
    </tr>

	<cfset lastyear = year(getgeneral.lastaccyear)>
	<cfset lastmonth = month(getgeneral.lastaccyear)>
	<cfset lastday = 1>
	<cfset selectedmonth = val(form.periodfrom)>
	<cfset count = 1>
	<cfset noweek = 1>
	<cfset weekday = arraynew(1)>
	<cfset weeks = arraynew(1)>
	<cfset lastmonth = lastmonth + selectedmonth>

	<cfif lastmonth gt 12>
		<cfset lastyear = lastyear + 1>
		<cfset lastmonth = lastmonth -12>
	</cfif>

	<cfset days = firstdayofmonth(createdate(lastyear,lastmonth,lastday))-2>

	<cfset totalday = daysinmonth(createdate(lastyear,lastmonth,1))>
	<cfset curweek = week(createdate(lastyear,lastmonth,1))>

	<cfloop index="a" from="1" to="#totalday#">
		<cfset curweek2 = week(createdate(lastyear,lastmonth,a))>
		<cfif curweek neq curweek2>
			<cfset noweek = noweek + 1>
			<cfset curweek = curweek2>
		</cfif>
	</cfloop>

	<cfloop index="a" from="1" to="#noweek#">
		<cfset weekday[a] = 0>
	</cfloop>

	<cfset curweek = week(createdate(lastyear,lastmonth,1))>
	<cfset noweek = 1>

	<cfloop index="a" from="1" to="#totalday#">
		<cfset curweek2 = week(createdate(lastyear,lastmonth,a))>
		<cfif a neq totalday>
			<cfset weeks[noweek] = curweek>
		<cfelse>
			<cfif week(createdate(lastyear,lastmonth,a-1)) eq week(createdate(lastyear,lastmonth,a))>
				<cfset weeks[noweek] = week(createdate(lastyear,lastmonth,a))>
			<cfelse>
				<cfset weeks[noweek + 1] = week(createdate(lastyear,lastmonth,a))>
			</cfif>
		</cfif>
		<cfif curweek eq curweek2>
			<cfset weekday[noweek] = weekday[noweek] + 1>
		<cfelse>
			<cfset noweek = noweek + 1>
			<cfset curweek = curweek2>
		</cfif>
	</cfloop>

	<cfset newtime = createdate(lastyear,1,1) + days>

	<tr>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
	<cfloop index="a" from="1" to="#noweek#">
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Week #a#</font></div></td>
	</cfloop>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
	</tr>
	<tr>
		<td></td>
		<td></td>
	<cfloop index="a" from="#count#" to="#noweek#">
		<cfset weekday[a] = weekday[a] + 1>

		<cfif count eq 1>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(newtime + 1,"ddd dd")# - #dateformat(newtime + weekday[a] - 1,"ddd dd")#</font></div></td>
		<cfelse>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(newtime,"ddd dd")# - #dateformat(newtime + weekday[a] - 1,"ddd dd")#</font></div></td>
		</cfif>

		<cfset newtime = newtime + weekday[a] >
		<cfset count = count + 1>
	</cfloop>
	</tr>
	<tr>
      	<td colspan="10"><hr></td>
    </tr>

<cfquery name="getagent" datasource="#dts#">
	select agenno from artran
	where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and (void = '' or void is null)
    <cfif isdefined("form.include") and form.include eq "yes">
	and (type = 'INV' or type = 'CS' or type = 'DN' or type = 'CN')
	<cfelse>
	and (type = 'INV' or type = 'CS')
	</cfif>
    <cfif form.agentfrom neq "" and form.agentto neq "">
    and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
    </cfif>
    <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
    <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
		<cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
		</cfif>
	<cfif form.areafrom neq "" and form.areato neq "">
	and area >='#form.areafrom#' and area <='#form.areato#'
	</cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
		and van >='#form.userfrom#' and van <='#form.userto#'
		</cfif>
    group by agenno order by agenno
</cfquery>

<cfset total = arraynew(1)>
<cfset subtotal = arraynew(1)>

<cfloop index="a" from="1" to="#noweek#">
	<cfset total[a] = 0>
</cfloop>

<cfloop query="getagent">
	<cfset agenno = getagent.agenno>

	<cfloop index="a" from="1" to="#noweek#">
		<cfset subtotal[a] = 0>
	</cfloop>

	<cfquery name="getintran" datasource="#dts#">
		select wos_date,qty,amt from ictran
		where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and agenno = '#agenno#' and (void = '' or void is null)
		<cfif isdefined("form.include") and form.include eq "yes">
		and (type = 'INV' or type = 'CS' or type = 'DN')
		<cfelse>
		and (type = 'INV' or type = 'CS')
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and area >='#form.areafrom#' and area <='#form.areato#'
		</cfif>
        <cfif form.userfrom neq "" and form.userto neq "">
		and van >='#form.userfrom#' and van <='#form.userto#'
		</cfif>
		order by fperiod
	</cfquery>

	<cfif isdefined("form.include") and form.include eq "yes">
		<cfquery name="getouttran" datasource="#dts#">
			select wos_date,qty,amt from ictran
			where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and agenno = '#agenno#' and (void = '' or void is null)
			and type = 'cn'
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and van >='#form.userfrom#' and van <='#form.userto#'
			</cfif>
			order by fperiod
		</cfquery>
	</cfif>

	<cfloop query="getintran">
		<cfset checkweek = week(getintran.wos_date)>
		<cfloop index="a" from="1" to="#noweek#">
			<cfif weeks[a] eq checkweek>
				<cfif form.label eq "salesqty">
					<cfset subtotal[a] = subtotal[a] + val(getintran.qty)>
					<cfset total[a] = total[a] + val(getintran.qty)>
				<cfelse>
					<cfset subtotal[a] = subtotal[a] + val(getintran.amt)>
					<cfset total[a] = total[a] + val(getintran.amt)>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>

	<!---<cfif isdefined("form.include") and form.include eq "yes">
		<cfloop query="getouttran">
			<cfset checkweek = week(getouttran.wos_date)>
			<cfloop index="a" from="1" to="#noweek#">
				<cfif weeks[a] eq checkweek>
					<cfif isdefined("form.label") and form.label neq "salesqty">
						<cfset subtotal[a] = subtotal[a] - val(getouttran.qty)>
						<cfset total[a] = total[a] - val(getouttran.qty)>
					<cfelse>
						<cfset subtotal[a] = subtotal[a] - val(getouttran.amt)>
						<cfset total[a] = total[a] - val(getouttran.amt)>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>--->

	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<cfif getagent.agenno eq "">
			<td><font size="2" face="Times New Roman, Times, serif">No - Agent</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">No - Agent</font></td>
		<cfelse>
			<cfquery name="getagentname" datasource="#dts#">
				select desp from icagent where agent = '#getagent.agenno#'
			</cfquery>
			<td><font size="2" face="Times New Roman, Times, serif">#getagent.agenno#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getagentname.desp#</font></td>
		</cfif>
		<cfloop index="a" from="1" to="#noweek#">
			<cfif form.label eq "salesqty">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal[a],"0")#</font></div></td>
			<cfelse>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal[a],stDecl_UPrice)#</font></div></td>
			</cfif>
		</cfloop>
		<cfif form.label eq "salesqty">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(arraysum(subtotal),"0")#</font></div></td>
		<cfelse>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(arraysum(subtotal),stDecl_UPrice)#</font></div></td>
		</cfif>
	</tr>
	<cfflush>
</cfloop>
	<tr>
      	<td colspan="10"><hr></td>
    </tr>
	<tr>
		<td></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
		<cfloop index="a" from="1" to="#noweek#">
			<cfif form.label eq "salesqty">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(total[a],"0")#</strong></font></div></td>
			<cfelse>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(total[a],",.__")#</strong></font></div></td>
			</cfif>
		</cfloop>
		<cfif form.label eq "salesqty">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(arraysum(total),"0")#</strong></font></div></td>
		<cfelse>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(arraysum(total),",.__")#</strong></font></div></td>
		</cfif>
	</tr>
</table>

<cfif getagent.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
</cfif>
</cfoutput>
<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>