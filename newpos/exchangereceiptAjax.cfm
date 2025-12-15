<cfset exchangerefno = URLDecode(url.exchangerefno)>
<cfset tran = URLDecode(url.tran)>
<cfset tranno = URLDecode(url.tranno)>
<cfset custno = URLDecode(url.custno)>
<cfset driver = URLDecode(url.driver)> 
<cfset rem9 = URLDecode(url.rem9)> 
<cfset uuid = URLDecode(url.uuid)>

<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior,branchpricelvl from gsetup
</cfquery>

<cfquery name="gettempitem" datasource="#dts#">
SELECT * FROM ictran WHERE refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#exchangerefno#"> and type="CS" ORDER BY TRANCODE
</cfquery>

<cfloop query="gettempitem">

<cfquery name="checkitemExist" datasource="#dts#">
    select 
    itemcount 
    from ictrantemp 
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
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
        '#gettempitem.itemno#', 
        '#REReplace(gettempitem.desp,"925925925925","%","ALL")#', 
        '', 
        '#gettempitem.location#',
        #numberformat(val(gettempitem.qty*-1),'._____')#,
        #numberformat(val(gettempitem.price),'.__')#, 
        '#unit#',
         #numberformat(val(gettempitem.amt*-1),'.__')#,
        #val(gettempitem.dispec1)#,
        #val(gettempitem.dispec2)#,
        #val(gettempitem.dispec3)#,
        #numberformat(val(gettempitem.disamt*-1),'._____')#,
        #numberformat(val(gettempitem.amt*-1),'.__')#, 
        '0',
        '',
        0.00000,
        #numberformat(val(gettempitem.qty*-1),'._____')#,
         #numberformat(val(gettempitem.price),'.__')#,
          '#unit#',
          '1',
           '1',
            #numberformat(val(gettempitem.amt*-1),'.__')#,
            #numberformat(val(gettempitem.disamt*-1),'._____')#,
            #numberformat(val(gettempitem.amt*-1),'.__')#,
            0.00000,
            '',
            '',
              '', 
              '0000-00-00', 
              '', 
              '', 
              '', 
              '#gettempitem.wos_group#', 
              '#gettempitem.category#', 
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
              ''
        )
</cfquery>

<cfset trancode = trancode+1>


</cfloop>

<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt1_bil) as sumsubtotal,count(itemno) as countitemno FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" />
</cfquery>

<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.countitemno#" />
</cfoutput>