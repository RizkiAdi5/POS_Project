<cfquery name="getgeneral" datasource="#dts#">
	select a.compro,date_format(a.lastaccyear,'%Y-%m-%d') as lastaccyear,concat(',.',repeat('_',b.decl_uprice))as decl_uprice,agentlistuserid
	from gsetup as a, gsetup2 as b;
</cfquery>

<cfset grandtotal = 0>
<cfset monthtotal = arraynew(1)>

<cfswitch expression="#form.period#">
	<cfcase value="1">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth21" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
		</cfinvoke>
	</cfcase>
	<cfcase value="2">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth22" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
		</cfinvoke>
	</cfcase>
	<cfcase value="3">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth23" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
		</cfinvoke>
	</cfcase>
	<cfcase value="4">
		<cfloop index="a" from="1" to="18">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth24" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
		</cfinvoke>
	</cfcase>
     <cfcase value="5">
		<cfloop index="a" from="1" to="1">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonthbymonth" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
            <cfinvokeargument name="period" value="#form.poption#">
		</cfinvoke>
	</cfcase>
    <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth25" method="getmonthcust" returnvariable="getcust">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
            <cfinvokeargument name="periodfrom" value="#trim(form.periodfrom)#">
			<cfinvokeargument name="periodto" value="#trim(form.periodto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
			<cfinvokeargument name="target_arcust" value="#target_arcust#">
		</cfinvoke>
	</cfcase>
</cfswitch>

