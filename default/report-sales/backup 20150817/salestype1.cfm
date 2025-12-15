<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>

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

<cfif form.userfrom neq "" and form.userto neq "">
<cfquery name="getenduserlist" datasource="#dts#">
select refno from artran where 0=0
and van >='#form.userfrom#' and van <= '#form.userto#'
</cfquery>
<cfset userlist=valuelist(getenduserlist.refno)>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Product Sales By Type Report</title>
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

		<cfquery name="getgroup" datasource="#dts#">
			select distinct ifnull(a.wos_group,'') as wos_group,(select desp from icgroup where wos_group=a.wos_group) as groupdesp,b.sumqty,b.sumamt
			from icitem as a
			left join
			(select wos_group,sum(qty) as sumqty,sum(amt) as sumamt from ictran
			where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
		<cfelse>
        <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
		<cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
        </cfif>
		</cfif>
			group by wos_group) as b on a.wos_group=b.wos_group

			where <cfif isdefined("form.include0")>(b.sumqty >=0 or b.sumamt >=0)<cfelse>(b.sumqty >0 or b.sumamt >0)</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group >='#form.groupfrom#' and a.wos_group <='#form.groupto#'
			</cfif>
			
            
			group by a.wos_group order by a.wos_group
		</cfquery>

		<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="10"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY TYPE REPORT</strong></font></div></td>
			</tr>
            <cfif form.custfrom neq "" and form.custto neq "">
            <cfquery name="custnamefr" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custfrom#'
