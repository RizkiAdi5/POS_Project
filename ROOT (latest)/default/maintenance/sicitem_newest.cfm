<html>
<head>
<title>Search Items</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getdealermenu" datasource="#dts#">
    select * from dealer_menu
</cfquery>

<cfquery name="getdisplaysetup" datasource="#dts#">
    select * from displaysetup
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select concat(',.',(repeat('_',decl_uprice))) as decl_uprice 
	from gsetup2
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery name="getrecordcount" datasource="#dts#">
	select count(itemno) as totalrecord 
	from icitem 
    <cfif Hitemgroup neq ''>
            where wos_group='#Hitemgroup#'
            </cfif>
	order by wos_date
</cfquery>
<cfif getdisplaysetup.item_showonhand eq 'Y'>
<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>
</cfif>
<body>
<cfoutput>
<cfif getrecordcount.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage or form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="sicitem_newest.cfm" method="post" target="_self">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif isdefined("url.start")>
			<cfset start = url.start>
		</cfif>
		
		<cfif isdefined("form.skeypage")>
			<cfset start = form.skeypage * 20 + 1 - 20>
			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>

		<cfset prevTwenty = start -20>
		<cfset nextTwenty = start +20>
		<cfset page = round(nextTwenty/20)>
		
		<cfquery datasource='#dts#' name="getjob">
			select a.*,m.desp as mdesp
			from icitem a
			left join iccolorid m on (a.colorid=m.colorid)
            <cfif Hitemgroup neq ''>
            where a.wos_group='#Hitemgroup#'
            </cfif>
			order by <cfif getdealermenu.productSortBy neq "">a.#getdealermenu.productSortBy#<cfelse>a.itemno</cfif>
			limit #start-1#,20;
		</cfquery>

		<cfif start neq 1>
			|| <a target="_self" href="sicitem_newest.cfm?start=#prevTwenty#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_newest.cfm?start=#nextTwenty#">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data" width="600px">

      		<tr> 
				<th>No.</th>
                <cfif getdisplaysetup.item_itemno eq 'Y'>
        		<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>#getgsetup.litemno#</cfif></th>
                </cfif>
                <cfif getdisplaysetup.dis_item eq 'Y'>
        		<th>Dis</th>
                </cfif>
                <cfif lcase(hcomid) eq "poria_i">
                <th>Barcode</th>
                </cfif>
                <cfif getdisplaysetup.item_aitemno eq 'Y'>
                <th>#getgsetup.laitemno#</th>
                </cfif>
                <cfif getdisplaysetup.item_desp eq 'Y'>
        		<th><cfif lcase(HcomID) eq "asaiki_i">Supplier Part Number<cfelse><cfoutput>#getgsetup.ldescription#</cfoutput></cfif></th>
                </cfif>
                <cfif getdisplaysetup.item_comment eq 'Y'>
        		<th>Comment</th>
                </cfif>
                 <cfif getdisplaysetup.item_supp eq 'Y'>
        		<th>Supplier</th>
                </cfif>
                <cfif getdisplaysetup.item_brand eq 'Y'>
        		<th>#getgsetup.lbrand#</th>
                </cfif>
                <cfif getdisplaysetup.item_category eq 'Y'>
        		<th>#getgsetup.lcategory#</th>
                </cfif>
                <cfif getdisplaysetup.item_sizeid eq 'Y'>
        		<th>#getgsetup.lsize#</th>
                </cfif>
                <cfif getdisplaysetup.item_showonhand eq 'Y'>
        		<th>On Hand</th>
                </cfif>
                <cfif getdisplaysetup.item_packing eq 'Y'>
        		<th>Packing</th>
                </cfif>
                <cfif getdisplaysetup.item_rating eq 'Y'>
				<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
					<th>Stock Bal</th>
				<cfelse>
        			<th>#getgsetup.lrating#</th>
				</cfif>
                </cfif>
               
                <cfif getdisplaysetup.item_group eq 'Y'>
        		<th>#getgsetup.lgroup#</th>
                </cfif> 
				<cfif getdisplaysetup.item_material eq 'Y'>
        		<th>#getgsetup.lmaterial#</th>
                </cfif>
                <cfif getdisplaysetup.item_model eq 'Y'>
        		<th>#getgsetup.lmodel#</th>
                </cfif>
               

                <cfif getdisplaysetup.item_unit eq 'Y'>
                <th>Unit</th>
                </cfif>
                <cfif getdisplaysetup.item_price eq 'Y'>
        		<th><cfif lcase(hcomid) eq "ultrexauto_i">Asking Price<cfelse>Price</cfif></th>
                </cfif>
                
                <cfif getdisplaysetup.item_cost eq 'Y'>
                <cfif getpin2.h1360 eq 'T'>
                <th>UCost</th>
                </cfif>
                </cfif>
				 <cfif getdisplaysetup.item_price2 eq 'Y'>
        			<th>Price 2</th>
				</cfif>
               <cfif getdisplaysetup.foreign_currency eq 'Y'>
                <th>F.Currency</th>
                </cfif>
                <cfif getdisplaysetup.foreign_unit eq 'Y'>
                <th>F.Unit Cost</th>
                </cfif>
                <cfif getdisplaysetup.foreign_selling eq 'Y'>
                <th>F.Selling Price</th>
                </cfif>
                <cfif getdisplaysetup.item_qtybf eq 'Y'>
        			<th>Qty BF</th>
				</cfif>
        		<cfif getpin2.h1311 eq 'T'>
					<th>Action</th>
				</cfif>
                
      		</tr>

			<cfloop query="getjob"> 
           
        		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif getpin2.h1311 eq 'T'>ondblclick="javascript:window.parent.location.href('icitem2.cfm?type=Edit&itemno=#urlencodedformat(getjob.itemno)#');"</cfif>>
					<td nowrap>#getjob.currentrow#</td>
                    <cfif getdisplaysetup.item_itemno eq 'Y'>
          			<td nowrap>#getjob.itemno#</td>
                    </cfif>
                    <cfif getdisplaysetup.dis_item eq 'Y'>
          			<td nowrap>#getjob.nonstkitem#</td>
                    </cfif>
                    <cfif lcase(hcomid) eq "poria_i">
                    <td nowrap>#getjob.barcode#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_aitemno eq 'Y'>
                    <td nowrap>#getjob.aitemno#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_desp eq 'Y'>
          			<td nowrap>#getjob.desp#<br>#getjob.despa#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_comment eq 'Y'>
          			<td nowrap>#tostring(getjob.comment)#</td>
                    </cfif>
                     <cfif getdisplaysetup.item_supp eq 'Y'>
                     <cfquery name="getsuppname" datasource="#dts#">
                     select name from #target_apvend# where custno='#getjob.supp#'
                     </cfquery>
          			<td nowrap>#getjob.supp# - #getsuppname.name#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_brand eq 'Y'>
          			<td nowrap>#getjob.brand#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_category eq 'Y'>
          			<td nowrap>#getjob.category#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_sizeid eq 'Y'>
          			<td nowrap>#getjob.sizeid#</td>
                    </cfif>
                     <cfif getdisplaysetup.item_showonhand eq 'Y'>
                      <cfquery name="getitembalance" datasource="#dts#">
    select 
	a.itemno,
	ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance
	
	from icitem as a
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno='#getjob.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
        and (linecode='' or linecode is null)
		group by itemno
	) as b on a.itemno=b.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where (type in ('DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) or 
				(type='INV' and (dono = "" or dono is null or dono not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">))))
		and itemno='#getjob.itemno#' 
		and fperiod<>'99'
		and (void = '' or void is null)
        and (linecode='' or linecode is null)
		group by itemno
	) as c on a.itemno=c.itemno
    
	
	where a.itemno='#getjob.itemno#' 
    </cfquery>
    
          			<td nowrap><a href="/default/report-stock/stockcard3.cfm?itemno=#getjob.itemno#&itembal=#getjob.qtybf#&pf=&pt=&cf=&ct=&pef=&pet=&gpf=&gpt=&df=&dt=&sf=&st=&thislastaccdate=&dodate=Y"><cfif getjob.itemtype neq "SV">#getitembalance.balance#</cfif></a></td></div>
                    </cfif>
                    <cfif getdisplaysetup.item_packing eq 'Y'>
                    <td nowrap>#getjob.packing#</td>
                    </cfif> 
                    <cfif getdisplaysetup.item_rating eq 'Y'>
					<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
						<cfset stkbal=val(getjob.qtybf)>
						<cfloop from="11" to="28" index="i">
							<cfset stkbal=stkbal+val(getjob["qin#i#"][getjob.currentrow])-val(getjob["qout#i#"][getjob.currentrow])>
						</cfloop>
						<td nowrap>#stkbal#</td>
					<cfelse>
          				<td nowrap>#getjob.costcode#</td>
					</cfif>
                    </cfif>
                    
                    <cfif getdisplaysetup.item_group eq 'Y'>
          			<td nowrap>#getjob.wos_group#</td>
                    </cfif>
                    <cfif getdisplaysetup.item_material eq 'Y'>
					<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
						<td nowrap>#getjob.mdesp#</td>
					<cfelse>
          				<td nowrap>#getjob.colorid#</td>
					</cfif>
                    </cfif>
                    <cfif getdisplaysetup.item_model eq 'Y'>
          			<td nowrap>#getjob.shelf#</td>
                    </cfif>
                    
                    <cfif getdisplaysetup.item_unit eq 'Y'>
                    <td nowrap><div align="right">#getjob.unit#</div></td>
                    </cfif>
                    <cfif getdisplaysetup.item_price eq 'Y'>
          			<td nowrap><div align="right">#NumberFormat(getjob.Price,getgsetup2.decl_uprice)#</div></td>
                    </cfif>
                    
					<cfif getdisplaysetup.item_price2 eq 'Y'>
	        			<td nowrap><div align="right">#NumberFormat(getjob.Price2,getgsetup2.decl_uprice)#</div></td>				
					</cfif>
                    <cfif getdisplaysetup.item_cost eq 'Y'>
                    <cfif getpin2.h1360 eq 'T'>
                    <td nowrap><div align="right">#NumberFormat(getjob.UCOST,getgsetup2.decl_uprice)#</div></td>
                    </cfif>
                    </cfif>
                  <cfif getdisplaysetup.foreign_currency eq 'Y'>
                    <td nowrap><div align="center">#getjob.fcurrcode#</div></td>                    </cfif>

<cfif getdisplaysetup.foreign_unit eq 'Y'>
                    <td nowrap><div align="right">#NumberFormat(getjob.fucost,getgsetup2.decl_uprice)#</div></td>
                    </cfif>
                    <cfif getdisplaysetup.foreign_selling eq 'Y'>
                    <td nowrap><div align="right">#NumberFormat(getjob.fprice,getgsetup2.decl_uprice)#</div></td>
                    </cfif>
                    
                    <cfif getdisplaysetup.item_qtybf eq 'Y'>
                    <td nowrap>#NumberFormat(getjob.qtybf,getgsetup2.decl_uprice)#</td>
                    </cfif>
          			
						<td nowrap><div align="center">
                        <cfif getpin2.h1311 eq 'T'>
							<a href="icitem2.cfm?type=Delete&itemno=#urlencodedformat(getjob.itemno)#" target="_parent"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              				<a href="icitem2.cfm?type=Edit&itemno=#urlencodedformat(getjob.itemno)#" target="_parent"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                        </cfif>
                        <cfif getpin2.h1310 eq 'T'>
                            <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyitem.cfm?itemno=#urlencodedformat(itemno)#');">Copy</a></div>
                        </cfif>
						</td>
        		</tr>

      		</cfloop> 
    	</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			|| <a target="_self" href="sicitem_newest.cfm?start=#prevTwenty#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_newest.cfm?start=#nextTwenty#">Next</a> ||
		</cfif>
		
		Page #page# Of #noOfPage#
		</div>
	</cfform>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>
</cfoutput>
</body>
</html>