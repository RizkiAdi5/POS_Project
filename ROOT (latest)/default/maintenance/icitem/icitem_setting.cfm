<html>
<head>
<title>Icitem Selection Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Icitem Selection Page</h1>

<cfoutput>
	<h4>
	<a href="icitem2.cfm?type=Create">Creating a New Item</a> ||
	<a href="icitem.cfm?">List all Item</a> ||
	<a href="s_icitem.cfm?type=icitem">Search For Item</a> ||
	<a href="icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<br><br>
<br>

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
  	<tr>
    	<td>1</td>
    	<td>Item Number History</td>
    	<td>Function That Help User To Identify Similar Product With Different Item.No</td>
    	<td><a href="icitem/itemhistory.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
  	<tr>
    	<td>2</td>
    	<td>Supplier/Item Price</td>
    	<td>Function That Will Automatically Return Price That Is Unique To Particular Supplier</td>
    	<td><a href="icitem/itemsupprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
  	<tr>
    	<td height="35">3</td>
    	<td>Customer/Item Price</td>
    	<td>Function That Will Automatically Return Price That Is Unique To Particular Customer</td>
    	<td><a href="icitem/itemcustprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
  	<tr>
    	<td>4</td>
    	<td>Item/Supplier Price</td>
    	<td>Function That Will Automatically Return Price That Is Unique To Particular Supplier</td>
    	<td><a href="icitem/suppitemprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
  	<tr>
    	<td height="34">5</td>
    	<td>Item/Customer Price</td>
    	<td>Function That Will Automatically Return Price That Is Unique To Particular Customer</td>
    	<td><a href="icitem/custitemprice.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
  	<tr>
    	<td height="34">6</td>
    	<td>Comment Maintainence</td>
    	<td>Maintain the comment</td>
    	<td><a href="commenttable.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Click Here</a></td>
  	</tr>
</table>
</body>
</html>