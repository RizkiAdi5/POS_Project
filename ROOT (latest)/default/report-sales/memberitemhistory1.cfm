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


	<html>
	<head>
	<title>Member Item Report</title>
	<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>

	<body>


	<cfquery name="getmember" datasource="#dts#">
		SELECT driverno,name,add1,add2,add3,icno,contact FROM driver 
        where 0=0
			and driverno = '#form.memberfrom#'
        order by driverno
	</cfquery>
	
	<cfoutput>
    <cfset columncount = "100%">
    <cfset rowcom = 7>
    <cfset comcom = 3>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="left"><font size="3" face="Times New Roman, Times, serif"><strong>Member Item History Report</strong></font></div></td>
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
        
        <cfloop query="getmember">
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Member No :</strong></font></div></td>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.driverno#</font></div></td>
            <td colspan="2"></td>
			
            </tr>
            <tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Name :</strong></font></div></td>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.name#</font></div></td>
            <td colspan="2"></td>
			
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Address :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.add1# #getmember.add2# #getmember.add3#</font></div></td>
            <td colspan="2"></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>IC No</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.icno#</font></div></td>
            <td colspan="2"></td>
          
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Contact :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.contact#</font></div></td>
            <td colspan="2"></td>
            </tr>
            
		<tr>
			<td colspan="#columncount#"><hr></td>
		</tr>
            
            <cfquery name="getitem" datasource="#dts#">
                SELECT a.wos_date,a.refno,a.itemno,a.desp,a.qty,a.price,a.amt,b.sizeid FROM ictran as a
                left join (select sizeid,itemno from icitem)as b on a.itemno=b.itemno
                where 0=0
                and a.type='CS'
                and (a.void is null or a.void='')
				and a.van ='#getmember.driverno#'
                
                order by wos_date
                </cfquery>
            
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Date.</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Reference No.</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Item No.</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Artist.</strong></font></div></td>
            <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Description</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Quantity</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Price</strong></font></div></td>
            <td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Amount</strong></font></div></td>
            </tr>
            
            <cfloop query="getitem">
            
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getitem.wos_date,'DD/MM/YYYY')#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.refno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.sizeid#</font></div></td>
            <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qty#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.price,',_.__')#</font></div></td>
             <td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.amt,',_.__')#</font></div></td>
             
                 </tr>
                 
				 <cfflush>
			</cfloop>
            <tr>
				<td colspan="#columncount#"><hr></td>
			</tr>
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
