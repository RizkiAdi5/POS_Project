<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<cfset thisPath = ExpandPath("/billformat/#dts#/*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfif DirectoryExists(thisDirectory) eq 'NO'>
<cftry>
	<cfdirectory action="create" directory="#thisDirectory#">
	<cffile action="copy" source="#ExpandPath("/billformat/general/preprintedformat.cfm")#" destination="#thisDirectory#">
	<cffile action="copy" source="#ExpandPath("/billformat/general/transactionformat.cfm")#" destination="#thisDirectory#">
	
	<cfdirectory action="create" directory="#GetDirectoryFromPath(ExpandPath("/Download/#dts#/ver9.0/*.*"))#">
	<cfdirectory action="create" directory="#GetDirectoryFromPath(ExpandPath("/Download/#dts#/ver9.1/*.*"))#">
	<cffile action="copy" source="#ExpandPath("/Download/ver9.0/glpost9.csv")#" destination="#GetDirectoryFromPath(ExpandPath("/Download/#dts#/ver9.0/*.*"))#">
	<cffile action="copy" source="#ExpandPath("/Download/ver9.1/glpost9.csv")#" destination="#GetDirectoryFromPath(ExpandPath("/Download/#dts#/ver9.1/*.*"))#">
	<cfoutput><p>Company directory has been created.</p></cfoutput>
<cfcatch type="any">
</cfcatch>
</cftry>
</cfif>

<cfquery name="GetSetting" datasource="#dts#">
SELECT EDControl,printapprove,lQUO,lSO FROM gsetup 
</cfquery>
<cfquery name="checkPrinted" datasource="#dts#">
SELECT printed,custno,printstatus FROM artran where refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.nexttranno#"> and type =<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tran#" >
</cfquery>
<cfif lcase(hcomid) eq "simplysiti_i">
<cfif url.tran eq "DO">
<cfif checkprinted.printed eq "Y">
<cfoutput>
<script type="text/javascript">
		alert('You Have Printed This Delivery Note Before')
</script>
</cfoutput>
</cfif>
</cfif>
</cfif>

<cfif lcase(hcomid) eq "hunting_i" and checkPrinted.printstatus eq ''>
<cfif url.tran eq 'QUO' or url.tran eq 'SO'>

<cfquery name="getbillstatus" datasource="#dts#">
select printstatus,created_by,grand,custno,name,CREATED_ON from artran where type='#url.tran#' and refno='#url.nexttranno#'
</cfquery>

<cfquery name="getgeneralmail" datasource="main">
select useremail from users where userDept = "#dts#" and userGrpId="admin" and useremail <> ""
</cfquery>

<cfset email1=''>
<cfloop query="getgeneralmail">
<cfset email1=email1&getgeneralmail.useremail>
<cfif getgeneralmail.recordcount neq getgeneralmail.currentrow>
<cfset email1=email1&",">
</cfif>
</cfloop>

<cfif email1 neq ''>

<cfif url.tran eq 'SO'>
<cfset reftypename=GetSetting.lSO>
<cfelse>
<cfset reftypename=GetSetting.lQUO>
</cfif>
<cfoutput>

<cftry>
<cfmail from="noreply@mynetiquette.com" to="#email1#" 
			subject="#url.tran#-#url.nexttranno# has been created"
		>
This message was sent by an automatic mailer built with cfmail:
= = = = = = = = = = = = = = = = = = = = = = = = = = =

Bill Type : #reftypename#
Bill No : #url.nexttranno#
Customer Name:#getbillstatus.name#
Total Amount:#getbillstatus.grand#
Created By : #getbillstatus.created_by#

</cfmail>
<cfcatch>
</cfcatch>
</cftry>
</cfoutput>

</cfif>

<cfquery name="updatestatus" datasource="#dts#">
update artran set printstatus='1' where type='#url.tran#'and refno='#url.nexttranno#'
</cfquery>
</cfif>

</cfif>

<cfif GetSetting.printapprove eq 'Y' and checkPrinted.printstatus neq 'a3' and url.tran eq 'PO'>
<cfajaximport tags="cfform">
        <cfwindow  width="350" height="300" name="printpass" refreshOnShow="true" closable="false" modal="true" title="Enter Password" initshow="true"
        source="/default/transaction/printpass/printpass.cfm?type=#url.tran#&refno=#url.nexttranno#" />
<cfelse>

<cfif getSetting.EDControl eq "Y" and checkPrinted.printed eq "Y">
<cfajaximport tags="cfform">
<cfwindow  width="350" height="300" name="exampass" refreshOnShow="true" closable="false" modal="true" title="Enter Password" initshow="true"
        source="/default/transaction/exampass/exampass.cfm?type=printing" />
<cfelse>
</cfif>
</cfif>
<html>
<head>
	<title>Transaction 3C</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfset cprint="">
<cfif tran eq 'RC' and getpin2.h2106 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'PR' and getpin2.h2205 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'DO' and getpin2.h2306 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'INV' and getpin2.h2405 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'CS' and getpin2.h2505 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'CN' and getpin2.h2605 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'DN' and getpin2.h2705 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'ISS' and getpin2.h2825 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'OAI' and getpin2.h2835 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'OAR' and getpin2.h2845 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'SAM' and getpin2.h2856 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'SAMM' and getpin2.h2856 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'PO' and getpin2.h2867 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'QUO' and getpin2.h287A eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'SO' and getpin2.h2888 eq "T">
<cfset cprint="T">
</cfif>
<cfif tran eq 'TR' and getpin2.h28A5 eq "T">
<cfset cprint="T">
</cfif>

<cfif cprint eq 'T'>
<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center" class="data">
	<tr>
    	<th height="25">Customized</th>
    	<th>Default</th>
  	</tr>
	
  	<cfoutput>
  	<tr>
    	<td height="20">
       <cfquery name="getformat" datasource="#dts#">
				select * from customized_format
				where type='#tran#'
				order by counter
			</cfquery>
			<cfset thiscount=0>
			<cfset maxcount=getformat.recordcount>
			<cfloop query="getformat">
				<cfset thiscount=thiscount+1>
				<div align="center">
					<a href="../../billformat/preprintedformat.cfm?tran=#tran#&nexttranno=#nexttranno#&BillName=#getformat.file_name#&doption=#getformat.d_option#" target="_blank" <cfif getSetting.EDControl eq "Y"> onClick="ajaxFunction(window.document.getElementById('ajaxField'),'/default/transaction/examPass/updatePrint.cfm?tran=#tran#&nexttranno=#nexttranno#');"</cfif> ><font size="2"><strong>#getformat.display_name#</strong></font></a>
					<cfif thiscount neq maxcount><br><br></cfif>
				</div>
			</cfloop>
		</td>
    	<td>
        	<div align="center">
				<a href="../../billformat/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#" 
				<cfif getSetting.EDControl eq "Y">onClick="ajaxFunction(window.document.getElementById('ajaxField'),
				'/default/transaction/examPass/updatePrint.cfm?tran=#tran#&nexttranno=#nexttranno#');"
				</cfif>>
				<font size="2"><strong>View</strong></font></a>
			</div>
        </td>
  	</tr>
    <tr>
    <td colspan="100%"><hr></td>
    </tr>
    <tr align="center">
    <td><a href="transaction.cfm?tran=#tran#" target="_self" >
					<font size="2"><b>#tran# Menu</b></font>
				</a>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <cfset aledit = 0>
