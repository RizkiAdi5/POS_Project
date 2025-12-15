<html>
<head>
	<title>Maintenance Voucher Type</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>


<body>
<cfoutput>
	<cfswitch expression="#url.type#">
		<cfcase value="Edit,Delete" delimiters=",">
			<cfquery name="getvoucher" datasource="#dts#">
				select * from vouchertype where voucherid = '#url.voucher#'
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit">
			<cfset mode="Edit">
			<cfset title="Edit Voucher Type">
			<cfset button="Edit">
		</cfcase>
		<cfcase value="Delete">
			<cfset mode="Delete">
			<cfset title="Delete Voucher Type">
			<cfset button="Delete">
		</cfcase>
		<cfcase value="Create">
			<cfset mode="Create">
			<cfset title="Create Voucher Type">
			<cfset button="Create">
		</cfcase>
	</cfswitch>

	<h1>#title#</h1>

		<h4>
<a href="vouchertable2.cfm?type=Create">Create New Voucher Type</a>
|| <a href="vouchertable.cfm">List All Voucher Type</a>
|| <a href="s_vouchertable.cfm?type=voucher">Search For Voucher Type</a>
	</h4>

	<cfform name="voucherform" action="vouchertableprocess.cfm" method="post">
    	<input type="hidden" name="mode" value="#mode#">

		<h1 align="center">Voucher Type File Maintenance</h1>

		<table align="center" class="data" width="500">
      		<tr>
        		<td width="100">Voucher Type :</td>
        		<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<cfinput type="text" size="12" name="voucher" value="#getvoucher.voucherid#" readonly>
            	<cfelse>
            		<cfinput type="text" size="12" name="voucher" required="yes" maxlength="8">
          		</cfif>
				</td>
      		</tr>
      		<tr>
        		<td>Description:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="desp" required="no" value="#getvoucher.voucherdesp#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="40" name="desp" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Amount:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="10" name="voucheramt" required="no" value="#getvoucher.voucheramt#" maxlength="10">
					<cfelse>
						<cfinput type="text" size="10" name="voucheramt" required="no" maxlength="10">
					</cfif>
				</td>
      		</tr>
            <tr>
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