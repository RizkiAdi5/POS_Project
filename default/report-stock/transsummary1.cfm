<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	<cfif dd greater than '12'>
		<cfset ndateto = dateformat(form.dateto,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYYDDMM")>
	</cfif>
</cfif>
<cfif form.datefrom neq "" and form.dateto neq "">
	<cfset date1 = createDate(ListGetAt(form.datefrom,3,"/"),ListGetAt(form.datefrom,2,"/"),ListGetAt(form.datefrom,1,"/"))>
	<cfset date2 = createDate(ListGetAt(form.dateto,3,"/"),ListGetAt(form.dateto,2,"/"),ListGetAt(form.dateto,1,"/"))>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Transaction Summary By Quantity Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<body>
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>TRANSACTION SUMMARY BY QUANTITY REPORT</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(date1,"dd/mm/yyyy")# - #dateformat(date2,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td colspan="6">&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><font size="2" face="Times New Roman, Times, serif">NO.</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">ITEM DESCRIPTION</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">U/M</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">RC</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PR</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">ISS</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">ADJ</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TR</font></div></td>
				<cfif lcase(HcomID) eq "eocean_i">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CT</font></div></td>
				</cfif>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>

			<cfset subrcqty = 0>
			<cfset subprqty = 0>
			<cfset subissqty = 0>
			<cfset subinvqty = 0>
			<cfset subcsqty = 0>
			<cfset subcnqty = 0>
			<cfset subdnqty = 0>
			<cfset subadjqty = 0>
			<cfset subtrqty = 0>
			<cfset subctqty = 0>
			<cfset totalrc = 0>
			<cfset totalpr= 0>
			<cfset totaliss= 0>
			<cfset totalinv= 0>
			<cfset totalcs= 0>
			<cfset totalcn = 0>
			<cfset totaldn= 0>
			<cfset totaladj= 0>
			<cfset totaltr= 0>
			<cfset totalct= 0>
			
			<cfquery name="getitem" datasource="#dts#">
				select a.itemno,a.desp,ifnull(a.wos_group,'') as wos_group,a.unit,b.suminvqty,c.sumcnqty,d.sumdnqty,e.sumcsqty,f.sumrcqty,g.sumprqty,h.sumissqty,m.sumctouqty,
				(ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) as sumadjqty,
				(ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) as sumtrqty
				from icitem as a
				left join
				(select itemno,sum(qty)as suminvqty from ictran where type = 'INV' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as b on a.itemno=b.itemno

				left join
				(select itemno,sum(qty)as sumcnqty from ictran where type = 'CN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno )as c on a.itemno=c.itemno

				left join
				(select itemno,sum(qty)as sumdnqty from ictran where type = 'DN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno )as d on a.itemno=d.itemno

				left join
				(select itemno,sum(qty)as sumcsqty from ictran where type = 'CS' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as e on a.itemno=e.itemno
						
				left join
				(select itemno,sum(qty)as sumrcqty from ictran where type = 'RC' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as f on a.itemno=f.itemno
						
				left join
				(select itemno,sum(qty)as sumprqty from ictran where type = 'PR' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as g on a.itemno=g.itemno
						
				left join
				(select itemno,sum(qty)as sumissqty from ictran where type = 'ISS' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as h on a.itemno=h.itemno
						
				left join
				(select itemno,sum(qty)as sumoaiqty from ictran where type = 'OAI' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as i on a.itemno=i.itemno
						
				left join
				(select itemno,sum(qty)as sumoarqty from ictran where type = 'OAR' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as j on a.itemno=j.itemno
						
				left join
				(select itemno,sum(qty)as sumtrinqty from ictran where type = 'TRIN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as k on a.itemno=k.itemno
						
				left join
				(select itemno,sum(qty)as sumtrouqty from ictran where type = 'TROU' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as l on a.itemno=l.itemno
				
				left join
				(select itemno,sum(qty)as sumctouqty from ictran where type = 'CT' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as m on a.itemno=m.itemno

				where a.itemno=a.itemno 
				<cfif isdefined("form.include0") and form.include0 eq "yes">
							
				<cfelse>
					and (ifnull(b.suminvqty,0) != 0 or ifnull(c.sumcnqty,0) != 0 or ifnull(d.sumdnqty,0) != 0 or ifnull(e.sumcsqty,0) != 0
						or ifnull(f.sumrcqty,0) != 0 or ifnull(g.sumprqty,0) != 0 or ifnull(h.sumissqty,0) != 0
						or (ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) != 0 or (ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) != 0
						)
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
				</cfif>
				group by a.itemno order by a.wos_group,a.itemno
			</cfquery>
			
			<cfset thisgroup = "XXXXXXXXXXXXXXXX">
			<cfloop query="getitem">
				<cfif thisgroup neq getitem.wos_group>
					<cfif thisgroup neq "XXXXXXXXXXXXXXXX">
						<tr>
							<td colspan="13"><hr></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUB - TOTAL:</font></div></td>
							<td></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subprqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subissqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subinvqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcsqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcnqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subdnqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subadjqty,"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtrqty,"0")#</font></div></td>
							<cfif lcase(HcomID) eq "eocean_i">
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subctqty,"0")#</font></div></td>
							</cfif>
						</tr>
					</cfif>
				
					<cfset subrcqty = 0>
					<cfset subprqty = 0>
					<cfset subissqty = 0>
					<cfset subinvqty = 0>
					<cfset subcsqty = 0>
					<cfset subcnqty = 0>
					<cfset subdnqty = 0>
					<cfset subadjqty = 0>
					<cfset subtrqty = 0>
					<cfset subctqty = 0>
					<cfset thisgroup = getitem.wos_group>
					
					<cfquery name="getgroup" datasource="#dts#">
						select wos_group,desp as groupdesp
						from icgroup 
						where wos_group = '#getitem.wos_group#'
					</cfquery>
					<cfif getgroup.recordcount eq 0>
						<cfset getgroup.wos_group = "No - Grouped">
						<cfset getgroup.groupdesp = "No - Grouped">
					</cfif>
					
					<tr>
						<td colspan="2"><font size="2" face="Times New Roman, Times, serif"><u><strong>Group: #getitem.wos_group#</strong></u></font></td>
						<td><font size="2" face="Times New Roman, Times, serif"><u><strong>#getgroup.groupdesp#</strong></u></font></td>	
					</tr>
				</cfif>
				<cfset totalrc = totalrc + val(getitem.sumrcqty)>
				<cfset totalpr= totalpr + val(getitem.sumprqty)>
				<cfset totaliss= totaliss + val(getitem.sumissqty)>
				<cfset totalinv= totalinv + val(getitem.suminvqty)>
				<cfset totalcs= totalcs + val(getitem.sumcsqty)>
				<cfset totalcn = totalcn + val(getitem.sumcnqty)>
				<cfset totaldn= totaldn + val(getitem.sumdnqty)>
				<cfset totaladj= totaladj + val(getitem.sumadjqty)>
				<cfset totaltr= totaltr + val(getitem.sumtrqty)>
				<cfset totalct= totalct + val(getitem.sumctouqty)>
				<cfset subrcqty = subrcqty + val(getitem.sumrcqty)>
				<cfset subprqty = subprqty + val(getitem.sumprqty)>
				<cfset subissqty = subissqty + val(getitem.sumissqty)>
				<cfset subinvqty = subinvqty + val(getitem.suminvqty)>
				<cfset subcsqty = subcsqty + val(getitem.sumcsqty)>
				<cfset subcnqty = subcnqty + val(getitem.sumcnqty)>
				<cfset subdnqty = subdnqty + val(getitem.sumdnqty)>
				<cfset subadjqty = subadjqty + val(getitem.sumadjqty)>
				<cfset subtrqty = subtrqty + val(getitem.sumtrqty)>
				<cfset subctqty = subctqty + val(getitem.sumctouqty)>

				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumrcqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumprqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumissqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.suminvqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumcsqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumcnqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumdnqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumadjqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumtrqty),"0")#</font></div></td>
					<cfif lcase(HcomID) eq "eocean_i">
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumctouqty),"0")#</font></div></td>
					</cfif>
				</tr>
									
			</cfloop>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUB - TOTAL:</font></div></td>
				<td></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subprqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subissqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subinvqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcsqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcnqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subdnqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subadjqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtrqty,"0")#</font></div></td>
				<cfif lcase(HcomID) eq "eocean_i">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subctqty,"0")#</font></div></td>
				</cfif>
			</tr>	
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrc,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpr,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaliss,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaladj,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaltr,"0")#</strong></font></div></td>
				<cfif lcase(HcomID) eq "eocean_i">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalct,"0")#</strong></font></div></td>
				</cfif>
			</tr>			
		</table>
		</cfoutput>

		<cfif getitem.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
	</cfcase>
	
	<cfcase value="EXCELDEFAULT">
		<cfxml variable="data">
		<?mso-application progid="Excel.Sheet"?>
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
		<Styles>
  			<Style ss:ID="Default" ss:Name="Normal">
   				<Alignment ss:Vertical="Bottom"/>
		   		<Borders/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
		   		<Interior/>
		   		<NumberFormat/>
		   		<Protection/>
		  	</Style>
		  	<Style ss:ID="s24">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s28">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<Borders>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Borders>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s33">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s35">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s39">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<Worksheet ss:Name="Transaction Summary By Qty">
		<cfset totalcol="12">
		<cfif lcase(HcomID) eq "eocean_i">
			<cfset totalcol=totalcol+1>
		</cfif>
 		<cfoutput><Table ss:ExpandedColumnCount="#totalcol#" x:FullColumns="1" x:FullRows="1"></cfoutput>
   		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="8"/>
		<cfif lcase(HcomID) eq "eocean_i">
			<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
		</cfif>
		<cfoutput>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s34"><Data ss:Type="String">Transaction Summary By Quantity Report</Data></Cell>
   		</Row>
   		
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s35"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s35"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

   		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="#totalcol-2#" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s39"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">UOM</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">RC</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">PR</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">ISS</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">ADJ</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">TR</Data></Cell>
			<cfif lcase(HcomID) eq "eocean_i">
    			<Cell ss:StyleID="s24"><Data ss:Type="String">CT</Data></Cell>
			</cfif>
   		</Row>

		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,a.desp,a.wos_group,a.unit,b.suminvqty,c.sumcnqty,d.sumdnqty,e.sumcsqty,f.sumrcqty,g.sumprqty,h.sumissqty,m.sumctouqty,
			(ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) as sumadjqty,
			(ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) as sumtrqty
			from icitem as a
			left join
			(select itemno,sum(qty)as suminvqty from ictran where type = 'INV' and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
				group by itemno) as b on a.itemno=b.itemno

			left join
			(select itemno,sum(qty)as sumcnqty from ictran where type = 'CN' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno )as c on a.itemno=c.itemno

			left join
			(select itemno,sum(qty)as sumdnqty from ictran where type = 'DN' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno )as d on a.itemno=d.itemno

			left join
			(select itemno,sum(qty)as sumcsqty from ictran where type = 'CS' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as e on a.itemno=e.itemno
						
			left join
			(select itemno,sum(qty)as sumrcqty from ictran where type = 'RC' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as f on a.itemno=f.itemno
						
			left join
			(select itemno,sum(qty)as sumprqty from ictran where type = 'PR' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as g on a.itemno=g.itemno
						
			left join
			(select itemno,sum(qty)as sumissqty from ictran where type = 'ISS' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as h on a.itemno=h.itemno
						
			left join
			(select itemno,sum(qty)as sumoaiqty from ictran where type = 'OAI' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as i on a.itemno=i.itemno
						
			left join
			(select itemno,sum(qty)as sumoarqty from ictran where type = 'OAR' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as j on a.itemno=j.itemno
						
			left join
			(select itemno,sum(qty)as sumtrinqty from ictran where type = 'TRIN' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as k on a.itemno=k.itemno
						
			left join
			(select itemno,sum(qty)as sumtrouqty from ictran where type = 'TROU' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as l on a.itemno=l.itemno
			
			left join
			(select itemno,sum(qty)as sumctouqty from ictran where type = 'CT' 
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= #date1# and wos_date <= #date2#
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno) as m on a.itemno=m.itemno

			where 
			<cfif isdefined("form.include0") and form.include0 eq "yes">
				true	
			<cfelse>
				 (ifnull(b.suminvqty,0) != 0 or ifnull(c.sumcnqty,0) != 0 or ifnull(d.sumdnqty,0) != 0 or ifnull(e.sumcsqty,0) != 0
					or ifnull(f.sumrcqty,0) != 0 or ifnull(g.sumprqty,0) != 0 or ifnull(h.sumissqty,0) != 0
					or (ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) != 0 or (ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) != 0
					)
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
			</cfif>
			group by a.itemno order by a.itemno
		</cfquery>

		<cfset totalrc = 0>
		<cfset totalpr= 0>
		<cfset totaliss= 0>
		<cfset totalinv= 0>
		<cfset totalcs= 0>
		<cfset totalcn = 0>
		<cfset totaldn= 0>
		<cfset totaladj= 0>
		<cfset totaltr= 0>
		<cfset totalct= 0>

		<cfloop query="getitem">
			<cfset totalrc = totalrc + val(getitem.sumrcqty)>
			<cfset totalpr= totalpr + val(getitem.sumprqty)>
			<cfset totaliss= totaliss + val(getitem.sumissqty)>
			<cfset totalinv= totalinv + val(getitem.suminvqty)>
			<cfset totalcs= totalcs + val(getitem.sumcsqty)>
			<cfset totalcn = totalcn + val(getitem.sumcnqty)>
			<cfset totaldn= totaldn + val(getitem.sumdnqty)>
			<cfset totaladj= totaladj + val(getitem.sumadjqty)>
			<cfset totaltr= totaltr + val(getitem.sumtrqty)>
			<cfset totalct= totalct + val(getitem.sumctouqty)>
			<Row ss:Height="12">
				<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
				<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText1">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#getitem.unit#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumrcqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumprqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumissqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.suminvqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumcsqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumcnqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumdnqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumadjqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumtrqty#</Data></Cell>
				<cfif lcase(HcomID) eq "eocean_i">
	    			<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumctouqty#</Data></Cell>
				</cfif>
			</Row>
		</cfloop>
   		<Row ss:Height="12">
    		<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
    		<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalrc#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalpr#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totaliss#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalinv#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalcs#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalcn#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totaldn#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totaladj#</Data></Cell>
			<Cell ss:StyleID="s30"><Data ss:Type="Number">#totaltr#</Data></Cell>
			<cfif lcase(HcomID) eq "eocean_i">
	    		<Cell ss:StyleID="s30"><Data ss:Type="Number">#totalct#</Data></Cell>
			</cfif>
   		</Row>
   		</cfoutput>
   		<Row ss:Height="12"/>
  		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Transaction_Summary_By_Quantity_Report_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Transaction_Summary_By_Quantity_Report_#huserid#.xls">
	</cfcase>

	<cfcase value="EXCELBYGROUP">
		<cfxml variable="data">
		<?mso-application progid="Excel.Sheet"?>
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
		<Styles>
  			<Style ss:ID="Default" ss:Name="Normal">
		  		<Alignment ss:Vertical="Bottom"/>
		   		<Borders/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
		   		<Interior/>
		   		<NumberFormat/>
		   		<Protection/>
		  	</Style>
		  	<Style ss:ID="s24">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		  	 	<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s26">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s27">
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s28">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s33">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s38">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s41">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s43">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<Worksheet ss:Name="Transaction Summary By Qty">
		<cfset totalcol="12">
		<cfif lcase(HcomID) eq "eocean_i">
			<cfset totalcol=totalcol+1>
		</cfif>
  		<cfoutput><Table ss:ExpandedColumnCount="#totalcol#" x:FullColumns="1" x:FullRows="1"></cfoutput>
   		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="8"/>
		<cfif lcase(HcomID) eq "eocean_i">
   			<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
		</cfif>
		
		<cfoutput>
   		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s37"><Data ss:Type="String">Transaction Summary By Quantity Report (GROUPED)</Data></Cell>
   		</Row>
		
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s38"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s38"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
				<Cell ss:MergeAcross="#totalcol-1#" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="#totalcol-2#" ss:StyleID="s41"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s43"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">UOM</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">RC</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">PR</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">ISS</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">ADJ</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">TR</Data></Cell>
			<cfif lcase(HcomID) eq "eocean_i">
    			<Cell ss:StyleID="s24"><Data ss:Type="String">CT</Data></Cell>
			</cfif>
   		</Row>

		<cfquery name="getgroup" datasource="#dts#">
			select if(a.wos_group is null,'',a.wos_group) as wos_group,(select desp from icgroup where wos_group=a.wos_group) as groupdesp,b.sumqty,b.sumamt
			from icitem as a
			left join
			(select wos_group,sum(qty) as sumqty,sum(amt) as sumamt from ictran
			where (type = 'RC' or type = 'PR' or type = 'ISS' or type = 'INV' or type = 'CS' or type = 'CN' or type = 'DN' or type = 'OAI' or type = 'OAR' or type = 'TRIN' or type = 'TROU' or type = 'CT') and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by wos_group) as b on a.wos_group=b.wos_group

			where <cfif isdefined("form.include0")>(b.sumqty >=0 or b.sumamt >=0)<cfelse>(b.sumqty >0 or b.sumamt >0)</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group >='#form.groupfrom#' and a.wos_group <='#form.groupto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
			</cfif>
			group by a.wos_group order by a.wos_group
		</cfquery>

		<cfset totalrc = 0>
		<cfset totalpr= 0>
		<cfset totaliss= 0>
		<cfset totalinv= 0>
		<cfset totalcs= 0>
		<cfset totalcn = 0>
		<cfset totaldn= 0>
		<cfset totaladj= 0>
		<cfset totaltr= 0>
		<cfset totalct= 0>

		<cfloop query="getgroup">
			<cfset subrcqty = 0>
			<cfset subprqty = 0>
			<cfset subissqty = 0>
			<cfset subinvqty = 0>
			<cfset subcsqty = 0>
			<cfset subcnqty = 0>
			<cfset subdnqty = 0>
			<cfset subadjqty = 0>
			<cfset subtrqty = 0>
			<cfset subctqty = 0>

			<Row ss:AutoFitHeight="0" ss:Height="15">
				<cfif getgroup.wos_group eq "">
					<Cell ss:MergeAcross="7" ss:StyleID="s36"><Data ss:Type="String">Group: No - Grouped</Data></Cell>
				<cfelse>
					<cfwddx action = "cfml2wddx" input = "Group: #getgroup.wos_group# - #getgroup.groupdesp#" output = "wddxText">
					<Cell ss:MergeAcross="7" ss:StyleID="s36"><Data ss:Type="String">#wddxText#</Data></Cell>
				</cfif>
   			</Row>

			<cfquery name="getitem" datasource="#dts#">
				select a.itemno,a.desp,a.wos_group,a.unit,b.suminvqty,c.sumcnqty,d.sumdnqty,e.sumcsqty,f.sumrcqty,g.sumprqty,h.sumissqty,m.sumctouqty,
				(ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) as sumadjqty,
				(ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) as sumtrqty
				from icitem as a
				left join
				(select itemno,sum(qty)as suminvqty from ictran where type = 'INV' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as b on a.itemno=b.itemno

				left join
				(select itemno,sum(qty)as sumcnqty from ictran where type = 'CN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno )as c on a.itemno=c.itemno

				left join
				(select itemno,sum(qty)as sumdnqty from ictran where type = 'DN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno )as d on a.itemno=d.itemno

				left join
				(select itemno,sum(qty)as sumcsqty from ictran where type = 'CS' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as e on a.itemno=e.itemno
						
				left join
				(select itemno,sum(qty)as sumrcqty from ictran where type = 'RC' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as f on a.itemno=f.itemno
						
				left join
				(select itemno,sum(qty)as sumprqty from ictran where type = 'PR' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as g on a.itemno=g.itemno
						
				left join
				(select itemno,sum(qty)as sumissqty from ictran where type = 'ISS' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as h on a.itemno=h.itemno
						
				left join
				(select itemno,sum(qty)as sumoaiqty from ictran where type = 'OAI' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as i on a.itemno=i.itemno
						
				left join
				(select itemno,sum(qty)as sumoarqty from ictran where type = 'OAR' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as j on a.itemno=j.itemno
						
				left join
				(select itemno,sum(qty)as sumtrinqty from ictran where type = 'TRIN' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as k on a.itemno=k.itemno
						
				left join
				(select itemno,sum(qty)as sumtrouqty from ictran where type = 'TROU' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as l on a.itemno=l.itemno
				
				left join
				(select itemno,sum(qty)as sumctouqty from ictran where type = 'CT' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= #date1# and wos_date <= #date2#
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by itemno) as m on a.itemno=m.itemno

				where <cfif getgroup.wos_group eq "">(a.wos_group = '#getgroup.wos_group#' or a.wos_group is null)<cfelse>a.wos_group = '#getgroup.wos_group#'</cfif>
				<cfif isdefined("form.include0") and form.include0 eq "yes">
							
				<cfelse>
					and (ifnull(b.suminvqty,0) != 0 or ifnull(c.sumcnqty,0) != 0 or ifnull(d.sumdnqty,0) != 0 or ifnull(e.sumcsqty,0) != 0
					or ifnull(f.sumrcqty,0) != 0 or ifnull(g.sumprqty,0) != 0 or ifnull(h.sumissqty,0) != 0
					or (ifnull(i.sumoaiqty,0)-ifnull(j.sumoarqty,0)) != 0 or (ifnull(k.sumtrinqty,0)-ifnull(l.sumtrouqty,0)) != 0
					)
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
				</cfif>
					group by a.itemno order by a.itemno
			</cfquery>

			<cfloop query="getitem">
				<cfset totalrc = totalrc + val(getitem.sumrcqty)>
				<cfset totalpr= totalpr + val(getitem.sumprqty)>
				<cfset totaliss= totaliss + val(getitem.sumissqty)>
				<cfset totalinv= totalinv + val(getitem.suminvqty)>
				<cfset totalcs= totalcs + val(getitem.sumcsqty)>
				<cfset totalcn = totalcn + val(getitem.sumcnqty)>
				<cfset totaldn= totaldn + val(getitem.sumdnqty)>
				<cfset totaladj= totaladj + val(getitem.sumadjqty)>
				<cfset totaltr= totaltr + val(getitem.sumtrqty)>
				<cfset totalct = totalct + val(getitem.sumctouqty)>
				<cfset subrcqty = subrcqty + val(getitem.sumrcqty)>
				<cfset subprqty = subprqty + val(getitem.sumprqty)>
				<cfset subissqty = subissqty + val(getitem.sumissqty)>
				<cfset subinvqty = subinvqty + val(getitem.suminvqty)>
				<cfset subcsqty = subcsqty + val(getitem.sumcsqty)>
				<cfset subcnqty = subcnqty + val(getitem.sumcnqty)>
				<cfset subdnqty = subdnqty + val(getitem.sumdnqty)>
				<cfset subadjqty = subadjqty + val(getitem.sumadjqty)>
				<cfset subtrqty = subtrqty + val(getitem.sumtrqty)>
				<cfset subctqty = subctqty + val(getitem.sumctouqty)>
				<Row>
					<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText1">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="String">#getitem.unit#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumrcqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumprqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumissqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.suminvqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumcsqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumcnqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumdnqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumadjqty#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumtrqty#</Data></Cell>
					<cfif lcase(HcomID) eq "eocean_i">
						<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumctouqty#</Data></Cell>
					</cfif>
				</Row>
			</cfloop>
			<Row ss:Height="12">
    			<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s30"><Data ss:Type="String">Sub Total</Data></Cell>
    			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subrcqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subprqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subissqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subinvqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subcsqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subcnqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subdnqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subadjqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subtrqty#</Data></Cell>
				<cfif lcase(HcomID) eq "eocean_i">
					<Cell ss:StyleID="s31"><Data ss:Type="Number">#subctqty#</Data></Cell>
				</cfif>
   			</Row>
			<Row ss:Height="12"/>
		</cfloop>
		<Row ss:Height="12">
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s30"/>
    		<Cell ss:StyleID="s30"><Data ss:Type="String">Total</Data></Cell>
    		<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalrc#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalpr#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totaliss#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalinv#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalcs#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalcn#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totaldn#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totaladj#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#totaltr#</Data></Cell>
			<cfif lcase(HcomID) eq "eocean_i">
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#totalct#</Data></Cell>
			</cfif>
   		</Row>
		<Row ss:Height="12"/>
		</cfoutput>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Transaction_Summary_By_Quantity_Report(Grouped)_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Transaction_Summary_By_Quantity_Report(Grouped)_#huserid#.xls">
	</cfcase>
</cfswitch>