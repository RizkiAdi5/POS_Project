<script type="text/javascript">
var ws = new ActiveXObject("WScript.Shell");
ws.Run('cmd.exe /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "Fax"','0');
</script>

<script type='text/javascript' src='/ajax/core/jquery.jqprint-0.3.js'></script>

<html>
<body onLoad="document.getElementById('sub_btn').focus()">

<cfquery name="getgsetup2" datasource="#dts#">
	select
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfquery name="getbill" datasource="#dts#">
SELECT * FROM artran WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
</cfquery>
<cfquery name="getbilltran" datasource="#dts#">
SELECT * FROM ictran WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
</cfquery>
<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>
<cfquery name="gettermandcondition" datasource="#dts#">
	select lcs from ictermandcondition
</cfquery>

<cfif val(getbill.CS_PM_CASH) neq 0 and val(getbill.CS_PM_CHEQ) eq 0 and val(getbill.CS_PM_CRCD) eq 0 and val(getbill.CS_PM_CRC2) eq 0 and val(getbill.CS_PM_DBCD) eq 0 and val(getbill.CS_PM_VOUC) eq 0 and val(getbill.CS_PM_CASHCD) eq 0 and val(getbill.deposit) eq 0>
	<cfif getbill.taxincl eq "T">
	<cfset getbill.net_bil = numberformat((numberformat(val(getbill.net_bil)* 2,'._')/2),'.__')>
<cfelse>
	<cfset getbill.grand_bil = numberformat((numberformat(val(getbill.grand_bil)* 2,'._')/2),'.__')>
	</cfif>
</cfif>
<cfoutput>
<cfform name="form1" id="form1" action="/default/transaction/POS/" method="post">
	<table width="230px" style="font-size:12px; border-width:thin; " cellpadding="0" cellspacing="0" >
		<cfif isdefined('url.reprint')>
			<tr>
			<td colspan="4" align="center" style="font-size:20px"><cfif getbill.void eq 'Y'>Void<cfelse>Reprint</cfif></td><td widtd="10%" rowspan="100%">&nbsp;</td>
			</tr>
		</cfif>
		<cfif getgsetup.displaylogo eq 'Y'>
			<tr>
				<td colspan="4" align="center"><img src="logo.jpg" width="150" height="50"></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="4" align="center"><a style="cursor:pointer; font-size:20px" onClick="window.print()"><strong>#getgsetup.compro#</strong></a></td><td widtd="10%" rowspan="100%">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro2#</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro3#</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro4#</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro5#</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro6#</td>
		</tr>
		<tr>
			<td colspan="4" align="center">#getgsetup.compro7#</td>
		</tr>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="left">Tgl : #dateformat(getbill.trdatetime,'DD-MM-YYYY')#</td>
			<td colspan="2" align="left">Jam : #timeformat(getbill.trdatetime,'HH:MM:SS')#</td>
		</tr>
		<tr>
			<td colspan="2" align="left">No : #getbill.refno#</td>
			<td colspan="2"  align="left">Kasir : #getbill.userid#</td>
		</tr>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
		<td colspan="4"></td>
		</tr>
		<tr><td colspan="4"></td></tr>
		<cfloop query="getbilltran">
		<cfset priceunit = 0>

		<cfif right(getbilltran.brem4,1) eq "%">
			<cfset totpercent = val(getbilltran.brem4)>
				<cfif totpercent lte 100 and totpercent gt 0>
				<cfset priceunit = numberformat(val(getbilltran.price_bil) * ((100-totpercent)/100),stDecl_UPrice)>
				</cfif>
			<cfelse>
			<cfset totdis = val(getbilltran.brem4)>
				<cfif totdis lte val(getbilltran.price_bil)>
				<cfset priceunit =numberformat(val(getbilltran.price_bil) - val(totdis),stDecl_UPrice)>
				</cfif>
			</cfif>
		<tr>

		<td colspan="4" style="font-size:5px">&nbsp;</td>
		</tr>
