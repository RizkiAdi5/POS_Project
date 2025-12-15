<cfoutput>
<script type="text/javascript" src="/scripts/ajax.js"></script>
<cfset ptype = 'CS'>

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,type,wos_date,grand,cs_pm_cash,cs_pm_crcd,cs_pm_crc2,cs_pm_dbcd,cs_pm_vouc,cs_pm_cheq,deposit from artran where type='#ptype#' and (void='' or void is null) order by refno desc limit 15
	</cfquery>
    <font style="text-transform:uppercase">#ptype# NO.</font>&nbsp;<input type="text" name="deleterefnocustno1" id="deleterefnocustno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielddeleterefno'),'deleterefnoajax.cfm?type=#ptype#&custno='+document.getElementById('deleterefnocustno1').value+'&custname='+document.getElementById('deleterefnocustname1').value);"  />&nbsp;&nbsp;NAME:&nbsp;
    <input type="text" name="deleterefnocustname1" id="deleterefnocustname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielddeleterefno'),'deleterefnoajax.cfm?type=#ptype#&custno='+document.getElementById('deleterefnocustno1').value+'&custname='+document.getElementById('deleterefnocustname1').value);" />&nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    
    <div id="ajaxFielddeleterefno">
    <table width="700px">
   	<tr>
    <th width="100px">DATE</th>
    <th width="100px">REF NO #ptype#</th>
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