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
		<cfinvoke component="salesmonth51" method="getmonthuser" returnvariable="getuser">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="userfrom" value="#form.userfrom#">
			<cfinvokeargument name="userto" value="#form.userto#">
		</cfinvoke>
	</cfcase>
	<cfcase value="2">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth52" method="getmonthuser" returnvariable="getuser">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="userfrom" value="#form.userfrom#">
			<cfinvokeargument name="userto" value="#form.userto#">
		</cfinvoke>
	</cfcase>
	<cfcase value="3">
		<cfloop index="a" from="1" to="6">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth53" method="getmonthuser" returnvariable="getuser">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="userfrom" value="#form.userfrom#">
			<cfinvokeargument name="userto" value="#form.userto#">
		</cfinvoke>
	</cfcase>
	<cfcase value="4">
		<cfloop index="a" from="1" to="18">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth54" method="getmonthuser" returnvariable="getuser">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
			<cfinvokeargument name="userfrom" value="#form.userfrom#">
			<cfinvokeargument name="userto" value="#form.userto#">
		</cfinvoke>
	</cfcase>
    <cfcase value="6">
		<cfloop index="a" from="#periodfrom#" to="#periodto#">
			<cfset monthtotal[a] = 0>
		</cfloop>
		<cfinvoke component="salesmonth55" method="getmonthuser" returnvariable="getuser">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="lastaccyear" value="#getgeneral.lastaccyear#">
            <cfinvokeargument name="periodfrom" value="#trim(form.periodfrom)#">
			<cfinvokeargument name="periodto" value="#trim(form.periodto)#">
			<cfinvokeargument name="userfrom" value="#form.userfrom#">
			<cfinvokeargument name="userto" value="#form.userto#">
		</cfinvoke>
	</cfcase>
</cfswitch>

