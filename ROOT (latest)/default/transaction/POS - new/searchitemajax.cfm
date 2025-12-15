   <cfquery name="getdisplay" datasource="#dts#">
select * from displaysetup
</cfquery>

	<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfset defaultfontsize = "#getgsetup.fontsize#px">
<cfif dts eq "tcds_i">
<cfset defaultfontsize = "12px">
</cfif>
   
   	<cfif lcase(hcomid) eq "tcds_i">
    
    <cftry>
    
    <cfquery name="getitem1" datasource="#dtssync#">
    Select Servi as itemno, desp,0 as ucost,0 as price,'' as aitemno,'' as wos_group,'' as category,'' as sizeid,'' as colorid,'' as remark1,0 as price2,'' as remark6,'' as remark7,'' as remark8,'' as remark9,'' as remark10,'' as remark11 from icservi WHERE
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
    select itemno,desp,ucost,price,aitemno,wos_group,category,sizeid,colorid,remark1,price2,remark6,remark7,remark8,remark9,remark10,remark11 from icitem WHERE 
    1=1
    <cfif URLDECODE(url.itemno) neq "">
    and (itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    )
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
    and (colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.colorname)#%" />
    or remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.colorname)#%" />)
    </cfif>
    
    <cfif URLDECODE(url.sizename) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    )
    </cfif>
    
    <cfif URLDECODE(url.brandname) neq "">
    and brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.brandname)#%" />
    </cfif>
    <cfif lcase(hcomid) eq 'tcds_i'>
    <cfif URLDECODE(url.aitemno) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    )
    </cfif>
    <cfelse>
    <cfif URLDECODE(url.aitemno) neq "">
    and aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    </cfif>
    </cfif>
     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
	<cfif Huserloc neq "All_loc">
    and itemno in (select itemno from locqdbf where location='#Huserloc#')
    </cfif>
    and (nonstkitem<>'T' or nonstkitem is null)
    </cfif>
    order by
    <cfif lcase(hcomid) eq 'tcds_i'>remark1,sizeid,desp<cfelse>itemno</cfif> limit 200
	</cfquery>
    
    <cfcatch>
    
    <cfquery name="getitem1" datasource="#dts#">
    Select Servi as itemno, desp,0 as ucost,0 as price,'' as aitemno,'' as wos_group,'' as category,'' as sizeid,'' as colorid,'' as remark1,0 as price2,'' as remark6,'' as remark7,'' as remark8,'' as remark9,'' as remark10,'' as remark11 from icservi WHERE
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
    select itemno,desp,ucost,price,aitemno,wos_group,category,sizeid,colorid,remark1,price2,remark6,remark7,remark8,remark9,remark10,remark11 from icitem WHERE 
    1=1
    <cfif URLDECODE(url.itemno) neq "">
    and (itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    )
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
    and (colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.colorname)#%" />
    or remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.colorname)#%" />)
    </cfif>
    
    <cfif URLDECODE(url.sizename) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    )
    </cfif>
    
    <cfif URLDECODE(url.brandname) neq "">
    and brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.brandname)#%" />
    </cfif>
    <cfif lcase(hcomid) eq 'tcds_i'>
    <cfif URLDECODE(url.aitemno) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    )
    </cfif>
    <cfelse>
    <cfif URLDECODE(url.aitemno) neq "">
    and aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    </cfif>
    </cfif>
     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
	<cfif Huserloc neq "All_loc">
    and itemno in (select itemno from locqdbf where location='#Huserloc#')
    </cfif>
    and (nonstkitem<>'T' or nonstkitem is null)
    </cfif>
    order by
    <cfif lcase(hcomid) eq 'tcds_i'>remark1,sizeid,desp<cfelse>itemno</cfif> limit 200
	</cfquery>
    
    </cfcatch>
    </cftry>
    
    <cfelse>
   
    <cfquery name="getitem1" datasource="#dts#">
    Select Servi as itemno, desp,0 as ucost,0 as price,'' as aitemno,'' as wos_group,'' as category,'' as sizeid,'' as colorid,'' as remark1,0 as price2,'' as remark6,'' as remark7,'' as remark8,'' as remark9,'' as remark10,'' as remark11 from icservi WHERE
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
    select itemno,desp,ucost,price,aitemno,wos_group,category,sizeid,colorid,remark1,price2,remark6,remark7,remark8,remark9,remark10,remark11 from icitem WHERE 
    1=1
    <cfif URLDECODE(url.itemno) neq "">
    and (itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    )
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
    and (colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.colorname)#%" />
    or remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.colorname)#%" />)
    </cfif>
    
    <cfif URLDECODE(url.sizename) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.sizename)#%" />
    )
    </cfif>
    
    <cfif URLDECODE(url.brandname) neq "">
    and brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.brandname)#%" />
    </cfif>
    <cfif lcase(hcomid) eq 'tcds_i'>
    <cfif URLDECODE(url.aitemno) neq "">
    and (sizeid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    )
    </cfif>
    <cfelse>
    <cfif URLDECODE(url.aitemno) neq "">
    and aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.aitemno)#%" />
    </cfif>
    </cfif>
     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
	<cfif Huserloc neq "All_loc">
    and itemno in (select itemno from locqdbf where location='#Huserloc#')
    </cfif>
    and (nonstkitem<>'T' or nonstkitem is null)
    </cfif>
    order by
    <cfif lcase(hcomid) eq 'tcds_i'>remark1,sizeid,desp<cfelse>itemno</cfif> limit 200
	</cfquery>
    
    </cfif>
    
	<cfoutput>  
	<cfset reftype= url.reftype>
    <table width="1000px">
    <tr>
    <td colspan="100%" align="right">
    <input name="Additembtn" id="Additembtn" type="button" style="cursor:pointer;" onClick="addmultiitem();ColdFusion.Window.hide('searchitem');" value="Add Selected Item"/>
    </td>
    </tr>
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
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">UCOST</font></th>
    </cfif>
    
    <cfif getpin2.h1360 eq 'T'>
    <!---
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <th width="50px">UCOST</th>
    </cfif>--->
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <th width="50px">PRICE</th>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">PROMO PRICE</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_qty eq 'Y'>
    <cfif lcase(hcomid) eq "tcds_i">
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">GWC</font></strong></th>
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">RF</font></strong></th>
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">PP</font></strong></th>
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">MBS</font></strong></th>
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">STK</font></strong></th>
    <th align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">WH</font></strong></th>
    <cfelse>
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">QTY ON HAND</font></th>
    </cfif>
    </cfif>
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <th width="80px">ACTION</th>
    </cfif>
    </tr>
    <cfloop query="getitem1" >
    <cfif getpin2.h1360 eq 'T'>
    <cfquery name="getitembalance1" datasource="#dts#">
    select 
	a.itemno,
	ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance
	
	from icitem as a
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno='#getitem1.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
		group by itemno
	) as b on a.itemno=b.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
		and itemno='#getitem1.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
		and toinv='' 
		group by itemno
	) as c on a.itemno=c.itemno
	
	where a.itemno='#getitem1.itemno#' 
    </cfquery>
    </cfif>
    <tr id="tr#getitem1.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));getitemdetail2('#URLENCODEDFORMAT(getitem1.itemno)#');<!--- document.getElementById('desp2').focus(); --->ColdFusion.Window.hide('searchitem');"</cfif>>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px" nowrap>#getitem1.itemno#</td>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.aitemno#</td>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.category#</td>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.sizeid#</td>
    </cfif>
    <cfif getdisplay.itemsearch_desp eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitem1.desp#</td>
    </cfif>
    
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#lsnumberformat(getitem1.ucost,',_.__')#</td>
    </cfif>
    
    <cfif getpin2.h1360 eq 'T'>
    <!---
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:16px">#lsnumberformat(getitem1.ucost,',_.__')#</td>
    </cfif>--->
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#lsnumberformat(getitem1.price,',_.__')#</td>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#lsnumberformat(getitem1.price2,',_.__')#</td>
    </cfif>
    <cfif getdisplay.itemsearch_qty eq 'Y'>
    <cfif lcase(hcomid) eq "tcds_i">
    <td align="center">#remark6#</td>
    <td align="center">#remark7#</td>
    <td align="center">#remark8#</td>
    <td align="center">#remark9#</td>
    <td align="center">#remark10#</td>
    <td align="center">#remark11#</td>
    <cfelse>
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px">#getitembalance1.balance#</td>
    </cfif>
    </cfif>
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px"><input name="btn#getitem1.currentrow#" id="btn#getitem1.currentrow#" type="button" style="background:none; border:none; cursor:pointer;"  onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));getitemdetail2('#URLENCODEDFORMAT(getitem1.itemno)#');<!--- document.getElementById('<cfif lcase(hcomid) eq "hairo_i">expressservicelist<cfelse>desp2</cfif>').focus(); --->document.getElementById('expressservicelist').focus();ColdFusion.Window.hide('searchitem');" value="SELECT" onfocus="document.getElementById('tr#getitem1.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('tr#getitem1.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getitem1.currentrow neq getitem1.recordcount>if(event.keyCode==40){document.getElementById('btn#val(getitem1.currentrow)+1#').focus()}</cfif> <cfif getitem1.currentrow neq 1>if(event.keyCode==38){document.getElementById('btn#val(getitem1.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('itemno1').focus()}</cfif>" /></td>
    <!---<td style="font:'Times New Roman', Times, serif; font-size:#getgsetup.fontsize#px"><input name="additem_#getitem1.currentrow#" id="additem_#getitem1.currentrow#" type="checkbox" value="#getitem1.itemno#" onclick="
    for (m=1;m<=200;m=m+1)
	{
	if (document.getElementById('btn'+m) == null)
	{
	}
	else
	{	
	document.getElementById('btn'+m).style.visibility='hidden';
	}
	}"/></td>--->
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><input name="additem_#getitem1.currentrow#" id="additem_#getitem1.currentrow#" type="checkbox" value="#getitem1.itemno#" onclick="itemcheckbox(this);"/></td>
    </cfif>
    </tr>
    </cfloop>
    </table>
    </div>
    </cfoutput>