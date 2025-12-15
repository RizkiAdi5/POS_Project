<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>
<cfset tran = #url.type#>
<cfif #tran# eq "rc">
	<cfset tran = "rc">
	<cfset tranname = "Purchase Receive">
	<cfset trancode = "rcno">
	<cfset prefix = "rccode">
</cfif>
<cfif #tran# eq "DO">
	<cfset tran = "DO">
	<cfset tranname = "Delivery Order">
	<cfset trancode = "dono">
	<cfset prefix = "docode">
</cfif>
<cfif #tran# eq "INV">
	<cfset tran = "INV">
	<cfset tranname = "Invoice">
	<cfset trancode = "invno">
	<cfset prefix = "invcode">
</cfif>
<cfif #tran# eq "CS">
	<cfset tran = "CS">
	<cfset tranname = "Cash Sales">
	<cfset trancode = "invno">
	<cfset prefix = "cscode">
</cfif>
<cfif #tran# eq "QUO">
	<cfset tran = "QUO">
	<cfset tranname = "Quotation">
	<cfset trancode = "quono">
	<cfset prefix = "quocode">
</cfif>
<cfif #tran# eq "PO">
	<cfset tran = "PO">
	<cfset tranname = "Purchase Order">
	<cfset trancode = "pono">
	<cfset prefix = "pocode">
</cfif>
<cfif #tran# eq "SO">
	<cfset tran = "SO">
	<cfset tranname = "Sales Order">
	<cfset trancode = "sono">
	<cfset prefix = "socode">
</cfif>
<cfif #tran# eq "CN">
	<cfset tran = "CN">
	<cfset tranname = "Credit Note">
	<cfset trancode = "cnno">
	<cfset prefix = "cncode">
</cfif>
<cfif #tran# eq "DN">
	<cfset tran = "DN">
	<cfset tranname = "Dedit Note">
	<cfset trancode = "dnno">
	<cfset prefix = "dncode">
</cfif>
<cfif #tran# eq "PR">
	<cfset tran = "PR">
	<cfset tranname = "Purchase Return">
	<cfset trancode = "prno">
	<cfset prefix = "prcode">
</cfif>
<cfif #tran# eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = "Sample">	
	<cfset trancode = "samno">
	<cfset prefix = "samcode">
</cfif>
<cfif tran eq 'PO' or tran eq 'PR' or tran eq 'RC'>
	<cfset ptype = target_apvend>
<cfelse>
	<cfset ptype = target_arcust>
</cfif>
<!--- <cfparam name="pagecnt" default="1"> --->
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../stylesheet/reportprint.css"/>
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>


<noscript>
Javascript has been disabled or not supported in this browser.<br>
Please enable Javascript supported before continue.
</noscript>
<!--- <cfparam name="Submit" default=""> --->
<cfparam name="Email" default="">

<cfquery datasource='#dts#' name="getHeaderInfo">
	select * from artran where refno ='#url.refno#' and type = '#tran#'
</cfquery>
<cfquery name="getgeneral" datasource="#dts#">
	select compro, compro2, compro3, compro4, compro5, compro6, compro7,CTYCODE,comuen,gstno,wpitemtax,wpitemtax1 from gsetup 
</cfquery>
<cfset wpitemtax="">
<cfif getgeneral.wpitemtax eq "1">
	<cfif getgeneral.wpitemtax1 neq "">
    	<cfif ListFindNoCase(getgeneral.wpitemtax1, tran, ",") neq 0>
			<cfset wpitemtax = "Y">
        </cfif>
	<cfelse>
    	<cfset wpitemtax="Y">
	</cfif>
</cfif>
<cfquery name="gettaxincludesum" datasource="#dts#">
        select sum(TAXAMT_BIL) as TAXAMT_BIL from ictran where refno = '#url.refno#' and type = '#tran#' and taxincl = "T"
</cfquery>

<cfif Email eq "Email">
	<cfquery name="getemail" datasource="#dts#">
		select e_mail from customer where custno = '#getheaderinfo.custno#'
	</cfquery>
	<cfif getemail.e_mail eq "">
	<cfoutput>
		<h4><font color="##FF0000">Please add in email address for customer - #getheaderinfo.custno#.</font></h4></cfoutput>
		<cfabort> 
	<cfelse> 
		<cflocation url="invoiceemail.cfm?url.refno=#url.refno#&tran=#tran#&custemail=#getemail.e_mail#&tranname=#tranname#&prefix=#getgeneral.prefix#">
	</cfif>	
