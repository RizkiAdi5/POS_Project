<cfquery name="getdecimal" datasource="#dts#">
SELECT Decl_Uprice,Decl_Discount FROM gsetup2
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select * from artran where type="INV" and fperiod="10"
</cfquery>

<cfloop query="getgroup">
<cfoutput>

<cfquery name="getdecimal" datasource="#dts#">
SELECT Decl_Uprice,Decl_Discount FROM gsetup2
</cfquery>
<cfquery name="recalculateictran" datasource="#dts#">
Update ictran set amt_bil = round(price_bil * qty_bil,#getdecimal.Decl_Uprice#)-disamt_bil WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
UPDATE ictran SET amt = amt_bil * currrate WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery name="getsum" datasource="#dts#">
SELECT refno,type,sum(amt_bil) as sumamt FROM ictran WHERE type = '#getgroup.type#' and refno='#getgroup.refno#' group by refno
</cfquery>

<cfquery name="updatesum" datasource="#dts#">
Update artran SET gross_bil = "#val(getsum.sumamt)#" WHERE type = '#getgroup.type#' and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getsum.refno#">
</cfquery>


<cfquery name="updategrand" datasource="#dts#">
UPDATE artran SET net_bil = gross_bil - disc_bil WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery name="updategrand2" datasource="#dts#">
Update artran SET 
grand_bil = if(taxincl = "T",net_bil+mc1_bil+mc2_bil+mc3_bil+mc4_bil+mc5_bil+mc6_bil+mc7_bil,round(net_bil + (net_bil * taxp1/100)+mc1_bil+mc2_bil+mc3_bil+mc4_bil+mc5_bil+mc6_bil+mc7_bil,#getdecimal.Decl_Uprice#)),
tax1_bil = if(taxincl = "T",round(net_bil * taxp1/(100+taxp1),#getdecimal.Decl_Uprice#), round(net_bil * taxp1/100,#getdecimal.Decl_Uprice#)),
tax_bil = if(taxincl = "T",round(net_bil * taxp1/(100+taxp1),#getdecimal.Decl_Uprice#), round(net_bil * taxp1/100,#getdecimal.Decl_Uprice#)) 
WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery name="updaterate" datasource="#dts#">
Update artran SET grand = grand_bil * currrate , net = net_bil * currrate, invgross = gross_bil * currrate, tax=tax_bil * currrate, tax1 = tax1_bil WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery datasource='#dts#' name="getartran">
select * from artran where type = '#getgroup.type#' and refno='#getgroup.refno#'
</cfquery>

<cfquery name='getgeneralinfo' datasource='#dts#'>
	select wpitemtax
	from gsetup
</cfquery>

<cfif getgeneralinfo.wpitemtax neq "Y" and val(getartran.invgross) neq 0>

    <cfif getartran.taxincl eq "T">

    <cfquery name="updatesum2" datasource="#dts#">
Update artran SET gross_bil = grand_bil-tax_bil+disc_bil-mc1_bil-mc2_bil-mc3_bil-mc4_bil-mc5_bil-mc6_bil-mc6_bil WHERE type = '#getgroup.type#' and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getsum.refno#">
    </cfquery>

    
<cfquery name="updaterate2" datasource="#dts#">
Update artran SET invgross = gross_bil * currrate WHERE 
type = '#getgroup.type#' and refno='#getgroup.refno#' 
</cfquery>

    <cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictran 
        set note_a='#getartran.note#',
        TAXPEC1='#getartran.taxp1#',
        TAXAMT_BIL=round((AMT_BIL/#val(getartran.net_bil)+val(getartran.disc_bil)#)*#val(getartran.tax1_bil)#,5),
        TAXAMT=round((AMT/#val(getartran.net)+val(getartran.discount)#)*#val(getartran.tax)#,5)
        type = '#getgroup.type#' and refno='#getgroup.refno#'
    </cfquery>
    <cfelse>
	<cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictran 
        set note_a='#getartran.note#',
        TAXPEC1='#getartran.taxp1#',
        TAXAMT_BIL=round((AMT_BIL/#val(getartran.gross_bil)#)*#val(getartran.tax1_bil)#,5),
        TAXAMT=round((AMT/#val(getartran.invgross)#)*#val(getartran.tax)#,5)
        type = '#getgroup.type#' and refno='#getgroup.refno#'
    </cfquery>
    </cfif>
</cfif>


   
</cfoutput>
</cfloop>
