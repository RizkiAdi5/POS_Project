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
					selling_above_credit_limit1 
					from dealer_menu 
				) as selling_above_credit_limit1, 
                (
					select 
					credit_term 
					from dealer_menu 
				) as credit_term, 
                (
					select 
					credit_term1 
					from dealer_menu 
				) as credit_term1, 
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
							and type in ('INV','DN','CS')
							and posted='' 
							group by custno 
						)
					,0)
                    -
                    ifnull(
						(
							select 
							ifnull(sum(grand_bil),0)
							from artran 
							where custno='#jsstringformat(preservesinglequotes(form.custno))#'
							and type='CN'
							and posted='' 
							group by custno 
						)
					,0)
					+
					ifnull(
						(
							select 
							ifnull((sum(debitamt)- sum(creditamt)),0)
							from #replacenocase(dts,"_i","_a","all")#.glpost 
							where accno='#jsstringformat(preservesinglequotes(form.custno))#' and fperiod <> '99'
							group by accno
						) 
					,0) 
                    
                    +
                    ifnull(
						(
							select 
							ifnull(lastybal,0)
							from #replacenocase(dts,"_i","_a","all")#.gldata 
							where accno='#jsstringformat(preservesinglequotes(form.custno))#' 
							group by accno
						) 
					,0)
				) as credit_balance;
			</cfquery>
				
			<cfset customer_credit_balance = val(get_dealer_menu_info.credit_balance)>
			<cfset customer_credit_limit = val(get_dealer_menu_info.credit_limit)>
			
            <!--- --->
            <cfif get_dealer_menu_info.credit_term eq "Y" and (get_dealer_menu_info.credit_term1 eq "" or ListFindNoCase(get_dealer_menu_info.credit_term1,form.tran))>
            
            <cfquery name="getaanecustoverduebill" datasource="#dts#">
            select *,DATE_ADD(wos_date,INTERVAL termdays DAY) from(select wos_date,term,refno,type,ifnull((select days from icterm where term=a.term),0)as termdays from artran as a where type in ('INV','CS','DN') and custno='#jsstringformat(preservesinglequotes(form.custno))#') as aa where DATE_ADD(wos_date,INTERVAL termdays DAY)<'#dateformat(now(),'yyyy-mm-dd')#'
            </cfquery>
            
            <cfset aaneoverduelist=valuelist(getaanecustoverduebill.refno)>
            
            <cfquery name="getaanecustoverduebill2" datasource="#dts#">
            select * from(select sum(debitamt)-sum(creditamt) as balance,reference from #replacenocase(dts,"_i","_a","all")#.arpost
            where accno='#jsstringformat(preservesinglequotes(form.custno))#' and reference in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#aaneoverduelist#">)
            group by reference)as a where balance<>0
            </cfquery>
            
            <cfif (get_dealer_menu_info.selling_above_credit_limit eq "Y" and (get_dealer_menu_info.selling_above_credit_limit1 eq "" or ListFindNoCase(get_dealer_menu_info.selling_above_credit_limit1,form.tran)) and customer_credit_limit neq 0 and customer_credit_balance gt customer_credit_limit) or getaanecustoverduebill2.recordcount gt 0>
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
            <cfelse>
            <!---Other Company--->
			<cfif get_dealer_menu_info.selling_above_credit_limit eq "Y" and (get_dealer_menu_info.selling_above_credit_limit1 eq "" or ListFindNoCase(get_dealer_menu_info.selling_above_credit_limit1,form.tran)) and customer_credit_limit neq 0 and customer_credit_balance gt customer_credit_limit>
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
            <!--- --->
            </cfif>
		</cfif>
	</cfif>
</cfif>