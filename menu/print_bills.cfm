<cfif getpin2.h6000 eq "T"><div class="menutitle" onClick="SwitchMenu('sub8')">Print Bills</div></cfif>

<cfoutput>
<span class="submenu" id="sub8">
<cfif getpin2.h6100 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=INV&name=Invoice&BilType=" target="mainFrame">
			Invoice
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6200 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=CS&name=Cash Bills&BilType=" target="mainFrame">
			Cash Bills
		</a>
	</li>
    </cfif>
	<hr/>
    <cfif getpin2.h6300 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=CN&name=Credit Note&BilType=" target="mainFrame">
			Credit Note
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6400 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=DN&name=Debit Note&BilType=" target="mainFrame">
			Debit Note
		</a>
	</li>
    </cfif>
	<hr/>
    <cfif getpin2.h6500 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=RC&name=Receive&BilType=" target="mainFrame">
			Receive
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6600 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=PR&name=Purchase Return&BilType=" target="mainFrame">
			Purchase Return
		</a>
	</li>
    </cfif>
	<hr/>
    <cfif getpin2.h6700 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=DO&name=Delivery Order&BilType=DO" target="mainFrame">
			Delivery Order
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6800 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=DO&name=Packing List&BilType=" target="mainFrame">
			Packing List
		</a>
	</li>
    </cfif>
	<hr/>
    <cfif getpin2.h6900 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=PO&name=Purchase Order&BilType=" target="mainFrame">
			Purchase Order
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6A00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=SO&name=Sales Order&BilType=" target="mainFrame">
			Sales Order
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6B00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=QUO&name=Quotation&BilType=" target="mainFrame">
			Quotation
		</a>
	</li>
    </cfif>
	<hr/>
    <cfif getpin2.h6C00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=ISS&name=Issue&BilType=" target="mainFrame">
			Issue
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6D00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=OAI&name=Adjustment Increase&BilType=" target="mainFrame">
			Adjustment Increase
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6E00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=OAR&name=Adjustment Reduce&BilType=" target="mainFrame">
			Adjustment Reduce
		</a>
	</li>
    </cfif>
    
	<hr/>
    <cfif getpin2.h6F00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note&BilType=" target="mainFrame">
			Transfer Note
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6G00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note 2&BilType=" target="mainFrame">
			Transfer Note 2
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6H00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Note&BilType=" target="mainFrame">
			Consignment Note
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6I00 eq "T">
	<li>
		<a href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Return&BilType=" target="mainFrame">
			Consignment Return
		</a>
	</li>
    </cfif>
	<!--- SPECIAL REPORT FUNCTION --->
	<cfinclude template = "print_bills_special.cfm">
	<!--- SPECIAL REPORT FUNCTION --->
</span>
</cfoutput>