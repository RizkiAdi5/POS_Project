
<cfquery name="updatepayment" datasource="#dts#">
UPDATE pospayment SET
id=1,
<cfif isdefined('form.creditcard')>
creditcard = "Y",
<cfelse>
creditcard = "N",
</cfif>
<cfif isdefined('form.cashcard')>
cashcard = "Y",
<cfelse>
cashcard = "N",
</cfif>
<cfif isdefined('form.cheque')>
cheque = "Y",
<cfelse>
cheque = "N",
</cfif>
<cfif isdefined('form.deposit')>
deposit = "Y",
<cfelse>
deposit = "N",
</cfif>
<cfif isdefined('form.voucher')>
voucher = "Y",
<cfelse>
voucher = "N",
</cfif>
<cfif isdefined('form.NETS')>
NETS = "Y",
<cfelse>
NETS = "N",
</cfif>
sccancel = "#form.sccancel#",
scdeposit = "#form.scdeposit#",
sccash = "#form.sccash#",
scnet = "#form.scnet#",
sccreditcard = "#form.sccreditcard#",
sccheque = "#form.sccheque#",
sccashcard = "#form.sccashcard#",
scmulti = "#form.scmulti#",
scclose = "#form.scclose#",
scsearch = "#form.scsearch#",
scfocus = "#form.scfocus#",
possync = "#form.possync#",
vouchertype = "#form.vouchertype#",
id=1
</cfquery>

<cfoutput>
<script type="text/javascript">
alert('Update Success!');
window.location.href='index.cfm';
</script>
</cfoutput>