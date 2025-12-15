<html>
<head>
<title><cfif hcomid eq "pnp_i">Stock Card3 Details<cfelse>Stock Card3</cfif></title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfset itemno=itemno>

<cfquery name="getdisplaydetail" datasource="#dts#">
select * from displaysetup
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
select * from modulecontrol
</cfquery>

<!--- Add On 28-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select include_SO_PO_stockcard from dealer_menu limit 1
</cfquery>

<cfparam name="totalin" default="0">
<cfparam name="totalout" default="0">

<cfif df neq "" and dt neq "">
	<cfset dd=dateformat(df,"DD")>

	<cfif dd greater than "12">
		<cfset ndatefrom=dateformat(df,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom=dateformat(df,"YYYYDDMM")>
	</cfif>

	<cfset dd=dateformat(dt,"DD")>

	<cfif dd greater than "12">
		<cfset ndateto=dateformat(dt,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto=dateformat(dt,"YYYYDDMM")>
	</cfif>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select 
	compro,cost,
	lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION 
	from gsetup;
</cfquery>
<cfif thislastaccdate neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = '#DateFormat(thislastaccdate,"yyyy-mm-dd")#'
		limit 1
	</cfquery>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
            a.aitemno,
			a.desp,
            b.custno,
            a.sizeid,
			a.qtybf,
            b.consignment,
			b.refno,
            b.refno2,
            b.location,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			b.price,
            b.IT_COS,
			b.qty,
			b.toinv,
            b.trancode,
			(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
		
			from icitem_last_year a,ictran b
		
			where a.itemno=b.itemno 
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null) 
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and (b.type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN','SO','PO') or 
				(b.type='INV' and b.refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
			<cfelse>
				and (b.type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN') or 
				(b.type='INV' and b.refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))
			</cfif> 
			and b.fperiod='99'
			and b.wos_date > '#DateFormat(getdate.LastAccDate,"yyyy-mm-dd")#'
			and b.wos_date <= '#DateFormat(getdate.ThisAccDate,"yyyy-mm-dd")#'
			<cfif df neq "" and dt neq "">
				and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
			</cfif>
			and a.LastAccDate='#DateFormat(getdate.LastAccDate,"yyyy-mm-dd")#'
			and a.ThisAccDate='#DateFormat(getdate.ThisAccDate,"yyyy-mm-dd")#'
            <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and toinv <> "" and type = "DO" group by toinv)
			</cfif>
			order by b.wos_date
		</cfquery>
	<cfelse>
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
            a.aitemno,
			a.desp,
            a.sizeid,
            b.location,
            b.consignment,
			a.qtybf,
			b.refno,
            b.custno,
            b.refno2,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			<cfif lcase(hcomid) eq "ovas_i" or lcase(hcomid) eq "gramas_i" or lcase(hcomid) eq "aipl_i" or lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "aspi_i">
				if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
			<cfelse>
				if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			</cfif>
			b.price,
            b.IT_COS,
			b.qty,
			b.toinv,
            b.trancode,
			(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
			<cfif lcase(hcomid) eq "ovas_i">
				,c.drivername
			</cfif>
            ,d.created_on,d.rem1,d.rem2
		
			from icitem_last_year a,ictran b,artran d
			<cfif lcase(hcomid) eq "ovas_i">
				,(
					select a.type,a.refno,a.van,concat(dr.name,' ',dr.name2) as drivername 
					from artran a
					left join driver dr on a.van=dr.driverno
					
					where 0=0
					<cfif df neq "" and dt neq "">
						and a.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
					</cfif>
				)as c
			</cfif>
		
			where a.itemno=b.itemno 
            and d.refno=b.refno and if(b.type='TROU' or b.type='TRIN','TR',b.type)=d.type
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null)
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and b.type not in ('QUO','SAM')
			<cfelse>
				and b.type not in ('QUO','SO','PO','SAM')
			</cfif> 
			and b.fperiod='99'
			and b.wos_date > '#DateFormat(getdate.LastAccDate,"yyyy-mm-dd")#'
			and b.wos_date <= '#DateFormat(getdate.ThisAccDate,"yyyy-mm-dd")#'
			<cfif df neq "" and dt neq "">
				and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
			</cfif>
			<cfif lcase(hcomid) eq "ovas_i">
				and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
			</cfif>
			and a.LastAccDate='#DateFormat(getdate.LastAccDate,"yyyy-mm-dd")#'
			and a.ThisAccDate='#DateFormat(getdate.ThisAccDate,"yyyy-mm-dd")#'
            <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and toinv <> "" and type = "DO" group by toinv)
			</cfif>
			order by b.wos_date,d.trdatetime
		</cfquery>
	</cfif>
	
<cfelse>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
            a.aitemno,
			a.desp,
            a.sizeid,
            b.location,
            b.consignment,
			a.qtybf,
			b.refno,
            b.custno,
            b.refno2,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			b.price,
            b.IT_COS,
			b.qty,
			b.toinv,
            b.trancode,
			(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
		
			from icitem a,ictran b
		
			where a.itemno=b.itemno 
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null) 
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and (type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN','SO','PO') or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
			<cfelse>
				and (type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN') or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
			</cfif> 
			
			and b.fperiod<>'99'
			<cfif pef neq "" and pet neq "">
				and b.fperiod+0 between '#pef#' and '#pet#'
			</cfif>
			<cfif df neq "" and dt neq "">
				and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
			<cfelse>
				and b.wos_date > #getgeneral.lastaccyear#
			</cfif>
             <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and toinv <> "" and type = "DO" group by toinv)
			</cfif>
			order by b.wos_date, a.created_on
		</cfquery>
	<cfelse>
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
            a.aitemno,
			a.desp,
			a.qtybf,
            a.sizeid,
			b.refno,
            b.location,
            b.consignment,
            b.custno,
            b.refno2,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			<cfif lcase(hcomid) eq "ovas_i" or lcase(hcomid) eq "gramas_i" or lcase(hcomid) eq "aipl_i" or lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "aspi_i">
				if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
			<cfelse>
				if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			</cfif>
			b.price,
            b.IT_COS,
			b.qty,
			b.toinv,
            b.trancode,
            d.created_on,d.rem1,d.rem2,
			(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
			<cfif lcase(hcomid) eq "ovas_i">
				,c.drivername
			</cfif>
            
		
			from icitem a,ictran b,artran d
			<cfif lcase(hcomid) eq "ovas_i">
				,(
					select a.type,a.refno,a.van,concat(dr.name,' ',dr.name2) as drivername 
					from artran a
					left join driver dr on a.van=dr.driverno
					
					where 0=0
					<cfif pef neq "" and pet neq "">
						and a.fperiod+0 between '#pef#' and '#pet#'
					</cfif>
					<cfif df neq "" and dt neq "">
						and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
					<cfelse>
						and a.wos_date > #getgeneral.lastaccyear#
					</cfif>
				)as c
			</cfif>
		
			where a.itemno=b.itemno 
            and d.refno=b.refno and if(b.type='TROU' or b.type='TRIN','TR',b.type)=d.type
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null) 
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and b.type not in ('QUO','SAM')
			<cfelse>
				and b.type not in ('QUO','SO','PO','SAM')
			</cfif> 
			and b.fperiod<>'99'
			<cfif pef neq "" and pet neq "">
				and b.fperiod+0 between '#pef#' and '#pet#'
			</cfif>
			<cfif df neq "" and dt neq "">
				and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
			<cfelse>
				and b.wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif lcase(hcomid) eq "ovas_i">
				and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
			</cfif>
             <cfif isdefined('url.exclude')>
            and (b.toinv = "" or b.toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and b.refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and toinv <> "" and type = "DO" group by toinv)
			</cfif>
			order by b.wos_date,d.trdatetime
		</cfquery>
	</cfif>
	
</cfif>
<!--- <cfquery name="getictran" datasource="#dts#">
	select 
	a.itemno,
	a.desp,
	a.qtybf,
	b.refno,
	b.refmo2,
	b.itemno,
	b.type,
	b.dono,
	b.wos_date,
	if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
	b.price,
	b.qty,
	b.toinv,
	(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
	
	from icitem a,ictran b
	
	where a.itemno=b.itemno 
	and a.itemno='#itemno#' 
	and (b.void = '' or b.void is null) 
	and b.type not in ('QUO','SO','PO','SAM')
	and b.fperiod<>'99'
	<cfif pef neq "" and pet neq "">
	and b.fperiod between '#pef#' and '#pet#'
	</cfif>
	<cfif df neq "" and dt neq "">
	and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
	<cfelse>
	and b.wos_date > #getgeneral.lastaccyear#
	</cfif>
	order by b.wos_date, b.trdatetime
</cfquery> --->

<body>
<p align="center"><font color="#000000" size="4" face="Times New Roman, Times, serif"><strong>STOCK CARD DETAILS</strong></font></p>

<table width="100%" border="0" align="center" cellspacing="0">
<cfoutput>
	<cfif cf neq "" and ct neq "">
		<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">#getgeneral.lCATEGORY# From #cf# To #ct#</font></td>
      	</tr>
    </cfif>
    <cfif gpf neq "" and gpt neq "">
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">#getgeneral.lGROUP# From #gpf# To #gpt#</font></td>
		</tr>
    </cfif>
    <cfif sf neq "" and st neq "">
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Supplier From #sf# To #st#</font></td>
      	</tr>
    </cfif>
    <cfif pef neq "" and pet neq "">
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Period From #pef# To #pet#</font></td>
      	</tr>
    </cfif>
    <cfif df neq "" and dt neq "">
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Date From #df# To #dt#</font></td>
      	</tr>
    </cfif>
    <cfif isdefined('category')>
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Category = #url.category#</font></td>
      	</tr>
    </cfif>
    
    <cfif isdefined('brand')>
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Brand = #url.brand#</font></td>
      	</tr>
    </cfif>
    
    <cfif isdefined('rating')>
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Rating = #url.rating#</font></td>
      	</tr>
    </cfif>
    
    <tr>
      	<td colspan="7"><cfif getgeneral.compro neq ""><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></cfif></td>
		<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
	<tr>
        <td colspan="9"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #itemno# - #getictran.desp#</font></td>
     
    </tr>
    <cfif getdisplaydetail.report_aitemno eq 'Y'>
    <tr>
        <td colspan="9"><font size="2" face="Times New Roman, Times, serif">PRODUCT CODE: #getictran.aitemno#</font></td>
     
    </tr>
    </cfif>
    <cfif lcase(hcomid) eq "sjpst_i">
        <tr>
        <td colspan="9"><font size="2" face="Times New Roman, Times, serif">Size: #getictran.sizeid#</font></td>
        
    </tr>
    </cfif>
	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
  	<tr>
    	<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REFNO</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">REFNO 2</font></div></td>
        <cfif lcase(hcomid) eq "netsource_i">
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">LOCATION</font></div></td>
        </cfif>
        <cfif getmodule.auto eq '1'>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">VEHICLE NO</font></div></td>
        </cfif>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">BALANCE</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
        
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">COST P.</font></div></td>
        <cfif lcase(hcomid) neq "epsilon_i">
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SELL P.</font></div></td>
        </cfif>
        <cfif lcase(hcomid) eq "epsilon_i">
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">COST PRICE</font></div></td>
        </cfif>
        <cfif lcase(hcomid) neq "epsilon_i">
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
        </cfif>
        </cfif>
        <cfif lcase(hcomid) eq "excelsnm_i" and getpin2.h42A0 neq 'T'>
        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">SELL P.</font></div></td>
        </cfif>
  	</tr>
  	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
  	<tr>
    	<td></td>
    	<td></td>
        <cfif getmodule.auto eq '1'>
        <td></td>
        </cfif>
        <cfif lcase(hcomid) eq "netsource_i">
        <td></td>
        </cfif>
        <td></td>
    	<td><font size="2" face="Times New Roman, Times, serif">Balance B/F:</font></td>
    	<td></td>
   	 	<td></td>
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font></td>
        <cfif thislastaccdate neq "">
        <cfquery name="getcost" datasource="#dts#">
        select ffc11 from fifoopq_last_year where itemno='#itemno#'
        </cfquery>
        <cfquery name="getcost2" datasource="#dts#">
        select ucost,avcost,avcost2 from icitem_last_year where itemno='#itemno#'
        </cfquery>
        <cfelse>
        <cfquery name="getcost" datasource="#dts#">
        select ffc11 from fifoopq where itemno='#itemno#'
        </cfquery>
        <cfquery name="getcost2" datasource="#dts#">
        select ucost,avcost,avcost2 from icitem where itemno='#itemno#'
        </cfquery>
        </cfif>
        <cfif getpin2.h42A0 eq 'T'>
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><cfif getgeneral.cost eq "FIFO">#lsnumberformat(getcost.ffc11,',_.____')#<cfelse><cfif getgeneral.cost eq "Month">#lsnumberformat(getcost2.avcost,',_.____')#<cfelseif getgeneral.cost eq "Moving">#lsnumberformat(getcost2.avcost2,',_.____')#<cfelse>#lsnumberformat(getcost2.ucost,',_.____')#</cfif></cfif></div></font></td>

        <cfif lcase(hcomid) neq "epsilon_i">
        <td></td>
        </cfif>
        <cfif lcase(hcomid) neq "epsilon_i">
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><cfif itembal neq '' and itembal neq 0><cfif getgeneral.cost eq "FIFO">#lsnumberformat(val(getcost.ffc11)*val(itembal),',_.__')#<cfelse>
		
        <cfif getgeneral.cost eq "Month">#lsnumberformat(val(getcost2.avcost)*val(itembal),',_.____')#<cfelseif getgeneral.cost eq "Moving">#lsnumberformat(val(getcost2.avcost2)*val(itembal),',_.____')#<cfelse>#lsnumberformat(val(getcost2.ucost)*val(itembal),',_.____')#</cfif>
		</cfif></cfif></div></font></td></cfif>
        </cfif>
  	</tr>
  <cfloop query="getictran">
  <cfif isdefined('url.dodate')>
   <cfif type eq "INV">
  <cfquery name="checkexist2" datasource="#dts#">
  select toinv,refno,type,itemno from ictran a  where refno ='#getictran.refno#' and itemno =<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and type = "#getictran.type#" and trancode = "#getictran.trancode#" and (dono = "" or dono is null or dono not in (select frrefno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by frrefno))
  </cfquery>
  </cfif>
  </cfif>
		<cfif ((type eq "PO" or type eq "SO") and getictran.toinv eq "") or (type neq "PO" and type neq "SO")>
    	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#dateformat(wos_date,"dd/mm/yy")#</font></div></td>
            <cfquery name="getrefno2" datasource="#dts#">
            select refno2,rem5 from artran where refno='#refno#' and type='#type#'
            </cfquery>
      		<td>
				<div align="left"><font size="2" face="Times New Roman, Times, serif"><cfif consignment neq ''>#replace(type,'TR','CG')#<cfelse>#type#</cfif> #refno#</font></div>
			</td>
            
            <td>
				<div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.refno2#</font></div>
			</td>
            <cfif getmodule.auto eq '1'>
        	<td>
				<div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.rem5#</font></div>
			</td>
            
            
            <cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN" or type eq "PO">
            <cfquery name="getcustname" datasource="#dts#">
            select name from #target_apvend# where custno='#custno#'
            </cfquery>
            <cfelse>
            <cfquery name="getcustname" datasource="#dts#">
            select name from #target_arcust# where custno='#custno#'
            </cfquery>
            </cfif>
            
        	</cfif>
            <cfif lcase(hcomid) eq "netsource_i">
        	<td>
				<div align="left"><font size="2" face="Times New Roman, Times, serif">#LOCATION#</font></div>
			</td>
        	</cfif>
            
      		<td><font size="2" face="Times New Roman, Times, serif"><cfif type eq "TRIN" or type eq "TROU">Transfer From #rem1# To #rem2#<cfelse><cfif getmodule.auto eq '1'>#getcustname.name#<cfelse>#name#</cfif><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "gramas_i"><cfif type eq 'CS'> - #location#</cfif></cfif><cfif lcase(hcomid) eq "ovas_i" and drivername neq ""> - #drivername#</cfif></cfif></font></td>
            
      		<td>
				<cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN" or type eq "PO">
          			<cfset itembal = val(itembal) + val(qty)>
          			<cfset totalin = totalin + val(qty)>
         			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
				</cfif>
			</td>
      		<td>
				<cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO") or (lcase(HcomID) eq "eocean_i" and type eq "CT")>
          			<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
						<cfset itembal = val(itembal) - val(qty)>
	            		<cfset totalout = totalout + val(qty)>
	            		<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
					<cfelse>
                    
					<cfif isdefined('url.dodate')>
                    
                    <cfif type eq "DO" and isdefined('url.include') eq false>
                        <cfset itembal = val(itembal) - val(qty)>
	            		<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty# / INV #toinv#</div></font>
						<cfelseif type eq "INV" and checkexist2.recordcount eq 0 and isdefined('url.include') eq false>
                        
						<cfelse>
	            			<cfset itembal = val(itembal) - val(qty)>
	            			<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
	          			</cfif>
                    <cfelse>
						<cfif type eq "DO" and toinv neq "" and isdefined('url.include') eq false>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">INV #toinv#</div></font>
						<cfelse>
	            			<cfset itembal = val(itembal) - val(qty)>
	            			<cfset totalout = totalout + val(qty)>
	            			<font size="2" face="Times New Roman, Times, serif"><div align="right">#qty#</div></font>
	          			</cfif>
                        </cfif>
					</cfif>
        		</cfif>
			</td>
      		<td>
				<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
					<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
				<cfelse>
                <cfif isdefined('url.dodate')>
                <cfif type eq "INV" and checkexist2.recordcount eq 0 and isdefined('url.include') eq false>
	          		<cfelse>
	          			<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
	          		</cfif>
				<cfelse>
					<cfif type eq "DO" and toinv neq "" and isdefined('url.include') eq false>
	          		<cfelse>
	          			<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
	          		</cfif>
                    </cfif>
				</cfif>
			</td>
            <cfif getpin2.h42A0 eq 'T'>
            
      		<td><cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN" or type eq "PO">
            	
                
          			<div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "widos_i" or lcase(hcomid) eq "derotech_i" or lcase(hcomid) eq "supporttest_i"><cfif type eq 'CN'><cfif val(getlastrc.qty) eq 0>#numberformat(val(getlastrc.amt),",.____")#<cfelse>#numberformat(val(getlastrc.amt)/val(getlastrc.qty),",.____")#</cfif><cfelse><cfif qty eq 0>#numberformat(price,",.____")#<cfelse>#numberformat(amt/qty,",.____")#</cfif></cfif><cfelse>#numberformat(price,",.____")#</cfif></font> </div>
                </cfif>

			</td>
            <cfif lcase(hcomid) neq "epsilon_i">
      		<td><cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO") or (lcase(HcomID) eq "eocean_i" and type eq "CT")>
         	 		<font size="2" face="Times New Roman, Times, serif"><div align="right"><cfif lcase(hcomid) eq "widos_i" or lcase(hcomid) eq "derotech_i"><cfif qty eq 0>#numberformat(price,",.____")#<cfelse>#numberformat(amt/qty,",.____")#</cfif><cfelse>#numberformat(price,",.____")#</cfif><cfif huserid eq 'ultralung' or huserid eq 'ultrairene'><cfif qty eq 0>---#it_cos#<cfelse>---#it_cos/qty#</cfif></cfif></div></font>
          		</cfif>
			</td>
            </cfif>
            <cfif lcase(hcomid) eq "epsilon_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(it_cos,",.____")#</font> </div></td>
            <cfelseif lcase(hcomid) eq "widos_i" or lcase(hcomid) eq "derotech_i">
            
            
            <td><font size="2" face="Times New Roman, Times, serif"><div align="right"><cfif type eq 'CN'><cfif val(getlastrc.qty) eq 0>#numberformat(amt,",.__")#<cfelse>#numberformat((val(getlastrc.amt)/val(getlastrc.qty))*qty,",.__")#</cfif><cfelse>#numberformat(amt,",.__")#</cfif></div></font></td>
            <cfelse>
      		<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(amt,",.__")#</div></font></td>
            </cfif>
    	</tr>
        </cfif>
         <cfif lcase(hcomid) eq "excelsnm_i" and getpin2.h42A0 neq 'T'>
        <td><cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO") or (lcase(HcomID) eq "eocean_i" and type eq "CT")>
         	 		<font size="2" face="Times New Roman, Times, serif"><div align="right"><cfif lcase(hcomid) eq "widos_i" or lcase(hcomid) eq "derotech_i"><cfif qty eq 0>#numberformat(price,",.____")#<cfelse>#numberformat(amt/qty,",.____")#</cfif><cfelse>#numberformat(price,",.____")#</cfif><cfif huserid eq 'ultralung' or huserid eq 'ultrairene'><cfif qty eq 0>---#it_cos#<cfelse>---#it_cos/qty#</cfif></cfif></div></font>
          		</cfif>
			</td>
        </cfif>
		<cfif (lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i") and  type eq "DO">
			<cfquery name="getinv" datasource="#dts#">
				select * from iclink 
				where frtype='DO' and type='INV' and frrefno='#refno#'
				group by type,refno
			</cfquery>
			<cfif getinv.recordcount neq 0>
				<cfloop query="getinv">
					<tr>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">INV #getinv.refno#</font></div></td>
					</tr>
				</cfloop>
			</cfif>
		</cfif>
		</cfif>
  	</cfloop>
	<tr>
    	<td colspan="100%"><hr></td>
  	</tr>
    <tr>
      	<td></td>
        <cfif getmodule.auto eq '1'>
        <td></td>
        </cfif>
        <cfif lcase(hcomid) eq "netsource_i">
        <td></td>
        </cfif>
      	<td></td>
        <td></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>Total:</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#totalin#</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#totalout#</strong></div></font></td>
      	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><strong>#itembal#</strong></div></font></td>
      	<td></td>
      	<td></td>
      	<td></td>
    </tr>
  	</cfoutput>
</table>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>