<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>
<cfquery name="getdisplaydetail" datasource="#dts#">
select * from displaysetup
</cfquery>

<cfif isdefined('form.dodate')>
<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and itemno between '#form.productfrom#' and '#form.productto#'
</cfif> group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>
</cfif> 


<html>
<head>
<title><cfif hcomid eq "pnp_i">View Location Stock Card Details<cfelse>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card Summary</cfif></title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandbalanceqty" default="0">

<cfparam name="subqtybf" default="0">
<cfparam name="subqtyin" default="0">
<cfparam name="subqtyout" default="0">
<cfparam name="subbalanceqty" default="0">

<cfquery name="getgeneral" datasource="#dts#">
	select 
	cost,
	compro,
	lastaccyear,
    singlelocation
	from gsetup;
</cfquery>

<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>
	
	<cfif dd greater than "12">
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	
	<cfif dd greater than "12">
		<cfset ndateto = dateformat(form.dateto,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYYDDMM")>
	</cfif>
</cfif>

<cfquery name="insert_new_location_item" datasource="#dts#">
	insert ignore into locqdbf 
	(
		itemno,
		location
	)
	(
		select 
		itemno,
		location 
		from ictran 
		where location<>''
		and (linecode <> 'SV' or linecode is null)
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
			and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif> 
        <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and location = '#form.locfrom#'
		</cfif>
        <cfelse>
		<cfif form.locfrom neq "" and form.locto neq "">
			and location between '#form.locfrom#' and '#form.locto#'
		</cfif>
        </cfif>
		group by location,itemno
		order by location,itemno
	)
</cfquery>


<!---<cfquery name="getlocation" datasource="#dts#">
	select itemno,desp from icitem where 0=0
    <cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
        <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
		<cfset wos_group = HUserid >
        and wos_group = "#wos_group#"
        </cfif>
		order by itemno
</cfquery>
---->


<cfif form.thislastaccdate neq "">

<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #thislastaccdate#
		limit 1
	</cfquery>


<cfquery name="getlocation" datasource="#dts#">
	select 
    <cfif isdefined('form.groupitem')>
	substring_index(a.location,'-',1) as location,
	substring_index(a.location,'-',1) as location_desp
	<cfelse>
    a.location,
	bb.location_desp
    </cfif>
    ,a.itemno,aa.desp
	from locqdbf_last_year as a 
	
	right join 
	(
		select 
		itemno,
		desp 
		from icitem 
		where itemno<>'' 
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
        <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
		<cfset wos_group = HUserid >
        and wos_group = "#wos_group#"
        </cfif>
		order by itemno
	) as aa on a.itemno=aa.itemno 
	
	left join 
	(
		select 
		location,
		desp as location_desp 
		from iclocation 
		order by location
	) as bb on a.location=bb.location
	
	left join
	(
		select 
		location,
		itemno,
		sum(qty) as getlastin 
		from ictran
		where type in ('RC','CN','OAI','TRIN') 
		<cfif form.datefrom neq "" and form.dateto neq "">
                    <cfelse>
					and fperiod < '#form.periodfrom#' 
                    </cfif>
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
        <cfelse>
            and wos_date < #getdate.LastAccDate#
        </cfif>
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif> 
		group by location,itemno
		order by location,itemno
	) as b on a.itemno=b.itemno and a.location=b.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as getlastout 
		from ictran
		where
        
        <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO') or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
                ))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO')
                and (toinv='' or toinv is null)
				</cfif> 
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
		<cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
		and fperiod < '#form.periodfrom#' 
        </cfif>
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
        <cfelse>
            and wos_date < #getdate.LastAccDate#
        </cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as c on a.itemno=c.itemno and a.location=c.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as qin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN')
		and fperiod='99' 
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate#  
		and (void = '' or void is null)
		and (linecode <> 'SV' or linecode is null)
    	<cfif form.datefrom neq "" and form.dateto neq "">
    	and wos_date between '#ndatefrom#' and '#ndateto#'
    	</cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as d on a.itemno=d.itemno and a.location=d.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as qout 
		from ictran 
		where
        <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
		and fperiod='99' 
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate#  
		and (void = '' or void is null)
		and (linecode <> 'SV' or linecode is null)

    	<cfif form.datefrom neq "" and form.dateto neq "">
    	and wos_date between '#ndatefrom#' and '#ndateto#'
   		</cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as e on a.itemno=e.itemno and a.location=e.location
	
	where a.location<>''
    <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by a.itemno
	order by a.itemno,a.location
</cfquery>


<cfelse>

