<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="false">
<!--- esc(v): short HTML-safe output (wraps HTMLEditFormat) --->
<cffunction name="esc" output="false" returntype="string">
    <cfargument name="v" required="false" default="">
    <cfset var s = "">
    <cfif NOT isNull(arguments.v)><cfset s = toString(arguments.v)></cfif>
    <cfreturn HTMLEditFormat(s)>
</cffunction>
<cfparam name="url.category" default="">
<cfparam name="url.q" default="">
<cfparam name="url.msg" default="">
<cfparam name="url.edit" default="">
<cfparam name="url.new" default="">
<cfset kw = trim(url.q)>
<cfset kwLike = "%" & lCase(kw) & "%">
<cfset flashMsg = "">
<cfif len(url.msg)><cfset flashMsg = url.msg></cfif>
<cfset flashErr = "">
<cfset promoCol = "">
<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qPromo" datasource="#dts#">
            SELECT COALESCE(
                MAX(CASE WHEN COLUMN_NAME = 'promo_price' THEN 'promo_price' END),
                MAX(CASE WHEN COLUMN_NAME = 'original_price' THEN 'original_price' END),
                ''
            ) AS promo_col
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'app_menu'
            AND COLUMN_NAME IN ('promo_price','original_price')
        </cfquery>
        <cfif qPromo.recordCount AND (qPromo.promo_col eq "promo_price" OR qPromo.promo_col eq "original_price")>
            <cfset promoCol = qPromo.promo_col>
        </cfif>
        <cfcatch type="any">
            <cftry>
                <cfquery name="qTryPromo" datasource="#dts#">SELECT promo_price FROM app_menu LIMIT 1</cfquery>
                <cfset promoCol = "promo_price">
                <cfcatch type="any">
                    <cftry>
                        <cfquery name="qTryOrig" datasource="#dts#">SELECT original_price FROM app_menu LIMIT 1</cfquery>
                        <cfset promoCol = "original_price">
                        <cfcatch type="any"><cfset promoCol = ""></cfcatch>
                    </cftry>
                </cfcatch>
            </cftry>
        </cfcatch>
    </cftry>
</cfif>
<cfset blobCols = false>
<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qBlob" datasource="#dts#">
            SELECT COUNT(*) AS colcnt FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'app_menu'
            AND COLUMN_NAME IN ('image_bytes','image_type')
        </cfquery>
        <cfif qBlob.recordCount AND val(qBlob.colcnt) gte 2><cfset blobCols = true></cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<cfif isDefined("form.form_action") AND form.form_action eq "delete" AND isNumeric(form.menu_id) AND isDefined("dts") AND len(trim(dts))>
    <cfset rtCat = ""><cfif structKeyExists(form, "rt_category")><cfset rtCat = form.rt_category></cfif>
    <cfset rtQ = ""><cfif structKeyExists(form, "rt_q")><cfset rtQ = form.rt_q></cfif>
    <cftry>
        <cfquery datasource="#dts#">DELETE FROM app_menu WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.menu_id)#"></cfquery>
        <cfset flashMsg = "deleted">
        <cfcatch type="any"><cfset flashMsg = ""><cfset flashErr = "Delete failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400)></cfcatch>
    </cftry>
    <cfif len(flashErr)>
        <cflocation url="Menu.cfm?err=#URLEncodedFormat(flashErr)#&category=#URLEncodedFormat(rtCat)#&q=#URLEncodedFormat(rtQ)#" addtoken="false">
    <cfelse>
        <cflocation url="Menu.cfm?msg=#URLEncodedFormat(flashMsg)#&category=#URLEncodedFormat(rtCat)#&q=#URLEncodedFormat(rtQ)#" addtoken="false">
    </cfif>
</cfif>

