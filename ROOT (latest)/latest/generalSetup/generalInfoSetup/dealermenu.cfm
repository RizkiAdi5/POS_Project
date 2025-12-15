<html>
<head>
<title>Dealer Menu</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/collapse_expand_single_item.js"></script>
</head>

<body>

<h4>
	<cfif getpin2.h5110 eq "T"><a href="../comprofile.cfm">Company Profile</a> </cfif>
    <cfif getpin2.h5120 eq "T">|| <a href="../lastusedno.cfm">Last Used No</a> </cfif>
    <cfif getpin2.h5130 eq "T">|| <a href="../transaction.cfm">Transaction Setup</a> </cfif>
    <cfif getpin2.h5140 eq "T">|| <a href="../Accountno.cfm">UBS Accounting Default Setup</a> </cfif> 
    <cfif getpin2.h5150 eq "T">|| <a href="../userdefine.cfm">User Defined</a> </cfif>
    <cfif getpin2.h5160 eq "T">||Dealer Menu </cfif> 
    <cfif getpin2.h5170 eq "T">||<a href="../transaction_menu/transaction_menu.cfm">Transaction Menu</a> </cfif> 
    <cfif getpin2.h5180 eq "T">||<a href="../userdefineformula.cfm">User Define - Formula</a></cfif>
</h4>

<h1 align="center">General Setup - Dealer_Menu</h1>

<cfquery name="get_dealer_menu_setting" datasource="#dts#">
	select 
	* 
	from dealer_menu;
</cfquery>
<cfquery datasource="#dts#" name="getGeneralInfo">
    SELECT * FROM gsetup;
</cfquery>
<cfset editbillpassword=getGeneralInfo.editbillpassword>
<cfset editbillpassword1=getGeneralInfo.editbillpassword1>

<!--- Modification On 11-01-2010, Remove Those Unuse Fields From This Form --->

