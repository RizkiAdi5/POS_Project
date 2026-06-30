<cfscript>
/**
 * Menu data sourced from icitem (ITEMNO=item_code, DESP=display_name, CATEGORY, PRICE, plus e-menu columns)
 */
numeric function menuEffectivePrice(required numeric price, numeric promo_price) {
    var p = val(arguments.promo_price);
    if (p gt 0 and p lt val(arguments.price)) return p;
    return val(arguments.price);
}
boolean function menuHasPromo(required numeric price, numeric promo_price) {
    var p = val(arguments.promo_price);
    return p gt 0 and p lt val(arguments.price);
}
string function formatRupiah(required numeric amount) {
    return "Rp " & NumberFormat(arguments.amount, "999,999,999");
}
</cfscript>
<cfparam name="url.category" default="all">
<cfparam name="url.q" default="">
<cfset kw = trim(url.q)>
<cfset kwLike = "%" & lCase(kw) & "%">
<cfset qAppMenu = queryNew("menu_id,item_code,display_name,category,price,promo_price,image_url,has_img_blob,is_available")>
<cfset qMenuCats = queryNew("catname")>
<cfset availableMenuCount = 0>
<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qMenuCats" datasource="#dts#">
            SELECT DISTINCT CATEGORY AS catname FROM icitem WHERE is_avail = 'T' ORDER BY catname
        </cfquery>
        <cfquery name="qAppMenu" datasource="#dts#">
            SELECT ITEMNO AS item_code, ITEMNO AS menu_id, DESP AS display_name, CATEGORY AS category,
            PRICE AS price, promo_price, img_url AS image_url,
            CASE WHEN img_bytes IS NULL THEN 0 ELSE 1 END AS has_img_blob,
            is_avail AS is_available
            FROM icitem
            WHERE is_avail = 'T'
            <cfif len(kw)>
                AND (LOWER(DESP) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#kwLike#">
                OR LOWER(ITEMNO) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#kwLike#">)
            </cfif>
            <cfif url.category neq "all" AND len(trim(url.category))>
                AND CATEGORY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.category)#">
            </cfif>
            ORDER BY CATEGORY, DESP
        </cfquery>
        <cfquery name="qMenuStat" datasource="#dts#">
            SELECT COUNT(*) AS cnt FROM icitem WHERE is_avail = 'T'
        </cfquery>
        <cfset availableMenuCount = qMenuStat.cnt>
        <cfcatch type="any">
            <cfset qAppMenu = queryNew("menu_id,item_code,display_name,category,price,promo_price,image_url,has_img_blob,is_available")>
            <cfset qMenuCats = queryNew("catname")>
            <cfset availableMenuCount = 0>
        </cfcatch>
    </cftry>
</cfif>
<cfset menuCategories = ["All"]>
<cfloop query="qMenuCats">
    <cfset arrayAppend(menuCategories, catname)>
</cfloop>
