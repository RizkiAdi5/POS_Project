<cfquery name="get_dealer_menu_info" datasource="#dts#">
				select 
				password 
				from dealer_menu;
</cfquery>
<cfif get_dealer_menu_info.password eq form.creditlimitpassword>
<script type="text/javascript">
document.getElementById('overcreditlimithid').value=0;
ColdFusion.Window.hide('creditlimitcontrol');
</script>
<cfelse>
<h3>Wrong Password</h3>

</cfif>