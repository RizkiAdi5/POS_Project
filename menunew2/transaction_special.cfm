<cfswitch expression="#lcase(hcomid)#">
	<cfcase value="fdipx_i">
		<hr/>
		<!--- <li>
			<a href="/feeder_impex/printing_job_order/printing_job_order.cfm" target="mainFrame">
				Printing Job Order
			</a>
		</li>
		<hr/> --->
		<li>
			<a href="/customized/fdipx_i/printing_job_order/printing_job_order.cfm" target="mainFrame">
				Printing Job Order
			</a>
		</li>
		<hr/>
	</cfcase>
    <cfcase value="ulp_i">
		<hr/>
		<!--- <li>
			<a href="/feeder_impex/printing_job_order/printing_job_order.cfm" target="mainFrame">
				Printing Job Order
			</a>
		</li>
		<hr/> --->
		<li>
			<a href="/customized/ulp_i/printing_job_order/printing_job_order.cfm" target="mainFrame">
				Printing Job Order
			</a>
		</li>
		<hr/>
	</cfcase>
	<cfcase value="imk_i">
		<hr/>
		<li>
			<a href="/Report/IMK/collectionnote.cfm" target="mainFrame">
				Collection Note
			</a>
		</li>
		<hr/>
	</cfcase>
	<cfcase value="solidlogic_i">
		<hr/>
		<li>
			<a href="/customized/solidlogic_i/rebatefunction.cfm" target="mainFrame">
				Rebate Function
			</a>
		</li>
		<hr/>
	</cfcase>
	<cfcase value="eocean_i">
		<hr/>
		<li>
			<a href="/customized/eocean_i/transaction/transaction.cfm?tran=CT" target="mainFrame">
				<cfoutput>#menutitle[76]#</cfoutput>
			</a>
		</li>
		<hr/>
	</cfcase>
</cfswitch>