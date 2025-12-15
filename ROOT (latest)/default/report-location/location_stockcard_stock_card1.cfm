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

<cfquery name="getnonactivelocation" datasource="#dts#">
select location from iclocation where noactivelocation='Y'
</cfquery>
<cfset nonactivelocation=valuelist(getnonactivelocation.location)>

<cfif form.result eq 'HTML'>
<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>


<cfif isdefined('cbdetail')>
<!--- Detail Listing---->

<html>
<head>
<title>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card Details</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandsoqty" default="0">
<cfparam name="grandavailqty" default="0">
<cfparam name="grandbalanceqty" default="0">
<cfparam name="totalin" default="0">
<cfparam name="totalout" default="0">

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

<cfif form.thislastaccdate neq "">
<cfset form.thislastaccdate = dateformat(form.thislastaccdate,'YYYY-MM-DD')>
<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = "#thislastaccdate#"
		limit 1
	</cfquery>


<cfquery name="getlocation" datasource="#dts#">
	select 
    a.itemno,a.location,(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
	bb.location_desp
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
		and operiod+0 < '#form.periodfrom#' 
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
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
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
		<cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
		and operiod+0 < '#form.periodfrom#' 
        </cfif>
		and fperiod='99'
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
		and fperiod='99' 
        and operiod between '#form.periodfrom#' and '#form.periodto#'
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
       and operiod between '#form.periodfrom#' and '#form.periodto#'
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
	
	where a.location<>'' and a.LastAccDate = "#thislastaccdate#"
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
    
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by a.location,a.itemno
	order by a.location,a.itemno
</cfquery>


<cfelse>

<cfquery name="getlocation" datasource="#dts#">
	select 
    a.location,a.itemno,(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
	bb.location_desp
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
    <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by a.location,a.itemno
	order by a.location,a.itemno
</cfquery>

</cfif>
<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
<p align="center"><font size="4" face="Times New Roman, Times, serif"><strong>STOCK CARD DETAILS LISTING</strong></font></p>

<table width="100%" border="0" align="center" cellspacing="0">
<cfoutput>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">
            
<cfif form.thislastaccdate neq "">
#dateformat(dateadd('m',form.periodfrom,form.thislastaccdate),"mmm yy")# - #dateformat(dateadd('m',form.periodto,form.thislastaccdate),"mmm yy")#
<cfelse>
#dateformat(dateadd('m',form.periodfrom,getgeneral.lastaccyear),"mmm yy")# - #dateformat(dateadd('m',form.periodto,getgeneral.lastaccyear),"mmm yy")#
</cfif>		

			
			</font></div></td>		
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
    
	
    </cfoutput>
    <cfloop query="getlocation">
    
    <cfset totalin=0>
    <cfset totalout=0>
    
    <cfif thislastaccdate neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = '#thislastaccdate#'
		limit 1
	</cfquery>
<cfquery name="getictran" datasource="#dts#">
	select 
	a.itemno,
	a.desp,
    a.despa,
	a.qtybf,
	b.refno,
	b.itemno,
	b.type,
	b.dono,
	b.wos_date,
    b.trancode,
	<cfif lcase(hcomid) eq "ovas_i">
		if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
	<cfelse>
		if(b.type in ('TROU','TRIN'),'Transfer',b.name) as name,
	</cfif>
	b.price,
    b.it_cos,
	b.qty,
	b.toinv,
	(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
	<cfif lcase(hcomid) eq "ovas_i">
		,c.drivername
	</cfif>
	from icitem_last_year a,ictran b
	<cfif lcase(hcomid) eq "ovas_i">
		,(
			select a.type,a.refno,a.van,concat(dr.name,' ',dr.name2) as drivername 
			from artran a
			left join driver dr on a.van=dr.driverno
					
			where 0=0
            and a.fperiod='99'
            and a.wos_date > #getdate.LastAccDate#
            and a.wos_date <= #getdate.ThisAccDate#
            <cfif df neq "" and dt neq "">
                and a.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
            </cfif>
			
		)as c
	</cfif>
	where a.itemno=b.itemno 
	and a.itemno='#getlocation.itemno#' 
	and (b.void = '' or b.void is null)
	and (b.linecode <> 'SV' or linecode is null)
	and b.type in ('INV','CN','DN','CS','PR','RC','DO','ISS','OAI','OAR','TRIN','TROU') 
	and b.location='#getlocation.location#'
    
    and b.fperiod='99'
	and b.wos_date > #getdate.LastAccDate#
	and b.wos_date <= #getdate.ThisAccDate#
	<cfif df neq "" and dt neq "">
        and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
    </cfif>
	
	<cfif lcase(hcomid) eq "ovas_i">
		and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
	</cfif>
	order by b.wos_date,b.trdatetime
</cfquery>
    <cfelse>
<cfquery name="getictran" datasource="#dts#">
	select 
	a.itemno,
	a.desp,
    a.despa,
	a.qtybf,
	b.refno,
	b.itemno,
	b.type,
	b.dono,
	b.wos_date,
    b.trancode,
	<cfif lcase(hcomid) eq "ovas_i">
		if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
	<cfelse>
		if(b.type in ('TROU','TRIN'),'Transfer',b.name) as name,
	</cfif>
	b.price,
    b.it_cos,
	b.qty,
	b.toinv,
	(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
	<cfif lcase(hcomid) eq "ovas_i">
		,c.drivername
	</cfif>
	from icitem a,ictran b
	<cfif lcase(hcomid) eq "ovas_i">
		,(
			select a.type,a.refno,a.van,concat(dr.name,' ',dr.name2) as drivername 
			from artran a
			left join driver dr on a.van=dr.driverno
					
			where 0=0
            
            <cfif form.periodfrom neq "" and form.periodto neq "">
            and a.fperiod between '#form.periodfrom#' and '#form.periodto#'
            </cfif>
            <cfif form.datefrom neq "" and form.dateto neq "">
            and a.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
            </cfif> 
		)as c
	</cfif>
	where a.itemno=b.itemno 
	and a.itemno='#getlocation.itemno#' 
	and (b.void = '' or b.void is null)
	and (b.linecode <> 'SV' or linecode is null)
	and b.type in ('INV','CN','DN','CS','PR','RC','DO','ISS','OAI','OAR','TRIN','TROU') 
	and b.fperiod<>'99'
	and b.location='#getlocation.location#'
    
    		<cfif form.periodfrom neq "" and form.periodto neq "">
            and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
            </cfif>
            <cfif form.datefrom neq "" and form.dateto neq "">
            and b.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and b.wos_date > #getgeneral.lastaccyear#
            </cfif> 
    
	<cfif lcase(hcomid) eq "ovas_i">
		and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
	</cfif>
	order by b.wos_date,a.created_on
</cfquery>
</cfif>
    <cfoutput>
    <tr>
        <td colspan="100%"><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif>: #getlocation.location# - #getlocation.location_desp#</font></td>
    </tr>
	<tr>
    <td colspan="100%"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #getlocation.itemno# - #getictran.desp# #getictran.despa#</font></td>
    </tr>
    <cfquery name="getitem" datasource="#dts#">
  	select aitemno from icitem where itemno='#getlocation.itemno#'
  	</cfquery>
  
  <tr>
    <td colspan="100%"><font size="2" face="Times New Roman, Times, serif">PRODUCT CODE : #getitem.aitemno#</font></td>
    </tr>
	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
</cfoutput>
  	<tr>
    	<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REFNO</font></div></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
        <cfif lcase(hcomid) eq "simplysiti_i">
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">LOCATION</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">AUTHORISED BY</font></div></td>
        </cfif>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">BALANCE</font></div></td>
        <cfif getpin2.h1360 eq 'T'>
        
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">COST P.</font></div></td>
        <cfif lcase(hcomid) neq "epsilon_i">
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SELL P.</font></div></td>
        </cfif>
        <cfif lcase(hcomid) eq "epsilon_i">
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">COST PRICE</font></div></td>
        </cfif>
        <cfif lcase(hcomid) neq "epsilon_i">
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td></cfif>
        </cfif>
  	</tr>
  	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
  	<tr>
    	<td></td>
    	<td></td>
        <cfif lcase(hcomid) eq "simplysiti_i">
        <td></td>
        <td></td>
        </cfif>
        <td><font size="2" face="Times New Roman, Times, serif">Balance B/F:</font></td>
    	
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><cfoutput>#getlocation.qtybf#</cfoutput></div></font></td>
    	<cfset itembal=getlocation.qtybf>
        <td></td>
    	<td></td>
    	<td></td>
  	</tr>
      
  <cfloop query="getictran">
  
  <cfif isdefined('form.dodate')>
   <cfif type eq "INV">
  <cfquery name="checkexist2" datasource="#dts#">
  select toinv,refno,type,itemno from ictran a  where refno ='#getictran.refno#' and itemno =<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and location =<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocation.location#"> and type = "#getictran.type#" and trancode = "#getictran.trancode#" and (dono = "" or dono is null or dono not in (select frrefno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by frrefno))
  </cfquery>
  </cfif>
  </cfif>
  
  <cfoutput>
    	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#dateformat(wos_date,"dd/mm/yy")#</font></div></td>
      		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#type# #refno#</font></div></td>
            
      		<td><font size="2" face="Times New Roman, Times, serif">#name#<cfif lcase(hcomid) eq "ovas_i" and drivername neq ""> - #drivername#</cfif></font></td>
            <cfif lcase(hcomid) eq "simplysiti_i">
            <cfquery name="gettrlocation" datasource="#dts#">
  			select rem1,rem2,created_by from artran where type='TR' and refno='#refno#'
  			</cfquery>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'TRIN'>#gettrlocation.rem1#<cfelse>#gettrlocation.rem2#</cfif></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'TRIN'>#gettrlocation.created_by#<cfelse>#gettrlocation.created_by#</cfif></font></div></td>
            </cfif>
            
      		<td><cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN">
          			<cfset itembal = itembal + qty>
          			<cfset totalin = totalin + qty>
         			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
				</cfif>
			</td>
      		<td><cfif type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU">
            
            
            <cfif isdefined('form.dodate')>
                    
                    <cfif type eq "DO">
                        <cfset itembal = val(itembal) - val(qty)>
	            		<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty# / INV #toinv#</div></font>
						<cfelseif type eq "INV" and checkexist2.recordcount eq 0>
                        
						<cfelse>
	            			<cfset itembal = val(itembal) - val(qty)>
	            			<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
	          			</cfif>
                    <cfelse>
						<cfif type eq "DO" and toinv neq "">
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">INV #toinv#</div></font>
						<cfelse>
	            			<cfset itembal = val(itembal) - val(qty)>
	            			<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
	          			</cfif>
                        </cfif>
            
          			
                    
                    
                    
        		</cfif>
			</td>
      		<td>
			<cfif isdefined('form.dodate')>
                <cfif type eq "INV" and checkexist2.recordcount eq 0>
	          		<cfelse>
	          			<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
	          		</cfif>
				<cfelse>
					<cfif type eq "DO" and toinv neq "" >
	          		<cfelse>
	          			<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
	          		</cfif>
                    </cfif>
			</td>
            <cfif getpin2.h1360 eq 'T'>
            
      		<td><cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN">
          			<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price,",.____")#</font> </div>
        		</cfif>
			</td>
            <cfif lcase(hcomid) neq "epsilon_i">
      		<td><cfif type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU">
         	 		<font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(price,",.____")#</div></font>
          		</cfif>
			</td>
            </cfif>
            <cfif lcase(hcomid) eq "epsilon_i">
            <td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(it_cos,",.__")#</div></font></td>
            </cfif>
            <cfif lcase(hcomid) neq "epsilon_i">
      		<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(amt,",.__")#</div></font></td>
            </cfif>
            </cfif>
    	</tr>
	</cfoutput>
  	</cfloop>

	<tr>
    	<td colspan="100%"><hr></td>
  	</tr>

	<cfoutput>
    <tr>
      	<td></td>
      	<td></td>
        <cfif lcase(hcomid) eq "simplysiti_i">
        <td></td>
        <td></td>
        </cfif>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>Total:</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#totalin#</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#totalout#</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#itembal#</strong></div></font></td>
      	<td></td>
      	<td></td>
      	<td></td>
    </tr>
  	</cfoutput>
    <tr>
    	<td colspan="100%"><br></td>
  	</tr>
    </cfloop>
    
    
</table>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>



<cfelse>
<!--- Normal Listing---->
<html>
<head>
<title><cfif hcomid eq "pnp_i">View Location Stock Card Details<cfelse>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card Summary</cfif></title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandsoqty" default="0">
<cfparam name="grandavailqty" default="0">
<cfparam name="grandbalanceqty" default="0">

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

<!--- REMARK ON 27-03-2009 --->
<!--- <cfquery name="delete_unwanted_location_item" datasource="#dts#">
	delete 
	a 
	from
	locqdbf as a,
	(
  		select location,itemno
  		from ictran
  		where location<>'' 
		and linecode=''
  		group by location,itemno
  		order by location,itemno
	) as b 
	where a.locqfield='' 
	and a.location<>b.location 
	and a.itemno<>b.itemno;
</cfquery>

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
		group by location,itemno
		order by location,itemno
	)
</cfquery> --->

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

<cfif form.thislastaccdate neq "">
<cfset form.thislastaccdate = dateformat(form.thislastaccdate,'YYYY-MM-DD')>
<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = "#thislastaccdate#"
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
		and operiod+0 < '#form.periodfrom#' 
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
<!---         <cfelse>
            and wos_date < #getdate.LastAccDate# --->
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
		and operiod+0 < '#form.periodfrom#' 
        </cfif>
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
      <!---   <cfelse>
            and wos_date < #getdate.LastAccDate# --->
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
        and operiod between '#form.periodfrom#' and '#form.periodto#'
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
       and operiod between '#form.periodfrom#' and '#form.periodto#'
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
	
	where a.location<>'' and a.LastAccDate = "#thislastaccdate#"
    <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>
	order by a.location
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
    <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
	group by <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>
	order by a.location
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
            
<cfif form.thislastaccdate neq "">
#dateformat(dateadd('m',form.periodfrom,form.thislastaccdate),"mmm yy")# - #dateformat(dateadd('m',form.periodto,form.thislastaccdate),"mmm yy")#
<cfelse>
#dateformat(dateadd('m',form.periodfrom,getgeneral.lastaccyear),"mmm yy")# - #dateformat(dateadd('m',form.periodto,getgeneral.lastaccyear),"mmm yy")#
</cfif>		

			
			</font></div></td>		
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
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif">PRODUCT CODE.</font></div></td>
        </cfif>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">DESPCRIPTION</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">QTYBF</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">IN</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">OUT</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">BALANCE</font></div></td>
        <cfif isdefined('form.reserve')>
        <td><div align="right"><font size="2" face="Times New Roman,Times,serif">RESERVED</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman,Times,serif">AVAILABLE</font></div></td>
        </cfif>
		<td><div align="center"><font size="2" face="Times New Roman,Times,serif">ACTION</font></div></td>
        
    </tr>
	<tr>
      	<td colspan="100%"><hr></td>
    </tr>
	<cfloop query="getlocation">
		<cfset target_location = getlocation.location>
		<cfset target_location_desp = getlocation.location_desp>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong><u>#getlocation.location#</u></strong></font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong><u>#getlocation.location_desp#</u></strong></font></div></td>
		</tr>
        
        <cfif thislastaccdate neq "">

<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = "#thislastaccdate#"
		limit 1
	</cfquery>

<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
            aa.despa,
            aa.aitemno,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance,ifnull(f.soqty,0) as soqty
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf_last_year  WHERE LastAccDate = "#thislastaccdate#" group by substring_index(location,'-',1),itemno order by itemno)<cfelse>(SELECT locqfield,itemno,location from locqdbf_last_year WHERE LastAccDate = "#thislastaccdate#")</cfif> as a 
			
			right join 
			(
				select 
				itemno,
                aitemno,
				desp,
                despa
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and brand between '#form.brandfrom#' and '#form.brandto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
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
				and operiod+0 < '#form.periodfrom#' 
				</cfif>
				and fperiod='99'
                and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date < '#ndatefrom#' 
<!--- 				<cfelse>
					and wos_date < #getdate.LastAccDate# --->
				</cfif>
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif> 
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
<!--- 				<cfelse>
					and wos_date < #getdate.LastAccDate# --->
	    		</cfif> 
				and fperiod='99'
                <cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
				and operiod+0 < '#form.periodfrom#' 
				</cfif>
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
		and operiod between '#form.periodfrom#' and '#form.periodto#'
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
                and operiod between '#form.periodfrom#' and '#form.periodto#'
				and fperiod='99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
            
            
            left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty-writeoff-shipped) as soqty 
				from ictran 
				where 
                
                type ='SO'
                and (toinv='' or toinv is null) 

                and operiod between '#form.periodfrom#' and '#form.periodto#'
				and fperiod='99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as f on a.itemno=f.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=f.location
			
			where a.location<>''
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>='#target_location#'
            and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
            <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
   			</cfif>
			order by a.location,a.itemno
		</cfquery>


<cfelse>

        
        
        
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            aa.despa,
            aa.aitemno,
            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance,
            ifnull(f.soqty,0) as soqty
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf group by substring_index(location,'-',1),itemno order by itemno)<cfelse>locqdbf</cfif> as a 
			
			right join 
			(
				select 
				itemno,
                aitemno,
				desp,despa
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and brand between '#form.brandfrom#' and '#form.brandto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#' 
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif> 
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
            
            
            left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty-writeoff-shipped) as soqty 
				from ictran 
				where 
                type ='SO' 
                and (toinv='' or toinv is null) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as f on a.itemno=f.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=f.location
            
            
			
			where a.location<>''
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>='#target_location#'
            and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
            <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and a.location not like '%OFFICE%' and a.location not like '%WAREHOUSE%'
    </cfif>
			order by a.location,a.itemno
		</cfquery>
		</cfif>
		<cfloop query="getitem">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.currentrow#.</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.itemno#</font></div></td>
               <cfif getdisplaydetail.report_aitemno eq 'Y'>
                <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.aitemno#</font></div></td>
                </cfif>
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.desp# #getitem.despa#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qtybf#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qin#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.qout#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.balance#</font></div></td>
                <cfif isdefined('form.reserve')>
                <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.soqty#</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getitem.balance-getitem.soqty#</font></div></td>
                </cfif>
                <cfset grandqtybf=grandqtybf+val(getitem.qtybf)>
				<cfset grandqtyin=grandqtyin+val(getitem.qin)>
                <cfset grandqtyout=grandqtyout+val(getitem.qout)>
                <cfset grandsoqty=grandsoqty+val(getitem.soqty)>
                <cfset grandavailqty=grandavailqty+(getitem.balance-getitem.soqty)>
                <cfset grandbalanceqty=grandbalanceqty+val(getitem.balance)>
				<td nowrap>
					<div align="center">
						<a href="location_stockcard_stock_card2.cfm
						?itemno=#urlencodedformat(getitem.itemno)#
						&itembal=#urlencodedformat(getitem.qtybf)#
						&pf=#urlencodedformat(form.productfrom)#
						&pt=#urlencodedformat(form.productto)#
						&cf=#urlencodedformat(form.catefrom)#
						&ct=#urlencodedformat(form.cateto)#
						&pef=#urlencodedformat(form.periodfrom)#
						&pet=#urlencodedformat(form.periodto)#
						&gpf=#urlencodedformat(form.groupfrom)#
						&gpt=#urlencodedformat(form.groupto)#
						&df=#urlencodedformat(form.datefrom)#
						&dt=#urlencodedformat(form.dateto)#
						&location=#urlencodedformat(target_location)#
                        &thislastaccdate=#thislastaccdate#
						&location_desp=#urlencodedformat(target_location_desp)#<cfif isdefined('form.groupitem')>&groupto=1</cfif><cfif isdefined('form.dodate')>&dodate=Y</cfif>">
						<font size="2" face="Times New Roman,Times,serif">View Details</font></a>
					</div>
				</td>
			</tr>
		</cfloop>
	  	<tr>
      		<td colspan="100%"><hr></td>
		</tr>
	</cfloop>
     <tr>
        <td></td>
        <td></td>
        <cfif getdisplaydetail.report_aitemno eq 'Y'>
        <td></td>
        </cfif>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL:</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtybf,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtyin,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandqtyout,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandbalanceqty,"0")#</font></div></td>
        <cfif isdefined('form.reserve')>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandsoqty,"0")#</font></div></td>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandavailqty,"0")#</font></div></td>
        </cfif>
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

