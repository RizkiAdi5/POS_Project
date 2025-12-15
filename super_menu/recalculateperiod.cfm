<html>
<head>
<title>PERIOD RECALCULATE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="javascript" src="../scripts/date_format.js"></script>

<cfparam name="submit" default="">

<body>
<form action="" method="post">
<H1>Recalculate</H1>
<input type="submit" name="submit" value="Submit">
</form>
<cfif submit eq 'Submit'>
	<cfquery name="getgsetup" datasource="#dts#">
		select lastaccyear from gsetup
	</cfquery>
	
    <cfquery datasource="#dts#" name="update99bill">
		update artran set fperiod="99"
		where wos_date <= #getgsetup.lastaccyear#
	</cfquery>
    
    <cfloop from="1" to="18" index="i">
    <cfset monthadd=i-1>
    <cfset ndatefrom=dateadd('m',monthadd,dateadd('d',1,getgsetup.lastaccyear))>
    <cfset ndateto=dateadd('d',DaysInMonth(ndatefrom),ndatefrom)>
    
    <cfset readperiod = numberformat(i,"00")>
    
    <cfquery name="updateperiod" datasource="#dts#">
			update artran set fperiod = '#readperiod#' where wos_date >= #ndatefrom# and wos_date < #ndateto#
	</cfquery>
    
    <cfquery name="updateperiod" datasource="#dts#">
        update ictran set fperiod = '#readperiod#'  where wos_date >= #ndatefrom# and wos_date < #ndateto#
    </cfquery>
    <cfquery name="updateperiod" datasource="#dts#">
        update igrade set fperiod = '#readperiod#' where wos_date >= #ndatefrom# and wos_date < #ndateto#
    </cfquery>
    <cfquery name="updateperiod" datasource="#dts#">
    	update iserial set fperiod = '#readperiod#' where wos_date >= #ndatefrom# and wos_date < #ndateto#
    </cfquery>		
    <cfquery name="updateperiod" datasource="#dts#">
        update artranat set fperiod = '#readperiod#' where wos_date >= #ndatefrom# and wos_date < #ndateto#
    </cfquery>
    
    </cfloop>
    
    <cfquery datasource="#dts#" name="getdeposit">
		Select * from deposit

	</cfquery>
    <cfloop query="getdeposit">
    <cfset thisdate = dateformat(getdeposit.wos_date,"yyyy-mm-dd")>
        
		<cfinvoke component="cfc.Period" method="getCurrentPeriod" dts="#dts#" inputDate="#thisdate#" returnvariable="cperiod"/>
		<cfquery name="updateperiod" datasource="#dts#">
			update deposit set fperiod = '#cperiod#' where depositno = '#getdeposit.depositno#' 
		</cfquery>
    </cfloop>
	You have finish the recalculate. 
</cfif>
</body>
</html>