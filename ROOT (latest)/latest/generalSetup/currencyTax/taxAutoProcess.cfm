<cfif HlinkAMS eq "Y">
	<cfset dts = replace(LCASE(dts),'_i','_a','all')> 
<cfelse>
	<cfset dts = dts>
</cfif>

<cfoutput>
	<cftry>
		<cfif isdefined("form.gsttax")>
			<cfloop index="codeid" list="#form.gsttax#">
				<cfquery name="checkTaxCode" datasource="#dts#">
					SELECT code 
					FROM taxtable 
					WHERE code='#codeid#';
				</cfquery>
				<cfif checkTaxCode.recordcount eq 0>
					<cfquery name="insertTaxCode" datasource="#dts#">
						INSERT INTO taxtable(code,desp,rate1,corr_accno,tax_type,tax_type2)
						VALUES
								(
									'#codeid#',
									'#form["desp"&codeid]#',
									'#form["rate"&codeid]#',
									'#form["corr_accno"&codeid]#',
									'#form["type"&codeid]#',
									'#form["type2"&codeid]#'
								)	
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
     <cfcatch type="any">
		<script type="text/javascript">
            alert('Failed to generate!\nError Message: #cfcatch.message#');
            window.open('/latest/generalSetup/currencyTax/taxAuto.cfm','_self');
        </script>
    </cfcatch>    
	</cftry>
	<script type="text/javascript">
		alert('Generated successfully!');
		window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
	</script>
</cfoutput>