</cfif>

<cfelse>

<cfif isdefined('form.dodate')>
<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and itemno between '#form.productfrom#' and '#form.productto#'
</cfif> group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>
</cfif> 

<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandsoqty" default="0">
<cfparam name="grandavailqty" default="0">
<cfparam name="grandbalanceqty" default="0">

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

<cfif form.thislastaccdate neq "">
<cfset form.thislastaccdate = dateformat(form.thislastaccdate,'YYYY-MM-DD')>
<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = "#thislastaccdate#"
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
		and operiod+0 < '#form.periodfrom#' 
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
        and wos_date > #getdate.LastAccDate#
		and wos_date <= #getdate.ThisAccDate# 
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
<!---         <cfelse>
            and wos_date < #getdate.LastAccDate# --->
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
		and operiod+0 < '#form.periodfrom#' 
        </cfif>
		and fperiod='99'
		and (void = '' or void is null) 
		and (linecode <> 'SV' or linecode is null)
		<cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date < '#ndatefrom#' 
<!---         <cfelse>
            and wos_date < #getdate.LastAccDate# --->
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
        and operiod between '#form.periodfrom#' and '#form.periodto#'
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
        and operiod between '#form.periodfrom#' and '#form.periodto#'
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
    and a.LastAccDate = "#thislastaccdate#"
    <cfif getgeneral.singlelocation eq 'Y'>
        <cfif form.locfrom neq "">
			and a.location = '#form.locfrom#'
		</cfif>
        <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between '#form.locfrom#' and '#form.locto#'
	</cfif>
    </cfif>
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
	group by <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>
	order by a.location
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
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and brand between '#form.brandfrom#' and '#form.brandto#'
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
    and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
	group by <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>
	order by a.location
