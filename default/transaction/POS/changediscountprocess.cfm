<cfquery name="getdiscount" datasource="#dts#">
SELECT disamt_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>
<cfif val(getdiscount.disamt_bil) eq val(url.disamt_bil1)>

<cfelse>
<cfif isdefined('url.trancode')>
<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_Discount = getgsetup2.Decl_Discount>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfquery name="updaterow" datasource="#dts#">
UPDATE ictrantemp SET 
dispec1 = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(url.disp1),stDecl_Discount)#">,
dispec2 = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(url.disp2),stDecl_Discount)#">,
dispec3 = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(url.disp3),stDecl_Discount)#">,
disamt_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(url.disamt_bil1),stDecl_Discount)#">
WHERE 
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfquery name="getitemdetail" datasource="#dts#">
SELECT itemno,unit,currrate,disamt_bil,brem4,qty,qty_bil FROM ictrantemp WHERE 
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfset qtyReal = val(getitemdetail.qty_bil)>

<cfif val(getitemdetail.currrate) eq 0>
<cfset newcurrate = 1>
<cfelse>
<cfset newcurrate = val(getitemdetail.currrate)>
</cfif>

<cfquery name="updateprice" datasource="#dts#">
UPDATE ictrantemp SET 
disamt = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(getitemdetail.disamt_bil) * val(newcurrate),stDecl_UPrice)#">
WHERE 
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfquery name="updateictranqty" datasource="#dts#">
UPDATE ictrantemp SET 
amt_bil = round((price_bil * qty_bil)+0.000001 - disamt_bil,2),
amt1_bil = round((price_bil * qty_bil)+0.000001 - disamt_bil,2)
WHERE 
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
UPDATE ictrantemp SET 
disamt = (disamt_bil * if(currrate = 0,1,currrate)),
amt = round((amt_bil * if(currrate = 0,1,currrate))+0.000001,2),
amt1 = round((amt1_bil * if(currrate = 0,1,currrate))+0.000001,2)
WHERE 
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> and
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfif getgsetup.wpitemtax eq "1">
	<cfquery name="updateictrantax" datasource="#dts#">
	UPDATE ictrantemp SET
        <cfif getgsetup.taxincluded eq "Y">
        TAXAMT_BIL=round((AMT_BIL*(taxpec1/(taxpec1+100))),3),
        TAXAMT=round((AMT*(taxpec1/(taxpec1+100))),3),
        taxincl="T"
        <cfelse>
        TAXAMT_BIL=round((AMT_BIL*(taxpec1/100)),3),
        TAXAMT=round((AMT*(taxpec1/100)),3)
        </cfif>
        where 
        uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
        and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
	</cfquery>
</cfif>


</cfif>
</cfif>