   <cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
    <cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>
		<cfset iDecl_UPrice=getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice="">
		<cfset stDecl_UPrice2 = ",.">
		
		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice=stDecl_UPrice&"0">
			<cfset stDecl_UPrice2 = stDecl_UPrice2 & "_">
		</cfloop>
	<cfquery name="getdealer_menu" datasource="#dts#">
	select include_SO_PO_stockcard from dealer_menu limit 1
</cfquery>


<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandbalanceqty" default="0">
<cfset grandtotalprice = 0>
<cfif lcase(hcomid) eq "gel_i">
	<cfparam name="grandqtysold" default="0">	 		
    <cfparam name="grandsalesamt" default="0">
</cfif>
<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
	<cfparam name="grandSOqty" default="0">
	<cfparam name="grandnetqty" default="0">
	<cfparam name="grandPOqty" default="0">
	<cfparam name="grandgrossqty" default="0">
</cfif>
<cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU'">
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>


<cfoutput>
<cfif form.periodfrom eq '01'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '02'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '03'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '04'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '05'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '06'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '07'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '08'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '09'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '10'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '11'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '12'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '13'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '14'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '15'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '16'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '17'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '18'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'yyyy/mm')#'>
</cfif>
</cfoutput>

<cfif isdefined("form.thislastaccdate") and form.thislastaccdate neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #form.thislastaccdate#
		limit 1
	</cfquery>
	
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem_last_year as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod = '99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod = '99'
				and (void = '' or void is null)
				and (toinv='' or toinv is null)  
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as h on a.itemno = h.itemno 
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			and a.LastAccDate = #getdate.LastAccDate#
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem_last_year as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#)
				and fperiod < '#form.periodfrom#' 
				and fperiod = '99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod = '99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod = '99'
				and (void = '' or void is null)
				and (toinv='' or toinv is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as h on a.itemno = h.itemno 
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			and a.LastAccDate = #getdate.LastAccDate#
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	</cfif>
	
	<cfset thislastaccdate = form.thislastaccdate>
<cfelse>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod+0 < '#form.periodfrom#' 
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
               
				and fperiod+0 < '#form.periodfrom#' 

				and fperiod<>'99'
				and (linecode <> 'SV' or linecode is null)
				and (void = '' or void is null)
				
				group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	   			and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod<>'99'
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as h on a.itemno = h.itemno
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
              
				and fperiod+0 < '#form.periodfrom#' 
                
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#)
                
				and fperiod+0 < '#form.periodfrom#' 
              
				and fperiod<>'99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and fperiod+0 = '#form.periodfrom#' 
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as h on a.itemno = h.itemno
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	</cfif>
	
	<cfset thislastaccdate = "">
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
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
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
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s38">
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  		</Style>
		  		<Style ss:ID="s39">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s41">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  		</Style>
		 	</Styles>
			
			<Worksheet ss:Name="Bills Listing">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="183.75"/>
					<Column ss:Width="60.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
					<Column ss:Width="24.75"/>
					<Column ss:Width="24.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
                    <Column ss:AutoFitWidth="0" ss:Width="24.75"/>
                    <Column ss:AutoFitWidth="0" ss:Width="24.75"/>
                    <Column ss:AutoFitWidth="0" ss:Width="24.75"/>
					<cfset c="9">
						<Column ss:AutoFitWidth="0" ss:Width="24.75"/>
						<cfset c=c+1>

		   
					<cfwddx action = "cfml2wddx" input = "DAILY STOCK CARD DETAILS" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					<cfif trim(catefrom) neq "" and trim(cateto) neq "">
						<cfwddx action = "cfml2wddx" input = "#getgeneral.lCATEGORY# From #catefrom# To #cateto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
                    
                    <cfif trim(groupfrom) neq "" and trim(groupto) neq "">
						<cfwddx action = "cfml2wddx" input = "#getgeneral.lGROUP# From #groupfrom# To #Groupto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
                    
                    <cfif trim(productfrom) neq "" and trim(productto) neq "">
						<cfwddx action = "cfml2wddx" input = "Product From #productfrom# To #productto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
                    
                    <cfif trim(suppfrom) neq "" and trim(suppto) neq "">
						<cfwddx action = "cfml2wddx" input = "Supplier From #suppfrom# To #suppto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
                    <cfwddx action = "cfml2wddx" input = "Period #yearmonth#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
			
				
					
					<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					
                    <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">ITEM NO.</Data></Cell>
					 <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">DESP</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">QTY B/F</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">01</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">02</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">03</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">04</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">05</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">06</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">07</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">08</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">09</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">10</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">11</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">12</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">13</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">14</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">15</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">16</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">17</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">18</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">19</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">20</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">21</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">22</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">23</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">24</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">25</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">26</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">27</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">28</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">29</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">30</Data></Cell>
                      <Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">31</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">BALANCE</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">SP ($)</Data></Cell>
                      <Cell ss:MergeDown="1" ss:StyleID="s27"><Data ss:Type="String">AMOUNT</Data></Cell>

				</Row>
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					
					<Cell ss:Index="4" ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">IN</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">OUT</Data></Cell>
					
				</Row>
				<cfloop query="getitem">
		<cfoutput>
        <!--- get perday quantity in --->
        <cfquery name="getin01" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date ='#yearmonth#/01'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin02" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/02'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin03" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/03'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin04" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/04'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin05" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/05'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin06" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/06'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin07" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/07'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin08" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/08'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin09" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/09'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin10" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/10'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin11" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/11'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin12" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/12'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin13" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/13'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin14" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/14'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin15" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/15'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin16" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/16'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin17" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/17'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin18" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/18'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin19" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/19'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        

        <cfquery name="getin20" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/20'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin21" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/21'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin22" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/22'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin23" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/23'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin24" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/24'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin25" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/25'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin26" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/26'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin27" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/27'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin28" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/28'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin29" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/29'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin30" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/30'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin31" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/31'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getout01" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/01'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout02" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/02'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
                
        <cfquery name="getout03" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/03'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout04" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/04'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout05" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/05'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout06" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/06'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout07" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/07' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout08" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/08'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout09" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/09'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout10" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/10'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout11" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/11'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout12" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/12' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout13" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/13'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout14" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/14'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout15" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/15'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout16" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/16'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout17" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/17'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout18" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/18'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout19" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/19'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout20" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/20'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout21" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/21'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout22" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/22'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout23" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/23'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout24" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/24'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout25" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/25'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout26" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/26'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout27" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/27'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout28" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/28'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout29" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/29'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout30" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/30' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout31" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/31'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
					<cfquery name="getprice" datasource="#dts#">
            select price from icitem where itemno='#getitem.itemno#'
            </cfquery>
					<cfset balanceqty=val(getitem.qtybf)+val(getitem.qin)-val(getitem.qout)>
					
					<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#getitem.qtybf#" output = "wddxText3">

						
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin01.recordcount eq 0><cfelse>#getin01.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout01.recordcount eq 0><cfelse>#getout01.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin02.recordcount eq 0><cfelse>#getin02.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout02.recordcount eq 0><cfelse>#getout02.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin03.recordcount eq 0><cfelse>#getin03.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout03.recordcount eq 0><cfelse>#getout03.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin04.recordcount eq 0><cfelse>#getin04.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout04.recordcount eq 0><cfelse>#getout04.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin05.recordcount eq 0><cfelse>#getin05.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout05.recordcount eq 0><cfelse>#getout05.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin06.recordcount eq 0><cfelse>#getin06.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout06.recordcount eq 0><cfelse>#getout06.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin07.recordcount eq 0><cfelse>#getin07.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout07.recordcount eq 0><cfelse>#getout07.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin08.recordcount eq 0><cfelse>#getin08.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout08.recordcount eq 0><cfelse>#getout08.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin09.recordcount eq 0><cfelse>#getin09.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout09.recordcount eq 0><cfelse>#getout09.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin10.recordcount eq 0><cfelse>#getin10.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout10.recordcount eq 0><cfelse>#getout10.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin11.recordcount eq 0><cfelse>#getin11.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout11.recordcount eq 0><cfelse>#getout11.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin12.recordcount eq 0><cfelse>#getin12.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout12.recordcount eq 0><cfelse>#getout12.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin13.recordcount eq 0><cfelse>#getin13.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout13.recordcount eq 0><cfelse>#getout13.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin14.recordcount eq 0><cfelse>#getin14.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout14.recordcount eq 0><cfelse>#getout14.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin15.recordcount eq 0><cfelse>#getin15.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout15.recordcount eq 0><cfelse>#getout15.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin16.recordcount eq 0><cfelse>#getin16.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout16.recordcount eq 0><cfelse>#getout16.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin17.recordcount eq 0><cfelse>#getin17.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout17.recordcount eq 0><cfelse>#getout17.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin18.recordcount eq 0><cfelse>#getin18.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout18.recordcount eq 0><cfelse>#getout18.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin19.recordcount eq 0><cfelse>#getin19.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout19.recordcount eq 0><cfelse>#getout19.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin20.recordcount eq 0><cfelse>#getin20.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout20.recordcount eq 0><cfelse>#getout20.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin21.recordcount eq 0><cfelse>#getin21.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout21.recordcount eq 0><cfelse>#getout21.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin22.recordcount eq 0><cfelse>#getin22.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout22.recordcount eq 0><cfelse>#getout22.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin23.recordcount eq 0><cfelse>#getin23.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout23.recordcount eq 0><cfelse>#getout23.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin24.recordcount eq 0><cfelse>#getin24.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout24.recordcount eq 0><cfelse>#getout24.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin25.recordcount eq 0><cfelse>#getin25.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout25.recordcount eq 0><cfelse>#getout25.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin26.recordcount eq 0><cfelse>#getin26.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout26.recordcount eq 0><cfelse>#getout26.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin27.recordcount eq 0><cfelse>#getin27.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout27.recordcount eq 0><cfelse>#getout27.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin28.recordcount eq 0><cfelse>#getin28.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout28.recordcount eq 0><cfelse>#getout28.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin29.recordcount eq 0><cfelse>#getin29.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout29.recordcount eq 0><cfelse>#getout29.qout#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin30.recordcount eq 0><cfelse>#getin30.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout30.recordcount eq 0><cfelse>#getout30.qout#</cfif></Data></Cell>
                         <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getin31.recordcount eq 0><cfelse>#getin31.qin#</cfif></Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif getout31.recordcount eq 0><cfelse>#getout31.qout#</cfif></Data></Cell>
                        
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#getitem.qin#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#getitem.qout#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#balanceqty#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#lsnumberformat(getprice.price,',_.__')#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#lsnumberformat((getprice.price*getitem.qout),',_.__')#</Data></Cell>

	
					
					</Row>
                    
                    <cfset grandtotalprice=grandtotalprice+(getprice.price*getitem.qout)>
            <cfset grandqtybf=grandqtybf+val(getitem.qtybf)>
            <cfset grandqtyin=grandqtyin+val(getitem.qin)>
            <cfset grandqtyout=grandqtyout+val(getitem.qout)>
            <cfset grandbalanceqty=grandbalanceqty+val(balanceqty)>
            <cfif lcase(hcomid) eq "gel_i">
            	<cfset grandqtysold=grandqtysold+val(sqty)>
                <cfset grandsalesamt=grandsalesamt+val(sumamt)>
			</cfif>
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
			<cfset netqty=val(balanceqty)-val(getitem.SOqty)>
				<cfset grandSOqty=grandSOqty+val(getitem.SOqty)>
                
				<cfset grandnetqty=grandnetqty+netqty>
				<cfset grandPOqty=grandPOqty+val(getitem.POqty)>
                <cfset grossqty=netqty+val(getitem.POqty)>
				<cfset grandgrossqty=grandgrossqty+grossqty>
			</cfif>
				</cfoutput>
  	</cfloop>
	
		
				<Row ss:AutoFitHeight="0" ss:Height="12"/>
				
				<cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:StyleID="s39"><Data ss:Type="Number"></Data></Cell>
				<Cell ss:StyleID="s38"><Data ss:Type="String">Total :</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtybf,"0")#</Data></Cell>
                <Cell ss:MergeAcross="61" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtyin,"0")#</Data></Cell>
                    <Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandqtyout,"0")#</Data></Cell>
                    <Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(grandbalanceqty,"0")#</Data></Cell>
                    
					
				</Row>
				</cfoutput>
                <cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Less : 7% GST :</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat(grandtotalprice*0.07,",_.__")#</Data></Cell>

				</Row>
				</cfoutput>
                 <cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Total :</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat(grandtotalprice*0.93,",_.__")#</Data></Cell>

				</Row>
				</cfoutput>
                 <cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Less : Trade Com.35%</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat((grandtotalprice*0.93)*0.35,",_.__")#</Data></Cell>

				</Row>
				</cfoutput>
				<cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Total :</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat(grandtotalprice-((grandtotalprice*0.93)*0.35),",_.__")#</Data></Cell>

				</Row>
				</cfoutput>
                <cfoutput>
                <cfset total1=grandtotalprice-((grandtotalprice*0.93)*0.35)>
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Add : 7% GST</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat(total1*0.07,",_.__")#</Data></Cell>

				</Row>
				</cfoutput>
                <cfoutput>
               
				<Row ss:AutoFitHeight="0" ss:Height="12">
                <Cell ss:MergeAcross="62" ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
               <Cell ss:MergeAcross="5" ss:StyleID="s38"><Data ss:Type="String">Total Amount Due :</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="Number">#lsnumberformat(total1*1.07,",_.__")#</Data></Cell>

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

		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">
	</cfcase>

    
  <cfcase value="HTML">
