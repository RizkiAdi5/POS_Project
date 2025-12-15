<html>
<head>
<title><cfif hcomid eq "pnp_i">Stock Card3 Details<cfelse>Stock Card3</cfif></title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<!--- Add On 28-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select include_SO_PO_stockcard from dealer_menu limit 1
</cfquery>

<cfparam name="totalin" default="0">
<cfparam name="totalout" default="0">

<cfquery name="getgeneral" datasource="#dts#">
	select 
	compro,
	lastaccyear,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION 
	from gsetup;
</cfquery>
<cfif thislastaccdate neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #thislastaccdate#
		limit 1
	</cfquery>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.qtybf,
			b.refno,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			b.price,
			b.qty,
			b.toinv,
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
			and b.wos_date > #getdate.LastAccDate#
			and b.wos_date <= #getdate.ThisAccDate#
			and a.LastAccDate=#getdate.LastAccDate#
			and a.ThisAccDate=#getdate.ThisAccDate#
            <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and fperiod <> '99' and toinv <> "")
			</cfif>
			order by b.wos_date, b.trdatetime
		</cfquery>
	<cfelse>
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.qtybf,
			b.refno,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			<cfif lcase(hcomid) eq "ovas_i">
				if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
			<cfelse>
				if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			</cfif>
			b.price,
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
				
				)as c
			</cfif>
		
			where a.itemno=b.itemno 
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null)
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and b.type not in ('QUO','SAM')
			<cfelse>
				and b.type not in ('QUO','SO','PO','SAM')
			</cfif> 
			and b.fperiod='99'
			and b.wos_date > #getdate.LastAccDate#
			and b.wos_date <= #getdate.ThisAccDate#
			
			<cfif lcase(hcomid) eq "ovas_i">
				and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
			</cfif>
			and a.LastAccDate=#getdate.LastAccDate#
			and a.ThisAccDate=#getdate.ThisAccDate#
            <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and fperiod <> '99' and toinv <> "")
			</cfif>
			order by b.wos_date, b.trdatetime
		</cfquery>
	</cfif>
	
<cfelse>
	<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.qtybf,
			b.refno,
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
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and (type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN','SO','PO') or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
			<cfelse>
				and (type in ('DO','PR','CS','DN','ISS','OAR','TROU','RC','CN','OAI','TRIN') or 
				(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno))) 
			</cfif> 
			
			and b.fperiod<>'99'
				and b.fperiod+0='#pef#'
			
				and b.wos_date > #getgeneral.lastaccyear#
			
             <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and fperiod <> '99' and toinv <> "")
			</cfif>
			order by b.wos_date, b.trdatetime
		</cfquery>
	<cfelse>
		<cfquery name="getictran" datasource="#dts#">
			select 
			a.itemno,
			a.desp,
			a.qtybf,
			b.refno,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			<cfif lcase(hcomid) eq "ovas_i">
				if(b.type='TROU' or b.type='TRIN',concat('Transfer - ',b.name),b.name) as name,
			<cfelse>
				if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			</cfif>
			b.price,
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
					
						and a.fperiod+0='#pef#'
					
					
						and a.wos_date > #getgeneral.lastaccyear#
					
				)as c
			</cfif>
		
			where a.itemno=b.itemno 
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null) 
			and (b.linecode = '' or b.linecode is null)
			<cfif getdealer_menu.include_SO_PO_stockcard eq "Y">
				and b.type not in ('QUO','SAM')
			<cfelse>
				and b.type not in ('QUO','SO','PO','SAM')
			</cfif> 
			and b.fperiod<>'99'
			
				and b.fperiod+0 = '#pef#' 
			
			
				and b.wos_date > #getgeneral.lastaccyear#
			
			<cfif lcase(hcomid) eq "ovas_i">
				and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
			</cfif>
             <cfif isdefined('url.exclude')>
            and (toinv = "" or toinv is null)
			</cfif>
            <cfif isdefined('url.include')>
            and refno not in (select toinv from ictran where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and fperiod <> '99' and toinv <> "")
			</cfif>
			order by b.wos_date, b.trdatetime
		</cfquery>
	</cfif>
	
</cfif>
<!--- <cfquery name="getictran" datasource="#dts#">
	select 
	a.itemno,
	a.desp,
	a.qtybf,
	b.refno,
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
   
      	<tr>
        	<td colspan="9" align="center"><font size="2" face="Times New Roman, Times, serif">Period #pef# </font></td>
      	</tr>

 
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
	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
  	<tr>
    	<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REFNO</font></div></td>
    	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">IN</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">OUT</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">BALANCE</font></div></td>
        <cfif getpin2.h42A0 eq 'T'>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">COST P.</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SELL P.</font></div></td>
    	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
        </cfif>
  	</tr>
  	<tr>
    	<td colspan="12"><hr></td>
  	</tr>
  	<tr>
    	<td></td>
    	<td></td>
    	<td><font size="2" face="Times New Roman, Times, serif">Balance B/F:</font></td>
    	<td></td>
   	 	<td></td>
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font></td>
    	<td></td>
    	<td></td>
    	<td></td>
  	</tr>
  <cfloop query="getictran">
		<cfif ((type eq "PO" or type eq "SO") and getictran.toinv eq "") or (type neq "PO" and type neq "SO")>
    	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#dateformat(wos_date,"dd/mm/yy")#</font></div></td>
      		<td>
				<div align="left"><font size="2" face="Times New Roman, Times, serif">#type# #refno#</font></div>
			</td>
      		<td><font size="2" face="Times New Roman, Times, serif">#name#<cfif lcase(hcomid) eq "ovas_i" and drivername neq ""> - #drivername#</cfif></font></td>
            
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
						<cfif type eq "DO" and toinv neq "" and isdefined('url.include') eq false>
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
				<cfif lcase(hcomid) eq "redd_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "ge_i">
					<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
				<cfelse>
					<cfif type eq "DO" and toinv neq "" and isdefined('url.include') eq false>
	          		<cfelse>
	          			<font size="2" face="Times New Roman, Times, serif"><div align="right">#itembal#</div></font>
	          		</cfif>
				</cfif>
			</td>
            <cfif getpin2.h42A0 eq 'T'>
      		<td><cfif type eq "RC" or type eq "CN" or type eq "OAI" or type eq "TRIN" or type eq "PO">
          			<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price,",.____")#</font> </div>
        		</cfif>
			</td>
      		<td><cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO") or (lcase(HcomID) eq "eocean_i" and type eq "CT")>
         	 		<font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(price,",.____")#</div></font>
          		</cfif>
			</td>
      		<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(amt,",.__")#</div></font></td>
    	</tr>
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
    	<td colspan="9"><hr></td>
  	</tr>
    <tr>
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