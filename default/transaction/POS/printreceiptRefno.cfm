<cfoutput>
<script type="text/javascript" src="/scripts/ajax.js"></script>
<cfset ptype = 'CS'>

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name from artran where type='#ptype#' order by refno desc limit 15
	</cfquery>
    <font style="text-transform:uppercase">#ptype# NO.</font>&nbsp;<input type="text" name="printrefnocustno1" id="printrefnocustno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldprintrefno'),'printreceiptrefnoajax.cfm?type=#ptype#&custno='+document.getElementById('printrefnocustno1').value+'&custname='+document.getElementById('printrefnocustname1').value);"  />&nbsp;&nbsp;NAME:&nbsp;
    <input type="text" name="printrefnocustname1" id="printrefnocustname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldprintrefno'),'printreceiptrefnoajax.cfm?type=#ptype#&custno='+document.getElementById('printrefnocustno1').value+'&custname='+document.getElementById('printrefnocustname1').value);" />&nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    
    <div id="ajaxFieldprintrefno">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">REF NO #ptype#</font></th>
    <th width="300px">CUSTOMER NAME</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.name#</td>
    <td>
	
    
    
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('/billformat/#dts#/preprintedformat.cfm?billname=receipt_non_editable&tran=#ptype#&nexttranno=#getcustsupp.refno#')"><u>Print</u></a>
   
   

    </td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>