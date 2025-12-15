<cfquery name="getgeneral" datasource="#dts#">
	select a.compro,date_format(a.lastaccyear,'%Y-%m-%d') as lastaccyear,concat(',.',repeat('_',b.decl_uprice))as decl_uprice
	from gsetup as a, gsetup2 as b;
</cfquery>

<cfset grandtotal = 0>
<cfset monthtotal = arraynew(1)>

<cfswitch expression="#form.label#">
	<cfcase value="salesqty">
		<cfset stDecl_UPrice = ".__">
	</cfcase>
	<cfdefaultcase>
		<cfset stDecl_UPrice = getgeneral.decl_uprice>
	</cfdefaultcase>
</cfswitch>

<cfswitch expression="#form.period#">
	<cfcase value="1">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth11" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="2">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth12" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="3">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth13" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
		</cfinvoke>
	</cfcase>
	<cfcase value="4">
		<cfloop index="a" from="1" to="18">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth14" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
		</cfinvoke>
	</cfcase>
    <cfcase value="5">
		<cfloop index="a" from="1" to="1">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonthbymonth" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
            <cfinvokeargument name="period" value="#form.poption#">
		</cfinvoke>
	</cfcase>
    <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth15" method="getmonthitem" returnvariable="getitem">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="catefrom" value="#trim(form.catefrom)#">
			<cfinvokeargument name="cateto" value="#trim(form.cateto)#">
            <cfinvokeargument name="periodfrom" value="#trim(form.periodfrom)#">
			<cfinvokeargument name="periodto" value="#trim(form.periodto)#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
			<cfinvokeargument name="agentfrom" value="#form.agentfrom#">
			<cfinvokeargument name="agentto" value="#form.agentto#">
            <cfinvokeargument name="teamfrom" value="#form.teamfrom#">
			<cfinvokeargument name="teamto" value="#form.teamto#">
			<cfinvokeargument name="areafrom" value="#form.areafrom#">
			<cfinvokeargument name="areato" value="#form.areato#">
			<cfinvokeargument name="groupfrom" value="#trim(form.groupfrom)#">
			<cfinvokeargument name="groupto" value="#trim(form.groupto)#">
			<cfinvokeargument name="label" value="#form.label#">
            <cfinvokeargument name="alown" value="#url.alown#">
            <cfinvokeargument name="huserid" value="#huserid#">
            <cfinvokeargument name="Huserloc" value="#Huserloc#">
			<cfinvokeargument name="include" value="#IIF(isdefined('form.include'),'form.include',DE(isdefined('form.include')))#">
			<cfinvokeargument name="include0" value="#IIF(isdefined('form.include0'),'form.include0',DE(isdefined('form.include0')))#">
		</cfinvoke>
	</cfcase>
</cfswitch>