<cfquery name="getlocation" datasource="#dts#">
	select 
    <cfif isdefined('form.groupitem')>
	substring_index(a.location,'-',1) as location,
	substring_index(a.location,'-',1) as location_desp
	<cfelse>
    a.location,
	bb.location_desp
    </cfif>
    ,a.itemno,aa.desp
	<!--- ,
	a.itemno,
	aa.desp,
	ifnull(d.qin,0) as qin,
	ifnull(e.qout,0) as qout,
	(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
	(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance --->
	from locqdbf as a 
	
	right join 
	(
		select 
		itemno,
		desp 
		from icitem 
		where itemno<>'' 
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
        <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
		<cfset wos_group = HUserid >
        and wos_group = "#wos_group#"
        </cfif>
		order by itemno
	) as aa on a.itemno=aa.itemno 
	
	left join 
	(
		select 
		location,
		desp as location_desp 
		from iclocation 
		order by location
	) as bb on a.location=bb.location
	
	left join
	(
		select 
		location,
		itemno,
		sum(qty) as getlastin 
		from ictran
		where type in ('RC','CN','OAI','TRIN') 
		<cfif form.datefrom neq "" and form.dateto neq "">
                    <cfelse>
					and fperiod < '#form.periodfrom#' 
                    </cfif>
		and fperiod<>'99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date < '#ndatefrom#' 
		</cfif>
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif> 
		group by location,itemno
		order by location,itemno
	) as b on a.itemno=b.itemno and a.location=b.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as getlastout 
		from ictran
		where
        
        <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO') or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO')
                and (toinv='' or toinv is null)
				</cfif> 
		<cfif form.datefrom neq "" and form.dateto neq "">
                    <cfelse>
					and fperiod < '#form.periodfrom#' 
                    </cfif>
		and fperiod<>'99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
		<cfif form.datefrom neq "" and form.dateto neq "">
    	and wos_date < '#ndatefrom#'
    	</cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as c on a.itemno=c.itemno and a.location=c.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as qin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN')
		and fperiod<>'99' 
		and (void = '' or void is null)
		and (linecode <> 'SV' or linecode is null)
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod between '#form.periodfrom#' and '#form.periodto#'
   		</cfif>
    	<cfif form.datefrom neq "" and form.dateto neq "">
    	and wos_date between '#ndatefrom#' and '#ndateto#'
    	</cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as d on a.itemno=d.itemno and a.location=d.location

	left join
	(
		select 
		location,
		itemno,
		sum(qty) as qout 
		from ictran 
		where
        <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
		and fperiod<>'99' 
		and (void = '' or void is null)
		and (linecode <> 'SV' or linecode is null)
   		<cfif form.periodfrom neq "" and form.periodto neq "">
    	and fperiod between '#form.periodfrom#' and '#form.periodto#'
   		</cfif>
    	<cfif form.datefrom neq "" and form.dateto neq "">
    	and wos_date between '#ndatefrom#' and '#ndateto#'
   		</cfif> 
		<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
		and itemno between '#form.productfrom#' and '#form.productto#'
		</cfif>
		group by location,itemno
		order by location,itemno
	) as e on a.itemno=e.itemno and a.location=e.location
	
	where a.location<>''
    <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by a.itemno
	order by a.itemno,a.location
</cfquery>

</cfif>


<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>

<table align="center" border="0" width="100%">
	<tr>
		<td colspan="100%"><div align="center"><font size="3" face="Times New Roman,Times,serif"><strong><cfif hcomid eq "pnp_i">LOCATION STOCK CARD DETAILS<cfelse><cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif> STOCK CARD SUMMARY</cfif></strong></font></div></td>
	</tr>
	<cfoutput>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">
				#dateformat(dateadd('m',form.periodfrom,getgeneral.lastaccyear),"mmm yy")# - #dateformat(dateadd('m',form.periodto,getgeneral.lastaccyear),"mmm yy")#
			</font></div></td>		
		</tr>
	</cfif>
    <cfif form.locfrom neq "" and form.locto neq "">
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Location: #form.locfrom# - #form.locto#</font></div></td>
		</tr>
	</cfif>
        <cfif form.productfrom neq "" and form.productto neq "">
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Product: #form.productfrom# - #form.productto#</font></div></td>
		</tr>
	</cfif>
    <cfif form.datefrom neq "" and form.dateto neq "">
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Date: #form.datefrom# - #form.dateto#</font></div></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3"><div align="left"><font size="2" face="Times New Roman,Times,serif">#getgeneral.compro#</font></div></td>
    	<td colspan="5"><div align="right"><font size="2" face="Times New Roman,Times,serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr>
		<td colspan="100%"><hr></td>
	</tr>
	<tr>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM NO.</font></div></td>
         <cfif getdisplaydetail.report_aitemno eq 'Y'>



         <td><div align="left"><font size="2" face="Times New Roman,Times,serif">Product Code</font></div></td>
         </cfif>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">DESPCRIPTION</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif">UOM</font></div></td>
       
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">QTYBF</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">IN</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">OUT</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">BALANCE</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman,Times,serif">PHOTO</font></div></td>
    </tr>
	<tr>
      	<td colspan="100%"><hr></td>
    </tr>
	<cfloop query="getlocation">
    <cfset subqtybf=0>
	<cfset subqtyin=0>
	<cfset subqtyout=0>
	<cfset subbalanceqty=0>
		<cfset target_location = getlocation.itemno>
		<cfset target_location_desp = getlocation.desp>
		
        
        <cfif thislastaccdate neq "">

<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #thislastaccdate#
		limit 1
	</cfquery>

<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            

            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
            aa.aitemno,
            aa.unit,
            aa.photo,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf_last_year group by itemno order by itemno)<cfelse>locqdbf</cfif> as a 
			
			right join 
			(
				select 
				itemno,
                aitemno,
                unit,
                photo,
				desp 
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				and itemno ='#target_location#'
                <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
				<cfset wos_group = huserid >
                and wos_group = "#wos_group#"
                </cfif>
				order by itemno
			) as aa on a.itemno=aa.itemno 
			
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
                <cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
				and fperiod < '#form.periodfrom#' 
				</cfif>
				and fperiod='99'
                and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date < '#ndatefrom#' 
				<cfelse>
					and wos_date < #getdate.LastAccDate#
				</cfif>
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as b on a.itemno=b.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=b.location
		
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as getlastout 
				from ictran
				where 
                <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
                and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date < '#ndatefrom#' 
				<cfelse>
					and wos_date < #getdate.LastAccDate#
	    		</cfif> 
				and fperiod='99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as c on a.itemno=c.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=c.location
		
			left join
			(
            
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as qin 
				from ictran 
				where type in ('RC','CN','OAI','TRIN')
				and fperiod='99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as d on a.itemno=d.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=d.location
		
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as qout 
				from ictran 
				where 
                <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
                
				and fperiod='99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
			
			where a.location<>''
            <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			and a.itemno ='#target_location#'
            <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
            group by a.itemno
			order by a.itemno,a.location
		</cfquery>


<cfelse>

        
        
        
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            aa.aitemno,
            aa.unit,
            aa.photo,
            
            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
			sum(ifnull(d.qin,0)) as qin,
			sum(ifnull(e.qout,0)) as qout,
			sum((ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0))) as qtybf,
			sum((ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0))) as balance
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf group by itemno order by itemno)<cfelse>locqdbf</cfif> as a 
			
			right join 
            
			(
				select 
				itemno,
                aitemno,
                unit,
                photo,
				desp 
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
                and itemno ='#target_location#'
                <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
				<cfset wos_group = huserid >
                and wos_group = "#wos_group#"
                </cfif>
				order by itemno
			) as aa on a.itemno=aa.itemno 
			
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
                <cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
				and fperiod < '#form.periodfrom#' 
				</cfif>
				and fperiod<>'99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#' 
				</cfif>
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as b on a.itemno=b.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=b.location
		
			left join
            
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as getlastout 
				from ictran
				where 
                <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
                <cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
				and fperiod < '#form.periodfrom#' 
                </cfif>
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				<cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as c on a.itemno=c.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=c.location
		
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as qin 
				from ictran 
				where type in ('RC','CN','OAI','TRIN')
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as d on a.itemno=d.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=d.location
		
			left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty) as qout 
				from ictran 
				where 
                <cfif isdefined('form.dodate')>
                (type in ('PR','CS','DN','ISS','OAR','TROU','DO')  or 
				(type='INV' and (dono = "" or dono is null or dono not in (
                <cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">
				))))
				<cfelse>
                type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                and (toinv='' or toinv is null) 
				</cfif>
                
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
                <cfif getgeneral.singlelocation eq 'Y'>
        		<cfif form.locfrom neq "">
				and location = '#form.locfrom#'
				</cfif>
       			 <cfelse>
				<cfif form.locfrom neq "" and form.locto neq "">
				and location between '#form.locfrom#' and '#form.locto#'
				</cfif>
    			</cfif>
				and itemno ='#target_location#'
				group by itemno
				order by itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
			
			where a.location<>''
            <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
            <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
			and a.itemno ='#target_location#'
            group by a.itemno
			order by a.itemno,a.location
		</cfquery>
		</cfif>
        
        
		<cfloop query="getitem">
      
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.currentrow#.</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.itemno#</font></div></td>
                 <cfif getdisplaydetail.report_aitemno eq 'Y'>
<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.aitemno#</font></div></td>

</cfif>
        
                <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.DESP#</font></div></td>
                <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.unit#</font></div></td>
                

				
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qtybf#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qin#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qout#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.balance#</font></div></td>
                <td><cfif getitem.photo neq ''><img src="/images/#dts#/#getitem.photo#" width="100" height="100"></cfif></td>
                <cfset grandqtybf=grandqtybf+val(getitem.qtybf)>
				<cfset grandqtyin=grandqtyin+val(getitem.qin)>
                <cfset grandqtyout=grandqtyout+val(getitem.qout)>
                <cfset grandbalanceqty=grandbalanceqty+val(getitem.balance)>

			</tr>
		</cfloop>
	  	
	</cfloop>
     <tr>
        <td></td>
        <td></td>
        <cfif getdisplaydetail.report_aitemno eq 'Y'>
        <td></td>
        </cfif>
        <td></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL:</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtybf,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtyin,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtyout,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandbalanceqty,"0")#</font></div></td>
    </tr>
</cfoutput>

</table>

<cfif getlocation.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>