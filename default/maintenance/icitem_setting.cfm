<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Icitem Selection Page</h1>
<h4>
	<cfif getpin2.h1310 eq 'T'>
		<a href="icitem2.cfm?type=Create">Creating a New Item</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="icitem.cfm?">List all Item</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_icitem.cfm?type=icitem">Search For Item</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_icitem.cfm">Item Listing</a> 
	</cfif>
	  	|| <a href="icitem_setting.cfm">More Setting</a>
	
</h4><br><br><br>

<table border="0" class="data" align="center">
	<tr> 
    	<td colspan="4"><div align="center"><strong>Item Setting</strong></div></td>
  	</tr>
  	<tr> 
    	<th width="45">S/No.</th>
    	<th width="129">Title</th>
    	<th width="445">Description</th>
    	<th width="94">Action</th>
  	</tr>
    <cfif getpin2.h1370 eq 'T'>
  	<tr> 
    	<td>1</td>
    	<td>Supplier/Item Price</td>
    	<td>Function that will automatically return price that is unique to particular supplier</td>
    	<td><a href="icitem/itemsupprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
    </cfif>
    <cfif getpin2.h1380 eq 'T'>
  	<tr> 
    	<td height="35">2</td>
    	<td>Customer/Item Price</td>
    	<td>Function that will automatically return price that is unique to particular customer</td>
    	<td><a href="icitem/itemcustprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
    </cfif>
    <cfif getpin2.h1390 eq 'T'>
  	<tr> 
    	<td>3</td>
    	<td>Item/Supplier Price</td>
    	<td>Function that will automatically return price that is unique to particular supplier</td>
		<td><a href="icitem/suppitemprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
    </cfif>
    <cfif getpin2.h13A0 eq 'T'>
  	<tr> 
    	<td height="34">4</td>
    	<td>Item/Customer Price</td>
    	<td>Function that will automatically return price that is unique to particular customer</td>
    	<td><a href="icitem/custitemprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
    </cfif>
</table>

</body>
</html>