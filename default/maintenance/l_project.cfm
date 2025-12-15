<html>
<head>
<title>Project Listing Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfquery name="getproject" datasource="#dts#">
  select * from project 
  where porj = "P"
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and source >= '#form.groupfrom#' and source <= '#form.groupto#'
  </cfif>
  order by source
</cfquery>


<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Project</cfoutput> Listing</strong></font></div>

  <cfif #getproject.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="l_project.cfm" method="post">
      <cfoutput>
        <input type="hidden" name="groupfrom" value="#form.groupfrom#">
        <input type="hidden" name="groupto" value="#form.groupto#">
        <cfif isdefined("form.cbcreditsales")>
          <input type="hidden" name="cbcreditsales" value="#form.cbcreditsales#">
        </cfif>
        <cfif isdefined("form.cbcashsales")>
          <input type="hidden" name="cbcashsales" value="#form.cbcashsales#">
        </cfif>
        <cfif isdefined("form.cbsalesreturn")>
          <input type="hidden" name="cbsalesreturn" value="#form.cbsalesreturn#">
        </cfif>
        <cfif isdefined("form.cbpurchase")>
          <input type="hidden" name="cbpurchase" value="#form.cbpurchase#">
        </cfif>
        <cfif isdefined("form.cbpurchasereturn")>
          <input type="hidden" name="cbpurchasereturn" value="#form.cbpurchasereturn#">
        </cfif>
      
      </cfoutput>
   
    </cfform>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" width="2%"><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Project Code</cfoutput></font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Description</cfoutput></font></strong></td>
                        <cfif isdefined("form.cbcreditsales")>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Credit Sales</font></strong></td>
        </cfif>
            <cfif isdefined("form.cbcashsales")>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Cash Sales</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbsalesreturn")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Sales Return</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbpurchase")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Purchase</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbpurchasereturn")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Purchase Return</font></strong></td>
        </cfif>
        
      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      
      <cfoutput query="getproject" startrow="1">
        <tr>
          <td align="center" width="2%"><div align="left">#i#</div></td>
          <td align="center" width="9%">#source#</td>
          <td align="center" width="9%">#project#</td>
          <cfif isdefined("form.cbcreditsales")>
            <td align="center" width="9%">#creditsales#</td>
          </cfif>
          <cfif isdefined("form.cbcashsales")>
            <td align="center" width="9%">#cashsales#</td>
          </cfif>
          <cfif isdefined("form.cbsalesreturn")>
            <td align="center" width="9%">#salesreturn#</td>
          </cfif>
          <cfif isdefined("form.cbpurchase")>
            <td align="center" width="9%">#purchase#</td>
          </cfif>
          <cfif isdefined("form.cbpurchasereturn")>
            <td align="center" width="9%">#purchasereturn#</td>
          </cfif>
         
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
  <cfif getproject.recordCount gt 0><cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
