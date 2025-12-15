<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">

<cfquery name="getdisplay" datasource="#dts#">
select * from displaysetup
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfoutput>
<cfset defaultfontsize = "#getgsetup.fontsize#px">
<cfset reftype= ''>
	<cfquery name="getitem" datasource="#dts#">
   		select itemno,aitemno,desp,ucost,price,category,sizeid from icitem where 0=0
         <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
		<cfif Huserloc neq "All_loc">
        and itemno in (select itemno from locqdbf where location='#Huserloc#')
        </cfif>
        </cfif> 
        and itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" />
        and (nonstkitem<>'T' or nonstkitem is null)
         order by itemno limit 160
	</cfquery>
    <cfquery name="getgroup" datasource="#dts#">
   	select wos_group from icgroup
	</cfquery>
    <cfquery name="getbrand" datasource="#dts#">
   	select brand from brand
	</cfquery>
    <table>
    <tr>
    <td valign="top" width="1000px">
    <table>
    <tr>
    <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">ITEM NO.</font></td>
    <td><input type="text" name="itemno1" id="itemno1" value="#url.itemno#" size="12" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('itemname3').focus();}} else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td>
    <td>&nbsp;</td>
    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
    <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">LEFT NAME:&nbsp;</font></td>
    <td> <input type="text" size="12" name="itemname2" id="itemname2" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('aitemno').focus();}}  else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td>
     <td>&nbsp;</td>
    <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">MID NAME:&nbsp;</font></td>
    <td><input type="text" size="12" name="itemname3" id="itemname3" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('itemname2').focus();}} else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td><cfelse>
    <td>
    <font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">MID NAME:&nbsp;</font></td>
    <td><input type="text" size="12" name="itemname3" id="itemname3" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('itemname2').focus();}} else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td>
    <td>&nbsp;</td><td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">LEFT NAME:&nbsp;</font></td><td><input type="text" size="12" name="itemname2" id="itemname2" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('aitemno').focus();}}  else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td>
	
	</cfif>
    <td> &nbsp;&nbsp;<input type="button" name="gobtn1" id="gobtn1" value="Go" onclick="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));" onkeyup="if(event.keyCode==40){document.getElementById('btn1').focus()}"  /></td>
    </tr>
    <tr>
    <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">#getgsetup.lgroup#:&nbsp;&nbsp;</font></td>
    <td>
    <cfif lcase(hcomid) eq "ssuni_i">
    <select name="group1" id="group1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));">
    <option value="">Choose a group</option>
    <cfloop query="getgroup">
    <option value="#getgroup.wos_group#">#getgroup.wos_group#</option>
    </cfloop>
    </select>
    <cfelse>
    <input type="text" size="12" name="group1" id="group1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));">
    </cfif>
    </td>
    <td>&nbsp;</td>
    <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">#getgsetup.lmaterial#:&nbsp;&nbsp;</font></td>
     <td><input type="text" size="12" name="colorid1" id="colorid1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));"></td>
    
    <td>&nbsp;</td>
    <TD><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">Brand:&nbsp;&nbsp;</font></TD>
    <td><select name="brand1" id="brand1" style="width:100px" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));">
    <option value="">Choose a brand</option>
    <cfloop query="getbrand">
    <option value="#getbrand.brand#">#getbrand.brand#</option>
    </cfloop>
    </select></td>
    </tr>
    <tr>
      <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">#getgsetup.lcategory#:&nbsp;&nbsp;</font></td>
     <td><input type="text" size="12" name="cate1" id="cate1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));"></td>
     <td>&nbsp;</td>
      
     
      <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;"><cfif lcase(hcomid) eq 'tcds_i'>Asian</cfif> #getgsetup.lsize#:&nbsp;&nbsp;</font></td>
     <td> <input type="text" size="12" name="sizeid1" id="sizeid1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));"></td>
     <td>&nbsp;</td>
     <cfif lcase(hcomid) eq 'tcds_i'>
     <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">#getgsetup.lsize#:&nbsp;</font></td>
     <cfelse>
      <td><font style="text-transform:uppercase;font:'Times New Roman', Times, serif; font-size:#defaultfontsize#;">PRODUCT CODE:&nbsp;</font></td>
     </cfif>
    <td><input type="text" size="12" name="aitemno" id="aitemno" onfocus="clearTimeout(t2);" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFielditm'),'searchitemajax.cfm?reftype=#reftype#&itemno='+escape(document.getElementById('itemno1').value)+'&itemname='+escape(document.getElementById('itemname3').value)+'&leftitemname='+escape(document.getElementById('itemname2').value)+'&groupname='+escape(document.getElementById('group1').value)+'&catename='+escape(document.getElementById('cate1').value)+'&colorname='+escape(document.getElementById('colorid1').value)+'&sizename='+escape(document.getElementById('sizeid1').value)+'&brandname='+escape(document.getElementById('brand1').value)+'&aitemno='+escape(document.getElementById('aitemno').value));if(event.keyCode==13){document.getElementById('gobtn1').focus();}}  else if (event.keyCode==40){document.getElementById('btn1').focus()}" /></td>
     
     <tr>
     <td colspan="6"><div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div></td>
     <td colspan="3" align="right"> <input name="Additembtn" id="Additembtn" type="button" style="cursor:pointer;" onClick="addmultiitem();ColdFusion.Window.hide('searchitem');" value="Add Selected Item"/></td>
     </tr>
  
    </table>
    <div id="ajaxFielditm" name="ajaxFielditm">
    
    <table width="850px">
    <tr>
    <td colspan="100%" align="right">
    
    </td>
    </tr>
    <tr>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <th width="100px"><font style="text-transform:uppercase">ITEM NO</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'><th width="100px">PRODUCT CODE</th></cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <th width="80px">CATEGORY</th>
    <th width="80px">ARTIST</th>
    </cfif>
    <cfif getdisplay.itemsearch_desp eq 'Y'>
    <th width="300px">NAME</th>
    </cfif>
    
     
   <cfif getpin2.h1360 eq 'T'> 
   <cfif getdisplay.itemsearch_ucost eq 'Y'>
   <th width="50px">UCOST</th>
   </cfif>
   <cfif getdisplay.itemsearch_price eq 'Y'>
    <th width="50px">PRICE</th>
    </cfif>
    
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <th width="80px">ACTION</th>
    </cfif>
    </tr>
    <cfloop query="getitem" >
   
    
    <tr id="tr#getitem.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem.itemno)#'));getitemdetail('#URLENCODEDFORMAT(getitem.itemno)#');<!--- document.getElementById('desp2').focus(); --->ColdFusion.Window.hide('searchitem');"</cfif>>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem.itemno#</td>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'><td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem.aitemno#</td></cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem.category#</td>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem.sizeid#</td>
    </cfif>
    <cfif getdisplay.itemsearch_desp eq 'Y'><td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem.desp#</td></cfif>
    <cfif getpin2.h1360 eq 'T'>
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#lsnumberformat(getitem.ucost,',_.__')#</td>
    </cfif>
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#lsnumberformat(getitem.price,',_.__')#</td>
    </cfif>
    
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <td style="font:'Times New Roman', Times, serif; font-size:16px"><input name="btn#getitem.currentrow#" id="btn#getitem.currentrow#" type="button" style="background:none; border:none; cursor:pointer;" onClick="document.getElementById('productfrom').value =unescape(decodeURI('#URLENCODEDFORMAT(getitem.itemno)#'));ajaxFunction(document.getElementById('itemajax'),'/default/maintenance/itemlocationenquireajax.cfm?itemno='+document.getElementById('productfrom').value);<!--- document.getElementById('desp2').focus(); --->ColdFusion.Window.hide('finditem');" value="SELECT" onfocus="document.getElementById('tr#getitem.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('tr#getitem.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getitem.currentrow neq getitem.recordcount>if(event.keyCode==40){document.getElementById('btn#val(getitem.currentrow)+1#').focus()}</cfif> <cfif getitem.currentrow neq 1>if(event.keyCode==38){document.getElementById('btn#val(getitem.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('itemno1').focus()}</cfif> " /></td>
    
    </cfif>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>
<!--- 	<script type="text/javascript">
	getfocus2()
    </script> --->