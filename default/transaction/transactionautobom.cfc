<cfcomponent>
	<cffunction name="generatebom">
		<cfargument name="dts" required="yes">
		<cfargument name="qty" required="yes">
		<cfargument name="itemno" required="yes">
        <cfargument name="bomno" required="yes">
        <cfargument name="huserid" required="yes">
        
        
       						 <cfquery name="getlocitembal" datasource="#arguments.dts#">
									select * from icitem
									where itemno = '#arguments.itemno#'
								</cfquery>
								<cfif getlocitembal.recordcount neq 0>
									<cfset itembal = getlocitembal.qtybf>
								<cfelse>
									<cfset itembal = 0>
								</cfif>
							
								<cfquery name="getin" datasource="#arguments.dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('RC','CN','OAI','TRIN') 
									and itemno= '#arguments.itemno#'
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getin.sumqty neq "">
									<cfset inqty = getin.sumqty>
								<cfelse>
									<cfset inqty = 0>
								</cfif>

								<cfquery name="getout" datasource="#arguments.dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
									and itemno= '#arguments.itemno#'
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getout.sumqty neq "">
									<cfset outqty = getout.sumqty>
								<cfelse>
									<cfset outqty = 0>
								</cfif>

								<cfquery name="getdo" datasource="#arguments.dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type='DO' 
									and toinv='' 
									and itemno= '#arguments.itemno#'
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getdo.sumqty neq "">
									<cfset DOqty = getdo.sumqty>
								<cfelse>
									<cfset DOqty = 0>
								</cfif>
							
								<cfquery name="getpo" datasource="#arguments.dts#">
									select 
									ifnull(sum(qty),0) as sumqty 
									from ictran 
									where type='PO' 
									and itemno= '#arguments.itemno#'
									and fperiod <> '99' 
									and (void = '' or void is null) and toinv=''
								</cfquery>		
							
								<cfset balonhand = itembal + inqty - outqty - doqty + getpo.sumqty>
        
        <cfquery name="getgeneral" datasource="#arguments.dts#">
		select * from gsetup
		</cfquery>
        
        <cfquery name="getbom" datasource="#arguments.dts#">
		select * from billmat where itemno='#arguments.itemno#' and bomno='#arguments.bomno#'
        </cfquery>
		
        <cfif balonhand - arguments.qty lt 0>

        <cfset qty=arguments.qty-balonhand>
        
        <cfset lastaccyear = dateformat(getGeneral.lastaccyear, "dd/mm/yyyy")>
		<cfset period = '#getGeneral.period#'>
		<cfset currentdate = dateformat(now(),"dd/mm/yyyy")>
		<cfset tmpYear = year(currentdate)>
		<cfset clsyear = year(lastaccyear)>
		<cfset tmpmonth = month(currentdate)>
		<cfset clsmonth = month(lastaccyear)>
		<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>

<cfif intperiod gt 18 or intperiod lte 0>
	<cfset readperiod = 99>
<cfelse>
	<cfset readperiod = numberformat(intperiod,"00")>
</cfif>
	
<cfset dd=dateformat(now(), "DD")>

<cfif dd greater than '12'>
	<cfset nDateCreate=dateformat(now(),"YYYYMMDD")>
<cfelse>
	<cfset nDateCreate=dateformat(now(),"YYYYDDMM")>
</cfif>

<cfquery datasource="#arguments.dts#" name="getGeneralInfo">
	select lastUsedNo as tranno, refnoused as arun 
	from refnoset
	where type = 'ASSM'
	and counter = 1
</cfquery>

<cfif getGeneralInfo.arun eq "1">
	<cfset refnocnt = len(getGeneralInfo.tranno)>	
	<cfset cnt = 0>
	<cfset yes = 0>
	
	<cfloop condition = "cnt lte refnocnt and yes eq 0">
		<cfset cnt = cnt + 1>			
		<cfif isnumeric(mid(getGeneralInfo.tranno,cnt,1))>				
			<cfset yes = 1>			
		</cfif>								
	</cfloop>
	
	<cfset nolen = refnocnt - cnt + 1>
	<cfset nextno = right(getGeneralInfo.tranno,nolen) + 1>
	<cfset nocnt = 1>
	<cfset zero = "">
	
	<cfloop condition = "nocnt lte nolen">
		<cfset zero = zero & "0">
		<cfset nocnt = nocnt + 1>	
	</cfloop>
	
	<cfset limit = 8>
	
	<cfif cnt gt 1>
		<cfset nexttranno = left(getGeneralInfo.tranno,cnt-1)&numberformat(nextno,zero)>
		<cfif len(nexttranno) gt limit>
			<cfset nexttranno = '99999999'>
		</cfif>
	<cfelse>
		<cfset nexttranno = numberformat(nextno,zero)> 
		<cfif len(nexttranno) gt limit>
			<cfset nexttranno = '99999999'>
		</cfif>
	</cfif>
</cfif>
<cfquery name="getitem" datasource="#arguments.dts#">
	select bom_cost,wos_group,category from icitem where itemno = '#arguments.itemno#'