<html>
<head>
<title><cfif hcomid eq "pnp_i">Stock Card2 Details<cfelse>Stock Card2</cfif></title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<!--- Add On 28-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select include_SO_PO_stockcard from dealer_menu limit 1
</cfquery>


<cfparam name="grandqtybf" default="0">
<cfparam name="grandqtyin" default="0">
<cfparam name="grandqtyout" default="0">
<cfparam name="grandbalanceqty" default="0">
<cfset grandtotalprice = 0>
<cfif lcase(hcomid) eq "gel_i">
	<cfparam name="grandqtysold" default="0">	 		
    <cfparam name="grandsalesamt" default="0">
</cfif>
<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
	<cfparam name="grandSOqty" default="0">
	<cfparam name="grandnetqty" default="0">
	<cfparam name="grandPOqty" default="0">
	<cfparam name="grandgrossqty" default="0">
</cfif>
<cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU'">
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>


<cfoutput>
<cfif form.periodfrom eq '01'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '02'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '03'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '04'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '05'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '06'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '07'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '08'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '09'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '10'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '11'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '12'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '13'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '14'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '15'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '16'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '17'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'yyyy/mm')#'>

<cfelseif form.periodfrom eq '18'>
<cfset monthyear='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'mm/yyyy')#'>
<cfset yearmonth='#dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'yyyy/mm')#'>
</cfif>
</cfoutput>

