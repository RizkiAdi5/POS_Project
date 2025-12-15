
<cfif isdefined('url.uuid') and isdefined('url.trancode')>
<cfset url.uuid = URLDECODE(url.uuid)>
<cfset url.unit = trim(URLDECODE(url.unit))>
<cfset dispec1=0>
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

<cfset factor1=1>
<cfset factor2=1>

<cfquery name="getitemdetail" datasource="#dts#">
SELECT itemno,price_bil,unit_bil,brem4,dispec1,dispec2,dispec3,qty_bil FROM ictrantemp WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfset xprice=getitemdetail.price_bil>

<cfquery name="selecticitem" datasource="#dts#">
SELECT price,priceu2,priceu3,priceu4,priceu5,priceu6,unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemdetail.itemno#" >
</cfquery>

<cfset qtyReal = getitemdetail.qty_bil>
<cfset unit = url.unit>
<cfif unit neq getitemdetail.unit_bil>

<cfif unit eq "#selecticitem.unit#">
<cfset qtyReal = val(getitemdetail.qty_bil)>
<cfset factor1=1>
<cfset factor2=1>
<cfset xprice=selecticitem.price>
<cfelseif unit eq "#selecticitem.unit2#">
<cfset qtyReal = ( val(getitemdetail.qty_bil) * val(selecticitem.factor1) ) / val(selecticitem.factor2)>
<cfset factor1=val(selecticitem.factor1)>
<cfset factor2=val(selecticitem.factor2)>
<cfset xprice=selecticitem.priceu2>
<cfelseif unit eq "#selecticitem.unit3#">
<cfset qtyReal = ( val(getitemdetail.qty_bil) * val(selecticitem.factorU3_a) ) / val(selecticitem.factorU3_b)>
<cfset factor1=val(selecticitem.factorU3_a)>
<cfset factor2=val(selecticitem.factorU3_b)>
<cfset xprice=selecticitem.priceu3>
<cfelseif unit eq "#selecticitem.unit4#">
<cfset qtyReal = ( val(getitemdetail.qty_bil) * val(selecticitem.factorU4_a) ) / val(selecticitem.factorU4_b)>
<cfset factor1=val(selecticitem.factorU4_a)>
<cfset factor2=val(selecticitem.factorU4_b)>
<cfset xprice=selecticitem.priceu4>
<cfelseif unit eq "#selecticitem.unit5#">
<cfset qtyReal = ( val(getitemdetail.qty_bil) * val(selecticitem.factorU5_a) ) / val(selecticitem.factorU5_b)>
<cfset factor1=val(selecticitem.factorU5_a)>
<cfset factor2=val(selecticitem.factorU5_b)>
<cfset xprice=selecticitem.priceu5>
<cfelseif unit eq "#selecticitem.unit6#">
<cfset qtyReal = ( val(getitemdetail.qty_bil) * val(selecticitem.factorU6_a) ) / val(selecticitem.factorU6_b)>
<cfset factor1=val(selecticitem.factorU6_a)>
<cfset factor2=val(selecticitem.factorU6_b)>
<cfset xprice=selecticitem.priceu6>
</cfif>

</cfif>

<cfquery name="updateprice" datasource="#dts#">
UPDATE ictrantemp SET 
price_bil = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xprice#">
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfquery name="getprice" datasource="#dts#">
	SELECT price_bil FROM ictrantemp WHERE 
    trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
    and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfset discountamount = 0 >  

<cfset realamount = numberformat(val(getprice.price_bil) * val(getitemdetail.qty_bil),stDecl_UPrice)>

<cfset disamt_bil1 = (val(getitemdetail.dispec1) / 100) * realamount>
<cfset netamttemp = realamount - disamt_bil1>
<cfset disamt_bil2 = (val(getitemdetail.dispec2) / 100) * netamttemp>
<cfset netamttemp = netamttemp - disamt_bil2>
<cfset disamt_bil3 = (val(getitemdetail.dispec3) / 100) * netamttemp>
<cfset netamttemp = netamttemp - disamt_bil3>
<cfset adiscountamount = disamt_bil1 + disamt_bil2 + disamt_bil3>


<cfquery name="updatediscountamount" datasource="#dts#">
UPDATE ictrantemp SET disamt_bil = "#numberformat(val(adiscountamount),stDecl_UPrice)#"
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>   




<cfquery name="updateictranqty" datasource="#dts#">
UPDATE ictrantemp SET 
qty = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtyReal#">,
unit_bil = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit#">,
factor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor1#">,
factor2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor2#">,
price_bil = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xprice#">,
amt_bil = round((price_bil * qty_bil)+0.000001 - disamt_bil,2),
amt1_bil = round((price_bil * qty_bil)+0.000001,2)
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
UPDATE ictrantemp SET 
disamt = (disamt_bil * if(currrate = 0,1,currrate)),
amt = round((amt_bil * if(currrate = 0,1,currrate))+0.000001,2),
amt1 = round((amt1_bil * if(currrate = 0,1,currrate))+0.000001,2),
price_bil = round((price_bil * if(currrate = 0,1,currrate))+0.000001,2)
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
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


<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt_bil) as sumsubtotal,sum(taxamt_bil) as sumtaxtotal,count(trancode) as notran FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#" />
</cfquery>


<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hidtaxtotal" id="hidtaxtotal" value="#numberformat(getsum.sumtaxtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.notran#" />
</cfoutput>


</cfif>