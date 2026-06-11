<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_emenu_currency.cfm">
<cfsetting showdebugoutput="false">

<!--- Must have table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif SESSION.emenu_cart_locked eq true>
    <cflocation url="/latest/customer/order_status.cfm" addtoken="false">
</cfif>

<!--- Must be logged in or guest --->
<cfif SESSION.emenu_loggedin neq "Yes" AND SESSION.emenu_is_guest neq "Yes">
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfset isGuest     = (SESSION.emenu_is_guest eq "Yes")>
<cfset custName    = len(trim(SESSION.emenu_name)) ? trim(SESSION.emenu_name) : "Guest">
<cfset tableDisplay = len(trim(SESSION.emenu_table_name)) ? SESSION.emenu_table_name : "Table " & SESSION.emenu_table_number>
<cfset emenuCurrSym = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9,990" : "9,990.00">
<cfset menuHasBill = false>
<cfset menuBillTotal = 0>
<cfif val(SESSION.emenu_order_id) gt 0>
    <cfquery name="qBillSnap" datasource="#dts#">
        SELECT total_amount,
               (SELECT COUNT(*) FROM app_order_items
                WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_order_id)#">) AS item_count
        FROM app_orders
        WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_order_id)#">
        LIMIT 1
    </cfquery>
    <cfif qBillSnap.recordCount AND val(qBillSnap.item_count) gt 0>
        <cfset menuHasBill = true>
        <cfset menuBillTotal = val(qBillSnap.total_amount)>
    </cfif>
</cfif>


<!--- Load menu items --->
<cfset menuError = "">
<!--- Waiter uploads store files in image_bytes; admin list uses MenuImage.cfm — customer must use same path --->
<cfset menuImgBlobCols = false>
<cftry>
    <cfquery name="qMenuImgCol" datasource="#dts#">
        SELECT COUNT(*) AS col_count
        FROM   information_schema.COLUMNS
        WHERE  TABLE_SCHEMA = DATABASE()
        AND    TABLE_NAME   = 'app_menu'
        AND    COLUMN_NAME  = 'image_bytes'
    </cfquery>
    <cfif val(qMenuImgCol.col_count) gt 0><cfset menuImgBlobCols = true></cfif>
    <cfcatch type="any"><cfset menuImgBlobCols = false></cfcatch>
</cftry>
<cfquery name="qMenu" datasource="#dts#">
    SELECT menu_id, item_code, display_name, category, sub_category,
           price, COALESCE(promo_price, 0) AS promo_price,
           is_available, is_vegetarian, is_halal, is_spicy, is_featured,
           COALESCE(description,'') AS description,
           COALESCE(image_url,'')   AS image_url,
           <cfif menuImgBlobCols>
           CASE WHEN image_bytes IS NOT NULL AND LENGTH(image_bytes) > 0 THEN 1 ELSE 0 END AS has_img_blob,
           <cfelse>
           0 AS has_img_blob,
           </cfif>
           COALESCE(prep_time, 0)   AS prep_time,
           COALESCE(calories, 0)    AS calories,
           display_order
    FROM   app_menu
    WHERE  is_available = 1
    ORDER  BY display_order ASC, category, display_name
</cfquery>

<!--- Distinct categories --->
<cfquery name="qCats" dbtype="query">
    SELECT DISTINCT category FROM qMenu ORDER BY category
