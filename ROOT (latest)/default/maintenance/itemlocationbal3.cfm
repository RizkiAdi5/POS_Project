<html>
<head>
<title>Item Location Balance Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 

 group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>

<cfset i=1>

<cfquery name="getgsetup" datasource="#dts#">
	select *
	from gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
	select itemno,remark6,remark7,remark8,remark9,remark10,remark11 from icitem
	order by itemno
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ".">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<p align="center"><font color="##000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Item Location Balance Listing</strong></font></p>

<cfif getitem.recordCount neq 0>
	

	<table width="100%" border="0" class="" align="center">
		<tr>
			<td colspan="8"><hr></td>
		</tr>
	  	<tr>
    		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Item No</font></strong></td>
        	<td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">GWC</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">RF</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">PP</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">MBS</font></strong></td>
            <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Stock</font></strong></td>
			<td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">Warehouse</font></strong></td>
  		</tr>
  		<tr>
			<td colspan="8"><hr></td>
		</tr>

		<cfoutput query="getitem">
        <cfquery name="getitembalance" datasource="#dts#">
        select 
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
            and itemno='#getitem.itemno#' 
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
            and itemno='#getitem.itemno#' 
            and fperiod<>'99'
            and (void = '' or void is null)
            
            group by itemno
        ) as c on a.itemno=c.itemno
        
        where a.itemno='#getitem.itemno#' 
        and (a.itemtype <> 'SV' or a.itemtype is null)

        </cfquery>
  			<tr>
    			<td><div align="center">#i#</div></td>
   	 			<td>#itemno#</td>
    			<td align="center"><cfif getgsetup.ddllocation eq 'GWC'>#getitembalance.balance#<cfelse>#remark6#</cfif></td>
                <td align="center"><cfif getgsetup.ddllocation eq 'RF'>#getitembalance.balance#<cfelse>#remark7#</cfif></td>
                <td align="center"><cfif getgsetup.ddllocation eq 'PP'>#getitembalance.balance#<cfelse>#remark8#</cfif></td>
                <td align="center"><cfif getgsetup.ddllocation eq 'MBS'>#getitembalance.balance#<cfelse>#remark9#</cfif></td>
                <td align="center">#remark10#</td>
                <td align="center">#remark11#</td>
				
			</tr>
			<cfset i = incrementvalue(i)>
  		</cfoutput>
	</table>
<cfelse>
  	<h3><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.</font></h3>
</cfif>

<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>