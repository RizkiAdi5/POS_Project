<html>
<head>
<title>Item - Customer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource="#dts#" name="getcust">
	select name,currcode from #target_arcust# where custno = '#custno#'
</cfquery>

<cfquery datasource="#dts#" name="getinfo">
	select * from icl3p2 where custno = '#custno#' and itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>

<cfif url.type1 eq "Add">
	<cfif getinfo.recordcount GT 0>
		<div align="center"><h3>You have added this item before.</h3>
		<input type="button" name="back" value="back" onClick="javascript:history.back()"></div>
		<cfabort>
	</cfif>
</cfif>

<cfif url.type1 eq "Delete">
	<cfset price=getinfo.price>
	<cfset dis1=getinfo.dispec>
	<cfset dis2=getinfo.dispec2>
	<cfset dis3=getinfo.dispec3>
	<cfset note=getinfo.ci_note>
	<cfset mode1="Delete">
	<cfset button="Delete">
</cfif>

<cfif url.type1 eq "Edit">
	<cfset price=getinfo.price>
	<cfset dis1=getinfo.dispec>
	<cfset dis2=getinfo.dispec2>
	<cfset dis3=getinfo.dispec3>
	<cfset note=getinfo.ci_note>
	<cfset mode1="Edit">
	<cfset button="Edit">
</cfif>

<cfif url.type1 eq "Add">
	<cfset price="0">
	<cfset dis1="0">
	<cfset dis2="0">
	<cfset dis3="0">
	<cfset note="">
	<cfset mode1="Add">
	<cfset button="Add">
</cfif>

<body>
<h1>Recommended Price - Item/Customer</h1>

<cfoutput>
  	<h4>
	<a href="custitemprice2.cfm?type=create">Create a Recommended Price</a> ||
	<a href="custitemprice.cfm">List all Recommended Price</a> ||
	<a href="scustitemprice.cfm">Search Recommended Price</a> ||
	<a href="../icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<cfform name="form1" method="post" action="custitemprocess.cfm">
  	<cfoutput>
    <table width="576" align="center" class="data">
      	<tr>
        	<th colspan="4"><div align="center">Recommended Price Body</div></th>
      	</tr>
      	<tr>
        	<th width="20%">Customer No</th>
        	<td colspan="3">
			<cfif mode1 eq "Delete" or mode1 eq "Edit">
				#url.custno#
			<cfelse>
				#form.custno#
			</cfif>
			</td>
      	</tr>
      	<tr>
        	<th>Name</th>
        	<td colspan="3">#getcust.name#</td>
      	</tr>
	  	<tr>
        	<th>Currency</th>
        	<td colspan="3">#getcust.currcode#</td>
      	</tr>
      	<tr>
        	<td colspan="4"><hr></td>
      	</tr>
      	<tr>
        	<td colspan="4"><div align="center"><strong><font size="2">Price</font></strong></div></td>
      	</tr>
      	<tr>
        	<th nowrap>Recommended Price</th>
        	<td> <cfinput type="text" name="price" value="#Numberformat(price, ".____")#" maxlength="15" size="12" required="yes" validate="float" message="Please key in Recommended Price.">
        	</td>
        	<td></td>
        	<td></td>
      	</tr>
      	<tr>
        	<th>Discount % (1)</th>
        	<td><cfinput type="text" size="4" name="dis1" value="#Numberformat(dis1, ".__")#" maxlength="5" required="yes" validate="float" message="Please key in Discount 1 (0-99).">
        </td>
        	<td nowrap>&nbsp;</td>
       	 	<td>&nbsp; </td>
      	</tr>
      	<tr>
        	<th>Discount % (2)</th>
        	<td><div align="left">
            	<cfinput type="text" size="4" name="dis2" value="#Numberformat(dis2, ".__")#" maxlength="5" required="yes" validate="float" message="Please key in Discount 2 (0-99).">
          		</div>
			</td>
        	<td>&nbsp;</td>
        	<td nowrap></td>
      	</tr>
      	<tr>
        	<th>Discount % (3)</th>
        	<td colspan="3"><cfinput type="text" size="4" name="dis3" value="#Numberformat(dis3, ".__")#" maxlength="5" required="yes" validate="float" message="Please key in Discount 3 (0-99)."></td>
      	</tr>
      	<tr>
        	<th>Note</th>
        	<td colspan="3"><input name="note" type="text" size="25" maxlength="24" value="#note#"></td>
      	</tr>
      	<tr>
        	<td><div align="left"></div></td>
        	<td colspan="3" align="right"><div align="right">
				<input type="hidden" name="mode" value="#mode#">
				<input type="hidden" name="itemno" value="#itemno#">
				<input type="hidden" name="custno" value="#custno#">
            	<input type="submit" name="mode1" value="#mode1#">
          		</div>
			</td>
      	</tr>
    </table>
  	</cfoutput>
</cfform>
</body>
</html>