<cfif IsDefined('url.material_id')>
	<cfset URLmaterialId = trim(urldecode(url.material_id))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cftry>
			<cfquery name="createMaterial" datasource="#dts#">
				INSERT INTO app_raw_materials (material_name,unit,stock_qty,reorder_level)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.materialName)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.unit)#">,
					<cfqueryparam cfsqltype="cf_sql_decimal" scale="3" value="#val(form.stockQty)#">,
					<cfif len(trim(form.reorderLevel))>
						<cfqueryparam cfsqltype="cf_sql_decimal" scale="3" value="#val(form.reorderLevel)#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_decimal" scale="3" null="true">
					</cfif>
				)
			</cfquery>
			<script type="text/javascript">
				alert('#trim(form.materialName)# has been created successfully!');
				window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to create #trim(form.materialName)#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/rawMaterial.cfm?action=create&menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
	<cfelseif url.action EQ "update">
		<cftry>
			<cfquery name="updateMaterial" datasource="#dts#">
				UPDATE app_raw_materials
				SET
					material_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.materialName)#">,
					unit=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.unit)#">,
					stock_qty=<cfqueryparam cfsqltype="cf_sql_decimal" scale="3" value="#val(form.stockQty)#">,
					reorder_level=<cfif len(trim(form.reorderLevel))><cfqueryparam cfsqltype="cf_sql_decimal" scale="3" value="#val(form.reorderLevel)#"><cfelse><cfqueryparam cfsqltype="cf_sql_decimal" scale="3" null="true"></cfif>
				WHERE material_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#URLmaterialId#">;
			</cfquery>
			<script type="text/javascript">
				alert('Updated #trim(form.materialName)# successfully!');
				window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to update #trim(form.materialName)#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/rawMaterial.cfm?action=update&menuID=#URLmenuID#&material_id=#URLmaterialId#','_self');
				</script>
			</cfcatch>
		</cftry>
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteMaterial" datasource="#dts#">
				DELETE FROM app_raw_materials
				WHERE material_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#URLmaterialId#">
			</cfquery>
			<script type="text/javascript">
				alert('Deleted successfully!');
				window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
	<cfelseif url.action EQ "print">

		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro
            FROM gsetup;
		</cfquery>

		<cfquery name="printMaterial" datasource="#dts#">
			SELECT material_name,unit,stock_qty,reorder_level
			FROM app_raw_materials
			ORDER BY material_name;
		</cfquery>
        <cfoutput>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>#url.pageTitle# Listing</title>
            <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
            <!--[if lt IE 9]>
                <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
                <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
            <![endif]-->
            <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>

		<div class="container">
            <div class="page-header">
                <h1 class="text">#url.pageTitle# Listing</h1>
                <p class="lead">Company: #getGsetup.compro#</p>
            </div>
            <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>MATERIAL NAME</th>
                        <th>UNIT</th>
                        <th>STOCK QTY</th>
                        <th>REORDER LEVEL</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printMaterial">
                    <tr>
                        <td>#material_name#</td>
                        <td>#unit#</td>
                        <td>#NumberFormat(stock_qty,"0.000")#</td>
                        <td>#len(trim(reorder_level)) ? NumberFormat(reorder_level,"0.000") : ""#</td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
            </div>
            <div class="panel-footer">
                <p>Printed at #DateFormat(NOW(),'dd-mm-yyyy')#, #TimeFormat(NOW(),'HH:MM:SS')#</p>
            </div>
		</div>
		</body>
		</html>
        </cfoutput>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/rawMaterialProfile.cfm?menuID=#URLmenuID#','_self');
	</script>
</cfif>
</cfoutput>