<!---		<tr>
			<td align="left" colspan="2" valign="bottom">#getbilltran.itemno# <cfif getbilltran.brem3 neq '' and getbilltran.itemno eq 'voucher'>&nbsp;&nbsp;&nbsp; <a href="printvoucher.cfm?voucherno=#getbilltran.brem3#&refno=#getbilltran.refno#" target="_blank">Print Voucher #getbilltran.brem3#</a></cfif></td>
		</tr>--->
		<tr>
			<td align="left" colspan="4"  width="220px">#getbilltran.desp# #getbilltran.despa#<cfif hcomid eq "hodaka_i"><br>#getbilltran.comment#</cfif><cfif getbilltran.brem1 eq "Delivery">-Delivery</cfif>
			<cfquery name="getserial" datasource="#dts#">
				  select * from iserial where refno = '#getbilltran.refno#' and type = '#getbilltran.type#' and itemno = '#getbilltran.itemno#' and trancode = '#getbilltran.trancode#'
			</cfquery>
			<cfif getserial.recordcount gt 0>
				<br>Serial: #valuelist(getserial.SERIALNO)#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td align="left" colspan="2">#getbilltran.qty_bil# * <cfif priceunit neq 0>#Replace( NumberFormat(price_bil, "," ), ",", ".", "ALL" )#<cfelse>#Replace( NumberFormat(getbilltran.dispec1, "," ), ",", ".", "ALL" )#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif getbilltran.dispec1 neq 0>#Replace( NumberFormat(getbilltran.amt_bil, "," ), ",", ".", "ALL" )#%</cfif>&nbsp;&nbsp;&nbsp;<cfif getbilltran.disamt_bil neq 0>-#Replace( NumberFormat(getbilltran.disamt_bil, "," ), ",", ".", "ALL" )#</cfif></td>
			<td align="right">#Replace( NumberFormat(getbilltran.amt_bil, "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfloop>
		<tr><td colspan="4"><hr/></tr>

		<cfset showcurrcode = "Rp">
		<cfquery name="getcurrency" datasource="#dts#">
		SELECT currency FROM currency WHERE currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getgsetup.bcurr#">
		</cfquery>
		<cfset showcurrcode = getcurrency.currency>
		<cfif getbill.currcode neq "">
		<cfquery name="getcurrency" datasource="#dts#">
		SELECT currency FROM currency WHERE currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getBill.currcode#">
		</cfquery>
		<cfset showcurrcode = getcurrency.currency>
		</cfif>
		<tr>
			<td colspan="2" align="right">
				<strong>DISKON #Replace( NumberFormat(val(getbill.disp1), "," ), ",", ".", "ALL" )#%</strong>
			</td>
			<td align="right">
				<strong>(#Replace( NumberFormat(val(getbill.disc_bil), "," ), ",", ".", "ALL" )#)</strong>
			</td>
		</tr>

		<tr>
			<th colspan="2" align="right">TOTAL: (#showcurrcode#)</strong></th>
			<th align="right"><strong>#Replace( NumberFormat(val(getbill.grand_bil), "," ), ",", ".", "ALL" )#</strong></th>
		</tr>

		<tr>
			<td colspan="2" align="right"><strong>TUNAI  (#showcurrcode#</strong>)</td>
			<td align="right"><strong>#Replace( NumberFormat(val(getbill.CS_PM_CASH)+val(getbill.rem11), "," ), ",", ".", "ALL" )#</strong></td>
		</tr>

		<tr><td colspan="4"><hr/></td></tr>
		<cfif val(getbill.CS_PM_CASH) neq 0>
		<tr>
			<td colspan="2" align="right"><strong>KEMBALI: (#showcurrcode#)</strong></td>
			<td align="right">#Replace( NumberFormat(val(getbill.rem11), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
        <tr>
		<td colspan="4" style="font-size:5px">&nbsp;</td>
		</tr>
		<tr>
		<td colspan="2" align="left">
			<cfquery name="getotalqty" datasource="#dts#">
			SELECT sum(qty_bil) as totalqty FROM ictran where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">
			</cfquery>
			Total Item :  #getotalqty.totalqty# Items</td>
		<td align="right"></td>
		</tr>

		<cfif val(getbill.CS_PM_CHEQ) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Cek-#getbill.checkno#</td>
			<td align="right">#Replace( NumberFormat(val(getbill.CS_PM_CHEQ), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.CS_PM_CRCD) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Kartu Kredit 1-#getbill.rem10#</td>
			<td align="right">#Replace(NumberFormat(val(getbill.CS_PM_CRCD), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.CS_PM_CRC2) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Kartu Kredit 2-#getbill.rem8#</td>
			<td align="right">#Replace( NumberFormat(val(getbill.CS_PM_CRC2), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.CS_PM_DBCD) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">JUMLAH NETTO</td>
			<td align="right">#Replace( NumberFormat(val(getbill.CS_PM_DBCD), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.CS_PM_VOUC) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Vourcher</td>
			<td align="right">#Replace( NumberFormat(val(getbill.CS_PM_VOUC), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.CS_PM_cashcd) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Kartu Kas</td>
			<td align="right">#Replace( NumberFormat(val(getbill.CS_PM_cashcd), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<cfif val(getbill.deposit) neq 0>
		<tr><td colspan="4"><hr/></td></tr>
		<tr>
			<td colspan="2" align="right">Deposito</td>
			<td align="right">#Replace( NumberFormat(val(getbill.deposit), "," ), ",", ".", "ALL" )#</td>
		</tr>
		</cfif>
		<tr><td colspan="4"><hr/></td></tr>
		<cfset info=tostring(gettermandcondition.lcs)>
		<cfset recordcnt = ListLen(info,chr(13)&chr(10))>


		<tr><td colspan="4" align="center"><strong>Syarat & Kondisi</strong></td></tr>
		<cfquery name="getreserve" datasource="#dts#">
		select * from reserve where reserveno='#getbill.refno#'
		</cfquery>
		<cfif getreserve.recordcount neq 0>
		<tr><td colspan="4" align="center">TERIMA KASIH ATAS KUNJUNGANNYA
			BARANG YANG SUDAH DIBELI TIDAK DAPAT
			DIKEMBALIKAN / DITUKAR</td></tr>
		<cfelse>
		<cfloop from="1" to="#recordcnt#" index="i">
		<cfset str = ListGetAt(info,i,chr(13)&chr(10))>
		<tr><td colspan="3" align="center">#str#</td></tr>
		<cfset i=i+1>

		</cfloop>
		</cfif>
		</tr>
		<td colspan="3" align="center">
		<input type="hidden" name="counterchoose" id="counterchoose" value="#getbill.counter#">
		<input type="hidden" name="cashierchoose" id="cashierchoose" value="#getbill.cashier#">
		<input type="submit" name="sub_btn" id="sub_btn" value="**Terima Kasih**" style="background:none;
                        border:0;
                        margin:0;
                        padding:0;
                        font-size:10px;
		">
		</td>
		</tr>
		<tr><td colspan="4"><hr/></td></tr>
		</table></cfform>

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript">
this.print(false);
setTimeout('form1.submit();',500);

 $(document).keydown(function(e) {
        if(e.keyCode == 8) {
        alert("Tekan enter atau 'Terima Kasih' untuk kembali.");
        e.preventDefault(); }
    });
</script>

</cfoutput>
</body>
</html>
