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
<title>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card Details</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="totalin" default="0">
<cfparam name="totalout" default="0">

<cfif url.df neq "" and url.dt neq "">
	<cfset dd=dateformat(url.df,"DD")>

	<cfif dd greater than "12">
		<cfset ndatefrom=dateformat(url.df,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom=dateformat(url.df,"YYYYDDMM")>
	</cfif>

	<cfset dd=dateformat(url.dt,"DD")>

	<cfif dd greater than "12">
		<cfset ndateto=dateformat(url.dt,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto=dateformat(url.dt,"YYYYDDMM")>
	</cfif>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro, lastaccyear from gsetup
</cfquery>

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
	and a.itemno='#url.itemno#' 
	and (b.void = '' or b.void is null)
	and (b.linecode <> 'SV' or linecode is null)
	and b.type in ('INV','CN','DN','CS','PR','RC','DO','ISS','OAI','OAR','TRIN','TROU') 
	and <cfif isdefined('url.groupto')>substring_index(b.location,'-',1)<cfelse>b.location</cfif>='#url.location#'
    
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
			<cfif url.pef neq "" and url.pet neq "">
				and a.fperiod between '#pef#' and '#pet#'
			</cfif>
			<cfif url.df neq "" and url.dt neq "">
				and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
			<cfelse>
				and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
		)as c
	</cfif>
	where a.itemno=b.itemno 
	and a.itemno='#url.itemno#' 
	and (b.void = '' or b.void is null)
	and (b.linecode <> 'SV' or linecode is null)
	and b.type in ('INV','CN','DN','CS','PR','RC','DO','ISS','OAI','OAR','TRIN','TROU') 
	and b.fperiod<>'99'
	and <cfif isdefined('url.groupto')>substring_index(b.location,'-',1)<cfelse>b.location</cfif>='#url.location#'
	<cfif url.pef neq "" and url.pet neq "">
		and b.fperiod between '#pef#' and '#pet#'
	</cfif>
	<cfif url.df neq "" and url.dt neq "">
		and b.wos_date >= '#ndatefrom#' and b.wos_date <= '#ndateto#'
	<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
	</cfif>
	<cfif lcase(hcomid) eq "ovas_i">
		and if(b.type='TROU' or b.type='TRIN','TR',b.type)=c.type and b.refno=c.refno
	</cfif>
	order by b.wos_date,a.created_on
</cfquery>
</cfif>
<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
<p align="center"><font size="4" face="Times New Roman, Times, serif"><strong>STOCK CARD DETAILS</strong></font></p>

<table width="100%" border="0" align="center" cellspacing="0">
<cfoutput>
	<cfif url.cf neq "" and url.ct neq "">
		<tr>
        	<td colspan="100%" align="center"><font size="2" face="Times New Roman, Times, serif">Category From #url.cf# To #url.ct#</font></td>
      	</tr>
    </cfif>
    <cfif url.gpf neq "" and url.gpt neq "">
      	<tr>
        	<td colspan="100%" align="center"><font size="2" face="Times New Roman, Times, serif">Group From #url.gpf# To #url.gpt#</font></td>
		</tr>
    </cfif>
    <cfif url.pef neq "" and url.pet neq "">
      	<tr>
        	<td colspan="100%" align="center"><font size="2" face="Times New Roman, Times, serif">Period From #url.pef# To #url.pet#</font></td>
      	</tr>
    </cfif>
    <cfif url.df neq "" and url.dt neq "">
      	<tr>
        	<td colspan="100%" align="center"><font size="2" face="Times New Roman, Times, serif">Date From #url.df# To #url.dt#</font></td>
      	</tr>
    </cfif>
    <tr>
      	<td colspan="7"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		<td colspan="3"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
	<tr>
        <td colspan="100%"><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "mhca_i">MARKETER<cfelse>LOCATION</cfif>: #url.location# - #url.location_desp#</font></td>
    </tr>
	<tr>
    <td colspan="100%"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #url.itemno# - #getictran.desp# #getictran.despa#</font></td>
    </tr>
    <cfquery name="getitem" datasource="#dts#">
  select aitemno from icitem where itemno='#url.itemno#'
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
    	
    	<td><font size="2" face="Times New Roman, Times, serif"><div align="right"><cfoutput>#itembal#</cfoutput></div></font></td>
    	<td></td>
    	<td></td>
    	<td></td>
  	</tr>
      
  <cfloop query="getictran">
  
  <cfif isdefined('url.dodate')>
   <cfif type eq "INV">
  <cfquery name="checkexist2" datasource="#dts#">
  select toinv,refno,type,itemno from ictran a  where refno ='#getictran.refno#' and itemno =<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and location =<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.location#"> and type = "#getictran.type#" and trancode = "#getictran.trancode#" and (dono = "" or dono is null or dono not in (select frrefno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by frrefno))
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
            
            
            <cfif isdefined('url.dodate')>
                    
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
			<cfif isdefined('url.dodate')>
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
</table>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>