<cfif getpin2.h3000 eq "T">
	<div class="menutitle" onClick="SwitchMenu('sub3')">Enquires</div>
</cfif>

<cfoutput>
<span class="submenu" id="sub3">
	<cfif husergrpid eq "admin" or husergrpid eq "super">
		<li>
			<a href="/#HDir#/enquires/billsummary.cfm" target="mainFrame">
				Bill Summary Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h3500 eq "T">
		<li>
			<a href="/#HDir#/enquires/historypriceenquiry/historypricemenu.cfm" target="mainFrame">
				History Price Enquiry
			</a>
		</li>
	</cfif>
	<cfif getpin2.h3400 eq "T">
		<li>
			<a href="/#HDir#/enquires/inforecast.cfm?type=Inventory" target="mainFrame">
				Inventory Forcast
			</a>
		</li>
	</cfif>
	<cfif getpin2.h3200 eq "T">
		<li>
			<a href="/#HDir#/enquires/outstandmenu.cfm" target="mainFrame">
				Outstanding And Tracking
			</a>
		</li>
	</cfif>
	<cfif getpin2.h3100 eq "T">
		<li>
			<a href="/#HDir#/enquires/inventorybalance_menu.cfm" target="mainFrame">
				Inventory Balance Check
			</a>
		</li>
	</cfif>
	<cfif husergrpid eq "admin" or husergrpid eq "super">
		<li>
			<a href="/#HDir#/enquires/traceitem_costvalue_menu.cfm" target="mainFrame">
				Trace Item Cost & Value
			</a>
		</li>
	</cfif>
    <cfif husergrpid eq "admin" or husergrpid eq "super">
		<li>
			<a href="/#HDir#/enquires/refno2check.cfm" target="mainFrame">
				Trace Refno 2 duplicate
			</a>
		</li>
	</cfif>
    <cfif getpin2.h3100 eq "T">
		<li>
			<a href="/#HDir#/report-exception/exceptionreportmenu.cfm" target="mainFrame">Exception Report</a>
		</li>
	</cfif>
    
     <cfif getpin2.h3100 eq "T">
		<li>
			<a href="/#HDir#/enquires/noacceptreportmenu.cfm" target="mainFrame">Bills Not Accepted Report</a>
		</li>
	</cfif>
    
</cfoutput>

<!--- SPECIAL ENQUIRES FUNCTION --->
<cfinclude template = "enquires_special.cfm">
<!--- SPECIAL ENQUIRES FUNCTION --->
</span>