<html>
<head>
<title>View Purchase Reports</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfparam name="ndatefrom" default="">
<cfparam name="ndateto" default="">
<cfparam name="totalrcamt" default="0">
<cfparam name="totalpramt" default="0">
<cfparam name="totalnetamt" default="0">
<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd=#dateformat(form.datefrom, "DD")#>
	<cfif dd greater than '12'>
		<cfset ndatefrom=#dateformat(form.datefrom,"YYYYMMDD")#>
	<cfelse>
		<cfset ndatefrom=#dateformat(form.datefrom,"YYYYDDMM")#>
	</cfif>

	<cfset dd=#dateformat(form.dateto, "DD")#>
	<cfif dd greater than '12'>
		<cfset ndateto=#dateformat(form.dateto,"YYYYMMDD")#>
	<cfelse>
		<cfset ndateto=#dateformat(form.dateto,"YYYYDDMM")#>
	</cfif>
</cfif>

<cfif url.type eq "Products">
	<cfif form.getfrom neq "" and form.getto neq "" and ndatefrom neq "" and ndateto neq "">
		<cfquery name="getitem" datasource="#dts#">
			select * from ictran where itemno >= '#form.getfrom#' and itemno <= '#form.getto#' and (type = 'RC' or type = 'PR')and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#' and custno<>'assm/999' group by itemno
		</cfquery>
	<cfelseif form.getfrom neq "" and form.getto neq "" and ndatefrom eq "" and ndateto eq "">
		<cfquery name="getitem" datasource="#dts#">
			select * from ictran where itemno >= '#form.getfrom#' and itemno <= '#form.getto#' and (type = 'RC' or type = 'PR') and custno<>'assm/999' group by itemno
		</cfquery>
	<cfelseif form.getfrom eq "" and form.getto eq "" and ndatefrom neq "" and ndateto neq "">
		<cfquery name="getitem" datasource="#dts#">
			select * from ictran where wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#' and (type = 'RC' or type = 'PR') and custno<>'assm/999' group by itemno
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select * from ictran where type = 'RC' or type = 'PR' and custno<>'assm/999' group by itemno
		</cfquery>
	</cfif>
</cfif>

<cfif url.type eq "Vendors">
	<cfif form.getfrom neq "" and form.getto neq "" and ndatefrom neq "" and ndateto neq "">
		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,b.* from icitem a,ictran b where a.itemno = b.itemno <!--- and a.supp <> ''  --->
			and b.custno >= '#form.getfrom#' and b.custno <= '#form.getto#' and b.wos_date >= '#ndatefrom#'
			and b.wos_date <= '#ndateto#' and (type = 'RC' or type = 'PR') and custno<>'assm/999' group by b.custno
		</cfquery>
	<cfelseif form.getfrom neq "" and form.getto neq "" and ndatefrom eq "" and ndateto eq "">
		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,b.* from icitem a, ictran b where a.itemno = b.itemno <!--- and a.supp <> ''  --->
			and b.custno >= '#form.getfrom#' and b.custno <= '#form.getto#' and (type = 'RC' or type = 'PR') and custno<>'assm/999'
			group by b.custno
		</cfquery>
	<cfelseif form.getfrom eq "" and form.getto eq "" and ndatefrom neq "" and ndateto neq "">
		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,b.* from icitem a,ictran b where a.itemno = b.itemno <!--- and a.supp <> '' --->
			and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#' and(type = 'RC' or type = 'PR') and custno<>'assm/999'
			group by b.custno
		</cfquery>
	<cfelse>
		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,b.* from icitem a,ictran b where a.itemno = b.itemno <!--- and a.supp <> '' --->
			and (b.type = 'RC' or type = 'PR') and custno<>'assm/999' group by b.custno
		</cfquery>
	</cfif>
</cfif>

<!---  <cfoutput query="getitem">
<cfset stype = "">
<cfif url.type eq "Products">
	<cfset stype = #itemno#>
<cfelseif url.type eq "Customers">
	<cfset stype = #custno#>
<cfelseif url.type eq "Agent">
	<cfset stype = #agenno#>
<cfelseif url.type eq "Group">
	<cfset stype = #wos_group#>
</cfif>
</cfoutput>   --->

<body>
<cfoutput>
<cfif form.getfrom neq "" and form.getto neq "">
	#url.type# - #form.getfrom# to #form.getto#
<cfelseif ndatefrom neq "" and ndateto neq "">
	#url.type# - #datefrom# to #dateto#
<cfelse>
	#url.type#
</cfif>
</cfoutput>

<br><br>
<table width="640" align="center" class="data">
  <tr>
    <th width="130"> <div align="center"><cfoutput>
          <cfif url.type eq "Products">
            Item No
            <cfelseif url.type eq "Vendors">
            Supplier No
          </cfif>
        </cfoutput> </div></th>
    <th width="300"><div align="center">Name</div></th>
    <th width="70"><div align="center">P. Receive</div></th>
    <th width="70"><div align="center">P. Return</div></th>
    <th width="70"><div align="center">Net</div></th>
  </tr>
  <cfoutput query="getitem">
  	<cfquery name="getcust" datasource="#dts#">
		select name from #target_apvend# where custno = '#custno#'
	</cfquery>
    <cfset rcamt = 0>
    <cfset pramt =0>
    <cfquery name="getrc" datasource="#dts#">
    select sum(amt)as sumamt from ictran where type ="RC" and custno = "#custno#"
    <cfif ndatefrom neq "" and ndateto neq "">
      and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
    </cfif>
    group by custno
    </cfquery>
    <cfif getrc.recordcount gt 0>
      <cfif getrc.sumamt neq "">
        <cfset rcamt = #getrc.sumamt#>
      </cfif>
    </cfif>
    <cfquery name="getpr" datasource="#dts#">
    select sum(amt)as sumamt from ictran where type = "PR" and custno = "#custno#"
    <cfif ndatefrom neq "" and ndateto neq "">
      and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
    </cfif>
    group by custno
    </cfquery>
    <cfif getpr.recordcount gt 0>
      <cfif getpr.sumamt neq "">
        <cfset pramt = #getpr.sumamt#>
      </cfif>
    </cfif>
    <cfset netamt = #rcamt# - #pramt#>
    <cfset totalrcamt = #totalrcamt# + #rcamt#>
    <cfset totalpramt = #totalpramt# + #pramt#>
    <cfset totalnetamt = #totalnetamt# + #netamt#>
    <tr>
      <td nowrap><cfif url.type eq "Products">
          #itemno#
          <cfelseif url.type eq "Vendors">
          #custno# </cfif></td>
      <td><cfif url.type eq "Products">
          #desp#
          <cfelseif url.type eq "Vendors">
          #getcust.name# </cfif></td>
      <td><div align="right">#numberformat(rcamt,".__")#</div></td>
      <td><div align="right">#numberformat(pramt,".__")#</div></td>
      <td><div align="right">#numberformat(netamt,".__")#</div></td>
    </tr>
  </cfoutput> <cfoutput>
    <tr bgcolor="##83B8ED">
      <td nowrap>&nbsp;</td>
      <td>
        <div align="right">Total:</div></td>
      <td>
        <div align="right">#numberformat(totalrcamt,".__")#</div></td>
      <td>
        <div align="right">#numberformat(totalpramt,".__")#</div></td>
      <td>
        <div align="right">#numberformat(totalnetamt,".__")#</div></td>
    </tr>
  </cfoutput>
</table>
</body>
</html>