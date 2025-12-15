<html>
<head>
<title>Product Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--- 	document.form.Tick.value = toString(val(document.form.Tick.value)+1); --->

function selectlist(custno,fieldtype){

            document.getElementById(fieldtype).value=custno;
			
			ajaxFunction(document.getElementById('itemajax'),'/default/maintenance/itemlocationenquireajax.cfm?itemno='+escape(document.getElementById('productfrom').value));
			
			}
</script>

</head>

<cfquery name="getGsetup" datasource="#dts#">
  Select lLOCATION from GSetup
</cfquery>

<body>
<h1 align="center"><cfoutput>#getGsetup.lLOCATION# Listing</cfoutput></h1>
  <cfoutput>
    <h4>
	<cfif getpin2.h1310 eq 'T'>
		<a href="icitem2.cfm?type=Create">Creating a New Item</a> || 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		<a href="icitem.cfm?type=icitem">List all Item</a> ||  
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		<a href="s_icitem.cfm?type=icitem">Search For Item</a> ||  
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		<a href="p_icitem.cfm">Item Listing</a> ||  
	</cfif>
    <cfif hcomid eq "tcds_i">
    <a href="itemlocationenquire.cfm" target="_blank">Item Location Balance Listing</a> ||  
    </cfif>
	<a href="icitem_setting.cfm">More Setting</a> 
	
</h4>
  </cfoutput>

  <table border="0" align="center" width="90%" class="data">
  <tr>
  <th>Item No</th>
  <td><input type="text" name="productfrom" id="productfrom" value="" onKeyUp="ajaxFunction(document.getElementById('itemajax'),'/default/maintenance/itemlocationenquireajax.cfm?itemno='+document.getElementById('productfrom').value);"><input type="button" size="10" value="Ajax Search" onClick="ColdFusion.Window.show('finditem');" /></td>
  </tr>  
  </table>
  <div id="itemajax">
  <table border="0" align="center" width="90%" class="data">
  <tr>
  <th width="30">Location</th>
  <td>
  </td>
  </tr>
  <tr>
  <th>Qty</th>
  <td></td>
  
  </tr>
  </table>
  </div>
</body>
</html>

<cfwindow width="1000" height="600" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="searchitem.cfm?type=Product&fromto=from&itemno={productfrom}" />