<cfif isDefined("form.form_action") AND (form.form_action eq "save_insert" OR form.form_action eq "save_update") AND isDefined("dts") AND len(trim(dts))>
    <cfset rtCat = ""><cfif structKeyExists(form, "rt_category")><cfset rtCat = form.rt_category></cfif>
    <cfset rtQ = ""><cfif structKeyExists(form, "rt_q")><cfset rtQ = form.rt_q></cfif>
    <cfset itemCode = left(trim(form.item_code), 60)>
    <cfset displayName = left(trim(form.display_name), 100)>
    <cfset categoryVal = left(trim(form.category), 50)>
    <cfset preserveUrl = "">
    <cfif structKeyExists(form, "image_url_preserve")><cfset preserveUrl = left(trim(toString(form.image_url_preserve)), 500)></cfif>
    <cfset priceVal = val(form.price)>
    <cfset promoStr = trim(form.promo_price)>
    <cfset promoEmpty = (NOT len(promoStr) OR NOT isNumeric(promoStr) OR val(promoStr) eq 0)>
    <cfset isAvail = 0>
    <cfif structKeyExists(form, "is_available") AND form.is_available eq "1"><cfset isAvail = 1></cfif>
    <cfif len(itemCode) eq 0 OR len(displayName) eq 0 OR len(categoryVal) eq 0>
        <cfset flashErr = "item_code, display_name, and category are required.">
    <cfelseif NOT len(trim(form.price)) OR NOT isNumeric(trim(form.price))>
        <cfset flashErr = "Price is required (numeric).">
    <cfelseif priceVal lt 0>
        <cfset flashErr = "Price is not valid.">
    <cfelse>
        <cfset imgBytes = "">
        <cfset imgMime = "">
        <cfset hasNewUpload = false>
        <cfset clearImage = false>
        <cfif blobCols>
            <cfset clearImage = structKeyExists(form, "clear_stored_image") AND trim(toString(form.clear_stored_image)) eq "1">
            <cftry>
                <cffile action="upload" filefield="menu_image" destination="#GetTempDirectory()#" nameconflict="makeunique" accept="image/gif,image/jpeg,image/jpg,image/pjpeg,image/png,image/x-png,image/webp">
                <cfset upPath = cffile.serverDirectory & "/" & cffile.serverFile>
                <cfif val(cffile.fileSize) lte 2097152 AND val(cffile.fileSize) gt 0>
                    <cfset imgBytes = fileReadBinary(upPath)>
                    <cfset uploadByteLen = 0>
                    <cftry><cfset uploadByteLen = len(imgBytes)><cfcatch type="any"><cfset uploadByteLen = 0></cfcatch></cftry>
                    <cfif val(uploadByteLen) gt 0>
                        <cfset ext = lCase(listLast(cffile.clientFile, "."))>
                        <cfset imgMime = "image/jpeg">
                        <cfif ext eq "png"><cfset imgMime = "image/png"></cfif>
                        <cfif ext eq "gif"><cfset imgMime = "image/gif"></cfif>
                        <cfif ext eq "webp"><cfset imgMime = "image/webp"></cfif>
                        <cfset hasNewUpload = true>
                        <cfset preserveUrl = "">
                    </cfif>
                </cfif>
                <cftry><cffile action="delete" file="#upPath#"><cfcatch type="any"></cfcatch></cftry>
                <cfcatch type="any"></cfcatch>
            </cftry>
        </cfif>
        <cftry>
            <cfif form.form_action eq "save_insert">
                <cfquery name="qDup" datasource="#dts#">SELECT menu_id FROM app_menu WHERE item_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemCode#"></cfquery>
                <cfif qDup.recordCount gt 0>
                    <cfset flashErr = "item_code is already in use.">
                <cfelse>
                    <cfquery datasource="#dts#">
                        INSERT INTO app_menu (item_code, display_name, category, price<cfif len(promoCol)>, #promoCol#</cfif>, image_url<cfif blobCols>, image_bytes, image_type</cfif>, is_available) VALUES (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemCode#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#displayName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryVal#">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#priceVal#">
                        <cfif len(promoCol)>,<cfif promoEmpty>NULL<cfelse><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(promoStr)#"></cfif></cfif>,
                        <cfif hasNewUpload>NULL<cfelseif len(trim(preserveUrl))><cfqueryparam cfsqltype="cf_sql_varchar" value="#preserveUrl#"><cfelse>NULL</cfif>,
                        <cfif blobCols><cfif hasNewUpload><cfqueryparam cfsqltype="cf_sql_blob" value="#imgBytes#"><cfelse>NULL</cfif>,<cfif hasNewUpload><cfqueryparam cfsqltype="cf_sql_varchar" value="#imgMime#"><cfelse>NULL</cfif>,</cfif>
                        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#isAvail#">)
                    </cfquery>
                    <cfset flashMsg = "saved">
                </cfif>
            <cfelse>
                <cfif NOT isNumeric(form.menu_id)>
                    <cfset flashErr = "Invalid ID.">
                <cfelse>
                    <cfquery name="qDup2" datasource="#dts#">SELECT menu_id FROM app_menu WHERE item_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemCode#"> AND menu_id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.menu_id)#"></cfquery>
                    <cfif qDup2.recordCount gt 0>
                        <cfset flashErr = "item_code conflicts with another row.">
                    <cfelse>
                        <cfquery datasource="#dts#">
                            UPDATE app_menu SET
                            item_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemCode#">,
                            display_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#displayName#">,
                            category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryVal#">,
                            price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#priceVal#">
                            <cfif len(promoCol)>, #promoCol# = <cfif promoEmpty>NULL<cfelse><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(promoStr)#"></cfif></cfif>,
                            image_url = <cfif hasNewUpload>NULL<cfelseif len(trim(preserveUrl))><cfqueryparam cfsqltype="cf_sql_varchar" value="#preserveUrl#"><cfelse>NULL</cfif>,
                            <cfif blobCols AND hasNewUpload>image_bytes = <cfqueryparam cfsqltype="cf_sql_blob" value="#imgBytes#">, image_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#imgMime#">,</cfif>
                            <cfif blobCols AND clearImage AND NOT hasNewUpload>image_bytes = NULL, image_type = NULL,</cfif>
                            is_available = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#isAvail#">
                            WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.menu_id)#">
                        </cfquery>
                        <cfset flashMsg = "saved">
                    </cfif>
                </cfif>
            </cfif>
            <cfcatch type="any"><cfset flashErr = "Save failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400)></cfcatch>
        </cftry>
    </cfif>
    <cfif len(flashErr)>
        <cfset eurl = "Menu.cfm?err=" & URLEncodedFormat(flashErr)>
        <cfif structKeyExists(form, "menu_id") AND isNumeric(form.menu_id)><cfset eurl = eurl & "&edit=" & val(form.menu_id)></cfif>
        <cfif structKeyExists(form, "rt_new") AND form.rt_new eq "1"><cfset eurl = eurl & "&new=1"></cfif>
        <cfset eurl = eurl & "&category=" & URLEncodedFormat(rtCat) & "&q=" & URLEncodedFormat(rtQ)>
        <cflocation url="#eurl#" addtoken="false">
    <cfelse>
        <cflocation url="Menu.cfm?msg=#URLEncodedFormat(flashMsg)#&category=#URLEncodedFormat(rtCat)#&q=#URLEncodedFormat(rtQ)#" addtoken="false">
    </cfif>
