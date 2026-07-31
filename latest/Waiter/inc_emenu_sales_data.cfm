<!---
    Shared e-menu sales analytics queries (last 7 days vs previous 7 days).
--->
<cfinclude template="../customer/inc_emenu_currency.cfm">
<cfset emenuSalesOk = false>
<cfset emenuSalesErr = "">
<cfset emenuWeekStart = dateAdd("d", -6, now())>
<cfset emenuWeekEnd = now()>
<cfset emenuThisRev = 0>
<cfset emenuThisOrders = 0>
<cfset emenuThisAvg = 0>
<cfset emenuLastRev = 0>
<cfset emenuLastOrders = 0>
<cfset emenuLastAvg = 0>
<cfset emenuRevPct = 0>
<cfset emenuOrdersPct = 0>
<cfset emenuAvgPct = 0>
<cfset emenuItemsPct = 0>
<cfset emenuThisItems = 0>
<cfset emenuLastItems = 0>
<cfset emenuBusiestDay = "-">
<cfset emenuPeakHourLabel = "-">
<cfset emenuTrendLabels = "[]">
<cfset emenuTrendValues = "[]">
<cfset emenuCategoryLabels = "[]">
<cfset emenuCategoryValues = "[]">
<cfif REQUEST.emenu_currency_decimals eq 0>
    <cfset emenuPriceFmt = "9,990">
<cfelse>
    <cfset emenuPriceFmt = "9,990.00">
</cfif>

