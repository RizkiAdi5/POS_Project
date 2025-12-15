<cfsetting showdebugoutput="no">
<cfset uuid = url.uuid>
<cfquery name="getsumictrantemp" datasource="#dts#">
SELECT sum(qty_bil)as sumqty FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>

<cfoutput>
<label for="totalitem" id="ttlItem">Total Item:</label>    
<label for="totalitemamonut" id="ttlItmAmt">#getsumictrantemp.sumqty#</label>     
</cfoutput>