</cfif>

<cfif isDefined("url.action") AND url.action eq "toggle" AND isNumeric(url.menu_id) AND isDefined("dts") AND len(trim(dts))>
    <cfquery name="qCur" datasource="#dts#">SELECT is_available FROM app_menu WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.menu_id)#"></cfquery>
    <cfif qCur.recordCount eq 1>
        <cfset newv = 0><cfif qCur.is_available neq 1><cfset newv = 1></cfif>
        <cfquery datasource="#dts#">UPDATE app_menu SET is_available = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#newv#"> WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.menu_id)#"></cfquery>
    </cfif>
    <cflocation url="Menu.cfm?category=#URLEncodedFormat(url.category)#&q=#URLEncodedFormat(url.q)#" addtoken="false">
</cfif>

<cfset qList = queryNew("menu_id")>
<cfset qCats = queryNew("catname")>
<cfset qErr = "">
<cfset qRow = queryNew("menu_id")>
<cfset showForm = false>
<cfset isNew = false>
<cfif url.new eq "1"><cfset showForm = true><cfset isNew = true></cfif>
<cfif isNumeric(url.edit) AND val(url.edit) gt 0><cfset showForm = true><cfset isNew = false></cfif>
<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qCats" datasource="#dts#">SELECT DISTINCT category AS catname FROM app_menu ORDER BY catname</cfquery>
        <cfif showForm AND NOT isNew>
            <cfquery name="qRow" datasource="#dts#">
                SELECT menu_id, item_code, display_name, category, price,
                <cfif promoCol eq "promo_price">promo_price<cfelseif promoCol eq "original_price">original_price AS promo_price<cfelse>NULL AS promo_price</cfif>,
                image_url,
                <cfif blobCols>CASE WHEN image_bytes IS NULL THEN 0 ELSE 1 END AS has_img_blob<cfelse>0 AS has_img_blob</cfif>,
                is_available FROM app_menu WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.edit)#">
            </cfquery>
            <cfif qRow.recordCount eq 0><cfset showForm = false><cfset flashErr = "Record not found."></cfif>
        </cfif>
        <cfif NOT showForm>
            <cfquery name="qList" datasource="#dts#">
                SELECT menu_id, item_code, display_name, category, price,
                <cfif promoCol eq "promo_price">promo_price<cfelseif promoCol eq "original_price">original_price AS promo_price<cfelse>NULL AS promo_price</cfif>,
                image_url,
                <cfif blobCols>CASE WHEN image_bytes IS NULL THEN 0 ELSE 1 END AS has_img_blob<cfelse>0 AS has_img_blob</cfif>,
                is_available FROM app_menu WHERE 1=1
                <cfif len(trim(url.category))>AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.category)#"></cfif>
                <cfif len(kw)>AND (LOWER(display_name) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#kwLike#"> OR LOWER(item_code) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#kwLike#">)</cfif>
                ORDER BY category, display_name
            </cfquery>
        </cfif>
        <cfcatch type="any"><cfset qErr = "app_menu query failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400)></cfcatch>
    </cftry>
</cfif>
<cfif isDefined("url.err") AND len(trim(url.err))><cfset flashErr = trim(url.err)></cfif>
<cfset htmlQ = esc(url.q)>
<cfset htmlCat = esc(url.category)>
<cfset imgVer = GetTickCount()>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>E-Menu admin — app_menu</title>
<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
<style type="text/css">
body { font-family: "Segoe UI", Arial, sans-serif; background:##ededed; color:##1D2835; margin: 0; padding: 16px 12px 40px; }
a { color: ##f0606d; text-decoration: none; }
a:hover { color: ##d04050; text-decoration: underline; }
.container { max-width: 1180px; }
.waiter-page-head { display: flex; flex-wrap: wrap; align-items: flex-end; justify-content: space-between; gap: 12px 16px; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 3px solid ##f0606d; }
.waiter-page-title { font-size: 22px; font-weight: 600; margin: 0; line-height: 1.25; }
.waiter-page-head .waiter-page-actions { flex-shrink: 0; }
.waiter-page-head .waiter-page-actions .btn { vertical-align: middle; }
.waiter-muted { color: ##666; font-size: 14px; margin: 0 0 14px; }
.waiter-panel { background:##fff; border: 1px solid ##ddd; border-radius: 6px; padding: 20px 22px; margin-bottom: 18px; box-shadow: 0 1px 3px rgba(0,0,0,.06); }
.waiter-panel-title { font-size: 16px; font-weight: 600; margin: 0 0 18px; padding-bottom: 10px; border-bottom: 1px solid ##eee; color: ##333; }
.btn-brand { background-color: ##f0606d !important; border-color: ##d85563 !important; color: ##fff !important; }
.btn-brand:hover, .btn-brand:focus { background-color: ##e55563 !important; border-color: ##c84855 !important; color: ##fff !important; }
.waiter-table { margin-bottom: 0; }
.waiter-table > thead > tr > th { white-space: nowrap; background: ##f8f8f8; font-size: 12px; text-transform: uppercase; letter-spacing: .02em; color: ##555; vertical-align: middle !important; padding: 10px 8px !important; text-align: center !important; }
.waiter-table > tbody > tr > td { vertical-align: middle !important; padding: 10px 8px !important; }
.waiter-table .waiter-col-id { width: 52px; text-align: center; }
.waiter-table .waiter-col-photo { width: 72px; text-align: center; }
.waiter-table .waiter-col-flag { width: 72px; text-align: center; }
.waiter-table .waiter-col-actions { width: 1%; text-align: center; white-space: nowrap; }
.waiter-table .waiter-col-code { white-space: nowrap; }
.waiter-table .text-right { font-variant-numeric: tabular-nums; }
.waiter-thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; border: 1px solid ##ddd; background: ##f5f5f5; vertical-align: middle; display: inline-block; }
.waiter-thumb-zoom { cursor: zoom-in; transition: box-shadow .15s ease, opacity .15s ease; }
.waiter-thumb-zoom:hover { box-shadow: 0 2px 10px rgba(0,0,0,.15); opacity: 0.95; }
.waiter-img-preview { max-width: 200px; max-height: 200px; width: auto; height: auto; object-fit: contain; border-radius: 8px; border: 1px solid ##e2e6ea; display: none; cursor: zoom-in; vertical-align: top; background: ##fff; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
.waiter-upload-zone { margin: 0; padding: 0; border: none; background: transparent; }
.waiter-upload-card { border: 2px dashed ##cfd6df; border-radius: 10px; background: linear-gradient(165deg, ##fafbfd 0%, ##fff 55%); padding: 20px 22px; box-shadow: inset 0 1px 0 rgba(255,255,255,.8); }
.waiter-upload-inner { display: flex; flex-wrap: wrap; align-items: stretch; gap: 22px; }
.waiter-upload-main { flex: 1 1 220px; min-width: 0; text-align: center; }
.waiter-upload-icon { font-size: 36px; color: ##c5cbd4; display: block; margin-bottom: 8px; line-height: 1; }
.waiter-upload-title { font-size: 15px; font-weight: 600; color: ##333; margin: 0 0 6px; }
.waiter-upload-hint { font-size: 12px; color: ##777; margin: 0 0 14px; line-height: 1.45; }
.waiter-file-input { position: absolute !important; width: 1px !important; height: 1px !important; padding: 0 !important; margin: -1px !important; overflow: hidden !important; clip: rect(0,0,0,0) !important; border: 0 !important; }
.waiter-file-btn { margin-bottom: 8px; }
.waiter-file-name { display: block; font-size: 12px; color: ##888; margin-top: 4px; word-break: break-all; min-height: 1.2em; }
.waiter-upload-preview-col { flex: 0 0 220px; max-width: 100%; text-align: center; padding: 12px 10px; background: ##fff; border-radius: 8px; border: 1px solid ##e8eaed; }
.waiter-preview-caption { margin: 0 0 10px; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: .04em; color: ##888; }
.waiter-upload-zone .checkbox-inline { margin-top: 12px; }
.waiter-category-wrap { max-width: 100%; }
.waiter-category-wrap select.form-control { width: 100% !important; max-width: 100%; }
.waiter-category-wrap .form-control { width: 100% !important; max-width: 100%; }
.waiter-category-sub { margin: 8px 0 0; font-size: 12px; }
.waiter-category-sub .btn-link { padding-left: 0; }
#imgZoomContent { max-width: 100%; max-height: 85vh; border-radius: 4px; }
.waiter-actions { white-space: nowrap; }
.waiter-actions .btn { margin: 0 2px; vertical-align: middle; }
.waiter-actions form { display: inline-block; vertical-align: middle; margin: 0; }
.waiter-form-horizontal .form-group { margin-bottom: 16px; }
.waiter-form-horizontal .control-label { font-weight: 600; color: ##444; }
.waiter-form-actions { margin-top: 6px; padding-top: 16px; border-top: 1px solid ##eee; }
.waiter-form-actions .btn { margin-right: 8px; }
.waiter-filter-form .form-group { margin-bottom: 0; width: 100%; max-width: 100%; }
.waiter-filter-form label { display: block; font-weight: 600; font-size: 12px; color: ##555; margin-bottom: 6px; }
.waiter-filter-form .form-control { width: 100%; max-width: 100%; box-sizing: border-box; }
.waiter-filter-form select.form-control { width: 100% !important; max-width: 100%; min-width: 0; display: block; height: auto; }
.waiter-filter-spacer { visibility: hidden; display: block; margin-bottom: 6px; line-height: 1.42; min-height: 1.42em; }
.waiter-filter-toolbar { margin: 0; }
.waiter-filter-toolbar .btn { margin: 0 8px 0 0; }
.waiter-filter-toolbar .btn:last-child { margin-right: 0; }
.waiter-filter-row > [class*="col-"] { margin-bottom: 12px; }
.waiter-filter-row > [class*="col-"]:last-child { margin-bottom: 0; }
@media (min-width: 992px) {
  .waiter-filter-row > [class*="col-"] { margin-bottom: 0; }
}
.alert { margin-bottom: 14px; }
</style>
</head>
<body>
<cfoutput>
<div class="container">
    <div class="waiter-page-head">
        <h1 class="waiter-page-title">Menu catalog</h1>
        <cfif showForm>
            <div class="waiter-page-actions">
                <a href="Menu.cfm?category=#URLEncodedFormat(url.category)#&amp;q=#URLEncodedFormat(url.q)#" class="btn btn-default btn-sm">&laquo; Back to list</a>
            </div>
        </cfif>
    </div>
    <cfif flashMsg eq "saved"><div class="alert alert-success">Saved successfully.</div></cfif>
    <cfif flashMsg eq "deleted"><div class="alert alert-success">Row deleted.</div></cfif>
    <cfif len(flashErr)><div class="alert alert-danger">#esc(flashErr)#</div></cfif>
    <cfif len(qErr)><div class="alert alert-warning">#esc(qErr)#</div></cfif>

    <cfif showForm>
        <cfset f = structNew()>
        <cfif isNew>
            <cfset f.menu_id = ""><cfset f.item_code = ""><cfset f.display_name = ""><cfset f.category = ""><cfset f.price = ""><cfset f.promo_price = ""><cfset f.image_url = ""><cfset f.is_available = 1><cfset f.has_img_blob = 0>
        <cfelse>
            <cfset f.menu_id = qRow.menu_id><cfset f.item_code = qRow.item_code><cfset f.display_name = qRow.display_name><cfset f.category = qRow.category><cfset f.price = qRow.price>
            <cfset f.promo_price = ""><cfif isNumeric(qRow.promo_price) AND val(qRow.promo_price) gt 0><cfset f.promo_price = qRow.promo_price></cfif>
            <cfset f.image_url = qRow.image_url><cfset f.is_available = qRow.is_available><cfset f.has_img_blob = val(qRow.has_img_blob)>
        </cfif>
        <cfset catTrim = trim(f.category)>
        <cfset catInList = false>
        <cfif len(catTrim)>
            <cfloop query="qCats"><cfif trim(catname) eq catTrim><cfset catInList = true><cfbreak></cfif></cfloop>
        </cfif>
        <cfset showCategorySelect = (NOT len(catTrim)) OR catInList>
        <div class="waiter-panel">
        <h2 class="waiter-panel-title"><cfif isNew>New menu item<cfelse>Edit menu — ID #val(f.menu_id)#</cfif></h2>
        <form method="post" action="Menu.cfm" class="form-horizontal waiter-form-horizontal" enctype="multipart/form-data">
            <input type="hidden" name="rt_category" value="#htmlCat#" />
            <input type="hidden" name="rt_q" value="#htmlQ#" />
            <input type="hidden" name="rt_new" value="<cfif isNew>1<cfelse>0</cfif>" />
            <cfif NOT isNew><input type="hidden" name="menu_id" value="#f.menu_id#" /><input type="hidden" name="image_url_preserve" value="#esc(f.image_url)#" /></cfif>
            <input type="hidden" name="form_action" value="<cfif isNew>save_insert<cfelse>save_update</cfif>" />
            <div class="form-group">
                <label class="col-sm-3 control-label" for="wf_item_code">item_code <small class="text-muted">(max 60)</small></label>
                <div class="col-sm-9"><input type="text" name="item_code" id="wf_item_code" maxlength="60" required="required" value="#esc(f.item_code)#" class="form-control" /></div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="wf_display_name">display_name</label>
                <div class="col-sm-9"><input type="text" name="display_name" id="wf_display_name" maxlength="100" required="required" value="#esc(f.display_name)#" class="form-control" /></div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="category_preset">category</label>
                <div class="col-sm-9">
                    <div class="waiter-category-wrap">
                        <div id="category_select_block"<cfif NOT showCategorySelect> class="hide"</cfif>>
                            <label class="sr-only" for="category_preset">Choose category from list</label>
                            <select id="category_preset" class="form-control" title="Categories"<cfif showCategorySelect> name="category" required="required"</cfif><cfif NOT showCategorySelect> disabled="disabled"</cfif>>
                                <option value="">Select category…</option>
                                <cfloop query="qCats"><option value="#esc(catname)#"<cfif showCategorySelect AND len(catTrim) AND catTrim eq trim(catname)> selected="selected"</cfif>>#esc(catname)#</option></cfloop>
                                <option value="__NEW__">+ Type a new category…</option>
                            </select>
                        </div>
                        <div id="category_text_block"<cfif showCategorySelect> class="hide"</cfif>>
                            <label class="sr-only" for="wf_category_text">Category name</label>
                            <input type="text" id="wf_category_text" maxlength="50" value="#esc(f.category)#" class="form-control" placeholder="Category name" autocomplete="off"<cfif NOT showCategorySelect> name="category" required="required"</cfif><cfif showCategorySelect> disabled="disabled"</cfif> />
                            <p class="waiter-category-sub"><button type="button" class="btn btn-link btn-sm" id="btn_category_from_list">&larr; Choose from list</button></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="wf_price">price</label>
                <div class="col-sm-9">
                    <input type="number" name="price" id="wf_price" step="0.01" min="0" required="required" value="#esc(f.price)#" class="form-control" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="wf_promo">Promo price</label>
                <div class="col-sm-9">
                    <input type="number" name="promo_price" id="wf_promo" step="0.01" min="0" value="#esc(f.promo_price)#" class="form-control" placeholder="Optional" />
                    <p class="help-block" style="margin-top:8px;margin-bottom:0;">Leave empty if there is no promo price.</p>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Image</label>
                <div class="col-sm-9">
                    <div class="waiter-upload-zone">
                    <cfif blobCols>
                        <div class="waiter-upload-card">
                            <div class="waiter-upload-inner">
                                <div class="waiter-upload-main">
                                    <p class="waiter-upload-hint">JPG, PNG, GIF or WebP · max 2 MB · stored in the database</p>
                                    <input type="file" name="menu_image" id="menu_image" accept="image/jpeg,image/png,image/gif,image/webp" class="waiter-file-input" />
                                    <label for="menu_image" class="btn btn-default waiter-file-btn"><span class="glyphicon glyphicon-upload"></span> Choose file</label>
                                    <span id="menu_image_name" class="waiter-file-name"></span>
                                    <cfif NOT isNew AND f.has_img_blob eq 1>
                                        <div>
                                            <label class="checkbox-inline" style="font-weight:normal;padding-left:0;"><input type="checkbox" name="clear_stored_image" value="1" style="margin-top:2px;" /> Remove image from database</label>
                                        </div>
                                    </cfif>
                                </div>
                                <div class="waiter-upload-preview-col">
                                    <p class="waiter-preview-caption">Preview · click to enlarge</p>
                                    <img id="imgPreview" class="waiter-img-preview waiter-thumb-zoom" alt="Preview" title="Click to enlarge"
                                        <cfif NOT isNew AND f.has_img_blob eq 1> src="MenuImage.cfm?id=#val(f.menu_id)#&amp;v=#imgVer#" data-fullsrc="MenuImage.cfm?id=#val(f.menu_id)#&amp;v=#imgVer#" style="display:inline-block;"
                                        <cfelseif len(trim(f.image_url))> src="#xmlFormat(trim(f.image_url))#" data-fullsrc="#xmlFormat(trim(f.image_url))#" style="display:inline-block;"
                                        <cfelse> src="" data-fullsrc="" style="display:none;"</cfif> />
                                </div>
                            </div>
                        </div>
                    <cfelse>
                        <div class="waiter-upload-card">
                            <p class="help-block text-warning" style="margin:0;">Columns <code>image_bytes</code> / <code>image_type</code> are missing. Run <code>CustomerView/menu_image_blob_alter.sql</code> then reload.</p>
                        </div>
                    </cfif>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="wf_is_available">Status</label>
                <div class="col-sm-9">
                    <div class="checkbox" style="margin-top:0;padding-top:7px;">
                        <label style="font-weight:normal;padding-left:0;margin-left:0;">
                            <input type="checkbox" name="is_available" id="wf_is_available" value="1" <cfif f.is_available eq 1>checked="checked"</cfif> /> Available
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group waiter-form-actions">
                <div class="col-sm-offset-3 col-sm-9">
                    <button type="submit" class="btn btn-brand">Save</button>
                    <a href="Menu.cfm?category=#URLEncodedFormat(url.category)#&amp;q=#URLEncodedFormat(url.q)#" class="btn btn-default">Cancel</a>
                </div>
            </div>
        </form>
        </div>
    <cfelse>
        <div class="waiter-panel">
        <form method="get" action="Menu.cfm" class="form waiter-filter-form">
            <div class="row waiter-filter-row">
                <div class="col-lg-4 col-md-4 col-sm-6">
                    <div class="form-group">
                        <label for="fcat">Category</label>
                        <select name="category" id="fcat" class="form-control">
                            <option value="">All categories</option>
                            <cfloop query="qCats"><option value="#esc(catname)#"<cfif trim(url.category) eq trim(catname)> selected="selected"</cfif>>#esc(catname)#</option></cfloop>
                        </select>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-6">
                    <div class="form-group">
                        <label for="fq">Search</label>
                        <input type="text" name="q" id="fq" value="#htmlQ#" placeholder="Name or code" class="form-control" autocomplete="off" />
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-12">
                    <div class="form-group">
                        <span class="waiter-filter-spacer" aria-hidden="true">&nbsp;</span>
                        <div class="btn-toolbar waiter-filter-toolbar" role="toolbar">
                            <button type="submit" class="btn btn-brand">Apply</button>
                            <a href="Menu.cfm" class="btn btn-default">Reset</a>
                            <a href="Menu.cfm?new=1" class="btn btn-brand">+ New</a>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        </div>
        <div class="waiter-panel table-responsive">
            <table class="table table-striped table-bordered table-hover table-condensed waiter-table">
                <thead>
                    <tr>
                        <th class="waiter-col-id text-center">ID</th>
                        <th class="waiter-col-photo text-center">Photo</th>
                        <th class="waiter-col-code text-center">item_code</th>
                        <th class="text-center">display_name</th>
                        <th class="text-center">category</th>
                        <th class="text-center">price</th>
                        <th class="text-center">promo</th>
                        <th class="waiter-col-flag text-center">Active</th>
                        <th class="waiter-col-actions text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfif qList.recordCount eq 0>
                        <tr><td colspan="9" class="text-center text-muted">No rows to display.</td></tr>
                    <cfelse>
                        <cfloop query="qList">
                            <tr>
                                <td class="waiter-col-id text-muted"><small>#menu_id#</small></td>
                                <td class="waiter-col-photo">
                                    <cfif blobCols AND val(has_img_blob) eq 1>
                                        <img class="waiter-thumb waiter-thumb-zoom" src="MenuImage.cfm?id=#menu_id#&amp;v=#imgVer#" data-fullsrc="MenuImage.cfm?id=#menu_id#&amp;v=#imgVer#" alt="" title="Click to enlarge" />
                                    <cfelseif len(trim(toString(image_url)))>
                                        <img class="waiter-thumb waiter-thumb-zoom" src="#xmlFormat(trim(image_url))#" data-fullsrc="#xmlFormat(trim(image_url))#" alt="" title="Click to enlarge" onerror="this.style.visibility='hidden';" />
                                    <cfelse>
                                        <span class="text-muted">&mdash;</span>
                                    </cfif>
                                </td>
                                <td class="waiter-col-code"><code>#esc(item_code)#</code></td>
                                <td>#esc(display_name)#</td>
                                <td>#esc(category)#</td>
                                <td class="text-right">#NumberFormat(price, "9,999.99")#</td>
                                <td class="text-right text-muted"><cfif val(promo_price) gt 0>#NumberFormat(promo_price, "9,999.99")#<cfelse>&mdash;</cfif></td>
                                <td class="waiter-col-flag"><cfif is_available eq 1><span class="label label-success">Yes</span><cfelse><span class="label label-default">No</span></cfif></td>
                                <td class="waiter-col-actions waiter-actions">
                                    <a href="Menu.cfm?edit=#menu_id#&amp;category=#URLEncodedFormat(url.category)#&amp;q=#URLEncodedFormat(url.q)#" class="btn btn-default btn-xs" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a>
                                    <a href="Menu.cfm?action=toggle&amp;menu_id=#menu_id#&amp;category=#URLEncodedFormat(url.category)#&amp;q=#URLEncodedFormat(url.q)#" class="btn btn-default btn-xs" title="<cfif is_available eq 1>Deactivate<cfelse>Activate</cfif>"><span class="glyphicon <cfif is_available eq 1>glyphicon-ban-circle<cfelse>glyphicon-ok-circle</cfif>"></span></a>
                                    <form method="post" action="Menu.cfm" style="display:inline;">
                                        <input type="hidden" name="form_action" value="delete" />
                                        <input type="hidden" name="menu_id" value="#menu_id#" />
                                        <input type="hidden" name="rt_category" value="#htmlCat#" />
                                        <input type="hidden" name="rt_q" value="#htmlQ#" />
                                        <button type="submit" class="btn btn-default btn-xs text-danger" title="Delete" onclick="return confirm('Delete this row?');"><span class="glyphicon glyphicon-trash"></span></button>
                                    </form>
                                </td>
                            </tr>
                        </cfloop>
                    </cfif>
                </tbody>
            </table>
        </div>
    </cfif>
</div>
</cfoutput>
<div class="modal fade" id="imgZoomModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Image</h4>
            </div>
            <div class="modal-body text-center" style="padding:20px;">
                <img id="imgZoomContent" src="" alt="" />
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript">
(function($){
  function showPreview(src) {
    var $p = $("#imgPreview");
    if (!src) { $p.attr("src", "").attr("data-fullsrc", "").css("display", "none"); return; }
    $p.attr("src", src).attr("data-fullsrc", src).off("error.preview").on("error.preview", function() { $(this).css("display", "none"); }).css("display", "inline-block");
  }
  function openZoom(src) {
    if (!src) return;
    $("#imgZoomContent").attr("src", src);
    $("#imgZoomModal").modal("show");
  }
  function categoryToTextMode(clear) {
    var $s = $("#category_preset"), $t = $("#wf_category_text");
    $("#category_select_block").addClass("hide");
    $("#category_text_block").removeClass("hide");
    $s.prop("disabled", true).removeAttr("name").removeAttr("required");
    $t.prop("disabled", false).attr("name", "category").attr("required", "required");
    if (clear) $t.val("");
    $t.focus();
  }
  function categoryToListMode() {
    var $s = $("#category_preset"), $t = $("#wf_category_text");
    var tv = $.trim($t.val());
    if (tv) {
      var matched = false, mv = "";
      $s.find("option").each(function() {
        var ov = $(this).val();
        if (ov && ov !== "__NEW__" && ov === tv) { matched = true; mv = ov; return false; }
      });
      if (!matched) { $t.focus(); return; }
      $s.val(mv);
    } else {
      $s.val("");
    }
    $("#category_text_block").addClass("hide");
    $("#category_select_block").removeClass("hide");
    $t.prop("disabled", true).removeAttr("name").removeAttr("required");
    $s.prop("disabled", false).attr("name", "category").attr("required", "required");
  }
  $(function(){
    $("#category_preset").on("change", function() {
      if ($(this).val() === "__NEW__") {
        $(this).val("");
        categoryToTextMode(true);
      }
    });
    $("#btn_category_from_list").on("click", function() {
      categoryToListMode();
    });
    $("#menu_image").on("change", function(){
      var f = this.files && this.files[0];
      $("#menu_image_name").text(f ? f.name : "");
      if (!f || !/^image\//.test(f.type)) return;
      var r = new FileReader();
      r.onload = function(e) { showPreview(e.target.result); };
      r.readAsDataURL(f);
    });
    $(document).on("click", ".waiter-thumb-zoom", function(e){
      e.preventDefault();
      var $t = $(this), s = $t.data("fullsrc") || $t.attr("src");
      if ($t.attr("id") === "imgPreview" && $t.css("display") === "none") return;
      if (s) openZoom(s);
    });
    $("#imgZoomModal").on("hidden.bs.modal", function(){
      $("#imgZoomContent").attr("src", "");
    });
  });
})(jQuery);
</script>
</body>
</html>
