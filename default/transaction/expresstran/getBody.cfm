<cfsetting showdebugoutput="no">

<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_Discount = getgsetup2.Decl_Discount>

<cfset uuid = url.uuid>
<cfquery datasource="#dts#" name="getlocation">
	select 
	location,
	desp 
	from iclocation 
    where 0=0
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
    <cfelse>
    <cfif Huserloc neq "All_loc">
	and location='#Huserloc#'
	</cfif>
    </cfif>
	order by location;
</cfquery>

<cfquery datasource="#dts#" name="getjob">
	select * from #target_project# where porj='J'
</cfquery>

<cfquery datasource="#dts#" name="getgsetup">
	select * from gsetup
</cfquery>

<cfquery datasource="#dts#" name="getdisplay">
	select * from displaysetup
</cfquery>
<cfoutput>
<table width="100%">
<tr>
<th width="2%">No</th>
<cfif getdisplay.simple_itemno eq 'Y'><th width="15%">Item Code</th></cfif>
<cfif getdisplay.simple_desp eq 'Y'><th width="30%">Description</th></cfif>
<cfif getdisplay.simple_location eq 'Y'><th width="10%" >Location</th></cfif>
<cfif getdisplay.simple_job eq 'Y'><th width="10%" >#getgsetup.ljob#</th></cfif>
<cfif getdisplay.simple_brem1 eq 'Y'><th width="10%" >#getgsetup.brem1#</th></cfif>
<th width="10%" <cfif getdisplay.simple_brand neq 'Y'>style="display:none"</cfif>>Brand</th>
<th width="10%" <cfif getdisplay.simple_group neq 'Y'>style="display:none"</cfif>>#getgsetup.lgroup#</th>
<th width="10%" <cfif getdisplay.simple_category neq 'Y'>style="display:none"</cfif>>#getgsetup.lcategory#</th>
<th width="10%" <cfif getdisplay.simple_model neq 'Y'>style="display:none"</cfif>>#getgsetup.lmodel#</th>
<th width="10%" <cfif getdisplay.simple_rating neq 'Y'>style="display:none"</cfif>>#getgsetup.lrating#</th>
<th width="10%" <cfif getdisplay.simple_sizeid neq 'Y'>style="display:none"</cfif>>#getgsetup.lsize#</th>
<th width="10%" <cfif getdisplay.simple_material neq 'Y'>style="display:none"</cfif>>#getgsetup.lmaterial#</th>
<cfif getdisplay.simple_qty eq 'Y'><th width="10%" >Quantity</th></cfif>
<cfif getdisplay.simple_price eq 'Y'><th width="8%" >Price</th></cfif>

<cfif getdisplay.simple_disc eq 'Y'><th width="8%" >Discount</th></cfif>
<cfif getdisplay.simple_amt eq 'Y'><th width="8%" >Amount</th></cfif>
<th width="10%">Action</th>
</tr>
<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode
<cfif lcase(hcomid) eq "lkabb_i" or lcase(hcomid) eq "lkabp_i" or lcase(hcomid) eq "lkab_i" <!---or lcase(hcomid) eq "lkatlb_i"--->
				or lcase(hcomid) eq "lkatbh_i" or lcase(hcomid) eq "svcmm_i" or lcase(hcomid) eq "svcnvn_i" or lcase(hcomid) eq "svctm_i"
				or lcase(hcomid) eq "svcyr_i" or lcase(hcomid) eq "svcdm_i" or lcase(hcomid) eq "svcbd_i" or lcase(hcomid) eq "21bl_i"
				or lcase(hcomid) eq "21cmw_i" or lcase(hcomid) eq "jvtpy_i" or lcase(hcomid) eq "jvsbw_i" or lcase(hcomid) eq "stbrd_i"
				or lcase(hcomid) eq "stpylb_i" or lcase(hcomid) eq "stfsrg_i" or lcase(hcomid) eq "stfsk_i" or lcase(hcomid) eq "ftmps_i"
				or lcase(hcomid) eq "lkabt_i" or lcase(hcomid) eq "lkatb_i" or lcase(hcomid) eq "lkatl_i" or lcase(hcomid) eq "shell_i"
				or lcase(hcomid) eq "fttk_i" or lcase(hcomid) eq "svcnc_i" or lcase(hcomid) eq "autoserv_i" or lcase(hcomid) eq "3ree_i"><cfelse>
 desc</cfif>
