<cfif form.mode neq "Delete">
	<cfquery name="get_arcust_apvend_info" datasource="#dts#">
		(
			select 
			a.invlimit,
			b.amt1_bil
			from #target_arcust# as a
	
			left join 
			(
				select 
				custno,
				sum(amt1_bil) as amt1_bil
				from ictran 
				where type='#jsstringformat(preservesinglequotes(tran))#'
				and refno='#jsstringformat(preservesinglequotes(nexttranno))#'
				and custno='#jsstringformat(preservesinglequotes(custno))#'
				<cfif form.mode eq "Edit">
				and itemno<>'#jsstringformat(preservesinglequotes(itemno))#'
				and itemcount<>'#jsstringformat(preservesinglequotes(itemcount))#'
				</cfif>
				group by custno 
			) as b on a.custno=b.custno 
			
			where a.custno='#jsstringformat(preservesinglequotes(custno))#' 
		)
		union 
		(
			select 
			a.invlimit,
			b.amt1_bil
			from #target_apvend# as a
			
			left join 
			(
				select 
				custno,
				sum(amt1_bil) as amt1_bil 
				from ictran 
				where type='#jsstringformat(preservesinglequotes(tran))#'
				and refno='#jsstringformat(preservesinglequotes(nexttranno))#'
				and custno='#jsstringformat(preservesinglequotes(custno))#'
				<cfif form.mode eq "Edit">
				and itemno<>'#jsstringformat(preservesinglequotes(itemno))#'
				and itemcount<>'#jsstringformat(preservesinglequotes(itemcount))#'
				</cfif> 
				group by custno 
			) as b on a.custno=b.custno 
			
			where a.custno='#jsstringformat(preservesinglequotes(custno))#' 
		);
	</cfquery>
	
	<cfset current_amt1_bil = val(get_arcust_apvend_info.amt1_bil) + (val(form.qty) * val(form.price))>
	<cfset invoice_limit = val(get_arcust_apvend_info.invlimit)>
	
	<cfif invoice_limit neq 0 and current_amt1_bil gt invoice_limit>
		<script language="javascript" type="text/javascript">
			<cfoutput>
			alert("Invoice Limit Already Exceed By #numberformat(current_amt1_bil-invoice_limit,'0.00')# !");
			</cfoutput>
			history.back();
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>