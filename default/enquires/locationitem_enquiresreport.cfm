<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Item Balance Enquires</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>


<cfquery datasource="#dts#" name="getitem">

 <CFIF form.choose is "Submit">  
	<!--- <cfif isdefined("form.url.itemno1")> --->
	select 
	a.itemno,
    a.desp,
    a.despa,
    a.category,
    a.wos_group,
	a.shelf,
    a.price,
    a.unit,
    a.packing,
	b.location,
	b.locationdesp,
	c.balance 
	
	from icitem as a 
	
	left join 
	(
		select 
		location,
		itemno,
		(select desp from iclocation where location=locqdbf.location) as locationdesp 
		from locqdbf
		where itemno=itemno 
		and itemno='#form.itemno#' 
		<cfif form.locationfrom neq "" and form.locationto neq "">
		and location between '#form.locationfrom#' and '#form.locationto#'
		</cfif>
	) as b on a.itemno=b.itemno 
	
	left join 
	(
		select 
		a.location,
		a.itemno,
		(ifnull(a.locqfield,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance 
		
		from locqdbf as a 
		
		left join
		(
			select 
			location,
			itemno,
			sum(qty) as sum_in 
			
			from ictran
			
			where type in ('RC','CN','OAI','TRIN') 
			and fperiod<>'99'
			and itemno='#form.itemno#' 
			<cfif form.locationfrom neq "" and form.locationto neq "">
			and location between '#form.locationfrom#' and '#form.locationto#'
			</cfif>

			group by location,itemno
			order by location,itemno
		) as b on a.location=b.location and a.itemno=b.itemno
		
		left join
		(
			select 
			location,
            category,
            wos_group,
			itemno,
			sum(qty) as sum_out 
			
			from ictran 
			
			where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
			and (toinv='' or toinv is null) 
			and fperiod<>'99'
			and itemno='#form.itemno#' 
			<cfif form.locationfrom neq "" and form.locationto neq "">
			and location between '#form.locationfrom#' and '#form.locationto#'
			</cfif>
			group by location,itemno
			order by location,itemno
		) as c on a.location=c.location and a.itemno=c.itemno 
		
		where a.itemno=a.itemno
		and a.itemno='#form.itemno#' 
       
		<cfif form.locationfrom neq "" and form.locationto neq "">
		and a.location between '#form.locationfrom#' and '#form.locationto#'
		</cfif>
	) as c on a.itemno=c.itemno and b.location=c.location 
	
	where a.itemno=a.itemno 
	and b.location<>''

	<cfif form.locationfrom neq "" and form.locationto neq "">
	and b.location between '#form.locationfrom#' and '#form.locationto#'
	</cfif> 
    and a.itemno='#form.itemno#' 
	order by a.itemno;
	
	
<CFELSEIF form.choose is "Display">
	
		<!--- <cfif isdefined("form.url.itemno1")> --->
	select 
	a.itemno,
    a.desp,
    a.despa,
    a.category,
    a.wos_group,
	a.shelf,
    a.price,
    a.unit,
    a.packing,
	b.location,
	b.locationdesp,
	c.balance 
	
	from icitem as a 
	
	left join 
	(
		select 
		location,
		itemno,
		(select desp from iclocation where location=locqdbf.location) as locationdesp 
		from locqdbf
		where itemno=itemno 
        <cfif form.itemfrom neq "" and form.itemto neq "">
		and itemno between '#form.itemfrom#' and '#form.itemto#'
        </cfif>
		<cfif form.locationfrom neq "" and form.locationto neq "">
		and location between '#form.locationfrom#' and '#form.locationto#'
		</cfif>
	) as b on a.itemno=b.itemno 
	
	left join 
	(
		select 
		a.location,
		a.itemno,
		(ifnull(a.locqfield,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance 
		
		from locqdbf as a 
		
		left join
		(
			select 
			location,
			itemno,
			sum(qty) as sum_in 
			
			from ictran
			
			where type in ('RC','CN','OAI','TRIN') 
			and fperiod<>'99'
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno between '#form.itemfrom#' and '#form.itemto#'
       		</cfif>
			<cfif form.locationfrom neq "" and form.locationto neq "">
			and location between '#form.locationfrom#' and '#form.locationto#'
			</cfif>

			group by location,itemno
			order by location,itemno
		) as b on a.location=b.location and a.itemno=b.itemno
		
		left join
		(
			select 
			location,
            category,
            wos_group,
			itemno,
			sum(qty) as sum_out 
			
			from ictran 
			
			where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
			and (toinv='' or toinv is null)
			and fperiod<>'99'
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif form.locationfrom neq "" and form.locationto neq "">
			and location between '#form.locationfrom#' and '#form.locationto#'
			</cfif>
			group by location,itemno
			order by location,itemno
		) as c on a.location=c.location and a.itemno=c.itemno 
		
		where a.itemno=a.itemno
		<cfif form.itemfrom neq "" and form.itemto neq "">
		and a.itemno between '#form.itemfrom#' and '#form.itemto#'
        </cfif> 
       
		<cfif form.locationfrom neq "" and form.locationto neq "">
		and a.location between '#form.locationfrom#' and '#form.locationto#'
		</cfif>
	) as c on a.itemno=c.itemno and b.location=c.location 
	
	where a.itemno=a.itemno 
	and b.location<>''

	<cfif form.locationfrom neq "" and form.locationto neq "">
	and b.location between '#form.locationfrom#' and '#form.locationto#'
	</cfif> 

	and a.itemno between '#form.itemfrom#' and '#form.itemto#'

	order by a.itemno;
	
</cfif>
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	select lcategory,lgroup from gsetup
</cfquery>




<body>
<h1><center>Item Balance Enquires</center></h1>
<cfoutput>
	<h2>
		<cfif form.choose is "Submit"> 
	Item - #form.itemno#
	<cfelseif form.choose is "Display">
				
			Item - #form.itemfrom# to #form.itemto#
			
			</cfif>
	</h2><br><br><br>
	
	<table align="center" class="data" width="95%">
		<tr> 
    		<th>Item No.</th>
    		<th>Name</th>
            <th>Location</th>
			<th>#getgsetup.lcategory#</th>
			<th>#getgsetup.lgroup#</th>	
            <cfif lcase(hcomid) eq "hyray_i">
            <th>In</th>
            <th>Out</th>	
            </cfif>
    		<th><cfif lcase(hcomid) eq "hyray_i">Balance<cfelse>On Hand</cfif></th>
			<cfif lcase(hcomid) eq "hyray_i"><th>Cost Price</th></cfif>
            <th><cfif lcase(hcomid) eq "hyray_i">Selling Price<cfelse>Price</cfif></th>
    		<th>Unit</th>
			<th>Packing</th>
		</tr>
		<cfloop query="getitem">
		<tr> 
     	 	<td>#getitem.itemno#</td>
            <td>#getitem.location#</td>
      		<td>#getitem.desp#<br>#getitem.despa#</td>
	  		<td>#getitem.category#</td>
	  		<td>#getitem.wos_group#</td>
            <cfif lcase(hcomid) eq "hyray_i">
            <td>#getitem.qtyin#</td>
            <td>#getitem.qtyout#</td>
            </cfif>
      		<td><div align="center"><font color="FF0000">#getitem.balance#</font></div></td>
            <cfif lcase(hcomid) eq "hyray_i">
            <td align="right">#numberformat(getitem.ucost,",.____")#</td>
            </cfif>
	  		<td align="right">#numberformat(getitem.price,",.____")#</td>
      		<td>#getitem.unit#</td>
	  		<td>#getitem.packing#</td>
    	</tr></cfloop>
	</table>
</cfoutput>

<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>