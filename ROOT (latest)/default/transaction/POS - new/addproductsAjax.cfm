<cfsetting showdebugoutput="no">
<cfset itemno = URLDecode(url.servicecode)>
<cfset desp = URLDecode(url.desp)>
<cfset amt = val(URLDecode(url.expressamt))>
<cfset qty = val(URLDecode(url.expqty))>
<cfset price = val(URLDecode(url.expprice))>
<cfset unit = URLDecode(url.unit)>
<cfset dispec1 = URLDecode(url.dispec1)>
<cfset dispec2 = URLDecode(url.dispec2)>
<cfset dispec3 = URLDecode(url.dispec3)>
<cfset dis = URLDecode(url.dis)>
<cfset tran = URLDecode(url.tran)>
<cfset tranno = URLDecode(url.tranno)>
<cfset custno = URLDecode(url.custno)>
<cfset isservi = URLDecode(url.isservi)>
<cfset uuid = URLDecode(url.uuid)>
<cfset trancode = URLDecode(url.trancode)>
<cfset location = URLDecode(url.brem1)> 
<cfset driver = URLDecode(url.driver)> 
<cfset rem9 = URLDecode(url.rem9)> 

<!--- <cfif FindNoCase('*',itemno) neq 0>
<cfset position = FindNoCase('*',itemno)>
<cfset qty = left(itemno,position-1)>
<cfset itemno = right(itemno,len(itemno)-position)>
</cfif> --->

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<!---Promotion--->
<cfquery name="checkpromotion" datasource="#dts#">
    SELECT * FROM promoitem as a right join promotion as b on a.promoid = b.promoid WHERE a.itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and b.periodfrom <="#dateformat(now(),'yyyy-mm-dd')#" and b.periodto >= "#dateformat(now(),'yyyy-mm-dd')#" and (b.customer='') and (b.location like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getgsetup.ddllocation#%"> or b.location='' or b.location is null)
</cfquery>

	<cfif checkpromotion.recordcount neq 0>
	<cfif checkpromotion.type eq "percent">
    <cfset dispec1 = val(checkpromotion.priceamt)>
    <cfset dis=(val(price)*val(qty))*(dispec1/100)>
    
    <cfset amt=(val(price)*val(qty))-dis>
    <cfset brem4=val(checkpromotion.priceamt)&"%">
    
    <cfelseif checkpromotion.type eq "price">
    <cfif checkpromotion.pricedistype eq "fixeddis">
	<cfset price = price - val(checkpromotion.priceamt)>
    <cfset amt=val(price)*val(qty)>
    <cfelseif checkpromotion.pricedistype eq "fixedprice">
    <cfset price = val(checkpromotion.priceamt)>
    <cfset amt=val(price)*val(qty)>
    <cfelseif checkpromotion.pricedistype eq "Varprice">
    <cfset price = checkpromotion.itemprice >
    <cfset amt=val(price)*val(qty)>
	</cfif>
    
    </cfif>

	
	</cfif>
    

<!--- --->

<!---Member price--->
<cfquery name="getproductdetail" datasource="#dts#">
select * from icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>

<cfquery name="getmemberprice" datasource="#dts#">
select * from driver where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">
</cfquery>

<cfif getmemberprice.pricelevel eq 2>
<cfset price = getproductdetail.price2>
<cfelseif getmemberprice.pricelevel eq 3>
<cfset price = getproductdetail.price3>
<cfelseif getmemberprice.pricelevel eq 4>
<cfset price = getproductdetail.price4>
<cfelse>
</cfif>

<!--- --->

<cfif getgsetup.positemgrouping eq 'Y'>

<cfquery name="checkitemexistinicitem" datasource="#dts#">
select * from(select itemno as itemno from icitem where (nonstkitem<>'T' or nonstkitem is null)
union all
select servi as itemno from icservi) as a
where itemno='#itemno#'
</cfquery>

<cfif checkitemexistinicitem.recordcount neq 0>

<cfquery name="validitemexist" datasource="#dts#">
SELECT trancode,itemno,qty_bil,price_bil,qty
FROM ictrantemp WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
and unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit#">
and dispec1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dispec1#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfif validitemexist.recordcount neq 0>
<cfquery name="updaterow" datasource="#dts#">
UPDATE ictrantemp SET 
qty_bil = qty_bil + #qty#,
disamt_bil =disamt_bil+#dis#
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validitemexist.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="getitemdetail" datasource="#dts#">
SELECT itemno,unit FROM ictrantemp WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validitemexist.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="selecticitem" datasource="#dts#">
SELECT unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemdetail.itemno#" >
</cfquery>

<cfset qtyReal = val(validitemexist.qty) + qty>
<cfif unit neq "" and unit neq "#selecticitem.unit#">

<cfif unit eq "#selecticitem.unit2#">
<cfset qtyReal = val(validitemexist.qty) +( val(qty) * val(selecticitem.factor1) ) / val(selecticitem.factor2)>
<cfelseif unit eq "#selecticitem.unit3#">
<cfset qtyReal = val(validitemexist.qty) +( val(qty) * val(selecticitem.factorU3_a) ) / val(selecticitem.factorU3_b)>
<cfelseif unit eq "#selecticitem.unit4#">
<cfset qtyReal = val(validitemexist.qty) +( val(qty) * val(selecticitem.factorU4_a) ) / val(selecticitem.factorU4_b)>
<cfelseif unit eq "#selecticitem.unit5#">
<cfset qtyReal = val(validitemexist.qty) +( val(qty) * val(selecticitem.factorU5_a) ) / val(selecticitem.factorU5_b)>
<cfelseif unit eq "#selecticitem.unit6#">
<cfset qtyReal = val(validitemexist.qty) +( val(qty) * val(selecticitem.factorU6_a) ) / val(selecticitem.factorU6_b)>
</cfif>

</cfif>

<cfquery name="updateictranqty" datasource="#dts#">
UPDATE ictrantemp SET 
qty = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtyReal#">,
amt_bil = round((price_bil * qty_bil)+0.000001 - disamt_bil,2),
amt1_bil = round((price_bil * qty_bil)+0.000001,2)
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validitemexist.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
UPDATE ictrantemp SET 
disamt = (disamt_bil * if(currrate = 0,1,currrate)),
amt = round((amt_bil * if(currrate = 0,1,currrate))+0.000001,2),
amt1 = round((amt1_bil * if(currrate = 0,1,currrate))+0.000001,2)
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validitemexist.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfelse>
<cfquery name="checkitemExist" datasource="#dts#">
    select 
    itemcount 
    from ictrantemp 
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="getitemdetail" datasource="#dts#">
    select 
    wos_group,category,costcode,custprice_rate
    from icitem
    where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>

<cfif checkitemExist.recordcount gt 0>
<cfset end = checkitemExist.itemcount[checkitemExist.recordcount]>
<cfset newtc = trancode>

<cfquery name="updateIctran" datasource="#dts#">
		update ictrantemp set 
		itemcount=itemcount+1,
		trancode=trancode+1
		where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
		and itemcount>=#newtc# 
		and itemcount<=#end#
		order by itemcount desc;
	</cfquery>
</cfif>

<!--- <cfquery name="selectictran" datasource="#dts#">
SELECT trancode FROM ictrantemp where  uuid = "#uuid#" order by trancode desc
</cfquery> --->

<cfquery name="selecticitem" datasource="#dts#">
SELECT unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#" >
</cfquery>


<!--- <cfif selectictran.trancode eq "">
<cfset selectictran.trancode = 0>
</cfif>
 --->
<cfset qtyReal = qty>

<cfif unit neq "" and unit neq "#selecticitem.unit#">

<cfif unit eq "#selecticitem.unit2#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factor1) ) / val(selecticitem.factor2)>
<cfelseif unit eq "#selecticitem.unit3#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU3_a) ) / val(selecticitem.factorU3_b)>
<cfelseif unit eq "#selecticitem.unit4#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU4_a) ) / val(selecticitem.factorU4_b)>
<cfelseif unit eq "#selecticitem.unit5#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU5_a) ) / val(selecticitem.factorU5_b)>
<cfelseif unit eq "#selecticitem.unit6#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU6_a) ) / val(selecticitem.factorU6_b)>
</cfif>

</cfif>



<!--- <cfset trancode = val(selectictran.trancode) + 1> --->

<cfquery name="insertictran" datasource="#dts#">
	insert into ictrantemp
	(
		type,
        refno,
        custno,
        trancode,
        itemcount,
        linecode,
        itemno,
        desp,
        despa,
        location,
        qty_bil,
        price_bil,
        unit_bil,
        amt1_bil,
        dispec1,
        dispec2,
        dispec3,
        disamt_bil,
        amt_bil,
		taxpec1,
        gltradac,
        taxamt_bil,
        qty,
        price,
        unit,
        factor1,
        factor2,
        amt1,
        disamt,
        amt,
        taxamt,
        note_a,
		dono,
        exported,
        exported1,
        sono,
        toinv,
        generated,
        wos_group,
        category,
        brem1,
        brem2,
        brem3,
        brem4,
        packing,
        shelf,
        supp,
        qty1,
        qty2,
        qty3,
        qty4,
        qty5,
        qty6,
        qty7,
        trdatetime,
        sv_part,
        sercost,
        userid,
        sodate,
        dodate,
        adtcost1,
        adtcost2,
        batchcode,
        expdate,
        mc1_bil,
        mc2_bil,
        defective,
        nodisplay,
        title_id,
        title_desp,
        comment,
        m_charge1,
        m_charge2,
        m_charge3,
        m_charge4,
        m_charge5,
        m_charge6,
        m_charge7,
       	mc3_bil,
        mc4_bil,
        mc5_bil,
        mc6_bil,
        mc7_bil,
        uuid,
        driver,
        rem9,
        note1
        )
        values
        (
        '#tran#',
        '#tranno#',
        '#custno#',
        #trancode#,#trancode#,
        '<cfif isservi eq "1">SV<cfelse></cfif>',
        '#itemno#', 
        '#REReplace(desp,"925925925925","%","ALL")#', 
        '', 
        '#location#',
        #numberformat(val(qty),'._____')#,
        #numberformat(val(price),'.__')#, 
        '#unit#',
         #numberformat(val(amt),'.__')#,
        #val(dispec1)#,
        #val(dispec2)#,
        #val(dispec3)#,
        #numberformat(val(dis),'._____')#,
        #numberformat(val(amt),'.__')#, 
        '0',
        '',
        0.00000,
        #numberformat(val(qtyReal),'._____')#,
         #numberformat(val(price),'.__')#,
          '#unit#',
          '1',
           '1',
            #numberformat(val(amt),'.__')#,
            #numberformat(val(dis),'._____')#,
            #numberformat(val(amt),'.__')#,
            0.00000,
            '',
            '',
              '', 
              '0000-00-00', 
              '', 
              '', 
              '', 
              '#getitemdetail.wos_group#', 
              '#getitemdetail.category#', 
              '', 
              '', 
              '', 
              <cfif isdefined('brem4')>'#brem4#'<cfelse>''</cfif>, 
              '', 
              '',
              '', 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              now(),
              '',
              0.00000,
              '#huserid#',
              '0000-00-00',
              '0000-00-00', 
              0.00000, 
              0.00000,
              '',
              '0000-00-00',
              0.00000, 
              0.00000,
              '',
              'N',
              '',
              '',
              '',
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              0.00000,
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              0.00000,
              '#uuid#',
              '#driver#',
              '#rem9#',
              <cfif getitemdetail.costcode eq 'YES' or getitemdetail.custprice_rate eq "offer">'Y'<cfelseif checkpromotion.recordcount neq 0>'P'<cfelse>''</cfif>
        )
</cfquery>
</cfif>

</cfif>



<cfelse>


<cfquery name="checkitemexistinicitem" datasource="#dts#">
select * from(select itemno as itemno from icitem where (nonstkitem<>'T' or nonstkitem is null)
union all
select servi as itemno from icservi) as a
where itemno='#itemno#'
</cfquery>

<cfif checkitemexistinicitem.recordcount neq 0>
<cfquery name="checkitemExist" datasource="#dts#">
    select 
    itemcount 
    from ictrantemp 
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="getitemdetail" datasource="#dts#">
    select 
    wos_group,category,custprice_rate,costcode
    from icitem
    where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>

<cfif checkitemExist.recordcount gt 0>
<cfset end = checkitemExist.itemcount[checkitemExist.recordcount]>
<cfset newtc = trancode>

<cfquery name="updateIctran" datasource="#dts#">
		update ictrantemp set 
		itemcount=itemcount+1,
		trancode=trancode+1
		where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
		and itemcount>=#newtc# 
		and itemcount<=#end#
		order by itemcount desc;
	</cfquery>
</cfif>

<!--- <cfquery name="selectictran" datasource="#dts#">
SELECT trancode FROM ictrantemp where  uuid = "#uuid#" order by trancode desc
</cfquery> --->

<cfquery name="selecticitem" datasource="#dts#">
SELECT unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#" >
</cfquery>


<!--- <cfif selectictran.trancode eq "">
<cfset selectictran.trancode = 0>
</cfif>
 --->
<cfset qtyReal = qty>

<cfif unit neq "" and unit neq "#selecticitem.unit#">

<cfif unit eq "#selecticitem.unit2#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factor1) ) / val(selecticitem.factor2)>
<cfelseif unit eq "#selecticitem.unit3#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU3_a) ) / val(selecticitem.factorU3_b)>
<cfelseif unit eq "#selecticitem.unit4#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU4_a) ) / val(selecticitem.factorU4_b)>
<cfelseif unit eq "#selecticitem.unit5#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU5_a) ) / val(selecticitem.factorU5_b)>
<cfelseif unit eq "#selecticitem.unit6#">
<cfset qtyReal = ( val(qty) * val(selecticitem.factorU6_a) ) / val(selecticitem.factorU6_b)>
</cfif>

</cfif>



<!--- <cfset trancode = val(selectictran.trancode) + 1> --->

<cfquery name="insertictran" datasource="#dts#">
	insert into ictrantemp
	(
		type,
        refno,
        custno,
        trancode,
        itemcount,
        linecode,
        itemno,
        desp,
        despa,
        location,
        qty_bil,
        price_bil,
        unit_bil,
        amt1_bil,
        dispec1,
        dispec2,
        dispec3,
        disamt_bil,
        amt_bil,
		taxpec1,
        gltradac,
        taxamt_bil,
        qty,
        price,
        unit,
        factor1,
        factor2,
        amt1,
        disamt,
        amt,
        taxamt,
        note_a,
		dono,
        exported,
        exported1,
        sono,
        toinv,
        generated,
        wos_group,
        category,
        brem1,
        brem2,
        brem3,
        brem4,
        packing,
        shelf,
        supp,
        qty1,
        qty2,
        qty3,
        qty4,
        qty5,
        qty6,
        qty7,
        trdatetime,
        sv_part,
        sercost,
        userid,
        sodate,
        dodate,
        adtcost1,
        adtcost2,
        batchcode,
        expdate,
        mc1_bil,
        mc2_bil,
        defective,
        nodisplay,
        title_id,
        title_desp,
        comment,
        m_charge1,
        m_charge2,
        m_charge3,
        m_charge4,
        m_charge5,
        m_charge6,
        m_charge7,
       	mc3_bil,
        mc4_bil,
        mc5_bil,
        mc6_bil,
        mc7_bil,
        uuid,
        driver,
        rem9,
        note1
        )
        values
        (
        '#tran#',
        '#tranno#',
        '#custno#',
        #trancode#,#trancode#,
        '<cfif isservi eq "1">SV<cfelse></cfif>',
        '#itemno#', 
        '#REReplace(desp,"925925925925","%","ALL")#', 
        '', 
        '#location#',
        #numberformat(val(qty),'._____')#,
        #numberformat(val(price),'.__')#, 
        '#unit#',
         #numberformat(val(amt),'.__')#,
        #val(dispec1)#,
        #val(dispec2)#,
        #val(dispec3)#,
        #numberformat(val(dis),'._____')#,
        #numberformat(val(amt),'.__')#, 
        '0',
        '',
        0.00000,
        #numberformat(val(qtyReal),'._____')#,
         #numberformat(val(price),'.__')#,
          '#unit#',
          '1',
           '1',
            #numberformat(val(amt),'.__')#,
            #numberformat(val(dis),'._____')#,
            #numberformat(val(amt),'.__')#,
            0.00000,
            '',
            '',
              '', 
              '0000-00-00', 
              '', 
              '', 
              '', 
              '#getitemdetail.wos_group#', 
              '#getitemdetail.category#', 
              '', 
              '', 
              '', 
              <cfif isdefined('brem4')>'#brem4#'<cfelse>''</cfif>, 
              '', 
              '',
              '', 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              now(),
              '',
              0.00000,
              '#huserid#',
              '0000-00-00',
              '0000-00-00', 
              0.00000, 
              0.00000,
              '',
              '0000-00-00',
              0.00000, 
              0.00000,
              '',
              'N',
              '',
              '',
              '',
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              0.00000,
              0.00000, 
              0.00000, 
              0.00000, 
              0.00000,
              0.00000,
              '#uuid#',
              '#driver#',
              '#rem9#',
              <cfif getitemdetail.costcode eq 'YES' or getitemdetail.custprice_rate eq "offer">'Y'<cfelseif checkpromotion.recordcount neq 0>'P'<cfelse>''</cfif>
        )
</cfquery>
</cfif>



</cfif>


<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt_bil) as sumsubtotal,count(itemno) as countitemno FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" />
</cfquery>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfif getgsetup.comboard eq 'Y'>
<cftry>
<div style="display:none">
<cfinvoke component="cfc.comboard" method="display" firstline="#desp#" secondlineleft="#numberformat(amt,',_.__')#" secondlineright="#numberformat(getsum.sumsubtotal,',_.__')#" comchannel="#getgsetup.comboardport#" returnvariable="test"/></div>
<cfcatch></cfcatch></cftry>
</cfif>
<cfoutput>

<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.countitemno#" />
</cfoutput>

