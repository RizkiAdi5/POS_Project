<html>
<head>
<title>No Location Report</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

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

<cfset str=arraynew(1)>

<cfif isdefined("form.purchasereceive")>
	<cfset str[1]="RC">
<cfelse>
	<cfset str[1]=''>
</cfif>
<cfif isdefined("form.purchasereturn")>
	<cfset str[2]="PR">
<cfelse>
	<cfset str[2]=''>
</cfif>
<cfif isdefined("form.invoice")>
	<cfset str[3]="INV">
<cfelse>
	<cfset str[3]=''>
</cfif>
<cfif isdefined("form.cashsales")>
	<cfset str[4]="CS">
<cfelse>
	<cfset str[4]=''>
</cfif>
<cfif isdefined("form.debitnote")>
	<cfset str[5]="DN">
<cfelse>
	<cfset str[5]=''>
</cfif>
<cfif isdefined("form.creditnote")>
	<cfset str[6]="CN">
<cfelse>
	<cfset str[6]=''>
</cfif>
<cfif isdefined("form.deliveryorder")>
	<cfset str[7]="DO">
<cfelse>
	<cfset str[7]=''>
</cfif>
<cfif isdefined("form.salesorder")>
	<cfset str[8]="SO">
<cfelse>
	<cfset str[8]=''>
</cfif>
<cfif isdefined("form.purchaseorder")>
	<cfset str[9]="PO">
<cfelse>
	<cfset str[9]=''>
</cfif>
<cfif isdefined("form.quotation")>
	<cfset str[10]="QUO">
<cfelse>
	<cfset str[10]=''>
</cfif>
<cfif isdefined("form.adjustmentincrease")>
	<cfset str[11]="OAI">
<cfelse>
	<cfset str[11]=''>
</cfif>
<cfif isdefined("form.adjustmentreduce")>
	<cfset str[12]="OAR">
<cfelse>
	<cfset str[12]=''>
</cfif>
<cfif isdefined("form.issue")>
	<cfset str[13]="ISS">
<cfelse>
	<cfset str[13]=''>
</cfif>

<cfset arraysort(str,"textnocase","desc")>

<cfset totalqty = 0>
<cfset ftotal = 0>
<cfset total= 0>
<cfset dftotal = 0>
<cfset dtotal = 0>
<cfset tftotal = 0>
<cfset ttotal = 0>

<body>
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="data">
	<tr>
		<td colspan="100%"><div align="center"><font size="3" face="Times New Roman,Times,serif"><strong>Print No Agent Report</strong></font></div></td>
	</tr>
    <cfif form.periodfrom neq "" and form.periodto neq "">
		<tr> 
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<tr> 
      		<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
    	</tr>
	</cfif>
    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
        <tr> 
          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">CUST: #form.custfrom# - #form.custto#</font></div></td>
        </tr>
    </cfif>
    <cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
        <tr> 
          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">SUPP: #form.suppfrom# - #form.suppto#</font></div></td>
        </tr>
    </cfif>
    
    <cfif form.projectfrom neq "" and form.projectto neq "">
        <tr> 
          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">PROJECT NO: #form.projectfrom# - #form.projectto#</font></div></td>
        </tr>
    </cfif>
	<cfif form.reffrom neq "" and form.refto neq "">
        <tr> 
          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman,Times,serif">REF NO: #form.reffrom# - #form.refto#</font></div></td>
        </tr>
    </cfif>
	
    <tr> 
      	<td colspan="4"><font size="2" face="Times New Roman,Times,serif">#getgeneral.compro#</font></td>
      	<td colspan="8"><div align="right"><font size="2" face="Times New Roman,Times,serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr> 
      	<td colspan="100%"><hr></td>
    </tr>
    <tr>
      	<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>Type</strong></font></div></td>
	  	<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>Ref No</strong></font></div></td>
      	<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>Date</strong></font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>Period</strong></font></div></td>
		
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif"><strong>Amount</strong></font></div></td>
		<td colspan="3"><div align="right"><font size="2" face="Times New Roman,Times,serif"><strong>Agent</strong></font></div></td>

    </tr>
    <tr> 
      	<td colspan="100%"><hr></td>
    </tr>

	<cfquery name="gettran" datasource="#dts#">
		select * from artran where 
		(void='' or void is null) and 
		(<cfloop index="a" from="1" to="#arraylen(str)#">
			<cfif str[a] neq "">
				type='#str[a]#' <cfif a neq 13 and str[a+1] neq ''>or</cfif>
			</cfif>
		 </cfloop>) 
		 <cfif form.reffrom neq "" and form.refto neq "">
		 	and refno between '#form.reffrom#' and '#form.refto#' 
		 </cfif>
		 <cfif (trim(form.custfrom) neq "" and trim(form.custto) neq "") and (trim(form.suppfrom) eq "" and trim(form.suppto) eq "")>
		 	and custno between '#form.custfrom#' and '#form.custto#' 
		 <cfelseif (trim(form.suppfrom) neq "" and trim(form.suppto) neq "") and (trim(form.custfrom) eq "" and trim(form.custto) eq "")>
			 and custno between '#form.suppfrom#' and '#form.suppto#'
		 </cfif>
		 
         <cfif form.projectfrom neq "" and form.projectto neq "">
		 	and source between '#form.projectfrom#' and '#form.projectto#' 
		 </cfif>
		 <cfif form.periodfrom neq "" and form.periodto neq "">
		 	and fperiod between '#form.periodfrom#' and '#form.periodto#'
		 </cfif>
		 <cfif form.datefrom neq "" and form.dateto neq "">
		 	and wos_date between '#ndatefrom#' and '#ndateto#'
		 </cfif>
          and (agenno ='' or agenno is null)
          
		 order by type,refno,wos_date
	</cfquery>
	
	<cfloop query="gettran">
	
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    <td><div align="left"><font  face="Times New Roman,Times,serif">#gettran.type#</font></div></td>
    <td><div align="left"><font  face="Times New Roman,Times,serif">#gettran.refno#</font></div></td>
    <td><div align="left"><font  face="Times New Roman,Times,serif">#dateformat(gettran.wos_date,'DD/MM/YYYY')#</font></div></td>
    <td><div align="left"><font  face="Times New Roman,Times,serif">#gettran.fperiod#</font></div></td>
    <td><div align="right"><font  face="Times New Roman,Times,serif">#numberformat(gettran.grand,',_.__')#</font></div></td>
    <td><div align="right"><font  face="Times New Roman,Times,serif">#gettran.agenno#</font></div></td>
    </tr>
    
		<tr><td><br></td></tr>
	</cfloop>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
	
</table>

</cfoutput>

<cfif gettran.recordcount eq 0>
	<h3 style="color:red">Sorry, No records were found.</h3>
</cfif>

<br><br>

<div align="right">
	<font  face="Arial,Helvetica,sans-serif">
		<a href="javascript:print()" class="noprint"><u>Print</u></a>
	</font>
</div>

<p class="noprint">
	<font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font>
</p>

</body>
</html>