</cfif>

<cfquery datasource="#dts#" name="getBodyInfo">
	select * from ictran where refno = '#url.refno#' and type = '#tran#' order by itemcount
</cfquery>

<cfif getHeaderInfo.rem0 eq "Profile">
	<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
		<cfquery datasource='#dts#' name="getBillToAdd">
   	  		select name,name2,add1,add2,add3,add4,attn,phone,fax from #target_apvend# where custno = '#getheaderInfo.custno#'
		</cfquery>
  	<cfelse>
		<cfquery datasource='#dts#' name="getBillToAdd">
   	  		select name,name2,add1,add2,add3,add4,attn,phone,fax from #target_arcust# where custno = '#getheaderInfo.custno#' 
		</cfquery>
  	</cfif>
<cfelse>
  	<cfquery datasource='#dts#' name="getBillToAdd">
    	select b.name,b.name2,a.add1,a.add2,a.add3,a.add4, a.attn, a.phone, a.fax from address a, #ptype# b where a.code = '#getheaderInfo.rem0#' and a.custno=b.custno
  	</cfquery>
	<cfif getBillToAdd.recordcount eq 0>
		<cfset getBillToAdd.name=getHeaderInfo.frem0>
		<cfset getBillToAdd.name2=getHeaderInfo.frem1>
		<cfset getBillToAdd.add1=getHeaderInfo.frem2>
		<cfset getBillToAdd.add2=getHeaderInfo.frem3>
		<cfset getBillToAdd.add3=getHeaderInfo.frem4>
		<cfset getBillToAdd.add4=getHeaderInfo.frem5>
		<cfset getBillToAdd.attn=getHeaderInfo.rem2>
		<cfset getBillToAdd.phone=getHeaderInfo.rem4>
		<cfset getBillToAdd.fax=getHeaderInfo.frem6>
	</cfif>
</cfif>

<cfif getHeaderInfo.rem1 eq "Profile">
	<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
		<cfquery datasource='#dts#' name="getDeliveryAdd">
   	  		select name,name2,DADDR1 as add1,DADDR2 as add2,DADDR3 as add3,DADDR4 as add4,DATTN as attn,DPHONE as phone,DFAX as fax from #target_apvend# where custno = '#getheaderInfo.custno#'
		</cfquery>
  	<cfelse>
		<cfquery datasource='#dts#' name="getDeliveryAdd">
   	  		select name,name2,DADDR1 as add1,DADDR2 as add2,DADDR3 as add3,DADDR4 as add4,DATTN as attn,DPHONE as phone,DFAX as fax from #target_arcust# where custno = '#getheaderInfo.custno#' 
		</cfquery>
  	</cfif>
<cfelse>
  	<cfquery datasource='#dts#' name="getDeliveryAdd">
    	select b.name,b.name2,a.add1,a.add2,a.add3,a.add4, a.attn, a.phone, a.fax from address a, #ptype# b where a.code = '#getheaderInfo.rem1#' and a.custno=b.custno
  	</cfquery>
	<cfif getDeliveryAdd.recordcount eq 0>
		<cfset getDeliveryAdd.name=getHeaderInfo.frem7>
		<cfset getDeliveryAdd.name2=getHeaderInfo.frem8>
		<cfset getDeliveryAdd.add1=getHeaderInfo.comm0>
		<cfset getDeliveryAdd.add2=getHeaderInfo.comm1>
		<cfset getDeliveryAdd.add3=getHeaderInfo.comm2>
		<cfset getDeliveryAdd.add4=getHeaderInfo.comm3>
		<cfset getDeliveryAdd.attn=getHeaderInfo.rem3>
		<cfset getDeliveryAdd.phone=getHeaderInfo.rem12>
		<cfset getDeliveryAdd.fax=getHeaderInfo.comm4>
	</cfif>
</cfif>

