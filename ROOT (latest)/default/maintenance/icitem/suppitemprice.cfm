<!--- <cfset currentFile=getToken(cgi.PATH_INFO,listlen(cgi.PATH_INFO,"/"),"/")> --->
<cfif findnocase(cgi.script_name,cgi.path_info)>
    <cfset request.path_info = cgi.path_info>
<cfelse>
    <cfset request.path_info = cgi.script_name & cgi.path_info>
</cfif>
<cfset currentFile=getToken(request.path_info,listlen(request.path_info,"/"),"/")>
<cfset records_per_page=20>
<cfset page_links_shown=5>
<cfset start_page=1>
<cfset begin_page=1>
<cfset sType="">
<cfset sFor="">

<cfif isdefined("form.sType") and isdefined("form.sFor")>
	<cfset sType=form.sType><cfset sFor=URLEncodedFormat(form.sFor)>
<cfelseif isdefined("url.st") and isdefined("url.sf")>
	<cfset sType=url.st><cfset sFor=URLEncodedFormat(url.sf)>
</cfif>

<cfif isdefined("form.results_list")>
	<cfset records_per_page=form.results_list>
<cfelseif isdefined("url.list")>
	<cfset records_per_page = url.list>
<cfelse>
	<cfset records_per_page=20>
</cfif>

<cfif isdefined("form.skeypage")>
	<cfset begin_page = form.skeypage>
	<cfif form.skeypage eq 1>
		<cfset begin_page=1>
	</cfif>
<cfelseif isdefined("url.page")>
	<cfset begin_page=url.page>
<cfelse>
	<cfset url.page=1>
</cfif>

<cfset start_record=begin_page*records_per_page-records_per_page>

<cfquery name="getData" datasource="#dts#">
	select SQL_CALC_FOUND_ROWS * from
	(
		Select a.*,b.desp as itemdesp,b.nonstkitem,b.category,b.wos_group,b.brand,b.sizeid,b.colorid,b.shelf,b.costcode,b.ucost from Icl3p a, icitem b where a.itemno = b.itemno group by a.itemno order by a.itemno
		
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="get_count" datasource="#dts#">
 	SELECT FOUND_ROWS() as records
</cfquery>

<cfset total_pages=ceiling(get_count.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<html>
<head>
<title>Recommended Price Selection Page - Item / Customer</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/table.js"></script>
</head>

<!--- <cfquery datasource="#dts#" name="getinfo">
	select * from icl3p group by itemno order by itemno
</cfquery> --->

<body>
<h1>Recommended Price - Item/Supplier</h1>

<h4>
	<a href="suppitemprice2.cfm?type=create"> Create a Recommended Price</a> ||
	<a href="suppitemprice.cfm">List All Recommended Price</a> ||
	<a href="ssuppitemprice.cfm">Search Recommended Price</a> ||
	<a href="../icitem_setting.cfm">More Setting</a>
</h4>

<div id="container">
<cfform name="form1" action="#currentFile#?list=" method="post" onsubmit="return checkValue();">
	<cfoutput>
	<input type="hidden" name="sType" value="#URLDecode(variables.sType)#">
	<input type="hidden" name="sFor" value="#URLDecode(variables.sFor)#">
	</cfoutput>
			
	<div class="ttype4" align="right">
		<strong id='Display_sel' style="visibility:hidden">Display 
		<select name="results_list">
			<option value="20">20</option>
			<option value="50" <cfif records_per_page eq '50'>selected</cfif>>50</option>
			<option value="100" <cfif records_per_page eq '100'>selected</cfif>>100</option>
		</select> results per page.
		<input type="submit" name="submit" value="Submit">
		</strong>
		<cfif total_pages gt 1>
			Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field." onChange="document.getElementById('Display_sel').style.visibility='visible'">
			<cfif begin_page neq 1><cfoutput>|| <a href="#currentFile#?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Previous</a> ||</cfoutput></cfif>
			<cfif begin_page neq total_pages><cfoutput><a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Next</a> ||</cfoutput></cfif>
			</cfif>
			<cfoutput>Page #begin_page# Of #total_pages#</cfoutput>			
	</div>
	<hr>
	
	<table width="90%" align="center" class="data">
		<tr>
			<th>Item No</th>
			<th>Description</th>
			<th>Status</th>
            <th>Brand</th>
            <th>Category</th>
            <th>Size</th>
            <th>Rating</th>
            <th>Material</th>
            <th>Group</th>
            <th>Model</th>
            <cfif getpin2.h13B0 eq 'T'>
            <th>Price</th>
            <th>UCost</th>
            </cfif>
			<th><div align="center">Action</div></th>
		</tr>
		<cfif getData.recordcount>
			<cfoutput query="getData">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td>#getData.itemno#</td>
					<td>#getData.itemdesp#</td>
					<td>#getData.nonstkitem#</td>
                     <td>#getData.brand#</td>
                    <td>#getData.category#</td>
                    <td>#getData.sizeid#</td>
                    <td>#getData.costcode#</td>
                    <td>#getData.colorid#</td>
                    <td>#getData.wos_group#</td>
                    <td>#getData.shelf#</td>
                    <cfif getpin2.h13B0 eq 'T'>
                    <td>#getData.price#</td>
                    <td>#getData.ucost#</td>
                    </cfif>
					<td align="left">
					<div align="center">
						<a href="suppitemprice2.cfm?type=Delete&itemno=#URLEncodedFormat(getData.itemno)#&status=#getData.nonstkitem#">
						<img height="18px" width="18px" src="../../../images/delete.ICO" alt="Delete" border="0">Delete</a>
						<a href="suppitemprice3.cfm?type=Edit&itemno=#URLEncodedFormat(getData.itemno)#&status=#getData.nonstkitem#">
						<img height="18px" width="18px" src="../../../images/edit.ICO" alt="Edit" border="0">Edit</a>
					</div>
					</td> 
				</tr>
			</cfoutput>
		<cfelse>
			<tr><td align="center" colspan="4">No Record Found.</td></tr>
		</cfif>
	</table>
</cfform>
<cfoutput>
	<div class="ttype4" align="center">
		<cfif begin_page EQ 1>
			&nbsp;[Previous]
		<cfelse>
			&nbsp;<a href="#currentFile#?page=1&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[First Page]</a>
			&nbsp;<a href="#currentFile#?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Previous]</a>
		</cfif>
		
		<cfif begin_page+int(show_pages/2)-1 GTE total_pages>
			<cfset start_page=total_pages-show_pages+1>
		<cfelseif begin_page+1 GT show_pages>
			<cfset start_page=begin_page-int(show_pages/2)>
		</cfif>
		<cfset end_page=start_page+show_pages-1>
		<cfloop from="#start_page#" to="#end_page#" index="i">
			<cfif begin_page EQ i><font color="##990033">#i#</font><cfelse><a href="#currentFile#?page=#i#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">#i#</a></cfif>
		</cfloop>
		
		<cfif begin_page*records_per_page LT get_count.records>
			&nbsp;<a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
			&nbsp;<a href="#currentFile#?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
		<cfelse>
			&nbsp;[Next]
		</cfif>
	</div>
</cfoutput>		
</div>
<br><hr>
</body>
</html>