<html>
<head>
<title>Product Sales By Month Report</title>
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
                <cfcase value="5">PERIOD #form.Poption#</cfcase>
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
    <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
        </tr>
    </cfif>
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
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
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
      	<td><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></td>
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

	<cfloop query="getitem">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>

			<cfswitch expression="#form.period#">
				<cfcase value="1,2,3" delimiters=",">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump1#<cfelse>#numberformat(getitem.sump1,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump2#<cfelse>#numberformat(getitem.sump2,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump3#<cfelse>#numberformat(getitem.sump3,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump4#<cfelse>#numberformat(getitem.sump4,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump5#<cfelse>#numberformat(getitem.sump5,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump6#<cfelse>#numberformat(getitem.sump6,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.total#<cfelse>#numberformat(getitem.total,stDecl_UPrice)#</cfif></font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getitem.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getitem.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getitem.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getitem.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getitem.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getitem.sump6>
					<cfset grandtotal = grandtotal + getitem.total>
				</cfcase>
                <cfcase value="5">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#getitem.sump1#<cfelse>#numberformat(getitem.sump1,stDecl_UPrice)#</cfif></font></div></td>
                <cfset monthtotal[1] = monthtotal[1] + getitem.sump1>
				<cfset grandtotal = grandtotal + getitem.total>
                </cfcase>
                 <cfcase value="6">
                 <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
                 <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump1)#<cfelse>#numberformat(getitem.sump1,stDecl_UPrice)#</cfif></font></div></td></cfif>
                 <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump2)#<cfelse>#numberformat(getitem.sump2,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump3)#<cfelse>#numberformat(getitem.sump3,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump4)#<cfelse>#numberformat(getitem.sump4,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump5)#<cfelse>#numberformat(getitem.sump5,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump6)#<cfelse>#numberformat(getitem.sump6,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump7)#<cfelse>#numberformat(getitem.sump7,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump8)#<cfelse>#numberformat(getitem.sump8,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump9)#<cfelse>#numberformat(getitem.sump9,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump10)#<cfelse>#numberformat(getitem.sump10,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump11)#<cfelse>#numberformat(getitem.sump11,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump12)#<cfelse>#numberformat(getitem.sump12,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump13)#<cfelse>#numberformat(getitem.sump13,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump14)#<cfelse>#numberformat(getitem.sump14,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump15)#<cfelse>#numberformat(getitem.sump15,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump16)#<cfelse>#numberformat(getitem.sump16,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump17)#<cfelse>#numberformat(getitem.sump17,stDecl_UPrice)#</cfif></font></div></td></cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump18)#<cfelse>#numberformat(getitem.sump18,stDecl_UPrice)#</cfif></font></div></td></cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.total)#<cfelse>#numberformat(getitem.total,stDecl_UPrice)#</cfif></font></div></td>
                    <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
					<cfset monthtotal[1] = monthtotal[1] + getitem.sump1>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<cfset monthtotal[2] = monthtotal[2] + getitem.sump2>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<cfset monthtotal[3] = monthtotal[3] + getitem.sump3>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<cfset monthtotal[4] = monthtotal[4] + getitem.sump4>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<cfset monthtotal[5] = monthtotal[5] + getitem.sump5>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<cfset monthtotal[6] = monthtotal[6] + getitem.sump6>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<cfset monthtotal[7] = monthtotal[7] + getitem.sump7>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<cfset monthtotal[8] = monthtotal[8] + getitem.sump8>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<cfset monthtotal[9] = monthtotal[9] + getitem.sump9>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<cfset monthtotal[10] = monthtotal[10] + getitem.sump10>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<cfset monthtotal[11] = monthtotal[11] + getitem.sump11>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<cfset monthtotal[12] = monthtotal[12] + getitem.sump12>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<cfset monthtotal[13] = monthtotal[13] + getitem.sump13>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<cfset monthtotal[14] = monthtotal[14] + getitem.sump14>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<cfset monthtotal[15] = monthtotal[15] + getitem.sump15>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<cfset monthtotal[16] = monthtotal[16] + getitem.sump16>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<cfset monthtotal[17] = monthtotal[17] + getitem.sump17>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<cfset monthtotal[18] = monthtotal[18] + getitem.sump18>
                    </cfif>
					<cfset grandtotal = grandtotal + getitem.total>
                 
			</cfcase>
				<cfdefaultcase>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump1)#<cfelse>#numberformat(getitem.sump1,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump2)#<cfelse>#numberformat(getitem.sump2,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump3)#<cfelse>#numberformat(getitem.sump3,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump4)#<cfelse>#numberformat(getitem.sump4,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump5)#<cfelse>#numberformat(getitem.sump5,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump6)#<cfelse>#numberformat(getitem.sump6,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump7)#<cfelse>#numberformat(getitem.sump7,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump8)#<cfelse>#numberformat(getitem.sump8,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump9)#<cfelse>#numberformat(getitem.sump9,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump10)#<cfelse>#numberformat(getitem.sump10,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump11)#<cfelse>#numberformat(getitem.sump11,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump12)#<cfelse>#numberformat(getitem.sump12,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump13)#<cfelse>#numberformat(getitem.sump13,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump14)#<cfelse>#numberformat(getitem.sump14,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump15)#<cfelse>#numberformat(getitem.sump15,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump16)#<cfelse>#numberformat(getitem.sump16,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump17)#<cfelse>#numberformat(getitem.sump17,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.sump18)#<cfelse>#numberformat(getitem.sump18,stDecl_UPrice)#</cfif></font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(getitem.total)#<cfelse>#numberformat(getitem.total,stDecl_UPrice)#</cfif></font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getitem.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getitem.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getitem.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getitem.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getitem.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getitem.sump6>
					<cfset monthtotal[7] = monthtotal[7] + getitem.sump7>
					<cfset monthtotal[8] = monthtotal[8] + getitem.sump8>
					<cfset monthtotal[9] = monthtotal[9] + getitem.sump9>
					<cfset monthtotal[10] = monthtotal[10] + getitem.sump10>
					<cfset monthtotal[11] = monthtotal[11] + getitem.sump11>
					<cfset monthtotal[12] = monthtotal[12] + getitem.sump12>
					<cfset monthtotal[13] = monthtotal[13] + getitem.sump13>
					<cfset monthtotal[14] = monthtotal[14] + getitem.sump14>
					<cfset monthtotal[15] = monthtotal[15] + getitem.sump15>
					<cfset monthtotal[16] = monthtotal[16] + getitem.sump16>
					<cfset monthtotal[17] = monthtotal[17] + getitem.sump17>
					<cfset monthtotal[18] = monthtotal[18] + getitem.sump18>
					<cfset grandtotal = grandtotal + getitem.total>
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
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(monthtotal[a])#<cfelse>#numberformat(monthtotal[a],stDecl_UPrice)#</cfif><strong></strong></font></div></td>
				</cfloop>
			</cfcase>
		<cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(monthtotal[a])#<cfelse>#numberformat(monthtotal[a],stDecl_UPrice)#</cfif><strong></strong></font></div></td>
        </cfloop>
        </cfcase>
			<cfdefaultcase>
				<cfloop index="a" from="1" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif form.label eq "salesqty" >#val(monthtotal[a])#<cfelse>#numberformat(monthtotal[a],stDecl_UPrice)#</cfif><strong></strong></font></div></td>
				</cfloop>
			</cfdefaultcase>
		</cfswitch>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong><cfif form.label eq "salesqty" >#val(grandtotal)#<cfelse>#numberformat(grandtotal,stDecl_UPrice)#</cfif></strong></font></div></td>
	</tr>
</table>
</cfoutput>

<cfif getitem.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
	<cfabort>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>