<cfquery name="getagent" datasource="#dts#">
      select * from icagent where agent = '#getheaderinfo.agenno#' 
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = #getgsetup2.Decl_Uprice#>
<cfset stDecl_UPrice = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = #stDecl_UPrice# & "_">
</cfloop>

<cfset iDecl_Discount = #getgsetup2.Decl_Discount#>
<cfset stDecl_Discount = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_Discount#">
  <cfset stDecl_Discount = #stDecl_Discount# & "_">
</cfloop>

<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
<cfform name="form1" action="">
   
<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<cfoutput query="getgeneral">
    <tr> 
		<td colspan="3">&nbsp;</td>
      	<td colspan="3" nowrap> <div align="center"><font size="4" face="Arial black">
			<strong><cfif getgeneral.compro neq ''>#compro#</cfif></strong></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro2 neq ''>#compro2#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro3 neq ''>#compro3#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro4 neq ''>#compro4#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro5 neq ''>#compro5#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro6 neq ''>#compro6#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro7 neq ''>#compro7#</cfif></font></div>
		</td>
      	<td colspan="3" valign="bottom">&nbsp;</td>
    </tr>
	</cfoutput>
    <tr> 
      <td colspan="100%">&nbsp;</td>
    </tr>
    <tr> 
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong>To:</strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong>Delivery To:</strong></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getBillToAdd.name# #getBillToAdd.name2#</cfoutput></strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getDeliveryAdd.name# #getDeliveryAdd.name2#</cfoutput></strong></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td colspan="3" nowrap>&nbsp;</td>
    </tr>
    <tr> 
		<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getBillToAdd.add1#</cfoutput></font></td>
	    <cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
	    	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add1#</cfoutput></font></td>
	    <cfelse>
	        <td colspan="3">&nbsp;</td>
	    </cfif>
	    <td colspan="3"><font size="3" face="Times New Roman, Times, serif">&nbsp;</font></td>
    </tr>
    <tr> 
		<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#getBillToAdd.add2#</cfoutput></font></td>
		<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add2#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="3"><strong><cfoutput>#Ucase(tranname)#</cfoutput></strong></font></td>
    </tr>
    <tr> 
      	<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#getBillToAdd.add3#</cfoutput></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add3#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td width="10%"><font face="Times New Roman, Times, serif" size="2">NO.</font></td>
      	<td width="1%"><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td width="24%"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getheaderInfo.refno#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#getBillToAdd.add4#</cfoutput></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add4#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td><font face="Times New Roman, Times, serif" size="2">DATE</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#dateformat(getHeaderInfo.wos_date,"dd/mm/yyyy")#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td colspan="3">&nbsp;</td>
      	<td colspan="3">&nbsp;</td>
      	<td><font face="Times New Roman, Times, serif" size="2">TERM</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getHeaderInfo.term#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td width="5%" nowrap><font face="Times New Roman, Times, serif" size="2"><strong>A/C NO</strong></font></td>
      	<td width="1%"><font size="2" face="Times New Roman, Times, serif"><strong>:</strong></font></td>
      	<td width="21%"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getHeaderInfo.custno#</cfoutput></strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3">&nbsp;</td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td><font face="Times New Roman, Times, serif" size="2">AGENT</font></td>
      	<td><font face="Times New Roman, Times, serif">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getagent.agent#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td><font face="Times New Roman, Times, serif" size="2"><strong>ATTN</strong></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><strong>:</strong></font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getBillToAdd.attn#</cfoutput></strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td width="4%"><font face="Times New Roman, Times, serif" size="2"><strong>ATTN</strong></font></td>
        	<td width="1%"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong></font></td>
        	<td width="33%"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.attn#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td><font face="Times New Roman, Times, serif" size="2">SHIP VIA</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getHeaderInfo.rem5#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
    </tr>
    <tr> 
      	<td><font size="2" face="Times New Roman, Times, serif">TEL</font><font size="2">&nbsp;</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getBillToAdd.phone#</cfoutput></font></td>
	    <cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td><font face="Times New Roman, Times, serif" size="2">TEL</td>
        	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.phone#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td><font size="2" face="Times New Roman, Times, serif">OUR REF NO</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getHeaderInfo.rem8#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
    </tr>
    <tr> 
      	<td><font size="2" face="Times New Roman, Times, serif">FAX</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getBillToAdd.fax#</cfoutput></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
	       <td><font face="Times New Roman, Times, serif" size="2">FAX</font></td>
	       <td><font face="Times New Roman, Times, serif" size="2">:</font></td>
	       <td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.fax#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td><font size="2" face="Times New Roman, Times, serif">YOUR REF NO</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
        	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getHeaderInfo.rem9#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
    </tr>