<cfif isdefined("form.thislastaccdate") and form.thislastaccdate neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #form.thislastaccdate#
		limit 1
	</cfquery>
	
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem_last_year as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod = '99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod = '99'
				and (void = '' or void is null)
				and (toinv='' or toinv is null)  
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as h on a.itemno = h.itemno 
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			and a.LastAccDate = #getdate.LastAccDate#
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem_last_year as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#)
				and fperiod < '#form.periodfrom#' 
				and fperiod = '99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
				and wos_date < #getdate.LastAccDate#group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod = '99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod = '99'
				and (void = '' or void is null)
				and (toinv='' or toinv is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate# 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod = '99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and wos_date > #getdate.LastAccDate#
				and wos_date <= #getdate.ThisAccDate#  
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod = '99'
					and (void = '' or void is null) 
					and (linecode <> 'SV' or linecode is null)
					and wos_date > #getdate.LastAccDate#
					and wos_date <= #getdate.ThisAccDate#  
					and (toinv='' or toinv is null)
					group by itemno
				) as h on a.itemno = h.itemno 
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			and a.LastAccDate = #getdate.LastAccDate#
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	</cfif>
	
	<cfset thislastaccdate = form.thislastaccdate>
<cfelse>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
				and fperiod+0 < '#form.periodfrom#' 
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
               
				and fperiod+0 < '#form.periodfrom#' 

				and fperiod<>'99'
				and (linecode <> 'SV' or linecode is null)
				and (void = '' or void is null)
				
				group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran a
				where (type in (#PreserveSingleQuotes(outtrantype)#) or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	   			and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod<>'99'
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as h on a.itemno = h.itemno
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.unit,
            a.brand,
            a.costcode,
            a.category,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				ifnull(g.SOqty,0) as SOqty,
				ifnull(h.POqty,0) as POqty,
			</cfif>
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) 
              
				and fperiod+0 < '#form.periodfrom#' 
                
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#)
                
				and fperiod+0 < '#form.periodfrom#' 
              
				and fperiod<>'99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
				group by itemno
			) as c on a.itemno = c.itemno
	
			left join
			(
				select itemno,sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and fperiod+0 = '#form.periodfrom#' 
	    		group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select itemno,sum(qty) as sqty,sum(amt) as sumamt 
				from ictran 
				where type in ('INV','CS','DN') 
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and fperiod+0 = '#form.periodfrom#' 
				group by itemno
			) as f on a.itemno = f.itemno 
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				left join
				(
					select itemno,sum(qty) as SOqty 
					from ictran 
					where type='SO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as g on a.itemno = g.itemno 
				
				left join
				(
					select itemno,sum(qty) as POqty 
					from ictran 
					where type='PO'
					and fperiod<>'99'
					and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null) 
					and (toinv='' or toinv is null)
					and fperiod+0 = '#form.periodfrom#' 
					group by itemno
				) as h on a.itemno = h.itemno
			</cfif>
	
			where a.itemno=a.itemno 
			<cfif not isdefined("form.include0")>
				and (ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) <> 0
			</cfif>
			<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between '#form.productfrom#' and '#form.productto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			group by a.itemno 
			order by a.itemno 
		</cfquery>
	</cfif>
	
	<cfset thislastaccdate = "">
