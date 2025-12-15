<html>
<head></head>
<body>


        <cfquery name="altertable1" datasource="#dts#">
        update taxcode set code="TX" where code="TX7"
        </cfquery>
        
        <cfquery name="altertable2" datasource="main">
        update taxcode set code="TX" where code="TX7"
        </cfquery>
        
        <cfquery name="altertable3" datasource="#dts#">
        update taxtable set code="TX" where code="TX7"
        </cfquery>
        
        <cfquery name="altertable4" datasource="#dts#">
        update artran set note="TX" where note="TX7"
        </cfquery>
        
        <cfquery name="altertable5" datasource="#dts#">
        update ictran set note_a="TX" where note_a="TX7"
        </cfquery>
        
        <cfquery name="altertable5" datasource="#dts#">
        update gsetup set df_salestax="TX" where df_salestax="TX7"
        </cfquery>
        
        <cfquery name="altertable5" datasource="#dts#">
        update gsetup set df_salestaxzero="TX" where df_salestaxzero="TX7"
        </cfquery>
        
        <cfquery name="altertable5" datasource="#dts#">
        update gsetup set df_purchasetax="TX" where df_purchasetax="TX7"
        </cfquery>
        
        <cfquery name="altertable5" datasource="#dts#">
        update gsetup set df_purchasetaxzero="TX" where df_purchasetaxzero="TX7"
        </cfquery>

<script type="text/javascript">
alert('Update Complete!');
window.location.href="/index.cfm";
</script>

    

Finish.

</body>
</html>