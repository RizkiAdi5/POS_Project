<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<cfquery name="getoutstandingso" datasource="#dts#">
SELECT refno,wos_date,custno,name FROM artran where type='SO' and fperiod!='99' and (void='' or void is null) and (toinv='' or toinv is null)
</cfquery>
<h3 align="center">Outstanding SO</h3>
 <cfoutput>
    <table width="100%">
    <tr>
    <th><font style="text-transform:uppercase">SO NO</font></th>
    <th >Date</th>
    <th >Customer No</th>
    <th>Customer Name</th>
    </tr>
   
    <cfloop query="getoutstandingso" >
    <tr>
    <td>#getoutstandingso.refno#</td>
    <td>#dateformat(getoutstandingso.wos_date,'DD/MM/YYYY')#</td>
    <td>#getoutstandingso.custno#</td>
    <td>#getoutstandingso.name#</td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>