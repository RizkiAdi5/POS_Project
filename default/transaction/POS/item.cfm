
<cfquery name="getitem" datasource="#dts#">
	SELECT itemno,desp,despa,price 
    FROM icitem
    WHERE itemno="#url.itemno#";
</cfquery>


<cfoutput>
<input type="text" name="hiditemno" id="hiditemno" value="#getitem.itemno#">
<input type="text" name="hiddesp" id="hiddesp" value="#getitem.desp#">
<input type="text" name="hiddespa" id="hiddespa" value="#getitem.desp#">
<input type="text" name="hidprice" id="hidprice" value="#getitem.price#">
</cfoutput>
