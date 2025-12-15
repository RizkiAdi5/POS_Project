   <cfquery name="getdisplay" datasource="#dts#">
select * from displaysetup
</cfquery>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
   
    <cfquery name="getitem1" datasource="#dts#">
    Select Servi as itemno, desp,0 as ucost,0 as price,'' as aitemno,'' as category,'' as sizeid,'' as remark1 from icservi WHERE
    1=1 
    <cfif URLDECODE(url.itemno) neq "">
    and Servi like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" />
    </cfif>
    <cfif URLDECODE(url.itemname) neq "">
    and desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemname)#%" />
    </cfif>
    <cfif URLDECODE(url.leftitemname) neq "">
    and desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.leftitemname)#%" />
    </cfif>
    union all
    select itemno,desp,ucost,price,aitemno,category,sizeid,remark1 from icitem WHERE 
    1=1
    <cfif URLDECODE(url.itemno) neq "">
    and itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    </cfif>
    <cfif URLDECODE(url.itemname) neq "">
    and desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemname)#%" /> 
    </cfif>
    <cfif URLDECODE(url.leftitemname) neq "">
    and desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.leftitemname)#%" />
    </cfif>
    <cfif URLDECODE(url.groupname) neq "">
    and wos_group like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.groupname)#%" />
    </cfif>
    <cfif URLDECODE(url.catename) neq "">
    and category like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.catename)#%" />
    </cfif>
    
    <cfif URLDECODE(url.colorname) neq "">
    and colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.colorname)#%" />
    </cfif>
    
    <cfif URLDECODE(url.sizename) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    )
    </cfif>
    
    <cfif URLDECODE(url.brandname) neq "">
    and brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.brandname)#%" />
    </cfif>
    <cfif URLDECODE(url.aitemno) neq "">
    and aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    </cfif>
     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
	<cfif Huserloc neq "All_loc">
    and itemno in (select itemno from locqdbf where location='#Huserloc#')
    </cfif>
    and (nonstkitem<>'T' or nonstkitem is null)
    </cfif>
    
    order by <cfif lcase(hcomid) eq 'tcds_i'>remark1,sizeid,desp<cfelse>itemno</cfif> limit 200
	</cfquery>
    
	<cfoutput>  
	<cfset reftype= url.reftype>
    <table width="850px">
    
    <tr>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <th width="100px"><font style="text-transform:uppercase">ITEM NO</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'>
    <th width="100px"><font style="text-transform:uppercase">PRODUCT CODE</font></th>
    </cfif>
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
    <cfloop query="getitem1" >
  
    <tr id="tr#getitem1.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));getitemdetail('#URLENCODEDFORMAT(getitem1.itemno)#');<!--- document.getElementById('desp2').focus(); --->ColdFusion.Window.hide('searchitem');"</cfif>>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem1.itemno#</td>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem1.aitemno#</td>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.category#</td>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.sizeid#</td>
    </cfif>
    <cfif getdisplay.itemsearch_desp eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#getitem1.desp#</td>
    </cfif>
    <cfif getpin2.h1360 eq 'T'>
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#lsnumberformat(getitem1.ucost,',_.__')#</td>
    </cfif>
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#lsnumberformat(getitem1.price,',_.__')#</td>
    </cfif>
    
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <td style="font:'Times New Roman', Times, serif; font-size:16px"><input name="btn#getitem1.currentrow#" id="btn#getitem1.currentrow#" type="button" style="background:none; border:none; cursor:pointer;"  onClick="document.getElementById('productfrom').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));ajaxFunction(document.getElementById('itemajax'),'/default/maintenance/itemlocationenquireajax.cfm?itemno='+document.getElementById('productfrom').value);<!--- document.getElementById('<cfif lcase(hcomid) eq "hairo_i">expressservicelist<cfelse>desp2</cfif>').focus(); --->ColdFusion.Window.hide('finditem');" value="SELECT" onfocus="document.getElementById('tr#getitem1.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('tr#getitem1.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getitem1.currentrow neq getitem1.recordcount>if(event.keyCode==40){document.getElementById('btn#val(getitem1.currentrow)+1#').focus()}</cfif> <cfif getitem1.currentrow neq 1>if(event.keyCode==38){document.getElementById('btn#val(getitem1.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('itemno1').focus()}</cfif>" /></td>
    
    </cfif>
    </tr>
    </cfloop>
    </table>
    </div>
    </cfoutput>