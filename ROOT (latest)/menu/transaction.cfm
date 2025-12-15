<cfif getpin2.h2000 eq "T">
	<div class="menutitle" onClick="SwitchMenu('sub2')">Transaction</div>
</cfif>

<cfquery name="getGeneralInfo" datasource="#dts#">
	select * 
	from gsetup;
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
	select * 
	from modulecontrol;
</cfquery>

<span class="submenu" id="sub2">
<cfoutput>
<cfif getpin2.h2100 eq "T">
			<li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=rc" target="mainFrame">
					#getGeneralInfo.lRC#
				</a>
			</li>
		</cfif>
        <cfif getpin2.h2200 eq "T">
			<li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=pr" target="mainFrame">
					#getGeneralInfo.lPR#
				</a>
			</li>
		</cfif>
<cfif getpin2.h2500 eq "T">
			<li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=INV" target="mainFrame">
					#getGeneralInfo.lINV#
				</a>
			</li>
            <li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=DO" target="mainFrame">
					#getGeneralInfo.lDO#
				</a>
			</li>
            <li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=SO" target="mainFrame">
					#getGeneralInfo.lSO#
				</a>
			</li>
			<li>
				<a href="/#HDir#/transaction/transaction.cfm?tran=cs" target="mainFrame">
					#getGeneralInfo.lCS#
				</a>
			</li>
             <li>
				<a href="/#HDir#/transaction/deposit/deposittable.cfm" target="mainFrame">
					Deposit
				</a>
			</li>
            </cfif>

            <li>
			<a href="/#HDir#/maintenance/dailyopening/s_dailycountertable.cfm" target="mainFrame">
				Cash Recording maintenance
			</a>
		</li>
        <cfif getpin2.h2800 eq "T">
			<li>
				<a href="/#HDir#/transaction/otransaction.cfm" target="mainFrame">
					Other Transaction
				</a>
			</li>
		</cfif>
       
		

        	

<li>
		<a href="/newbody.cfm" target="mainFrame" onclick="popup('/#HDir#/transaction/POS/index.cfm?first=true')">
				POS Transaction
			</a>            
		</li>
        <li>
        <a href="/default/admin/possync/index.cfm" target="mainFrame" >POS Sync</a>
        </li>
          <li>
        <a href="/default/transaction/pospayment/index.cfm" target="mainFrame" >POS Control</a>
        </li>
        <li>
        <a href="/default/transaction/POSSubmission/POSSubmission.cfm" target="mainFrame" >POS Submission</a>
        </li>
	
</cfoutput>
</span>