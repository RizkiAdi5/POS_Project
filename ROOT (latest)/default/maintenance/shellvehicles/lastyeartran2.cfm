<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfparam name="ndatefrom" default="">
<cfparam name="ndateto" default="">

	
<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>

	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>

	<cfif dd greater than '12'>
		<cfset ndateto = dateformat(form.dateto,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYYDDMM")>
	</cfif>
</cfif>

<cfquery name="getlastyeartran" datasource="#dts#">
select * from shelllastyeartran where vehicle='#trim(url.entryno)#'
        
        	</cfquery>
			
		<html>
		<head>
			<title>LOADING REPORT</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href = "/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
			<style type="text/css" media="print">
				.noprint { display: none; }
			</style>
		</head>

		<body>
		
		<table align="center" cellpadding="3" cellspacing="0" width="100%">
		<cfoutput>
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>PREVIOUS TRANSACTION</strong></font></div></td>
			</tr>
			
			<tr>
				<td colspan="4"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.compro#</font></td>
				<td></td>
				<td></td>
				<td></td>
				<td colspan="20"><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfoutput>

			<tr>
            	<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Site</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Invoice Number</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Invoice Date</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Customer</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Add 1</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Add 2
</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Add 3</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Add 4</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong> Contact</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Tel</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Stock Code</strong></font></div></td>

                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Stock Desc</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Latest Cost</strong></font></div></td>

                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Qty</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Stock Selling Price</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Actual Selling Price</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Stock Total Sales</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Add On Amt</strong></font></div></td>

                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Disc Amt</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Actual Total Sales</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Total Stock COGS</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Category 1</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Category 2</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Category 3</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Vehicles</strong></font></div></td>
                
                
			</tr>
            <cfoutput>

            <cfloop query="getlastyeartran">
           
            
            <tr>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#site#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#refno#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(getlastyeartran.wos_date,'DD/MM/YYYY')#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#custno#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#add1#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#add2#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#add3#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#add4#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#contact#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#tel#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#stockcode#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#stockdesp#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#lastestcost#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#qty#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#stockprice#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#actualprice#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#stockamt#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#addonamount#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#discountamount#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#totalamount#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#totalstock#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#category1#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#category2#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#category3#</font></div></td>
            <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#vehicle#</font></div></td>
</tr>
<tr><td colspan="100%"><hr></td></tr>
			</cfloop>
            </cfoutput>
		</table>
		
		<br><br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
