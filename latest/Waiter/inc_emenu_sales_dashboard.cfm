<!---
    Reusable e-menu sales dashboard (KPI cards + charts).
    Requires inc_emenu_sales_data.cfm included first.
    Optional: emenuDashCompact = true for overview embed.
--->
<cfparam name="emenuDashCompact" default="false">
<cfif NOT isDefined("emenuSalesOk")>
    <cfinclude template="inc_emenu_sales_data.cfm">
</cfif>

<cfset revTrendCls = "neutral">
<cfset revTrendText = numberFormat(emenuRevPct, "999.9") & "% from last week">
<cfif emenuRevPct gt 0><cfset revTrendCls = "up"><cfset revTrendText = "+" & revTrendText>
<cfelseif emenuRevPct lt 0><cfset revTrendCls = "down"></cfif>

<cfset ordTrendCls = "neutral">
<cfset ordTrendText = numberFormat(emenuOrdersPct, "999.9") & "% from last week">
<cfif emenuOrdersPct gt 0><cfset ordTrendCls = "up"><cfset ordTrendText = "+" & ordTrendText>
<cfelseif emenuOrdersPct lt 0><cfset ordTrendCls = "down"></cfif>

<cfset avgTrendCls = "neutral">
<cfset avgTrendText = numberFormat(emenuAvgPct, "999.9") & "% from last week">
<cfif emenuAvgPct gt 0><cfset avgTrendCls = "up"><cfset avgTrendText = "+" & avgTrendText>
<cfelseif emenuAvgPct lt 0><cfset avgTrendCls = "down"></cfif>

<cfset itemsTrendCls = "neutral">
<cfset itemsTrendText = numberFormat(emenuItemsPct, "999.9") & "% from last week">
<cfif emenuItemsPct gt 0><cfset itemsTrendCls = "up"><cfset itemsTrendText = "+" & itemsTrendText>
<cfelseif emenuItemsPct lt 0><cfset itemsTrendCls = "down"></cfif>

<cfoutput>
<section class="emenu-sales-dashboard<cfif emenuDashCompact> compact</cfif>">
    <cfif NOT emenuDashCompact>
    <div class="emenu-sales-head">
        <h1 class="emenu-sales-title">Sales History</h1>
        <p class="emenu-sales-subtitle">Track your restaurant's performance and analytics</p>
    </div>
    </cfif>

    <cfif NOT emenuSalesOk>
        <div class="emenu-sales-alert">E-Menu sales dashboard is unavailable: #HTMLEditFormat(emenuSalesErr)#</div>
    <cfelse>
        <div class="emenu-kpi-grid">
            <div class="emenu-kpi-card">
                <div class="emenu-kpi-top">
                    <div class="emenu-kpi-label">Total Revenue</div>
                    <span class="emenu-kpi-icon orange" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    </span>
                </div>
                <div class="emenu-kpi-value">#REQUEST.emenu_currency_symbol# #numberFormat(emenuThisRev, emenuPriceFmt)#</div>
                <div class="emenu-kpi-trend #revTrendCls#">#revTrendText#</div>
            </div>

            <div class="emenu-kpi-card">
                <div class="emenu-kpi-top">
                    <div class="emenu-kpi-label">Total Orders</div>
                    <span class="emenu-kpi-icon blue" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18M16 10a4 4 0 0 1-8 0"/></svg>
                    </span>
                </div>
                <div class="emenu-kpi-value">#int(emenuThisOrders)#</div>
                <div class="emenu-kpi-trend #ordTrendCls#">#ordTrendText#</div>
            </div>

            <div class="emenu-kpi-card">
                <div class="emenu-kpi-top">
                    <div class="emenu-kpi-label">Avg Order Value</div>
                    <span class="emenu-kpi-icon green" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3v18h18"/><path d="m19 9-5 5-4-4-3 3"/></svg>
                    </span>
                </div>
                <div class="emenu-kpi-value">#REQUEST.emenu_currency_symbol# #numberFormat(emenuThisAvg, emenuPriceFmt)#</div>
                <div class="emenu-kpi-trend #avgTrendCls#">#avgTrendText#</div>
            </div>

            <div class="emenu-kpi-card">
                <div class="emenu-kpi-top">
                    <div class="emenu-kpi-label">Items Sold</div>
                    <span class="emenu-kpi-icon purple" aria-hidden="true">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13 5.4 5M7 13l-2.3 4.6A1 1 0 0 0 5.6 19H17"/><circle cx="9" cy="21" r="1"/><circle cx="18" cy="21" r="1"/></svg>
                    </span>
                </div>
                <div class="emenu-kpi-value">#int(emenuThisItems)#</div>
                <div class="emenu-kpi-trend #itemsTrendCls#">#itemsTrendText#</div>
                <div class="emenu-kpi-meta">Busiest day: #emenuBusiestDay#</div>
            </div>
        </div>

        <div class="emenu-chart-grid">
            <div class="emenu-chart-card">
                <h3 class="emenu-chart-title">Revenue Trend</h3>
                <div class="emenu-chart-canvas-wrap">
                    <canvas id="emenuRevenueTrendChart" aria-label="Revenue trend chart"></canvas>
                </div>
            </div>
            <div class="emenu-chart-card">
                <h3 class="emenu-chart-title">Sales by Category</h3>
                <div class="emenu-chart-canvas-wrap">
                    <canvas id="emenuCategoryPieChart" aria-label="Sales by category chart"></canvas>
                </div>
            </div>
        </div>

        <script type="text/javascript">
        window.EMENU_SALES_DATA = {
            currencySymbol: #serializeJSON(REQUEST.emenu_currency_symbol)#,
            currencyDecimals: #val(REQUEST.emenu_currency_decimals)#,
            trendLabels: #emenuTrendLabels#,
            trendValues: #emenuTrendValues#,
            categoryLabels: #emenuCategoryLabels#,
            categoryValues: #emenuCategoryValues#
        };
        </script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
        <script type="text/javascript" src="/latest/js/waiter/sales-history.js"></script>
    </cfif>
</section>
</cfoutput>
