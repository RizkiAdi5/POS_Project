<script type="text/javascript">
var ws = new ActiveXObject("WScript.Shell");
ws.Run('cmd.exe /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "Fax"','0');
</script>


<link rel="StyleSheet" href="barcode.css" type="text/css" />


<script type="text/javascript">

BARS       = [212222,222122,222221,121223,121322,131222,122213,122312,132212,221213,221312,231212,112232,122132,122231,113222,123122,123221,223211,221132,221231,213212,223112,312131,311222,321122,321221,312212,322112,322211,212123,212321,232121,111323,131123,131321,112313,132113,132311,211313,231113,231311,112133,112331,132131,113123,113321,133121,313121,211331,231131,213113,213311,213131,311123,311321,331121,312113,312311,332111,314111,221411,431111,111224,111422,121124,121421,141122,141221,112214,112412,122114,122411,142112,142211,241211,221114,413111,241112,134111,111242,121142,121241,114212,124112,124211,411212,421112,421211,212141,214121,412121,111143,111341,131141,114113,114311,411113,411311,113141,114131,311141,411131,211412,211214,211232,23311120];
START_BASE = 38
STOP       = 106 //BARS[STOP]==23311120 (manually added a zero at the end)
 
var fromType128 = {
    A: function(charCode) {
        if (charCode>=0 && charCode<32)
            return charCode+64;
        if (charCode>=32 && charCode<96)
            return charCode-32;
        return charCode;
    },
    B: function(charCode) {
        if (charCode>=32 && charCode<128)
            return charCode-32;
        return charCode;
    },
    C: function(charCode) {
        return charCode;
    }
};
 
function code128(code, barcodeType) {
    if (arguments.length<2)
        barcodeType = code128Detect(code);
    if (barcodeType=='C' && code.length%2==1)
        code = '0'+code;
    var a = parseBarcode128(code,  barcodeType);
    return bar2html128(a.join('')) ;//+ '<label>' + code + '</label>';
}
 
 
function code128Detect(code) {
    if (/^[0-9]+$/.test(code)) return 'C';
    if (/[a-z]/.test(code)) return 'B';
    return 'A';
}
 
function parseBarcode128(barcode, barcodeType) {
    var bars = [];
    bars.add = function(nr) {
        var nrCode = BARS[nr];
        this.check = this.length==0 ? nr : this.check + nr*this.length;
        this.push( nrCode || format("UNDEFINED: %1->%2", nr, nrCode) );
    };
 
    bars.add(START_BASE + barcodeType.charCodeAt(0));
    for(var i=0; i<barcode.length; i++)
    {
        var code = barcodeType=='C' ? +barcode.substr(i++, 2) : barcode.charCodeAt(i);
        converted = fromType128[barcodeType](code);
        if (isNaN(converted) || converted<0 || converted>106)
            throw new Error(format("Unrecognized character (%1) at position %2 in code '%3'.", code, i, barcode));
        bars.add( converted );
    }
    bars.push(BARS[bars.check % 103], BARS[STOP]);
 
    return bars;
}
 
function format(c){
    var d=arguments;
    var e= new RegExp("%([1-"+(arguments.length-1)+"])","g");
    return(c+"").replace(e,function(a,b){return d[b]})
}
 
function bar2html128(s) {
    for(var pos=0, sb=[]; pos<s.length; pos+=2)
    {
        sb.push('<div class="bar' + s.charAt(pos) + ' space' + s.charAt(pos+1) + '"></div>');
    }
    return sb.join('');
}

function encode()
{
  var strValue = document.getElementById("barcode_input").value;
  var strBarcodeHTML = code128(strValue);
  document.getElementById("barcode").innerHTML = strBarcodeHTML;
  
}
</script>



<script type='text/javascript' src='/ajax/core/jquery.jqprint-0.3.js'></script>



<html>
<body>

<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>
<cfquery name="gettermandcondition" datasource="#dts#">
	select lcs from ictermandcondition
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>

