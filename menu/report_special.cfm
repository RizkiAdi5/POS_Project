<cfquery name="get_company_id" datasource="main">
	select 
	(lcase(left(company_id,char_length(company_id)-2))) as company_id
	from customize_report
	where company_id='#jsstringformat(preservesinglequotes(hcomid))#'
	order by company_id;
</cfquery>

<cfif get_company_id.recordcount eq 1>
	<cfoutput>
		<hr/>
		<li>
			<a href="/Report/report_menu.cfm?company_id=#urlencodedformat(get_company_id.company_id)#" target="mainFrame">
				Customized Report
			</a>
		</li>
	</cfoutput>
</cfif>