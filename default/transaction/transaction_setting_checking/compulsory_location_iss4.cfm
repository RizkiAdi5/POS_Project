<cfquery name="check_compulsory_location_setting" datasource="#dts#">
	select 
	compulsory_location
	from transaction_menu;
</cfquery>

<cfif check_compulsory_location_setting.compulsory_location eq "Y">
	if(document.getElementById("location").value=="")
	{
		alert("Please Select A Location !");
		document.getElementById("location").focus();
		return false;
	}
</cfif>