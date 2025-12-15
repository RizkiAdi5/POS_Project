<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
and itemno='#url.itemno#' 
 group by frrefno
</cfquery>

<cfset billupdated=valuelist(getdoupdated.frrefno)>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
        select a.itemno,a.remark6,a.remark7,a.remark8,a.remark9,a.remark10,a.remark11,
        ifnull(b.sumtotalin,0) as qtyin,
        ifnull(c.sumtotalout,0) as qtyout,
        ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
        ifnull(a.qtybf,0) as openbal
        from icitem as a
        
        left join 
        (
            select itemno,sum(qty) as sumtotalin 
            from ictran 
            where type in ('RC','CN','OAI','TRIN') 
            and itemno='#url.itemno#' 
            and fperiod<>'99'
            and (void = '' or void is null)
            group by itemno
        ) as b on a.itemno=b.itemno
        
        left join 
        (
            select itemno,sum(qty) as sumtotalout 
            from ictran 
            where
            <cfif isdefined('form.dodate')>
                    (type in ('DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) or 
                    (type='INV' and (dono = "" or dono is null or dono not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">))))
                    <cfelse>
    
            type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
            and (toinv='' or toinv is null) 
            </cfif>
            and itemno='#url.itemno#' 
            and fperiod<>'99'
            and (void = '' or void is null)
            
            group by itemno
        ) as c on a.itemno=c.itemno
        
        where a.itemno='#url.itemno#' 
        and (a.itemtype <> 'SV' or a.itemtype is null)

        </cfquery>



  <cfoutput>
  <cfif getitem.recordcount eq 0>
  <h3>Item Not Found</h3>
  <cfelse>
  <table border="1" align="center" width="90%" class="data">
  <tr>
  <th width="30">Location</th>
  <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">GWC</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">RF</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">PP</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">MBS</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Stock</font></strong></td>
			<td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Warehouse</font></strong></td>
  </tr>
  <tr>
  <th>Qty</th>
  <cfloop query="getitem">
  <td align="center">#remark6#</td>
                <td align="center">#remark7#</td>
                <td align="center">#remark8#</td>
                <td align="center">#remark9#</td>
                <td align="center">#remark10#</td>
                <td align="center">#remark11#</td>
  </cfloop>
  
  </tr>
  </table>
  </cfif>
  </cfoutput>

