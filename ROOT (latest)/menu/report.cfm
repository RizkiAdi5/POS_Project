<cfif getpin2.h4000 eq "T">
	<div class="menutitle" onClick="SwitchMenu('sub4')">Reports</div>
</cfif>

<span class="submenu" id="sub4">
<cfoutput>
	<cfif getpin2.h4100 eq "T">
		<li>
			<a href="/#HDir#/report-billing/bill_listingmenu.cfm" target="mainFrame">
				Bill Listing
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4200 eq "T">
		<li>
			<a href="/#HDir#/report-stock/stock_listingmenu.cfm" target="mainFrame">
				Inventory Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4300 eq "T">
		<li>
			<a href="/#HDir#/report-sales/salesmenu.cfm" target="mainFrame">
				Sales Report
			</a>
		</li>
	</cfif>
 	<cfif getpin2.h4400 eq "T">
		<li>
			<a href="/#HDir#/report-purchase/purchasemenu.cfm" target="mainFrame">
				Purchase Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4800 eq "T">
		<li>
			<a href="/#HDir#/report-item/itemreportmenu.cfm" target="mainFrame">
				Cust/Supp/Agent/Area Item Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4500 eq "T">
		<li>
			<a href="/#HDir#/report-location/location_listingmenu.cfm" target="mainFrame">
				#getgeneral.lLOCATION# Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4600 eq "T">
		<li>
			<a href="/#HDir#/report-others/other_listingmenu.cfm" target="mainFrame">
				Serial Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4900 eq "T">
    	<cfquery name="checkcustom" datasource="#dts#">
            select customcompany from dealer_menu
        </cfquery>
		<li>
			<a href="/#HDir#/report-batch/batchcodereportmenu.cfm" target="mainFrame">
				<cfif checkcustom.customcompany eq "Y">Lot Number<cfelse>Batch Code</cfif> Report
			</a>
		</li>
	</cfif>
	<cfif getpin2.h4A00 eq "T">
		<li>
			<a href="/#HDir#/report-gradeditem/gradeditemreportmenu.cfm" target="mainFrame">Graded Item Report</a>
		</li>
	</cfif>
	<cfif getpin2.h4B00 eq "T">
		<li>
			<a href="/#HDir#/report-matrixitem/matrixitemreportmenu.cfm" target="mainFrame">Matrix Item Report</a>
		</li>
	</cfif>
	<cfif getpin2.h4C00 eq "T">
		<li>
			<a href="/#HDir#/report-project/projectreportmenu.cfm" target="mainFrame">#getgeneral.lPROJECT# Report</a>
		</li>
	</cfif>
    	<cfif getpin2.h4D00 eq "T">
		<li>
			<a href="/#HDir#/report-service/servicereportmenu.cfm" target="mainFrame">Service Report</a>
		</li>
	</cfif>
    	<cfif getpin2.h4E00 eq "T">
		<li>
			<a href="/#HDir#/report-store/storereportmenu.cfm" target="mainFrame">Store Keeper Report</a>
		</li>
	</cfif>
    <cfif getpin2.h4F00 eq "T">
		<li>
			<a href="/#HDir#/report-manufacturing/manufacturingmenu.cfm" target="mainFrame">Manufacturing Report</a>
		</li>
	</cfif>
    
    
</cfoutput>
<cfif getpin2.h4H00 eq "T">
<!--- SPECIAL REPORT FUNCTION --->
<cfinclude template = "report_special.cfm">
<!--- SPECIAL REPORT FUNCTION --->
</cfif>
</span>