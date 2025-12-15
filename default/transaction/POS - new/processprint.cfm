<script type="text/javascript">
var ws = new ActiveXObject("WScript.Shell");
ws.Run('cmd.exe /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "Fax"','0');
</script>

<script type='text/javascript' src='/ajax/core/jquery.jqprint-0.3.js'></script>



<html>
<body onLoad="document.getElementById('sub_btn').focus()">

<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>
<cfquery name="gettermandcondition" datasource="#dts#">
	select lcs from ictermandcondition
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfquery name="getbill" datasource="#dts#">
SELECT * FROM artran WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
</cfquery>
<cfquery name="getbilltran" datasource="#dts#">
SELECT * FROM ictran WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
</cfquery>
<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfif lcase(hcomid) eq "tcds_i" and val(getbill.CS_PM_CASH) neq 0>
<cftry>
<div style="display:none">
<cfexecute 
     name="C:\WINDOWS\system32\cmd.exe" 
     arguments="/c c:\railo\tomcat\webapps\ROOT\default\transaction\POS\opendrawer.bat" 
     timeout="10800">
</cfexecute> 
</div>
<cfcatch>
</cfcatch></cftry>
</cfif>


<cfif val(getbill.CS_PM_CASH) neq 0 and val(getbill.CS_PM_CHEQ) eq 0 and val(getbill.CS_PM_CRCD) eq 0 and val(getbill.CS_PM_CRC2) eq 0 and val(getbill.CS_PM_DBCD) eq 0 and val(getbill.CS_PM_VOUC) eq 0 and val(getbill.CS_PM_CASHCD) eq 0 and val(getbill.deposit) eq 0>
<cfif getbill.taxincl eq "T">
<cfset getbill.net_bil = numberformat((numberformat(val(getbill.net_bil)* 2,'._')/2),'.__')>
<cfelse>
<cfset getbill.grand_bil = numberformat((numberformat(val(getbill.grand_bil)* 2,'._')/2),'.__')>
</cfif>
</cfif>
<cfoutput>
<cfform name="form1" id="form1" action="/default/transaction/POS/" method="post">
<table width="230px" style="font-size:12px; border-width:thin;" cellpadding="0" cellspacing="0" >
<cfif isdefined('url.reprint')> 
<tr><td colspan="3" align="center" style="font-size:20px"><cfif getbill.void eq 'Y'>Void<cfelse>Reprint</cfif></td><td widtd="10%" rowspan="100%">&nbsp;</td></tr>
</cfif>
<cfif getgsetup.displaylogo eq 'Y'><tr><td colspan="3" align="center"><img src="logo.jpg" width="150" height="50"></td></tr></cfif>
<tr><td colspan="3" align="center"><a style="cursor:pointer; font-size:20px" onClick="window.print()"><strong>#getgsetup.compro#</strong></a></td><td widtd="10%" rowspan="100%">&nbsp;</td></tr>
<tr><td colspan="3" align="center">#getgsetup.compro2#</td></tr>
<tr><td colspan="3" align="center">#getgsetup.compro3#</td></tr>
<tr><td colspan="3" align="center">#getgsetup.compro4#</td></tr>
<tr><td colspan="3" align="center">#getgsetup.compro5#</td></tr>
<tr><td colspan="3" align="center">Receipt No : #getbill.refno#</td></tr>
<tr><td colspan="3" align="center">Date : #dateformat(getbill.trdatetime,'DD-MM-YYYY')#</td></tr>
<tr><td colspan="3" align="center">Time : #timeformat(getbill.trdatetime,'HH:MM:SS')#</td></tr>
<tr>
<td colspan="3"></td>
</tr>
<cfif getbill.rem30 neq ''>
<tr><td colspan="3" align="left">Customer Name : #getbill.rem30#</td></tr>
</cfif>
<cfif getbill.rem31 neq ''>
<tr><td colspan="3" align="left">Phone No : #getbill.rem31#</td></tr>
</cfif>
<cfif getbill.rem32 neq ''>
<tr><td colspan="3" align="left">Email : #getbill.rem32#</td></tr>
</cfif>
<tr>
<td colspan="3"></td>
</tr>
<tr><td colspan="3"></td></tr>
<cfloop query="getbilltran">
<cfset priceunit = 0>
<cfif getbilltran.brem4 neq "">
<cfif right(getbilltran.brem4,1) eq "%">
    <cfset totpercent = val(getbilltran.brem4)>
        <cfif totpercent lte 100 and totpercent gt 0>
        <cfset priceunit = numberformat(val(getbilltran.price_bil) * ((100-totpercent)/100),stDecl_UPrice)>
        </cfif>
    <cfelse>
    <cfset totdis = val(getbilltran.brem4)>
        <cfif totdis lte val(getbilltran.price_bil)>
        <cfset priceunit =numberformat(val(getbilltran.price_bil) - val(totdis),stDecl_UPrice)>
        </cfif>
    </cfif>
