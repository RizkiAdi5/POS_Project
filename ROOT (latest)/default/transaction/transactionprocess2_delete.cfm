<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
	<cfset obtype= "bth_qin">
<cfelse>
	<cfset obtype= "bth_qut">
</cfif>

<cfloop from="1" to="#ArrayLen(locationArray)#" index="i">
	<cfquery name="checkexist" datasource="#dts#">
		select * from ictran
		where type='#tran#' 
		and refno='#nexttranno#' 
		and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		and location = '#locationArray[i]#'
	</cfquery>
	
	<cfset oldqty = val(oldqtyArray[i])>
	<cfset oldbatchcode = oldbatchArray[i]>
	
	<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfif trim(oldbatchcode) neq "">	<!--- Oldbatchcode neq Empty --->
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#-#oldqty#) 
				where batchcode='#oldbatchcode#' 
				and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
			</cfquery>
			<cfquery name="updateobbatch" datasource="#dts#">
				update lobthob set 
				#obtype#=(#obtype#-#oldqty#) 
				where location = '#locationArray[i]#'
				and batchcode='#oldbatchcode#' 
				and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
			</cfquery>				
		</cfif>
	</cfif>
</cfloop>

<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
	<cfif lcase(HUserID) neq "kellysteel2">
		<cfquery datasource="#dts#" name="getinfo">
			select sum(qty) as act_qty from ictran 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and ( linecode <>  'SV' or linecode is null)
			and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		</cfquery>
		<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
			
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=(#qname#-#getinfo.act_qty#) 
			where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		</cfquery>
	</cfif>
</cfif>

<cfquery name="deleteserial" datasource="#dts#">
	delete from iserial 
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
</cfquery>

<cfquery name="deleteiclink" datasource="#dts#">
	delete from iclink 
	where type='#tran#'
	and refno='#nexttranno#'
	and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
</cfquery>	
<cfif getGeneralInfo.asvoucher eq "Y">
<cfquery name="checkvoucher" datasource="#dts#">
SELECT voucherno FROM ictran 
where itemno='#form.itemno#' 
	and refno='#nexttranno#' 
	and type='#tran#' 
	and itemcount='#itemcount#';
</cfquery>
<cfif checkvoucher.voucherno neq "">
<cfquery name="deletevoucher" datasource="#dts#">
DELETE FROM voucher where voucherid = "#checkvoucher.voucherno#"
</cfquery>
</cfif>
</cfif>
<cfquery name="deleteitem" datasource="#dts#">
	delete from ictran 
	where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
	and refno='#nexttranno#' 
	and type='#tran#' 
</cfquery>

<cfquery name="getLast" datasource="#dts#">
	select itemcount from ictran 
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#' 
	order by itemcount
</cfquery>

<cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(getLast.itemcount)#"/>

<cfif wpitemtax eq "Y">
	<cfquery name="gettax" datasource="#dts#">
    	select sum(taxamt_bil) as tt_taxamt_bil from ictran where type='#tran#' and refno='#nexttranno#' and (void='' or void is null)
    </cfquery>
    <cfquery name="updatetax" datasource="#dts#">
    	update artran set tax_bil='#val(gettax.tt_taxamt_bil)#' where type='#tran#' and refno='#nexttranno#'
    </cfquery>
</cfif>

<cfset status = "Item Deleted Successfully">