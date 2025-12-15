<html>
<head></head>
<body>

    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table arcust use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table apvend use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icitem use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icgroup use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table iccate use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table brand use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icsizeid use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table iccolorid use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table unit use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table ictran use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table artran use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table project use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table business use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table counter use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table cashier use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
   
   <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icarea use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icagent use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table icservi use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
        <cfquery name="altertable1" datasource="#dts#">
        repair table expresspickitem use_frm
        </cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>



<script type="text/javascript">
alert('Repair Complete!');
window.location.href="/index.cfm";
</script>

    

Finish.

</body>
</html>