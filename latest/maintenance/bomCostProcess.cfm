<html>
<head>
<title>Generate BOM Cost</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfif form.itemfrom neq "" and form.itemto neq "">
	<cfquery name="getall" datasource="#dts#">
		select a.*,b.itemno,b.bom_cost from billmat a, icitem b where a.itemno = b.itemno and a.itemno >= '#form.itemfrom#' and a.itemno <= '#form.itemto#' <cfif form.bomno neq "">and a.bomno = '#form.bomno#'</cfif> group by a.itemno order by a.itemno,a.bomno,a.bmitemno
	</cfquery>
<cfelse>
	<cfquery name="getall" datasource="#dts#">
		select a.*,b.itemno,b.bom_cost from billmat a, icitem b where a.itemno = b.itemno group by a.itemno order by a.itemno,a.bomno,a.bmitemno
	</cfquery>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select a.compro,concat(',.',repeat('_',b.decl_uprice)) as decl_uprice 
	from gsetup as a, gsetup2 as b
</cfquery>

<body>
<div align="center"><font color="#000000" size="4" face="Times New Roman, Times, serif">GENERATE COST</font></div>

<cfif getall.recordcount gt 0>
  <table width="100%" border="0" cellpadding="3" align="center">
    <cfoutput>
      <cfif form.itemfrom neq "" and form.itemto neq "">
        <font color="000000" size="2" face="Times New Roman, Times, serif">ITEM
        NO FROM : #form.itemfrom#<br>
        ITEM NO TO : #form.itemto#</font><br>
        <br>
      </cfif>
    </cfoutput>
    <tr>
      <td colspan="6"><cfif getgeneral.compro neq "">
          <font size="2" face="Times New Roman, Times, serif"><cfoutput>#getgeneral.compro#</cfoutput></font> </cfif> </td>
      <td>&nbsp;</td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput></font></div></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <td width="20%" colspan="2"><font size="2" face="Times New Roman, Times, serif"><strong>ITEM
        NO</strong></font></td>
      <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
      <td width="5%"><font size="2" face="Times New Roman, Times, serif"><strong>MATERIAL</strong></font></td>
      <td><div align="center"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
      <td><div align="center"><font size="2" face="Times New Roman, Times, serif"><strong>QTY
          REQ.</strong></font></div></td>
      <td>&nbsp;</td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <cfset loopcnt = 0>
    <cfloop query="getall">
      <cfquery name="getbomcost" datasource="#dts#">
      select bom_cost,desp from icitem where itemno = '#itemno#'
      </cfquery>
      <cfquery name="getdata" datasource="#dts#">
      select * from billmat where itemno = '#itemno#' and bomno='#getall.bomno#' group by itemno,bomno order
      by bomno
      </cfquery>
      <cfloop query="getdata">
        <cfoutput>
          <tr>
            <td colspan="3"><font size="2" face="Times New Roman, Times, serif">
              <cfif loopcnt eq 0>
                #Itemno#
              </cfif>
              </font> <div align="left"></div></td>
            <td colspan="5" nowrap> <font size="2" face="Times New Roman, Times, serif">
              <cfif loopcnt eq 0>#getbomcost.desp#</cfif> </font> <div align="center"><font size="2" face="Times New Roman, Times, serif">
                </font></div>
              <font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
          </tr>
        </cfoutput>
        <cfquery name="getbody" datasource="#dts#">
        select * from billmat where itemno = '#itemno#' and bomno = '#bomno#'
        order by bmitemno
        </cfquery>
        <!--- <cfset cnt = 0> --->
        <cfset totalcost = 0>
        <cfset totalcost = getbomcost.bom_cost>
        <cfoutput>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td nowrap>&nbsp;</td>
            <td nowrap><font size="2" face="Times New Roman, Times, serif">MISC.
              COST : </font></td>
            <td nowrap>&nbsp;</td>
            <td>&nbsp;</td>
            <td nowrap>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getbomcost.bom_cost,getgeneral.decl_uprice)#</font></div></td>
          </tr>
        </cfoutput>
        <cfoutput query="getbody">
          <cfif bmqty neq ''>
            <cfset xbmqty = getbody.bmqty>
            <cfelse>
            <cfset xbmqty = 0>
          </cfif>
          <cfquery name="getbmitem" datasource="#dts#">
          select desp,ucost from icitem where itemno = '#getbody.bmitemno#'
          </cfquery>
          
          <cfif isdefined('form.movingavrg')>
    <!--- Get average moving cost --->
    <cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU','CT'">
	<cfset outtrantypewodo="'INV','PR','DN','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
	<cfset outtrantypewithinv="'INV','DO','DN','PR','CS','ISS','OAR','TROU'">
	<cfset outtrantypewodo="'INV','PR','DN','CS','ISS','OAR','TROU'">
