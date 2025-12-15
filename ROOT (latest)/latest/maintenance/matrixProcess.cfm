<cfif IsDefined('url.mItemNo')>
	<cfset URLmItemNo = trim(urldecode(url.mItemNo))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT mitemno 
            FROM icmitem
			WHERE mitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.matrixItemNo)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.matrixItemNo)# already exist!');
				window.open('/latest/maintenance/matrix.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>	
				<cfquery name="createMatrix" datasource="#dts#">
					INSERT INTO icmitem (colorno,mitemno,aitemno,desp,despa,comment,
                    					 brand,supp,category,wos_group,photo,sizeid,colorid,shelf,
                                         unit,ucost,price,price2,price3,price4,
                                         fcurrcode
                                         <cfloop index="i" from="2" to="10">,fcurrcode#i#</cfloop>
                                         ,fucost
                                         <cfloop index="i" from="2" to="10">,fucost#i#</cfloop>
                                         ,fprice
                                         <cfloop index="i" from="2" to="10">,fprice#i#</cfloop>
                                         <cfloop index="i" from="1" to="30">,remark#i#</cfloop>
                                         <cfloop index="i" from="1" to="20">,color#i#</cfloop>
                                         <cfloop index="i" from="1" to="20">,size#i#</cfloop>,muratio)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.matrixItemNo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.alternateItemNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.despa)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.brand)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.supplier)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.category)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">,
                        <cfif IsDefined('picture_available')>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.picture_available)#">,
                        <cfelse>    
                        	'',
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.material)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.unitOfMeasurement)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitCostPrice)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice1)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice2)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice3)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice4)#">,  
                     	
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.foreignCurrency1)#">
                        <cfloop index="i" from="2" to="10">
                       		<cfset fcurrcodeValue = evaluate('form.foreignCurrency#i#')>	
                        		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(fcurrcodeValue)#">
                        </cfloop>,
                        
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.foreignUnitCostValue1)#">
                        <cfloop index="i" from="2" to="10">
                       		<cfset foreignUnitCost = evaluate('form.foreignUnitCostValue#i#')>
                        		,<cfqueryparam cfsqltype="cf_sql_double" value="#val(foreignUnitCost)#">
                        </cfloop>,
                        
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.foreignSellingPriceValue1)#">
                        <cfloop index="i" from="2" to="10">
                       		<cfset foreignSellingPrice = evaluate('form.foreignSellingPriceValue#i#')>	
                        		,<cfqueryparam cfsqltype="cf_sql_double" value="#val(foreignSellingPrice)#">
                        </cfloop>,
                        
                        <cfloop index="i" from="1" to="30">
                       		<cfset remarkValue = evaluate('form.remark#i#')>	
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(remarkValue)#">,
                        </cfloop>
                        
                        <cfloop index="i" from="1" to="20">
                       		<cfset colorValue = evaluate('form.color#i#')>	
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(colorValue)#">,
                        </cfloop>
                        
                        <cfloop index="i" from="1" to="20">
                       		<cfset sizeValue = evaluate('form.size#i#')>	
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizeValue)#">,
                        </cfloop>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.muRatio)#">
					)
				</cfquery>
                <cfcatch type="any">
                    <script type="text/javascript">
                        alert('Failed to create #trim(form.matrixItemNo)#!\nError Message: #cfcatch.message#');
                        window.open('/latest/maintenance/matrix.cfm?action=create','_self');
                    </script>
                </cfcatch>
       		</cftry>
			<script type="text/javascript">
				alert('#trim(form.matrixItemNo)# has been created successfully!');
				window.open('/latest/maintenance/matrixProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		<cftry>	
			<cfquery name="updateMatrix" datasource="#dts#">
				UPDATE icmitem
				SET
					colorno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorNo)#">,
					mitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.matrixItemNo#">,
                    aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.alternateItemNo#">,
                    desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    despa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
                    comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comment#">,
                    brand = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">,
                    supp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.supplier#">,
                    category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.category#">,
                    wos_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.group#">,
                    photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">,
                    sizeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.size#">,
                    colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.material#">,
                    shelf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.model#">,
                    
                    unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unitOfMeasurement#">,
                    ucost = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitCostPrice)#">,
                    price = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice1)#">,
                    price2 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice2)#">,
                    price3 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice3)#">,
                    price4 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.unitSellingPrice4)#">,
                
					
                    fcurrcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.foreignCurrency1)#">
                    <cfloop index="i" from="2" to="10">
                        <cfset fcurrcodeValue = evaluate('form.foreignCurrency#i#')>	
                            ,fcurrcode#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(fcurrcodeValue)#">
                    </cfloop>,
                    
                    fucost = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.foreignUnitCostValue1)#">
                    <cfloop index="i" from="2" to="10">
                        <cfset foreignUnitCost = evaluate('form.foreignUnitCostValue#i#')>	
                            ,fucost#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(foreignUnitCost)#">
                    </cfloop>,
                    
                    fprice = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.foreignSellingPriceValue1)#">
                    <cfloop index="i" from="2" to="10">
                        <cfset foreignSellingPrice = evaluate('form.foreignSellingPriceValue#i#')>	
                            ,fprice#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(foreignSellingPrice)#">
                    </cfloop>,
                    
                     <cfloop index="i" from="1" to="30">
                        <cfset remarkValue = evaluate('form.remark#i#')>	
                        remark#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(remarkValue)#">,
                    </cfloop>
                    
                    <cfloop index="i" from="1" to="20">
                        <cfset colorValue = evaluate('form.color#i#')>	
                        color#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(colorValue)#">,
                    </cfloop>
                    
                    <cfloop index="i" from="1" to="20">
                        <cfset sizeValue = evaluate('form.size#i#')>	
                        size#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizeValue)#">,
                    </cfloop>
                   
                    muratio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.muRatio)#">
				WHERE mitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.matrixItemNo)#">;
			</cfquery>
            <cfcatch type="any">
                <script type="text/javascript">
                    alert('Failed to create #trim(form.matrixItemNo)#!\nError Message: #cfcatch.message#');
                    window.open('/latest/maintenance/matrix.cfm?action=update','_self');
                </script>
            </cfcatch>
        </cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.matrixItemNo)# successfully!');
			window.open('/latest/maintenance/matrixProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteMatrix" datasource="#dts#">
				DELETE FROM icmitem
				WHERE mitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLmItemNo#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLmItemNo#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/matrixProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLmItemNo# successfully!');
			window.open('/latest/maintenance/matrixProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printSize" datasource="#dts#">
			SELECT mitemno,desp
			FROM icmitem
			ORDER BY mitemno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Matrix Listing</title>
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
			<h1 class="text">Matrix Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>MATRIX NO</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printSize">
				<tr>
					<td>#mitemno#</td>
					<td>#desp#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>Printed at #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/matrixProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/matrixProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>