</cfquery>

</cfif>



<cfxml variable="data">
			<?xml version="1.0"?>
			<?mso-application progid="Excel.Sheet"?>
			<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
			<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
				<Author>Netiquette Technology</Author>
				<LastAuthor>Netiquette Technology</LastAuthor>
				<Company>Netiquette Technology</Company>
			</DocumentProperties>
			<Styles>
		  		<Style ss:ID="Default" ss:Name="Normal">
			   		<Alignment ss:Vertical="Bottom"/>
			   		<Borders/>
			   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
			   		<Interior/>
			   		<NumberFormat/>
			   		<Protection/>
		  		</Style>
		  		<Style ss:ID="s22">
		   			<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  		</Style>
			 	<Style ss:ID="s24">
			   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
			   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
			  	</Style>
		  		<Style ss:ID="s26">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  		</Style>
		  		<Style ss:ID="s27">
		   			<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		  		</Style>
		  		<Style ss:ID="s30">
		   			<NumberFormat ss:Format="dd-mm-yy;@"/>
		  		</Style>
		  		<Style ss:ID="s31">
		  			<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  		</Style>
		  		<Style ss:ID="s32">
		  	 		<NumberFormat ss:Format="@"/>
		  		</Style>
		  		<Style ss:ID="s33">
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s34">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="dd/mm/yyyy;@"/>
		  		</Style>
		  		<Style ss:ID="s35">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0"/>
		  		</Style>
		  		<Style ss:ID="s36">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="@"/>
		  		</Style>
		  		<Style ss:ID="s37">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s38">
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  		</Style>
		  		<Style ss:ID="s39">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s41">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  		</Style>
		 	</Styles>
			
			<Worksheet ss:Name="Location Stock Card">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="60.25"/>
					<Column ss:Width="60.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:Width="60.75"/>
					<Column ss:Width="47.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="11">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>

		   
					<cfwddx action = "cfml2wddx" input = "View Location Stock Card Summary" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					
						<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
                        <cfif form.thislastaccdate neq "">
