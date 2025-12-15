<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>
<cfif form.itemfrom neq "" and form.itemto neq "">
	<cfquery name="getall" datasource="#dts#">
		select a.*,b.itemno,b.bom_cost from billmat a, icitem b where a.itemno = b.itemno and a.itemno >= '#form.itemfrom#' and a.itemno <= '#form.itemto#' group by a.itemno order by a.itemno,a.bomno,a.bmitemno
	</cfquery>
<cfelse>
	<cfquery name="getall" datasource="#dts#">
		select a.*,b.itemno,b.bom_cost from billmat a, icitem b where a.itemno = b.itemno group by a.itemno order by a.itemno,a.bomno,a.bmitemno
	</cfquery>
</cfif>
<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup
</cfquery>


<body>

<div align="center"><font color="#000000" size="4" face="Times New Roman, Times, serif">LIST BILL
  OF MATERIAL</font> </div>

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
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput></font></div></td>
    </tr>
    <tr>
      <td colspan="7"><hr></td>
    </tr>
    <tr>
      <td><font size="2" face="Times New Roman, Times, serif"><strong>ITEM NO</strong></font></td>
      <td><font size="2" face="Times New Roman, Times, serif"><strong>BOM NO</strong></font></td>
      <td colspan="2"><font size="2" face="Times New Roman, Times, serif"><strong>MATERIAL</strong></font></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>QTY
          REQ.</strong></font></div></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>ON
          HAND </strong></font></div></td>
      <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>RATIO</strong></font></div></td>
    </tr>
    <tr>
      <td colspan="7"><hr></td>
    </tr>
    <cfset loopcnt = 0>
    <cfloop query="getall">
      <cfquery name="getbomcost" datasource="#dts#">
      select bom_cost from icitem where itemno = '#itemno#'
      </cfquery>
      <cfquery name="getdata" datasource="#dts#">
      select * from billmat where itemno = '#itemno#' group by itemno,bomno order
      by bomno
      </cfquery>
      <cfloop query="getdata">
        <cfoutput>
          <tr>
            <td width="15%"><font size="2" face="Times New Roman, Times, serif">
              <cfif loopcnt eq 0>
                #Itemno#
              </cfif>
              </font></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#Bomno#</font></div></td>
            <td colspan="2"> <font size="2" face="Times New Roman, Times, serif">
              <!--- #bmitemno# --->
              Miscellaneous Cost - #numberformat(getbomcost.bom_cost,".__")#</font></td>
            <td><div align="center"> <font size="2" face="Times New Roman, Times, serif">
                <!--- #bmqty# --->
                </font></div></td>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
          </tr>
        </cfoutput>
        <cfquery name="getbody" datasource="#dts#">
        select * from billmat where itemno = '#itemno#' and bomno = '#bomno#'
        order by bmitemno
        </cfquery>
        <cfset cnt = 0>
        <cfoutput query="getbody">
        <cfquery name="getbalance" datasource="#dts#">
        select
			a.itemno,
			a.desp,
			a.unit,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			ifnull(f.sqty,0) as sqty,
			ifnull(f.sumamt,0) as sumamt,
			
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.qtybf,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
		
			from icitem as a
	
			left join
			(
				select itemno,sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
				and fperiod+0 < '' 
				and fperiod<>'99'
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				 
				group by itemno
			) as b on a.itemno = b.itemno
	
			left join
			(
				select itemno,sum(qty) as getlastout 
				from ictran
				where type in ('INV','DO','DN','PR','CS','ISS','OAR','TROU')
				and fperiod+0 < '' 
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
				where type in ('RC','CN','OAI','TRIN')
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				
	    		 
				group by itemno
			) as d on a.itemno = d.itemno
	
			left join
			(
				select itemno,sum(qty) as qout 
				from ictran 
				where type in ('INV','DO','DN','PR','CS','ISS','OAR','TROU')
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null)
				and (toinv='' or toinv is null) 
	   			
	    		 
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
				
				 
				group by itemno
			) as f on a.itemno = f.itemno 

			
	
			where a.itemno=a.itemno


			
				and a.itemno = '#getbody.bmitemno#'

        </cfquery>
        <cfif val(bmqty) eq 0>
        <cfset bmqty = 1>
		</cfif>
          <cfset ratio = val(getbalance.balance) / val(bmqty)>
          <cfif cnt eq 0>
            <cfset smallerratio = ratio>
          </cfif>
          <cfif ratio lt smallerratio>
            <cfset smallerratio = ratio>
          </cfif>
          <tr>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td nowrap><font size="2" face="Times New Roman, Times, serif">#bmitemno# - #getbalance.desp#</font></td>
            <td nowrap><font size="2" face="Times New Roman, Times, serif">#getbalance.unit#</font></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#bmqty#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getbalance.balance)#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#ratio#</font></div></td>
          </tr>
          <cfset cnt = cnt +1>
        </cfoutput>
        
        <!--- getbody --->
        <cfoutput>
          <tr>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
            <td colspan="4" nowrap><div align="center"><font size="2" face="Times New Roman, Times, serif">MAXIMUM
                CAN BE MANUFACTURED</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#smallerratio#</font></div></td>
          </tr>
        </cfoutput>
        <cfset loopcnt = loopcnt +1>
      </cfloop>
      <!--- getdata --->
      <tr>
        <td colspan="7"><hr></td>
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
