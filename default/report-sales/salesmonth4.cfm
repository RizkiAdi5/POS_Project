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
		<cfinvoke component="salesmonth41" method="getmonthgroup" returnvariable="getgroup">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="label" value="#form.label#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="2">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth42" method="getmonthgroup" returnvariable="getgroup">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="label" value="#form.label#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="3">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth43" method="getmonthgroup" returnvariable="getgroup">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="label" value="#form.label#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="4">
		<cfloop index="a" from="1" to="12">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth44" method="getmonthgroup" returnvariable="getgroup">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="label" value="#form.label#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
		</cfinvoke>
	</cfcase>
    <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth45" method="getmonthgroup" returnvariable="getgroup">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
            <cfinvokeargument name="periodfrom" value="#trim(form.periodfrom)#">
			<cfinvokeargument name="periodto" value="#trim(form.periodto)#">
			<cfinvokeargument name="label" value="#form.label#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
		</cfinvoke>
	</cfcase>
</cfswitch>

<html>
<head>
<title>Group Sales By Month Report</title>
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
    <cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
        </tr>
    </cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
        </tr>
    </cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM: #form.itemfrom# - #form.itemto#</font></div></td>
        </tr>
    </cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
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
      	<td colspan="19"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd-mm-yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="25"><hr></td>
    </tr>
    <tr>
		<td><font size="2" face="Times New Roman, Times, serif">NO</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">GROUP.NO.</font></td>
	  	<td><font size="2" face="Times New Roman, Times, serif">DESP</font></td>
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
				<cfloop index="l" from="1" to="12">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(dateadd('m',l,getgeneral.lastaccyear),"mmm yy")#</font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
	  	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
    </tr>
    <tr>
      	<td colspan="25"><hr></td>
    </tr>

	<cfloop query="getgroup">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><font size="2" face="Times New Roman, Times, serif">#getgroup.currentrow#.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getgroup.wos_group eq "",DE("No-Grouped"),DE(getgroup.wos_group))#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getgroup.desp eq "",DE(""),DE(getgroup.desp))#</font></td>
			<cfswitch expression="#form.period#">
				<cfcase value="1,2,3" delimiters=",">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump1,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump2,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump3,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump4,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump5,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump6,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.total,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getgroup.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getgroup.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getgroup.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getgroup.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getgroup.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getgroup.sump6>
					<cfset grandtotal = grandtotal + getgroup.total>
				</cfcase>
                <cfcase value="6">
                <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump1,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                </cfif>
                <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump2,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump3,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump4,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump5,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump6,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump7,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump8,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump9,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump10,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump11,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump12,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump13,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump14,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump15,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump16,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump17,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump18,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                    </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.total,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
                	<cfif form.periodfrom  lte 1 and form.periodto gte 1 >
					<cfset monthtotal[1] = monthtotal[1] + getgroup.sump1>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<cfset monthtotal[2] = monthtotal[2] + getgroup.sump2>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<cfset monthtotal[3] = monthtotal[3] + getgroup.sump3>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<cfset monthtotal[4] = monthtotal[4] + getgroup.sump4>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<cfset monthtotal[5] = monthtotal[5] + getgroup.sump5>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<cfset monthtotal[6] = monthtotal[6] + getgroup.sump6>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<cfset monthtotal[7] = monthtotal[7] + getgroup.sump7>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<cfset monthtotal[8] = monthtotal[8] + getgroup.sump8>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<cfset monthtotal[9] = monthtotal[9] + getgroup.sump9>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<cfset monthtotal[10] = monthtotal[10] + getgroup.sump10>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<cfset monthtotal[11] = monthtotal[11] + getgroup.sump11>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<cfset monthtotal[12] = monthtotal[12] + getgroup.sump12>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
	  				<cfset monthtotal[13] = monthtotal[13] + getgroup.sump13>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<cfset monthtotal[14] = monthtotal[14] + getgroup.sump14>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<cfset monthtotal[15] = monthtotal[15] + getgroup.sump15>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<cfset monthtotal[16] = monthtotal[16] + getgroup.sump16>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<cfset monthtotal[17] = monthtotal[17] + getgroup.sump17>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<cfset monthtotal[18] = monthtotal[18] + getgroup.sump18> 
                    </cfif>
                    
					<cfset grandtotal = grandtotal + getgroup.total>
                </cfcase>
                
				<cfdefaultcase>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump1,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump2,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump3,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump4,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump5,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump6,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump7,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump8,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump9,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump10,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump11,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump12,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
<!--- 					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump13,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump14,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump15,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump16,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump17,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.sump18,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
			 --->		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.total,iif(form.label eq "salesqty",DE("0"),DE(getgeneral.decl_uprice)))#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getgroup.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getgroup.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getgroup.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getgroup.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getgroup.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getgroup.sump6>
					<cfset monthtotal[7] = monthtotal[7] + getgroup.sump7>
					<cfset monthtotal[8] = monthtotal[8] + getgroup.sump8>
					<cfset monthtotal[9] = monthtotal[9] + getgroup.sump9>
					<cfset monthtotal[10] = monthtotal[10] + getgroup.sump10>
					<cfset monthtotal[11] = monthtotal[11] + getgroup.sump11>
					<cfset monthtotal[12] = monthtotal[12] + getgroup.sump12>
<!--- 					<cfset monthtotal[13] = monthtotal[13] + getgroup.sump13>
					<cfset monthtotal[14] = monthtotal[14] + getgroup.sump14>
					<cfset monthtotal[15] = monthtotal[15] + getgroup.sump15>
					<cfset monthtotal[16] = monthtotal[16] + getgroup.sump16>
					<cfset monthtotal[17] = monthtotal[17] + getgroup.sump17>
					<cfset monthtotal[18] = monthtotal[18] + getgroup.sump18> --->
					<cfset grandtotal = grandtotal + getgroup.total>
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
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],iif(form.label eq "salesqty",DE("0"),DE(",.__")))#<strong></strong></font></div></td>
				</cfloop>
			</cfcase>
			<cfcase value="6">
			<cfloop index="a" from="#periodfrom#" to="#periodto#">
        	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],iif(form.label eq "salesqty",DE("0"),DE(",.__")))#<strong></strong></font></div></td>
       		</cfloop>
        </cfcase>
			<cfdefaultcase>
				<cfloop index="a" from="1" to="12">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(monthtotal[a],iif(form.label eq "salesqty",DE("0"),DE(",.__")))#<strong></strong></font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(grandtotal,iif(form.label eq "salesqty",DE("0"),DE(",.__")))#</strong></font></div></td>
	</tr>
</table>
</cfoutput>

<cfif getgroup.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
	<cfabort>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>

<!--- <cfheader name="Content-Disposition" value="inline; filename=Profit_Margin_By_Product.xls">
<cfcontent type="application/vnd.ms-excel" file="#getDirectoryFromPath(getTemplatePath())#Profit_Margin_By_Product.xls"> --->