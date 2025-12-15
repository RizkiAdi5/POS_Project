<cfoutput>
<cfquery name="geteu" datasource="#dts#">
SELECT driverno FROM driver where driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">
</cfquery>
<cfif geteu.recordcount neq 0>
<h1>Member Id already existed</h1>
<cfform name="errorback" id="errorback" method="post" action="neweu.cfm">
<input type="submit" name="sub_btn" id="sub_btn" value="Create New Again">
</cfform> 
<cfabort>
<cfelse>
<cfquery name="insert" datasource="#dts#">
Insert into Driver (driverno,name,contact,add1,add2,add3)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membername#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertel#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd3#">
)
</cfquery>
<script type="text/javascript">
myoption = document.createElement("OPTION");
myoption.text = "#form.memberid# - #form.membername#";
myoption.value = "#form.memberid#";
document.invoicesheet.driver.options.add(myoption);
var indexvalue = document.getElementById("driver").length-1;
document.getElementById("driver").selectedIndex=indexvalue;
ColdFusion.Window.hide("neweu");
</script>
</cfif>
</cfoutput>