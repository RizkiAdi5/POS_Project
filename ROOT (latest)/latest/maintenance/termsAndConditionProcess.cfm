<cfoutput>
<cftry>
	<cfquery name="checkTermsAndCondition" datasource="#dts#">
    	SELECT * 
        FROM ictermandcondition;
    </cfquery>
    
	<cfif checkTermsAndCondition.recordcount EQ 0>
    	<cfquery name="insertTermsAndCondition" datasource="#dts#">
            INSERT INTO ictermandcondition(lrc,lpr,ldo,linv,lcs,lcn,ldn,lpo,lquo,lquo2,lquo3,lquo4,lquo5,lso,lsam) 
            VALUES (
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.irc)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ipr)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ido)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.inv)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ics)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.icn)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.idn)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ipo)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo2)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo3)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo4)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo5)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iso)#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.isam)#">)
		</cfquery>        
    <cfelse>
        <cfquery name="updateTermsAndCondition" datasource="#dts#">
            UPDATE ictermandcondition
            SET
                lrc=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.irc)#">,
                lpr=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ipr)#">,
                ldo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ido)#">,
                linv=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.inv)#">,
                lcs=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ics)#">,
                lcn=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.icn)#">,
                ldn=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.idn)#">,
                lpo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ipo)#">,
                lquo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo)#">,
                lquo2=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo2)#">,
                lquo3=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo3)#">,
                lquo4=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo4)#">,
                lquo5=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iquo5)#">,
                lso=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.iso)#">,
                lsam=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.isam)#">;
        </cfquery>
    </cfif>
<cfcatch type="any">
    <script type="text/javascript">
        alert('Failed to update !\nError Message: #cfcatch.message#');
        window.open('/latest/maintenance/termsAndCondition.cfm','_self');
    </script>
</cfcatch>
</cftry>
<script type="text/javascript">
    alert('Updated successfully!');
    window.open('/latest/body/bodymenu.cfm?id=10400','_self');
</script>	
</cfoutput>