<cfquery name="getbilltran" datasource="#dts#">
SELECT * FROM ictran WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="CS"> and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.refno#"> and brem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.voucherno#">
</cfquery>

<cfoutput>

<table width="595px" height="842" style="font-size:12px; border-width:thin;" cellpadding="0" cellspacing="5"  >
<tr>

<td colspan="100%" align="center"><img src="tcdsheader.png" width="863" height="308"></td>
</tr>
<cfquery name="gettermandcondition" datasource="#dts#">
	select lvouc from ictermandcondition
</cfquery>
<tr>
<td colspan="100%"><font style="font-size:18px">#gettermandcondition.lvouc#</font></td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px"></font></td>
</tr>
<tr>
<td><font style="font-size:18px">Date Of Issue</font></td>
<td><font style="font-size:18px">BarCode</font></td>
</tr>
<tr>
<td><font style="font-size:18px">#dateformat(getbilltran.wos_date,'dd/mm/yyyy')#</font></td>
<td><input style="margin-left:45px" type="hidden"  value="#url.voucherno#" id="barcode_input"></input><div class="barcode128h" id="barcode"></div></td>
</tr>
<tr>
<td><font style="font-size:18px">Valid Till</font></td>
<td></td>
</tr>
<tr>
<td><font style="font-size:18px">#dateformat(dateadd('d','-1',dateadd('yyyy',1,getbilltran.wos_date)),'dd/mm/yyyy')#</font></td>
<td></td>
</tr>
<tr>
<td colspan="100%"><br><br><br><br></td>
</tr>
<cffunction name="towords">
<cfargument name="amount" type="numeric" required="true">
<cfscript>
		var toword=numberformat(val(arguments.amount),",.__");
		var th = arrayNew(1);
		var dg = arrayNew(1);
		var tn = arrayNew(1);
		var tw = arrayNew(1);
		th = listtoarray(" , Thousand, Million, Billion,Trillion", ",");
		dg = listtoarray("zero, one, two, three, four, five, six, seven, eight, nine", ","); 
		tn = listtoarray("Ten, Eleven, Twelve, Thirteen, Fourteen, Fifteen, Sixteen, Seventeen, Eighteen, nineteen",","); 
		tw = listtoarray("Twenty, Thirty, Forty, Fifty, Sixty, Seventy, Eighty, Ninety",","); 
		s = Replace(toword, ",", "", "All");
		/*if (s neq #LSCurrencyFormat(s, "none")#) {return 'Not a number'; } */
		if(s lt 0)
      	{
        	str = 'Negative';
		 	s =   Abs(s);
		 	s = val(s);
      	}
		else
		{
			str = '';
      	}

		if (s neq 0){
		/* x = s.indexOf('.');  */ 
		x = Find('.', S)-1;
		z = mid(s, 1, x);
		zd = mid(s, x+2, 2);
		cents_p = mid(s, x+2, 2);
		w_num = REReplace(s, "[T]*",",","ALL") ;
		w_num = RemoveChars(w_num, ((len(s)*2)+1), 1);
		w_num = RemoveChars(w_num, 1, 1);
		sk = 0;
		d_num = REReplace(cents_p, "[T]*",",","ALL") ;
		d_num = RemoveChars(d_num, ((len(cents_p)*2)+1), 1);
		d_num = RemoveChars(d_num, 1, 1);
		d_sk = 0;
		c=0;
		
		for (i=1; i lte x; i=i+1) 
		{
		 	if (zd eq 00){
			   if(c eq 1){     
			   		str = listAppend(str, 'and ');
			   }
			}
			if (((x+1)-i) mod 3 eq 2) 
			{
				if (listgetat(w_num, i) eq '1') 
				{
					str = listAppend(str, tn[Val(listgetat(w_num, i+1))+1]); 
					str = listAppend(str, ' ');
					i=i+1; 
					sk=1;
				}
				else if (listgetat(w_num, i) neq 0) 
				{
					str = ListAppend(str, tw[Val(listgetat(w_num, i))-1]);
					str = listAppend(str, ' '); 
					sk=1;
					
				}  
				c=c+1;
			}
			else if (listgetat(w_num, i) neq 0) 
			{
				str = ListAppend(str, dg[Val(listgetat(w_num, i))+1]); 
				str = listAppend(str, ' '); 
				
				if (((x+1)-i) mod 3 eq 0) 
				{
					str = ListAppend(str, 'hundred '); 
				}
				sk=1; 
				c=c+1;
			}
			else if (listgetat(w_num, i) eq 0){
				c=c+1;
			}
			if (((x-i)-2) mod 3 eq 1) 
			{
				if (sk) 
				{
					str = listAppend(str, th[((x-i)/3)+1]); 
					str = listAppend(str, ' '); 
				}
				sk=0;
				c=0;
			}
		}

		if (zd neq 00)
		{
			if (x neq len(s)) 
			{
				y = len(s);
				
				if (z neq 0)
				{
					str = listAppend(str, 'and '); 
				}
				
				for (i=1; i lte 2; i=i+1) 
				{
					if ((3-i) mod 3 eq 2) 
					{
						if (listgetat(d_num, i) eq '1') 
						{
							str = listAppend(str, tn[listgetat(d_num, i+1)+1]); 
							i=i+1; 
							d_sk=1;
						} 
						else if (listgetat(d_num, i) neq 0) 
						{
							str = listAppend(str, tw[Val(listgetat(d_num, i))-1]); 
							d_sk=1;
						}
					}
					else if (listgetat(d_num, i) neq 0) 
					{
						str = listAppend(str, dg[listgetat(d_num, i)+1]); 
						d_sk=1;
					} 
				}
				
				if (zd eq 01)
				{
					str = listAppend(str, ' cent');
				}
				else 
				{
					str = listAppend(str, ' cents');
				}
			}
		}
		if(len(str) neq 0){ 
			if(right(str,4) eq 'and '){
			    intstr=Len(str);
				countstr=intstr-4;
				str=Left(str,countstr);
			}
		}
		str = listAppend(str, ' Dollar');
		toword = Replace(str, ",", "", "All");
	}
	else{
	toword = '-';
	}