</cfquery>
<cfloop query="getictrantemp">

<cfquery name="getiteminfo" datasource="#dts#">
select sizeid,colorid,brand,category,wos_group,shelf,costcode from icitem where itemno='#getictrantemp.itemno#'
</cfquery>

<tr <cfif (getictrantemp.currentrow mod 2) eq 0>style="background-color:##33FFFF"</cfif> onMouseOut="javascript:this.style.backgroundColor='<cfif (getictrantemp.currentrow mod 2) eq 0>33FFFF</cfif>';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
<td nowrap>#getictrantemp.currentrow#</td>
<cfif getdisplay.simple_itemno eq 'Y'><td nowrap ><a onmouseover="JavaScript:this.style.cursor='hand'" onClick="document.getElementById('itemdesptrancode').value='#getictrantemp.trancode#';ColdFusion.Window.show('itemdesp');">#getictrantemp.itemno#</a></td></cfif>
<cfif getdisplay.simple_desp eq 'Y'><td nowrap ><a onmouseover="JavaScript:this.style.cursor='hand'" onClick="document.getElementById('itemdesptrancode').value='#getictrantemp.trancode#';ColdFusion.Window.show('itemdesp');">#getictrantemp.desp#</a></td></cfif>
<cfif getdisplay.simple_location eq 'Y'><td nowrap>
<!--- <select name="coltypelist#getictrantemp.trancode#" id="coltypelist#getictrantemp.trancode#" onChange="if(this.value != '#getictrantemp.brem1#'){document.getElementById('updatebtn#getictrantemp.trancode#').style.display='block';}else{document.getElementById('updatebtn#getictrantemp.trancode#').style.display='none';}">
<option value="Cash n Carry" <cfif getictrantemp.brem1 eq "Cash n Carry">Selected</cfif>>Cash & Carry</option>
<option value="Cash n Delivery" <cfif getictrantemp.brem1 eq "Cash n Delivery">Selected</cfif>>Cash & Delivery</option> 
</select> ---><!---<input type="text" name="coltypelist#getictrantemp.trancode#" id="coltypelist#getictrantemp.trancode#" value="#getictrantemp.brem1#" onClick="if(this.value=='Collection'){this.value = 'Delivery';updaterow('#getictrantemp.trancode#');} else {this.value = 'Collection';updaterow('#getictrantemp.trancode#');}" readonly="readonly">--->
<select name="coltypelist#getictrantemp.trancode#" id="coltypelist#getictrantemp.trancode#" onChange="updaterow('#getictrantemp.trancode#');">
<option value="">Choose a location</option>
<cfloop query="getlocation">
<option value="#getlocation.location#" <cfif getictrantemp.location eq getlocation.location>selected</cfif>>#getlocation.location#</option>
</cfloop>
</select>
</td></cfif>

<cfif getdisplay.simple_job eq 'Y'><td nowrap>
<select name="joblist#getictrantemp.trancode#" id="joblist#getictrantemp.trancode#" onChange="updaterow('#getictrantemp.trancode#');">
<option value="">Choose a #getgsetup.ljob#</option>
<cfloop query="getjob">
<option value="#getjob.source#" <cfif getictrantemp.job eq getjob.source>selected</cfif>>#getjob.source#</option>
</cfloop>
</select>
</td></cfif>


<cfif getdisplay.simple_brem1 eq 'Y'>
<td>
<cfif lcase(HcomID) eq "hodaka_i" and type eq 'PO'>
<cfquery name="gethodakaso" datasource="#dts#">
select refno from ictran where type='SO' and itemno='#getictrantemp.itemno#' and refno not in (select brem1 from ictran where type='PO' and itemno='#getictrantemp.itemno#')
</cfquery>
<select name="brem1list#getictrantemp.trancode#" id="brem1list#getictrantemp.trancode#" onChange="updaterow('#getictrantemp.trancode#');">
<option value="">Choose an SO NO</option>
<cfloop query="gethodakaso">
<option value="#gethodakaso.refno#">#gethodakaso.refno#</option>
</cfloop>
</select>
<cfelse>
<input type="text" name="brem1list#getictrantemp.trancode#" id="brem1list#getictrantemp.trancode#" value="#getictrantemp.brem1#"  onBlur="updaterow('#getictrantemp.trancode#');" />
</cfif>
</td>
</cfif>
<td width="10%" <cfif getdisplay.simple_brand neq 'Y'>style="display:none"</cfif>>#getiteminfo.brand#</td>
<td width="10%" <cfif getdisplay.simple_group neq 'Y'>style="display:none"</cfif>>#getiteminfo.wos_group#</td>
<td width="10%" <cfif getdisplay.simple_category neq 'Y'>style="display:none"</cfif>>#getiteminfo.category#</td>
<td width="10%" <cfif getdisplay.simple_model neq 'Y'>style="display:none"</cfif>>#getiteminfo.shelf#</td>
<td width="10%" <cfif getdisplay.simple_rating neq 'Y'>style="display:none"</cfif>>#getiteminfo.costcode#</td>
<td width="10%" <cfif getdisplay.simple_sizeid neq 'Y'>style="display:none"</cfif>>#getiteminfo.sizeid#</td>
<td width="10%" <cfif getdisplay.simple_material neq 'Y'>style="display:none"</cfif>>#getiteminfo.colorid#</td>