</cfquery>
<cfquery name="getitem2" datasource="#arguments.dts#">
		select * from icitem where itemno='#arguments.itemno#'
        </cfquery>
        
		<cfset totalprice = 0>
		<cfset itemcnt = 1>
        
        <cfoutput>
        <cfloop query="getbom">
        <cfquery name="getitem" datasource="#arguments.dts#">
		select * from icitem where itemno='#getbom.bmitemno#'
        </cfquery>
    <cfset currrate =1>
    <cfif getitem.price neq "">
		<cfset itemprice = getitem.ucost>
	<cfelse>		
		<cfset itemprice = 0>
	</cfif>
	<cfset amt1_bil = qty * itemprice>
	<cfset disamt_bil = 0>
	<cfset netamt = amt1_bil - disamt_bil>
	<cfset taxamt_bil = 0>
	<!--- <cfset amt_bil = netamt + taxamt_bil> --->
    <cfset amt_bil = netamt>
	<cfset xprice = itemprice * currrate>
	<cfset amt1 = amt1_bil * currrate>
	<cfset disamt = disamt_bil * currrate>
	<cfset taxamt = taxamt_bil * currrate>
	<cfset amt = amt_bil * currrate>
	<cfset totalprice = totalprice + amt1_bil>
			

        <cfquery datasource="#arguments.dts#" name="insertictran">
            Insert into ictran (type,refno,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,
            location,qty_bil,price_bil,amt1_bil,dispec1,disamt_bil,amt_bil,taxpec1,taxamt_bil,qty,price,
            amt1,disamt,amt,taxamt,dono,name,sono,wos_group,category,trdatetime,dispec2,dispec3,comment,factor1,factor2)
        
            values ('ISS', '#nexttranno#', 'ASSM/999', '#readperiod#', 
            #ndatecreate#, '#currrate#', '#itemcnt#', 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#getbom.bmitemno#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.desp#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.despa#"> ,
            '#arguments.location#', '#qty#', '#val(itemprice)#','#val(amt1_bil)#', '0',
            '#val(disamt_bil)#', '#val(amt_bil)#', '0','#val(taxamt_bil)#','#qty#', '#val(xprice)#', '#val(amt1)#', 
            '#val(disamt)#',	'#val(amt)#', '#val(taxamt)#', 'DONO','#form.despa#', 'SONO', '#getitem.wos_group#',
            '#getitem.category#',#createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#,0,0,'','1','1')
        </cfquery>
<cfset itemcnt =itemcnt+1>
	
    <cfset issno='ISS '&#nexttranno#>
    </cfloop>
</cfoutput>

<!--- insert RC ictran --->

	<cfset itemcnt = 1>

<cfset arprice_bil = getitem2.ucost>
<cfset amt1_bil = qty * arprice_bil>
<cfset disamt_bil = 0 * amt1_bil>
<cfset netamt = amt1_bil - disamt_bil>
<cfset taxamt_bil = 0 * netamt>
<!--- <cfset amt_bil = netamt + taxamt_bil> --->
<cfset amt_bil = netamt>
<cfset arprice = arprice_bil * currrate>
<cfset amt1 = amt1_bil * currrate>
<cfset disamt = disamt_bil * currrate>
<cfset taxamt = taxamt_bil * currrate>
<cfset amt = amt_bil * currrate>

<cfquery datasource="#arguments.dts#" name="insertictran">
	Insert into ictran (type,refno,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,
	location,qty_bil,price_bil,amt1_bil,dispec1,disamt_bil,amt_bil,taxpec1,taxamt_bil,qty,price,
	amt1,disamt,amt,taxamt,dono,name,sono,wos_group,category,trdatetime,dispec2,dispec3,comment,factor1,factor2)

	values ('RC', '#nexttranno#', 'ASSM/999', '#readperiod#', 
	#ndatecreate#, '#currrate#', '#itemcnt#', '#arguments.itemno#', '#getitem2.desp#', '#getitem2.despa#',
	'#arguments.location#', '#qty#', '#arprice_bil#','#amt1_bil#', '0',
	'#disamt_bil#', '#amt_bil#', '0','#taxamt_bil#','#qty#', '#arprice#', '#amt1#', 
	'#disamt#',	'#amt#', '#taxamt#', 'DONO','#getitem2.desp#', 'SONO', '#getitem2.wos_group#',
	'#getitem2.category#', #createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#,0,0,'','1','1')
</cfquery>

<!--- insert artran RC --->

  	<cfquery name="insertartran" datasource="#arguments.dts#">
		Insert into artran (type,refno,custno,fperiod,wos_date,currrate,
		name,rem1,exported,trdatetime,userid,currcode,created_by,created_on,updated_by,updated_on,pono)
		
		values('RC','#nexttranno#','ASSM/999','#readperiod#',#ndatecreate#,
		'#currrate#','#HUserID#','#HUserID#','',#createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#, '#HUserID#','#form.refno3#','#HUserID#',#now()#,'#HUserID#',#now()#,'#issno#')
	</cfquery>

  	<cfquery name="insertartran" datasource="#arguments.dts#">
		Insert into artran (type,refno,custno,fperiod,wos_date,currrate,
		name,rem1,exported,trdatetime,userid,currcode,created_by,created_on,updated_by,updated_on)
		
		values('ISS','#nexttranno#','ASSM/999','#readperiod#',#ndatecreate#,
		'#currrate#','#HUserID#','#HUserID#','',#createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#, '#HUserID#','#form.refno3#','#HUserID#',#now()#,'#HUserID#',#now()#)
	</cfquery>

<cfquery name="updategsetup" datasource="#arguments.dts#">
		update refnoset 
		set lastUsedNo=UPPER('#nexttranno#')
		where type = 'ASSM'
		and counter = 1
	</cfquery>      
</cfif>  



	</cffunction>
</cfcomponent>	