</cfif>
 <cfquery name="getitem2" datasource="#dts#">
			select a.itemno,a.desp,a.ucost,(ifnull(a.qtybf,0)) as qtybf,b.lastin,c.lastout,d.qin,e.qout,f.rcamt,f.rcqty,g.pramt,g.prqty,h.movqin,i.movqout,ifnull(((ifnull(a.qtybf,0))+ifnull(b.lastin,0)-ifnull(c.lastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)),0) as balance,
							((((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0))*ifnull(a.avcost2,0)+ifnull(f.rcamt,0)-ifnull(g.pramt,0))/((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0)+ifnull(f.rcqty,0)-ifnull(g.prqty,0))) as unitcost,
				ifnull((((ifnull(a.qtybf,0))+ifnull(b.lastin,0)-ifnull(c.lastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0))*((((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0))*ifnull(a.avcost2,0)+ifnull(f.rcamt,0)-ifnull(g.pramt,0))/((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0)+ifnull(f.rcqty,0)-ifnull(g.prqty,0)))),1) as stockbalance
			
			from icitem as a
	
			left join
			(
				select sum(qty) as lastin,itemno 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) and (void = '' or void is null)
                and fperiod !='99'
				and (linecode <> 'SV' or linecode is null)
				group by itemno
			) as b on a.itemno=b.itemno
	
			left join
			(
				select sum(qty) as lastout,itemno 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) and (void = '' or void is null) and (toinv='' or toinv is null)
                and fperiod !='99'
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as c on a.itemno=c.itemno
	
			left join
			(
				select sum(qty) as qin,itemno 
				from ictran
				where type in (#PreserveSingleQuotes(intrantype)#) and (void = '' or void is null)
                and fperiod !='99'
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as d on a.itemno=d.itemno
	
			left join
			(
				select sum(qty) as qout,itemno 
				from ictran
				where type in (#PreserveSingleQuotes(outtrantypewithinv)#) and (void = '' or void is null) and (toinv='' or toinv is null)
                and fperiod !='99'
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as e on a.itemno=e.itemno
	
			left join
			(
				select sum(qty) as rcqty,sum(amt) as rcamt,itemno 
				from ictran
				where type='RC' and (void = '' or void is null)
				and fperiod !='99'
				group by itemno
			) as f on a.itemno=f.itemno
	
			left join
			(
				select sum(qty) as prqty,sum(amt) as pramt,itemno 
				from ictran
				where type='PR' and (void = '' or void is null)
                and fperiod !='99'
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as g on a.itemno=g.itemno
	
			left join
			(
				select sum(qty) as movqin,itemno 
				from ictran
				where type='CN' and wos_date=(select max(wos_date) from ictran where type='RC' and (void = '' or void is null))	and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as h on a.itemno=h.itemno
	
			left join
			(
				select sum(qty) as movqout,itemno 
				from ictran
				where type in ('CN','INV') and wos_date=(select max(wos_date) from ictran where type='RC' and (void = '' or void is null)) and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)

				group by itemno
			) as i on a.itemno=i.itemno
	
			left join
			(	
				select (ifnull(bb.sumqty,0)-ifnull(cc.sumqty,0)) as pqty,ifnull(bb.sumqty,0) as pin,ifnull(cc.sumqty,0) as pout,aa.itemno 
				from icitem as aa
				left join
				(
					select sum(qty) as sumqty,itemno 
					from ictran
					where (void = '' or void is null) and type in (#PreserveSingleQuotes(intrantype)#) and fperiod='99' 
					and (linecode <> 'SV' or linecode is null)
					group by itemno
				) as bb on aa.itemno=bb.itemno
	
				left join
				(
					select sum(qty) as sumqty, itemno 
					from ictran
					where (void = '' or void is null) and type in (#PreserveSingleQuotes(outtrantypewithinv)#) and fperiod='99' and (toinv='' or toinv is null) 
					and (linecode <> 'SV' or linecode is null)
					group by itemno
				) as cc on aa.itemno=cc.itemno
	
					and aa.itemno ='#bmitemno#'
				
				group by aa.itemno
			) as j on a.itemno = j.itemno
	

			where a.itemno <> ''
			
			and a.itemno ='#getbody.bmitemno#'
			
			order by a.itemno;
		</cfquery>
        
    <!--- end of average moving cost --->
     
      <cfif getitem2.balance neq 0 and getitem2.balance neq ''>
            <cfset xucost = getitem2.stockbalance/getitem2.balance>
            <cfelse>
            <cfset xucost = 0>
          </cfif>
     
    <cfelse>
    
    <cfif getbmitem.ucost neq ''>
            <cfset xucost = getbmitem.ucost>
            <cfelse>
            <cfset xucost = 0>
          </cfif>
    </cfif>
          
          
          
          <cfset itemcost = xbmqty * xucost>
          <cfset totalcost = totalcost + itemcost>
          
          <tr>
            <td width="10%"><div align="center"></div></td>
            <td colspan="3"><font size="2" face="Times New Roman, Times, serif">&nbsp;#getbody.bmitemno#</font></td>
            <td nowrap><div align="left"><font size="2" face="Times New Roman, Times, serif">#getbmitem.desp#</font></div></td>
            <td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getbody.bmqty#</font></div></td>
            <td nowrap><font size="2" face="Times New Roman, Times, serif"><cfif isdefined('form.movingavrg')>#numberformat(xucost,getgeneral.decl_uprice)#<cfelse>#numberformat(getbmitem.ucost,getgeneral.decl_uprice)#</cfif></font></td>
            <td> <div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(itemcost,getgeneral.decl_uprice)#</font></div></td>
          </tr>
        </cfoutput>
        <!--- getbody --->
        <cfoutput>
          <tr>
            <td colspan="7">&nbsp;</td>
            <td><div align="right">___________</div></td>
          </tr>
          <tr>
            <td colspan="2"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td nowrap><font size="2" face="Times New Roman, Times, serif">TOTAL
              : </font></td>
            <td colspan="2" nowrap><div align="center"></div></td>
            <td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalcost,getgeneral.decl_uprice)#</font></div></td>
          </tr>
			<cfif isdefined("form.update_cost")>
				<cfquery name="update_cost" datasource="#dts#">
					update icitem set 
					ucost=(#totalcost#+bom_cost) 
					where itemno='#itemno#'
				</cfquery>
			</cfif>
        </cfoutput>
        <cfset loopcnt = loopcnt +1>
      </cfloop>
      <!--- getdata --->
      <tr>
        <td colspan="8"><hr></td>
      </tr>
      <cfset loopcnt = 0>
    </cfloop>
    <!--- getall --->
  </table>

<cfelse>
  Sorry. No Records.

</cfif>
</body>
</html>
