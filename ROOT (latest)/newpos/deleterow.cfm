
<cfif isdefined('url.uuid') and isdefined('url.trancode')>
<cfset url.uuid = URLDECODE(url.uuid)>
<cfquery name="updaterow" datasource="#dts#">
DELETE FROM ictrantemp 
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfquery name="checkitemExist" datasource="#dts#">
select 
itemcount 
from ictrantemp 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>
<cfif checkitemExist.recordcount gt 0>
<cfset itemcountlist = valuelist(checkitemExist.itemcount)>

<cfloop index="i" from="1" to="#listlen(itemcountlist)#">
<cfif listgetat(itemcountlist,i) neq i>
<cfquery name="updateIctran" datasource="#dts#">
	update ictrantemp set 
	itemcount='#i#',
	trancode='#i#'
	where 
	uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
	and itemcount='#listgetat(itemcountlist,i)#';
</cfquery>

<cfquery name="updateiserial" datasource="#dts#">
	update iserialtemp set 
	trancode='#i#'
	where 
	uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
	and trancode='#listgetat(itemcountlist,i)#';
</cfquery>

</cfif>
</cfloop>
</cfif>


<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt1_bil) as sumsubtotal,count(trancode) as notran,sum(taxamt_bil) as sumtaxtotal FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#" />
</cfquery>

<cfif lcase(hcomid) eq "mika_i">
<cfquery name="gettotalmikaqty" datasource="#dts#">
	select sum(qty) as qty FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" /> and itemno in ('100001','100503','100504','100505','100506','100507','100511','100513','100518','100520','100521','100525','100527','100533','100502')
</cfquery>

<cfif gettotalmikaqty.qty gte 2>
<cfset mikafreeqty= int(gettotalmikaqty.qty/2)>

<cfquery name="checkmikafreeitem" datasource="#dts#">
	select itemno,type,refno,custno from ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" /> and itemno="110005"
</cfquery>

<cfif checkmikafreeitem.recordcount eq 0>
	<cfset trancode=getsum.notran+1>
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
        rem9
        )
        values
        (
        '#checkmikafreeitem.type#',
        '#checkmikafreeitem.refno#',
        '#checkmikafreeitem.custno#',
        #trancode#,#trancode#,
        '',
        '110005', 
        'RAISIN & CHOCO COOKIES', 
        '', 
        '',
        #numberformat(val(mikafreeqty),'._____')#,
        0, 
        'BOX',
        0,
        0,
        0,
        0,
        0,
        0, 
        '0',
        '',
        0.00000,
        #numberformat(val(mikafreeqty),'._____')#,
         0,
          'BOX',
          '1',
           '1',
            0,
            0,
            0,
            0.00000,
            '',
            '',
              '', 
              '0000-00-00', 
              '', 
              '', 
              '', 
              '', 
              '', 
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
              '',
              ''
        )
</cfquery>

<cfelse>
<cfquery name="updateictran" datasource="#dts#">
	update ictrantemp set qty="#val(mikafreeqty)#",qty_bil="#val(mikafreeqty)#"
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" /> and itemno="110005"
</cfquery>

</cfif>
<cfelse>
<cfquery name="updateictran" datasource="#dts#">
	delete from ictrantemp
    where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" /> and itemno="110005"
</cfquery>
</cfif>
</cfif>




<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hidtaxtotal" id="hidtaxtotal" value="#numberformat(getsum.sumtaxtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.notran#" />
</cfoutput>


</cfif>