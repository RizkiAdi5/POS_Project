<cfif getpin2.h1000 eq "T">
	<div class="menutitle" onClick="SwitchMenu('sub1')">Maintenance</div>
</cfif>

<span class="submenu" id="sub1">
<cfoutput>
	<cfif getpin2.h1200 eq "T">
		<li>
			<a href="/#HDir#/maintenance/linkPage.cfm?type=Customer" target="mainFrame">
				Customer Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1100 eq "T">
		<li>
			<a href="/#HDir#/maintenance/linkPage.cfm?type=Supplier" target="mainFrame">
				Supplier Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1300 eq "T">
		<li>
			<a href="/#HDir#/maintenance/s_icitem.cfm?type=icitem" target="mainFrame">
				Product Profile
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1G00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/servicetable.cfm" target="mainFrame">
				Service Profile
			</a>
		</li>
	</cfif>
    <cfif lcase(HcomID) eq "beps_i">
    	<li>
			<a href="/#HDir#/maintenance/Placement/Placementtable.cfm" target="mainFrame">
				Placement Profile
			</a>
		</li>
    </cfif>

	<hr/>
	<cfif getpin2.h1400 eq "T">
		<li>
			<a href="/#HDir#/maintenance/categorytable.cfm" target="mainFrame">
				#getgeneral.lcategory# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1500 eq "T">
		<li>
			<a href="/#HDir#/maintenance/grouptable.cfm" target="mainFrame">
				#getgeneral.lgroup# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1600 eq "T">
		<li>
			<a href="/#HDir#/maintenance/sizeidtable.cfm" target="mainFrame">
				#getgeneral.lsize# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1700 eq "T">
		<li>
			<a href="/#HDir#/maintenance/costcodetable.cfm" target="mainFrame">
				#getgeneral.lrating# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1800 eq "T">
		<li>
			<a href="/#HDir#/maintenance/coloridtable.cfm" target="mainFrame">
				#getgeneral.lMaterial# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1900 eq "T">
		<li>
			<a href="/#HDir#/maintenance/shelftable.cfm" target="mainFrame">
				#getgeneral.lModel# Profile
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1P00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/brandtable.cfm" target="mainFrame">
				Brand Profile
			</a>
		</li>
	</cfif>
    
	<hr/>
	<cfif getpin2.h1F00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/addresstable.cfm" target="mainFrame">
				Address Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1B00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/agenttable.cfm" target="mainFrame">
				#getgeneral.lAGENT# Profile
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1B00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/teamtable.cfm" target="mainFrame">
				#getgeneral.lTeam# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1D00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/areatable.cfm" target="mainFrame">
				Area Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1J00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/bom.cfm" target="mainFrame">
				Bill of Material
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1S00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/businesstable.cfm" target="mainFrame">
				Business Profile
			</a>
		</li>
   </cfif>
	<cfif getpin2.h1E00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/commenttable.cfm" target="mainFrame">
				Comment Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1C00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/vdriver.cfm" target="mainFrame">
				#getgeneral.lDRIVER# Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1D00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/S_locationtable.cfm" target="mainFrame">
				#getgeneral.lLOCATION# Profile
			</a>
		</li>
	</cfif>
	
	<cfif getpin2.h1H00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/Projecttable.cfm" target="mainFrame">
				#getgeneral.lPROJECT# Profile
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1H00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/Job/Projecttable.cfm" target="mainFrame">
				#getgeneral.lJOB# Profile
			</a>
		</li>
	</cfif>
	
	<cfif getpin2.h1I00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/termtable.cfm" target="mainFrame">
				Term Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1A00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/unittable.cfm" target="mainFrame">
				Unit of Measurement
			</a>
		</li>
        <li>
			<a href="/#HDir#/maintenance/counter/countertable.cfm" target="mainFrame">
				Counter
			</a>
		</li>
        
         
	</cfif>
    
	<cfif getpin2.h1K00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/openqtymaintenance/openqtymenu.cfm" target="mainFrame">
				Opening Qty Maintenance
			</a>
		</li>
	</cfif>
	<hr/>
	<cfif getpin2.h1L00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/s_colorsizetable.cfm" target="mainFrame">
				Color - Size Maintenance
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1M00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/s_matrixitemtable.cfm" target="mainFrame">
				Matrix Item Maintenance
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1N00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/s_titletable.cfm" target="mainFrame">
				Title Maintenance
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1O00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/symbol/symbolMaintenance.cfm" target="mainFrame">
				Symbol Maintenance
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1Q00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/vehicles/vehicles.cfm" target="mainFrame">
				Vehicles Profile
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1U00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/vattention.cfm" target="mainFrame">
				Attention Profile
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1X00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/languagetable.cfm" target="mainFrame">
				Language Profile
			</a>
		</li>
        </cfif>
    <cfif getpin2.h1Y00 eq "T">    
        <li>
			<a href="/#HDir#/maintenance/termsandconditiontable.cfm" target="mainFrame">
				Terms and Condition Maintenance
			</a>
		</li>
        </cfif>

    <cfif getpin2.h1R00 eq "T">
		<li>
			<a href="/#HDir#/maintenance/voucher/voucher.cfm" target="mainFrame">
				Vouchers Profile
			</a>
		</li>
        <li>
			<a href="/#HDir#/maintenance/promotion/p_vehicles.cfm" target="mainFrame">
				Promotion
			</a>
		</li>
         <li>
			<a href="/#HDir#/maintenance/commission/" target="mainFrame">
				Commission
			</a>
		</li>
	</cfif>
    <cfif lcase(HcomID) eq "unichem_i">
    <li>
			<a href="/#HDir#/maintenance/contract/" target="mainFrame">
				Service Agreement
			</a>
		</li>
	</cfif>
    <cfif lcase(HcomID) eq "mcjim_i">
       <li>
			<a href="/#HDir#/maintenance/itemforecastmaintainece/" target="mainFrame">
				Inventory Forecast Maintenance
			</a>
		</li>
    </cfif>
     <cfif getpin2.h1V00 eq "T">
     <li>
			<a href="/#HDir#/maintenance/recurrgroup/recurrmain.cfm" target="mainFrame">
				Recurr Group
			</a>
		</li>
        </cfif>
        <cfif getpin2.h1Z50 eq "T">
        <li>
			<a href="/#HDir#/maintenance/counter/countertable.cfm" target="mainFrame">
				Counter
			</a>
		</li>
       </cfif>
        <cfif getpin2.h1Z60 eq "T">
        <li>
			<a href="/#HDir#/maintenance/cashiertable.cfm" target="mainFrame">
				Cashier Profile
			</a>
		</li>
        </cfif>
        <cfif getpin2.h1Z70 eq "T">
        <li>
			<a href="/#HDir#/maintenance/discounttable.cfm" target="mainFrame">
				Discount Profile
			</a>
		</li>
        </cfif>
        <cfif getpin2.h1Z80 eq "T">
        <li>
			<a href="/#HDir#/maintenance/vouchertype/vouchertable.cfm" target="mainFrame">
				Voucher Type
			</a>
		</li>
        </cfif>
        <cfif lcase(HcomID) eq "hunting_i">
     <li>
			<a href="/#HDir#/maintenance/hunting/index.cfm" target="_blank">
				Hunting
			</a>
		</li>
        </cfif>
</cfoutput>

<!--- SPECIAL MAINTENANCE FUNCTION --->
<cfinclude template = "maintenance_special.cfm">
<!--- SPECIAL MAINTENANCE FUNCTION --->
</span>