<cfwddx action = "cfml2wddx" input = "#dateformat(dateadd('m',form.periodfrom,form.thislastaccdate),"mmm yy")# - #dateformat(dateadd('m',form.periodto,form.thislastaccdate),"mmm yy")#" output = "wddxText">
<cfelse>
                        <cfwddx action = "cfml2wddx" input = "#dateformat(dateadd('m',form.periodfrom,getgeneral.lastaccyear),"mmm yy")# - #dateformat(dateadd('m',form.periodto,getgeneral.lastaccyear),"mmm yy")#" output = "wddxText">
                        </cfif>
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>

					<cfwddx action = "cfml2wddx" input = "" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>

				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">NO.</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">ITEM NO.</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">PRODUCT CODE</Data></Cell>
                    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "kjctrial_i")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">PRODUCT CODE.</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s27"><Data ss:Type="String">DESPCRIPTION</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">QTYBF</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">BALANCE</Data></Cell>
                    <cfif isdefined('form.reserve')>
					<Cell ss:StyleID="s27"><Data ss:Type="String">RESERVED</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">AVAILABLE</Data></Cell>
                    </cfif>
					
				</Row>
                <cfloop query="getlocation">
		<cfset target_location = getlocation.location>
		<cfset target_location_desp = getlocation.location_desp>
		<cfoutput>
        
       				<cfwddx action = "cfml2wddx" input = "#getlocation.location#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#getlocation.location_desp#" output = "wddxText2">	
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
					</Row>
        </cfoutput>
        <cfif thislastaccdate neq "">

