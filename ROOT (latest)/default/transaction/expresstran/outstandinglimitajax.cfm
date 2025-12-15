<cfsetting showdebugoutput="no">
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
					from #target_arcust#
					where custno='#jsstringformat(preservesinglequotes(custno))#' 
				) as credit_limit,
				(
					ifnull(
						(
							select 
							ifnull(sum(grand_bil),0)
							from artran 
							where custno='#jsstringformat(preservesinglequotes(custno))#'
							and type='INV'
							and posted='' 
							group by custno 
						)
					,0)
					-
                    <cfif Hlinkams eq 'Y'>
					ifnull(
						(
							select 
							ifnull((sum(debitamt)- sum(creditamt)),0)
							from #replacenocase(dts,"_i","_a","all")#.glpost 
							where accno='#jsstringformat(preservesinglequotes(custno))#' 
							group by accno
						) 
					,0) 
                    <cfelse>
                    0
                    </cfif>
				) as credit_balance;
			</cfquery>
<cfoutput>
#get_dealer_menu_info.credit_balance#
</cfoutput>