<cfif tran eq "RC">
	<cfif getpin2.h2103 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "PR">

	<cfif getpin2.h2202 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "DO">

	<cfif getpin2.h2302 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "INV">

	<cfif getpin2.h2402 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "CS">

	<cfif getpin2.h2502 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "CN">

	<cfif getpin2.h2602 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "DN">

	<cfif getpin2.h2702 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "PO">

	<cfif getpin2.h2862 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "QUO">
	<cfif getpin2.h2872 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
</cfif>

<cfif tran eq "SO">

	<cfif getpin2.h2882 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>

</cfif>

<cfif tran eq "SAM">

	<cfif getpin2.h2852 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>

</cfif>
                	<cfif aledit eq 1><a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#nexttranno#&custno=#URLEncodedFormat(checkPrinted.custno)#<!--- &bcode=&dcode= --->&first=0"><font size="2"><b>Edit</b></font></a></cfif>
                </td>
    </tr>
</cfoutput>
</table>
</cfif>
<cfoutput>
<cfquery name="gettransactiondetail" datasource="#dts#">
select * from artran where refno='#url.nexttranno#' and type='#url.tran#'
</cfquery>
<cfif url.tran eq 'PO' or url.tran eq 'RC' or url.tran eq 'PR'>
<cfquery name="getcustadd" datasource="#dts#">
select * from #target_apvend# where custno='#gettransactiondetail.custno#'
</cfquery>
<cfelse>
<cfquery name="getcustadd" datasource="#dts#">
select * from #target_arcust# where custno='#gettransactiondetail.custno#'
</cfquery>
</cfif>
<br>
<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center" class="data">
<tr>
<th colspan="2"><div align="center"><font size="+1"><strong>Transaction Detail</strong></font></div></th>
</tr>
<tr>
<th colspan="2"><hr></th>
</tr>
<tr>
<th>Reference No</th>
<td>#gettransactiondetail.refno#</td>
</tr>
<tr>
<th>Customer Code</th>
<td>#gettransactiondetail.custno#</td>
</tr>
<tr>
<th>Name</th>
<td>#gettransactiondetail.name#</td>
</tr>
<tr>
<th>Address</th>
<td>#getcustadd.add1# #getcustadd.add2# <br> #getcustadd.add3# #getcustadd.add4#</td>
</tr>
<th>Tel</th>
<td>#getcustadd.phone#</td>
</tr>
<tr>
<th>Fax</th>
<td>#getcustadd.fax#</td>
</tr>
<tr>
<th>Gst</th>
<td>#numberformat(gettransactiondetail.tax_bil,',_.__')#</td>
</tr>
<tr>
<th>Net Amount</th>
<td>#numberformat(gettransactiondetail.grand_bil,',_.__')#</td>
</tr>
<tr>
<th>Project</th>
<td>#gettransactiondetail.source#</td>
</tr>
<tr>
<th>Created By</th>
<td>#gettransactiondetail.created_by#</td>
</tr>
<tr>
<th>Agent</th>
<td>#gettransactiondetail.agenno#</td>
</tr>
<tr>
<th>Voucher No</th>
<td>#gettransactiondetail.voucher#</td>
</tr>
 <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
<cfquery name="gettransactiondetail2" datasource="#dts#">
select * from ictran where refno='#url.nexttranno#' and type='#url.tran#' and itemcount = '1'
</cfquery>
<tr>
<th>Item Desp</th>
<td>#gettransactiondetail2.desp#</td>
</tr>
</cfif>

</table>
</cfoutput>
<div id="ajaxField">
</div>
</body>
</html>