<cfform name="dealer_menu" action="update_dealer_menu.cfm" method="post">
	<table align="center" class="data" width="50%">
		<tr>
			<th onClick="javascript:shoh('dealer_menu_page1');shoh('dealer_menu_page2');">Page 1<img src="/images/d.gif" name="imgdealer_menu_page1" align="center"></th>
			<th onClick="javascript:shoh('dealer_menu_page2');shoh('dealer_menu_page1');">Page 2<img src="/images/u.gif" name="imgdealer_menu_page2" align="center"></th>
		</tr>
	</table>
	<cfoutput>
	<table id="dealer_menu_page1" align="center" class="data" width="50%">
		<!--- <tr bgcolor="999999">
			<td><input name="keep_deleted_bills" type="checkbox" value="Y" #iif(get_dealer_menu_setting.keep_deleted_bills eq "Y",DE("checked"),DE(""))# disabled> Keep Deleted Bills</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="negetive_stock_allowed" type="checkbox" value="Y" #iif(get_dealer_menu_setting.negetive_stock_allowed eq "Y",DE("checked"),DE(""))# disabled> Negetive Stock Allowed</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="with_super_password" type="checkbox" value="Y" #iif(get_dealer_menu_setting.with_super_password eq "Y",DE("checked"),DE(""))# disabled> With Super Password</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="allowed_edit_quantity_of_invoice_generated_from_do" type="checkbox" value="Y" #iif(get_dealer_menu_setting.allowed_edit_quantity_of_invoice_generated_from_do eq "Y",DE("checked"),DE(""))# disabled> Allowed Edit Quantity Of Invoice Generated From DO</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="allowed_repeated_ref_no_2_in_so_cn_dn" type="checkbox" value="Y" #iif(get_dealer_menu_setting.allowed_repeated_ref_no_2_in_so_cn_dn eq "Y",DE("checked"),DE(""))# disabled> Allowed Repeated Ref No 2 In So CN,DN</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="with_system_date_time" type="checkbox" value="Y" #iif(get_dealer_menu_setting.with_system_date_time eq "Y",DE("checked"),DE(""))# disabled> With System Date Time</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="create_backup_set_at_year_end_processing" type="checkbox" value="Y" #iif(get_dealer_menu_setting.create_backup_set_at_year_end_processing eq "Y",DE("checked"),DE(""))# disabled> Create Backup Set At Year End Processing</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="cents_in_arabic" type="checkbox" value="Y" #iif(get_dealer_menu_setting.cents_in_arabic eq "Y",DE("checked"),DE(""))# disabled> Cents In Arabic</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="use_user_id_to_login" type="checkbox" value="Y" #iif(get_dealer_menu_setting.use_user_id_to_login eq "Y",DE("checked"),DE(""))# disabled> Use User ID To Login</td>
		</tr>
		<tr bgcolor="999900">
			<td align="center"><strong>Safety Control Password For INV,CS,DO,DN,CN</strong></td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><input name="selling_below_cost" type="checkbox" value="Y" #iif(get_dealer_menu_setting.selling_below_cost eq "Y",DE("checked"),DE(""))#> Selling Below Cost</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><input name="minimum_selling_price" type="checkbox" value="Y" #iif(get_dealer_menu_setting.minimum_selling_price eq "Y",DE("checked"),DE(""))#> Minimum Selling Price</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><input name="selling_above_credit_limit" type="checkbox" value="Y" #iif(get_dealer_menu_setting.selling_above_credit_limit eq "Y",DE("checked"),DE(""))#> Selling Above Credit Limit</td>
		</tr> --->
		<tr>
			<td align="center" colspan="100%"><strong>Safety Control Password For INV,CS,DO,DN,CN</strong></td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Selling Below Cost</th>
			<td>
				<input name="selling_below_cost" type="checkbox" value="Y" #iif(get_dealer_menu_setting.selling_below_cost eq "Y",DE("checked"),DE(""))#> 
			</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Minimum Selling Price</th>
			<td>
				<input name="minimum_selling_price" type="checkbox" value="Y" #iif(get_dealer_menu_setting.minimum_selling_price eq "Y",DE("checked"),DE(""))#> 
			</td>
		</tr>
        <tr>
        <th><div align="left">Edit/Delete Bill Password control for
            <input name="editbillpassword1" type="text" value="#editbillpassword1#" maxlength="100" size="20">
            (For example: QUO,INV)</div></th>
        <td><input name="editbillpassword" type="checkbox" value="1" <cfif editbillpassword eq '1'>checked</cfif>></td>
      </tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Selling Above Credit Limit</th>
			<td>
				<input name="selling_above_credit_limit" type="checkbox" value="Y" #iif(get_dealer_menu_setting.selling_above_credit_limit eq "Y",DE("checked"),DE(""))#> 
			</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Password</th>
			<td><cfinput name="password" type="password" value="#get_dealer_menu_setting.password#" size="10" maxlength="50"> </td>
		</tr>
        <tr>
        <th>Customer Ajax Format</th>
        <td><select name="custformat" id="custformat">
        <option value="1" <cfif get_dealer_menu_setting.custformat eq '1'>selected</cfif>>Custno,Leftname,Midname</option>
        <option value="2" <cfif get_dealer_menu_setting.custformat eq '2'>selected</cfif>>Agentno,Custname,Custno</option>
        </select>
        </td>
        </tr>
        <tr>
        <th>Product Ajax Format</th>
        <td><select name="itemformat" id="custformat">
        <option value="1" <cfif get_dealer_menu_setting.itemformat eq '1'>selected</cfif>>Itemno,Leftname,Midname</option>
        <option value="2" <cfif get_dealer_menu_setting.itemformat eq '2'>selected</cfif>>Productcode,Description,Itemno</option>
        </select>
        </td>
        </tr>
		<!--- <tr bgcolor="999999">
			<td><input name="foc_item" type="checkbox" value="Y" #iif(get_dealer_menu_setting.foc_item eq "Y",DE("checked"),DE(""))# disabled> FOC Item</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="edit_bills" type="checkbox" value="Y" #iif(get_dealer_menu_setting.edit_bills eq "Y",DE("checked"),DE(""))# disabled> Edit Bills</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="delete_bills" type="checkbox" value="Y" #iif(get_dealer_menu_setting.delete_bills eq "Y",DE("checked"),DE(""))# disabled> Delete Bills</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="second_print_control" type="checkbox" value="Y" #iif(get_dealer_menu_setting.second_print_control eq "Y",DE("checked"),DE(""))# disabled> Second Print Control</td>
		</tr> --->
	</table>
	<table id="dealer_menu_page2" style="display:none" align="center" class="data" width="50%">
		<tr>
			<td align="center" colspan="100%"><strong>Other Setting</strong></td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Customer / Supplier Sort By</th>
			<td>
				<select name="custSuppSortBy">
					<option value="custno,name" #iif(get_dealer_menu_setting.custSuppSortBy eq "custno,name",DE("selected"),DE(""))#>Cust/Supp No.</option>
					<option value="name,custno" #iif(get_dealer_menu_setting.custSuppSortBy eq "name,custno",DE("selected"),DE(""))#>Cust/Supp Name</option>
					<option value="created_on desc" #iif(get_dealer_menu_setting.custSuppSortBy eq "created_on desc",DE("selected"),DE(""))#>Date Created (Descending)</option>
				</select>
			</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Product Sort By</th>
			<td>
				<select name="productSortBy">
					<option value="itemno,desp" #iif(get_dealer_menu_setting.productSortBy eq "itemno,desp",DE("selected"),DE(""))#>Item No.</option>
					<option value="desp,itemno" #iif(get_dealer_menu_setting.productSortBy eq "desp,itemno",DE("selected"),DE(""))#>Item Description</option>
					<option value="created_on desc" #iif(get_dealer_menu_setting.productSortBy eq "created_on desc",DE("selected"),DE(""))#>Date Created (Descending)</option>
				</select>
			</td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Transaction Sort By</th>
			<td>
				<select name="transactionSortBy">
					<option value="created_on desc,refno desc" #iif(get_dealer_menu_setting.transactionSortBy  eq "created_on desc,refno desc",DE("selected"),DE(""))#>Date Created (Descending)</option>
					<option value="wos_date desc,refno desc" #iif(get_dealer_menu_setting.transactionSortBy  eq "wos_date desc,refno desc",DE("selected"),DE(""))#>Bill Date (Descending)</option>
                    <option value="refno desc,wos_date desc" #iif(get_dealer_menu_setting.transactionSortBy  eq "refno desc,wos_date desc",DE("selected"),DE(""))#>Refno (Descending)</option>
				</select>
			</td>
		</tr>
        <cfif husergrpid eq "Super">
            <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                <th>Custom Company</th>
                <td>
                	<input name="customcompany" type="checkbox" value="Y" #iif(get_dealer_menu_setting.customcompany eq "Y",DE("checked"),DE(""))#>
                </td>
            </tr>
        <cfelse>
        	<input name="customcompany" type="hidden" value="#get_dealer_menu_setting.customcompany#">
		</cfif>
		<tr>
			<td align="center" colspan="100%"><strong>Report Setting</strong></td>
		</tr>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<th>Include SO/PO In Stock Card Report</th>
			<td><input name="include_SO_PO_stockcard" type="checkbox" value="Y" #iif(get_dealer_menu_setting.include_SO_PO_stockcard eq "Y",DE("checked"),DE(""))#></td>
		</tr>
		<!--- <tr bgcolor="999999">
			<td><cfinput name="trans_limit_demo" type="text" value="#get_dealer_menu_setting.trans_limit_demo#" size="10" maxlength="10" disabled> Trans Limit Demo</td>
		</tr>
		<tr bgcolor="999999">
			<td><cfinput name="date_expired" type="text" value="#lsdateformat(get_dealer_menu_setting.date_expired,'dd/mm/yyyy')#" size="10" maxlength="10" disabled> Date Expired</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="remove_audit_trail_of_modification" type="checkbox" value="Y" #iif(get_dealer_menu_setting.remove_audit_trail_of_modification eq "Y",DE("checked"),DE(""))# disabled> Remove Audit Trail Of Modification</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="control_credit_limit_for_so" type="checkbox" value="Y" #iif(get_dealer_menu_setting.control_credit_limit_for_so eq "Y",DE("checked"),DE(""))# disabled> Control Credit Limit For SO</td>
		</tr>
		<tr bgcolor="999999">
			<td><input name="set_gst_to_zr_when_tax_0" type="checkbox" value="Y" #iif(get_dealer_menu_setting.set_gst_to_zr_when_tax_0 eq "Y",DE("checked"),DE(""))# disabled> Set GST To ZR When TAX 0</td>
		</tr>
		<tr bgcolor="999999">
			<td><cfinput name="password" type="password" value="#get_dealer_menu_setting.password#" size="10" maxlength="50"> Password</td>
		</tr>
		<tr bgcolor="999999">
			<td><cfinput name="cost_allowed_pin" type="text" value="#get_dealer_menu_setting.cost_allowed_pin#" size="10" maxlength="50" disabled> Cost Allowed PIN</td>
		</tr> --->
	</table>
	<table align="center" class="data" width="50%">
		<tr>
			<td align="center">
				<input name="Save" type="submit" value="Save">
				<input name="Reset" type="reset" value="Reset">
			</td>
		</tr>
	</table>
	</cfoutput>
</cfform>

</body>
</html>