</cfquery>
            <cfquery name="custnameto" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custto#'
            </cfquery>
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "hyray_i"><cfif form.custfrom eq form.custto>Customer : #custnamefr.name#<cfelse>Customer : #custnamefr.name# - #custnameto.name#</cfif><cfelse>CUSTOMER NO: #form.custfrom# - #form.custto#</cfif></font></div></td>
				</tr>
			</cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif"><cfif periodfrom eq periodto>#form.monthfrom#<cfelse>PERIOD: #form.periodfrom# - #form.periodto#</cfif></font></div></td>
				</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				<tr>
					<td colspan="10"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
				</tr>
			</cfif>

			<cfswitch expression="#form.qtysold#">
				<cfcase value="yes">
					<tr>
						<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="-1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
					</tr>
					<tr>
						<td colspan="6"><hr></td>
					</tr>
					<tr>
						<td><font size="2" face="Times New Roman, Times, serif">NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">ITEM DESCRIPTION</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">U/M</font></td>
						<td></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
					</tr>
					<tr>
						<td colspan="6"><hr></td>
					</tr>

					<cfset totalqty= 0>

					<cfloop query="getgroup">
						<cfset subqty = 0>
						<tr>
							<cfif getgroup.wos_group eq "">
								<td colspan="2"><font size="2" face="Times New Roman, Times, serif"><u><strong>Group: No - Grouped</strong></u></font></td>
								<td><font size="2" face="Times New Roman, Times, serif"><u><strong>No - Grouped</strong></u></font></td>
							<cfelse>
								<td colspan="2"><font size="2" face="Times New Roman, Times, serif"><u><strong>Group: #getgroup.wos_group#</strong></u></font></td>
								<td><font size="2" face="Times New Roman, Times, serif"><u><strong>#getgroup.groupdesp#</strong></u></font></td>
							</cfif>
						</tr>

						<cfquery name="getitem" datasource="#dts#">
							select a.itemno,a.desp,a.wos_group,a.unit,b.sumqty
							from icitem as a
							left join
							(select itemno,sum(qty)as sumqty from ictran where (type='INV' or type='CS' or type='DN') and (void = '' or void is null)
							<cfif form.periodfrom neq "" and form.periodto neq "">
								and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
								and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
								and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
								and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
							</cfif>
                            <cfif url.alown eq 1>
							<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
							<cfelse>
            				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
							</cfif>
							<cfelse>
                            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
							<cfelse>
							<cfif Huserloc neq "All_loc">
							and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
							</cfif>
                            </cfif>
							</cfif>
							group by itemno) as b on a.itemno=b.itemno

							where <cfif getgroup.wos_group eq "">(a.wos_group = '#getgroup.wos_group#' or a.wos_group is null)<cfelse>a.wos_group = '#getgroup.wos_group#'</cfif>
							<cfif isdefined("form.include0")>
							and b.sumqty >=0
							<cfelse>
							and b.sumqty >0
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
							<cfset totalqty= totalqty + val(getitem.sumqty)>
							<cfset subqty = subqty + val(getitem.sumqty)>
							<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></td>
								<td></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumqty),"0")#</font></div></td>
							</tr>
						</cfloop>
						<tr>
							<td colspan="6"><hr></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUB - TOTAL:</font></div></td>
							<td></td>
							<td></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(subqty)#</font></div></td>
						</tr>
					</cfloop>
					<tr>
						<td colspan="6"><hr></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
						<td></td>
						<td></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#val(totalqty)#</strong></font></div></td>
					</tr>
				</cfcase>

				<cfdefaultcase>
					<tr>
						<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
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
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
                        <cfif isdefined('form.focqty')>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOC</font></div></td>
                        </cfif>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
					</tr>
					<tr>
						<td colspan="100%"><hr></td>
					</tr>

					<cfset totalinv = 0>
                    <cfset totalfoc = 0>
					<cfset totaldn= 0>
					<cfset totalcs= 0>
					<cfset totalcn= 0>
					<cfset totals= 0>
					<cfset totalqty= 0>

					<cfloop query="getgroup">
						<cfset subinvamt = 0>
                        <cfset subfoc = 0>
						<cfset subcsamt = 0>
						<cfset subdnamt = 0>
						<cfset subcnamt = 0>
						<cfset subtotal = 0>
						<cfset subqty = 0>

						<tr>
							<cfif getgroup.wos_group eq "">
								<td colspan="2"><font size="2" face="Times New Roman, Times, serif"><u><strong>Group: No - Grouped</strong></u></font></td>
								<td><font size="2" face="Times New Roman, Times, serif"><u><strong>No - Grouped</strong></u></font></td>
							<cfelse>
								<td colspan="2"><font size="2" face="Times New Roman, Times, serif"><u><strong>Group: #getgroup.wos_group#</strong></u></font></td>
								<td><font size="2" face="Times New Roman, Times, serif"><u><strong>#getgroup.groupdesp#</strong></u></font></td>
							</cfif>
						</tr>

						<cfquery name="getitem" datasource="#dts#">
							select a.itemno,a.desp,a.wos_group,a.unit,(ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) as sumqty,
							b.suminvamt,c.sumcnamt,d.sumdnamt,e.sumcsamt,(ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)) as total
							from icitem as a
							left join
							(select itemno,sum(amt)as suminvamt,sum(qty)as suminvqty from ictran where type = 'INV' and (void = '' or void is null)
							<cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
							</cfif>
                            <cfif url.alown eq 1>
							<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
							<cfelse>
            				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
							</cfif>
							<cfelse>
                            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
							<cfelse>
							<cfif Huserloc neq "All_loc">
							and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
							</cfif>
                            </cfif>
							</cfif>
							group by itemno) as b on a.itemno=b.itemno

							left join
							(select itemno,sum(amt)as sumcnamt from ictran where type = 'CN' and (void = '' or void is null)
							<cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
							</cfif>
                            <cfif url.alown eq 1>
							<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
							<cfelse>
            				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
							</cfif>
							<cfelse>
                            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
							<cfelse>
							<cfif Huserloc neq "All_loc">
							and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
							</cfif>
                            </cfif>
							</cfif>
							group by itemno )as c on a.itemno=c.itemno

							left join
							(select itemno,sum(amt)as sumdnamt,sum(qty)as sumdnqty from ictran where type = 'DN' and (void = '' or void is null)
							<cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                            <cfif url.alown eq 1>
							<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
							<cfelse>
            				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
							</cfif>
							<cfelse>
                            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
							<cfelse>
							<cfif Huserloc neq "All_loc">
							and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
							</cfif>
                            </cfif>
							</cfif>
                            
							group by itemno )as d on a.itemno=d.itemno

							left join
							(select itemno,sum(amt)as sumcsamt,sum(qty)as sumcsqty from ictran where type = 'CS' and (void = '' or void is null)
							<cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                            <cfif url.alown eq 1>
							<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
							<cfelse>
            				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
							</cfif>
							<cfelse>
                            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
							<cfelse>
							<cfif Huserloc neq "All_loc">
							and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
							</cfif>
                            </cfif>
							</cfif>
                            
							group by itemno) as e on a.itemno=e.itemno

							where <cfif getgroup.wos_group eq "">(a.wos_group = '#getgroup.wos_group#' or a.wos_group is null)<cfelse>a.wos_group = '#getgroup.wos_group#'</cfif>
							<cfif isdefined("form.include0") and form.include0 eq "yes">
							and ((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >=0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)) >=0)
							<cfelse>
							and ((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)) >0)
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
                        
                        <cfif isdefined('form.focqty')>
                                <cfquery name="getfoc" datasource="#dts#">
                                select sum(qty) as focqty from ictran where itemno='#getitem.itemno#' and foc='Y'
                                <cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                                </cfquery>
                                </cfif>
                        
                        
							<cfset totalinv = totalinv + val(getitem.suminvamt)>
							<cfset totaldn= totaldn + val(getitem.sumdnamt)>
							<cfset totalcs= totalcs + val(getitem.sumcsamt)>
							<cfset totalcn= totalcn + val(getitem.sumcnamt)>
							<cfset totals= totals + val(getitem.total)>
                            <cfif isdefined('form.focqty')>
							<cfset totalqty= totalqty + val(getitem.sumqty)-val(getfoc.focqty)>
                            <cfelse>
                            <cfset totalqty= totalqty + val(getitem.sumqty)>
                            </cfif>
							<cfset subinvamt = subinvamt + val(getitem.suminvamt)>
							<cfset subcsamt = subcsamt + val(getitem.sumcsamt)>
							<cfset subdnamt = subdnamt + val(getitem.sumdnamt)>
							<cfset subcnamt = subcnamt + val(getitem.sumcnamt)>
							<cfset subtotal = subtotal + val(getitem.total)>
                            <cfif isdefined('form.focqty')>
							<cfset subqty = subqty + val(getitem.sumqty)-val(getfoc.focqty)>
                            <cfelse>
                            <cfset subqty = subqty + val(getitem.sumqty)>
                            </cfif>

							<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
								<td><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></td>
                                
                                
                                <cfif isdefined('form.focqty')>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getitem.sumqty)-val(getfoc.focqty)#</font></div></td>
                                <cfelse>
                                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getitem.sumqty)#</font></div></td>
                                </cfif>
                                <cfif isdefined('form.focqty')>
                                <cfset totalfoc = totalfoc +val(getfoc.focqty)>
                                <cfset subfoc = subfoc +val(getfoc.focqty)>
                                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getfoc.focqty)#</font></div></td>
                                </cfif>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.suminvamt),stDecl_UPrice)#</font></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumcsamt),stDecl_UPrice)#</font></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumdnamt),stDecl_UPrice)#</font></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.total),stDecl_UPrice)#</font></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumcnamt),stDecl_UPrice)#</font></div></td>
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
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(subqty)#</font></div></td>
                            <cfif isdefined('form.focqty')>
                            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(subfoc)#</font></div></td>
                            </cfif>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subinvamt,",.__")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcsamt,",.__")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subdnamt,",.__")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal,",.__")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcnamt,",.__")#</font></div></td>
						</tr>
					</cfloop>
					
					<tr>
						<td colspan="100%"><hr></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
						<td></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#val(totalqty)#</strong></font></div></td>
                        <cfif isdefined('form.focqty')>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#val(totalfoc)#</strong></font></div></td>
                        </cfif>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,",___.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,",___.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,",___.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totals,",___.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,",___.__")#</strong></font></div></td>
					</tr>
				</cfdefaultcase>
			</cfswitch>
		</table>
		</cfoutput>

		<cfif getgroup.recordcount eq 0>
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
    
    <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath()) & "..\..\Excel_Report\"&dts&"\">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
    
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
		<Worksheet ss:Name="Product_Sales_Report_By-Type">
          <cfif lcase(hcomid) eq "hyray_i">
        <Table ss:ExpandedColumnCount="9" x:FullColumns="1" x:FullRows="1">
        <cfelse>
  		<Table ss:ExpandedColumnCount="9" x:FullColumns="1" x:FullRows="1">
        </cfif>
   		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="7" ss:StyleID="s34"><Data ss:Type="String">Products Sales Report - By Type</Data></Cell>
   		</Row>
   		<cfoutput>
        <cfif form.custfrom neq "" and form.custto neq "">
            <cfquery name="custnamefr" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custfrom#'
