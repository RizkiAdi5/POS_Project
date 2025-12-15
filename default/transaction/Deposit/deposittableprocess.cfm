<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">
<cfif form.wos_date neq ''>
<cfset form.wos_date=createdate(right(form.wos_date,4),mid(wos_date,4,2),left(wos_date,2))>
<cfset form.wos_date=dateformat(form.wos_date,'YYYY-MM-DD')>
<cfelse>
<cfset form.wos_date='0000-00-00'>
</cfif>

<cfif form.mode eq "Create">
	<cftry>
		<cfinsert datasource='#dts#' tablename="Deposit" formfields="Depositno,desp,,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,chequeno,cctype1,cctype2,sono,wos_date">
		
		<cfcatch type="database">
			<h3 align="center">Error. This Deposit Has Been Created Already !</h3>
			<p align="center"><input type="button" name="Back" value="Back" onClick="javascrip:history.back()"></p>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cfset status="The Deposit, #form.Depositno# Has Been Created successfully !">

<cfelse>
	<cfswitch expression="#form.mode#">
		<cfcase value="Delete">
			<cftry>
				<cfquery datasource='#dts#' name="deleteDeposit">
					Delete from Deposit where depositno='#form.depositno#'
				</cfquery>
				<cfcatch type="database">
					<cfset status="Sorry, The Deposit, #form.Depositno# was Removed From The System !">
					<p align="center"><input type="button" name="Back" value="Back" onClick="javascrip:history.back()"></p>
					<cfabort>
				</cfcatch>
			</cftry>
			
			<cfset status="The Deposit, #form.Depositno# Has Been Deleted Successfully!">
		</cfcase>
		<cfcase value="Edit">
			<cfupdate datasource='#dts#' tablename="Deposit" formfields="Depositno,desp,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,chequeno,cctype1,cctype2,sono,wos_date">
			<cfset status="The Deposit, #form.Depositno# Has Been Edited Successfully!">
		</cfcase>
	</cfswitch>
</cfif>

<cfif isdefined('transactioncreate')>
<cfoutput>
<script>
	<!---window.opener.addnewdeposit('#form.Depositno#');--->
	window.close();
	window.open('printdeposit.cfm?depositno=#form.Depositno#','_blank');
</script>
</cfoutput>

<cfelse>
<cfoutput>
	<form name="done" action="s_Deposittable.cfm?type=Deposit&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>
<cfoutput>
<script>
	window.open('printdeposit.cfm?depositno=#form.Depositno#','_blank');
	done.submit();
</script>
</cfoutput>
</cfif>