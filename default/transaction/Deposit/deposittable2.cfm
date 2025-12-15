<html>
<head>
	<title>Maintenance Deposit</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
</head>

<body>
<cfoutput>
	<cfswitch expression="#url.type#">
		<cfcase value="Edit,Delete" delimiters=",">
			<cfquery name="getDeposit" datasource="#dts#">
				select * from Deposit where Depositno = '#url.Deposit#'
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit">
			<cfset mode="Edit">
			<cfset title="Edit Deposit">
			<cfset button="Edit">
            <cfset sono=getDeposit.sono>
		</cfcase>
		<cfcase value="Delete">
			<cfset mode="Delete">
			<cfset title="Delete Deposit">
			<cfset button="Delete">
            <cfset sono=getDeposit.sono>
		</cfcase>
		<cfcase value="Create">
			<cfset mode="Create">
			<cfset title="Create Deposit">
			<cfset button="Create">
            <cfset sono=''>
            <cfquery name="getlastno" datasource="#dts#">
				select depositno as depositno from Deposit order by depositno desc
			</cfquery>
            <cfif getlastno.recordcount eq 0>
            <cfset depositno='00000001'>
            <cfelse>
            <cftry>
            <cfset depositno=numberformat(getlastno.depositno+1,'00000000')>
            <cfcatch>
            <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastno.depositno#" returnvariable="depositno" />
    		</cfcatch>
            </cftry>
            </cfif>
		</cfcase>
	</cfswitch>

	<h1>#title#</h1>
	<h4>
	<cfif getpin2.h1F10 eq 'T'><a href="Deposittable2.cfm?type=Create">Creating A Deposit Area</a> </cfif>
	<cfif getpin2.h1F20 eq 'T'>|| <a href="Deposittable.cfm">List All Deposit</a> </cfif>
	<cfif getpin2.h1F30 eq 'T'>|| <a href="s_Deposittable.cfm?type=Deposit">Search For Deposit</a></cfif>
    
    
    <cfif getpin2.h1630 eq 'T'>|| <a href="p_Deposit.cfm">Deposit Listing</a></cfif></h4>

	<cfform name="Depositform" action="Deposittableprocess.cfm" method="post">
    <cfif isdefined('url.tran')>
    <input type="hidden" name="transactioncreate" id="transactioncreate" value="1">
    <cfset sono=url.sono>
    </cfif>
    	<input type="hidden" name="sono" id="sono" value="#sono#">
    	<input type="hidden" name="mode" value="#mode#">

		<h1 align="center">Deposit File Maintenance</h1>

		<table align="center" class="data" width="500">
      		<tr>
        		<td width="100">Deposit :</td>
        		<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<cfinput type="text" size="12" name="Depositno" value="#getDeposit.Depositno#" readonly>
            	<cfelse>
            		<cfinput type="text" size="12" name="Depositno" value="#depositno#" required="yes" maxlength="12" readonly>
          		</cfif>
				</td>
      		</tr>
      		<tr>
        		<td>Description:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="desp" required="no" value="#getDeposit.desp#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="40" name="desp" value="Deposit Pay" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Date:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="wos_date" required="no" value="#dateformat(getDeposit.wos_date,'DD/MM/YYYY')#" maxlength="10" validate="eurodate">
					<cfelse>
						<cfinput type="text" size="10" name="wos_date" required="no" value="#dateformat(now(),'DD/MM/YYYY')#" maxlength="10" validate="eurodate">
					</cfif>
                    <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(wos_date);">
                    (DD/MM/YYYY)
				</td>
      		</tr>
            <tr>
        		<td>Cash:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_CASH" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_CASH,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_CASH" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Cheque:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_CHEQ" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_CHEQ,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_CHEQ" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td colspan="2">Cheque No:
				&nbsp;
				<cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="30" name="chequeno" required="no" value="#getDeposit.chequeno#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="30" name="chequeno" value="" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            
            <tr>
        		<td>Credit Card:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_crcd" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_crcd,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_crcd" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
<td colspan="3">
<cfif mode eq "Delete" or mode eq "Edit">
<input type="radio" name="cctype1" id="cctype1" value="MASTER" <cfif getDeposit.cctype1 eq 'MASTER'>checked="checked"</cfif>/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="VISA" <cfif getDeposit.cctype1 eq 'VISA'>checked="checked"</cfif> />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="AMEX" <cfif getDeposit.cctype1 eq 'AMEX'>checked="checked"</cfif> />American Express&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="DINERS" <cfif getDeposit.cctype1 eq 'DINERS'>checked="checked"</cfif> />Diners Club
<cfelse>
<input type="radio" name="cctype1" id="cctype1" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="DINERS" />Diners Club
</cfif>
</td>
</tr>
            <tr>
        		<td>Credit Card 2:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_crc2" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_crc2,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_crc2" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
<td colspan="3">
<cfif mode eq "Delete" or mode eq "Edit">
<input type="radio" name="cctype2" id="cctype2" value="MASTER" <cfif getDeposit.cctype2 eq 'MASTER'>checked="checked"</cfif>/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="VISA" <cfif getDeposit.cctype2 eq 'VISA'>checked="checked"</cfif>/>Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="AMEX" <cfif getDeposit.cctype2 eq 'AMEX'>checked="checked"</cfif>/>American Express&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="DINERS" <cfif getDeposit.cctype2 eq 'DINERS'>checked="checked"</cfif>/>Diners Club
<cfelse>
<input type="radio" name="cctype2" id="cctype2" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype2" id="cctype2" value="DINERS" />Diners Club

</cfif>
</td>
</tr>
            <tr>
        		<td>Debit Card :</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_dbcd" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_dbcd,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_dbcd" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Voucher :</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="CS_PM_vouc" validate="float" required="no" value="#numberformat(getDeposit.CS_PM_vouc,',_.__')#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="10" name="CS_PM_vouc" validate="float" value="0.00" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>

      		<tr>
        		<td></td>
        		<td align="right"><cfinput name="submit" type="submit" value="  #button#  "></td>
      		</tr>
		</table>
	</cfform>
</body>
</cfoutput>
</html>