<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = "#thislastaccdate#"
		limit 1
	</cfquery>

<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
            aa.despa,
            aa.aitemno,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance,ifnull(f.soqty,0) as soqty
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf_last_year group by substring_index(location,'-',1),itemno order by itemno)<cfelse>(SELECT locqfield,itemno,location from locqdbf_last_year WHERE LastAccDate = "#thislastaccdate#")</cfif> as a 
			
			right join 
			(
				select 
				itemno,
                aitemno,
				desp,
                despa
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and brand between '#form.brandfrom#' and '#form.brandto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
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
				and operiod+0 < '#form.periodfrom#' 
				</cfif>
				and fperiod='99'
                and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date < '#ndatefrom#' 
<!--- 				<cfelse>
					and wos_date < #getdate.LastAccDate# --->
				</cfif>
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif> 
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
<!--- 				<cfelse>
					and wos_date < #getdate.LastAccDate# --->
	    		</cfif> 
				and fperiod='99'
                <cfif form.datefrom neq "" and form.dateto neq ""><cfelse>
				and operiod+0 < '#form.periodfrom#' 
				</cfif>
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
                and operiod between '#form.periodfrom#' and '#form.periodto#' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
                and operiod between '#form.periodfrom#' and '#form.periodto#'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
            
            
            left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty-writeoff-shipped) as soqty 
				from ictran 
				where 
                
                type ='SO'
                and (toinv='' or toinv is null) 

                
				and fperiod='99' 
                and operiod between '#form.periodfrom#' and '#form.periodto#' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		<cfif form.datefrom neq "" and form.dateto neq "">
	    			and wos_date between '#ndatefrom#' and '#ndateto#'
	    		</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as f on a.itemno=f.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=f.location
			
			where a.location<>''
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>='#target_location#'
            and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
			order by a.location,a.itemno
		</cfquery>


