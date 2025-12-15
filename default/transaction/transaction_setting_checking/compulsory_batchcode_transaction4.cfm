<cfquery name="check_compulsory_batchcode_setting" datasource="#dts#">
	select 
	compulsory_batchcode
	from transaction_menu
</cfquery>

<cfif check_compulsory_batchcode_setting.compulsory_batchcode eq "Y">
	if(trim(document.getElementById("enterbatch").value)=="")
	{
		<cfif lcase(hcomid) eq "thaipore_i" or lcase(hcomid) eq "laihock_i">
			alert("Please Select A Lot Number !");
		<cfelse>
			alert("Please Select A Batch Code !");
		</cfif>
		
		return false;
	}
</cfif>