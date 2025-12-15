<cfset defaultfontsize = "16px">
<cfif dts eq "tcds_i">
<cfset defaultfontsize = "12px">
</cfif>
<cfsetting showdebugoutput="no">   
   <cfquery name="getdisplay" datasource="#dts#">
select * from displaysetup
</cfquery>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
   
    <cfquery name="getitem1" datasource="#dts#">
    Select Servi as itemno, desp,0 as ucost,0 as price,'' as aitemno,'' as wos_group,'' as category,'' as sizeid,'' as colorid,0 as price2 from icservi WHERE
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
    select itemno,desp,ucost,price,aitemno,wos_group,category,sizeid,colorid,price2 from icitem WHERE 
    1=1
    <cfif URLDECODE(url.itemno) neq "">
    and itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
    or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.itemno)#%" /> 
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
    
    order by itemno limit 200
	</cfquery>
    
    <cfquery name="getallbal" datasource="#dts#">
     select 
	a.itemno,
	ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance
	
	from (SELECT itemno,qtybf FROM icitem WHERE itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getitem1.itemno)#" list="yes" separator=",">)) as a
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getitem1.itemno)#" list="yes" separator=",">)
		and fperiod<>'99'
		and (void = '' or void is null)
		group by itemno
	) as b on a.itemno=b.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
		and itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getitem1.itemno)#" list="yes" separator=",">)
		and fperiod<>'99'
		and (void = '' or void is null)
		and toinv='' 
		group by itemno
	) as c on a.itemno=c.itemno
    </cfquery>
    
	<cfoutput>  
	<cfset reftype= url.reftype>
    <table width="650px">
    <tr>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <th width="75px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">ITEM NO</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'>
    <th width="75px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">PRODUCT CODE</font></th>
    </cfif>
    
    <cfif getdisplay.itemsearch_group eq 'Y'>
    <th width="200px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">#getgsetup.lgroup#</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_cate eq 'Y'>
    <th width="200px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">#getgsetup.lcategory#</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_sizeid eq 'Y'>
    <th width="200px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">#getgsetup.lsize#</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_colorid eq 'Y'>
    <th width="200px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">#getgsetup.lmaterial#</font></th>
    </cfif>
    
    <cfif getdisplay.itemsearch_desp eq 'Y'>
    <th width="200px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">NAME</font></th>
    </cfif>
    <cfif getpin2.h1360 eq 'T'>
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">UCOST</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">PRICE</font></th>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">PROMO PRICE</font></th>
    </cfif>
    <cfif getdisplay.itemsearch_qty eq 'Y'>
    <th width="50px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">QTY ON HAND</font></th>
    </cfif>
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <th width="80px"><font style="text-transform:uppercase; font-size:#defaultfontsize#">ACTION</font></th>
    </cfif>
    </tr>
    <cfloop query="getitem1" >
    <cfif getpin2.h1360 eq 'T'>
    <cfquery name="getitembalance1" dbtype="query">
    SELECT balance FROM getallbal WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem1.itemno#">
    </cfquery>
    </cfif>
    <tr id="tr#getitem1.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));getitemdetail('#URLENCODEDFORMAT(getitem1.itemno)#');<!--- document.getElementById('desp2').focus(); --->ColdFusion.Window.hide('searchitem');"</cfif>>
    <cfif getdisplay.itemsearch_itemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.itemno#</td>
    </cfif>
    <cfif getdisplay.itemsearch_aitemno eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.aitemno#</td>
    </cfif>
    
    <cfif getdisplay.itemsearch_group eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.wos_group#</td>
    </cfif>
    <cfif getdisplay.itemsearch_cate eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.category#</td>
    </cfif>
    <cfif getdisplay.itemsearch_sizeid eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.sizeid#</td>
    </cfif>
    <cfif getdisplay.itemsearch_colorid eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.colorid#</td>
    </cfif>
    
    <cfif getdisplay.itemsearch_desp eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitem1.desp#</td>
    </cfif>
    <cfif getpin2.h1360 eq 'T'>
    <cfif getdisplay.itemsearch_ucost eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#lsnumberformat(getitem1.ucost,',_.__')#</td>
    </cfif>
    <cfif getdisplay.itemsearch_price eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#lsnumberformat(getitem1.price,',_.__')#</td>
    </cfif>
    <cfif lcase(hcomid) eq "tcds_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#lsnumberformat(getitem1.price2,',_.__')#</td>
    </cfif>
    <cfif getdisplay.itemsearch_qty eq 'Y'>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">#getitembalance1.balance#</td>
    </cfif>
    </cfif>
    <cfif lcase(hcomid) neq "acht_i">
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><input name="btn#getitem1.currentrow#" id="btn#getitem1.currentrow#" type="button" style="background:none; border:none; cursor:pointer;"  onClick="document.getElementById('expressservicelist').value = unescape(decodeURI('#URLENCODEDFORMAT(getitem1.itemno)#'));getitemdetail('#URLENCODEDFORMAT(getitem1.itemno)#');<!--- document.getElementById('<cfif lcase(hcomid) eq "hairo_i">expressservicelist<cfelse>desp2</cfif>').focus(); --->ColdFusion.Window.hide('searchitem');" value="SELECT" onfocus="document.getElementById('tr#getitem1.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('tr#getitem1.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getitem1.currentrow neq getitem1.recordcount>if(event.keyCode==40){document.getElementById('btn#val(getitem1.currentrow)+1#').focus()}</cfif> <cfif getitem1.currentrow neq 1>if(event.keyCode==38){document.getElementById('btn#val(getitem1.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('itemno1').focus()}</cfif>" /></td>
    <td style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><input name="additem_#getitem1.currentrow#" id="additem_#getitem1.currentrow#" type="checkbox" value="#getitem1.itemno#" onclick="itemcheckbox(this);"/></td>
    </cfif>
    </tr>
    </cfloop>
    </table>
    </div>
    </cfoutput>