<cfif url.type1 eq "Add">
	<cfif url.multilocation eq "Y" and service eq "">
		<cfquery name="geticlocation" datasource="#dts#">
			select location from iclocation
			order by location
		</cfquery>
		<cfset locationlist = valuelist(geticlocation.location,";")>
		<cfset qtylist = "">
		<cfloop from="1" to="#geticlocation.recordcount#" index="x">
			<cfif x eq 1>
				<cfset qtylist = "0">
				<cfset oldqtylist = "0">
				<cfset batchlist = " ">
                <cfset milcertlist = " ">
                <cfset importpermitlist = " ">
				<cfset oldbatchlist = " ">
				<cfset mc1billist = " ">
				<cfset mc2billist = " ">
				<cfset sodatelist = " ">
				<cfset dodatelist = " ">
				<cfset expdatelist = " ">
				<cfset defectivelist = " ">
			<cfelse>
				<cfset qtylist = qtylist&";0">
				<cfset oldqtylist = oldqtylist&";0">
				<cfset batchlist = batchlist&"; ">
				<cfset oldbatchlist = oldbatchlist&"; ">
				<cfset mc1billist = mc1billist&"; ">
				<cfset mc2billist = mc2billist&"; ">
				<cfset sodatelist = sodatelist&"; ">
				<cfset dodatelist = dodatelist&"; ">
				<cfset expdatelist = expdatelist&"; ">
                <cfset milcertlist = milcertlist&"; ">
                <cfset importpermitlist = importpermitlist&"; ">
				<cfset defectivelist = defectivelist&"; ">
			</cfif>
		</cfloop>
	</cfif>
    <cfquery name="getartran" datasource="#dts#">
		select 
		* 
		from artran 
		where type='#tran#'
		and refno='#nexttranno#'; 
	</cfquery>
	<cfset Brem1 = "">
	<cfset Brem2 = "">
	<cfset Brem3 = "">
	<cfset Brem4 = "">
	<cfset Brem5 = "">	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
	<cfset Brem6 = "">	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
    <cfset Brem7 = "">	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
	<cfset Brem8 = "">	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
    <cfset Brem9 = "">
    <cfset it_cos = "">
	<cfset xsv_part = "">
	<cfset sercost = 0>
	<cfset taxpec1 = 0>
    <cfset taxamt_bil=0>	<!--- ADD ON 30-07-2009 --->
	<cfset gltradac = "">
	<cfset amt = 0>		<!--- ADD ON 090608, SHOW THE PRODUCT'S AMOUNT IN THE BODY PART (FORM) --->
    <cfset foc = "">
	<cfset packing = "">
	<cfset shelf = "">	<!--- Add On 090908 --->
	<!--- ADD ON 260908, FOR 2ND UNIT --->
	<cfset factor1 = 1>
	<cfset factor2 = 1>
	<cfset nodisplay = "">		<!--- ADD ON 01-12-2008, FOR NOT DISPAY ITEM IN BILL --->
	<cfset title = "">			<!--- ADD ON 25-02-2009, FOR ITEM TITLE --->
	<cfset titledesp="">
    <cfset ictranfilename="">		<!--- ADD ON 26-02-2009, FOR ITEM TITLE --->
	<cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">	<!--- ADD ON 21-04-2009 --->
		<cfset titledespa="">
	</cfif>
    <cfif tran eq "INV" and getGeneralInfo.asvoucher eq "Y">
    <cfset asvoucher = "N">
    <cfquery name="getlastvoucherno" datasource="#dts#">
    select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.custno#">
    </cfquery>
    <cfif getlastvoucherno.voucherno neq "">
    <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
    <cfset voucherno = newvoucherno>
    <cfelse>
    <cfset voucherno = right(getartran.custno,3)&"000001">
	</cfif>
    
	</cfif>
	<cfset supp="">		<!--- ADD ON 24-05-2009 --->
	
	<!--- ADD ON 05-06-2009 --->
	<cfset qty1=0>
	<cfset qty2=0>
	<cfset qty3=0>
	<cfset qty4=0>
	<cfset qty5=0>
	<cfset qty6=0>
	<cfset qty7=0>
	<cfset wpformula="">
	<cfset wqformula="">
    <cfset xnote_a="">
	<!--- ADD ON 10-12-2009 --->
	<cfset xsource="">
	<cfset xjob="">
    
    <cfif service neq "" and(lcase(hcomid) eq "weldasia_i" or lcase(hcomid) eq "weldasiatax_i" or lcase(hcomid) eq "weldasiaasct_i") >
    <cfset getartran.note=getGeneralInfo.df_salestaxzero>
    </cfif>
    
	
    
	<!--- ADD ON 10-12-2009 --->
	<cfif getGeneralInfo.projectbybill eq "1">
		<cfset xsource=getartran.source>
		<cfset xjob=getartran.job>
    <cfelseif getGeneralInfo.jobbyitem eq "Y">
        <cfset xsource=getartran.source>
	<cfelseif getGeneralInfo.remainloc eq "Y">
    	<cfquery name="getlastsource" datasource="#dts#">
        SELECT source,job FROM ictran WHERE type='#tran#'
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">
        order by trancode desc limit 1
        </cfquery>
        <cfif getlastsource.recordcount neq "">
        <cfset xsource = getlastsource.source>
		<cfset xjob = getlastsource.job>
		</cfif>
	</cfif>
    
    
	
    <cfquery name="selected_tax" datasource="#dts#">
        SELECT * FROM #target_taxtable#
        WHERE
        <cfif getartran.note neq "">
            code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.note#">
        <cfelse>
            code=code
        </cfif>
        <cfif lcase(hcomid) eq "iaf_i">
            AND tax_type in ('T',
            <cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
                'PT'
            <cfelse>
                'ST'
            </cfif>
            )
        </cfif>
        limit 1
    </cfquery>
    <cfif selected_tax.recordcount neq 0>
        <cfset selected_taxrate = selected_tax.rate1 * 100>
        <cfset taxpec1 = selected_taxrate>
    <cfelse>
        <cfset taxpec1=0>
    </cfif>
    
    <cfset xnote_a=getartran.note>

	<!--- <cfquery name="getpricehis" datasource="#dts#">
		select 
		wos_date,
		price,
		dispec1,
		dispec2,
		dispec3,
		grade 
		from ictran 
		where itemno='#itemno#' 
		and custno='#getartran.custno#' 
		order by wos_date desc limit 3;
	</cfquery> --->
    <cfif getGeneralInfo.histpriceinv eq 'Y'>
    <cfif tran eq 'PO' or tran eq 'RC' or tran eq 'PR'>
    <cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,grade,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.custno#"> 
        and type = 'RC'
		order by wos_date desc limit 5;
	</cfquery>
    <cfelse>
    <cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,grade,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.custno#"> 
        and type = 'INV'
		order by wos_date desc limit 5;
	</cfquery>
    </cfif>
    <cfelse>
	<cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,grade,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.custno#"> 
		order by wos_date desc limit 5;
	</cfquery>
    </cfif>

	<!--- <cfquery name="getitembal" datasource="#dts#">
		select 
		desp,
		despa,
		ucost,
		price,
		qtybf,
		minimum,
		unit,
		graded
		<cfif lcase(hcomid) eq "ge_i" or lcase(hcomid) eq "gecn_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "gwa_i" or lcase(hcomid) eq "gwachina_i" or lcase(hcomid) eq "saehan_i">
		,aitemno as productcode
		</cfif> 
		<cfif lcase(hcomid) eq "avent_i">
		,packing,remark1 as uom2, remark2 as handle, remark3 as printed, colorid as materialid
		</cfif>
		<cfif lcase(hcomid) eq "anglo_i">
		,shelf as cod_model,remark1 as cod_color,colorid as cod_material,sizeid
		</cfif>
		from icitem where itemno='#itemno#';
	</cfquery> --->
	<cfquery name="getitembal" datasource="#dts#">
		select desp,despa,comment,ucost,price,price2,price3,price4,qtybf,minimum,fcurrcode,fucost,fprice,
		unit,graded,remark1,wpformula,wqformula,taxcode
		<cfif lcase(hcomid) eq "ge_i" or lcase(hcomid) eq "gecn_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "gwa_i" or lcase(hcomid) eq "gwachina_i" or lcase(hcomid) eq "saehan_i">
		,aitemno as productcode
		<cfelseif lcase(hcomid) eq "avent_i">
		,packing,remark1 as uom2, remark2 as handle, remark3 as printed, colorid as materialid
		<cfelseif lcase(hcomid) eq "anglo_i">
		,shelf as cod_model,remark1 as cod_color,colorid as cod_material,sizeid
		</cfif> 
		from icitem where itemno='#itemno#'
	</cfquery>
    
    <cfif getGeneralInfo.wpitemtax eq "1" and tran neq 'RC' and tran neq 'PO' and tran neq 'PR' and getitembal.taxcode neq "">
    <cfset xnote_a = getitembal.taxcode>
    <cfquery name="selected_taxnew" datasource="#dts#">
        SELECT * FROM #target_taxtable#
        WHERE
            code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitembal.taxcode#">
    </cfquery>
    <cfif selected_taxnew.recordcount neq 0>
        <cfset selected_taxrate = selected_taxnew.rate1 * 100>
        <cfset taxpec1 = selected_taxrate>
    </cfif>
    
	</cfif>

	<cfset itemno = itemno>

	<cfif service neq "">
	  	<cfif isdefined("form.service")>
			<cfif form.service eq "Unnamed">
				<cfset itemno = "">
			<cfelse>
				<cfset itemno = form.service>
			</cfif>
	  	<cfelse>
			<cfset itemno = url.service>
	  	</cfif>

		<cfset isservice = 1>

		<cfquery name="getitembal" datasource="#dts#">
			select 
			* 
			from icservi 
			where servi='#itemno#';
	  	</cfquery>

		<cfset price = getitembal.serprice>
	  	<cfset dispec1 = 0>
	  	<cfset dispec2 = 0>
	  	<cfset dispec3 = 0>
	  	<cfset desp = getitembal.desp>
	  	<cfset despa = getitembal.despa>
        <cfset sercost = getitembal.sercost>
	  	<cfset remark1 = "">	<!--- ADD ON 10-02-2009 --->
	<cfelse>
		<cfif tran eq "RC" or tran eq "PO" or tran eq "PR">
			<cfquery name="getrecommendprice" datasource="#dts#">
				select 
				* 
				from icl3p 
				where itemno='#itemno#' 
				and custno='#getartran.custno#';
			</cfquery>

			<cfif getrecommendprice.recordcount gt 0>
				<cfset price = getrecommendprice.price>
				<cfset dispec1 = getrecommendprice.dispec>
				<cfset dispec2 = getrecommendprice.dispec2>
				<cfset dispec3 = getrecommendprice.dispec3>
			<cfelse>
				<cfif currrate neq 0>
					<cfset price = val(getitembal.ucost)/val(currrate)>
				<cfelse>
					<cfset price = getitembal.ucost>
				</cfif>

				<cfset dispec1 = 0>
				<cfset dispec2 = 0>
				<cfset dispec3 = 0>
			</cfif>
		<cfelse>
			<cfquery name="getrecommendprice" datasource="#dts#">
				select 
				* 
				from icl3p2 
				where itemno='#itemno#' 
				and custno='#getartran.custno#';
			</cfquery>

			<cfif getrecommendprice.recordcount gt 0>
				<cfset price = getrecommendprice.price>
				<cfset dispec1 = getrecommendprice.dispec>
				<cfset dispec2 = getrecommendprice.dispec2>
				<cfset dispec3 = getrecommendprice.dispec3>
			<cfelse>
				<cfif getgeneralinfo.bcurr neq refno3 and refno3 neq "">
					<cfif currrate neq 0>
						<cfif lcase(hcomid) eq "ovas_i" or  lcase(hcomid) eq "ecraft_i">
							<cfif refno3 eq "RM">
								<cfset price = getitembal.price/currrate>
								<cfquery name="getusercurr" datasource="#dts#">
									select a.currcode from iclocation a, main.users b 
									where a.location =b.location
									and a.currcode='RM' and b.userid='#HUserID#'
								</cfquery>
								<cfif getusercurr.recordcount neq 0>
									<cfset price = getitembal.price2>
								</cfif>
							<cfelse>
								<cfset price = val(getitembal.price)/val(currrate)>
							</cfif>
						<cfelse>
							<cfset price = val(getitembal.price)/val(currrate)>
						</cfif>
						<!--- <cfset price = getitembal.price/currrate> --->
					<cfelse>
						<cfset price = getitembal.price>
					</cfif>
				<cfelse>
					
                    	<cfquery name="getbustype" datasource="#dts#">
                        SELECT business FROM #target_arcust#
							where custno='#getartran.custno#'
                        </cfquery>
                        <cfif getbustype.business neq "">
                        <cfquery name="getpricelvl" datasource="#dts#">
                        SELECT pricelvl FROM business where business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getbustype.business#">
                        </cfquery>
                        
                        <cfif getpricelvl.pricelvl eq 2>
                        <cfset price = getitembal.price2>
                        <cfelseif getpricelvl.pricelvl eq 3>
                        <cfset price = getitembal.price3>
                        <cfelseif getpricelvl.pricelvl eq 4>
                        <cfset price = getitembal.price4>
                        <cfelse>
                        <cfset price = getitembal.price>
						</cfif>
						<cfelse>
						<cfset price = getitembal.price>
						</cfif>
					
				</cfif>

				<cfset dispec1 = 0>
				<cfset dispec2 = 0>
				<cfset dispec3 = 0>
			</cfif>
            
            <cfif getGeneralInfo.itempriceprior eq "2">
            
            <cfquery name="getbustype" datasource="#dts#">
            SELECT business FROM #target_arcust#
                where custno='#getartran.custno#'
            </cfquery>
            <cfif getbustype.business neq "">
            <cfquery name="getpricelvl" datasource="#dts#">
            SELECT pricelvl FROM business where business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getbustype.business#">
            </cfquery>
            
            <cfif getpricelvl.pricelvl eq 2>
            <cfset price = getitembal.price2>
            <cfelseif getpricelvl.pricelvl eq 3>
            <cfset price = getitembal.price3>
            <cfelseif getpricelvl.pricelvl eq 4>
            <cfset price = getitembal.price4>
            <cfelse>
            <cfset price = getitembal.price>
            </cfif>
            <cfelse>
            <cfset price = getitembal.price>
            </cfif>
                        
			</cfif>
            
		</cfif>
		<cfif (tran eq "RC" or tran eq "PO" or tran eq "PR") and getrecommendprice.recordcount gt 0>
        <cfset desp = getrecommendprice.desp>
        <cfelse>
		<cfset desp = getitembal.desp>
        </cfif>
		<cfset despa = getitembal.despa>
		<cfset remark1 = getitembal.remark1>	<!--- ADD ON 10-02-2009 --->
		<!--- ADD ON 05-06-2009 --->
		<cfset wpformula=getitembal.wpformula>
		<cfset wqformula=getitembal.wqformula>
		<!--- ADD ON 040608, FOR SALES ORDER ONLY THE PRODUCT CODE FROM PRODUCT PROFILE WILL ASSIGNED TO CUST PART NO --->
		<cfif (lcase(hcomid) eq "ge_i" or lcase(hcomid) eq "gecn_i" or lcase(hcomid) eq "idi_i" or lcase(hcomid) eq "gwa_i" or lcase(hcomid) eq "gwachina_i" or lcase(hcomid) eq "saehan_i") and tran eq "SO">
			<cfset brem3 = getitembal.productcode>
		<cfelseif lcase(hcomid) eq "avent_i">
			<cfif getitembal.materialid neq "">
				 <cfquery name='getcolor' datasource='#dts#'>
   			 		select * from iccolorid where colorid = '#getitembal.materialid#'
    			</cfquery>
				<cfif getcolor.recordcount neq 0>
					<cfset brem1 = getcolor.desp>
				</cfif>
			</cfif>
			<cfset brem2 = getitembal.handle>
			<cfset brem3 = getitembal.printed>
			<cfset brem4 = getitembal.uom2>
			<cfset packing = getitembal.packing>
		<cfelseif lcase(hcomid) eq "anglo_i">	<!--- Add On 090908 --->
			<cfset Brem1 = getitembal.cod_material>
			<cfset Brem2 = getitembal.cod_color>
			<cfset Brem3 = getitembal.sizeid>
			<cfset shelf = getitembal.cod_model>
		<cfelseif lcase(hcomid) eq "nikbra_i">
			<cfquery name="getmaxbrem1" datasource="#dts#">
				select max(brem1+0) as maxno
				from ictran 
				where type='#tran#'
				and refno='#nexttranno#'
			</cfquery>
			<cfset Brem1=val(getmaxbrem1.maxno)+1>
			<cfset Brem2 = "0.00">
		</cfif> 
	</cfif>
    
    <cfif (lcase(HcomID) eq "gamemartz_i") and tran eq 'RC'>
    <cfset Brem1 = getitembal.price>
    </cfif>
    
    
 <cfquery name="getgsetuplocation" datasource="#dts#">
	select ddllocation,followlocation from gsetup 
      </cfquery>
	<cfif isdefined("form.location")>
		<cfset xlocation = form.location>
	<cfelse>
		<cfif HcomID eq "pnp_i">
			<cfinclude template="../../pnp/get_userid_location.cfm">
		<cfelseif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfinclude template="../../customized/#dts#/get_default_location.cfm">
		<cfelseif lcase(hcomid) eq "meisei_i" and tran eq "RC">
        	<cfset xlocation = "MEISEI ">
        <cfelseif lcase(hcomid) eq "meisei_i" and tran eq "INV">
        	<cfset xlocation = "DIRECT BUY & SELL W/H">
		<cfelse>
        <cfif getgsetuplocation.followlocation eq 'Y'>
         <cfquery name="get1stitemlocation" datasource="#dts#">
            select location from ictran where refno='#nexttranno#' and type='#tran#' and itemcount='1'
         </cfquery>
            <cfset xlocation = get1stitemlocation.location>
        <cfelse>
			<cfset xlocation = "#getgsetuplocation.ddllocation#">
        </cfif>
		</cfif>
	</cfif>
	<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i' or lcase(hcomid) eq 'ugateway_i' or lcase(hcomid) eq 'ideal_i' or lcase(hcomid) eq 'visionlaw_i'>
    <cfset qty = 1 >
	<cfelse>
	<cfset qty = getGeneralInfo.df_qty>
	</cfif>
	<cfif isservice eq 1>
		<cfset unit = "">
		<cfset graded = "">
		<cfset is_service = 1>	<!--- ADD ON 190908, WANT TO KNOW THE TYPE: SERVICE/PRODUCT --->
	<cfelse>
		<cfset unit = getitembal.unit>
		<cfset graded = getitembal.graded>
		<cfset is_service = 0>	<!--- ADD ON 190908, WANT TO KNOW THE TYPE: SERVICE/PRODUCT --->
	</cfif>
	
	<!--- ADD ON 20-11-2008, INITIALIZE THE GRADED ITEM VALUE --->
	<cfset grdcolumnlist = "">
	<cfset grdvaluelist = "">
	<cfset totalrecord = "0">
	<cfset bgrdcolumnlist = "">
	<cfset oldgrdvaluelist = "">

	<!--- REMARK ON 040608, MOVE TO THE TOP OF PAGE --->
	<!---cfset Brem1 = "">
	<cfset Brem2 = "">
	<cfset Brem3 = "">
	<cfset Brem4 = "">
	<cfset xsv_part = "">
	<cfset sercost = 0>
	<cfset taxpec1 = 0>
	<cfset gltradac = ""--->

	<cfif isdefined("url.code")>
		<cfquery name="getcomment" datasource="#dts#">
			select 
			* 
			from comments 
			where code='#url.code#';
		</cfquery>

		<cfquery name="gettempcomment" datasource="#dts#">
			select 
			comment 
			from commentemp 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno='#itemno#' 
			and userid='#huserid#';
		</cfquery>

		<cfif tostring(gettempcomment.comment) eq "">
			<cfset comment=ToString(getcomment.details)>
		<cfelse>
			<cfset comment=tostring(gettempcomment.comment)&chr(13)&chr(13)&ToString(getcomment.details)>
		</cfif>

		<cfquery name="deltempcomment" datasource="#dts#">
			delete from commentemp 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno='#itemno#' 
			and userid='#huserid#';
		</cfquery>
	<cfelse>
    <cfif service eq "">
    <cfset comment = ToString(getitembal.comment)>
    <cfelse>
    <cfset comment = "">
    </cfif>
	</cfif>
	
	<!--- ADD ON 230908 --->
	<!--- <cfif lcase(hcomid) eq "ecraft_i">
		<cfquery name="getarrival" datasource="#dts#">
        	select * from ictran
            where itemno = '#itemno#'
            and type = 'PO'
            and fperiod <> '99'
            order by wos_date desc 
            limit 1
        </cfquery>
        <cfif getarrival.recordcount neq 0 and getarrival.wos_date neq "">
			<cfset arrivaldate = dateformat(getarrival.wos_date,"dd/mm/yyyy")>
		<cfelse>
        	<cfset arrivaldate = "-">
		</cfif>
	</cfif> --->
	<!--- Modified on 17-11-2008 --->
	<cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and (tran eq "INV" or tran eq "CS" or tran eq "DO")>
		<cfquery name="getarrival" datasource="#dts#">
        	select a.rem9 from artran a,ictran b
            where a.type = b.type and a.refno = b.refno 
			and b.itemno = '#itemno#'
            and a.type = 'PO'
            and a.fperiod <> '99'
            order by a.rem9 desc 
            limit 1
        </cfquery>
        <cfif getarrival.recordcount neq 0 and getarrival.rem9 neq "">
			<cfset arrivaldate = dateformat(getarrival.rem9,"dd/mm/yyyy")>
		<cfelse>
        	<cfset arrivaldate = "-">
		</cfif>
	</cfif>
	<cfset discamt = 0>
	
	<cfset mode = "Add">
	<cfset button = "Add">
    <cfif isdefined('getitembal.fcurrcode')>
    <cfif getitembal.fcurrcode neq "" and getartran.currcode eq getitembal.fcurrcode>
        <cfif tran eq "INV" or tran eq "DO" or tran eq "QUO" or tran eq "SO" or tran eq "CS">
        <cfset price = getitembal.fprice>
		<cfelse>
        <cfset price = getitembal.fucost>
		</cfif>
        </cfif>
        </cfif>
        
    <cfif tran eq "INV" or tran eq "DO" or tran eq "QUO" or tran eq "SO" or tran eq "CS">
    <cfquery name="checkitemprice" datasource="#dts#">
    select custprice_rate from icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
    </cfquery>
    <cfquery name="checkcustomerprice" datasource="#dts#">
    select NORMAL_RATE,OFFER_RATE,OTHERS_RATE from #target_arcust# where custno='#getartran.custno#'
    </cfquery>
    <cfif checkitemprice.custprice_rate eq 'normal' and checkcustomerprice.NORMAL_RATE neq 0>
    <cfset price=(price*((100-val(checkcustomerprice.NORMAL_RATE))/100))>
    <cfelseif checkitemprice.custprice_rate eq 'offer' and checkcustomerprice.OFFER_RATE neq 0>
    <cfset price=(price*((100-val(checkcustomerprice.OFFER_RATE))/100))>
    <cfelseif checkitemprice.custprice_rate eq 'others' and checkcustomerprice.OTHERS_RATE neq 0>
    <cfset price=(price*((100-val(checkcustomerprice.OTHERS_RATE))/100))>
    </cfif>
    
    </cfif>
        
    <cfif tran eq "INV" or tran eq "DO" or tran eq "QUO" or tran eq "SO" or tran eq "CS">
    <cfquery name="checkpromotion" datasource="#dts#">
    SELECT * FROM promoitem as a right join promotion as b on a.promoid = b.promoid WHERE a.itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and b.periodfrom <="#dateformat(now(),'yyyy-mm-dd')#" and b.periodto >= "#dateformat(now(),'yyyy-mm-dd')#" and (b.customer='#getartran.custno#' or b.customer='')
    </cfquery>
    
    <cfif checkpromotion.recordcount neq 0>
	<cfif checkpromotion.type eq "percent">
    <cfif getGeneralInfo.prodisprice eq "Y">
    <cfset dispec1 = val(checkpromotion.priceamt)>
    <cfelse>
    <cfset price = price - (price * (val(checkpromotion.priceamt)/100)) >
    </cfif>
    <cfelseif checkpromotion.type eq "price">
    <cfif checkpromotion.pricedistype eq "fixeddis">
    <cfif getGeneralInfo.prodisprice eq "Y">
    <cfset discamt = val(checkpromotion.priceamt)>
	<cfelse>
	<cfset price = price - val(checkpromotion.priceamt)>
    </cfif>
    <cfelseif checkpromotion.pricedistype eq "fixedprice">
    <cfset price = val(checkpromotion.priceamt)>
    <cfelseif checkpromotion.pricedistype eq "Varprice">
    <cfset price = checkpromotion.itemprice >
	</cfif>
    <cfelseif checkpromotion.type eq "buy">
	<script type="text/javascript">
	function buypromo()
	{
	<cfoutput>
	var valueval = document.getElementById('qt6').value;
	var pricenow = document.getElementById('pri6').value * document.getElementById('qt6').value;
	<cfloop query="checkpromotion">
	<cfset varvalcount = 1>
	
	<cfif checkpromotion.discby eq "price">
    <cfif checkpromotion.pricedistype eq "fixeddis">
    <cfset price1 = val(price) - val(checkpromotion.priceamt)>
	<cfset disamtval1 =  val(checkpromotion.priceamt)>
    <cfelseif checkpromotion.pricedistype eq "fixedprice">
    <cfset price1 = val(checkpromotion.priceamt)>
    <cfelseif checkpromotion.pricedistype eq "Varprice">
    <cfset price1 = checkpromotion.itemprice >
	</cfif>
    <cfelse>
    <cfset price1 = price - (val(price) * (val(checkpromotion.priceamt)/100)) >
	<cfset disamtval1 =  val(checkpromotion.priceamt)>
	</cfif>
	<cfif checkpromotion.buydistype neq "totalamt">
	<cfif checkpromotion.currentrow neq 1>else </cfif>if(valueval >= #checkpromotion.rangefrom# && valueval <=#checkpromotion.rangeto#)
	{
	<cfif getGeneralInfo.prodisprice eq "Y" and isdefined('disamtval1')  and checkpromotion.discby eq "price">
	document.getElementById('discamt_id').value = "#val(disamtval1)#";
	<cfelseif getGeneralInfo.prodisprice eq "Y" and isdefined('disamtval1')  and checkpromotion.discby neq "price">
	document.getElementById('dis13').value = "#val(disamtval1)#";
	<cfelse>
	document.getElementById('pri6').value = "#val(price1)#";
	</cfif>
	}
	
	<cfelse>
	
	<cfif checkpromotion.currentrow neq 1>else </cfif>if(pricenow >= #checkpromotion.rangefrom# && pricenow <=#checkpromotion.rangeto#)
	{
	<cfif getGeneralInfo.prodisprice eq "Y" and isdefined('disamtval1')  and checkpromotion.discby eq "price">
	document.getElementById('discamt_id').value = "#val(disamtval1)#";
	<cfelseif getGeneralInfo.prodisprice eq "Y" and isdefined('disamtval1')  and checkpromotion.discby neq "price">
	document.getElementById('dis13').value = "#val(disamtval1)#";
	<cfelse>
	document.getElementById('pri6').value = "#val(price1)#";
	</cfif>
	}
	</cfif>
    </cfloop>
	else
	{
	document.getElementById('pri6').value = "#price#";
	}
	</cfoutput>
	}
    </script>
	</cfif>
    
	</cfif>
    
    <cfelse>
    <cfquery name="checkpromotion" datasource="#dts#">
    SELECT * FROM promotion where promoid = 0
    </cfquery>
	</cfif>
    	<cfif lcase(hcomid) eq "taftc_i">
       
        <cfquery name="getcoursedetail" datasource="#dts#">
        SELECT camt,bydeposit from project where source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.source#">
        </cfquery> 
        <cfif getcoursedetail.bydeposit eq "1">
        <cfset price = val(getcoursedetail.camt) / 2>
		<cfelse>
        <cfset price = getcoursedetail.camt>
		</cfif>
		</cfif>
        
        
</cfif>