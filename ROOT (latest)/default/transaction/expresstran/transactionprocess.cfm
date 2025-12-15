<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfinclude template="arcust_apvend_checking/invoice_limit_checking.cfm">
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
            <cfquery name="updateiclinkfr" datasource="#dts#">
            	Update iclink SET
                frtrancode = '#i#'
                WHERE frtype = '#tran#'
                and frrefno = '#refno#'
                and frtrancode= '#listgetat(itemcountlist,i)#';
            </cfquery>
            
            <cfquery name="updateiclinkto" datasource="#dts#">
            	Update iclink SET
                trancode = '#i#'
                WHERE type = '#tran#'
                and refno = '#refno#'
                and trancode= '#listgetat(itemcountlist,i)#';
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

<cffunction name="relocate" output="false">
	<cfargument name="newtc" required="yes">
	<cfargument name="end" required="yes">
	<cfargument name="refno" required="yes">
	<cfquery name="updateIserial" datasource="#dts#">
        update iserial set 
        trancode=trancode + 1
       	where type='#tran#'
		and refno='#refno#' 
		and custno='#form.custno#' 
		and trancode>=#newtc# 
		and trancode<=#end#
    </cfquery>
    
    <cfquery name="updateIgrade" datasource="#dts#">
        update igrade set 
        trancode=trancode + 1
        where type='#tran#'
		and refno='#refno#' 
		and custno='#form.custno#' 
		and trancode>=#newtc# 
		and trancode<=#end#
    </cfquery>
    <cfquery name="updateiclinkfr" datasource="#dts#">
        Update iclink SET
        frtrancode = frtrancode + 1
        WHERE frtype = '#tran#'
        and frrefno = '#refno#'
        and frtrancode >=#newtc#
        and frtrancode<=#end#
    </cfquery>
    
     <cfquery name="updateiclinkfr" datasource="#dts#">
        Update iclink SET
        trancode = trancode + 1
        WHERE type = '#tran#'
        and refno = '#refno#'
        and trancode >=#newtc#
        and trancode <=#end#
    </cfquery>
            
	<cfquery name="updateIctran" datasource="#dts#">
		update ictran set 
		itemcount=itemcount+1,
		trancode=trancode+1
		where type='#tran#'
		and refno='#refno#' 
		and custno='#form.custno#' 
		and itemcount>=#newtc# 
		and itemcount<=#end#
		order by itemcount desc;
	</cfquery>
</cffunction>

<!--- REMARK ON 090608 AND REPLACE WITH THE IF ELSE CONDITION --->
<!---cfset amt1_bil = val(form.qty) * val(form.price)--->

<!--- Add On 091008, Ecraft Customization --->
<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
	<cfset loc_currrcode = "">
	<cfset loc_currrate = 1>
	<cfif form.location neq "">
		<cfquery name="getforeign" datasource="#dts#">
			select FOREIGNLOC,CURRCODE from iclocation where location = '#form.location#'
		</cfquery>
		<cfset loc_currrcode = getforeign.currcode>
		<cfif val(getforeign.FOREIGNLOC) neq 0>
			<cfquery name="currency" datasource="#dts#">
  				select * from #target_currency# 
				where currcode='#getforeign.currcode#'
			</cfquery>
			
			<cfif val(form.readperiod) gt 18 or val(form.readperiod) lte 0>
				<cfset loc_currrate = currency.currrate>
			<cfelse>
				<cfset counter = val(form.readperiod)>
				<cfset loc_currrate = Evaluate("currency.currp#counter#")>
			</cfif>
		</cfif>
	</cfif>
</cfif> --->

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

<cfif val(form.qty) neq 0 and getGeneralInfo.editamount neq "1">
	<cfset amt1_bil=val(form.qty) * val(form.price)>
	<cfset amt1_bil=numberformat(amt1_bil,".__")>	<!--- ADD ON 04-03-2009 --->
<cfelse>
	<cfset amt1_bil=val(form.amt)>
</cfif>

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
<cfset netamttemp = 0>
<cfset disamt_bil1 = (val(form.dispec1) / 100) * amt1_bil>
<cfset netamttemp = amt1_bil - disamt_bil1>
<cfset disamt_bil2 = (val(form.dispec2) / 100) * netamttemp>
<cfset netamttemp = netamttemp - disamt_bil2>
<cfset disamt_bil3 = (val(form.dispec3) / 100) * netamttemp>
<cfset netamttemp = netamttemp - disamt_bil3>
<cfset disamt_bil = disamt_bil1 + disamt_bil2 + disamt_bil3>

<!--- Add on 230908 --->
<cfif val(disamt_bil) eq 0 and val(discamt) neq 0>
	<cfset disamt_bil = discamt>
</cfif>

<cfset disamt_bil = numberformat(disamt_bil,'.__')>
<cfset netamt = amt1_bil - val(disamt_bil)>

<!--- <cfset taxamt_bil = (val(form.taxpec1) / 100) * netamt> --->
<cfset taxamt_bil = val(form.taxamt_bil)>
<!--- <cfset amt_bil = val(netamt) + taxamt_bil> --->	<!--- REMARK ON 30-07-2009 --->
<cfset amt_bil = val(netamt)>
<cfset xprice = val(form.price) * currrate>
<cfset amt1 = amt1_bil * currrate>
<cfset disamt = disamt_bil * currrate>
<cfset taxamt = taxamt_bil * currrate>
<cfset amt = amt_bil * currrate>
<cfset amt = val(amt)>

<!--- Add on 290908, For 2nd Unit --->
<cfif val(form.factor1) neq 0>
	<cfset xprice = (xprice * val(form.factor2)) / val(form.factor1)>
<cfelse>
	<cfset xprice = 0>
</cfif>
<!--- Add on 290908, For 2nd Unit --->
<cfif val(form.factor2) neq 0>
	<cfset act_qty = val(form.qty) * val(form.factor1) / val(form.factor2)>
<cfelse>
	<cfset act_qty = 0>
</cfif>

<!--- REMARK ON 290908 --->
<!--- <cfquery name="getitem" datasource="#dts#">
	select 
	category,
	wos_group,
	wserialno 
	from icitem 
	where itemno='#form.itemno#';
</cfquery> --->

<cfquery name="getitem" datasource="#dts#">
	select 
	category,
	wos_group,
	wserialno,
	unit 
	from icitem 
	where itemno='#form.itemno#'
</cfquery>

<cfif form.mode eq "Delete">
	<!---DELETE TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess_delete.cfm">
	<!---DELETE TRANSACTION PROCESS --->
<cfelseif form.mode eq "Add">
	<!---ADD TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess_add.cfm">
	<!---ADD TRANSACTION PROCESS --->
<cfelseif form.mode eq "Edit">
	<!---EDIT TRANSACTION PROCESS --->
	<cfinclude template = "transactionprocess_edit.cfm">
	<!---EDIT TRANSACTION PROCESS --->
</cfif>	

<!--- After sucessfully update on the artran and ictran, system will check if additional --->
<!--- work need to be done otherwise, it will proceed to page "transaction3.cfm --->
<cfif getitem.wserialno eq "T" and (tran neq "QUO" and tran neq "SO" and tran neq "PO" and tran neq "SAM")>
	<cfinclude template = "transactionprocess_check_serial_process.cfm">
<cfelse>
	<cfinclude template = "transactionprocess_check_default_process.cfm">
</cfif>