<cfif Hlinkams eq "Y" and form.type eq "Create">
	<cfif isdefined("credit_limit_exceed") and credit_limit_exceed eq "N">
		<!--- Do Nothing --->
	<cfelseif isdefined("url.credit_limit_exceed") and url.credit_limit_exceed eq "N">
		<!--- Do Nothing --->
	<cfelse>
		<cfif isdefined("form.check") and form.check neq "">
			<cfquery name="get_dealer_menu_info" datasource="#dts#">
				select 
				password 
				from dealer_menu;
			</cfquery>
			
			<cfset compare_result = compare(get_dealer_menu_info.password,form.password)>
		
			<cfif compare_result eq 0>
				<cfset credit_limit_exceed = "N">
				<cfset session.hcredit_limit_exceed = "N">
				<cfset session.bcredit_limit_exceed = "N">
				<cfset session.customercode = custno>
				<cfset session.tran_refno = nexttranno>
				
				<cfform name="done" action="transaction2.cfm?credit_limit_exceed=N" method="post">
					<cfloop list="#form.fieldnames#" index="a" delimiters=",">
						<cfinput name="#a#" type="hidden" value="#evaluate('form.#a#')#">
					</cfloop>
				</cfform>
				
				<script language="javascript" type="text/javascript">
					done.submit();
				</script>
			<cfelse>
				<cfset credit_limit_exceed = "Y">
				<cfset session.hcredit_limit_exceed = "Y">
				<cfset session.bcredit_limit_exceed = "Y">
				<cfset session.customercode = session.customercode>
				<cfset session.tran_refno = session.tran_refno>
				<cfset form.check = "">
				<cfset form.password = "">
				
				<cfform name="done" action="" method="post">
					<cfloop list="#form.fieldnames#" index="a" delimiters=",">
						<cfinput name="#a#" type="hidden" value="#evaluate('form.#a#')#">
					</cfloop>
				</cfform>
				
				<script language="javascript" type="text/javascript">
					done.submit();
				</script>
			</cfif>
		<cfelse>
			<cfquery name="get_dealer_menu_info" datasource="#dts#">
				select 
				(
					select 
					selling_above_credit_limit 
					from dealer_menu 
				) as selling_above_credit_limit, 
				(
					select 
					crlimit 
					from #replacenocase(dts,"_i","_a","all")#.arcust 
					where custno='#jsstringformat(preservesinglequotes(form.custno))#' 
				) as credit_limit,
				(
					ifnull(
						(
							select 
							ifnull(sum(grand_bil),0)
							from artran 
							where custno='#jsstringformat(preservesinglequotes(form.custno))#'
							and type='INV'
							and posted='' 
							group by custno 
						)
					,0)
					-
					ifnull(
						(
							select 
							ifnull((sum(debitamt)- sum(creditamt)),0)
							from #replacenocase(dts,"_i","_a","all")#.glpost 
							where accno='#jsstringformat(preservesinglequotes(form.custno))#' 
							group by accno
						) 
					,0) 
				) as credit_balance;
			</cfquery>
				
			<cfset customer_credit_balance = val(get_dealer_menu_info.credit_balance)>
			<cfset customer_credit_limit = val(get_dealer_menu_info.credit_limit)>
			
			<cfif get_dealer_menu_info.selling_above_credit_limit eq "Y" and customer_credit_limit neq 0 and customer_credit_balance gt customer_credit_limit>
				<cfset credit_limit_exceed = "Y">
				<cfset session.hcredit_limit_exceed = "Y">
				<cfset session.bcredit_limit_exceed = "Y">
				<cfset session.customercode = session.customercode>
				<cfset session.tran_refno = session.tran_refno>
				
				<script language="javascript" type="text/javascript">
					<cfoutput>
					<cfif isdefined("form.check")>
						alert("Wrong Password !");
					<cfelse>
						alert("Credit Limit Exceed !");
					</cfif>
					</cfoutput>
				</script>
				
				<cfinclude template="enter_user_password.cfm">
				<cfabort>
			<cfelse>
				<cfset credit_limit_exceed = "N">
				<cfset session.hcredit_limit_exceed = "N">
				<cfset session.bcredit_limit_exceed = "Y">
				<cfset session.customercode = custno>
				<cfset session.tran_refno = nexttranno>
			</cfif>
		</cfif>
	</cfif>
</cfif>