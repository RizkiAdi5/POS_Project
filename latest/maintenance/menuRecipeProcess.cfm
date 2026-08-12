<cfif NOT IsDefined('form.itemCode') OR trim(form.itemCode) EQ "">
	<cfoutput>
	<script type="text/javascript">
		alert('No menu item specified.');
		window.open('/latest/maintenance/menuRecipeProfile.cfm?menuID=#form.menuID#','_self');
	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfset URLitemCode = trim(form.itemCode)>
<cfset URLmenuID = IsDefined('form.menuID') ? form.menuID : "">
<cfset maxIdx = IsDefined('form.maxRowIndex') ? val(form.maxRowIndex) : -1>

<cfoutput>
<cftry>
	<cftransaction>
		<cfquery name="deleteRecipe" datasource="#dts#">
			DELETE FROM app_menu_recipes
			WHERE item_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemCode#">
		</cfquery>

		<cfif maxIdx GTE 0>
			<cfloop index="i" from="0" to="#maxIdx#">
				<cfif IsDefined("form.material_id#i#") AND IsDefined("form.qty#i#")
					AND len(trim(evaluate('form.material_id#i#')))
					AND val(evaluate('form.qty#i#')) GT 0>
					<cfquery name="insertRecipeLine" datasource="#dts#">
						INSERT INTO app_menu_recipes (item_code, material_id, qty_per_unit)
						VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemCode#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#val(evaluate('form.material_id#i#'))#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" scale="3" value="#val(evaluate('form.qty#i#'))#">
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>

	<script type="text/javascript">
		alert('Recipe for #URLitemCode# saved successfully!');
		window.open('/latest/maintenance/menuRecipeProfile.cfm?menuID=#URLmenuID#','_self');
	</script>

	<cfcatch type="any">
		<script type="text/javascript">
			alert('Failed to save recipe!\nError Message: #cfcatch.message#');
			window.open('/latest/maintenance/menuRecipe.cfm?itemno=#URLitemCode#&menuID=#URLmenuID#','_self');
		</script>
	</cfcatch>
</cftry>
</cfoutput>
