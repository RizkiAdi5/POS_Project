<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">

<cfif form.mode eq "Create">
		<cfquery name="checkexist" datasource="#dts#">
        select voucherid from vouchertype where voucherid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucher#">
        </cfquery>
    
    <cfif checkexist.recordcount eq 0>
		<cfquery name="insertvoucher" datasource="#dts#">
        INSERT INTO vouchertype
        (voucherid,voucherdesp,voucheramt,created_by,created_on)
        VALUES
        (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucher#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
        "#val(form.voucheramt)#",
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">,
        now()
        )
        </cfquery>
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
            alert('The voucher has existed');
            history.go(-1);
            </script>
        	<cfabort>
        </cfoutput>
        
    </cfif>
	<cfset status="The voucher, #form.voucher# Has Been Created successfully !">

<cfelse>
	<cfswitch expression="#form.mode#">
		<cfcase value="Delete">

				<cfquery datasource='#dts#' name="deletevoucher">
					Delete from vouchertype where voucherid='#form.voucher#'
				</cfquery>

			
			<cfset status="The voucher, #form.voucher# Has Been Deleted Successfully!">
		</cfcase>
		<cfcase value="Edit">
			<cfquery name="updatevoucher" datasource="#dts#">
            UPDATE vouchertype SET
            voucherdesp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
            voucheramt="#val(form.voucheramt)#"
            
            WHERE voucherid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucher#">
            </cfquery>
            
			<cfset status="The voucher, #form.voucher# Has Been Edited Successfully!">
		</cfcase>
	</cfswitch>
</cfif>

<cfoutput>
	<form name="done" action="s_vouchertable.cfm?type=voucher&amp;process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>