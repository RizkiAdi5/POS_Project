<!---
    /latest/Waiter/WaiterPOS.cfm
    Counter ordering for staff: start a new order for a customer who already
    paid and wants another round (dine-in, merged into their table's open
    order) or a stand-alone take-away order with its own reference number.
    Single-page flow: the item catalog + cart are always visible; Dine In /
    Take Away (+ table number) is just an inline field in the cart panel
    until the first "Send to Order", not a separate gate page.
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="/application.cfm">
<cfinclude template="/latest/Waiter/inc_waiter_login.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_emenu_currency.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="SESSION.wpos_order_id"     default="">
<cfparam name="SESSION.wpos_order_number" default="">
<cfparam name="SESSION.wpos_table_id"     default="">
<cfparam name="SESSION.wpos_table_number" default="">
<cfparam name="SESSION.wpos_is_takeaway"  default="No">
<cfparam name="SESSION.wpos_invoice_url"  default="">
<cfparam name="SESSION.wpos_show_qr"      default="No">

<!--- Cancel current order context --->
<cfif structKeyExists(url, "cancel")>
    <cfset SESSION.wpos_order_id     = "">
    <cfset SESSION.wpos_order_number = "">
    <cfset SESSION.wpos_table_id     = "">
    <cfset SESSION.wpos_table_number = "">
    <cfset SESSION.wpos_is_takeaway  = "No">
    <cfset SESSION.wpos_invoice_url  = "">
    <cfset SESSION.wpos_show_qr      = "No">
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<cfset pageErr = structKeyExists(url, "err") ? trim(url.err) : "">
<cfset hasOrder = val(SESSION.wpos_order_id) gt 0>
<cfset emenuCurrSym  = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9,990" : "9,990.00">

<!--- Existing items already on this order (merge visibility) --->
<cfset existingCount = 0>
<cfset existingTotal = 0>
<cfif hasOrder>
    <cfquery name="qExisting" datasource="#dts#">
        SELECT COUNT(*) AS item_count, COALESCE(SUM(subtotal),0) AS item_total
        FROM   app_order_items
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.wpos_order_id)#">
    </cfquery>
    <cfset existingCount = val(qExisting.item_count)>
    <cfset existingTotal = val(qExisting.item_total)>
</cfif>

<!--- Catalog is always shown --->
<cfquery name="qMenu" datasource="#dts#">
    SELECT ITEMNO AS item_code, DESP AS display_name, CATEGORY AS category,
           PRICE AS price, COALESCE(promo_price, 0) AS promo_price,
           COALESCE(img_url,'') AS image_url,
           CASE WHEN img_bytes IS NOT NULL AND LENGTH(img_bytes) > 0 THEN 1 ELSE 0 END AS has_img_blob,
           sort_ord AS display_order
    FROM   icitem
    WHERE  is_avail = 'T'
    ORDER  BY sort_ord ASC, CATEGORY, DESP
</cfquery>
<cfquery name="qCats" dbtype="query">
    SELECT DISTINCT category FROM qMenu ORDER BY category
</cfquery>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="cache-control" content="no-cache">
<title>Waiter POS</title>
<style>
:root{
  --accent:#F54900; --accent-dark:#D04000; --accent-soft:#FFF3ED;
  --ink:#111827; --ink-soft:#6B7280; --ink-faint:#9CA3AF;
  --line:#E9EAEE; --bg:#F6F7FB; --card:#FFFFFF;
  --green:#16A34A; --green-soft:#EAFBF1;
  --blue:#2563EB; --blue-soft:#EEF2FF;
  --radius:16px; --radius-sm:10px;
  --shadow-sm:0 1px 2px rgba(16,24,40,.06);
  --shadow-md:0 4px 16px rgba(16,24,40,.08);
  --shadow-lg:0 12px 32px rgba(16,24,40,.12);
}
*{box-sizing:border-box;}
body{margin:0;background:var(--bg);color:var(--ink);
     font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
     -webkit-font-smoothing:antialiased;}