<html>
<head>
<title>Customer Sales By Month Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<body>
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
	<cfif isdefined("form.include")>
		<td colspan="25"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY MONTH REPORT (Included DN/CN)</strong></font></div></td>
    <cfelse>
		<td colspan="25"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY MONTH REPORT (Excluded DN/CN)</strong></font></div></td>
	</cfif>
	</tr>
    <tr>
      	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">
	  		<cfswitch expression="#form.period#">
				<cfcase value="1">PERIOD 1 - 6</cfcase>
				<cfcase value="2">PERIOD 7 - 12</cfcase>
				<cfcase value="3">PERIOD 13 - 18</cfcase>
                <cfcase value="5">Period #form.poption#</cfcase>
                <cfcase value="6">PERIOD #form.periodfrom# - #form.periodto#</cfcase>
				<cfdefaultcase>ONE YEAR</cfdefaultcase>
			</cfswitch>
	  	</font></div>
	  	</td>
    </tr>
    <cfif form.agentfrom neq "" and form.agentto neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
        </tr>
    </cfif>
    <cfif form.teamfrom neq "" and form.teamto neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
        </tr>
    </cfif>
    <cfif form.areafrom neq "" and form.areato neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
        </tr>
    </cfif>
    <tr>
      	<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="19"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="25"><hr></td>
    </tr>
    <tr>
		<td><font size="2" face="Times New Roman, Times, serif">NO</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">CUST.NO.</font></td>
	  	<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
		<td><font size="2" face="Times New Roman, Times, serif">AGENT</font></td>
		<cfswitch expression="#form.period#">
			<cfcase value="1">
				<cfloop index="l" from="1" to="6">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfcase>
			<cfcase value="2">
				<cfloop index="l" from="7" to="12">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfcase>
			<cfcase value="3">
				<cfloop index="l" from="13" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfcase>
            <cfcase value="5">
				<cfloop index="l" from="#form.poption#" to="#form.poption#">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfcase>
            <cfcase value="6">
				<cfloop index="l" from="#form.periodfrom#" to="#form.periodto#">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfcase>
			<cfdefaultcase>
				<cfloop index="l" from="1" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
	  	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
    </tr>
    <tr>
      	<td colspan="25"><hr></td>
    </tr>

	<cfloop query="getcust">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><font size="2" face="Times New Roman, Times, serif">#getcust.currentrow#.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getcust.custno#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getcust.name#</font></td>
            <cfquery name="getagenno" datasource="#dts#">
            select agenno from ictran where custno='#getcust.custno#'
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
</cfquery>
			<td><font size="2" face="Times New Roman, Times, serif">#getagenno.agenno#</font></td>
			<cfswitch expression="#form.period#">
				<cfcase value="1,2,3" delimiters=",">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getcust.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getcust.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getcust.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getcust.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getcust.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getcust.sump6>
					<cfset grandtotal = grandtotal + getcust.total>
				</cfcase>
                <cfcase value="5">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump1,getgeneral.decl_uprice)#</font></div></td>
                <cfset monthtotal[1] = monthtotal[1] + getcust.sump1>
				<cfset grandtotal = grandtotal + getcust.total>
                </cfcase>
                <cfcase value="6">
                <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
                	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump1,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump2,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump3,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump4,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump5,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump6,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump7,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump8,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump9,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump10,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump11,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump12,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump13,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump14,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump15,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump16,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump17,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump18,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.total,getgeneral.decl_uprice)#</font></div></td>
                    <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
					<cfset monthtotal[1] = monthtotal[1] + getcust.sump1>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<cfset monthtotal[2] = monthtotal[2] + getcust.sump2>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<cfset monthtotal[3] = monthtotal[3] + getcust.sump3>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<cfset monthtotal[4] = monthtotal[4] + getcust.sump4>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<cfset monthtotal[5] = monthtotal[5] + getcust.sump5>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<cfset monthtotal[6] = monthtotal[6] + getcust.sump6>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<cfset monthtotal[7] = monthtotal[7] + getcust.sump7>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<cfset monthtotal[8] = monthtotal[8] + getcust.sump8>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<cfset monthtotal[9] = monthtotal[9] + getcust.sump9>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<cfset monthtotal[10] = monthtotal[10] + getcust.sump10>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<cfset monthtotal[11] = monthtotal[11] + getcust.sump11>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<cfset monthtotal[12] = monthtotal[12] + getcust.sump12>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<cfset monthtotal[13] = monthtotal[13] + getcust.sump13>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<cfset monthtotal[14] = monthtotal[14] + getcust.sump14>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<cfset monthtotal[15] = monthtotal[15] + getcust.sump15>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<cfset monthtotal[16] = monthtotal[16] + getcust.sump16>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<cfset monthtotal[17] = monthtotal[17] + getcust.sump17>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<cfset monthtotal[18] = monthtotal[18] + getcust.sump18>
                    </cfif>
					<cfset grandtotal = grandtotal + getcust.total>
                </cfcase>
				<cfdefaultcase>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump7,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump8,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump9,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump10,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump11,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump12,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump13,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump14,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump15,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump16,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump17,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.sump18,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getcust.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getcust.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getcust.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getcust.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getcust.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getcust.sump6>
					<cfset monthtotal[7] = monthtotal[7] + getcust.sump7>
					<cfset monthtotal[8] = monthtotal[8] + getcust.sump8>
					<cfset monthtotal[9] = monthtotal[9] + getcust.sump9>
					<cfset monthtotal[10] = monthtotal[10] + getcust.sump10>
					<cfset monthtotal[11] = monthtotal[11] + getcust.sump11>
					<cfset monthtotal[12] = monthtotal[12] + getcust.sump12>
					<cfset monthtotal[13] = monthtotal[13] + getcust.sump13>
					<cfset monthtotal[14] = monthtotal[14] + getcust.sump14>
					<cfset monthtotal[15] = monthtotal[15] + getcust.sump15>
					<cfset monthtotal[16] = monthtotal[16] + getcust.sump16>
					<cfset monthtotal[17] = monthtotal[17] + getcust.sump17>
					<cfset monthtotal[18] = monthtotal[18] + getcust.sump18>
					<cfset grandtotal = grandtotal + getcust.total>
				</cfdefaultcase>
			</cfswitch>
		</tr>
	</cfloop>
	<tr>
    	<td colspan="25"><hr></td>
    </tr>
    <tr>
		<td></td>
		<td></td>
		<td></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
		<cfswitch expression="#form.period#">
			<cfcase value="1,2,3" delimiters=",">
				<cfloop index="a" from="1" to="6">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#</font></div></td>
				</cfloop>
			</cfcase>
		<cfcase value="5">

					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[1],",.__")#</font></div></td>
			</cfcase>
            <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#<strong></strong></font></div></td>
        </cfloop>
        </cfcase>
			<cfdefaultcase>
				<cfloop index="a" from="1" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#</font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(grandtotal,",.__")#</strong></font></div></td>
	</tr>
</table>
</cfoutput>

<cfif getcust.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
	<cfabort>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>