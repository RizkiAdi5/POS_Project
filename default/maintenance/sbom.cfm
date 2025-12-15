<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getall" datasource="#dts#">
	select a.*,b.itemno,b.bom_cost from billmat a, icitem b where a.itemno = b.itemno group by a.itemno,a.bomno order by a.itemno,a.bomno,a.bmitemno
</cfquery>


<body>
<h1 align="center">Search Bill of Material</h1>
<cfoutput> 
  <h4><cfif getpin2.h1J10 eq 'T'><a href="bom.cfm">Create B.O.M</a> </cfif><cfif getpin2.h1J20 eq 'T'>|| <a href="vbom.cfm">List B.O.M</a> </cfif><cfif getpin2.h1J30 eq 'T'>|| <a href="bom.cfm">Search B.O.M</a> </cfif><cfif getpin2.h1J40 eq 'T'>|| <a href="genbomcost.cfm">Generate 
    Cost</a> </cfif><cfif getpin2.h1J50 eq 'T'>|| <a href="checkmaterial.cfm">Check Material</a> </cfif><cfif getpin2.h1J60 eq 'T'>|| <a href="useinwhere.cfm">Use In Where</a></cfif></h4>
</cfoutput> 
<form action="sbom.cfm" method="post">
	<cfoutput>
	<h1>Item No :	
	<input type="text" name="searchitem" value="">	
	
	Bom No : <input type="text" name="searchbom" value="">
	<cfif husergrpid eq "Muser"><input type="submit" name="submit" value="Search"></cfif> </h1>
	</cfoutput>	
</form>

<cfif isdefined("form.searchStr")>
	<cfquery dbtype="query" name="exactResult">
		Select * from getall where itemno = '#form.searchitem#' and bomno = '#form.searchbom#'
	</cfquery>
	
	<cfquery dbtype="query" name="similarResult">
		Select * from getall where itemno LIKE '#form.searchitem#' and bomno LIKE '#form.searchbom#'
	</cfquery>
	<h2>Exact Result</h2>
			<cfif #exactResult.recordCount# neq 0>
			
			</cfif>
</cfif>



<cfif getall.recordcount gt 0>
  <table width="80%" border="0" cellpadding="3" align="center" class="data">
    <tr> 
      <th>Item No</th>
      <th>BOM No</th>
      <th>Material</th>
      <th>Qty Required</th>
      <th>On hand</th>
      <th>Ratio</th>
    </tr>
    <cfloop query="getall">
		
      <cfoutput> 
        <tr> 
          <td>#Itemno#</td>
          <td><div align="center">#Bomno#</div></td>
          <td> 
            <!--- #bmitemno# --->
          </td>
          <td><div align="center"> 
              <!--- #bmqty# --->
            </div></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </cfoutput> 
      <cfquery name="getbody" datasource="#dts#">
      select * from billmat where itemno = '#itemno#' and bomno = '#bomno#'
      </cfquery>
	  
      <cfset cnt = 0>
	  
      <cfoutput query="getbody"> 
	  
        <cfquery name="getitem" datasource="#dts#">
        select desp,qtybf from icitem where itemno = '#getbody.bmitemno#' 
        </cfquery>
        <cfquery name="getout" datasource="#dts#">
        select sum(qty)as sumqty from ictran where itemno = '#getbody.bmitemno#'
		and (type = 'INV' or type = 'DN' or type = 'CS' or type = 'PR' ) 
        </cfquery>
        <cfquery name="getin" datasource="#dts#">
        select sum(qty)as sumqty from ictran where itemno = '#getbody.bmitemno#'
		and (type = 'RC' or type = 'CN')
        
        </cfquery>
        <cfquery name="getdo" datasource="#dts#">
        select sum(qty)as sumqty from ictran where itemno = '#getbody.bmitemno#'
		and type = 'DO' and toinv = "" 
        
        </cfquery>
        <cfif getitem.qtybf neq "">
          <cfset itembal = #getitem.qtybf#>
          <cfelse>
          <cfset itembal = 0>
        </cfif>
        <cfif getout.sumqty neq "">
          <cfset outqty = #getout.sumqty#>
          <cfelse>
          <cfset outqty = 0>
        </cfif>
        <cfif getdo.sumqty neq "">
          <cfset doqty = #getdo.sumqty#>
          <cfelse>
          <cfset doqty = 0>
        </cfif>
        <cfset outqty = #outqty# + #doqty#>
        <cfif getin.sumqty neq "">
          <cfset inqty = #getin.sumqty#>
          <cfelse>
          <cfset inqty = 0>
        </cfif>
        <cfset balonhand = #inqty# - #outqty#>
        <cfset ratio = #balonhand# / #bmqty#>
        <cfif cnt eq 0>
          <cfset smallerratio = #ratio#>
        </cfif>
        <cfif ratio lt smallerratio>
          <cfset smallerratio = #ratio#>
        </cfif>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td nowrap>#bmitemno# - #getitem.desp#</td>
          <td><div align="center">#bmqty#</div></td>
          <td>#balonhand#</td>
          <td>#ratio#</td>
        </tr>
        <cfset cnt = cnt +1>
		
      </cfoutput> 
	  <cfoutput>
      <tr> 
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="3" nowrap><div align="center">Maximum Can Be Manufactured</div></td>
        <td>#smallerratio#</td>
      </tr>
      <tr> 
        <td colspan="6"><hr></td>
      </tr>
	  </cfoutput>
    </cfloop>
  </table>

<cfelse>
  <h3>No Records.</h3>
  
</cfif>
</body>
</html>
