<!---
    /latest/customer/order_confirm.cfm
    Order confirmation page — shown after orderProcess.cfm saves the order.
    Matches Figma order-confirmation design.
--->
<cfinclude template="../../application.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif NOT len(trim(SESSION.emenu_order_number))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- Pull values from session --->
<cfset orderNumber     = SESSION.emenu_order_number>
<cfset orderNumDisplay = chr(35) & orderNumber><!--- builds "#ORD-..." safely --->

<cfset orderTotal   = val(SESSION.emenu_order_total)>
<cfset orderSubtot  = val(SESSION.emenu_order_subtot)>
<cfset orderTax     = val(SESSION.emenu_order_tax)>
<cfset pointsEarned = val(SESSION.emenu_points_earned)>
<cfset tableDisplay = len(trim(SESSION.emenu_table_number)) ? "Table " & SESSION.emenu_table_number : "Your Table">
<cfset isLoyalty    = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)))>

<!--- Fetch order items for the summary --->
<cftry>
    <cfquery name="qItems" datasource="#dts#">
        SELECT quantity, unit_price, subtotal, special_instructions, status AS kitchen_status,
               COALESCE(item_name, item_code) AS item_name
        FROM   app_order_items
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_order_id#">
        ORDER  BY item_id ASC
    </cfquery>
    <cfcatch type="any">
        <cfset qItems = queryNew("quantity,unit_price,subtotal,special_instructions,kitchen_status,item_name")>
    </cfcatch>
