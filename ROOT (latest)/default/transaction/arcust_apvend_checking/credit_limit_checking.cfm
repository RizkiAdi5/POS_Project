<cfif form.mode neq "Delete">

<cfif Hlinkams eq "Y">
<cfset dts1=replacenocase(dts,"_i","_a","all")>

<cfif tran eq 'PO' or tran eq 'PR' or tran eq 'RC'>
<cfquery name="checkexistcustomerinarpost" datasource="#dts1#">
				select 
				accno
				from appost 
				where 
                (accext is null or accext = "") and accno = "#jsstringformat(preservesinglequotes(custno))#"
                </cfquery>
<cfelse>
				<cfquery name="checkexistcustomerinarpost" datasource="#dts1#">
				select 
				accno
				from arpost 
				where 
                (accext is null or accext = "") and accno = "#jsstringformat(preservesinglequotes(custno))#"
                </cfquery>
</cfif>

<cfif checkexistcustomerinarpost.recordcount neq 0>
<cfif tran eq 'PO' or tran eq 'PR' or tran eq 'RC'>
    <cfquery name="get_arcust_apvend_info" datasource="#dts1#">
    (
			select 
			a.crlimit,
			b.amt1_bil
			from #target_apvend# as a
			
			left join 
			(
				select 
				accno as custno,
				sum(creditamt)-sum(debitamt) as amt1_bil
				from appost 
				where 
                (accext is null or accext = "") and accno = "#jsstringformat(preservesinglequotes(custno))#"
			) as b on a.custno=b.custno 
			
			where a.custno='#jsstringformat(preservesinglequotes(custno))#' 
		);
    </cfquery>
    <cfelse>
<cfquery name="get_arcust_apvend_info" datasource="#dts1#">
		(
			select 
			a.crlimit,
			b.amt1_bil
			from #target_arcust# as a
	
			left join 
			(
				select 
				accno as custno,
				sum(debitamt)-sum(creditamt) as amt1_bil
				from arpost 
				where 
                (accext is null or accext = "") and accno = "#jsstringformat(preservesinglequotes(custno))#"
			) as b on a.custno=b.custno 
			
			where a.custno='#jsstringformat(preservesinglequotes(custno))#' 
		)
	</cfquery>
    
    </cfif>
	
	<cfset current_amt1_bil = val(get_arcust_apvend_info.amt1_bil) + (val(form.qty) * val(form.price))>
	<cfset credit_limit = val(get_arcust_apvend_info.crlimit)>
	
	<cfif credit_limit neq 0 and current_amt1_bil gt credit_limit>
		<script language="javascript" type="text/javascript">
			<cfoutput>
			alert("Credit Limit Already Exceed By #numberformat(current_amt1_bil-credit_limit,'0.00')# !");
			</cfoutput>
			history.back();
			history.back();
		</script>
		<cfabort>
	</cfif>
    </cfif>

</cfif>
</cfif>