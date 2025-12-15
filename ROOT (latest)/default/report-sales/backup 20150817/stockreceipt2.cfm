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
		<title>Stock Receipt (Summary) (By Date)</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

		<body>
		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		  <cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<cfquery name="getdata" datasource="#dts#">
			select wos_date,refno,custno,net,tax,pono,sono,rem10,created_on,refno2 from artran
			where type in ('RC') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by wos_date
		</cfquery>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Stock Receipt (Summary) (By Date)</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            
            <cfif form.locfrom neq "" and form.locto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Location: #form.locfrom# - #form.locto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">DATE</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Supplier</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><div align="left">Reference Number</div></font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><div align="left">Reference Number 2</div></font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Invoice Total</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Sales Tax</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Other Cost</font></div></td>
				
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Date Received</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Date Captured</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Payment Method</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PO Number</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Order Number</font></div></td>
            	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Comment</font></div></td>
            
            </tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<cfset currentdate=''>
            
            <cfset totalcount = 0>
			<cfset totalamt = 0>
			<cfset totaltax = 0>
            
            <cfset subcount = 0>
			<cfset subamt = 0>
			<cfset subtax = 0>

			<cfloop query="getdata">
            
            <cfif currentdate neq '' and currentdate neq getdata.wos_date>
            
            
            <tr><td colspan="100%"><hr></td></tr>
            <tr>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><Strong>Sub Total :</Strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#subcount#</font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
								<td><div align="right">#numberformat(val(subamt),',_.__')#</div></td>
								<td><div align="right">#numberformat(val(subtax),',_.__')#</div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>

							
					</tr>
                    
            <cfset subcount = 0>
			<cfset subamt = 0>
            <cfset subtax = 0>
            <tr><td colspan="100%"><br></td></tr><tr><td colspan="100%"><br></td></tr>
            
            </cfif>
            
            	

					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getdata.wos_date,'dd/mm/yyyy')#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.custno#</font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.refno#</font></div></td>
								<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.refno2#</font></div></td>
                                <td><div align="right">#numberformat(val(getdata.net),',_.__')#</div></td>
								<td><div align="right">#numberformat(val(getdata.tax),',_.__')#</div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right">#dateformat(getdata.created_on,'dd/mm/yyyy')#</div></td>
                                <td><div align="right">#getdata.rem10#</div></td>
                                <td><div align="right">#getdata.pono#</div></td>
                                <td><div align="right">#getdata.sono#</div></td>
                                <td><div align="right"></div></td>

                              
                               <cfset totalcount = totalcount+1>
								<cfset totalamt = totalamt+val(getdata.net)>
                                <cfset totaltax = totaltax+val(getdata.tax)>
                                
                                <cfset subcount = subcount+1>
                                <cfset subamt = subamt+val(getdata.net)>
                                <cfset subtax = subtax+val(getdata.tax)>
                                <cfset currentdate=getdata.wos_date>
					</tr>
                    
				</cfloop>
 
 				<tr><td colspan="100%"><hr></td></tr>
                <tr>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><Strong>Sub Total :</Strong></font></div></td>
                            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
                            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#subcount#</font></div></td>
                            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
                                    <td><div align="right">#numberformat(val(subamt),',_.__')#</div></td>
                                    <td><div align="right">#numberformat(val(subtax),',_.__')#</div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
                                    <td><div align="right"></div></td>
    
                                
                        </tr>
                        
                <cfset subcount = 0>
                <cfset subamt = 0>
                <cfset subtax = 0>
                <tr><td colspan="100%"><br></td></tr><tr><td colspan="100%"><br></td></tr>
 
				<tr>
					<td colspan="100%"><hr></td>
				</tr>
				<tr>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><Strong>Total :</Strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#totalcount#</font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
								<td><div align="right">#numberformat(val(totalamt),',_.__')#</div></td>
								<td><div align="right">#numberformat(val(totaltax),',_.__')#</div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>
                                <td><div align="right"></div></td>
							
					</tr>
</table>
		</cfoutput>

		<cfif getdata.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
