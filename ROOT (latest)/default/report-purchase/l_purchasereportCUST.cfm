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
<title>Purchase Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfquery name="getcust" datasource="#dts#">
  select refno,wos_date,itemno,custno,name,desp,qty,unit,price,price_bil,amt_bil,amt ,disamt_bil, disamt from ictran
  where custno = '#url.custno#' and (type='PR' or type='RC')
  <cfif isdefined('url.agentid') and isdefined('url.agentidto')>
  and agenno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.agentid)#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.agentidto)#">
  </cfif>
</cfquery>



<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Purchase Report</strong></font></div><br>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Supplier No : #getcust.custno#</cfoutput></strong></font></div><br>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Supplier Name : #getcust.name#</cfoutput></strong></font></div>
  <cfif #getcust.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="l_outstanding.cfm" method="post">
      <cfoutput>

      </cfoutput>
   
    </cfform>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Ref No</font></strong></td>
        <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Date</font></strong></td>
        <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Item no</font></strong></td>
        <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Product Code</font></strong></td>
        <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Item Description</font></strong></td>
        <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Qty</font></strong></td>
         <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Unit</font></strong></td>
         <cfif lcase(hcomid) eq "vsolutionspteltd_i">
         <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Currency</font></strong></td>
         <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Currency Unit Price</font></strong></td>
         <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Currency Amount</font></strong></td>
         
         
         
         </cfif>
	 <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Purchase Price</font></strong></td>
     <cfif lcase(hcomid) eq "vsolutionspteltd_i">
     <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount Amount</font></strong></td>
         </cfif>
 	 <td align="center" ><strong><font size="2" face="Arial, Helvetica, sans-serif">Amount</font></strong></td>
                 
      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      
      <cfoutput query="getcust" startrow="1">
      <cfquery name="getaitemno" datasource="#dts#">
select aitemno from icitem where itemno='#getcust.itemno#'
</cfquery>
<cfquery name="getcurrencycode" datasource="#dts#">
select currcode from artran where refno='#getcust.refno#'
    </cfquery>
		<tr>
          <td align="center">#refno#</div></td>
          <td align="center">#DateFormat(wos_date, 'YYYY-MM-DD')#</div></td>
          <td align="left">#itemno#</div></td>
          <td align="left">#getaitemno.aitemno#</td>
          <td align="left">#desp#</div></td>
          
		  <td align="right">#qty#</td>
          <td align="left">#unit#</td>
          <cfif lcase(hcomid) eq "vsolutionspteltd_i">
          <td align="center">#getcurrencycode.currcode#</td>
          <td align="center">#lsnumberformat(price_bil,',_.__')#</td>
          <td align="center">#lsnumberformat(amt_bil,',_.__')#</td>
         
          
          </cfif>
          <cfif lcase(hcomid) eq "vsolutionspteltd_i">
          <td align="right">#lsnumberformat(price,',_.__')#</td>
          <cfelse>
          <td align="right">#lsnumberformat(price,',_.__')#</td>
          
          </cfif>
          <cfif lcase(hcomid) eq "vsolutionspteltd_i">
           <td align="center">#lsnumberformat(disamt,',_.__')#</td>
           </cfif>
          <td align="right">#lsnumberformat(amt,',_.__')#</td>
          
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
  <cfif getcust.recordCount gt 0><cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
