<cfoutput>
	<cfswitch expression="#lcase(hcomid)#">
		<cfcase value="glenn_i,glenndemo_i">
			<hr/>
			<li>
				<a href="/customized/#dts#/enquires/special_menu.cfm" target="mainFrame">
					Customization
				</a>
			</li>
		</cfcase>		
	</cfswitch>
</cfoutput>