<cftry>
    <cfquery name="qEmenuWeekStats" datasource="#dts#">
        SELECT
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                 AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                THEN o.total_amount ELSE 0 END), 0) AS this_rev,
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                 AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                THEN 1 ELSE 0 END), 0) AS this_orders,
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                 AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                THEN o.total_amount ELSE 0 END), 0) AS last_rev,
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                 AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                THEN 1 ELSE 0 END), 0) AS last_orders
        FROM app_orders o
        WHERE o.status NOT IN ('cancelled')
    </cfquery>

    <cfquery name="qEmenuItems" datasource="#dts#">
        SELECT
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                 AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                THEN i.quantity ELSE 0 END), 0) AS this_items,
            COALESCE(SUM(CASE
                WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                 AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                THEN i.quantity ELSE 0 END), 0) AS last_items
        FROM app_order_items i
        INNER JOIN app_orders o ON o.order_id = i.order_id
        WHERE o.status NOT IN ('cancelled')
    </cfquery>

    <cfquery name="qEmenuPeakHour" datasource="#dts#">
        SELECT HOUR(o.created_at) AS peak_hour,
               COUNT(*) AS order_count
        FROM app_orders o
        WHERE o.status NOT IN ('cancelled')
          AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
          AND o.created_at <  CURDATE() + INTERVAL 1 DAY
        GROUP BY HOUR(o.created_at)
        ORDER BY order_count DESC, peak_hour ASC
        LIMIT 1
    </cfquery>

    <cfquery name="qEmenuBusiestDay" datasource="#dts#">
        SELECT DAYNAME(o.created_at) AS day_name,
               COALESCE(SUM(o.total_amount), 0) AS day_rev
        FROM app_orders o
        WHERE o.status NOT IN ('cancelled')
          AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
          AND o.created_at <  CURDATE() + INTERVAL 1 DAY
        GROUP BY DAYNAME(o.created_at), DAYOFWEEK(o.created_at)
        ORDER BY day_rev DESC
        LIMIT 1
    </cfquery>

    <cfquery name="qEmenuTrend" datasource="#dts#">
        SELECT DATE(o.created_at) AS day_date,
               COALESCE(SUM(o.total_amount), 0) AS amount_total
        FROM app_orders o
        WHERE o.status NOT IN ('cancelled')
          AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
          AND o.created_at <  CURDATE() + INTERVAL 1 DAY
        GROUP BY DATE(o.created_at)
        ORDER BY day_date ASC
    </cfquery>

    <cfquery name="qEmenuCategory" datasource="#dts#">
        SELECT COALESCE(NULLIF(TRIM(c.CATEGORY), ''), 'Uncategorized') AS category_label,
               COALESCE(SUM(i.subtotal), 0) AS category_revenue
        FROM app_order_items i
        INNER JOIN app_orders o ON o.order_id = i.order_id
        LEFT JOIN icitem c ON TRIM(c.ITEMNO) = TRIM(i.item_code)
        WHERE o.status NOT IN ('cancelled')
          AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
          AND o.created_at <  CURDATE() + INTERVAL 1 DAY
        GROUP BY COALESCE(NULLIF(TRIM(c.CATEGORY), ''), 'Uncategorized')
        ORDER BY category_revenue DESC
    </cfquery>

    <cfset emenuThisRev = val(qEmenuWeekStats.this_rev)>
    <cfset emenuThisOrders = val(qEmenuWeekStats.this_orders)>
    <cfset emenuLastRev = val(qEmenuWeekStats.last_rev)>
    <cfset emenuLastOrders = val(qEmenuWeekStats.last_orders)>
    <cfset emenuThisItems = val(qEmenuItems.this_items)>
    <cfset emenuLastItems = val(qEmenuItems.last_items)>
    <cfif qEmenuBusiestDay.recordCount gt 0>
        <cfset emenuBusiestDay = trim(qEmenuBusiestDay.day_name)>
    </cfif>
    <cfif emenuThisOrders gt 0>
        <cfset emenuThisAvg = emenuThisRev / emenuThisOrders>
    <cfelse>
        <cfset emenuThisAvg = 0>
    </cfif>
    <cfif emenuLastOrders gt 0>
        <cfset emenuLastAvg = emenuLastRev / emenuLastOrders>
    <cfelse>
        <cfset emenuLastAvg = 0>
    </cfif>
    <cfif qEmenuPeakHour.recordCount gt 0>
        <cfset emenuPeakHourLabel = right("0" & val(qEmenuPeakHour.peak_hour), 2) & ":00">
    </cfif>

    <cfif emenuLastRev gt 0>
        <cfset emenuRevPct = round(((emenuThisRev - emenuLastRev) / emenuLastRev) * 1000) / 10>
    <cfelseif emenuThisRev gt 0>
        <cfset emenuRevPct = 100>
    </cfif>
    <cfif emenuLastOrders gt 0>
        <cfset emenuOrdersPct = round(((emenuThisOrders - emenuLastOrders) / emenuLastOrders) * 1000) / 10>
    <cfelseif emenuThisOrders gt 0>
        <cfset emenuOrdersPct = 100>
    </cfif>
    <cfif emenuLastAvg gt 0>
        <cfset emenuAvgPct = round(((emenuThisAvg - emenuLastAvg) / emenuLastAvg) * 1000) / 10>
    <cfelseif emenuThisAvg gt 0>
        <cfset emenuAvgPct = 100>
    </cfif>
    <cfif emenuLastItems gt 0>
        <cfset emenuItemsPct = round(((emenuThisItems - emenuLastItems) / emenuLastItems) * 1000) / 10>
    <cfelseif emenuThisItems gt 0>
        <cfset emenuItemsPct = 100>
    </cfif>

    <!--- Build 7-day trend arrays (fill missing days with zero) --->
    <cfset trendMap = structNew()>
    <cfloop query="qEmenuTrend">
        <cfset trendMap[dateFormat(qEmenuTrend.day_date, "yyyy-mm-dd")] = val(qEmenuTrend.amount_total)>
    </cfloop>
    <cfset trendLabelArr = arrayNew(1)>
    <cfset trendValueArr = arrayNew(1)>
    <cfloop from="0" to="6" index="di">
        <cfset dKey = dateFormat(dateAdd("d", di - 6, now()), "yyyy-mm-dd")>
        <cfset arrayAppend(trendLabelArr, dateFormat(dateAdd("d", di - 6, now()), "mmm d"))>
        <cfif structKeyExists(trendMap, dKey)>
            <cfset arrayAppend(trendValueArr, trendMap[dKey])>
        <cfelse>
            <cfset arrayAppend(trendValueArr, 0)>
        </cfif>
    </cfloop>
    <cfset emenuTrendLabels = serializeJSON(trendLabelArr)>
    <cfset emenuTrendValues = serializeJSON(trendValueArr)>

    <!--- Category pie: top 5 + Other --->
    <cfset catLabelArr = arrayNew(1)>
    <cfset catValueArr = arrayNew(1)>
    <cfset catOther = 0>
    <cfset catIdx = 0>
    <cfloop query="qEmenuCategory">
        <cfset catIdx = catIdx + 1>
        <cfif catIdx lte 5>
            <cfset arrayAppend(catLabelArr, qEmenuCategory.category_label)>
            <cfset arrayAppend(catValueArr, val(qEmenuCategory.category_revenue))>
        <cfelse>
            <cfset catOther = catOther + val(qEmenuCategory.category_revenue)>
        </cfif>
    </cfloop>
    <cfif catOther gt 0>
        <cfset arrayAppend(catLabelArr, "Other")>
        <cfset arrayAppend(catValueArr, catOther)>
    </cfif>
    <cfset emenuCategoryLabels = serializeJSON(catLabelArr)>
    <cfset emenuCategoryValues = serializeJSON(catValueArr)>

    <cfset emenuSalesOk = true>
    <cfcatch type="any">
        <cfset emenuSalesErr = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400)>
        <!--- Fallback without table_number (older schemas) --->
        <cftry>
            <cfquery name="qEmenuWeekStats2" datasource="#dts#">
                SELECT
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                         AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                        THEN o.total_amount ELSE 0 END), 0) AS this_rev,
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                         AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                        THEN 1 ELSE 0 END), 0) AS this_orders,
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                         AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                        THEN o.total_amount ELSE 0 END), 0) AS last_rev,
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                         AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                        THEN 1 ELSE 0 END), 0) AS last_orders
                FROM app_orders o
                WHERE o.status NOT IN ('cancelled')
            </cfquery>
            <cfquery name="qEmenuTrend2" datasource="#dts#">
                SELECT DATE(o.created_at) AS day_date,
                       COALESCE(SUM(o.total_amount), 0) AS amount_total
                FROM app_orders o
                WHERE o.status NOT IN ('cancelled')
                  AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                  AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                GROUP BY DATE(o.created_at)
                ORDER BY day_date ASC
            </cfquery>
            <cfquery name="qEmenuCategory2" datasource="#dts#">
                SELECT COALESCE(NULLIF(TRIM(c.CATEGORY), ''), 'Uncategorized') AS category_label,
                       COALESCE(SUM(i.subtotal), 0) AS category_revenue
                FROM app_order_items i
                INNER JOIN app_orders o ON o.order_id = i.order_id
                LEFT JOIN icitem c ON TRIM(c.ITEMNO) = TRIM(i.item_code)
                WHERE o.status NOT IN ('cancelled')
                  AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                  AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                GROUP BY COALESCE(NULLIF(TRIM(c.CATEGORY), ''), 'Uncategorized')
                ORDER BY category_revenue DESC
            </cfquery>
            <cfquery name="qEmenuPeakHour2" datasource="#dts#">
                SELECT HOUR(o.created_at) AS peak_hour, COUNT(*) AS order_count
                FROM app_orders o
                WHERE o.status NOT IN ('cancelled')
                  AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                  AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                GROUP BY HOUR(o.created_at)
                ORDER BY order_count DESC, peak_hour ASC
                LIMIT 1
            </cfquery>
            <cfquery name="qEmenuItems2" datasource="#dts#">
                SELECT
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                         AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                        THEN i.quantity ELSE 0 END), 0) AS this_items,
                    COALESCE(SUM(CASE
                        WHEN o.created_at >= DATE_SUB(CURDATE(), INTERVAL 13 DAY)
                         AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                        THEN i.quantity ELSE 0 END), 0) AS last_items
                FROM app_order_items i
                INNER JOIN app_orders o ON o.order_id = i.order_id
                WHERE o.status NOT IN ('cancelled')
            </cfquery>
            <cfquery name="qEmenuBusiestDay2" datasource="#dts#">
                SELECT DAYNAME(o.created_at) AS day_name,
                       COALESCE(SUM(o.total_amount), 0) AS day_rev
                FROM app_orders o
                WHERE o.status NOT IN ('cancelled')
                  AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
                  AND o.created_at <  CURDATE() + INTERVAL 1 DAY
                GROUP BY DAYNAME(o.created_at), DAYOFWEEK(o.created_at)
                ORDER BY day_rev DESC
                LIMIT 1
            </cfquery>

            <cfset emenuThisRev = val(qEmenuWeekStats2.this_rev)>
            <cfset emenuThisOrders = val(qEmenuWeekStats2.this_orders)>
            <cfset emenuLastRev = val(qEmenuWeekStats2.last_rev)>
            <cfset emenuLastOrders = val(qEmenuWeekStats2.last_orders)>
            <cfset emenuThisItems = val(qEmenuItems2.this_items)>
            <cfset emenuLastItems = val(qEmenuItems2.last_items)>
            <cfif qEmenuBusiestDay2.recordCount gt 0>
                <cfset emenuBusiestDay = trim(qEmenuBusiestDay2.day_name)>
            </cfif>
            <cfif emenuLastItems gt 0>
                <cfset emenuItemsPct = round(((emenuThisItems - emenuLastItems) / emenuLastItems) * 1000) / 10>
            <cfelseif emenuThisItems gt 0>
                <cfset emenuItemsPct = 100>
            </cfif>
            <cfif emenuThisOrders gt 0>
                <cfset emenuThisAvg = emenuThisRev / emenuThisOrders>
            <cfelse>
                <cfset emenuThisAvg = 0>
            </cfif>
            <cfif emenuLastOrders gt 0>
                <cfset emenuLastAvg = emenuLastRev / emenuLastOrders>
            <cfelse>
                <cfset emenuLastAvg = 0>
            </cfif>
            <cfif qEmenuPeakHour2.recordCount gt 0>
                <cfset emenuPeakHourLabel = right("0" & val(qEmenuPeakHour2.peak_hour), 2) & ":00">
            </cfif>
            <cfif emenuLastRev gt 0>
                <cfset emenuRevPct = round(((emenuThisRev - emenuLastRev) / emenuLastRev) * 1000) / 10>
            <cfelseif emenuThisRev gt 0>
                <cfset emenuRevPct = 100>
            </cfif>
            <cfif emenuLastOrders gt 0>
                <cfset emenuOrdersPct = round(((emenuThisOrders - emenuLastOrders) / emenuLastOrders) * 1000) / 10>
            <cfelseif emenuThisOrders gt 0>
                <cfset emenuOrdersPct = 100>
            </cfif>
            <cfif emenuLastAvg gt 0>
                <cfset emenuAvgPct = round(((emenuThisAvg - emenuLastAvg) / emenuLastAvg) * 1000) / 10>
            <cfelseif emenuThisAvg gt 0>
                <cfset emenuAvgPct = 100>
            </cfif>

            <cfset trendMap = structNew()>
            <cfloop query="qEmenuTrend2">
                <cfset trendMap[dateFormat(qEmenuTrend2.day_date, "yyyy-mm-dd")] = val(qEmenuTrend2.amount_total)>
            </cfloop>
            <cfset trendLabelArr = arrayNew(1)>
            <cfset trendValueArr = arrayNew(1)>
            <cfloop from="0" to="6" index="di">
                <cfset dKey = dateFormat(dateAdd("d", di - 6, now()), "yyyy-mm-dd")>
                <cfset arrayAppend(trendLabelArr, dateFormat(dateAdd("d", di - 6, now()), "mmm d"))>
                <cfif structKeyExists(trendMap, dKey)>
                    <cfset arrayAppend(trendValueArr, trendMap[dKey])>
                <cfelse>
                    <cfset arrayAppend(trendValueArr, 0)>
                </cfif>
            </cfloop>
            <cfset emenuTrendLabels = serializeJSON(trendLabelArr)>
            <cfset emenuTrendValues = serializeJSON(trendValueArr)>

            <cfset catLabelArr = arrayNew(1)>
            <cfset catValueArr = arrayNew(1)>
            <cfset catOther = 0>
            <cfset catIdx = 0>
            <cfloop query="qEmenuCategory2">
                <cfset catIdx = catIdx + 1>
                <cfif catIdx lte 5>
                    <cfset arrayAppend(catLabelArr, qEmenuCategory2.category_label)>
                    <cfset arrayAppend(catValueArr, val(qEmenuCategory2.category_revenue))>
                <cfelse>
                    <cfset catOther = catOther + val(qEmenuCategory2.category_revenue)>
                </cfif>
            </cfloop>
            <cfif catOther gt 0>
                <cfset arrayAppend(catLabelArr, "Other")>
                <cfset arrayAppend(catValueArr, catOther)>
            </cfif>
            <cfset emenuCategoryLabels = serializeJSON(catLabelArr)>
            <cfset emenuCategoryValues = serializeJSON(catValueArr)>
            <cfset emenuSalesOk = true>
            <cfset emenuSalesErr = "">
            <cfcatch type="any">
                <cfset emenuSalesErr = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400)>
            </cfcatch>
        </cftry>
    </cfcatch>
</cftry>
