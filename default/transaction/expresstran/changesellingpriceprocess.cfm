<cfquery name="getprice" datasource="#dts#">
SELECT rem8 as price_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>
<cfif val(getprice.price_bil) eq val(form.price_bil1)>
<script type="text/javascript">
ColdFusion.Window.hide('changesellingprice');
</script>
<cfelse>
<cfif isdefined('url.uuid') and isdefined('url.trancode')>
<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_Discount = getgsetup2.Decl_Discount>

<cfquery name="updateprice" datasource="#dts#">
UPDATE ictrantemp SET 
rem8 = <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(form.price_bil1),stDecl_UPrice)#">,
rem7 = "Y"
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>
<script type="text/javascript">
refreshlist();
ColdFusion.Window.hide('changesellingprice');
</script>
</cfif>
</cfif>