</cfquery>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>Menu &mdash; <cfoutput>#HTMLEditFormat(tableDisplay)#</cfoutput></title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:"Segoe UI",Arial,sans-serif;background:#f3f4f6;
             min-height:100vh;padding-bottom:100px;}

        /* ---- Header ---- */
        .top-header{
            background:linear-gradient(135deg,#F54900,#D04000);
            padding:16px;
            position:sticky;top:0;z-index:100;
            box-shadow:0 2px 8px rgba(0,0,0,.15);
        }
        .header-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;}
        .table-tag{background:rgba(255,255,255,.2);color:#fff;
                   padding:4px 12px;border-radius:20px;font-size:13px;font-weight:600;}
        .user-info{display:flex;align-items:center;gap:8px;}
        .user-name{color:#fff;font-size:14px;font-weight:600;max-width:140px;
                   white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
        .logout-btn{background:rgba(255,255,255,.2);border:none;color:#fff;
                    padding:6px 10px;border-radius:8px;font-size:12px;
                    cursor:pointer;text-decoration:none;white-space:nowrap;}
        .logout-btn:hover{background:rgba(255,255,255,.35);}

        /* ---- Search ---- */
        .search-wrap{position:relative;}
        .search-wrap svg{position:absolute;left:12px;top:50%;transform:translateY(-50%);
                         width:18px;height:18px;color:#9ca3af;pointer-events:none;}
        .search-input{width:100%;padding:10px 14px 10px 38px;
                      border:none;border-radius:12px;font-size:15px;
                      background:rgba(255,255,255,.9);outline:none;}
        .search-input:focus{background:#fff;}

        /* ---- Category nav ---- */
        .cat-nav{display:flex;gap:8px;overflow-x:auto;padding:12px 16px 4px;
                 scrollbar-width:none;}
        .cat-nav::-webkit-scrollbar{display:none;}
        .cat-btn{flex-shrink:0;padding:8px 18px;border-radius:20px;border:none;
                 font-size:14px;font-weight:600;cursor:pointer;
                 background:#fff;color:#6b7280;transition:all .2s;}
        .cat-btn.active{background:#F54900;color:#fff;}

        /* ---- Item grid ---- */
        .items-wrap{padding:12px 16px;display:flex;flex-direction:column;gap:14px;}

        .item-card{background:#fff;border-radius:16px;overflow:hidden;
                   box-shadow:0 2px 8px rgba(0,0,0,.06);
                   display:flex;align-items:stretch;}

        .item-img{width:110px;min-height:110px;flex-shrink:0;object-fit:cover;background:#f3f4f6;}
        .item-img-placeholder{width:110px;min-height:110px;flex-shrink:0;
                              background:linear-gradient(135deg,#fed7aa,#fecaca);
                              display:flex;align-items:center;justify-content:center;
                              font-size:32px;}

        .item-body{flex:1;padding:12px 12px 12px 14px;
                   display:flex;flex-direction:column;justify-content:space-between;}

        .item-name{font-size:15px;font-weight:700;color:#111827;margin-bottom:4px;
                   line-height:1.3;}
        .item-cat{font-size:12px;color:#9ca3af;margin-bottom:6px;}

        .item-desc{font-size:12px;color:#6b7280;margin-bottom:6px;line-height:1.4;}
        .badge-row{display:flex;gap:4px;flex-wrap:wrap;margin-bottom:6px;}
        .badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px;}
        .badge-halal   {background:#dcfce7;color:#15803d;}
        .badge-veg     {background:#d1fae5;color:#065f46;}
        .badge-spicy   {background:#fee2e2;color:#b91c1c;}
        .badge-featured{background:#fef3c7;color:#92400e;}
        .item-price-row{display:flex;align-items:center;gap:8px;margin-bottom:10px;}
        .item-price{font-size:16px;font-weight:700;color:#F54900;}
        .item-promo{font-size:12px;color:#9ca3af;text-decoration:line-through;}

        .add-row{display:flex;align-items:center;gap:8px;}
        .qty-ctrl{display:none;align-items:center;gap:6px;}
        .qty-ctrl.show{display:flex;}
        .qty-btn{width:30px;height:30px;border-radius:8px;border:none;
                 background:#f3f4f6;color:#111827;font-size:18px;cursor:pointer;
                 display:flex;align-items:center;justify-content:center;
                 font-weight:700;transition:background .15s;}
        .qty-btn:hover{background:#e5e7eb;}
        .qty-num{font-size:15px;font-weight:700;color:#111827;min-width:20px;text-align:center;}
        .add-btn{background:#F54900;color:#fff;border:none;border-radius:10px;
                 padding:8px 16px;font-size:14px;font-weight:700;cursor:pointer;
                 transition:opacity .15s;white-space:nowrap;}
        .add-btn:hover{opacity:.9;}

        .empty-state{text-align:center;padding:60px 24px;color:#9ca3af;}
        .empty-state svg{width:48px;height:48px;margin:0 auto 12px;display:block;}

        /* ---- Cart button ---- */
        .cart-fab{
            position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
            background:#F54900;color:#fff;border:none;border-radius:16px;
            padding:16px 28px;font-size:16px;font-weight:700;cursor:pointer;
            box-shadow:0 6px 24px rgba(245,73,0,.4);
            display:none;align-items:center;gap:12px;
            min-width:240px;justify-content:space-between;
            z-index:200;transition:opacity .2s;
        }
        .cart-fab.show{display:flex;}
        .cart-fab:hover{opacity:.95;}
        .cart-fab-left{display:flex;align-items:center;gap:8px;}
        .cart-badge{background:rgba(255,255,255,.3);border-radius:8px;
                    padding:2px 8px;font-size:13px;}

        /* ---- Cart Drawer ---- */
        .drawer-overlay{position:fixed;inset:0;background:rgba(0,0,0,.5);
                        z-index:300;display:none;}
        .drawer-overlay.open{display:block;}
        .drawer{position:fixed;bottom:0;left:0;right:0;background:#fff;
                border-radius:24px 24px 0 0;z-index:400;
                max-height:85vh;display:flex;flex-direction:column;
                transform:translateY(100%);transition:transform .3s ease;}
        .drawer.open{transform:translateY(0);}
        .drawer-handle{width:40px;height:4px;background:#e5e7eb;
                       border-radius:2px;margin:12px auto 0;}
        .drawer-header{padding:16px 20px;border-bottom:1px solid #f3f4f6;
                       display:flex;align-items:center;justify-content:space-between;}
        .drawer-title{font-size:18px;font-weight:700;color:#111827;}
        .drawer-close{background:none;border:none;font-size:22px;
                      cursor:pointer;color:#6b7280;padding:4px;}
        .drawer-body{overflow-y:auto;flex:1;padding:16px 20px;}
        .drawer-footer{padding:16px 20px;border-top:1px solid #f3f4f6;}

        /* Cart item cards (Figma style) */
        .ci-card{border:1px solid #f0f0f0;border-radius:16px;padding:14px;margin-bottom:10px;}
        .ci-card:last-child{margin-bottom:0;}
        .ci-row{display:flex;gap:12px;}
        .ci-img{width:72px;height:72px;border-radius:12px;object-fit:cover;flex-shrink:0;}
        .ci-img-ph{width:72px;height:72px;border-radius:12px;background:#fff3ee;
                   flex-shrink:0;display:flex;align-items:center;justify-content:center;}
        .ci-img-ph svg{width:28px;height:28px;color:#F54900;}
        .ci-body{flex:1;min-width:0;}
        .ci-name{font-size:14px;font-weight:700;color:#111;margin-bottom:3px;}
        .ci-unit-price{font-size:13px;color:#F54900;font-weight:600;margin-bottom:8px;}
        .ci-controls{display:flex;align-items:center;gap:8px;}
        .ci-qty-wrap{display:flex;align-items:center;gap:6px;
                     background:#f3f4f6;border-radius:10px;padding:4px 6px;}
        .ci-qty-btn2{width:28px;height:28px;border-radius:8px;border:none;
                     background:transparent;cursor:pointer;
                     display:flex;align-items:center;justify-content:center;}
        .ci-qty-btn2:hover{background:#e5e7eb;}
        .ci-qty-btn2 svg{width:16px;height:16px;}
        .ci-qty{font-size:14px;font-weight:700;min-width:22px;text-align:center;color:#111;}
        .ci-note-btn{width:34px;height:34px;border-radius:10px;border:none;
                     background:#f3f4f6;cursor:pointer;
                     display:flex;align-items:center;justify-content:center;}
        .ci-note-btn svg{width:16px;height:16px;color:#6b7280;}
        .ci-note-btn.active{background:#fff3ee;}
        .ci-note-btn.active svg{color:#F54900;}
        .ci-subtotal{font-size:14px;font-weight:700;color:#111;white-space:nowrap;padding-left:8px;padding-top:2px;}
        .ci-note-row{display:none;margin-top:10px;gap:8px;}
        .ci-note-row.open{display:flex;}
        .ci-note-input{flex:1;padding:8px 12px;border:1.5px solid #e5e7eb;border-radius:10px;
                       font-size:13px;color:#374151;outline:none;background:#f9fafb;}
        .ci-note-input:focus{border-color:#F54900;background:#fff;}
        .ci-note-save{padding:8px 14px;background:#F54900;color:#fff;border:none;
                      border-radius:10px;font-size:13px;font-weight:700;cursor:pointer;}
        .ci-note-display{margin-top:8px;background:#fff3ee;border:1px solid #fed7aa;
                         border-radius:8px;padding:6px 10px;font-size:12px;color:#c2410c;}

        /* Totals */
        .total-row{display:flex;justify-content:space-between;align-items:center;
                   margin-bottom:6px;font-size:14px;color:#6b7280;}
        .total-row.grand{font-size:17px;font-weight:700;color:#111827;
                         margin-top:10px;padding-top:10px;
                         border-top:1px solid #e5e7eb;}
        .place-order-btn{width:100%;padding:16px;background:#F54900;color:#fff;
                         border:none;border-radius:14px;font-size:16px;
                         font-weight:700;cursor:pointer;margin-top:14px;
                         transition:opacity .2s;}
        .place-order-btn:hover{opacity:.9;}
        .place-order-btn:disabled{background:#d1d5db;cursor:not-allowed;}

        .empty-cart{text-align:center;padding:40px 0;color:#9ca3af;font-size:15px;}

        .bill-bar{background:#fff;border-radius:12px;padding:10px 14px;margin:0 16px 8px;
                  display:flex;align-items:center;justify-content:space-between;
                  box-shadow:0 1px 4px rgba(0,0,0,.06);font-size:13px;}
        .bill-bar a{color:#F54900;font-weight:700;text-decoration:none;}
    </style>
</head>
<body>

<!--- ===== HEADER ===== --->
<div class="top-header">
    <div class="header-row">
        <span class="table-tag">&#128205;&nbsp;<cfoutput>#HTMLEditFormat(tableDisplay)#</cfoutput></span><!--- pin emoji decimal entity is safe outside cfoutput --->

        <div class="user-info">
            <cfif NOT isGuest>
                <a href="/latest/customer/profile.cfm" class="user-name" style="text-decoration:none;color:inherit;">
                    <cfoutput>#HTMLEditFormat(custName)#</cfoutput>
                </a>
                <a href="/latest/customer/logout.cfm" class="logout-btn">Logout</a>
            <cfelse>
                <a href="/latest/customer/login.cfm" class="logout-btn">Login</a>
            </cfif>
        </div>
    </div>
    <div class="search-wrap">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"/>
        </svg>
        <input type="text" class="search-input" id="searchInput"
               placeholder="Search menu..." oninput="filterMenu()">
    </div>
</div>

<cfif menuHasBill>
<div class="bill-bar">
    <span>Running bill: <strong>#emenuCurrSym# #numberFormat(menuBillTotal, emenuPriceFmt)#</strong></span>
    <a href="/latest/customer/payment.cfm">Pay bill</a>
</div>
</cfif>

<!--- ===== CATEGORY NAV ===== --->
<div class="cat-nav" id="catNav">
    <button class="cat-btn active" onclick="filterCat('ALL',this)">All</button>
    <cfoutput query="qCats">
        <cfif len(trim(qCats.category))>
            <button class="cat-btn"
                    onclick="filterCat('#JSStringFormat(qCats.category)#',this)">
                #HTMLEditFormat(qCats.category)#
            </button>
        </cfif>
    </cfoutput>
</div>

<!--- ===== MENU ITEMS ===== --->
<div class="items-wrap" id="itemsWrap">

    <cfif qMenu.recordCount eq 0>
        <div class="empty-state">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25H12"/>
            </svg>
            <p>No menu items available at the moment.</p>
        </div>
    </cfif>

    <cfoutput query="qMenu">
        <cfset basePrice    = val(qMenu.price)>
        <cfset promoPrice   = val(qMenu.promo_price)>
        <cfset showPromo    = (promoPrice gt 0 AND promoPrice lt basePrice)>
        <cfset displayPrice = (showPromo ? promoPrice : basePrice)>
        <cfset itemImgSrc = "">
        <cfif len(trim(qMenu.image_url))>
            <cfset itemImgSrc = trim(qMenu.image_url)>
        <cfelseif val(qMenu.has_img_blob) eq 1>
            <cfset itemImgSrc = "/latest/Waiter/MenuImage.cfm?id=" & val(qMenu.menu_id)>
        </cfif>

        <div class="item-card"
             data-id="#qMenu.menu_id#"
             data-name="#JSStringFormat(qMenu.display_name)#"
             data-price="#displayPrice#"
             data-cat="#JSStringFormat(trim(qMenu.category))#"
             data-img="#JSStringFormat(itemImgSrc)#">

            <cfif len(itemImgSrc)>
                <img class="item-img"
                     src="#HTMLEditFormat(itemImgSrc)#"
                     alt="#HTMLEditFormat(qMenu.display_name)#"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                <div class="item-img-placeholder" style="display:none;">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="1.5" width="36" height="36" style="color:##F54900">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M12 8.25v-1.5m0 1.5c-1.355 0-2.697.056-4.024.166C6.845 8.51 6 9.473 6 10.608v2.513m6-4.871c1.355 0 2.697.056 4.024.166C17.155 8.51 18 9.473 18 10.608v2.513M15 12H9m6 0a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                </div>
            <cfelse>
                <div class="item-img-placeholder">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="1.5" width="36" height="36" style="color:##F54900">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M12 8.25v-1.5m0 1.5c-1.355 0-2.697.056-4.024.166C6.845 8.51 6 9.473 6 10.608v2.513m6-4.871c1.355 0 2.697.056 4.024.166C17.155 8.51 18 9.473 18 10.608v2.513M15 12H9m6 0a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                </div>
            </cfif>

            <div class="item-body">
                <div>
                    <div class="item-name">#HTMLEditFormat(qMenu.display_name)#</div>
                    <cfif len(trim(qMenu.description))>
                        <div class="item-desc">#HTMLEditFormat(left(trim(qMenu.description),60))##(len(trim(qMenu.description)) gt 60 ? '...' : '')#</div>
                    </cfif>
                    <!--- Badges --->
                    <div class="badge-row">
                        <cfif qMenu.is_halal>
                            <span class="badge badge-halal">Halal</span>
                        </cfif>
                        <cfif qMenu.is_vegetarian>
                            <span class="badge badge-veg">Veg</span>
                        </cfif>
                        <cfif qMenu.is_spicy>
                            <span class="badge badge-spicy">Spicy</span>
                        </cfif>
                        <cfif qMenu.is_featured>
                            <span class="badge badge-featured">Featured</span>
                        </cfif>
                    </div>
                    <div class="item-price-row">
                        <span class="item-price">#emenuCurrSym# #numberFormat(displayPrice, emenuPriceFmt)#</span>
                        <cfif showPromo>
                            <span class="item-promo">#emenuCurrSym# #numberFormat(basePrice, emenuPriceFmt)#</span>
                        </cfif>
                    </div>
                </div>
                <div class="add-row">
                    <div class="qty-ctrl" id="ctrl-#qMenu.menu_id#">
                        <button class="qty-btn" onclick="changeQty('#qMenu.menu_id#',-1)">&minus;</button>
                        <span class="qty-num" id="qty-#qMenu.menu_id#">1</span>
                        <button class="qty-btn" onclick="changeQty('#qMenu.menu_id#',1)">+</button>
                    </div>
                    <button class="add-btn" id="addbtn-#qMenu.menu_id#"
                            onclick="addToCart('#qMenu.menu_id#','#JSStringFormat(qMenu.display_name)#',#displayPrice#)">
                        + Add
                    </button>
                </div>
            </div>
        </div>
    </cfoutput>

</div>

<!--- ===== FLOATING CART BUTTON ===== --->
<button class="cart-fab" id="cartFab" onclick="openCart()">
    <div class="cart-fab-left">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="2" width="22" height="22">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"/>
        </svg>
        <span id="fabCount" class="cart-badge">0 items</span>
    </div>
    <span id="fabTotal">#emenuCurrSym# 0</span>
</button>

<!--- ===== CART DRAWER ===== --->
<div class="drawer-overlay" id="drawerOverlay" onclick="closeCart()"></div>
<div class="drawer" id="cartDrawer">
    <div class="drawer-handle"></div>
    <div class="drawer-header">
        <span class="drawer-title">Your Order</span>
        <button class="drawer-close" onclick="closeCart()">&times;</button>
    </div>
    <div class="drawer-body" id="drawerBody">
        <div class="empty-cart" id="emptyCart">Your cart is empty</div>
    </div>
    <div class="drawer-footer">
        <div class="total-row"><span>Subtotal</span><span id="drawerSubtotal">#emenuCurrSym# 0</span></div>
        <div class="total-row"><span>Tax (10%)</span><span id="drawerTax">#emenuCurrSym# 0</span></div>
        <div class="total-row grand"><span>Total</span><span id="drawerTotal">#emenuCurrSym# 0</span></div>
        <button class="place-order-btn" id="placeOrderBtn"
                onclick="placeOrder()" disabled>Place Order</button>
    </div>
</div>

<!--- Hidden form to submit order --->
<form id="orderForm" action="/latest/customer/orderProcess.cfm" method="post" style="display:none;">
    <input type="hidden" name="cart_json" id="cartJsonInput">
</form>

<script>
/* ================================================================
   CART STATE
================================================================ */
var cart = {};   /* { menuId: { id, name, price, qty, note } } */
var EMENU_CURR_SYM = '<cfoutput>#JSStringFormat(emenuCurrSym)#</cfoutput>';
var EMENU_CURR_DEC = <cfoutput>#val(REQUEST.emenu_currency_decimals)#</cfoutput>;

function fmt(n){
    var v = parseFloat(n) || 0;
    if (EMENU_CURR_DEC === 0) {
        return EMENU_CURR_SYM + ' ' + Math.round(v).toLocaleString();
    }
    return EMENU_CURR_SYM + ' ' + v.toFixed(2);
}

/* ---- Add to cart ---- */
function addToCart(id, name, price) {
    var qtyEl = document.getElementById('qty-' + id);
    var qty   = qtyEl ? parseInt(qtyEl.textContent) || 1 : 1;

    /* grab image from data-img on the card */
    var card  = document.querySelector('[data-id="' + id + '"]');
    var img   = card ? (card.dataset.img || '') : '';

    if (cart[id]) {
        cart[id].qty += qty;
    } else {
        cart[id] = { id: id, name: name, price: parseFloat(price), qty: qty, note: '', img: img };
    }

    /* Reset qty display back to 1 */
    if (qtyEl) qtyEl.textContent = '1';
    var ctrl = document.getElementById('ctrl-' + id);
    if (ctrl) ctrl.classList.remove('show');

    refreshFab();
    refreshDrawer();
}

/* ---- Change qty on card (before adding) ---- */
function changeQty(id, delta) {
    var el  = document.getElementById('qty-' + id);
    var cur = parseInt(el.textContent) || 1;
    var nxt = Math.max(1, cur + delta);
    el.textContent = nxt;
    document.getElementById('ctrl-' + id).classList.add('show');
}

/* ---- Remove from cart ---- */
function removeFromCart(id) {
    delete cart[id];
    refreshFab();
    refreshDrawer();
}

/* ---- Change qty inside drawer ---- */
function changeCartQty(id, delta) {
    if (!cart[id]) return;
    cart[id].qty = Math.max(0, cart[id].qty + delta);
    if (cart[id].qty === 0) { removeFromCart(id); return; }
    refreshFab();
    refreshDrawer();
}

/* ---- Update note ---- */
function updateNote(id, val) {
    if (cart[id]) cart[id].note = val;
}

/* ---- Totals ---- */
function cartTotal() {
    return Object.values(cart).reduce(function(s,i){ return s + i.price * i.qty; }, 0);
}
function cartCount() {
    return Object.values(cart).reduce(function(s,i){ return s + i.qty; }, 0);
}

/* ---- Refresh FAB ---- */
function refreshFab() {
    var count = cartCount();
    var fab   = document.getElementById('cartFab');
    if (count > 0) {
        fab.classList.add('show');
        document.getElementById('fabCount').textContent = count + ' item' + (count === 1 ? '' : 's');
        document.getElementById('fabTotal').textContent = fmt(cartTotal());
    } else {
        fab.classList.remove('show');
    }
}

/* SVG constants */
var TRASH_SVG = '<svg viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"/></svg>';
var MINUS_SVG = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15"/></svg>';
var NOTE_SVG  = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125"/></svg>';
var FOOD_SVG  = '<svg viewBox="0 0 24 24" fill="none" stroke="#F54900" stroke-width="1.5" width="28" height="28"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8.25v-1.5m0 1.5c-1.355 0-2.697.056-4.024.166C6.845 8.51 6 9.473 6 10.608v2.513m6-4.871c1.355 0 2.697.056 4.024.166C17.155 8.51 18 9.473 18 10.608v2.513M15 12H9m6 0a3 3 0 11-6 0 3 3 0 016 0z"/></svg>';

/* ---- Refresh drawer ---- */
function refreshDrawer() {
    var body     = document.getElementById('drawerBody');
    var items    = Object.values(cart);
    var placeBtn = document.getElementById('placeOrderBtn');

    if (items.length === 0) {
        body.innerHTML = '<div class="empty-cart">Your cart is empty</div>';
        document.getElementById('drawerSubtotal').textContent = fmt(0);
        document.getElementById('drawerTax').textContent      = fmt(0);
        document.getElementById('drawerTotal').textContent    = fmt(0);
        placeBtn.disabled = true;
        return;
    }

    var html = '';
    items.forEach(function(item) {
        var imgBlock = item.img
            ? '<img class="ci-img" src="' + escAttr(item.img) + '" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'flex\';">' +
              '<div class="ci-img-ph" style="display:none;">' + FOOD_SVG + '</div>'
            : '<div class="ci-img-ph">' + FOOD_SVG + '</div>';

        var minusBtn = item.qty === 1
            ? '<button class="ci-qty-btn2" onclick="changeCartQty(\'' + item.id + '\',-1)" title="Remove">' + TRASH_SVG + '</button>'
            : '<button class="ci-qty-btn2" onclick="changeCartQty(\'' + item.id + '\',-1)">' + MINUS_SVG + '</button>';

        var noteClass   = item.note ? ' active' : '';
        var noteDisplay = item.note
            ? '<div class="ci-note-display" id="nd-' + item.id + '">Note: ' + escHtml(item.note) + '</div>'
            : '<div class="ci-note-display" id="nd-' + item.id + '" style="display:none;"></div>';

        html +=
            '<div class="ci-card">' +
                '<div class="ci-row">' +
                    imgBlock +
                    '<div class="ci-body">' +
                        '<div class="ci-name">' + escHtml(item.name) + '</div>' +
                        '<div class="ci-unit-price">' + fmt(item.price) + '</div>' +
                        '<div class="ci-controls">' +
                            '<div class="ci-qty-wrap">' +
                                minusBtn +
                                '<span class="ci-qty">' + item.qty + '</span>' +
                                '<button class="ci-qty-btn2" onclick="changeCartQty(\'' + item.id + '\',1)">+</button>' +
                            '</div>' +
                            '<button class="ci-note-btn' + noteClass + '" onclick="toggleNote(\'' + item.id + '\')" title="Add note">' + NOTE_SVG + '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="ci-subtotal">' + fmt(item.price * item.qty) + '</div>' +
                '</div>' +
                noteDisplay +
                '<div class="ci-note-row" id="nr-' + item.id + '">' +
                    '<input class="ci-note-input" type="text" placeholder="Special instructions..." value="' + escAttr(item.note) + '" oninput="updateNote(\'' + item.id + '\',this.value)">' +
                    '<button class="ci-note-save" onclick="saveNote(\'' + item.id + '\')">Save</button>' +
                '</div>' +
            '</div>';
    });

    body.innerHTML = html;
    var subtotal = cartTotal();
    var tax      = subtotal * 0.10;
    var total    = subtotal + tax;
    document.getElementById('drawerSubtotal').textContent = fmt(subtotal);
    document.getElementById('drawerTax').textContent      = fmt(tax);
    document.getElementById('drawerTotal').textContent    = fmt(total);
    placeBtn.disabled = false;
}

/* ---- Toggle note input ---- */
function toggleNote(id) {
    var row = document.getElementById('nr-' + id);
    var nd  = document.getElementById('nd-' + id);
    var isOpen = row.classList.contains('open');
    if (isOpen) {
        row.classList.remove('open');
    } else {
        row.classList.add('open');
        if (nd) nd.style.display = 'none';
        setTimeout(function(){ var inp = row.querySelector('input'); if(inp) inp.focus(); }, 50);
    }
}

/* ---- Save note ---- */
function saveNote(id) {
    refreshDrawer();   /* re-render so badge + display update */
}

/* ---- Open / close drawer ---- */
function openCart() {
    refreshDrawer();
    document.getElementById('drawerOverlay').classList.add('open');
    document.getElementById('cartDrawer').classList.add('open');
    try { document.body.classList.add('emenuCartOpen'); } catch(e) {}
}
function closeCart() {
    document.getElementById('drawerOverlay').classList.remove('open');
    document.getElementById('cartDrawer').classList.remove('open');
    try { document.body.classList.remove('emenuCartOpen'); } catch(e) {}
}

/* ---- Place order ---- */
function placeOrder() {
    if (cartCount() === 0) return;
    document.getElementById('cartJsonInput').value = JSON.stringify(Object.values(cart));
    document.getElementById('orderForm').submit();
}

/* ---- Category filter ---- */
var currentCat = 'ALL';
function filterCat(cat, btn) {
    currentCat = cat;
    document.querySelectorAll('.cat-btn').forEach(function(b){ b.classList.remove('active'); });
    btn.classList.add('active');
    applyFilters();
}

/* ---- Search filter ---- */
function filterMenu() { applyFilters(); }

function applyFilters() {
    var q = document.getElementById('searchInput').value.toLowerCase().trim();
    document.querySelectorAll('.item-card').forEach(function(card) {
        var name = (card.dataset.name || '').toLowerCase();
        var cat  = (card.dataset.cat  || '').toLowerCase();
        var matchCat    = currentCat === 'ALL' || cat === currentCat.toLowerCase();
        var matchSearch = !q || name.includes(q);
        card.style.display = (matchCat && matchSearch) ? '' : 'none';
    });
}

/* ---- Utils ---- */
function escHtml(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;')
                                     .replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
function escAttr(s){ return String(s).replace(/"/g,'&quot;'); }
</script>

<cfinclude template="/latest/ai/customer-launcher.cfm">

</body>
</html>
