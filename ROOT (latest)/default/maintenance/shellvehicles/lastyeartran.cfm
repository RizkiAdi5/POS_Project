<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

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

<cfset grandstockamt=0>
<cfset grandaddonamount=0>
<cfset granddiscountamount=0>
<cfset grandtotalamount=0>
<cfset totalqty=0>

	<html>
	<head>
	<title>Vehicle Service History Report</title>
	<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>

	<body>


	<cfquery name="getvehicle" datasource="#dts#">
		SELECT * FROM shelllastyeartran 
        where vehicle='#trim(url.entryno)#'
            group by vehicle
            order by concat(right(wos_date,4),lpad(substring_index(substring_index(wos_date,'/',2),'/',-1),2,'0'),lpad(substring_index(wos_date,'/',1),2,'0')) desc
	</cfquery>
	
	<cfoutput>
    <cfset columncount = "100%">
    <cfset rowcom = 7>
    <cfset comcom = 3>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="left"><font size="3" face="Times New Roman, Times, serif"><strong>Vehicle Service History Report</strong></font></div></td>
		</tr>
        		<tr>
			<td colspan="100%"><font size="2" face="Times New Roman, Times, serif">Printed by : #HUserID#</font></td></tr>
		<tr><td colspan="100%"><div align="left"><font size="2" face="Times New Roman, Times, serif">Date printed : #dateformat(now(),"dd/mm/yyyy")#</font></div></td></tr>
        <tr>
			<td colspan="100%"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		</tr>
		<tr>
			<td colspan="#columncount#"><hr></td>
		</tr>
        
        <cfloop query="getvehicle">
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Vehicle No :</strong></font></div></td>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.vehicle#</font></div></td>
            <td colspan="2"></td>
			
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Customer :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.custno#</font></div></td>
            <td colspan="2"></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Customer Phone No.</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.tel#</font></div></td>
            <td colspan="2"></td>
          
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Owner :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.contact#</font></div></td>
            <td colspan="2"></td>
            </tr>
            
		<tr>
			<td colspan="#columncount#"><hr></td>
		</tr>
        
			<cfquery name="getservdate" datasource="#dts#">
				SELECT * FROM shelllastyeartran 
                where 0=0
			and vehicle ='#getvehicle.vehicle#'
            group by refno
            order by concat(right(wos_date,4),lpad(substring_index(substring_index(wos_date,'/',2),'/',-1),2,'0'),lpad(substring_index(wos_date,'/',1),2,'0')) desc
			</cfquery>

			<cfloop query="getservdate">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Date :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getservdate.wos_date#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Reference No. :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getservdate.refno#</font></div></td>
                 </tr>
				 
            
            <cfquery name="getitem" datasource="#dts#">
				
                SELECT * FROM shelllastyeartran 
                where 0=0
				and refno ='#getservdate.refno#'
                order by concat(right(wos_date,4),lpad(substring_index(substring_index(wos_date,'/',2),'/',-1),2,'0'),lpad(substring_index(wos_date,'/',1),2,'0')) desc
                </cfquery>
            
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Item No.</strong></font></div></td>
             <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Description</strong></font></div></td>

               <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Quantity</strong></font></div></td>
               <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Price</strong></font></div></td>
                <td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Amount</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Add on Amount</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Discount Amount</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Total Amount</strong></font></div></td>
            </tr>
            
            <cfloop query="getitem">
            
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.stockcode#</font></div></td>
            <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.stockdesp#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qty#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.stockprice,',_.__')#</font></div></td>
             <td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.stockamt,',_.__')#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.addonamount,',_.__')#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.discountamount,',_.__')#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.totalamount,',_.__')#</font></div></td>
             
                 </tr>
            <cfset grandstockamt=grandstockamt+val(getitem.stockamt)>
			<cfset grandaddonamount=grandaddonamount+val(getitem.addonamount)>
            <cfset granddiscountamount=granddiscountamount+val(getitem.discountamount)>
            <cfset grandtotalamount=grandtotalamount+val(getitem.totalamount)>     
            <cfset totalqty=totalqty+val(getitem.qty)>     
				 <cfflush>
			</cfloop>
            <tr>
				<td colspan="#columncount#"><hr></td>
			</tr>
            
            <tr>
            <td></td>
            <td colspan="3"><div align="right"><font size="2" face="Times New Roman, Times, serif"><b>Total :</b></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalqty#</font></div></td>
            <td></td>
            <td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandstockamt,',_.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandaddonamount,',_.__')#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(granddiscountamount,',_.__')#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandtotalamount,',_.__')#</font></div></td>
             
                 </tr>
            
            <tr>
				<td colspan="#columncount#"><hr></td>
			</tr>
            <cfflush>
			</cfloop>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
			<cfflush>
		</cfloop>
		
	  </table>
	</cfoutput>

	<br>
	<br>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
	<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