<cfif getdisplay.simple_qty eq 'Y'><td nowrap align="right" ><input type="text" name="qtylist#getictrantemp.trancode#" id="qtylist#getictrantemp.trancode#" value="#val(getictrantemp.qty_bil)#" size="5"  onBlur="updaterow('#getictrantemp.trancode#');" onKeyup="if(this.value != '#val(getictrantemp.qty_bil)#'){document.getElementById('updatebtn#getictrantemp.trancode#').style.display='block';}else{document.getElementById('updatebtn#getictrantemp.trancode#').style.display='none';}"  ></td></cfif>



<cfif getdisplay.simple_price eq 'Y'><td nowrap align="right"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='#getictrantemp.trancode#';ColdFusion.Window.show('changeprice');getfocus4();">#numberformat(val(getictrantemp.price_bil),stDecl_UPrice)#</a></td></cfif>

<cfif getdisplay.simple_disc eq 'Y'><td nowrap align="right"><input type="text" name="brem4#getictrantemp.trancode#" id="brem4#getictrantemp.trancode#" value="#getictrantemp.brem4#" size="5"  onBlur="updaterow('#getictrantemp.trancode#');" onKeyup="if(this.value != '#getictrantemp.brem4#'){document.getElementById('updatebtn#getictrantemp.trancode#').style.display='block';}else{document.getElementById('updatebtn#getictrantemp.trancode#').style.display='none';}" ></td></cfif>
<cfif getdisplay.simple_amt eq 'Y'><td nowrap align="right" >
#numberformat(val(getictrantemp.amt_bil),',.__')#</td></cfif>
<td nowrap><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are You Sure You Want To Delete?')){deleterow('#getictrantemp.trancode#')}" value="DELETE"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"><!--- &nbsp;&nbsp;<input type="button" name="Updatebtn#getictrantemp.trancode#" id="updatebtn#getictrantemp.trancode#" onClick="updaterow('#getictrantemp.trancode#')" value="UPDATE" style="display:none"/> ---></td>

<td>
<cfif getdisplay.simple_location neq 'Y'>
<input type="hidden" name="coltypelist#getictrantemp.trancode#" id="coltypelist#getictrantemp.trancode#" value="#getictrantemp.location#" />
</cfif>
<cfif getdisplay.simple_job neq 'Y'>
<input type="hidden" name="joblist#getictrantemp.trancode#" id="joblist#getictrantemp.trancode#" value="#getictrantemp.job#" />
</cfif>

<cfif getdisplay.simple_brem1 neq 'Y'>
<input type="hidden" name="brem1list#getictrantemp.trancode#" id="brem1list#getictrantemp.trancode#" value="#getictrantemp.brem1#" />
</cfif>

<cfif getdisplay.simple_qty neq 'Y'>
<input type="hidden" name="qtylist#getictrantemp.trancode#" id="qtylist#getictrantemp.trancode#" value="#val(getictrantemp.qty_bil)#" />
</cfif>
<cfif getdisplay.simple_packing neq 'Y'>
<input type="hidden" name="promotiontype#getictrantemp.trancode#" id="promotiontype#getictrantemp.trancode#" value="#getictrantemp.promotion#" />
</cfif>
<cfif getdisplay.simple_disc neq 'Y'>
<input type="hidden" name="brem4#getictrantemp.trancode#" id="brem4#getictrantemp.trancode#" value="#getictrantemp.brem4#" />
</cfif></td>

</tr>
</cfloop>

</table>
</cfoutput>
