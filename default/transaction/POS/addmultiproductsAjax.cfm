<cfset tran = URLDecode(url.tran)>
<cfset tranno = URLDecode(url.tranno)>
<cfset custno = URLDecode(url.custno)>
<cfset uuid = URLDecode(url.uuid)>
<cfset trancode = URLDecode(url.trancode)>
<cfset location = URLDecode(url.location)>
<cfset driver = URLDecode(url.driver)>

<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior,branchpricelvl from gsetup
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfquery name="gettempitem" datasource="#dts#">
SELECT itemno FROM expresspickitem WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemlisting)#"> ORDER BY CREATED_ON DESC
</cfquery>

<cfloop query="gettempitem">
<cftry>
<cfset itemno = gettempitem.itemno>






<cfquery name="getproductdetail" datasource="#dts#">
select * from icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>

<cfif url.tran eq 'PO' or url.tran eq 'RC' or url.tran eq 'PR' or url.tran eq 'ISS'>
<cfset price = getproductdetail.ucost>
<cfelse>
<cfset price = getproductdetail.price>
</cfif>

<cfif checkenable.itempriceprior eq "2">
<cfquery name="getcustomerprice" datasource="#dts#">
select * from icl3p<cfif url.tran eq 'PO' or url.tran eq 'RC' or url.tran eq 'PR' or url.tran eq 'ISS'><cfelse>2</cfif> where itemno='#getproductdetail.itemno#' and custno='#custno#'
</cfquery>
<cfif getcustomerprice.recordcount neq 0>
<cfset price=getcustomerprice.price>
<cfset ucost=getcustomerprice.price>
</cfif>
</cfif>

<cfquery name="getbustype" datasource="#dts#">
SELECT business FROM #target_arcust#
    where custno='#custno#'
</cfquery>
<cfif getbustype.business neq "">
<cfquery name="getpricelvl" datasource="#dts#">
SELECT pricelvl FROM business where business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getbustype.business#">
</cfquery>

<cfif getpricelvl.pricelvl eq 2>
<cfset price = getproductdetail.price2>
<cfelseif getpricelvl.pricelvl eq 3>
<cfset price = getproductdetail.price3>
<cfelseif getpricelvl.pricelvl eq 4>
<cfset price = getproductdetail.price4>
<cfelse>
</cfif>
<cfelse>

</cfif>

<!---gsetup price--->

<cfif checkenable.branchpricelvl eq 2>
<cfset price = getproductdetail.price2>
<cfelseif checkenable.branchpricelvl eq 3>
<cfset price = getproductdetail.price3>
<cfelseif checkenable.branchpricelvl eq 4>
<cfset price = getproductdetail.price4>
<cfelseif checkenable.branchpricelvl eq 5>
<cfset price = getproductdetail.price5>
<cfelseif checkenable.branchpricelvl eq 6>
<cfset price = getproductdetail.price6>
<cfelse>
<cfset price = getproductdetail.price>
</cfif>


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


<cfset desp = getproductdetail.desp>
<cfset amt = price>
<cfset qty = 1>
<cfset unit = getproductdetail.unit>
<cfset dispec1 = 0>
<cfset dispec2 = 0>
<cfset dispec3 = 0>
<cfset dis = 0>
<cfset driver = ''> 
<cfset rem9 = ''> 



<cfquery name="validitemexist" datasource="#dts#">
SELECT trancode,itemno,qty_bil,price_bil 
FROM ictrantemp WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> and location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#location#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfif validitemexist.recordcount neq 0>
<cfelse>
<cfquery name="checkitemExist" datasource="#dts#">
    select 
    itemcount 
    from ictrantemp 
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="getitemdetail" datasource="#dts#">
    select 
    wos_group,category,costcode,custprice_rate,taxcode
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


<cfquery name="selecticitem" datasource="#dts#">
SELECT unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#" >
</cfquery>

<cfset qtyReal = qty>

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
        '',
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
              '', 
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

<cfif getgsetup.wpitemtax eq "1">
	<cfquery name="checktaxpercent" datasource="#dts#">
    select rate1 from #target_taxtable# where code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemdetail.taxcode#">
    </cfquery>

	<cfquery name="updateictrantax" datasource="#dts#">
	UPDATE ictrantemp
    	<cfif checktaxpercent.rate1 eq "0">
        set note_a="ZR",
        TAXPEC1=0,
        TAXAMT_BIL=0,
        TAXAMT=0
        <cfelse>
        set note_a=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getgsetup.df_salestax#">,
        TAXPEC1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(getgsetup.gst)#">,
        <cfif getgsetup.taxincluded eq "Y">
        TAXAMT_BIL=round((AMT_BIL*(#getgsetup.gst/(getgsetup.gst+100)#)),3),
        TAXAMT=round((AMT*(#getgsetup.gst/(getgsetup.gst+100)#)),3),
        taxincl="T"
        <cfelse>
        TAXAMT_BIL=round((AMT_BIL*(#getgsetup.gst/100#)),3),
        TAXAMT=round((AMT*(#getgsetup.gst/100#)),3)
        </cfif>
        </cfif>
        where 
        uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
        and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
	</cfquery>
</cfif>



<cfset trancode = trancode+1>

<cfcatch></cfcatch></cftry>

</cfloop>

<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt_bil) as sumsubtotal,count(itemno) as countitemno,sum(taxamt_bil) as sumtaxtotal FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" />
</cfquery>

<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hidtaxtotal" id="hidtaxtotal" value="#numberformat(getsum.sumtaxtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.countitemno#" />
</cfoutput>