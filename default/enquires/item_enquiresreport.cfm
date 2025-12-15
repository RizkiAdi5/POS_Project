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
	a.unit,
	a.price,
	a.packing,
	a.category,
	a.wos_group,
    a.ucost,
    ifnull(b.sumtotalin,0) as qtyin,
    ifnull(c.sumtotalout,0) as qtyout,
	ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
	ifnull(a.qtybf,0) as openbal
	from icitem as a
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno='#form.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
		group by itemno
	) as b on a.itemno=b.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
		and itemno='#form.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
		and toinv='' 
		group by itemno
	) as c on a.itemno=c.itemno
	
	where a.itemno='#form.itemno#' 
	
<CFELSEIF form.choose is "Display">
	
		<!--- <cfif isdefined("form.url.itemno1")> --->
	select 
	a.itemno,
	a.desp,
	a.despa,
	a.unit,
	a.price,
	a.packing,
	a.category,
	a.wos_group,
    a.ucost,
    ifnull(b.sumtotalin,0) as qtyin,
    ifnull(c.sumtotalout,0) as qtyout,
	ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
	ifnull(a.qtybf,0) as openbal
	from icitem as a
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and itemno between '#form.itemfrom#' and '#form.itemto#' 
			</cfif>
		
		and fperiod<>'99'
		and (void = '' or void is null)
		group by itemno
	) as b on a.itemno=b.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and itemno between '#form.itemfrom#' and '#form.itemto#' 
			</cfif>
		and fperiod<>'99'
		and (void = '' or void is null) 
		and (toinv='' or toinv is null)
		group by itemno
	) as c on a.itemno=c.itemno
	
	where 
    <cfif form.itemdesp eq "">
    a.itemno between '#form.itemfrom#' and  '#form.itemto#' 
    <cfelse>
    a.itemno like "<cfif isdefined('leftdesp') eq false>%</cfif>#form.itemdesp#%" or a.desp like "<cfif isdefined('leftdesp') eq false>%</cfif>#form.itemdesp#%" or a.despa like "<cfif isdefined('leftdesp') eq false>%</cfif>#form.itemdesp#%"
	</cfif>	
    order by a.itemno
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
      		<td>#getitem.desp#<br>#getitem.despa#</td>
	  		<td>#getitem.category#</td>
	  		<td>#getitem.wos_group#</td>
            <cfif lcase(hcomid) eq "hyray_i">
            <td>#getitem.qtyin#</td>
            <td>#getitem.qtyout#</td>
            </cfif>
      		<td><div align="center"><font color="FF0000"><a href="/default/report-stock/stockcard3.cfm?itemno=#getitem.itemno#&itembal=#getitem.openbal#&pf=&pt=&cf=&ct=&pef=&pet=&gpf=&gpt=&df=&dt=&sf=&st=&thislastaccdate=&dodate=Y">#getitem.balance#</a></font></div></td>
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