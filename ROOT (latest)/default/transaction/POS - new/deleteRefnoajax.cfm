
<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,type,wos_date,grand,cs_pm_cash,cs_pm_crcd,cs_pm_crc2,cs_pm_dbcd,cs_pm_vouc,cs_pm_cheq,deposit from artran WHERE type ='#url.type#' and (void='' or void is null) and refno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> order by refno desc limit 20
	</cfquery>
	<cfoutput>  
   
       <table width="700px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">DATE</font></th>
    <th width="100px"><font style="text-transform:uppercase">REF NO #url.type#</font></th>
    <th width="300px">CUSTOMER NAME</th>
    <th width="100px">AMOUNT</th>
    <th width="100px">PAYMENT TYPE</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#dateformat(getcustsupp.wos_date,'DD/MM/YYYY')#</td>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.name#</td>
    <td>#numberformat(getcustsupp.grand,',_.__')#</td>
    <td><cfif cs_pm_cash neq 0>Cash<cfelseif cs_pm_dbcd neq 0>Nets<cfelseif cs_pm_crcd neq 0 or cs_pm_crc2 neq 0>Credit Card</cfif></td>
    <td>
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('/billformat/#dts#/preprintedformat.cfm?billname=receipt_non_editable&tran=#getcustsupp.type#&nexttranno=#getcustsupp.refno#')"><u>Print</u></a>&nbsp;&nbsp;&nbsp;
    
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="PopupCenter('editbillcontrol.cfm?tran=#getcustsupp.type#&refno=#getcustsupp.refno#&parentpage=no&type=delete','linkname','500','500');"><u>Void</u></a>
   
</td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>