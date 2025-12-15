<html>
<head>
<title>Vehicle Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfquery name="getVehicles" datasource="#dts#">
  select * from vehicles 
  where 0=0
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and entryno >= '#form.groupfrom#' and entryno <= '#form.groupto#'
  </cfif>
    <cfif form.groupfrom2 neq "" and form.groupto2 neq "">
	and custcode >= '#form.groupfrom2#' and custcode <= '#form.groupto2#'
  </cfif>
  order by carno
</cfquery>


<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Vehicles</cfoutput> Listing</strong></font></div>

  <cfif #getVehicles.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" width="2%"><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Vehicle No</cfoutput></font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Customer No</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Model</font></strong></td>
        
      
   
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Vehicle Make</font></strong></td>

			<td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Vehicle Color</font></strong></td>

          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Chasis No</font></strong></td>

          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Year of manufacture</font></strong></td>

          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Original Reg Date</font></strong></td>

          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Capacity</font></strong></td>
      
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Coverage type</font></strong></td>
       
      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      
      <cfoutput query="getvehicles" startrow="1">
        <tr>
          <td align="center" width="2%"><div align="left">#i#</div></td>
          <td align="center" width="9%">#entryno#</td>
          	<td align="center" width="9%">#custcode#</td>
            <td align="center" width="9%">#model#</td>
            <td align="center" width="9%">#make#</td>
			<td align="center" width="9%">#colour#</td>
            <td align="center" width="9%">#chasisno#</td>
        
            <td align="center" width="9%">#yearmade#</td>
         
            <td align="center" width="9%">#dateformat(oriregdate,'DD-MM-YYYY')#</td>
        
            <td align="center" width="9%">#capacity#</td>
         
            <td align="center" width="9%">#coveragetype#</td>
        
        </tr>
        <!--- <cfset i = incrementvalue(#i#)> --->
        <cfset i = incrementvalue(#i#)>
      </cfoutput>
    </table>
    <br>
    <div align="right">
      <!---       <cfif #start# neq 1>
        <cfoutput><a href="l_icitem.cfm">Previous</a> ||</cfoutput>
      </cfif>
      <cfif #page# neq #noOfPage#>
        <cfoutput> <a href="l_icitem.cfm">Next</a> ||</cfoutput>
      </cfif> --->
    </div>
    <cfelse>
    <h3><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.</font></h3>
  </cfif>
  <cfif getVehicles.recordCount gt 0><cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
