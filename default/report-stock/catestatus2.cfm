<html>
<head>
<title>Category Status and Value Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear from gsetup
</cfquery>

<cfparam name="i" default="1" type="numeric">
<cfparam name="RCqty" default="0">
<cfparam name="PRqty" default="0">
<cfparam name="DOqty" default="0">
<cfparam name="invqty" default="0">
<cfparam name="CNqty" default="0">
<cfparam name="DNqty" default="0">
<cfparam name="CSqty" default="0">
<cfparam name="ISSqty" default="0">
<cfparam name="OAIqty" default="0">
<cfparam name="OARqty" default="0">
<cfparam name="xucost" default="0.0000000">
<cfparam name="balonhand" default="0">
<cfparam name="lastbalonhand" default="0">

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset totalbf=0>
<cfset totalin=0>
<cfset totalout=0>
<cfset totalbal=0>
<cfset totalstkval=0>

<cfset iDecl_UPrice = #getgsetup2.Decl_UPrice#>
<cfset stDecl_UPrice = ",___.">
<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = #stDecl_UPrice# & "_">
</cfloop>

<cfif getgeneral.cost eq "FIXED">
	<cfset costingmethod = "Fixed Cost Method">
<cfelseif getgeneral.cost eq "MONTH">
	<cfset costingmethod = "Month Average Method">
<cfelseif getgeneral.cost eq "MOVING">
	<cfset costingmethod = "Moving Average Method">
<cfelseif getgeneral.cost eq "FIFO">
	<cfset costingmethod = "First In First Out Method">
<cfelse>
	<cfset costingmethod = "Last In First Out Method">
</cfif>


<body>
<h1 align="center">Category Status and Value Summary</h1>
<h2 align="center">Calculated by <cfoutput>#costingmethod#</cfoutput></h2>

<cfif getgeneral.cost neq "fifo" and getgeneral.cost neq "lifo">

<cfquery name="getitem" datasource="#dts#">
	select itemno,desp,wos_group,category,sum(qtybf) as qtybf,ucost from icitem where itemno <> '' and category <>''

	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
	and category >= '#form.catefrom#' and category <= '#form.cateto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	and wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
	</cfif>
	group by category order by category
</cfquery>

