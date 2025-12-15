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
		SELECT * FROM driver 
        where 0=0
			<cfif trim(form.memberfrom) neq "">
			and driverno = '#form.memberfrom#'
			</cfif>
            <cfif isdefined('form.Negpoint')>
            and pointsbf+points-pointsredeem < 0
            </cfif>
            <cfif isdefined('form.point30')>
            and pointsbf+points-pointsredeem >= 30
            </cfif>
        order by driverno
	</cfquery>
	
	<cfoutput>
    <cfset columncount = "100%">
    <cfset rowcom = 7>
    <cfset comcom = 3>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="left"><font size="3" face="Times New Roman, Times, serif"><strong>Member Point History Report</strong></font></div></td>
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
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Address :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.add1# #getmember.add2# #getmember.add3#</font></div></td>
            <td colspan="2"></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>IC No</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getmember.remarks#</font></div></td>
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
				
                SELECT * FROM artran 
                where 0=0
                and type='CS'
                and (void is null or void='')

				and van ='#getmember.driverno#'
                
                </cfquery>
            
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Date.</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Reference No.</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Grand</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Point Earned</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Point Used</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Balance Point</strong></font></div></td>
            
            </tr>
            
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong></strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong></strong></font></div></td>

            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Point Opening :</strong></font></div></td>
          	<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#getmember.pointsbf#</strong></font></div></td>
   
            </tr>
            <cfset pointbal=getmember.pointsbf>
            <cfloop query="getitem">
            
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getitem.wos_date,'DD/MM/YYYY')#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.refno#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.grand,',_.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.point,',_.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.cs_pm_cheq,',_.__')#</font></div></td>
            <cfset pointbal=pointbal+getitem.point-(getitem.cs_pm_cheq)>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(pointbal,',_.__')#</font></div></td>
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
