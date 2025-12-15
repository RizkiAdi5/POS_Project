<cfset records_per_page=10>
<cfset page_links_shown=5>
<cfset start_page=1>
<cfset begin_page=1>
<cfset sType="">
<cfset sFor="">

function setdate()
	{	
    <cfset sort="date">
	}

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
	<cfset records_per_page=10>
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

<cfquery name="getData" datasource="main">
	select SQL_CALC_FOUND_ROWS * from
	(
		Select * from info 
		
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="get_count" datasource="main">
 	SELECT FOUND_ROWS() as records
</cfquery>

<cfset total_pages=ceiling(get_count.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<html>
<head>
<title>View <cfoutput>Update</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

</head>

<body>
<!--- <cfif isdefined("url.type")> --->
<!--- <cfset typeNo="title"> 
			<cfset link = #url.type# &".cfm"> --->
            
<cfquery datasource='#dts#' name="getPersonnel">
				select SQL_CALC_FOUND_ROWS * from
	(
		Select * from info 
		
	) as r order by type
	LIMIT #start_record#, #records_per_page#
    
			</cfquery>
			<!--- <cfset type = #url.type#> --->
<!--- <cfelse> --->
			<!--- <cfset typeNo=#type# & "No"> 
			<cfset link = #type# &".cfm">
 --->
			<!--- <cfquery datasource='#dts#' name="getPersonnel">
				Select * from info order by title
			</cfquery> --->
						
<!--- </cfif> --->
			
			<cfparam name="start" default="1">
			<cfparam name="page" default="1">
			<cfparam name="prevFive" default="0">
			<cfparam name="nextFive" default="0">
			<cfoutput>
  <h1>View Update Informations</h1>
</cfoutput>
<cfoutput>
  <h4><cfif getpin2.h1810 eq 'T'><a href="update2.cfm?type=Create">Creating a Update</a> </cfif>
  <cfif getpin2.h1820 eq 'T'>
      || <a href="update.cfm?">Edit &amp; Delate Update</a> </cfif>
     
      </h4>
</cfoutput>
  <cfform action="update.cfm" method="post">
   
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
					<cfif begin_page neq 1><cfoutput>|| <a href="update.cfm?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Previous</a> ||</cfoutput></cfif>
					<cfif begin_page neq total_pages><cfoutput><a href="update.cfm?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Next</a> ||</cfoutput></cfif>
				</cfif>
				<cfoutput>Page #begin_page# Of #total_pages#</cfoutput>			
			</div>
    
    <hr>
    <cfif isdefined("url.process")>
      <cfoutput>
        <h1>#form.status#</h1>
        <hr>
      </cfoutput> 
    </cfif>
    
  <cfif isdefined("form.status")><div class="pageMessage" align="center"><cfoutput><font color="red">#form.status#</font></cfoutput></div></cfif>
			<table width="80%" align="center" class="data">
				<tr>
					<th width="50px">Date</th>
					<th width="80px">Title</th>
					<th >Type</th>
					<th width="40">Desp</th>
					<th width="80px">Action</th>
				</tr>
				<cfif getPersonnel.recordcount>
					<cfoutput query="getPersonnel">
                    <cfset strNo = "getPersonnel.title">
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td>#dateformat(getPersonnel.date,"dd/mm/yyyy")#</td>
						<td align="left">#getPersonnel.title#</td>
						<td>#getPersonnel.type#</td>
						<td >#getPersonnel.desp#</td>
						<td align="left">
						<a href="update2.cfm?type=Edit&title=#evaluate(strNo)#">Edit</a>  ||
						<a href="update2.cfm?type=Delete&title=#evaluate(strNo)#">Delete</a></td> 
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
					&nbsp;<a href="update.cfm?page=1&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[First Page]</a>
					&nbsp;<a href="update.cfm?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Previous]</a>
				</cfif>
		
				<cfif begin_page+int(show_pages/2)-1 GTE total_pages>
					<cfset start_page=total_pages-show_pages+1>
				<cfelseif begin_page+1 GT show_pages>
					<cfset start_page=begin_page-int(show_pages/2)>
				</cfif>
				<cfset end_page=start_page+show_pages-1>
				<cfloop from="#start_page#" to="#end_page#" index="i">
					<cfif begin_page EQ i><font color="##990033">#i#</font><cfelse><a href="update.cfm?page=#i#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">#i#</a></cfif>
				</cfloop>
		
				<cfif begin_page*records_per_page LT get_count.records>
					&nbsp;<a href="update.cfm?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
					&nbsp;<a href="update.cfm?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
				<cfelse>
					&nbsp;[Next]
				</cfif>
			</div>
		</cfoutput>		
	</div>
</body>
</html>
