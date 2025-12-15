<cfif lcase(hcomid) eq "ubs_i" or lcase(hcomid) eq "net_i" or lcase(hcomid) eq "imk_i">
	<div class="menutitle" onClick="SwitchMenu('sub6')">CRM</div>
	<span class="submenu" id="sub6">
		<cfoutput>
		<cfif lcase(hcomid) neq "imk_i">
			<li>
				<a href="/#HDir#/crm/createjob.cfm" target="mainFrame">
					Create Jobsheet
				</a>
			</li>
			<li>
				<a href="/#HDir#/crm/viewjob.cfm" target="mainFrame">
					View Jobsheet
				</a>
			</li>
			<li>
				<a href="/#HDir#/crm/customerhistory.cfm" target="mainFrame">
					View Customer History
				</a>
			</li>
			<li>
				<a href="/#HDir#/crm/viewschedule.cfm" target="mainFrame">
					View Schedule
				</a>
			</li>
		</cfif>
		<li>
			<a href="/#HDir#/crm/rptexpire.cfm" target="mainFrame">
				View Expire Contract
			</a>
		</li>
		<li>
			<a href="/#HDir#/crm/chkcntct.cfm" target="mainFrame">
				Check Contract
			</a>
		</li>
		<cfif lcase(hcomid) eq "net_i">
			<li>
                <a href="/#HDir#/crm/cust_maintenance/index.cfm" target="_blank">
                    Customer Account
                </a>
            </li>
		</cfif>
		</cfoutput>
	</span>
</cfif>