<html>
<head>
<title>End User Sales By Month Report</title>
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
		<td colspan="25"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY MONTH REPORT</strong></font></div></td>
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
    <cfif form.userfrom neq "" and form.userto neq "">
        <tr>
          	<td colspan="25"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
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
      	<td><font size="2" face="Times New Roman, Times, serif">END USER</font></td>
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

	<cfloop query="getuser">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><font size="2" face="Times New Roman, Times, serif">#getuser.currentrow#.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getuser.van eq "",DE("No-USER"),DE(getuser.van))#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#IIF(getuser.desp eq "",DE(""),DE(getuser.desp))#</font></td>
			<cfswitch expression="#form.period#">
				<cfcase value="1,2,3" delimiters=",">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getuser.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getuser.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getuser.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getuser.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getuser.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getuser.sump6>
					<cfset grandtotal = grandtotal + getuser.total>
				</cfcase>
                <cfcase value="6">
                <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump1,getgeneral.decl_uprice)#</font></div></td>
                </cfif>
                <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump2,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump3,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump4,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump5,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump6,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump7,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump8,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump9,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump10,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump11,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump12,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump13,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump14,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump15,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump16,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump17,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump18,getgeneral.decl_uprice)#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.total,getgeneral.decl_uprice)#</font></div></td>
                    <cfif form.periodfrom  lte 1 and form.periodto gte 1 >
					<cfset monthtotal[1] = monthtotal[1] + getuser.sump1>
                    </cfif>
                    <cfif form.periodfrom  lte 2 and form.periodto gte 2 >
					<cfset monthtotal[2] = monthtotal[2] + getuser.sump2>
                    </cfif>
                    <cfif form.periodfrom  lte 3 and form.periodto gte 3 >
					<cfset monthtotal[3] = monthtotal[3] + getuser.sump3>
                    </cfif>
                    <cfif form.periodfrom  lte 4 and form.periodto gte 4 >
					<cfset monthtotal[4] = monthtotal[4] + getuser.sump4>
                    </cfif>
                    <cfif form.periodfrom  lte 5 and form.periodto gte 5 >
					<cfset monthtotal[5] = monthtotal[5] + getuser.sump5>
                    </cfif>
                    <cfif form.periodfrom  lte 6 and form.periodto gte 6 >
					<cfset monthtotal[6] = monthtotal[6] + getuser.sump6>
                    </cfif>
                    <cfif form.periodfrom  lte 7 and form.periodto gte 7 >
					<cfset monthtotal[7] = monthtotal[7] + getuser.sump7>
                    </cfif>
                    <cfif form.periodfrom  lte 8 and form.periodto gte 8 >
					<cfset monthtotal[8] = monthtotal[8] + getuser.sump8>
                    </cfif>
                    <cfif form.periodfrom  lte 9 and form.periodto gte 9 >
					<cfset monthtotal[9] = monthtotal[9] + getuser.sump9>
                    </cfif>
                    <cfif form.periodfrom  lte 10 and form.periodto gte 10 >
					<cfset monthtotal[10] = monthtotal[10] + getuser.sump10>
                    </cfif>
                    <cfif form.periodfrom  lte 11 and form.periodto gte 11 >
					<cfset monthtotal[11] = monthtotal[11] + getuser.sump11>
                    </cfif>
                    <cfif form.periodfrom  lte 12 and form.periodto gte 12 >
					<cfset monthtotal[12] = monthtotal[12] + getuser.sump12>
                    </cfif>
                    <cfif form.periodfrom  lte 13 and form.periodto gte 13 >
					<cfset monthtotal[13] = monthtotal[13] + getuser.sump13>
                    </cfif>
                    <cfif form.periodfrom  lte 14 and form.periodto gte 14 >
					<cfset monthtotal[14] = monthtotal[14] + getuser.sump14>
                    </cfif>
                    <cfif form.periodfrom  lte 15 and form.periodto gte 15 >
					<cfset monthtotal[15] = monthtotal[15] + getuser.sump15>
                    </cfif>
                    <cfif form.periodfrom  lte 16 and form.periodto gte 16 >
					<cfset monthtotal[16] = monthtotal[16] + getuser.sump16>
                    </cfif>
                    <cfif form.periodfrom  lte 17 and form.periodto gte 17 >
					<cfset monthtotal[17] = monthtotal[17] + getuser.sump17>
                    </cfif>
                    <cfif form.periodfrom  lte 18 and form.periodto gte 18 >
					<cfset monthtotal[18] = monthtotal[18] + getuser.sump18>
                    </cfif>
					<cfset grandtotal = grandtotal + getuser.total>
                </cfcase>
				<cfdefaultcase>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump1,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump2,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump3,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump4,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump5,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump6,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump7,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump8,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump9,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump10,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump11,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump12,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump13,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump14,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump15,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump16,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump17,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.sump18,getgeneral.decl_uprice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getuser.total,getgeneral.decl_uprice)#</font></div></td>
					<cfset monthtotal[1] = monthtotal[1] + getuser.sump1>
					<cfset monthtotal[2] = monthtotal[2] + getuser.sump2>
					<cfset monthtotal[3] = monthtotal[3] + getuser.sump3>
					<cfset monthtotal[4] = monthtotal[4] + getuser.sump4>
					<cfset monthtotal[5] = monthtotal[5] + getuser.sump5>
					<cfset monthtotal[6] = monthtotal[6] + getuser.sump6>
					<cfset monthtotal[7] = monthtotal[7] + getuser.sump7>
					<cfset monthtotal[8] = monthtotal[8] + getuser.sump8>
					<cfset monthtotal[9] = monthtotal[9] + getuser.sump9>
					<cfset monthtotal[10] = monthtotal[10] + getuser.sump10>
					<cfset monthtotal[11] = monthtotal[11] + getuser.sump11>
					<cfset monthtotal[12] = monthtotal[12] + getuser.sump12>
					<cfset monthtotal[13] = monthtotal[13] + getuser.sump13>
					<cfset monthtotal[14] = monthtotal[14] + getuser.sump14>
					<cfset monthtotal[15] = monthtotal[15] + getuser.sump15>
					<cfset monthtotal[16] = monthtotal[16] + getuser.sump16>
					<cfset monthtotal[17] = monthtotal[17] + getuser.sump17>
					<cfset monthtotal[18] = monthtotal[18] + getuser.sump18>
					<cfset grandtotal = grandtotal + getuser.total>
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

<cfif getuser.recordcount eq 0>
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