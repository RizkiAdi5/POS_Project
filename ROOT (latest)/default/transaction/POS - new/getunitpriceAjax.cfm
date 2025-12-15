<cfsetting showdebugoutput="no">
<cfquery name="getunitprice" datasource="#dts#">
SELECT price,unit2,unit3,unit4,unit5,unit6,priceu2,priceu3,priceu4,priceu5,priceu6 from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>

<cfset unitprice1=getunitprice.price>
<cfif getunitprice.unit2 eq url.unit>
<cfset unitprice1=getunitprice.priceu2>
<cfelseif getunitprice.unit3 eq url.unit>
<cfset unitprice1=getunitprice.priceu3>
<cfelseif getunitprice.unit4 eq url.unit>
<cfset unitprice1=getunitprice.priceu4>
<cfelseif getunitprice.unit5 eq url.unit>
<cfset unitprice1=getunitprice.priceu5>
<cfelseif getunitprice.unit6 eq url.unit>
<cfset unitprice1=getunitprice.priceu6>
</cfif>

<cfoutput>
<input type="hidden" name="priceforunit" id="priceforunit" value="#unitprice1#" />
</cfoutput>