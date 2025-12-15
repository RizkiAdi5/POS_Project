<cfquery name="getgeneral" datasource="#dts#">
	select a.compro,date_format(a.lastaccyear,'%Y-%m-%d') as lastaccyear,concat(',.',repeat('_',b.decl_uprice))as decl_uprice
	from gsetup as a, gsetup2 as b;
</cfquery>

<cfset grandtotal = 0>
<cfset monthtotal = arraynew(1)>

<cfswitch expression="#form.period#">
	<cfcase value="1">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth31" method="getmonthagent" returnvariable="getagent">
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
		</cfinvoke>
	</cfcase>
	<cfcase value="2">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth32" method="getmonthagent" returnvariable="getagent">
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
		</cfinvoke>
	</cfcase>
	<cfcase value="3">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth33" method="getmonthagent" returnvariable="getagent">
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
		</cfinvoke>
	</cfcase>
	<cfcase value="4">
		<cfloop index="a" from="1" to="18">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth34" method="getmonthagent" returnvariable="getagent">
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
		</cfinvoke>
	</cfcase>
    <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth35" method="getmonthagent" returnvariable="getagent">
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
		</cfinvoke>
	</cfcase>
</cfswitch>

<html>
<head>
<title>Agent Sales By Month Report</title>
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
      	<td><font size="2" face="Times New Roman, Times, serif">AGENT.NO.</font></td>
	  	<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
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

	<cfloop query="getagent">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><font size="2" face="Times New Roman, Times, serif">#getagent.currentrow#.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getagent.agenno eq "",DE("No-Agent"),DE(getagent.agenno))#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getagent.desp eq "",DE("No-Agent"),DE(getagent.desp))#</font></td>
			<cfswitch expression="#form.period#">
				<cfcase value="1,2,3" delimiters=",">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getagent.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getagent.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getagent.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getagent.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getagent.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getagent.sump6>
					<cfset grandtotal = grandtotal + getagent.total>
				</cfcase>
                <cfcase value="6">
                <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump1,getgeneral.decl_uprice)#</font></div></td>
                </cfif>
                <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump2,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump3,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump4,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump5,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump6,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump7,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump8,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump9,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump10,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump11,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump12,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump13,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump14,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump15,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump16,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump17,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump18,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.total,getgeneral.decl_uprice)#</font></div></td>
                    <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
					<cfset monthtotal[1] = monthtotal[1] + getagent.sump1>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<cfset monthtotal[2] = monthtotal[2] + getagent.sump2>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<cfset monthtotal[3] = monthtotal[3] + getagent.sump3>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<cfset monthtotal[4] = monthtotal[4] + getagent.sump4>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<cfset monthtotal[5] = monthtotal[5] + getagent.sump5>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<cfset monthtotal[6] = monthtotal[6] + getagent.sump6>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<cfset monthtotal[7] = monthtotal[7] + getagent.sump7>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<cfset monthtotal[8] = monthtotal[8] + getagent.sump8>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<cfset monthtotal[9] = monthtotal[9] + getagent.sump9>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<cfset monthtotal[10] = monthtotal[10] + getagent.sump10>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<cfset monthtotal[11] = monthtotal[11] + getagent.sump11>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<cfset monthtotal[12] = monthtotal[12] + getagent.sump12>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<cfset monthtotal[13] = monthtotal[13] + getagent.sump13>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<cfset monthtotal[14] = monthtotal[14] + getagent.sump14>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<cfset monthtotal[15] = monthtotal[15] + getagent.sump15>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<cfset monthtotal[16] = monthtotal[16] + getagent.sump16>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<cfset monthtotal[17] = monthtotal[17] + getagent.sump17>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<cfset monthtotal[18] = monthtotal[18] + getagent.sump18>
                    </cfif>
					<cfset grandtotal = grandtotal + getagent.total>
                </cfcase>
				<cfdefaultcase>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump7,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump8,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump9,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump10,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump11,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump12,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump13,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump14,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump15,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump16,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump17,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.sump18,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getagent.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getagent.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getagent.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getagent.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getagent.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getagent.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getagent.sump6>
					<cfset monthtotal[7] = monthtotal[7] + getagent.sump7>
					<cfset monthtotal[8] = monthtotal[8] + getagent.sump8>
					<cfset monthtotal[9] = monthtotal[9] + getagent.sump9>
					<cfset monthtotal[10] = monthtotal[10] + getagent.sump10>
					<cfset monthtotal[11] = monthtotal[11] + getagent.sump11>
					<cfset monthtotal[12] = monthtotal[12] + getagent.sump12>
					<cfset monthtotal[13] = monthtotal[13] + getagent.sump13>
					<cfset monthtotal[14] = monthtotal[14] + getagent.sump14>
					<cfset monthtotal[15] = monthtotal[15] + getagent.sump15>
					<cfset monthtotal[16] = monthtotal[16] + getagent.sump16>
					<cfset monthtotal[17] = monthtotal[17] + getagent.sump17>
					<cfset monthtotal[18] = monthtotal[18] + getagent.sump18>
					<cfset grandtotal = grandtotal + getagent.total>
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
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
		<cfswitch expression="#form.period#">
			<cfcase value="1,2,3" delimiters=",">
				<cfloop index="a" from="1" to="6">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#<strong></strong></font></div></td>
				</cfloop>
			</cfcase>
        <cfcase value="6">
			<cfloop index="a" from="#periodfrom#" to="#periodto#">
        	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#<strong></strong></font></div></td>
       		</cfloop>
        </cfcase>

			<cfdefaultcase>
				<cfloop index="a" from="1" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],",.__")#<strong></strong></font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(grandtotal,",.__")#</strong></font></div></td>
	</tr>
</table>
</cfoutput>

<cfif getagent.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
	<cfabort>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>