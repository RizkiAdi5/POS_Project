<cfoutput>
	<cftry>
    	<cfif Hlinkams eq "Y">
            <cfquery name="updateCompanyProfileAMS" datasource="#replaceNoCase(dts,'_i','_a','all')#">
                UPDATE gsetup
                SET
                    compro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.compro)#">,
                    compro2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro2#">,
                    compro3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro3#">,
                    compro4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro4#">,
                    compro5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro5#">,
                    compro6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro6#">,
                    compro7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro7#">,
                    comuen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comUEN#">,

                    gstno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gstno#">,
                    ctycode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currencyCode#">,
                    lastaccyear = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.date,'YYYY-MM-DD')#">,
                    period = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.thisYearClosing#">,

                    debtorfr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.debtorFrom#">,
                    debtorto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.debtorTo#">,
                    creditorfr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.creditorFrom#">,
                    creditorto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.creditorTo#">

                WHERE companyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.companyID)#">;
            </cfquery>

            <cfquery name="updateAccount" datasource="mainams">
   				UPDATE useraccountlimit
                SET
   					compro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.compro)#">
    			WHERE companyid = "#replaceNoCase(dts,'_i','_a','all')#";
    		</cfquery>
		</cfif>

        <cfquery name="updateCompanyProfileIMS" datasource="#dts#">
            UPDATE gsetup
            SET
                compro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.compro)#">,
                compro2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro2#">,
                compro3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro3#">,
                compro4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro4#">,
                compro5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro5#">,
                compro6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro6#">,
                compro7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.compro7#">,
                comuen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comUEN#">,
				dflanguage= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.language#">,

                gstno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gstno#">,
                bCurr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currencyCode#">,
                ctycode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currencyCode#">,
                lastaccyear = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.date,'YYYY-MM-DD')#">,
                period = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.thisYearClosing#">,

                debtorfr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.debtorFrom#">,
                debtorto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.debtorTo#">,
                creditorfr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.creditorFrom#">,
                creditorto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.creditorTo#">,
                periodalfr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.periodAllowed#">

            WHERE companyid = 'IMS';
        </cfquery>

        <cfquery name="getGsetup" datasource="#dts#">
            SELECT dflanguage
            FROM gsetup;
        </cfquery>

        <cfif getGsetup.dflanguage NEQ "english">
            <cfset menuname=getGsetup.dflanguage>
            <cfset titledesp="titledesp_"&getGsetup.dflanguage>
        <cfelse>
            <cfset menuname="menu_name">
            <cfset titledesp="titledesp">
        </cfif>

        <cfquery name="updateAccount" datasource="#dts#">
            UPDATE userdefinedmenu a, main.menunew2 b
            SET
				a.new_menu_name = b.#menuName#
            WHERE a.menu_id = b.menu_id
			AND a.changed != '1';
        </cfquery>


        <cfquery name="updateAccount" datasource="main">
            UPDATE useraccountlimit
            SET
                compro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.compro)#">,
                period = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.thisYearClosing#">,
                lastaccyear = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.date,'YYYY-MM-DD')#">
            WHERE companyid = "#dts#";
        </cfquery>

		<cfcatch type="any">
        <script type="text/javascript">
            alert('Failed to update #trim(form.compro)#!\nError Message: #cfcatch.message#');
            window.open('/latest/generalSetup/generalInfoSetup/companyProfile.cfm','_self');
        </script>
    </cfcatch>
    </cftry>
    <script type="text/javascript">
        alert('Updated #trim(form.compro)# successfully!');
      	if(window.self != window.parent){
			parent.location.replace("/index.cfm");
		}
    </script>
</cfoutput>