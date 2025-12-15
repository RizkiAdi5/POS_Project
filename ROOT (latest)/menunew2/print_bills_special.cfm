<cfquery name="get_company_id" datasource="main">
	select 
	(lcase(left(company_id,char_length(company_id)-2))) as company_id
	from customize_print_bills
	where company_id='#jsstringformat(preservesinglequotes(hcomid))#'
	order by company_id;
</cfquery>

<cfif get_company_id.recordcount eq 1>
	<cfoutput>
		<hr/>
		<li>
			<a href="/billformat/#dts#/print_bills_special/sub_menu.cfm" target="mainFrame" onClick="javascript:alert('Developing !');return false;">
				Customized Print Bills
			</a>
		</li>
	</cfoutput>
</cfif>