<cfoutput>
    <cftry>	
        <cfquery name="updateUserDefined" datasource="#dts#">
            UPDATE userdefault
            SET
                inv_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.INVdesp)#">,
                do_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DOdesp#">,
                so_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SOdesp#">,
                quo_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QUOdesp#">,
                cs_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSdesp#">,
                cn_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CNdesp#">,
                dn_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DNdesp#">,
                po_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.POdesp#">,
                
                rq_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RQdesp#">,
                pr_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRdesp#">,
                rc_desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCdesp#">
                
            WHERE company = 'IMS'; 
        </cfquery>
        
        <cfquery name="updateExtraRemark" datasource="#dts#">
            UPDATE extraremark
            SET
                <cfloop index="i" from="30" to="49">  
                	rem#i#= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.headerRemark#i#')#">,
                </cfloop>
                
                <cfloop index="i" from="0" to="11">  
                	trrem#i#= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remark#i#')#"> <cfif i NEQ 11>,</cfif>
                </cfloop>
        </cfquery> 
        
        <cfquery name="updateGsetup" datasource="#dts#">
            UPDATE gsetup
            SET
            	refno2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refNo2#">,
                ldescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
				<cfloop index="i" from="5" to="11"> 
                	rem#i#= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.headerRemark#i#')#">,
                </cfloop>
                                
                <cfloop index="i" from="1" to="4">  
                	brem#i#= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.bodyRemark#i#')#">,
                </cfloop>
                
                <cfloop index="i" from="1" to="7">  
                	misccharge#i#= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.miscCharge#i#')#"><cfif i NEQ 7>,</cfif>
                </cfloop>
        </cfquery> 
               
    <cfcatch type="any">
        <script type="text/javascript">
            alert('Failed to update setup(s)!\nError Message: #cfcatch.message#');
            window.open('/latest/generalSetup/generalInfoSetup/userDefined','_self');
        </script>
    </cfcatch>
    </cftry>
    
    <script type="text/javascript">
        alert('Updated setup(s) successfully!');
        window.open('/latest/body/bodymenu.cfm?id=60100','_self');
    </script>	
</cfoutput>