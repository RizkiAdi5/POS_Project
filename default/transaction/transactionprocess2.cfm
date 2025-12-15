<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfinclude template="arcust_apvend_checking/invoice_limit_checking.cfm">
<cfif getpin2.h2G00 eq "T">
<cfelse>
<cfinclude template="arcust_apvend_checking/credit_limit_checking.cfm">
</cfif>
<cfinclude template="dealer_setting_checking/selling_below_cost.cfm">
<cfinclude template="dealer_setting_checking/minimum_selling_price.cfm">
<cfinclude template="dealer_setting_checking/selling_above_credit_limit_body_part.cfm">

<cffunction name="reorder" output="false">
	<cfargument name="itemcountlist" required="yes">
	<cfargument name="refno" required="yes">
	
	<cfloop index="i" from="1" to="#listlen(itemcountlist)#">
		<cfif listgetat(itemcountlist,i) neq i>
			<cfquery name="updateIserial" datasource="#dts#">
				update iserial set 
				trancode='#i#'
				where type='#tran#' 
				and refno='#refno#' 
				and custno='#form.custno#' 
				and trancode='#listgetat(itemcountlist,i)#';
			</cfquery>
            <cfquery name="updateIgrade" datasource="#dts#">
				update igrade set 
				trancode='#i#'
				where type='#tran#' 
				and refno='#refno#' 
				and custno='#form.custno#' 
				and trancode='#listgetat(itemcountlist,i)#';
			</cfquery>
			
			<cfquery name="updateIctran" datasource="#dts#">
				update ictran set 
				itemcount='#i#',
				trancode='#i#'
				where type='#tran#' 
				and refno='#refno#' 
				and custno='#form.custno#' 
				and itemcount='#listgetat(itemcountlist,i)#';
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cfquery name="getitem" datasource="#dts#">
	select category,wos_group,wserialno,unit 
	from icitem 
	where itemno='#form.itemno#'
</cfquery>

<!--- 3 Level Discount --->
<cfif form.dispec1 eq "">
  <cfset form.dispec1 = 0>
</cfif>

<cfif form.dispec2 eq "">
  <cfset form.dispec2 = 0>
</cfif>

<cfif form.dispec3 eq "">
  <cfset form.dispec3 = 0>
</cfif>

<cfset qtylist = form.qtylist>
<cfset oldqtylist = form.oldqtylist>
<cfset locationlist = form.locationlist>
<cfset batchlist = form.batchlist>

<cfset oldbatchlist = form.oldbatchlist>
<cfset mc1billist = form.mc1billist>
<cfset mc2billist = form.mc2billist>
<cfset sodatelist = form.sodatelist>
<cfset dodatelist = form.dodatelist>
<cfset expdatelist = form.expdatelist>
<cfset milcertlist = form.milcertlist>
<cfset importpermitlist = form.importpermitlist>
<cfset defectivelist = form.defectivelist>
<cfset manudatelist = form.expdatelist>

<cfset qtyArray = ListToArray(qtylist,";")>
<cfset oldqtyArray = ListToArray(oldqtylist,";")>
<cfset locationArray = ListToArray(locationlist,";")>
<cfset batchArray = ListToArray(batchlist,";")>

<cfset oldbatchArray = ListToArray(oldbatchlist,";")>
<cfset mc1bilArray = ListToArray(mc1billist,";")>
<cfset mc2bilArray = ListToArray(mc2billist,";")>
<cfset sodateArray = ListToArray(sodatelist,";")>
<cfset dodateArray = ListToArray(dodatelist,";")>
<cfset expdateArray = ListToArray(expdatelist,";")>
<cfset milcertArray = ListToArray(milcertlist,";")>
<cfset importpermitArray = ListToArray(importpermitlist,";")>
<cfset defectiveArray = ListToArray(defectivelist,";")>
<cfset manudateArray = ListToArray(manudatelist,";")>
<!--- ADD ON 30-07-2009 --->
<cfquery datasource="#dts#" name="getGeneralInfo">
	select * from gsetup
</cfquery>

<cfset wpitemtax="">
<cfif getGeneralInfo.wpitemtax eq "1">
	<cfif getGeneralInfo.wpitemtax1 neq "">
    	<cfif ListFindNoCase(getgeneralinfo.wpitemtax1, tran, ",") neq 0>
			<cfset wpitemtax = "Y">
        </cfif>
	<cfelse>
    	<cfset wpitemtax="Y">
	</cfif>
</cfif>

<cfif form.mode eq "Delete">
	<!---DELETE TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess2_delete.cfm">
	<!---DELETE TRANSACTION PROCESS --->
<cfelseif form.mode eq "Add">
	<!---ADD TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess2_add.cfm">
	<!---ADD TRANSACTION PROCESS --->
<cfelseif form.mode eq "Edit">
	<!---EDIT TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess2_edit.cfm">
	<!---EDIT TRANSACTION PROCESS --->
</cfif>
<cfinclude template = "transactionprocess_check_default_process.cfm">