</cfif>

<body>


<table width="80%" border="0" align="center" cellspacing="0">
  	<cfoutput>
    <tr>
      	<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong><cfif hcomid eq "pnp_i">STOCK CARD DETAILS<cfelse>STOCK CARD SUMMARY</cfif></strong></font></div></td>
	</tr>
    <cfif trim(catefrom) neq "" and trim(cateto) neq "">
    	<tr>
        	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">#getgeneral.lCATEGORY# From #catefrom# To #cateto#</font></div></td>
      	</tr>
    </cfif>
    <cfif trim(groupfrom) neq "" and trim(groupto) neq "">
      	<tr>
        	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">#getgeneral.lGROUP# From #groupfrom# To #Groupto#</font></div></td>
      	</tr>
    </cfif>
	<cfif trim(productfrom) neq "" and trim(productto) neq "">
      	<tr>
        	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Product From #productfrom# To #productto#</font></div></td>
      	</tr>
    </cfif>
    <cfif trim(suppfrom) neq "" and trim(suppto) neq "">
      	<tr>
        	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Supplier From #suppfrom# To #suppto#</font></div></td>
      	</tr>
    </cfif>
   
      	<tr>
        	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Period #periodfrom#</font></div></td>
      	</tr>

    <tr>
    	<td colspan="5"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
      	<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
  	</cfoutput>
  	<tr>
		<td colspan="100%"><hr></td>
  	</tr>
    </table>
    <table width="80%" border="2" align="center" cellspacing="0">
  	<tr>
    	
    	<td rowspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></div></td>
		<td rowspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
    	<td rowspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif">QTY B/F </font></div></td>
    	<td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>01</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>02</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>03</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>04</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>05</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>06</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>07</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>08</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>09</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>10</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>11</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>12</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>13</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>14</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>15</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>16</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>17</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>18</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>19</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>20</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>21</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>22</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>23</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>24</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>25</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>26</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>27</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>28</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>29</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>30</cfoutput></font></div></td>
        <td colspan="2"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>31</cfoutput></font></div></td>
        
        
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
   	 	<td><div align="center"><font size="2" face="Times New Roman, Times, serif">BALANCE</font></div></td>
     	<td><div align="center"><font size="2" face="Times New Roman, Times, serif">SP ($)</font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">ACTION</font></div></td>
  	</tr>
    <tr>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    </tr>
  	<tr>
		<td colspan="100%"><hr></td>
  	</tr>

	<cfloop query="getitem">
		<cfoutput>
        <!--- get perday quantity in --->
        <cfquery name="getin01" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and wos_date ='#yearmonth#/01'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin02" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/02'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin03" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/03'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin04" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/04'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin05" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/05'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin06" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/06'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin07" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/07'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin08" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/08'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin09" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/09'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin10" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/10'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin11" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/11'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin12" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/12'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin13" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/13'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin14" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/14'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin15" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/15'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin16" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/16'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin17" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/17'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin18" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/18'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin19" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/19'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin20" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/20'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin21" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/21'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin22" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/22'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin23" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/23'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin24" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/24'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin25" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/25'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin26" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/26'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin27" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/27'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin28" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/28'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin29" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/29'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin30" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/30'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getin31" datasource="#dts#">
        select sum(qty) as qin 
				from ictran 
				where type in (#PreserveSingleQuotes(intrantype)#)
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
	    		and wos_date ='#yearmonth#/31'
                and itemno ='#getitem.itemno#'				
                    group by itemno
        </cfquery>
        
        <cfquery name="getout01" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/01'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout02" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/02'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
                
        <cfquery name="getout03" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/03'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout04" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/04'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout05" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/05'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout06" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/06'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout07" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/07' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout08" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/08'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout09" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/09'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout10" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/10'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout11" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/11'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout12" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/12' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout13" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/13'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout14" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/14'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout15" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/15'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout16" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/16'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout17" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/17'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout18" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/18'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout19" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/19'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout20" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/20'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout21" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/21'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout22" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/22'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout23" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/23'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout24" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/24'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout25" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/25'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout26" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/26'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout27" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/27'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout28" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/28'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout29" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/29'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout30" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/30' 
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
        <cfquery name="getout31" datasource="#dts#">
        select itemno,sum(qty) as qout 
				from ictran 
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			and wos_date ='#yearmonth#/31'
                and itemno ='#getitem.itemno#'
	    		group by itemno
        </cfquery>
        
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		
        
      		<td nowrap><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
      		<td nowrap><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
			<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.qtybf#</font></div></td>
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin01.recordcount eq 0>&nbsp;<cfelse>#getin01.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout01.recordcount eq 0>&nbsp;<cfelse>#getout01.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin02.recordcount eq 0>&nbsp;<cfelse>#getin02.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout02.recordcount eq 0>&nbsp;<cfelse>#getout02.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin03.recordcount eq 0>&nbsp;<cfelse>#getin03.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout03.recordcount eq 0>&nbsp;<cfelse>#getout03.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin04.recordcount eq 0>&nbsp;<cfelse>#getin04.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout04.recordcount eq 0>&nbsp;<cfelse>#getout04.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin05.recordcount eq 0>&nbsp;<cfelse>#getin05.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout05.recordcount eq 0>&nbsp;<cfelse>#getout05.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin06.recordcount eq 0>&nbsp;<cfelse>#getin06.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout06.recordcount eq 0>&nbsp;<cfelse>#getout06.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin07.recordcount eq 0>&nbsp;<cfelse>#getin07.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout07.recordcount eq 0>&nbsp;<cfelse>#getout07.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin08.recordcount eq 0>&nbsp;<cfelse>#getin08.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout08.recordcount eq 0>&nbsp;<cfelse>#getout08.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin09.recordcount eq 0>&nbsp;<cfelse>#getin09.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout09.recordcount eq 0>&nbsp;<cfelse>#getout09.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin10.recordcount eq 0>&nbsp;<cfelse>#getin10.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout10.recordcount eq 0>&nbsp;<cfelse>#getout10.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin11.recordcount eq 0>&nbsp;<cfelse>#getin11.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout11.recordcount eq 0>&nbsp;<cfelse>#getout11.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin12.recordcount eq 0>&nbsp;<cfelse>#getin12.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout12.recordcount eq 0>&nbsp;<cfelse>#getout12.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin13.recordcount eq 0>&nbsp;<cfelse>#getin13.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout13.recordcount eq 0>&nbsp;<cfelse>#getout13.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin14.recordcount eq 0>&nbsp;<cfelse>#getin14.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout14.recordcount eq 0>&nbsp;<cfelse>#getout14.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin15.recordcount eq 0>&nbsp;<cfelse>#getin15.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout15.recordcount eq 0>&nbsp;<cfelse>#getout15.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin16.recordcount eq 0>&nbsp;<cfelse>#getin16.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout16.recordcount eq 0>&nbsp;<cfelse>#getout16.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin17.recordcount eq 0>&nbsp;<cfelse>#getin17.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout17.recordcount eq 0>&nbsp;<cfelse>#getout17.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin18.recordcount eq 0>&nbsp;<cfelse>#getin18.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout18.recordcount eq 0>&nbsp;<cfelse>#getout18.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin19.recordcount eq 0>&nbsp;<cfelse>#getin19.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout19.recordcount eq 0>&nbsp;<cfelse>#getout19.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin20.recordcount eq 0>&nbsp;<cfelse>#getin20.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout20.recordcount eq 0>&nbsp;<cfelse>#getout20.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin21.recordcount eq 0>&nbsp;<cfelse>#getin21.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout21.recordcount eq 0>&nbsp;<cfelse>#getout21.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin22.recordcount eq 0>&nbsp;<cfelse>#getin22.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout22.recordcount eq 0>&nbsp;<cfelse>#getout22.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin23.recordcount eq 0>&nbsp;<cfelse>#getin23.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout23.recordcount eq 0>&nbsp;<cfelse>#getout23.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin24.recordcount eq 0>&nbsp;<cfelse>#getin24.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout24.recordcount eq 0>&nbsp;<cfelse>#getout24.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin25.recordcount eq 0>&nbsp;<cfelse>#getin25.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout25.recordcount eq 0>&nbsp;<cfelse>#getout25.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin26.recordcount eq 0>&nbsp;<cfelse>#getin26.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout26.recordcount eq 0>&nbsp;<cfelse>#getout26.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin27.recordcount eq 0>&nbsp;<cfelse>#getin27.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout27.recordcount eq 0>&nbsp;<cfelse>#getout27.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin28.recordcount eq 0>&nbsp;<cfelse>#getin28.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout28.recordcount eq 0>&nbsp;<cfelse>#getout28.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin29.recordcount eq 0>&nbsp;<cfelse>#getin29.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout29.recordcount eq 0>&nbsp;<cfelse>#getout29.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin30.recordcount eq 0>&nbsp;<cfelse>#getin30.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout30.recordcount eq 0>&nbsp;<cfelse>#getout30.qout#</cfif></font></div></td>
            
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getin31.recordcount eq 0>&nbsp;<cfelse>#getin31.qin#</cfif></font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif getout31.recordcount eq 0>&nbsp;<cfelse>#getout31.qout#</cfif></font></div></td>
            

      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.qin#</font></div></td>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.qout#</font></div></td>
			<cfset balanceqty=val(getitem.qtybf)+val(getitem.qin)-val(getitem.qout)>
      		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#balanceqty#</font></div></td>
            <cfquery name="getprice" datasource="#dts#">
            select price from icitem where itemno='#getitem.itemno#'
            </cfquery>
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#lsnumberformat(getprice.price,',_.__')#</font></div></td>
            <td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">#lsnumberformat((getprice.price*getitem.qout),',_.__')#</font></div></td>
			
			<cfset grandtotalprice=grandtotalprice+(getprice.price*getitem.qout)>
            <cfset grandqtybf=grandqtybf+val(getitem.qtybf)>
            <cfset grandqtyin=grandqtyin+val(getitem.qin)>
            <cfset grandqtyout=grandqtyout+val(getitem.qout)>
            <cfset grandbalanceqty=grandbalanceqty+val(balanceqty)>
            <cfif lcase(hcomid) eq "gel_i">
            	<cfset grandqtysold=grandqtysold+val(sqty)>
                <cfset grandsalesamt=grandsalesamt+val(sumamt)>
			</cfif>
			
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
			<cfset netqty=val(balanceqty)-val(getitem.SOqty)>
				<cfset grandSOqty=grandSOqty+val(getitem.SOqty)>
                
				<cfset grandnetqty=grandnetqty+netqty>
				<cfset grandPOqty=grandPOqty+val(getitem.POqty)>
                <cfset grossqty=netqty+val(getitem.POqty)>
				<cfset grandgrossqty=grandgrossqty+grossqty>
			</cfif>
			
	  		<td nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">
			<a href="dailystockcard3.cfm?itemno=#urlencodedformat(itemno)#&itembal=#getitem.qtybf#&pf=#urlencodedformat(productfrom)#&pt=#urlencodedformat(productto)#&cf=#catefrom#&ct=#cateto#&pef=#periodfrom#&gpf=#groupfrom#&gpt=#groupto#&sf=#urlencodedformat(suppfrom)#&st=#urlencodedformat(suppto)#&thislastaccdate=#thislastaccdate#<cfif isdefined ('form.cbcate')>&category=#category#</cfif><cfif isdefined ('form.cbbrand')>&brand=#brand#</cfif><cfif isdefined ('form.cbrating')>&rating=#costcode#</cfif><cfif isdefined('form.exclude')>&exclude=Y</cfif><cfif isdefined('form.include')>&include=Y</cfif>">View Details</a></font></div></td>

			<!--- <cfif UCASE(HcomID) eq "IDI" or UCASE(HcomID) eq "ECN" or UCASE(HcomID) eq "GEM" or UCASE(HcomID) eq "JVG">
				<cfif HUserGrpID eq "admin" or HUserGrpID eq "super">
					<a href="stockcard3.cfm?itemno=#urlencodedformat(itemno)#&itembal=#getitem.qtybf#&pf=#urlencodedformat(productfrom)#&pt=#urlencodedformat(productto)#&cf=#catefrom#&ct=#cateto#&pef=#periodfrom#&pet=#periodto#&gpf=#groupfrom#&gpt=#groupto#&df=#datefrom#&dt=#dateto#&sf=#urlencodedformat(suppfrom)#&st=#urlencodedformat(suppto)#">View Details</a></font></div></td>
				</cfif>
			<cfelse>
				<a href="stockcard3.cfm?itemno=#urlencodedformat(itemno)#&itembal=#getitem.qtybf#&pf=#urlencodedformat(productfrom)#&pt=#urlencodedformat(productto)#&cf=#catefrom#&ct=#cateto#&pef=#periodfrom#&pet=#periodto#&gpf=#groupfrom#&gpt=#groupto#&df=#datefrom#&dt=#dateto#&sf=#urlencodedformat(suppfrom)#&st=#urlencodedformat(suppto)#">View Details</a></font></div></td>
			</cfif> --->
    	</tr>
		</cfoutput>
  	</cfloop>
    <tr>
        <td colspan="100%"><hr></td>
	</tr>
    <tr>
        <td></td>
        
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL:</font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(grandqtybf,"0")#</cfoutput></font></div></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td></td>
		<td></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(grandqtyin,"0")#</cfoutput></font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(grandqtyout,"0")#</cfoutput></font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(grandbalanceqty,"0")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Total Sales W/O GST :</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(grandtotalprice,",_.__")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Less : 7% GST :</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(grandtotalprice*0.07,",_.__")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Total :</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(grandtotalprice*0.93,",_.__")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Less : Trade Com.35%</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat((grandtotalprice*0.93)*0.35,",_.__")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Total :</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(grandtotalprice-((grandtotalprice*0.93)*0.35),",_.__")#</cfoutput></font></div></td>
    </tr>
    <cfset total1=grandtotalprice-((grandtotalprice*0.93)*0.35)>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Add : 7% GST</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(total1*0.07,",_.__")#</cfoutput></font></div></td>
    </tr>
    <tr>
    <td colspan="62"></td>
    <td colspan=" 7">Total Amount Due :</td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#lsnumberformat(total1*1.07,",_.__")#</cfoutput></font></div></td>
    </tr>
</table>
</body>
</html>
</cfcase>
</cfswitch>