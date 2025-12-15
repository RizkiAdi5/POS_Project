<cfinclude template = "../../../CFC/convert_single_double_quote_script.cfm">

<cfoutput>
	<cfquery name="getaddress" datasource="#dts#">
   		select * from address order by code limit 100
	</cfquery>

    <font style="text-transform:uppercase">CODE.</font>&nbsp;<input type="text" name="code1" id="code1" size="10" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielddadd'),'/default/transaction/expressbill/searchaddressajax.cfm?code='+escape(document.getElementById('code1').value)+'&addname='+escape(document.getElementById('addname1').value)+'&custno='+escape(document.getElementById('custno1').value));"  />&nbsp;NAME:&nbsp;<input type="text" size="12" name="addname1" id="addname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielddadd'),'/default/transaction/expressbill/searchaddressajax.cfm?code='+escape(document.getElementById('code1').value)+'&addname='+escape(document.getElementById('addname1').value)+'&custno='+escape(document.getElementById('custno1').value));" />&nbsp;CUSTNO:&nbsp;<input type="text" size="12" name="custno1" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielddadd'),'/default/transaction/expressbill/searchaddressajax.cfm?code='+escape(document.getElementById('code1').value)+'&addname='+escape(document.getElementById('addname1').value)+'&custno='+escape(document.getElementById('custno1').value));" />&nbsp;&nbsp;<input type="button" name="gobtn1" value="Go"  />
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    <div id="ajaxFielddadd" name="ajaxFielddadd">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">CODE</font></th>
    <th width="300px">NAME</th>
    <th width="50px">CUSTNO</th>
    <th width="50px">ADDRESS</th>
    <th width="50px">ATTN</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getaddress" >
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    <td>#getaddress.code#</td>
    <td>#getaddress.name#</td>
    <td>#getaddress.custno#</td>
    <td>#getaddress.add1#<br />#getaddress.add2#<br />#getaddress.add3#<br />#getaddress.add4#</td>
    <td>#getaddress.attn#</td>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="document.getElementById('Dcode').value =unescape('#URLENCODEDFORMAT(getaddress.code)#');document.getElementById('d_name').value =unescape('#URLENCODEDFORMAT(getaddress.name)#');document.getElementById('d_add1').value =unescape('#URLENCODEDFORMAT(getaddress.add1)#');document.getElementById('d_add2').value =unescape('#URLENCODEDFORMAT(getaddress.add2)#');document.getElementById('d_add3').value =unescape('#URLENCODEDFORMAT(getaddress.add3)#');document.getElementById('d_add4').value =unescape('#URLENCODEDFORMAT(getaddress.add4)#');document.getElementById('d_attn').value =unescape('#URLENCODEDFORMAT(getaddress.attn)#');document.getElementById('d_phone').value =unescape('#URLENCODEDFORMAT(getaddress.phone)#');document.getElementById('d_fax').value =unescape('#URLENCODEDFORMAT(getaddress.fax)#');ColdFusion.Window.hide('changedaddr');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>