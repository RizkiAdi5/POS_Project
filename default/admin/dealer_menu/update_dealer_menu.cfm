<cfparam name="form.company_id" 										default="IMS" 			type="any">
<cfparam name="form.keep_deleted_bills" 								default="" 				type="any">
<cfparam name="form.negetive_stock_allowed" 							default="Y" 			type="any">
<cfparam name="form.with_super_password" 								default="Y" 			type="any">
<cfparam name="form.allowed_edit_quantity_of_invoice_generated_from_do" default="" 				type="any">
<cfparam name="form.allowed_repeated_ref_no_2_in_so_cn_dn" 				default="Y" 			type="any">
<cfparam name="form.with_system_date_time" 								default="" 				type="any">
<cfparam name="form.create_backup_set_at_year_end_processing" 			default="Y" 			type="any">
<cfparam name="form.cents_in_arabic" 									default="" 				type="any">
<cfparam name="form.use_user_id_to_login" 								default="Y" 			type="any">
<cfparam name="form.selling_below_cost" 								default="" 				type="any">
<cfparam name="form.minimum_selling_price" 								default="" 				type="any">
<cfparam name="form.selling_above_credit_limit" 						default="" 				type="any">
<cfparam name="form.foc_item" 											default="" 				type="any">
<cfparam name="form.edit_bills" 										default="" 				type="any">
<cfparam name="form.delete_bills" 										default="" 				type="any">
<cfparam name="form.second_print_control" 								default="" 				type="any">
<cfparam name="form.trans_limit_demo" 									default="200" 			type="any">
<cfparam name="form.date_expired" 										default="3069-12-12"	type="any">
<cfparam name="form.remove_audit_trail_of_modification"					default="" 				type="any">
<cfparam name="form.control_credit_limit_for_so" 						default="" 				type="any">
<cfparam name="form.set_gst_to_zr_when_tax_0" 							default="Y" 			type="any">
<cfparam name="form.password" 											default="" 				type="any">
<cfparam name="form.cost_allowed_pin" 									default="01234" 		type="any">
<cfparam name="form.custSuppSortBy" 									default="custno" 		type="any">
<cfparam name="form.productSortBy" 										default="itemno" 		type="any">
<cfparam name="form.transactionSortBy" 									default="wos_date desc,refno desc" 		type="any">
<cfparam name="form.include_SO_PO_stockcard" 							default="N" 			type="any">
<cfparam name="form.customcompany" 										default="N" 			type="any">

<cfquery datasource="#dts#" name="SaveGeneralInfo">
    UPDATE gsetup SET  
		<cfif isdefined("form.editbillpassword")>
            editbillpassword = '1'
        <cfelse>
            editbillpassword = ''
        </cfif>	
        
        ,editbillpassword1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.editbillpassword1#">
      
	WHERE companyid='IMS';
</cfquery>

<cftry>
	<cfupdate 
	datasource="#dts#" 
	tablename="dealer_menu" 
	formfields="
	company_id,
	keep_deleted_bills,
	negetive_stock_allowed,
	with_super_password,
	allowed_edit_quantity_of_invoice_generated_from_do,
	allowed_repeated_ref_no_2_in_so_cn_dn,
	with_system_date_time,
	create_backup_set_at_year_end_processing,
	cents_in_arabic,
	use_user_id_to_login,
	selling_below_cost,
	minimum_selling_price,
	selling_above_credit_limit,
	foc_item,
	edit_bills,
	delete_bills,
	second_print_control,
	trans_limit_demo,
	date_expired,
	remove_audit_trail_of_modification,
	control_credit_limit_for_so,
	set_gst_to_zr_when_tax_0,
	password,
	cost_allowed_pin,custSuppSortBy,productSortBy,transactionSortBy,include_SO_PO_stockcard,customcompany,custformat,itemformat
	">
	
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>

<script language="javascript" type="text/javascript">
	alert("Update Process Done !");
	window.location="dealer_menu.cfm";
</script>