/* ── Top bar ── */
.topbar{background:var(--card);border-bottom:1px solid var(--line);padding:14px 24px;
        display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.topbar-left{display:flex;align-items:center;gap:14px;}
.brand{font-size:17px;font-weight:800;letter-spacing:-.01em;display:flex;align-items:center;gap:8px;}
.brand-dot{width:9px;height:9px;border-radius:50%;background:var(--accent);}
.chip{font-size:12.5px;font-weight:600;padding:5px 12px;border-radius:99px;background:var(--accent-soft);color:var(--accent-dark);}
.topbar-right{display:flex;gap:8px;}
.tbtn{font-size:13px;font-weight:600;padding:8px 14px;border-radius:10px;border:1px solid var(--line);
      background:var(--card);color:var(--ink-soft);text-decoration:none;cursor:pointer;transition:.15s;}
.tbtn:hover{background:#F3F4F6;color:var(--ink);}
.tbtn.danger{color:#DC2626;border-color:#FCA5A5;}
.tbtn.danger:hover{background:#FEF2F2;}

.alert{margin:16px 24px 0;padding:12px 16px;border-radius:12px;font-size:13.5px;font-weight:500;}
.alert-err{background:#FEF2F2;color:#B91C1C;border:1px solid #FECACA;}

/* ── Layout ── */
.pos-layout{display:grid;grid-template-columns:1fr 380px;gap:0;align-items:start;}
.catalog{padding:20px 24px 100px;}
.cart-panel{position:sticky;top:65px;height:calc(100vh - 65px);background:var(--card);
            border-left:1px solid var(--line);display:flex;flex-direction:column;}

.toolbar{display:flex;gap:10px;margin-bottom:16px;}
.search-wrap{position:relative;flex:1;}
.search-wrap svg{position:absolute;left:14px;top:50%;transform:translateY(-50%);width:17px;height:17px;color:var(--ink-faint);}
.search-input{width:100%;padding:11px 14px 11px 40px;border:1px solid var(--line);border-radius:12px;
             font-size:14.5px;background:var(--card);outline:none;}
.search-input:focus{border-color:var(--accent);}
.cat-select{border:1px solid var(--line);border-radius:12px;padding:11px 14px;font-size:14px;background:var(--card);min-width:170px;}

.item-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:14px;}
.item-card{background:var(--card);border:1px solid var(--line);border-radius:16px;overflow:hidden;cursor:pointer;
           transition:.15s;box-shadow:var(--shadow-sm);position:relative;}
.item-card:hover{box-shadow:var(--shadow-md);transform:translateY(-2px);border-color:#F3D5C4;}
.item-thumb{width:100%;aspect-ratio:1/1;object-fit:cover;background:#F1F2F5;display:block;}
.item-thumb-ph{width:100%;aspect-ratio:1/1;background:linear-gradient(135deg,#FFE8D6,#FFD9CE);
               display:flex;align-items:center;justify-content:center;font-size:34px;}
.item-info{padding:10px 12px 12px;}
.item-name{font-size:13.5px;font-weight:700;color:var(--ink);line-height:1.3;margin-bottom:3px;
           display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;min-height:35px;}
.item-price{font-size:13px;font-weight:700;color:var(--accent);}
.item-add{position:absolute;right:8px;top:8px;width:28px;height:28px;border-radius:50%;background:rgba(17,24,39,.55);
          color:#fff;display:flex;align-items:center;justify-content:center;opacity:0;transition:.15s;}
.item-card:hover .item-add{opacity:1;}
.item-add svg{width:15px;height:15px;}

/* ── Cart panel ── */
.cart-head{padding:18px 22px;border-bottom:1px solid var(--line);}
.cart-title{font-size:16px;font-weight:800;margin-bottom:10px;}
.order-chip{display:inline-flex;align-items:center;gap:6px;font-size:12.5px;font-weight:700;color:var(--accent-dark);
            background:var(--accent-soft);padding:5px 11px;border-radius:99px;}
.existing-note{margin-top:10px;background:var(--blue-soft);color:#1E40AF;border-radius:10px;padding:9px 12px;font-size:12.5px;font-weight:600;}

/* Inline order-type selector (replaces the old separate first page) */
.type-toggle{display:flex;background:#F1F2F5;border-radius:12px;padding:4px;gap:4px;}
.type-btn{flex:1;border:none;background:transparent;padding:9px 8px;border-radius:9px;cursor:pointer;
          font-size:13px;font-weight:700;color:var(--ink-soft);transition:.15s;
          display:flex;align-items:center;justify-content:center;gap:6px;}
.type-btn svg{width:15px;height:15px;}
.type-btn.active{background:var(--card);color:var(--accent);box-shadow:var(--shadow-sm);}
.table-input-wrap{margin-top:10px;}
.table-input{width:100%;padding:10px 12px;border:1.5px solid var(--line);border-radius:10px;font-size:14.5px;
             outline:none;transition:.15s;background:#FAFAFB;}
.table-input:focus{border-color:var(--accent);background:#fff;}

/* ── Table picker trigger + summary chip ── */
.table-pick-btn{width:100%;padding:11px 14px;border:1.5px dashed var(--line);border-radius:10px;
                 background:#FAFAFB;color:var(--ink-soft);font-size:14px;font-weight:600;cursor:pointer;
                 display:flex;align-items:center;justify-content:center;gap:8px;transition:.15s;}
.table-pick-btn:hover{border-color:var(--accent);color:var(--accent-dark);background:var(--accent-soft);}
.table-pick-btn svg{width:16px;height:16px;}
.table-summary{display:flex;align-items:center;justify-content:space-between;gap:10px;padding:11px 14px;
                border:1.5px solid var(--line);border-radius:10px;background:#fff;}
.table-summary .ts-info{font-size:14px;font-weight:700;color:var(--ink);}
.table-summary .ts-sub{font-size:12px;color:var(--ink-soft);font-weight:500;margin-top:1px;}
.table-summary .ts-change{font-size:12px;font-weight:700;color:var(--accent-dark);background:none;border:none;cursor:pointer;padding:4px 6px;}

/* ── Table picker modal ── */
.tp-overlay{display:none;position:fixed;inset:0;z-index:200;background:rgba(17,24,39,.55);
            align-items:center;justify-content:center;padding:20px;}
.tp-overlay.open{display:flex;}
.tp-modal{background:#fff;border-radius:18px;max-width:720px;width:100%;max-height:85vh;
          display:flex;flex-direction:column;box-shadow:var(--shadow-lg);}
.tp-head{padding:18px 22px;border-bottom:1px solid var(--line);display:flex;align-items:center;justify-content:space-between;}
.tp-head h3{margin:0;font-size:16px;font-weight:800;}
.tp-close{border:none;background:#F3F4F6;width:30px;height:30px;border-radius:50%;cursor:pointer;
          display:flex;align-items:center;justify-content:center;color:var(--ink-soft);}
.tp-close:hover{background:#E5E7EB;color:var(--ink);}
.tp-legend{display:flex;flex-wrap:wrap;gap:12px;padding:12px 22px 0;font-size:11.5px;color:var(--ink-soft);}
.tp-legend span{display:inline-flex;align-items:center;gap:5px;}
.tp-dot{width:9px;height:9px;border-radius:50%;display:inline-block;}
.tp-body{padding:16px 22px 22px;overflow-y:auto;}
.tp-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:12px;}
.tp-card{border:1.5px solid var(--line);border-radius:14px;padding:12px 13px;cursor:pointer;text-align:left;
         background:#fff;transition:.15s;}
.tp-card:hover{transform:translateY(-2px);box-shadow:var(--shadow-md);}
.tp-card.st-available{background:#EAFBF1;border-color:#A7E8C4;}
.tp-card.st-occupied{background:#FFF3E8;border-color:#FBCB9A;}
.tp-card.st-paid{background:#EEF2FF;border-color:#B7C4F5;}
.tp-card.st-reserved{background:#FEFBEA;border-color:#F3DE8A;}
.tp-num{font-size:17px;font-weight:800;color:var(--ink);}
.tp-seats{font-size:11.5px;color:var(--ink-soft);margin-top:1px;}
.tp-chip{display:inline-block;margin-top:8px;font-size:10.5px;font-weight:800;letter-spacing:.02em;
         text-transform:uppercase;padding:3px 8px;border-radius:99px;}
.tp-card.st-available .tp-chip{background:#16A34A;color:#fff;}
.tp-card.st-occupied .tp-chip{background:#EA7A1B;color:#fff;}
.tp-card.st-paid .tp-chip{background:#2563EB;color:#fff;}
.tp-card.st-reserved .tp-chip{background:#CA8A04;color:#fff;}
.tp-order-info{margin-top:8px;font-size:11.5px;color:var(--ink-soft);border-top:1px dashed rgba(0,0,0,.12);padding-top:7px;}
.tp-order-info .tp-total{font-weight:700;color:var(--ink);}
.tp-items{margin-top:5px;font-size:11px;color:var(--ink-soft);max-height:70px;overflow-y:auto;}
.tp-items div{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.tp-empty{grid-column:1/-1;text-align:center;color:var(--ink-faint);padding:30px 0;font-size:13px;}
.tp-card-disabled{cursor:not-allowed;}
.tp-card-disabled:hover{transform:none;box-shadow:none;}
.tp-blocked-note{margin-top:8px;font-size:11px;color:#9A3412;background:#FFE8D6;border-radius:8px;padding:6px 8px;line-height:1.35;}

.cart-body{flex:1;overflow-y:auto;padding:10px 22px;}
.cart-empty{text-align:center;color:var(--ink-faint);padding:60px 10px;font-size:13.5px;}
.cart-empty svg{width:40px;height:40px;margin-bottom:10px;opacity:.5;}
.cart-line{display:flex;align-items:center;gap:10px;padding:12px 0;border-bottom:1px solid #F3F4F6;}
.cart-line:last-child{border-bottom:none;}
.cl-info{flex:1;min-width:0;}
.cl-name{font-size:13.5px;font-weight:700;color:var(--ink);margin-bottom:2px;
         white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.cl-price{font-size:12px;color:var(--ink-soft);}
.cl-qty{display:flex;align-items:center;gap:7px;background:#F3F4F6;border-radius:9px;padding:4px 6px;}
.cl-qty button{width:22px;height:22px;border:none;border-radius:6px;background:transparent;cursor:pointer;
               font-weight:800;font-size:14px;color:var(--ink);display:flex;align-items:center;justify-content:center;}
.cl-qty button:hover{background:#E5E7EB;}
.cl-qty span{font-size:13px;font-weight:700;min-width:16px;text-align:center;}
.cl-amt{font-size:13.5px;font-weight:700;min-width:64px;text-align:right;}

.cart-foot{border-top:1px solid var(--line);padding:16px 22px 22px;background:var(--card);}
.tot-row{display:flex;justify-content:space-between;font-size:13.5px;color:var(--ink-soft);margin-bottom:6px;}
.tot-row.grand{font-size:19px;font-weight:800;color:var(--ink);margin-top:8px;padding-top:12px;border-top:1px dashed var(--line);}
.send-btn{width:100%;margin-top:14px;padding:15px;border:none;border-radius:13px;font-size:15px;font-weight:700;
          color:#fff;background:linear-gradient(135deg,var(--accent),var(--accent-dark));cursor:pointer;
          box-shadow:0 8px 20px rgba(245,73,0,.25);transition:.15s;}
.send-btn:disabled{background:#E5E7EB;color:#9CA3AF;box-shadow:none;cursor:not-allowed;}
.send-btn:not(:disabled):hover{opacity:.94;transform:translateY(-1px);}

@media (max-width:900px){
  .pos-layout{grid-template-columns:1fr;}
  .cart-panel{position:static;height:auto;border-left:none;border-top:1px solid var(--line);}
}
</style>
</head>
<body>
<cfoutput>

<div class="topbar">
    <div class="topbar-left">
        <span class="brand"><span class="brand-dot"></span>Waiter POS</span>
        <cfif hasOrder>
            <span class="chip">
                <cfif SESSION.wpos_is_takeaway eq "Yes">Take Away<cfelse>Table #HTMLEditFormat(SESSION.wpos_table_number)#</cfif>
                &nbsp;&middot;&nbsp;#HTMLEditFormat(SESSION.wpos_order_number)#
            </span>
        </cfif>
    </div>
    <div class="topbar-right">
        <cfif isDefined("SESSION.waiter_name") AND len(trim(SESSION.waiter_name))>
            <span style="font-size:13px;color:var(--ink-soft);line-height:34px;padding:0 4px;">#HTMLEditFormat(SESSION.waiter_name)#</span>
            <a href="WaiterPOS.cfm?waiter_logout=1" class="tbtn">Sign Out</a>
        </cfif>
        <a href="WaiterDashboard.cfm" class="tbtn">Dashboard</a>
        <cfif hasOrder><a href="WaiterPOS.cfm?cancel=1" class="tbtn danger">Cancel Order</a></cfif>
    </div>
</div>

<cfif len(pageErr)>
    <div class="alert alert-err">#HTMLEditFormat(pageErr)#</div>
</cfif>

<div class="pos-layout">
    <div class="catalog">
        <div class="toolbar">
            <div class="search-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.2-5.2m0 0a7.5 7.5 0 10-10.6-10.6 7.5 7.5 0 0010.6 10.6z"/></svg>
                <input type="text" class="search-input" id="searchItem" placeholder="Search item..." oninput="applyFilters()">
            </div>
            <select class="cat-select" id="searchCate" onchange="applyFilters()">
                <option value="">All Categories</option>
                <cfloop query="qCats">
                    <cfif len(trim(qCats.category))>
                        <option value="#HTMLEditFormat(qCats.category)#">#HTMLEditFormat(qCats.category)#</option>
                    </cfif>
                </cfloop>
            </select>
        </div>

        <div class="item-grid" id="itemGrid">
            <cfloop query="qMenu">
                <cfset basePrice    = val(qMenu.price)>
                <cfset promoPrice   = val(qMenu.promo_price)>
                <cfset showPromo    = (promoPrice gt 0 AND promoPrice lt basePrice)>
                <cfset displayPrice = (showPromo ? promoPrice : basePrice)>
                <cfset itemImgSrc = "">
                <cfif len(trim(qMenu.image_url))>
                    <cfset itemImgSrc = trim(qMenu.image_url)>
                <cfelseif val(qMenu.has_img_blob) eq 1>
                    <cfset itemImgSrc = "/latest/Waiter/MenuImage.cfm?id=" & URLEncodedFormat(qMenu.item_code)>
                </cfif>

                <div class="item-card" data-name="#JSStringFormat(qMenu.display_name)#" data-cat="#JSStringFormat(trim(qMenu.category))#"
                     onclick="addToCart('#JSStringFormat(qMenu.item_code)#','#JSStringFormat(qMenu.display_name)#',#displayPrice#)">
                    <cfif len(itemImgSrc)>
                        <img class="item-thumb" src="#HTMLEditFormat(itemImgSrc)#" alt=""
                             onerror="this.outerHTML='<div class=&quot;item-thumb-ph&quot;>&##127869;</div>';">
                    <cfelse>
                        <div class="item-thumb-ph">&##127869;</div>
                    </cfif>
                    <div class="item-add">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M12 5v14M5 12h14"/></svg>
                    </div>
                    <div class="item-info">
                        <div class="item-name">#HTMLEditFormat(qMenu.display_name)#</div>
                        <div class="item-price">#emenuCurrSym# #numberFormat(displayPrice, emenuPriceFmt)#</div>
                    </div>
                </div>
            </cfloop>
        </div>
    </div>

    <div class="cart-panel">
        <div class="cart-head">
            <div class="cart-title">Order</div>

            <cfif hasOrder>
                <span class="order-chip">
                    <cfif SESSION.wpos_is_takeaway eq "Yes">Take Away<cfelse>Table #HTMLEditFormat(SESSION.wpos_table_number)#</cfif>
                    &nbsp;&middot;&nbsp;#HTMLEditFormat(SESSION.wpos_order_number)#
                </span>
                <cfif existingCount gt 0>
                    <div class="existing-note">
                        #existingCount# item#(existingCount eq 1 ? '' : 's')# already on this order &mdash; #emenuCurrSym# #numberFormat(existingTotal, emenuPriceFmt)#
                    </div>
                </cfif>
            <cfelse>
                <div class="type-toggle">
                    <button type="button" class="type-btn active" id="btnDineIn" onclick="setMode('dine_in')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 3v18M21 3v18M3 8h4M3 13h4M17 8h4M17 13h4M3 3h4v5a2 2 0 01-2 2H3M17 3h4v5a2 2 0 01-2 2h-2"/></svg>
                        Dine In
                    </button>
                    <button type="button" class="type-btn" id="btnTakeaway" onclick="setMode('takeaway')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M20 7h-3V6a4 4 0 00-8 0v1H6a1 1 0 00-1 1l1 12a2 2 0 002 2h8a2 2 0 002-2l1-12a1 1 0 00-1-1zM9 6a3 3 0 016 0v1H9V6z"/></svg>
                        Take Away
                    </button>
                </div>
                <div class="table-input-wrap" id="tableFieldWrap">
                    <button type="button" class="table-pick-btn" id="tablePickBtn" onclick="openTablePicker()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 3v18M21 3v18M3 8h4M3 13h4M17 8h4M17 13h4M3 3h4v5a2 2 0 01-2 2H3M17 3h4v5a2 2 0 01-2 2h-2"/></svg>
                        Choose table
                    </button>
                    <div class="table-summary" id="tableSummary" style="display:none;">
                        <div>
                            <div class="ts-info" id="tsInfo">&nbsp;</div>
                            <div class="ts-sub" id="tsSub">&nbsp;</div>
                        </div>
                        <button type="button" class="ts-change" onclick="openTablePicker()">Change</button>
                    </div>
                </div>
            </cfif>
        </div>

        <div class="cart-body" id="cartBody">
            <div class="cart-empty" id="emptyCart">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"/></svg>
                <div>Tap an item to add it</div>
            </div>
        </div>

        <div class="cart-foot">
            <div class="tot-row"><span>Subtotal</span><span id="fSub">#emenuCurrSym# 0</span></div>
            <div class="tot-row"><span>Tax (10%)</span><span id="fTax">#emenuCurrSym# 0</span></div>
            <div class="tot-row grand"><span>Total</span><span id="fTotal">#emenuCurrSym# 0</span></div>
            <button class="send-btn" id="placeOrderBtn" onclick="placeOrder()" disabled>Send to Order</button>
        </div>
    </div>
</div>

<div class="tp-overlay" id="tpOverlay" onclick="if(event.target===this) closeTablePicker();">
    <div class="tp-modal">
        <div class="tp-head">
            <h3>Choose a table</h3>
            <button type="button" class="tp-close" onclick="closeTablePicker()">&times;</button>
        </div>
        <div class="tp-legend">
            <span><i class="tp-dot" style="background:##16A34A;"></i>Available &mdash; free to seat</span>
            <span><i class="tp-dot" style="background:##EA7A1B;"></i>Occupied &mdash; open order</span>
            <span><i class="tp-dot" style="background:##2563EB;"></i>Paid &mdash; awaiting session close</span>
            <span><i class="tp-dot" style="background:##CA8A04;"></i>Reserved</span>
        </div>
        <div class="tp-body">
            <div class="tp-grid" id="tpGrid">
                <div class="tp-empty">Loading tables&hellip;</div>
            </div>
        </div>
    </div>
</div>

<form id="orderForm" action="WaiterPOSOrderProcess.cfm?action=submit" method="post" style="display:none;">
    <input type="hidden" name="cart_json" id="cartJsonInput">
    <input type="hidden" name="order_mode" id="orderModeHidden" value="dine_in">
    <input type="hidden" name="table_id" id="tableIdHidden">
    <input type="hidden" name="table_number" id="tableNumberHidden">
</form>

<script>
var cart = {};
var hasOrder = #hasOrder ? 'true' : 'false'#;
var selectedMode = 'dine_in';
var selectedTableId = '';
var selectedTableNumber = '';
var tpTablesCache = null;
var EMENU_CURR_SYM = '#JSStringFormat(emenuCurrSym)#';
var EMENU_CURR_DEC = #val(REQUEST.emenu_currency_decimals)#;

function fmt(n){
    var v = parseFloat(n) || 0;
    if (EMENU_CURR_DEC === 0) return EMENU_CURR_SYM + ' ' + Math.round(v).toLocaleString();
    return EMENU_CURR_SYM + ' ' + v.toFixed(2);
}
function setMode(mode) {
    selectedMode = mode;
    document.getElementById('btnDineIn').classList.toggle('active', mode === 'dine_in');
    document.getElementById('btnTakeaway').classList.toggle('active', mode === 'takeaway');
    document.getElementById('tableFieldWrap').style.display = (mode === 'dine_in') ? '' : 'none';
}
function addToCart(id, name, price) {
    if (cart[id]) { cart[id].qty += 1; }
    else { cart[id] = { id: id, name: name, price: parseFloat(price), qty: 1 }; }
    render();
}
function changeQty(id, delta) {
    if (!cart[id]) return;
    cart[id].qty = Math.max(0, cart[id].qty + delta);
    if (cart[id].qty === 0) delete cart[id];
    render();
}
function cartCount() { return Object.values(cart).reduce(function(s,i){ return s + i.qty; }, 0); }
function cartTotal() { return Object.values(cart).reduce(function(s,i){ return s + i.price * i.qty; }, 0); }

function render() {
    var items = Object.values(cart);
    var body  = document.getElementById('cartBody');
    var btn   = document.getElementById('placeOrderBtn');

    if (items.length === 0) {
        body.innerHTML = '<div class="cart-empty" id="emptyCart"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"/></svg><div>Tap an item to add it</div></div>';
    } else {
        var html = '';
        items.forEach(function(item){
            html += '<div class="cart-line">' +
                '<div class="cl-info"><div class="cl-name">' + escHtml(item.name) + '</div><div class="cl-price">' + fmt(item.price) + ' each</div></div>' +
                '<div class="cl-qty">' +
                    '<button type="button" onclick="changeQty(\'' + item.id + '\',-1)">&minus;</button>' +
                    '<span>' + item.qty + '</span>' +
                    '<button type="button" onclick="changeQty(\'' + item.id + '\',1)">+</button>' +
                '</div>' +
                '<div class="cl-amt">' + fmt(item.price * item.qty) + '</div>' +
            '</div>';
        });
        body.innerHTML = html;
    }

    var sub = cartTotal(), tax = sub * 0.10, total = sub + tax;
    document.getElementById('fSub').textContent   = fmt(sub);
    document.getElementById('fTax').textContent   = fmt(tax);
    document.getElementById('fTotal').textContent = fmt(total);
    btn.disabled = (cartCount() === 0);
}
function placeOrder() {
    if (cartCount() === 0) return;

    if (!hasOrder) {
        if (selectedMode === 'dine_in') {
            if (!selectedTableId) {
                alert('Choose a table first.');
                openTablePicker();
                return;
            }
            document.getElementById('tableIdHidden').value = selectedTableId;
            document.getElementById('tableNumberHidden').value = selectedTableNumber;
        }
        document.getElementById('orderModeHidden').value = selectedMode;
    }

    document.getElementById('cartJsonInput').value = JSON.stringify(Object.values(cart));
    document.getElementById('orderForm').submit();
}

function statusLabel(st) {
    if (st === 'available') return 'Available';
    if (st === 'occupied')  return 'Occupied';
    if (st === 'paid')      return 'Paid';
    if (st === 'reserved')  return 'Reserved';
    return st;
}
function openTablePicker() {
    document.getElementById('tpOverlay').classList.add('open');
    fetch('WaiterPOSTables.cfm', { cache: 'no-store' })
        .then(function(r){ return r.json(); })
        .then(function(data){
            tpTablesCache = (data && data.ok && Array.isArray(data.tables)) ? data.tables : [];
            renderTableGrid(tpTablesCache);
        })
        .catch(function(){
            document.getElementById('tpGrid').innerHTML = '<div class="tp-empty">Could not load tables. Try again.</div>';
        });
}
function closeTablePicker() {
    document.getElementById('tpOverlay').classList.remove('open');
}
function renderTableGrid(tables) {
    var grid = document.getElementById('tpGrid');
    if (!tables || !tables.length) {
        grid.innerHTML = '<div class="tp-empty">No tables set up yet.</div>';
        return;
    }
    var html = '';
    tables.forEach(function(t){
        var blocked = (t.status === 'occupied');
        var tag = blocked ? 'div' : 'button';
        html += '<' + tag + (blocked ? '' : ' type="button"') +
            ' class="tp-card st-' + t.status + (blocked ? ' tp-card-disabled' : '') + '"' +
            (blocked ? '' : ' onclick="selectTable(' + t.table_id + ')"') + '>' +
            '<div class="tp-num">Table ' + escHtml(t.table_number) + '</div>' +
            '<div class="tp-seats">' + t.seats + ' seats</div>' +
            '<span class="tp-chip">' + statusLabel(t.status) + '</span>';
        if ((t.status === 'occupied' || t.status === 'paid') && t.has_order) {
            html += '<div class="tp-order-info">' +
                (t.status === 'paid' ? 'Paid &mdash; new order starts fresh' : (t.item_count + ' item' + (t.item_count === 1 ? '' : 's'))) +
                ' &middot; <span class="tp-total">' + fmt(t.total_amount) + '</span></div>';
            if (t.items && t.items.length) {
                html += '<div class="tp-items">';
                t.items.slice(0, 6).forEach(function(it){
                    html += '<div>' + it.qty + '&times; ' + escHtml(it.name) + '</div>';
                });
                if (t.items.length > 6) html += '<div>&hellip; +' + (t.items.length - 6) + ' more</div>';
                html += '</div>';
            }
        }
        if (blocked) {
            html += '<div class="tp-blocked-note">Unpaid &mdash; ask the customer to use e-menu\'s Order More, or settle the bill first.</div>';
        }
        html += '</' + tag + '>';
    });
    grid.innerHTML = html;
}
function selectTable(tableId) {
    var t = (tpTablesCache || []).find(function(x){ return x.table_id === tableId; });
    if (!t) return;
    selectedTableId = t.table_id;
    selectedTableNumber = t.table_number;

    document.getElementById('tablePickBtn').style.display = 'none';
    var summary = document.getElementById('tableSummary');
    summary.style.display = 'flex';
    document.getElementById('tsInfo').textContent = 'Table ' + t.table_number;

    var sub = statusLabel(t.status);
    if (t.status === 'occupied' && t.has_order) {
        sub += ' — ' + t.item_count + ' item' + (t.item_count === 1 ? '' : 's') + ' already ordered, ' + fmt(t.total_amount);
    } else if (t.status === 'paid') {
        sub += ' — previous order settled, this starts a new order';
    } else if (t.status === 'reserved') {
        sub += ' — held for a booking';
    } else {
        sub += ' — ready to seat';
    }
    document.getElementById('tsSub').textContent = sub;

    closeTablePicker();
}
function applyFilters() {
    var q   = document.getElementById('searchItem').value.toLowerCase().trim();
    var cat = document.getElementById('searchCate').value.toLowerCase();
    document.querySelectorAll('##itemGrid .item-card').forEach(function(card){
        var name = (card.dataset.name || '').toLowerCase();
        var c    = (card.dataset.cat  || '').toLowerCase();
        var matchCat  = !cat || c === cat;
        var matchName = !q   || name.indexOf(q) !== -1;
        card.style.display = (matchCat && matchName) ? '' : 'none';
    });
}
function escHtml(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
</script>

</cfoutput>
</body>
</html>