</cfscript>

<cfreturn toword>
</cffunction>
<tr>
<td colspan="100%" align="center"><img style="z-index:-1" src="tcdslogo.png" width="906" height="422" >
<p style="position: absolute; z-index: 999; left: 85px; top: 683px; width: 246px; height: 81px;"><font style="font-size: 48px">$#getbilltran.amt#</font><br><font style="font-size: 36px">
#towords(getbilltran.amt)#</font></p>
<p style="position: absolute; z-index: 999; left: 619px; top: 685px; width: 246px; height: 81px;"><font style="font-size: 48px">$#getbilltran.amt#</font><br><font style="font-size: 36px">
#towords(getbilltran.amt)#</font></p>
<br><br><br><br><br><br>
</td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px"><strong>Terms & Conditions</strong></font></td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px">1. This voucher is honored only at That CD Shop & High Society (Singapore)</font></td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px">2. This voucher is not exchangeable for cash</font></td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px">3. This voucher is not valid unless it is signed by authorised personnel of That CD Shop or High Society (Singapore)</font></td>
</tr>
<tr>
<td colspan="100%"><font style="font-size:18px">4. This voucher is strictly valid for 12 months from the Date of Issued</font></td>
</tr>

<tr>
<td colspan="100%"><font style="font-size:18px">5. This voucher must be fully utilised when making payment. Any unutilised amount of this voucher will be forfeited & shall not be refundable or carry forward</font></td>
</tr>

<tr>
<td colspan="100%"><font style="font-size:18px">6. Incomplete or damaged voucher presented will not be honored</font></td>
</tr>

<tr>
<td colspan="100%"><font style="font-size:18px">7. T&Cs for this voucher may be withdrawn or amended without prior notice at the discretion of the Company</font></td>
</tr>

</table>





<script type="text/javascript">
encode();
this.print(false);

</script>


</cfoutput>
</body>
</html>
