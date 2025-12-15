<html>
<head>
<title>Promotion Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfset newdate = createdate('#form.year1#','#form.month1#','#form.day1#') >
<cfset newdate2 = createdate('#form.year2#','#form.month2#','#form.day2#') >

<cfset newdate3 = dateformat(newdate,'YYYY-MM-DD') >
<cfset newdate4 = dateformat(newdate2,'YYYY-MM-DD')>

<cfquery name="getpromotion" datasource="#dts#">
  select * from promotion
  where 0=0
    <cfif form.pricedistype neq "">
  		and type = '#form.pricedistype#'
   </cfif>
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and promoid >= '#form.groupfrom#' and promoid <= '#form.groupto#'
  </cfif>
    <cfif newdate3 neq "" and newdate4 neq "">
	and periodfrom >= '#newdate3#' and periodto <= '#newdate4#'
  </cfif>
  order by promoid
</cfquery>


<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Promotion</cfoutput> Listing</strong></font></div>
  	<cfif form.groupfrom neq "" and form.groupto neq "">
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Promotion ID #form.groupfrom# - #form.groupto#</cfoutput></font></div>
</cfif>
	<cfif form.pricedistype neq "" >
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Promotion type #form.pricedistype#</cfoutput></font></div>
</cfif>
    <cfif newdate3 neq "" and newdate4 neq "">
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Period #newdate3# - #newdate4#</cfoutput></font></div>
</cfif>



  <cfif #getpromotion.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="l_vehicles.cfm" method="post">
      <cfoutput>
        <input type="hidden" name="groupfrom" value="#form.groupfrom#">
        <input type="hidden" name="groupto" value="#form.groupto#">

      </cfoutput>
   
    </cfform>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" width="2%"><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Promotion ID</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Promotion Type</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Period From</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Period To</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Price Amount</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Range From</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Range To</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount By</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Price Discount Type</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Buy Discount Type</font></strong></td>

                      
      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      
      <cfoutput query="getpromotion" startrow="1">
        <tr>
          <td align="center" width="2%"><div align="left">#i#</div></td>
          <td align="center" width="9%">#promoid#</td>
          <td align="center" width="9%">#type#</td>
          <td align="center" width="9%">#dateformat(periodfrom,'DD-MM-YYYY')#</td>
          <td align="center" width="9%">#dateformat(periodto,'DD-MM-YYYY')#</td>
          <td align="center" width="9%">#lsnumberformat(val(priceamt),',_.__')#</td>
          <td align="center" width="9%">#rangefrom#</td>
          <td align="center" width="9%">#rangeto#</td>
          <td align="center" width="9%">#discby#</td>
          <td align="center" width="9%">#pricedistype#</td>
          <td align="center" width="9%">#buydistype#</td>
             
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
  <cfif getpromotion.recordCount gt 0><cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