</cfquery>
            <cfquery name="custnameto" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custto#'
            </cfquery>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String"><cfif form.custfrom eq form.custto>Customer : #form.custfrom#<cfelse>Customer : #form.custfrom# - #form.custto#</cfif></Data></Cell>
			</Row>
			</cfif>

			

        
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String"><cfif periodfrom eq periodto>#form.monthfrom#<cfelse>PERIOD: #form.periodfrom# - #form.periodto#</cfif></Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.catefrom neq "" and form.cateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.itemfrom neq "" and form.itemto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

   		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="6" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s39"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Qty Sold</Data></Cell>
            <Cell ss:StyleID="s24"><Data ss:Type="String">FOC</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">NET</Data></Cell>
   		</Row>

		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,a.desp,a.wos_group,a.unit,(ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) as sumqty,
			b.suminvamt,c.sumcnamt,d.sumdnamt,e.sumcsamt,(ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) as net
			from icitem as a
			left join
			(select itemno,sum(amt)as suminvamt,sum(qty)as suminvqty from ictran where type = 'INV' and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
                            
			group by itemno) as b on a.itemno=b.itemno

			left join
			(select itemno,sum(amt)as sumcnamt from ictran where type = 'CN' and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
            <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
			group by itemno )as c on a.itemno=c.itemno

			left join
			(select itemno,sum(amt)as sumdnamt,sum(qty)as sumdnqty from ictran where type = 'DN' and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
            <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
			group by itemno )as d on a.itemno=d.itemno

			left join
			(select itemno,sum(amt)as sumcsamt,sum(qty)as sumcsqty from ictran where type = 'CS' and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
            <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
			group by itemno) as e on a.itemno=e.itemno

			where
			<cfif isdefined("form.include0") and form.include0 eq "yes">
			((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >=0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) >=0)
			<cfelse>
			((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) >0)
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
			</cfif>
			group by a.itemno order by a.itemno
		</cfquery>

		<cfset totalinv = 0>
        <cfset totalfoc = 0>
		<cfset totaldn= 0>
		<cfset totalcs= 0>
		<cfset totalcn= 0>
		<cfset totalnet= 0>
		<cfset totalqty= 0>

		<cfloop query="getitem">
			<cfset totalinv = totalinv + val(getitem.suminvamt)>
			<cfset totaldn= totaldn + val(getitem.sumdnamt)>
			<cfset totalcs= totalcs + val(getitem.sumcsamt)>
			<cfset totalcn= totalcn + val(getitem.sumcnamt)>
			<cfset totalnet= totalnet + val(getitem.net)>
			<cfset totalqty= totalqty + val(getitem.sumqty)>
			<Row ss:Height="12">
				<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
				<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText1">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#getitem.sumqty#</Data></Cell>
                   <cfif isdefined('form.focqty')>
                                <cfquery name="getfoc" datasource="#dts#">
                                select sum(qty) as focqty from ictran where itemno='#getitem.itemno#' and foc='Y'
                                <cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                                </cfquery>
                                <cfset totalfoc = totalfoc +val(getfoc.focqty)>
                               <Cell ss:StyleID="s31"><Data ss:Type="Number">#getfoc.focqty#</Data></Cell>
                                </cfif>
				<cfif form.qtysold eq "no">
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.suminvamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.sumdnamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.sumcsamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.sumcnamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#getitem.net#</Data></Cell>
				</cfif>
			</Row>
		</cfloop>
   		<Row ss:Height="12">
    		<Cell ss:StyleID="s29"/>
    		<Cell ss:Index="3" ss:StyleID="s30"><Data ss:Type="Number">#totalqty#</Data></Cell>
             <cfif isdefined('form.focqty')>
            <Cell ss:StyleID="s30"><Data ss:Type="Number">#totalfoc#</Data></Cell>
            </cfif>
			<cfif form.qtysold eq "no">
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalinv#</Data></Cell>
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totaldn#</Data></Cell>
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalcs#</Data></Cell>
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalcn#</Data></Cell>
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalnet#</Data></Cell>
			</cfif>
   		</Row>
   		</cfoutput>
   		<Row ss:Height="12"/>
  		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Product_Sales_Report_By-Type_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Product_Sales_Report_By-Type_#huserid#.xls">
	</cfcase>

	<cfcase value="EXCELBYGROUP">
    <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath()) & "..\..\Excel_Report\"&dts&"\">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
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
            <Style ss:ID="s35">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
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
		<Worksheet ss:Name="Product_Sales_Report_By-Type">
        <cfif isdefined('form.focqty')>
        <Table ss:ExpandedColumnCount="9" x:FullColumns="1" x:FullRows="1">
        <cfelse>
  		<Table ss:ExpandedColumnCount="9" x:FullColumns="1" x:FullRows="1">
        </cfif>
   		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>
   		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="7" ss:StyleID="s37"><Data ss:Type="String">Products Sales Report - By Type (GROUPED)</Data></Cell>
   		</Row>
		<cfoutput>
        <cfif form.custfrom neq "" and form.custto neq "">
            <cfquery name="custnamefr" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custfrom#'