<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0">
	<tr><cfoutput>
      	<td colspan="4"><font size="2" face="Times New Roman, Times, serif">
        <cfif getgeneral.compro neq "">
          #getgeneral.compro#
        </cfif>
        </font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr></cfoutput>
    <tr>
      	<td colspan="10"><hr></td>
    </tr>
  	<tr>
  		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">No</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">Category</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Unit Cost</font></div></td>
        </cfif>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Qty Bf</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">In</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Out</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Balance</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Stock Value ($)</font></div></td></cfif>
	</tr>
 	 <tr>
      	<td colspan="10"><hr></td>
    </tr>
  <cfoutput query="getitem">
    <cfset itembal = 0>
	<cfset fixedcost = 0>
    <cfset rcqty = 0>
    <cfset invqty = 0>
    <cfset cnqty = 0>
    <cfset prqty = 0>
    <cfset dnqty = 0>
    <cfset doqty = 0>
	<cfset csqty = 0>
	<cfset issqty = 0>
	<cfset oaiqty = 0>
	<cfset oarqty = 0>
	<cfset xucost = 0.0000000>
	<cfset lastitembal = 0>
	<cfset lastrcqty = 0>
    <cfset lastinvqty = 0>
    <cfset lastcnqty = 0>
    <cfset lastprqty = 0>
    <cfset lastdnqty = 0>
    <cfset lastdoqty = 0>
	<cfset lastcsqty = 0>
	<cfset lastissqty = 0>
	<cfset lastoaiqty = 0>
	<cfset lastoarqty = 0>

    <cfquery name="getrc" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type ="RC" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getrc.sumqty neq "">
        <cfset RCqty = #getrc.sumqty#>
      </cfif>

    <cfquery name="getpr" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "PR" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getpr.sumqty neq "">
        <cfset PRqty = #getpr.sumqty#>
      </cfif>

    <cfquery name="getdo" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "DO" and toinv = "" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getdo.sumqty neq "">
        <cfset DOqty = #getdo.sumqty#>
      </cfif>

    <cfquery name="getinv" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "INV" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getinv.sumqty neq "">
        <cfset INVqty = #getinv.sumqty#>
      </cfif>

    <cfquery name="getcn" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "CN" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getcn.sumqty neq "">
        <cfset CNqty = #getcn.sumqty#>
      </cfif>

    <cfquery name="getdn" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "DN" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getdn.sumqty neq "">
        <cfset DNqty = #getdn.sumqty#>
      </cfif>

	<cfquery name="getcs" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "CS" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getcs.sumqty neq "">
        <cfset CSqty = #getcs.sumqty#>
      </cfif>

	<cfquery name="getiss" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "ISS" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getiss.sumqty neq "">
        <cfset ISSqty = #getiss.sumqty#>
      </cfif>

	<cfquery name="getoai" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "OAI" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getoai.sumqty neq "">
        <cfset OAIqty = #getoai.sumqty#>
      </cfif>

	<cfquery name="getoar" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "OAR" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif getoar.sumqty neq "">
        <cfset OARqty = #getoar.sumqty#>
      </cfif>



	<!--- LAST ITEMBAL --->
	<cfquery name="lastgetrc" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type ="RC" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetrc.sumqty neq "">
        <cfset lastRCqty = #lastgetrc.sumqty#>
      </cfif>

    <cfquery name="lastgetpr" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "PR" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetpr.sumqty neq "">
        <cfset lastPRqty = #lastgetpr.sumqty#>
      </cfif>

    <cfquery name="lastgetdo" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "DO" and toinv = "" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetdo.sumqty neq "">
        <cfset lastDOqty = #lastgetdo.sumqty#>
      </cfif>

    <cfquery name="lastgetinv" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "INV" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetinv.sumqty neq "">
        <cfset lastINVqty = #lastgetinv.sumqty#>
      </cfif>

    <cfquery name="lastgetcn" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "CN" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetcn.sumqty neq "">
        <cfset lastCNqty = #lastgetcn.sumqty#>
      </cfif>

    <cfquery name="lastgetdn" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "DN" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetdn.sumqty neq "">
        <cfset lastDNqty = #lastgetdn.sumqty#>
      </cfif>

	<cfquery name="lastgetcs" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "CS" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetcs.sumqty neq "">
        <cfset lastCSqty = #lastgetcs.sumqty#>
      </cfif>

	<cfquery name="lastgetiss" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "ISS" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetiss.sumqty neq "">
        <cfset lastISSqty = #lastgetiss.sumqty#>
      </cfif>

	<cfquery name="lastgetoai" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "OAI" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetoai.sumqty neq "">
        <cfset lastOAIqty = #lastgetoai.sumqty#>
      </cfif>

	<cfquery name="lastgetoar" datasource="#dts#">
		select sum(qty)as sumqty from ictran where type = "OAR" and category = "#getitem.category#"
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod < '#form.periodfrom#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= "#form.catefrom#" and category <= "#form.cateto#"
		</cfif>
    </cfquery>

      <cfif lastgetoar.sumqty neq "">
        <cfset lastOARqty = #lastgetoar.sumqty#>
      </cfif>

	<cfif getitem.qtybf neq "">
		<cfset itembal = getitem.qtybf>
	</cfif>

	<cfset laststockin = #lastrcqty# + #lastcnqty# + #lastoaiqty#>
    <cfset laststockout = #lastoarqty# + #lastdoqty# + #lastinvqty# + #lastdnqty# + #lastcsqty# + #lastprqty# + #lastissqty#>
	<cfset lastbalonhand = #itembal# + #laststockin# - #laststockout#>

	<!--- END LAST ITEMBAL --->

	<cfif getitem.ucost neq "">
		<cfset fixedcost = getitem.ucost>
	</cfif>

    <cfset stockin = #rcqty# + #cnqty# + #oaiqty#>
    <cfset stockout = #oarqty# + #doqty# + #invqty# + #dnqty# + #csqty# + #prqty# + #issqty#>
    <cfset balonhand = #lastbalonhand# + #stockin# - #stockout#>


	<cfif getgeneral.cost eq 'month'>

		<cfquery datasource="#dts#" name="rcpricenow">
			select sum(amt)as sumamt,sum(qty) as qty from ictran where category = "#getitem.category#" <cfif form.periodfrom neq "" and form.periodto neq ""> and fperiod <= '#form.periodto#'</cfif> and type = 'RC'
		</cfquery>
		<cfif rcpricenow.sumamt neq "">
			<cfset rcpricenowamt = rcpricenow.sumamt>
		<cfelse>
			<cfset rcpricenowamt = 0>
		</cfif>
		<cfif rcpricenow.qty neq "">
			<cfset rcpricenowqty = rcpricenow.qty>
		<cfelse>
			<cfset rcpricenowqty = 0>
		</cfif>

		<cfquery datasource="#dts#" name="prpricenow">
			select sum(amt)as sumamt,sum(qty) as qty from ictran where category = "#getitem.category#" <cfif form.periodfrom neq "" and form.periodto neq ""> and fperiod <= '#form.periodto#'</cfif><!--- and month(wos_date) = '#monthnow#' ---> and type = 'PR'
		</cfquery>
		<cfif prpricenow.sumamt neq "">
			<cfset prpricenowamt = prpricenow.sumamt>
		<cfelse>
			<cfset prpricenowamt = 0>
		</cfif>
		<cfif prpricenow.qty neq "">
			<cfset prpricenowqty = prpricenow.qty>
		<cfelse>
			<cfset prpricenowqty = 0>
		</cfif>

		<cfset up =  (itembal * fixedcost)  + rcpricenowamt - prpricenowamt>
		<cfset down = itembal + rcpricenowqty - prpricenowqty>

		<cfif down neq 0>
			<cfset xucost = up/ down>
			<cfset xucost = numberformat(xucost,#stDecl_UPrice#)>
		<cfelse>
			<cfset xucost = numberformat(xucost,#stDecl_UPrice#)>
		</cfif>

	<cfelseif getgeneral.cost eq 'moving'>
		<cfset getinvqty = 0>
		<cfset getprqty = 0>
		<cfset getcnqty = 0>

		<cfset xucost = numberformat(fixedcost,#stDecl_UPrice#)>

		<cfquery datasource="#dts#" name="get1stRC">
			select refno,type,wos_date from ictran where category = "#getitem.category#" and type = 'RC'
			<!--- <cfif form.periodfrom neq "" and form.periodto neq "">and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'</cfif> --->
			order by wos_date
		</cfquery>


		<cfloop query="get1stRC" endrow="1">

			<cfquery name="getinv" datasource="#dts#">
				select sum(amt)as sumamt, sum(qty) as qty, refno, type from ictran where category = "#getitem.category#" and type = 'INV' and wos_date < #get1stRC.wos_date#
				<!--- <cfif form.periodfrom neq "" and form.periodto neq "">and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'</cfif>  --->
				group by itemno
			</cfquery>
			<cfif getinv.sumamt neq "">
				<cfset getinvamt = getinv.sumamt>
			<cfelse>
				<cfset getinvamt = 0>
			</cfif>

			<cfif getinv.qty neq "">
				<cfset getinvqty = getinv.qty>
			<cfelse>
				<cfset getinvqty = 0>
			</cfif>

			<cfquery name="getpr" datasource="#dts#">
				select sum(amt)as sumamt, sum(qty) as qty, refno, type from ictran where category = "#getitem.category#" and type = 'PR' and wos_date < #get1stRC.wos_date#
				<cfif form.periodfrom neq "" and form.periodto neq "">and fperiod <= '#form.periodto#'</cfif>
				group by itemno
			</cfquery>
			<cfif getpr.sumamt neq "">
				<cfset getpramt = getpr.sumamt>
			<cfelse>
				<cfset getpramt = 0>
			</cfif>

			<cfif getpr.qty neq "">
				<cfset getprqty = getpr.qty>
			<cfelse>
				<cfset getprqty = 0>
			</cfif>

			<cfquery name="getcn" datasource="#dts#">
				select sum(amt)as sumamt, sum(qty) as qty, refno, type from ictran where category = "#getitem.category#" and type = 'PR' and wos_date < #get1stRC.wos_date#
				<cfif form.periodfrom neq "" and form.periodto neq "">and fperiod <= '#form.periodto#'</cfif>
				group by itemno
			</cfquery>
			<cfif getcn.sumamt neq "">
				<cfset getcnamt = getcn.sumamt>
			<cfelse>
				<cfset getcnamt = 0>
			</cfif>

			<cfif getcn.qty neq "">
				<cfset getcnqty = getcn.qty>
			<cfelse>
				<cfset getcnqty = 0>
			</cfif>

		</cfloop>


		<cfquery datasource="#dts#" name="getrcprice">
			select sum(amt)as sumamt,sum(qty) as qty from ictran where category = "#getitem.category#" and type = 'RC'
			<cfif form.periodfrom neq "" and form.periodto neq "">and fperiod <= '#form.periodto#'</cfif>
		</cfquery>
		<cfif getrcprice.sumamt neq "">
			<cfset getrcpriceamt = getrcprice.sumamt>
		<cfelse>
			<cfset getrcpriceamt = 0>
		</cfif>
		<cfif getrcprice.qty neq "">
			<cfset getrcpriceqty = getrcprice.qty>
		<cfelse>
			<cfset getrcpriceqty = 0>
		</cfif>

		<cfquery datasource="#dts#" name="getprprice">
			select sum(amt)as sumamt,sum(qty) as qty from ictran where category = "#getitem.category#" and type = 'PR'
			<cfif form.periodfrom neq "" and form.periodto neq "">and fperiod <= '#form.periodto#'</cfif>
		</cfquery>
		<cfif getprprice.sumamt neq "">
			<cfset getprpriceamt = getprprice.sumamt>
		<cfelse>
			<cfset getprpriceamt = 0>
		</cfif>
		<cfif getprprice.qty neq "">
			<cfset getprpriceqty = getprprice.qty>
		<cfelse>
			<cfset getprpriceqty = 0>
		</cfif>


		<!--- <cfoutput>#itembal# #getinvqty# cost #xucost#<br></cfoutput> --->
		<cfset up = ((itembal - getinvqty - getprqty + getcnqty) * xucost) + getrcpriceamt - getprpriceamt>
		<cfset down = itembal - getinvqty - getprqty + getcnqty + getrcpriceqty - getprpriceqty>

		<cfif down neq 0>
			<cfset xucost = up/ down>
		<cfelse>
			<cfset xucost = 0>
		</cfif>

		<cfset xucost = numberformat(xucost,#stDecl_UPrice#)>

	<cfelse>

		<cfquery datasource="#dts#" name="getprice">
			select sum(ucost)as ucost from icitem where category = "#getitem.category#"
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and category >= "#form.catefrom#" and category <= "#form.cateto#"
			</cfif>
		</cfquery>
		<cfif getprice.ucost neq "">
			<cfset xucost = #getprice.ucost#>
			<cfset xucost = numberformat(xucost,#stDecl_UPrice#)>

		</cfif>
	</cfif>

	<cfquery datasource="#dts#" name="getdesp">
		select desp from iccate where cate = "#getitem.category#"
	</cfquery>
	<cfset stkval = #val(balonhand)# * #val(xucost)#>

    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#i#</font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#category# - #getdesp.desp#</font></div></td><cfif getpin2.h42A0 eq 'T'>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(val(xucost), stDecl_UPrice)#</font></div></td></cfif>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#lastbalonhand#</font></div></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#stockin#</font></div></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#stockout#</font></div></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#balonhand#</font></div></td>
      <cfif getpin2.h42A0 eq 'T'>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(stkval,"___.__")#</font></div></td></cfif>
    </tr>
    <cfset i = incrementvalue(#i#)>
    <cfset totalbf=totalbf +lastbalonhand>
    <cfset totalin=totalin+stockin>
    <cfset totalout=totalout+stockout>
    <cfset totalbal=totalbal+balonhand>
    <cfset totalstkval=totalstkval+stkval>
  </cfoutput>
  <cfoutput>
  <tr>
  <td colspan="100%"><hr>
  </td></tr>
  <tr>
  <td></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Total :</font></div></td>
  <cfif getpin2.h42A0 eq 'T'><td></td></cfif>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbf#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalin#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalout#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbal#</font></div></td>
   <cfif getpin2.h42A0 eq 'T'>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalstkval#</font></div></td>
  </cfif>
  </tr>
  </cfoutput>
</table>
<cfelseif getgeneral.cost eq "lifo">
	<cfquery name="getitem" datasource="#dts#">
		select itemno,desp,wos_group,unit,category, sum(qtybf) as qtybf from icitem where itemno <> '' and category <>''
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= '#form.catefrom#' and category <= '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
		</cfif>
		group by category order by category
	</cfquery>

	<table width="90%" border="0" align="center" cellpadding="3" cellspacing="0">
		<tr>
			<td colspan="4"><font size="2" face="Times New Roman, Times, serif">
			<cfif getgeneral.compro neq "">
			  #getgeneral.compro#
			</cfif>
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="10"><hr></td>
		</tr>
	  	<tr>
	  		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">ITEM DESCRIPTION</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">B/F</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
            <cfif getpin2.h42A0 eq 'T'>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">STK VAL</font></div></td>
            </cfif>
	  	</tr>
	  	<tr>
			<td colspan="10"><hr></td>
		</tr>
	<cfloop query="getitem">
		<cfquery name="check" datasource="#dts#">
			select a.itemno,b.itemno from fifoopq a, icitem b
			where a.itemno = b.itemno and b.category = '#getitem.category#'
		</cfquery>

		<cfif getitem.qtybf neq "">
			<cfset bfqty = #getitem.qtybf#>
		<cfelse>
			<cfset bfqty = 0>
		</cfif>

		<cfquery name="getin" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#' and (type = 'RC' or type = 'CN' or type = 'OAI')
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>

		<cfif getin.qty neq "">
			<cfset inqty = #getin.qty#>
		<cfelse>
			<cfset inqty = 0>
		</cfif>

		<cfquery name="getdo" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#' and type = 'DO' and toinv = ''
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>

		<cfif getdo.qty neq "">
			<cfset doqty = #getdo.qty#>
		<cfelse>
			<cfset doqty = 0>
		</cfif>

		<cfquery name="getout" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#' and (type = 'INV' or type = 'PR' or type = 'DN' or type = 'CS' or type = 'ISS' or type = 'OAR' or type = 'CT')
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>
		<cfif getout.qty neq "">
			<cfset outqty = #getout.qty#>
		<cfelse>
			<cfset outqty = 0>
		</cfif>

		<cfset ttoutqty = outqty + doqty>

		<cfset balqty =  bfqty + inqty - ttoutqty>

		<cfset fifoqty = 0>
		<cfset ttnewffstkval =0>

		<cfquery name="getrc" datasource="#dts#">
			select qty, amt, amt_bil, price, price_bil from ictran where category = '#getitem.category#' and type = 'RC'
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			order by trdatetime desc
		</cfquery>

		<cfif getrc.recordcount gt 0 and check.recordcount gt 0>
			<cfset totalrcqty = 0>
			<cfset cnt = 0>
			<cfloop query="getrc">
				<cfset cnt = cnt + 1>
				<cfif getrc.qty neq "">
					<cfset rcqty = getrc.qty>
				<cfelse>
					<cfset rcqty = 0>
				</cfif>
				<cfset totalrcqty = totalrcqty + rcqty>
				<cfif totalrcqty gte ttoutqty>
					<cfset minusqty = totalrcqty - ttoutqty>
					<cfif minusqty gt 0>
						<cfset stkval = minusqty * getrc.price>
					<cfelse>
						<cfset stkval = 0>
					</cfif>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif totalrcqty gte ttoutqty>
				<cfset cnt = cnt + 1> <!--- next record --->
				<cfset newstkval = 0>
				<cfoutput query="getrc" startrow="#cnt#">
					<cfset newstkval = newstkval + getrc.amt>
				</cfoutput>
				<cfloop index="i" from="11" to="50">
					<cfset ffq = "sum(a.ffq"&"#i#)">
					<cfset ffc = "sum(a.ffc"&"#i#)">
					<cfquery name="getfifoopq" datasource="#dts#">
						select #ffq# as xffq, #ffc# as xffc from fifoopq a, icitem b where a.itemno = b.itemno and b.category = '#getitem.category#'
					</cfquery>

					<cfset newffstkval = getfifoopq.xffq * getfifoopq.xffc>
					<cfset ttnewffstkval = ttnewffstkval + newffstkval>
				</cfloop>

				<cfset totalstkval = stkval + newstkval + ttnewffstkval>

			<cfelse> <!--- rc less than out --->
				<cfset ttnewffstkval = 0>
				<cfset fifoqty = totalrcqty>
				<cfloop index="i" from="11" to="50">
					<cfset ffq = "sum(a.ffq"&"#i#)">
					<cfset ffc = "sum(a.ffc"&"#i#)">
					<cfquery name="getfifoopq" datasource="#dts#">
						select #ffq# as xffq, #ffc# as xffc from fifoopq a, icitem b where a.itemno = b.itemno and b.category = '#getitem.category#'
					</cfquery>

					<cfset fifoqty = fifoqty + getfifoopq.xffq>
					<cfset newffstkval = getfifoopq.xffq * getfifoopq.xffc>
					<cfset ttnewffstkval = ttnewffstkval + newffstkval>

					<cfif fifoqty gte ttoutqty>
						<cfset minusfifoqty = fifoqty - ttoutqty>
						<cfif minusfifoqty gt 0>
							<cfset stkvalff = minusfifoqty * getfifoopq.xffc>
						<cfelse>
							<cfset stkvalff = 0>
						</cfif>
						<cfset fifocnt = #i# + 1>
						<cfbreak>
					</cfif>
				</cfloop>

				<cfif fifoqty gte ttoutqty>
					<cfset ttnewffstkval = 0>
					<cfloop index="i" from="#fifocnt#" to="50">
						<cfset ffq = "sum(a.ffq"&"#i#)">
						<cfset ffc = "sum(a.ffc"&"#i#)">
						<cfquery name="getfifoopq2" datasource="#dts#">
							select #ffq# as xffq, #ffc# as xffc from fifoopq a, icitem b where a.itemno = b.itemno and b.category = '#getitem.category#'
						</cfquery>

						<cfset newffstkval = getfifoopq2.xffq * getfifoopq2.xffc>
						<cfset ttnewffstkval = ttnewffstkval + newffstkval>
					</cfloop>
				</cfif>
				<cfset totalstkval = stkvalff + ttnewffstkval>
			</cfif>

		<cfelseif getrc.recordcount eq 0 and check.recordcount gt 0>

			<cfset ttnewffstkval = 0>

			<cfloop index="i" from="11" to="50">
				<cfset ffq = "sum(a.ffq"&"#i#)">
				<cfset ffc = "sum(a.ffc"&"#i#)">
				<cfquery name="getfifoopq2" datasource="#dts#">
					select #ffq# as xffq, #ffc# as xffc from fifoopq a, icitem b where a.itemno = b.itemno and b.category= '#getitem.category#'
				</cfquery>

				<cfset newffstkval = getfifoopq2.xffq * getfifoopq2.xffc>
				<cfset ttnewffstkval = ttnewffstkval + newffstkval>
			</cfloop>
			<cfset totalstkval = ttnewffstkval>

		<cfelse>

			<cfset totalrcqty = 0>
			<cfset cnt = 0>
			<cfset stkval = 0>
			<cfset newstkval = 0>
			<cfif getrc.recordcount gt 0>
				<cfloop query="getrc">
					<cfset cnt = cnt + 1>
					<cfif getrc.qty neq "">
						<cfset rcqty = getrc.qty>
					<cfelse>
						<cfset rcqty = 0>
					</cfif>

					<cfset totalrcqty = totalrcqty + rcqty>
					<cfif totalrcqty gte ttoutqty>
						<cfset minusqty = totalrcqty - ttoutqty>
						<cfif minusqty gt 0>
							<cfset stkval = minusqty * getrc.price>
						<cfelse>
							<cfset stkval = 0>
						</cfif>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif getrc.recordcount gt cnt>
					<cfset cnt = cnt + 1> <!--- next record --->
					<cfset newstkval = 0>
					<cfoutput query="getrc" startrow="#cnt#">

						<cfset newstkval = newstkval + getrc.amt>
					</cfoutput>
				<cfelse>
					<cfset newstkval = 0>
				</cfif>
			</cfif>
			<cfset totalstkval = stkval + newstkval>
		</cfif>

	  <cfoutput>
	  <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#itemno#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#desp#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#qtybf#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#inqty#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#ttoutqty#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#balqty#</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalstkval,",___.__")#</font></div></td></cfif>
	  </tr>
      <cfset totalbf=totalbf +lastbalonhand>
    <cfset totalin=totalin+stockin>
    <cfset totalout=totalout+stockout>
    <cfset totalbal=totalbal+balonhand>
    <cfset totalstkval=totalstkval+stkval>
	  </cfoutput>
	 </cfloop>
     <cfoutput>
  <tr>
  <td colspan="100%"><hr>
  </td></tr>
  <tr>
  <td></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Total :</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbf#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalin#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalout#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbal#</font></div></td>
   <cfif getpin2.h42A0 eq 'T'>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalstkval#</font></div></td>
  </cfif>
  </tr>
  </cfoutput>
	</table>

<cfelseif getgeneral.cost eq "fifo">
	<cfquery name="getitem" datasource="#dts#">
		select itemno,desp,wos_group,unit, sum(qtybf) as qtybf from icitem where itemno <> '' and category <>''
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category >= '#form.catefrom#' and category <= '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
		</cfif>
		group by category order by category
	</cfquery>

	<table width="90%" border="0" align="center" cellpadding="3" cellspacing="0">
		<cfoutput>
		<tr>
			<td colspan="4"><font size="2" face="Times New Roman, Times, serif">
			<cfif getgeneral.compro neq "">
			  #getgeneral.compro#
			</cfif>
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="10"><hr></td>
		</tr>
	  	<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CATEGORY</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CATEGORY DESCRIPTION</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">B/F</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
            <cfif getpin2.h42A0 eq 'T'>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">STK VAL</font></div></td>
            </cfif>
	   </tr>
	  	<tr>
			<td colspan="10"><hr></td>
		</tr>
	<cfloop query="getitem">
		<cfquery name="check" datasource="#dts#">
			select a.itemno,b.itemno from fifoopq a, icitem b
			where a.itemno = b.itemno and b.category = '#getitem.category#'
		</cfquery>



		<cfif getitem.qtybf neq "">
			<cfset bfqty = #getitem.qtybf#>
		<cfelse>
			<cfset bfqty = 0>
		</cfif>

		<cfquery name="getin" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#'
			and (type = 'RC' or type = 'CN' or type = 'OAI')
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>

		<cfif getin.qty neq "">
			<cfset inqty = #getin.qty#>
		<cfelse>
			<cfset inqty = 0>
		</cfif>

		<cfquery name="getdo" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#' and type = 'DO' and toinv = ''
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>

		<cfif getdo.qty neq "">
			<cfset doqty = #getdo.qty#>
		<cfelse>
			<cfset doqty = 0>
		</cfif>

		<cfquery name="getout" datasource="#dts#">
			select sum(qty) as qty from ictran where category = '#getitem.category#' and (type = 'INV' or type = 'PR' or type = 'DN' or type = 'CS' or type = 'ISS' or type = 'OAR')
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
		</cfquery>
		<cfif getout.qty neq "">
			<cfset outqty = #getout.qty#>
		<cfelse>
			<cfset outqty = 0>
		</cfif>

		<cfset ttoutqty = outqty + doqty>

		<cfset balqty =  bfqty + inqty - ttoutqty>

		<cfset fifoqty = 0>
		<cfset ttnewffstkval =0>

		<cfif bfqty neq 0 and check.recordcount gt 0>

			<cfloop index="i" from="50" to="11" step="-1">
				<cfset ffq = "sum(a.ffq"&"#i#)">
				<cfset ffc = "sum(a.ffc"&"#i#)">
				<cfquery name="getfifoopq" datasource="#dts#">
					select #ffq# as xffq, #ffc# as xffc from fifoopq a,icitem b where a.itemno=b.itemno and
					b.category = '#getitem.category#'
				</cfquery>
				<cfif getfifoopq.recordcount gt 0>
					<cfset fifoqty = fifoqty + getfifoopq.xffq>
					<cfset newffstkval = getfifoopq.xffq * getfifoopq.xffc>
					<cfset ttnewffstkval = ttnewffstkval + newffstkval>

					<cfif fifoqty gte ttoutqty>
						<cfset minusfifoqty = fifoqty - ttoutqty>
						<cfif minusfifoqty gt 0>
							<cfset stkvalff = minusfifoqty * getfifoopq.xffc>
						<cfelse>
							<cfset stkvalff = 0>
						</cfif>
						<cfset fifocnt = #i# - 1>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
			<cfif fifoqty gte ttoutqty>
				<cfset ttnewffstkval = 0>

				<cfloop index="i" from="#fifocnt#" to="11" step="-1">
					<cfset ffq = "sum(a.ffq"&"#i#)">
					<cfset ffc = "sum(a.ffc"&"#i#)">
					<cfquery name="getfifoopq2" datasource="#dts#">
						select #ffq# as xffq, #ffc# as xffc from fifoopq a, icitem b
						where a.itemno = b.itemno and b.category = '#getitem.category#'
					</cfquery>

					<cfset newffstkval = getfifoopq2.xffq * getfifoopq2.xffc>
					<cfset ttnewffstkval = ttnewffstkval + newffstkval>
				</cfloop>
				<cfquery name="getallrc" datasource="#dts#">
					select sum(amt) as sumamt, sum(amt_bil)as sumamtbil,sum(price) as price, sum(price_bil)as price_bil from ictran where category = '#getitem.category#' and type = 'RC'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					group by itemno
				</cfquery>
				<cfquery name="getrc" datasource="#dts#">
					select qty, amt, amt_bil, price, price_bil from ictran where category = '#getitem.category#' and type = 'RC'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					order by trdatetime
				</cfquery>

				<cfif getallrc.sumamt eq "">
					<cfset sumamt = 0>
				<cfelse>
					<cfset sumamt = getallrc.sumamt>
				</cfif>

				<cfset totalstkval = stkvalff + ttnewffstkval + sumamt>
			<cfelse>
				<cfset totalrcqty = #fifoqty#>
				<cfset stkval = 0>
				<cfquery name="getrc" datasource="#dts#">
					select qty, amt, amt_bil, price, price_bil from ictran where category = '#getitem.category#' and type = 'RC'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					order by trdatetime
				</cfquery>
				<cfset cnt = 0>
				<cfloop query="getrc">
					<cfset cnt = cnt + 1>
					<cfif getrc.qty neq "">
						<cfset rcqty = getrc.qty>
					<cfelse>
						<cfset rcqty = 0>
					</cfif>

					<cfset totalrcqty = totalrcqty + rcqty>
					<cfif totalrcqty gte ttoutqty>
						<cfset minusqty = totalrcqty - ttoutqty>
						<cfif minusqty gt 0>
							<cfset stkval = minusqty * getrc.price>
						<cfelse>
							<cfset stkval = 0>
						</cfif>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif getrc.recordcount gt cnt>
					<cfset cnt = cnt + 1> <!--- next record --->
					<cfset newstkval = 0>
					<cfoutput query="getrc" startrow="#cnt#">

						<cfset newstkval = newstkval + getrc.amt>
					</cfoutput>
				<cfelse>
					<cfset newstkval = 0>
				</cfif>
				<cfset totalstkval = stkval + newstkval>
			</cfif>
		<cfelse>
			<cfset totalrcqty = 0>
			<cfset stkval = 0>
			<cfquery name="getrc" datasource="#dts#">
				select qty, amt, amt_bil, price, price_bil from ictran where category = '#getitem.category#' and type = 'RC'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				order by trdatetime
			</cfquery>
			<cfset cnt = 0>
			<cfloop query="getrc">
				<cfset cnt = cnt + 1>
				<cfif getrc.qty neq "">
					<cfset rcqty = getrc.qty>
				<cfelse>
					<cfset rcqty = 0>
				</cfif>

				<cfset totalrcqty = totalrcqty + rcqty>
				<cfif totalrcqty gte ttoutqty>
					<cfset minusqty = totalrcqty - ttoutqty>
					<cfif minusqty gt 0>
						<cfset stkval = minusqty * getrc.price>
					<cfelse>
						<cfset stkval = 0>
					</cfif>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif getrc.recordcount gt cnt>
				<cfset cnt = cnt + 1> <!--- next record --->
				<cfset newstkval = 0>
				<cfoutput query="getrc" startrow="#cnt#">

					<cfset newstkval = newstkval + getrc.amt>
				</cfoutput>
			<cfelse>
				<cfset newstkval = 0>
			</cfif>
			<cfset totalstkval = stkval + newstkval>
		</cfif>

	  <cfoutput>
	  	<cfquery name="getdesp" datasource="#dts#">
			select desp from iccate where cate = '#getitem.category#'
		</cfquery>
	  <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#category#</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdesp.desp#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#qtybf#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#inqty#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#ttoutqty#</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#balqty#</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalstkval,",_.__")#</font></div></td>
        </cfif>
	  </tr>
      <cfset totalbf=totalbf +lastbalonhand>
    <cfset totalin=totalin+stockin>
    <cfset totalout=totalout+stockout>
    <cfset totalbal=totalbal+balonhand>
    <cfset totalstkval=totalstkval+stkval>
	  </cfoutput>
	 </cfloop>
     <cfoutput>
  <tr>
  <td colspan="100%"><hr>
  </td></tr>
  <tr>
  <td></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Total :</font></div></td>
  <cfif getpin2.h42A0 eq 'T'><td></td></cfif>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbf#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalin#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalout#</font></div></td>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalbal#</font></div></td>
   <cfif getpin2.h42A0 eq 'T'>
  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalstkval#</font></div></td>
  </cfif>
  </tr>
  </cfoutput>
	</table>
</cfif>
<cfif getitem.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
</cfif>
<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>