</table>
<hr>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr> 
      	<td width="5%" nowrap><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">ITEM</font></strong></font></div></td>
	  	<cfif tran eq "RC">
	  		<td width="20%" nowrap><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">CODE</font></strong></font></div></td>
	  	</cfif>
      	<td width="*"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">DESCRIPTION</font></strong></font></div></td>
      	<td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">QTY</font></strong></font></div></td>
      	<td width="10%" nowrap><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">U.PRICE</font></strong></font></div></td>
		<cfif wpitemtax eq "Y"><td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">TAX</font></strong></font></div></td></cfif>
      	<td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">AMOUNT</font></strong></font></div></td>
		<cfif wpitemtax eq "Y"><td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">TAX CODE</font></strong></font></div></td></cfif>
    </tr>
    <tr> 
      <td colspan="100%"><hr></td>
    </tr>
    <cfset totalamt = 0>
    <cfset totalqty = 0>
    <cfset disamt_bil = 0>
    <cfset row = 0>
	
    <cfoutput query="getBodyInfo"> 
		<cfset xamt_bil = 0>
		<cfset xqty = 0>
      
      	<cfquery name="getserial" datasource="#dts#">
      		select * from iserial where refno = '#url.refno#' and type = '#getbodyinfo.type#' 
      		and itemno = '#getbodyinfo.itemno#' and trancode = '#getbodyinfo.itemcount#'
      	</cfquery>
      	<cfset row = #row# +1>
      	<tr> 
        	<td valign="top" nowrap><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#row#</font></font></div></td>
			<cfif tran eq "RC">
	  		 	<td><div><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.itemno#</font></font></div></td>
	    	</cfif>
        	<td><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.desp# #getBodyInfo.despa#</font></font></td>
        	<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.qty#</font></font></div></td>
        	<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(getBodyInfo.price_bil,stDecl_UPrice)#</font></font></div></td>
			<cfif wpitemtax eq "Y">
				<td><div align="right"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(getBodyInfo.taxamt_bil,".__")#</font></font></div></td>
			</cfif>
			<cfif wpitemtax eq "Y" and getBodyInfo.taxincl neq "T">
				<cfset xamt_bil = val(getBodyInfo.taxamt_bil)+val(getBodyInfo.amt_bil)>
			<cfelse>
				<cfset xamt_bil = val(getBodyInfo.amt_bil)>
			</cfif>
        	<td><div align="right"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(xamt_bil,".__")#</font></font></div></td>
			<cfif wpitemtax eq "Y">
				<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.note_a#<cfif getBodyInfo.taxincl eq "T"> (Tax Included)</cfif></font></font></div></td>
        </cfif>
			<cfif getbodyinfo.amt_bil neq "">
				<cfset xamt_bil = #getBodyInfo.amt_bil#>
			</cfif>
			<cfif getBodyInfo.qty neq "">
				<cfset xqty = #getBodyInfo.qty#>
			</cfif>
        	<cfset totalamt = #totalamt# + #xamt_bil#>
        	<cfset totalqty = #totalqty# + #xqty#>
		</tr>
      	<cfif getserial.recordcount gt 0>
		  	<cfset myarray = ArrayNew(1)>
		  	<cfloop query="getserial"><cfsilent>#ArrayAppend(myarray, "#serialno#")#<br></cfsilent></cfloop>
		  	<cfset mylist1= Arraytolist(myArray, ', ')>
        	<tr> 
          		<td valign="top"><div align="left"></div></td>
          		<td><font face="Times New Roman, Times, serif"><font size="2">**S/No : #mylist1#</font></font></td>
          		<td><div align="center"></div></td>
          		<td><div align="center"></div></td>
          		<td><div align="right"></div></td>
        	</tr>
      	</cfif>
	  
    	<cfif tostring(comment) neq "">
        	<tr> 
          		<td></td>
          		<td><font face="Times New Roman"><font size="2">#replace(tostring(comment),chr(10),"<br/>","all")#</font></font></td>
          		<td></td>
          		<td></td>
         	 	<td></td>
        	</tr>
      	</cfif>
	</cfoutput> 
	<tr><td colspan="100%"><hr></td></tr>
	<cfset xdisp1 = 0>
	<cfset xdisp2 = 0>
	<cfset xdisp3 = 0>
	<cfset xtaxp1 = 0>
	 
	<cfif getheaderinfo.taxp1 neq "">
		<cfset xtaxp1 = getheaderinfo.taxp1>
	</cfif>
	 
	<cfif getheaderinfo.disp1 neq "">
		<cfset xdisp1 = getheaderinfo.disp1>	
	</cfif>
	
	<cfif getheaderinfo.disp2 neq "">
		<cfset xdisp2 = getheaderinfo.disp2>
	</cfif>
	
	<cfif getheaderinfo.disp3 neq "">
	 	<cfset xdisp3 = getheaderinfo.disp3>
	</cfif>
	
	<cfset disamt_bil = getheaderinfo.disc_bil>
	  
	<cfset net_bil = val(totalamt) - val(disamt_bil)>
	<cfset taxamt_bil = net_bil * (xtaxp1/100)>
	  
	<cfset gross_bil = net_bil + taxamt_bil> 
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"></td>
      	<td><font face="Times New Roman, Times, serif"><font size="2">TOTAL</font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(totalamt,'____.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"></td>
      	<td nowrap>
			<font face="Times New Roman, Times, serif"><font size="2">DISCOUNT 
            <cfif getheaderinfo.disp1 neq 0 and getheaderinfo.disp1 neq "">
			    <cfoutput>#numberformat(xdisp1,'____.__')# </cfoutput>
				<cfif xdisp2 neq 0>
				  	<cfoutput> + #numberformat(xdisp2,'____.__')# </cfoutput>
				</cfif>
				<cfif xdisp3 neq 0>
				  	<cfoutput> + #numberformat(xdisp3,'____.__')# </cfoutput>
				</cfif>
				(%)
			 </cfif></font></font>
		</td>
      	<td nowrap><font size="2"><div align="right"><font face="Times New Roman, Times, serif"><cfoutput>#numberformat(disamt_bil,stDecl_Discount)#</cfoutput></font></div></font></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"></td>
      	<td><font face="Times New Roman, Times, serif"><font size="2">NET</font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(net_bil,'____.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"></td>
      	<td nowrap><font face="Times New Roman, Times, serif"><font size="2">TAX <cfif getHeaderInfo.TAXINCL eq "T">ALREADY INCLUDED</cfif> <cfif getheaderinfo.taxp1 neq 0 and getheaderinfo.taxp1 neq ""><cfoutput>(#numberformat(xtaxp1,'____._')#</cfoutput>%)</cfif></font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(getHeaderInfo.tax_bil,'.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"></td>
      	<td><font face="Times New Roman, Times, serif"><font size="2">GROSS&nbsp;<cfoutput>#getheaderinfo.currcode#</cfoutput> </font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(getHeaderInfo.grand_bil,'____.__')#</cfoutput></font></div></td>
    </tr>
</table>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr> 
      	<td width="65%"><font size="2" face="Times New Roman, Times, serif">Received By :</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">Issued By :</font></td>
    </tr>
    <tr> 
      	<td height="52">&nbsp;</td>
      	<td>&nbsp;</td>
    </tr>
    <tr> 
      	<td>_____________________</td>
      	<td>_____________________</td>
    </tr>
    <tr> 
      	<td><font face="Times New Roman, Times, serif"><font size="2">Company's Stamp &amp; Signature</font></font></td>
      	<td nowrap><font size="2" face="Times New Roman, Times, serif"><cfoutput>#getagent.desp# TEL: #getagent.hp#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
    </tr>
</table>
<div align="right"> 
	<cfif husergrpid eq "Muser">
      	<a href="../../home2.cfm" class="noprint"><u><font size="2" face="Arial, Helvetica, sans-serif">Home</font></u></a> 
    </cfif>
    <font size="2" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font> 
</div>
</cfform>
</body>
</html>