<cfelse>

        
        
        
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
            aa.despa,
            aa.aitemno,
            <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1) as location<cfelse>a.location</cfif>,
			aa.desp,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance,
            ifnull(f.soqty,0) as soqty
			from <cfif isdefined('form.groupitem')>(select sum(locqfield) as locqfield,itemno,location from locqdbf group by substring_index(location,'-',1),itemno order by itemno)<cfelse>locqdbf</cfif> as a 
			
			right join 
			(
				select 
				itemno,
                aitemno,
				desp,despa
				from icitem 
				where itemno<>'' 
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and brand between '#form.brandfrom#' and '#form.brandto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#' 
				</cfif>

				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif> 
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date < '#ndatefrom#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
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
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as e on a.itemno=e.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=e.location
            
            
            left join
			(
				select 
				<cfif isdefined('form.groupitem')>substring_index(location,'-',1) as </cfif>location,
				itemno,
				sum(qty-writeoff-shipped) as soqty 
				from ictran 
				where 
                type ='SO' 
                and (toinv='' or toinv is null) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>='#target_location#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				</cfif> 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				group by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
				order by <cfif isdefined('form.groupitem')>substring_index(location,'-',1)<cfelse>location</cfif>,itemno
			) as f on a.itemno=f.itemno and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>=f.location
            
            
			
			where a.location<>''
            <cfif not isdefined("form.include0")>
				and (ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			and <cfif isdefined('form.groupitem')>substring_index(a.location,'-',1)<cfelse>a.location</cfif>='#target_location#'
            and a.location not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#nonactivelocation#">)
			order by a.location,a.itemno
		</cfquery>
		</cfif>
		<cfloop query="getitem">
        <cfoutput>
        <cfwddx action = "cfml2wddx" input = "#getitem.currentrow#." output = "wddxText">
		<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText2">
        <cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText8">
		<cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText3">
        <cfwddx action = "cfml2wddx" input = "#getitem.desp# #getitem.despa#" output = "wddxText4">
        <cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText5">
        <cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText6">
        <cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText7">
        <Row ss:AutoFitHeight="0">
            <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
            <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
            <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>
            <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "kjctrial_i")>
            <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
            </cfif>
            <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
            
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.qtybf#</Data></Cell>
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.qin#</Data></Cell>
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.qout#</Data></Cell>
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.balance#</Data></Cell>
            <cfif isdefined('form.reserve')>
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.soqty#</Data></Cell>
            <Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.balance-getitem.soqty#</Data></Cell>
			</cfif>
        
        </Row>
                <cfset grandqtybf=grandqtybf+val(getitem.qtybf)>
				<cfset grandqtyin=grandqtyin+val(getitem.qin)>
                <cfset grandqtyout=grandqtyout+val(getitem.qout)>
                <cfset grandsoqty=grandsoqty+val(getitem.soqty)>
                <cfset grandavailqty=grandavailqty+(getitem.balance-getitem.soqty)>
                <cfset grandbalanceqty=grandbalanceqty+val(getitem.balance)>
		</cfoutput>
		</cfloop>
	  	
	</cfloop>

<Row ss:AutoFitHeight="0" ss:Height="12"/>
				
				<cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "kjctrial_i")>
                <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                </cfif>
					<Cell ss:StyleID="s38"><Data ss:Type="String">Grand Total</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtybf,"0")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtyin,"0")#</Data></Cell>
                    <Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtyout,"0")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandbalanceqty,"0")#</Data></Cell>
                    <cfif isdefined('form.reserve')>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandsoqty,"0")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandavailqty,"0")#</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s38"/>
					
				</Row>
				</cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12"/>
			</Table>
		 	
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
		   	<Unsynced/>
		   	<Print>
				<ValidPrinterInfo/>
				<Scale>60</Scale>
				<HorizontalResolution>600</HorizontalResolution>
				<VerticalResolution>600</VerticalResolution>
		   	</Print>
		   	<Selected/>
		   	<Panes>
				<Pane>
					<Number>3</Number>
			 		<ActiveRow>20</ActiveRow>
			 		<ActiveCol>3</ActiveCol>
				</Pane>
		   	</Panes>
		   	<ProtectObjects>False</ProtectObjects>
		   	<ProtectScenarios>False</ProtectScenarios>
		  	</WorksheetOptions>
		 	</Worksheet>
			</Workbook>
		</cfxml>

		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls" output="#tostring(data)#" charset="utf-8">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls"> 

</cfif>