</cfquery>
            <cfquery name="custnameto" datasource="#dts#">
            select name from #target_arcust# where custno='#form.custto#'
            </cfquery>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String"><cfif form.custfrom eq form.custto>Customer : #custnamefr.name#<cfelse>Customer : #custnamefr.name# - #custnameto.name#</cfif></Data></Cell>
			</Row>
			</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s38"><Data ss:Type="String"><cfif periodfrom eq periodto>#form.monthfrom#<cfelse>PERIOD: #form.periodfrom# - #form.periodto#</cfif></Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="7" ss:StyleID="s38"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.catefrom neq "" and form.cateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
				<Cell ss:MergeAcross="7" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.itemfrom neq "" and form.itemto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
				<Cell ss:MergeAcross="7" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="6" ss:StyleID="s41"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s43"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Qty Sold</Data></Cell>
            <cfif isdefined('form.focqty')>
            <Cell ss:StyleID="s24"><Data ss:Type="String">FOC</Data></Cell>
            </cfif>
			<cfif form.qtysold eq "no">
				<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">NET</Data></Cell>
			</cfif>
   		</Row>

		<cfquery name="getgroup" datasource="#dts#">
			select a.wos_group,(select desp from icgroup where wos_group=a.wos_group) as groupdesp,b.sumqty,b.sumamt
			from icitem as a
			left join
			(select wos_group,sum(qty) as sumqty,sum(amt) as sumamt from ictran
			where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
            <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
            <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
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

		<cfset totalinv = 0>
        <cfset totalfoc = 0>
		<cfset totaldn= 0>
		<cfset totalcs= 0>
		<cfset totalcn= 0>
		<cfset totalnet= 0>
		<cfset totalqty= 0>

		<cfloop query="getgroup">
			<cfset subinvamt = 0>
            <cfset subfoc = 0>
			<cfset subcsamt = 0>
			<cfset subdnamt = 0>
			<cfset subcnamt = 0>
			<cfset subnet = 0>
			<cfset subqty = 0>

			<Row ss:AutoFitHeight="0" ss:Height="15">
				<cfif getgroup.wos_group eq "">
					<Cell ss:MergeAcross="7" ss:StyleID="s36"><Data ss:Type="String">Group: No - Grouped</Data></Cell>
				<cfelse>
					<cfwddx action = "cfml2wddx" input = "Group: #getgroup.wos_group# - #getgroup.groupdesp#" output = "wddxText">
					<Cell ss:MergeAcross="7" ss:StyleID="s36"><Data ss:Type="String">#wddxText#</Data></Cell>
				</cfif>
   			</Row>

			<cfquery name="getitem" datasource="#dts#">
				select a.itemno,a.desp,a.wos_group,a.unit,(ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) as sumqty,
				b.suminvamt,c.sumcnamt,d.sumdnamt,e.sumcsamt,(ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) as net
				from icitem as a
				left join
				(select itemno,sum(amt)as suminvamt,sum(qty)as suminvqty from ictran where type = 'INV' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
                <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
				group by itemno) as b on a.itemno=b.itemno

				left join
				(select itemno,sum(amt)as sumcnamt from ictran where type = 'CN' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
                <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
				group by itemno )as c on a.itemno=c.itemno

				left join
				(select itemno,sum(amt)as sumdnamt,sum(qty)as sumdnqty from ictran where type = 'DN' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
                <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
				group by itemno )as d on a.itemno=d.itemno

				left join
				(select itemno,sum(amt)as sumcsamt,sum(qty)as sumcsqty from ictran where type = 'CS' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
                <cfif form.custfrom neq "" and form.custto neq "">
                and custno >= '#form.custfrom#' and custno <= '#form.custto#'
            </cfif>
            <cfif form.areafrom neq "" and form.areato neq "">
                and area >= '#form.areafrom#' and area <= '#form.areato#'
            </cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
				and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
			<cfelse>
            <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
			<cfelse>
			<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
            </cfif>
			</cfif>
				group by itemno) as e on a.itemno=e.itemno

				where a.wos_group = '#getgroup.wos_group#'
				<cfif isdefined("form.include0") and form.include0 eq "yes">
				and ((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >=0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) >=0)
				<cfelse>
				and ((ifnull(b.suminvqty,0)+ifnull(d.sumdnqty,0)+ifnull(e.sumcsqty,0)) >0 or (ifnull(b.suminvamt,0)+ifnull(d.sumdnamt,0)+ifnull(e.sumcsamt,0)-ifnull(c.sumcnamt,0)) >0)
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
				<cfset totalinv = totalinv + val(getitem.suminvamt)>
				<cfset totaldn= totaldn + val(getitem.sumdnamt)>
				<cfset totalcs= totalcs + val(getitem.sumcsamt)>
				<cfset totalcn= totalcn + val(getitem.sumcnamt)>
				<cfset totalnet= totalnet + val(getitem.net)>
				<cfset totalqty= totalqty + val(getitem.sumqty)>
				<cfset subinvamt = subinvamt + val(getitem.suminvamt)>
				<cfset subcsamt = subcsamt + val(getitem.sumcsamt)>
				<cfset subdnamt = subdnamt + val(getitem.sumdnamt)>
				<cfset subcnamt = subcnamt + val(getitem.sumcnamt)>
				<cfset subnet = subnet + val(getitem.net)>
				<cfset subqty = subqty + val(getitem.sumqty)>
				<Row>
					<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText1">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#getitem.sumqty#</Data></Cell>
                      <cfif isdefined('form.focqty')>
                                <cfquery name="getfoc" datasource="#dts#">
                                select sum(qty) as focqty from ictran where itemno='#getitem.itemno#' and foc='Y'
                                <cfif form.periodfrom neq "" and form.periodto neq "">
							and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
							</cfif>
                            <cfif form.custfrom neq "" and form.custto neq "">
								and custno >= '#form.custfrom#' and custno <= '#form.custto#'
							</cfif>
                            <cfif form.areafrom neq "" and form.areato neq "">
								and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
                            <cfif form.userfrom neq "" and form.userto neq "">
							and refno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#userlist#">)
							</cfif>
							<cfif form.datefrom neq "" and form.dateto neq "">
							and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
							<cfelse>
							and wos_date > #getgeneral.lastaccyear#
							</cfif>
							<cfif form.agentfrom neq "" and form.agentto neq "">
							and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
							</cfif>
                            <cfif form.teamfrom neq "" and form.teamto neq "">
							and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
                                </cfquery>
                                <cfset totalfoc = totalfoc +val(getfoc.focqty)>
                               <Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getfoc.focqty)#</Data></Cell>
                                </cfif>
					<cfif form.qtysold eq "no">
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.suminvamt#</Data></Cell>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.sumdnamt#</Data></Cell>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.sumcsamt#</Data></Cell>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.sumcnamt#</Data></Cell>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.net#</Data></Cell>
					</cfif>
				</Row>
			</cfloop>
			<Row ss:Height="12">
    			<Cell ss:StyleID="s30"/>
    			<Cell ss:Index="3" ss:StyleID="s31"><Data ss:Type="Number">#subqty#</Data></Cell>
                <cfif isdefined('form.focqty')>
                <Cell ss:StyleID="s31"><Data ss:Type="Number">#subfoc#</Data></Cell>
                </cfif>
				<cfif form.qtysold eq "no">
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#subinvamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#subdnamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#subcsamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#subcnamt#</Data></Cell>
					<Cell ss:StyleID="s33"><Data ss:Type="Number">#subnet#</Data></Cell>
				</cfif>
   			</Row>
			<Row ss:Height="12"/>
		</cfloop>
		<Row ss:Height="12">
    		<Cell ss:StyleID="s30"><Data ss:Type="String">Grand Total</Data></Cell>
    		<Cell ss:Index="3" ss:StyleID="s31"><Data ss:Type="Number">#totalqty#</Data></Cell>
             <cfif isdefined('form.focqty')>
             <Cell ss:StyleID="s31"><Data ss:Type="Number">#totalfoc#</Data></Cell>
             </cfif>
			<cfif form.qtysold eq "no">
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalinv#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#totaldn#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalcs#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalcn#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalnet#</Data></Cell>
			</cfif>
   		</Row>
		<Row ss:Height="12"/>
		</cfoutput>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Product_Sales_Report_By-Type(Grouped)_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Product_Sales_Report_By-Type(Grouped)_#huserid#.xls">
	</cfcase>
</cfswitch>