</cfif>
<tr>
<td colspan="3" style="font-size:5px">&nbsp;</td>
</tr>
<tr>
<td align="left" colspan="3" valign="bottom">#getbilltran.itemno# <cfif getbilltran.brem3 neq '' and getbilltran.itemno eq 'voucher'>&nbsp;&nbsp;&nbsp; <a href="printvoucher.cfm?voucherno=#getbilltran.brem3#&refno=#getbilltran.refno#" target="_blank">Print Voucher #getbilltran.brem3#</a></cfif></td>
</tr>
<tr>
<td align="left" colspan="3"  width="220px">#getbilltran.desp#<cfif hcomid eq "hodaka_i">#getbilltran.despa#<br>#getbilltran.comment#</cfif><cfif getbilltran.brem1 eq "Delivery">-Delivery</cfif></td>
</tr>
<!--- <cfif priceunit neq 0>
<tr>
<td align="left">(#numberformat(getbilltran.price_bil,'.__')#)</td>
</tr>
</cfif> --->
<tr valign="top">
<td align="left" colspan="2">#getbilltran.qty_bil# * <cfif priceunit neq 0>#numberformat(price_bil,'.__')#<cfelse>#numberformat(getbilltran.price_bil,'.__')#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif getbilltran.dispec1 neq 0>#getbilltran.dispec1#%</cfif>&nbsp;&nbsp;&nbsp;<cfif getbilltran.disamt_bil neq 0>-#getbilltran.disamt_bil#</cfif></td>

<td align="right">#numberformat(getbilltran.amt_bil,'.__')#</td>
</tr>
</cfloop>

<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">
<cfquery name="getotalqty" datasource="#dts#">
SELECT sum(qty_bil) as totalqty FROM ictran where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
</cfquery>
Total Quantity :  #getotalqty.totalqty#</td>
<td align="right"></td>
</tr>
<cfset showcurrcode = "S$">
<cfif getbill.currcode neq "">
<cfquery name="getcurrency" datasource="#dts#">
SELECT currency FROM currency WHERE currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getBill.currcode#">
</cfquery>
<cfset showcurrcode = getcurrency.currency>
</cfif>
<cfif lcase(hcomid) neq "tcds_i">
<tr>
<td colspan="2" align="right">
SubTotal (#showcurrcode#)</td>
<td align="right"><cfif getbill.taxincl eq "T">#numberformat(val(getbill.gross_bil)+val(getbill.tax_bil),'.__')#<cfelse>#numberformat(val(getbill.gross_bil),'.__')#</cfif></td>
</tr>
</cfif>
<cfif lcase(hcomid) eq "tcds_i">
<tr>
<td colspan="2" align="right">
Voucher Discount
</td>
<td align="right">
#numberformat(val(getbill.permitno),'.__')#
</td>
</tr>
<tr>
<td colspan="2" align="right">
VIP $ Discount
</td>
<td align="right">
#numberformat(val(getbill.rem5),'.__')#
</td>
</tr>
<cfelse>
<tr>
<td colspan="2" align="right">
Further #numberformat(val(getbill.disp1),'.__')#%
</td>
<td align="right">
(#numberformat(val(getbill.disc_bil),'.__')#)
</td>
</tr>
</cfif>
<cfif lcase(hcomid) neq "tcds_i">
<tr>
<td colspan="2" align="right">
Rounding Adjustment
</td>
<td align="right">
#numberformat(val(getbill.roundadj),'.__')#
</td>
</tr>
</cfif>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">
<cfif getbill.taxincl eq "T">
Total Payable (#showcurrcode#)
<cfelse>
Before Tax Total (#showcurrcode#)
</cfif>
</td>

<td align="right">
<cfif getbill.taxincl eq "T"><b></cfif>#numberformat(val(getbill.net_bil),'.__')#<cfif getbill.taxincl eq "T"></b></cfif>
</td>
</tr>
<td colspan="2" align="right"><cfif getbill.taxincl eq "T">Include </cfif>GST (#numberformat(val(getbill.taxp1),'.__')#)</td>
<td align="right">#numberformat(getbill.tax_bil,'.__')#</td>
</tr>

<tr>
<td colspan="2" align="right">Misc Charges</td>
<td align="right">#numberformat(getbill.MC1_bil,'.__')#</td>
</tr>

<tr>
<th colspan="2" align="right">Total Payable (#showcurrcode#)</th>
<th align="right">#numberformat(getbill.grand_bil,'.__')#</th>
</tr>
<cfif val(getbill.CS_PM_CASH) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Cash  (#showcurrcode#)</td>
<td align="right">#numberformat(val(getbill.CS_PM_CASH)+val(getbill.rem11),'.__')#</td>
</tr>
<tr>
<td colspan="2" align="right">Changes Due (#showcurrcode#)</td>
<td align="right">#numberformat(val(getbill.rem11),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_CHEQ) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Cheque-#getbill.checkno#</td>
<td align="right">#numberformat(val(getbill.CS_PM_CHEQ),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_CRCD) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Credit Card-#getbill.rem10#</td>
<td align="right">#numberformat(val(getbill.CS_PM_CRCD),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_CRC2) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Credit Card-#getbill.rem8#</td>
<td align="right">#numberformat(val(getbill.CS_PM_CRC2),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_DBCD) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">NETS</td>
<td align="right">#numberformat(val(getbill.CS_PM_DBCD),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_VOUC) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Voucher</td>
<td align="right">#numberformat(val(getbill.CS_PM_VOUC),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.CS_PM_cashcd) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Cash Card</td>
<td align="right">#numberformat(val(getbill.CS_PM_cashcd),'.__')#</td>
</tr>
</cfif>
<cfif val(getbill.deposit) neq 0>
<tr><td colspan="3"><hr/></td></tr>
<tr>
<td colspan="2" align="right">Deposit</td>
<td align="right">#numberformat(val(getbill.deposit),'.__')#</td>
</tr>
</cfif>
<tr><td colspan="3"></td></tr>
<cfif lcase(hcomid) eq "tcds_i">
<cfif getbill.van neq ''>
<cftry>
<cfquery name="getpoints" datasource="#dtssync#">
select ifnull(pointsbf+points-pointsredeem,0) as points from driver where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getbill.van#">
</cfquery>
<tr>
<td colspan="2" align="right">Member Point Balance</td>
<td align="right">#getpoints.points#</td>
</tr>
<cfcatch>
<tr>
<td colspan="2" align="right">Member Point Balance</td>
<td align="right"></td>
</tr>
</cfcatch></cftry>
<tr><td colspan="3"></td></tr>
</cfif>
</cfif>
<cfif lcase(hcomid) neq "tcds_i">
<tr>
<td align="Left">Cashiers</td>
<td  colspan="2"  align="right">#getbill.userid#</td>
</tr>

<tr>
<cfquery name="getagentname" datasource="#dts#">
select desp from icagent where agent='#getbill.agenno#'
</cfquery>
<td align="Left">Salesman</td>
<td  colspan="2"  align="right">#getagentname.desp#</td>
</tr>
</cfif>
<cfif lcase(hcomid) eq "tcds_i">
<cfif getbill.van neq ''>

<cfquery name="getmembername" datasource="#dts#">
select name from driver where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getbill.van#">
</cfquery>
<tr>
<td align="Left" colspan="3">Member : #getbill.van# - #getmembername.name#</td>
</tr>

</cfif>
</cfif>
<tr>
<td><cfif lcase(hcomid) neq "tcds_i">Remarks<cfelse>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif></td>
</tr>
<tr>
<td colspan="3">
#getbill.rem9#
</td>


<cfset info=tostring(gettermandcondition.lcs)>
<cfset recordcnt = ListLen(info,chr(13)&chr(10))>


<tr><td colspan="3" align="center"><strong>Terms & Conditions</strong></td></tr>
<cfquery name="getreserve" datasource="#dts#">
select * from reserve where reserveno='#getbill.refno#'
</cfquery>
<cfif getreserve.recordcount neq 0>
<tr><td colspan="3" align="center">If the reserve item(s) is not pick up within 2 months of arrival, the deposit will be forfeited, and reservation will be cancelled.
<br>GOODS SOLD ARE NOT RETURNABLE, REFUNDABLE & EXCHANGEABLE</td></tr>
<cfelse>
<cfloop from="1" to="#recordcnt#" index="i">
<cfset str = ListGetAt(info,i,chr(13)&chr(10))>
<tr><td colspan="3" align="center">#str#</td></tr>
<cfset i=i+1>

</cfloop>
</cfif>
</tr>
<td colspan="3" align="center">
<input type="hidden" name="counterchoose" id="counterchoose" value="#getbill.counter#">
<input type="submit" name="sub_btn" id="sub_btn" value="**Thank You**" style="background:none; 
                        border:0; 
                        margin:0; 
                        padding:0;
                        font-size:10px; 
"><br/>
<input type="submit" name="sub_btn" id="sub_btn" value="Have a nice day" style="background:none; 
                        border:0; 
                        margin:0; 
                        padding:0; 
                        font-size:10px; 
">
</td>
</tr>
</table></cfform>





<script type="text/javascript">

this.print(false);

</script>


</cfoutput>
</body>
</html>
<!---

<cfheader name="Content-Disposition" value="inline; filename=test.txt">
<cfcontent type="application/msword" file="c:\railo\test.txt" deletefile="yes"> --->
