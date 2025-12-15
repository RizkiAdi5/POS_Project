<html>
<head>
<title>Promotion Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
<script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<script type="text/javascript">

function deletepromo(promoid)
	{
	var answer = confirm('Are you sure to delete this promotion?');
	if(answer)
	{
	var ajaxurl = '/default/maintenance/promotion/deletepromotionajax.cfm?promoid='+promoid;
	new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error delete Promotion'); },		
		
		onComplete: function(transport){
		alert('Promotion has been deleted');
		form.submit();
        }
      })
	
	<!---
	ajaxFunction(document.getElementById('onholdajax'),onholdurl);
	<cfoutput>
	window.location.href="index.cfm?type=#url.type#";
	</cfoutput>--->
	}
	}


</script>
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
    <cfform action="l_vehicles.cfm" name="form" method="post" target="_blank">
    <cfoutput>
    <input type="hidden" name="groupfrom" value="#form.groupfrom#">
    <input type="hidden" name="groupto" value="#form.groupto#">
    <input type="hidden" name="pricedistype" value="#form.pricedistype#">
    <input type="hidden" name="year1" value="#form.year1#">
    <input type="hidden" name="month1" value="#form.month1#">
    <input type="hidden" name="day1" value="#form.day1#">
    <input type="hidden" name="year2" value="#form.year2#">
    <input type="hidden" name="month2" value="#form.month2#">
    <input type="hidden" name="day2" value="#form.day2#">
    </cfoutput>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr><div id="ajaxFieldPro"></div></td>
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
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Action</font></strong></td>

                      
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
          <td align="center" width="9%">#lsnumberformat(priceamt,',_.__')#</td>
          <td align="center" width="9%">#rangefrom#</td>
          <td align="center" width="9%">#rangeto#</td>
          <td align="center" width="9%">#discby#</td>
          <td align="center" width="9%">#pricedistype#</td>
          <td align="center" width="9%">#buydistype#</td>
          <td  align="center" style="color:##09F"><a onClick="deletepromo('#promoid#');" onMouseOver="this.style.cursor='hand'"><u>Delete</u></a></td>
             
        </tr>
        <!--- <cfset i = incrementvalue(#i#)> --->
        <cfset i = incrementvalue(#i#)>
      </cfoutput>
    </table>
    </cfform>
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
