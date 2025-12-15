<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>

<html>
<head>
<title>View Item-<cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Report</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select 
	compro,
	lastaccyear,
    singlelocation
	from gsetup;
</cfquery>

<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat(',.',repeat('_',decl_uprice)) as decl_uprice
	from gsetup2;
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_UPrice>

<cfquery name="getlocation" datasource="#dts#">
	select 
	a.location,
	(select desp from iclocation where location=a.location) as desp
	from ictran as a,icitem as b 
	where a.type in 
	<cfif form.type eq "1">
	('INV','CS','DN','CN') 
	<cfelse>
	('RC','PR') 
	</cfif>
	and a.itemno=b.itemno
	and (a.void = '' or a.void is null) 
	<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and b.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
	</cfif>
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
	and b.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	and b.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
	</cfif>
    <cfif getgeneral.singlelocation eq 'Y'>
    <cfif form.locfrom neq "">
	and a.location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.locfrom#">
	</cfif>
    <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between <cfqueryparam cfsqltype="cf_sql_char" value="#form.locfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.locto#">
	</cfif>
    </cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
	and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
	and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
	and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
	<cfelse>
	and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
	</cfif>
	group by a.location 
	order by a.location;
</cfquery>

<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>

<cfif form.type eq "1">
	<cfset ttinvamt = 0>
	<cfset ttcnamt = 0>
	<cfset ttdnamt = 0>
	<cfset ttcsamt = 0>
	<cfset ttnetamt = 0>
	
	<table width="100%" border="0" cellspacing="3" cellpadding="0">
	<cfoutput>
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman,Times,serif"><strong>ITEM <cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif> #form.typename# REPORT</strong></font></div></td>
		</tr>
		<tr>
			<td colspan="4"><font size="2" face="Times New Roman,Times,serif">#getgeneral.compro#</font>
			<td colspan="5"><div align="right"><font size="2" face="Times New Roman,Times,serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
	</cfoutput>
		<tr>
			<td colspan="8"><hr></td>
		</tr>
		<tr>
			<td width="30%" colspan="2"><div align="left"><font size="2" face="Times New Roman,Times,serif"><cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif></font></div></td>
			<td width="30%"><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">INV</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">CS</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">DN</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">CN</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">TOTAL</font></div></td>
		</tr>
		<tr>
			<td colspan="8"><hr></td>
		</tr>
		
		<cfloop query="getlocation">
			<cfset sttinvamt = 0>
			<cfset sttcnamt = 0>
			<cfset sttdnamt = 0>
			<cfset sttcsamt = 0>
			<cfset sttnetamt = 0>

			<tr>
				<cfoutput>
				<td colspan="2" nowrap><font size="2" face="Times New Roman,Times,serif"><strong><cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif>:</strong> #getlocation.location#</font></td>
				<td colspan="6"><font size="2" face="Times New Roman,Times,serif">#getlocation.desp#</font></td>
				</cfoutput>
			</tr>
			
			<cfquery name="getitem" datasource="#dts#">
				select 
				aa.itemno,
				aa.desp,
				b.inv_amt,
				c.cs_amt,
				d.dn_amt,
				e.cn_amt 
					 
				from (ictran as a,icitem as aa)
				
				left join
				(
					select 
					itemno,
					sum(amt) as inv_amt 
					from ictran 
					where type='INV' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as b on a.itemno=b.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as cs_amt 
					from ictran 
					where type='CS' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as c on a.itemno=c.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as dn_amt 
					from ictran 
					where type='DN' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as d on a.itemno=d.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as cn_amt 
					from ictran 
					where type='CN' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as e on a.itemno=e.itemno
				
				where a.type in ('INV','CS','DN','CN') 
				and a.location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
				and a.itemno=aa.itemno
				and (a.void = '' or a.void is null) 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and aa.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and aa.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
				<cfelse>
				and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
				</cfif>
				group by a.itemno 
				order by a.itemno;
			</cfquery>
			
			<cfloop query="getitem">
				<cfset invamt = val(getitem.inv_amt)>
				<cfset csamt = val(getitem.cs_amt)>
				<cfset dnamt = val(getitem.dn_amt)>
				<cfset cnamt = val(getitem.cn_amt)>
				<cfset netamt = invamt + dnamt + csamt - cnamt>
				
				<cfoutput>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td nowrap><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.currentrow#.</font></div></td>
					<td nowrap><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.itemno#</font></div></td>
					<td nowrap><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitem.desp#</font></div></td>
					<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(invamt,stDecl_UPrice)#</font></div></td>
					<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(csamt,stDecl_UPrice)#</font></div></td>
					<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(dnamt,stDecl_UPrice)#</font></div></td>
					<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(cnamt,stDecl_UPrice)#</font></div></td>
					<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(netamt,stDecl_UPrice)#</font></div></td>
				</tr>
				</cfoutput>
			
				<cfset sttinvamt = sttinvamt + invamt>
				<cfset sttdnamt = sttdnamt + dnamt>
				<cfset sttcnamt = sttcnamt + cnamt>
				<cfset sttcsamt = sttcsamt + csamt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttinvamt = ttinvamt + invamt>
				<cfset ttdnamt = ttdnamt + dnamt>
				<cfset ttcnamt = ttcnamt + cnamt>
				<cfset ttcsamt = ttcsamt + csamt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>
			
			<tr>
				<td colspan="8"><hr></td>
			</tr>
			
			<cfoutput>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td colspan="2"></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">SUB-TOTAL:</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttinvamt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttcsamt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttdnamt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttcnamt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttnetamt,stDecl_UPrice)#</font></div></td>
			</tr>
			</cfoutput>
		</cfloop>
		
		<tr>
		  <td colspan="8"><hr></td>
		</tr>
		
		<cfoutput>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td colspan="2"></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">TOTAL:</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttinvamt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttcsamt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttdnamt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttcnamt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttnetamt,",.__")#</font></div></td>
		  </tr>
		</cfoutput>
	</table>
</cfif>

<cfif form.type eq "2">
	<cfset ttrcamt = 0>
	<cfset ttpramt = 0>
	<cfset ttnetamt = 0>
	
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<cfoutput>
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman,Times,serif"><strong>ITEM <cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif> #TYPENAME# REPORT</strong></font></div></td>
		</tr>
		<tr>
			<td colspan="2"><font size="2" face="Times New Roman,Times,serif">#getgeneral.compro#</font></td>
			<td colspan="4"><div align="right"><font size="2" face="Times New Roman,Times,serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="6"><hr></td>
		</tr>
		<tr>
			<td colspan="2" width="30%"><div align="left"><font size="2" face="Times New Roman,Times,serif"><cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif></font></div></td>
			<td width="30%"><div align="left"><font size="2" face="Times New Roman,Times,serif">DESCRIPTION</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">RC</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">PR</font></div></td>
			<td width="8%"><div align="right"><font size="2" face="Times New Roman,Times,serif">TOTAL</font></div></td>
		</tr>
		<tr>
			<td colspan="6"><hr></td>
		</tr>
	
		<cfloop query="getlocation">
			<cfset sttrcamt = 0>
			<cfset sttpramt = 0>
			<cfset sttnetamt = 0>
			
			<tr>
				<cfoutput>
				<td colspan="2" nowrap><font size="2" face="Times New Roman,Times,serif"><strong><cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif>:</strong> #getlocation.location#</font></td>
				<td colspan="4"><font size="2" face="Times New Roman,Times,serif">#getlocation.desp#</font></td>
				</cfoutput>
			</tr>
			
			<cfquery name="getitem" datasource="#dts#">
				select 
				aa.itemno,
				aa.desp,
				b.rc_amt,
				c.pr_amt
					 
				from (ictran as a,icitem as aa) 
				
				left join
				(
					select 
					itemno,
					sum(amt) as rc_amt 
					from ictran 
					where type='RC' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as b on a.itemno=b.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as pr_amt 
					from ictran 
					where type='PR' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as c on a.itemno=c.itemno
	
				where a.type in ('RC','PR') 
				and a.location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
				and a.itemno=aa.itemno
				and (a.void = '' or a.void is null) 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and aa.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and aa.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
				<cfelse>
				and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
				</cfif>
				group by a.itemno 
				order by a.itemno;
			</cfquery>
			
			<cfloop query="getitem">
				<cfset rcamt = val(getitem.rc_amt)>
				<cfset pramt = val(getitem.pr_amt)>
				<cfset netamt = rcamt - pramt>
				
				<cfoutput>
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td nowrap><font size="2" face="Times New Roman,Times,serif">#getitem.currentrow#.</font></td>
						<td nowrap><font size="2" face="Times New Roman,Times,serif">#getitem.itemno#</font></td>
						<td nowrap><font size="2" face="Times New Roman,Times,serif">#getitem.desp#</font></td>
						<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(rcamt,stDecl_UPrice)#</font></div></td>
						<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(pramt,stDecl_UPrice)#</font></div></td>
						<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(netamt,stDecl_UPrice)#</font></div></td>
					</tr>
				</cfoutput>
				
				<cfset sttrcamt = sttrcamt + rcamt>
				<cfset sttpramt = sttpramt + pramt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttrcamt = ttrcamt + rcamt>
				<cfset ttpramt = ttpramt + pramt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>
			
			<tr>
				<td colspan="6"><hr></td>
			</tr>
			
			<cfoutput>
			<tr>
				<td colspan="2"></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">SUB TOTAL:</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttrcamt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttpramt,stDecl_UPrice)#</font></div></td>
				<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(sttnetamt,stDecl_UPrice)#</font></div></td>
			</tr>
			</cfoutput>
		</cfloop>
	
		<tr>
			<td colspan="6"><hr></td>
		</tr>
	
		<cfoutput>
		<tr>
			<td colspan="2">&nbsp;</td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">TOTAL:</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttrcamt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttpramt,",.__")#</font></div></td>
			<td nowrap><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(ttnetamt,",.__")#</font></div></td>
		</tr>
		</cfoutput>
	</table>
</cfif>
	
<br><br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>