</cftry>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Order Confirmed</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f3f4f6;min-height:100vh;}

        .conf-header{
            background:linear-gradient(135deg,#F54900 0%,#D04000 100%);
            padding:48px 20px 80px;
            border-radius:0 0 48px 48px;
            text-align:center;
        }
        .check-circle{
            width:80px;height:80px;background:#fff;border-radius:50%;
            display:inline-flex;align-items:center;justify-content:center;margin-bottom:16px;
        }
        .check-circle svg{width:48px;height:48px;color:#F54900;}
        .conf-title{font-size:26px;font-weight:800;color:#fff;margin-bottom:8px;}
        .conf-sub  {color:rgba(255,255,255,.85);font-size:14px;margin-bottom:24px;}
        .order-num-box{
            background:rgba(255,255,255,.2);backdrop-filter:blur(8px);
            border-radius:16px;padding:16px 32px;display:inline-block;
        }
        .order-num-label{font-size:12px;color:rgba(255,255,255,.8);margin-bottom:4px;}
        .order-num-val  {font-size:22px;font-weight:800;color:#fff;letter-spacing:1px;}

        .body{padding:0 16px 32px;margin-top:-52px;}

        .thank-box{
            background:#fff7ed;border:1px solid #fed7aa;border-radius:16px;
            padding:14px 20px;text-align:center;font-size:13px;color:#c2410c;
            margin-bottom:16px;
        }

        .card{background:#fff;border-radius:24px;padding:20px;margin-bottom:16px;
              box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0;}

        .order-meta{display:flex;align-items:center;justify-content:space-between;
                    padding-bottom:16px;border-bottom:1px solid #f3f4f6;margin-bottom:16px;}
        .meta-left {display:flex;align-items:center;gap:12px;}
        .meta-icon {background:#fff7ed;padding:10px;border-radius:12px;}
        .meta-icon svg{width:20px;height:20px;color:#F54900;}
        .meta-label{font-size:12px;color:#9ca3af;margin-bottom:2px;}
        .meta-val  {font-size:14px;font-weight:600;color:#111;}
        .eta       {display:flex;align-items:center;gap:6px;color:#F54900;font-size:14px;font-weight:600;}
        .eta svg   {width:18px;height:18px;}

        .section-title{font-size:15px;font-weight:700;color:#111;margin-bottom:14px;}
        .item-row  {display:flex;justify-content:space-between;align-items:flex-start;
                    padding:10px 0;border-bottom:1px solid #f9fafb;}
        .item-row:last-child{border-bottom:none;}
        .item-name {font-size:14px;color:#111;}
        .item-qty  {font-size:13px;color:#9ca3af;margin-top:2px;}
        .item-note {font-size:12px;color:#c2410c;margin-top:4px;font-style:italic;}
        .item-price{font-size:14px;font-weight:600;color:#111;white-space:nowrap;padding-left:12px;}

        .total-section{margin-top:14px;padding-top:14px;border-top:1px solid #f3f4f6;}
        .total-row {display:flex;justify-content:space-between;font-size:13px;
                    color:#6b7280;margin-bottom:6px;}
        .total-row.grand{font-size:15px;font-weight:700;color:#111;
                         padding-top:10px;border-top:1px solid #f3f4f6;margin-top:4px;}

        .points-box{
            border-radius:16px;padding:16px;margin-bottom:16px;
            background:linear-gradient(to right,##fff4ed,##ffead9);
            border:2px solid #F54900;
            display:flex;align-items:center;gap:14px;
        }
        .pts-icon{width:48px;height:48px;background:#F54900;border-radius:14px;
                  display:flex;align-items:center;justify-content:center;flex-shrink:0;}
        .pts-icon svg{width:24px;height:24px;color:#fff;}
        .pts-title{font-size:14px;font-weight:700;color:#111;margin-bottom:3px;}
        .pts-sub  {font-size:13px;color:#9ca3af;}

        .btn-menu{
            display:block;width:100%;padding:16px;border-radius:14px;
            background:#F54900;color:#fff;text-align:center;
            font-size:16px;font-weight:700;border:none;cursor:pointer;
            text-decoration:none;margin-bottom:10px;
        }
        .btn-status{
            display:block;width:100%;padding:14px;border-radius:14px;
            background:#fff;color:#F54900;text-align:center;
            font-size:15px;font-weight:700;border:2px solid #F54900;
            text-decoration:none;
        }
    </style>
</head>
<body>
<cfoutput>

<div class="conf-header">
    <div class="check-circle">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
    </div>
    <div class="conf-title">Order Confirmed!</div>
    <div class="conf-sub">Your food is being prepared</div>
    <div class="order-num-box">
        <div class="order-num-label">Order Number</div>
        <div class="order-num-val">#orderNumDisplay#</div>
    </div>
</div>

<div class="body">

    <div class="thank-box">
        Thank you for ordering, please wait patiently &mdash; your order is being prepared!
    </div>

    <!--- Order summary card --->
    <div class="card">
        <div class="order-meta">
            <div class="meta-left">
                <div class="meta-icon">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z"/>
                    </svg>
                </div>
                <div>
                    <div class="meta-label">Table Number</div>
                    <div class="meta-val">#HTMLEditFormat(tableDisplay)#</div>
                </div>
            </div>
            <div class="eta">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                15-20 min
            </div>
        </div>

        <div class="section-title">Order Summary</div>

        <cfif qItems.recordCount>
            <cfloop query="qItems">
                <div class="item-row">
                    <div>
                        <div class="item-name">#HTMLEditFormat(qItems.item_name)#</div>
                        <div class="item-qty">x#qItems.quantity#</div>
                        <cfif len(trim(qItems.special_instructions))>
                            <div class="item-note">Note: #HTMLEditFormat(qItems.special_instructions)#</div>
                        </cfif>
                    </div>
                    <div class="item-price">RM #numberFormat(val(qItems.subtotal),'9.00')#</div>
                </div>
            </cfloop>
        </cfif>

        <div class="total-section">
            <div class="total-row">
                <span>Subtotal</span><span>RM #numberFormat(orderSubtot,'9.00')#</span>
            </div>
            <div class="total-row">
                <span>Tax (10%)</span><span>RM #numberFormat(orderTax,'9.00')#</span>
            </div>
            <div class="total-row grand">
                <span>Total</span><span>RM #numberFormat(orderTotal,'9.00')#</span>
            </div>
        </div>
    </div>

    <!--- Points earned banner (loyalty members only) --->
    <cfif isLoyalty AND pointsEarned gt 0>
    <div class="points-box">
        <div class="pts-icon">
            <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
            </svg>
        </div>
        <div>
            <div class="pts-title">You earned points!</div>
            <div class="pts-sub">+#numberFormat(pointsEarned,'9,999')# points added to your account</div>
        </div>
    </div>
    </cfif>

    <!--- CTA buttons --->
    <a href="/latest/customer/menu.cfm" class="btn-menu">Order More</a>
    <a href="/latest/customer/order_status.cfm" class="btn-status">Track My Order</a>

</div>
</cfoutput>
</body>
</html>
