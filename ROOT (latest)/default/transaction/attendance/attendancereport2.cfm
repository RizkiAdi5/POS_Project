<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<html>
<head>
<title>Staff Attendance Report</title>
<link href="../../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">

</head>

<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYY-MM-DD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYY-DD-MM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	<cfif dd greater than '12'>
		<cfset ndateto = dateformat(form.dateto,"YYYY-MM-DD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYY-DD-MM")>
	</cfif>
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
	select lastaccyear,cost,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION 
	from gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
	select * from staffattendance
    where logintype='login'
	<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
	</cfif>
    group by wos_date,cashier,logintype
	order by cashier
</cfquery>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<p align="center"><font color="##000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Staff Attendance</strong></font></p>
<cfif getitem.recordcount neq 0>
	<table width="100%" border="0" class="" align="center">
		<tr>
			<td colspan="8"><hr></td>
		</tr>
	  	<tr>
        	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Staff</font></strong></td>
    		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Date</font></strong></td>
        	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Check In Time</font></strong></td>
  			<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Check Out Time</font></strong></td>
        </tr>
  		<tr>
			<td colspan="8"><hr></td>
		</tr>

		<cfoutput query="getitem">
		<cfquery name="getlogout" datasource="#dts#">
            select * from staffattendance
            where logintype='logout' and wos_date=#getitem.wos_date# and cashier='#getitem.cashier#'
            
        </cfquery>
  			<tr>
    			<td><font size="2" face="Arial, Helvetica, sans-serif">#getitem.cashier#</font></td>
   	 			<td><font size="2" face="Arial, Helvetica, sans-serif">#dateformat(getitem.wos_date,'dd/mm/yyyy')#</font></td>
    			<td>#timeformat(getitem.time,'HH:MM:SS')#</td>
				<td>#timeformat(getlogout.time,'HH:MM:SS')#</td>
			</tr>
  		</cfoutput>
	</table>
<cfelse>
  	<h3><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.</font></h3>
</cfif>

<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>
