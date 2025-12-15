<cfquery name="getcsname" datasource="#dts#">
	select lcs from gsetup
</cfquery>
<cfif #tran# eq "rc">
	<cfset tran = "rc">
	<cfset tranname = "Purchase Receive">
	<cfset trancode = "rcno">
	<cfset prefix = "rccode">
</cfif>
<cfif #tran# eq "DO">
	<cfset tran = "DO">
	<cfset tranname = "Delivery Order">
	<cfset trancode = "dono">
	<cfset prefix = "docode">
</cfif>
<cfif #tran# eq "INV">
	<cfset tran = "INV">
	<cfset tranname = "Invoice">
	<cfset trancode = "invno">
	<cfset prefix = "invcode">
</cfif>
<cfif #tran# eq "CS">
	<cfset tran = "CS">
	<cfset tranname = "Tax Invoice">
	<cfset trancode = "invno">
	<cfset prefix = "cscode">
</cfif>
<cfif #tran# eq "QUO">
	<cfset tran = "QUO">
	<cfset tranname = "Quotation">
	<cfset trancode = "quono">
	<cfset prefix = "quocode">
</cfif>
<cfif #tran# eq "PO">
	<cfset tran = "PO">
	<cfset tranname = "Purchase Order">
	<cfset trancode = "pono">
	<cfset prefix = "pocode">
</cfif>
<cfif #tran# eq "SO">
	<cfset tran = "SO">
	<cfset tranname = "Sales Order">
	<cfset trancode = "sono">
	<cfset prefix = "socode">
</cfif>
<cfif #tran# eq "CN">
	<cfset tran = "CN">
	<cfset tranname = "Credit Note">
	<cfset trancode = "cnno">
	<cfset prefix = "cncode">
</cfif>
<cfif #tran# eq "DN">
	<cfset tran = "DN">
	<cfset tranname = "Dedit Note">
	<cfset trancode = "dnno">
	<cfset prefix = "dncode">
</cfif>
<cfif #tran# eq "PR">
	<cfset tran = "PR">
	<cfset tranname = "Purchase Return">
	<cfset trancode = "prno">
	<cfset prefix = "prcode">
</cfif>
<cfif #tran# eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = "Sample">	
	<cfset trancode = "samno">
	<cfset prefix = "samcode">
</cfif>
<cfif tran eq 'PO' or tran eq 'PR' or tran eq 'RC'>
	<cfset ptype = target_apvend>
<cfelse>
	<cfset ptype = target_arcust>
</cfif>


<cffunction name="toword">
<cfargument name="amount" type="numeric" required="true">
<cfscript>
		var toword=numberformat(val(arguments.amount),",.__");
		var th = arrayNew(1);
		var dg = arrayNew(1);
		var tn = arrayNew(1);
		var tw = arrayNew(1);
		th = listtoarray(" , thousand, million, billion,trillion", ",");
		dg = listtoarray("zero, one, two, three, four, five, six, seven, eight, nine", ","); 
		tn = listtoarray("ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen",","); 
		tw = listtoarray("twenty, thirty, forty, fifty, sixty, seventy, eighty, ninety",","); 
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
		str = listAppend(str, ' only');
		toword = Replace(str, ",", "", "All");
	}
	else{
	toword = '-';
	}
</cfscript>

<cfreturn toword>


</cffunction>


<!--- <cfparam name="pagecnt" default="1"> --->
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../stylesheet/reportprint.css"/>
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>


<noscript>
Javascript has been disabled or not supported in this browser.<br>
Please enable Javascript supported before continue.
</noscript>
<!--- <cfparam name="Submit" default=""> --->
<cfparam name="Email" default="">

<cfquery datasource='#dts#' name="getHeaderInfo">
	select * from artran where refno ='#nexttranno#' and type = '#tran#'
</cfquery>
<cfquery name="getgeneral" datasource="#dts#">
	select #prefix# as prefix, compro, compro2, compro3, compro4, compro5, compro6, compro7,CTYCODE,comuen,gstno,wpitemtax,wpitemtax1 from gsetup 
</cfquery>
<cfset wpitemtax="">
<cfif getgeneral.wpitemtax eq "1">
	<cfif getgeneral.wpitemtax1 neq "">
    	<cfif ListFindNoCase(getgeneral.wpitemtax1, tran, ",") neq 0>
			<cfset wpitemtax = "Y">
        </cfif>
	<cfelse>
    	<cfset wpitemtax="Y">
	</cfif>
</cfif>
<cfquery name="gettaxincludesum" datasource="#dts#">
        select sum(TAXAMT_BIL) as TAXAMT_BIL from ictran where refno = '#nexttranno#' and type = '#tran#' and taxincl = "T"
</cfquery>

<cfif Email eq "Email">
	<cfquery name="getemail" datasource="#dts#">
		select e_mail from customer where custno = '#getheaderinfo.custno#'
	</cfquery>
	<cfif getemail.e_mail eq "">
	<cfoutput>
		<h4><font color="##FF0000">Please add in email address for customer - #getheaderinfo.custno#.</font></h4></cfoutput>
		<cfabort> 
	<cfelse> 
		<cflocation url="invoiceemail.cfm?nexttranno=#nexttranno#&tran=#tran#&custemail=#getemail.e_mail#&tranname=#tranname#&prefix=#getgeneral.prefix#">
	</cfif>	
</cfif>

<cfquery datasource="#dts#" name="getBodyInfo">
	select * from ictran where refno = '#nexttranno#' and type = '#tran#' order by itemcount
</cfquery>

	<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
		<cfquery datasource='#dts#' name="getBillToAdd">
   	  		select name,name2,add1,add2,add3,add4,attn,phone,fax,gstno from #target_apvend# where custno = '#getheaderInfo.custno#'
		</cfquery>
  	<cfelse>
		<cfquery datasource='#dts#' name="getBillToAdd">
   	  		select name,name2,add1,add2,add3,add4,attn,phone,fax,gstno from #target_arcust# where custno = '#getheaderInfo.custno#' 
		</cfquery>
  	</cfif>
    
	<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
		<cfquery datasource='#dts#' name="getDeliveryAdd">
   	  		select name,name2,DADDR1 as add1,DADDR2 as add2,DADDR3 as add3,DADDR4 as add4,DATTN as attn,DPHONE as phone,DFAX as fax from #target_apvend# where custno = '#getheaderInfo.custno#'
		</cfquery>
  	<cfelse>
		<cfquery datasource='#dts#' name="getDeliveryAdd">
   	  		select name,name2,DADDR1 as add1,DADDR2 as add2,DADDR3 as add3,DADDR4 as add4,DATTN as attn,DPHONE as phone,DFAX as fax from #target_arcust# where custno = '#getheaderInfo.custno#' 
		</cfquery>
  	</cfif>


<cfquery name="getagent" datasource="#dts#">
      select * from icagent where agent = '#getheaderinfo.agenno#' 
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = #getgsetup2.Decl_Uprice#>
<cfset stDecl_UPrice = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = #stDecl_UPrice# & "_">
</cfloop>

<cfset iDecl_Discount = #getgsetup2.Decl_Discount#>
<cfset stDecl_Discount = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_Discount#">
  <cfset stDecl_Discount = #stDecl_Discount# & "_">
</cfloop>

<body>
<cfform name="form1" action="">
   
<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<cfoutput query="getgeneral">
    <tr> 
		<td colspan="3">&nbsp;</td>
      	<td colspan="3" nowrap> <div align="center"><font size="4" face="Arial black">
			<strong><cfif getgeneral.compro neq ''>#compro#</cfif></strong></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro2 neq ''>#compro2#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro3 neq ''>#compro3#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro4 neq ''>#compro4#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro5 neq ''>#compro5#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro6 neq ''>#compro6#</cfif></font><br>
          	<font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro7 neq ''>#compro7#</cfif></font><br>
            <font size="2" face="Times New Roman, Times, serif">Gst Reg No : #getgeneral.gstno#</font>
            </div>
		</td>
      	<td colspan="3" valign="bottom">&nbsp;</td>
    </tr>
	</cfoutput>

    <tr> 
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong>To:</strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong>Delivery To:</strong></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="3"><strong><cfoutput>#Ucase(tranname)#</cfoutput></strong></font></td>
    </tr>
    <tr> 
      	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getBillToAdd.name# #getBillToAdd.name2#</cfoutput></strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getDeliveryAdd.name# #getDeliveryAdd.name2#</cfoutput></strong></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td width="10%"><font face="Times New Roman, Times, serif" size="2">NO.</font></td>
      	<td width="1%"><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td width="24%"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getheaderInfo.refno#</cfoutput></font></td>
    </tr>
    <tr> 
		<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getBillToAdd.add1#</cfoutput></font></td>
	    <cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
	    	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add1#</cfoutput></font></td>
	    <cfelse>
	        <td colspan="3">&nbsp;</td>
	    </cfif>
	    <td><font face="Times New Roman, Times, serif" size="2">DATE</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#dateformat(getHeaderInfo.wos_date,"dd/mm/yyyy")#</cfoutput></font></td>
    </tr>
    <tr> 
		<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#getBillToAdd.add2#</cfoutput></font></td>
		<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3"><font face="Times New Roman, Times, serif" size="2"><cfoutput>#getDeliveryAdd.add2#</cfoutput></font></td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	
    </tr>

   
    <tr> 
      	<td colspan="3"><cfoutput>GST Reg No : #getBillToAdd.gstno#</cfoutput></td>
      	<td colspan="3">&nbsp;</td>
      	<td><font face="Times New Roman, Times, serif" size="2">AGENT</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput>#huserid#</cfoutput></font></td>
    </tr>
    <tr> 
      	<td width="5%" nowrap><font face="Times New Roman, Times, serif" size="2"><strong>A/C NO</strong></font></td>
      	<td width="1%"><font size="2" face="Times New Roman, Times, serif"><strong>:</strong></font></td>
      	<td width="21%"><font face="Times New Roman, Times, serif" size="2"><strong><cfoutput>#getHeaderInfo.custno#</cfoutput></strong></font></td>
      	<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
        	<td colspan="3">&nbsp;</td>
        <cfelse>
        	<td colspan="3">&nbsp;</td>
      	</cfif>
      	<td><font face="Times New Roman, Times, serif" size="2">Payment</font></td>
      	<td><font face="Times New Roman, Times, serif">:</font></td>
      	<td><font face="Times New Roman, Times, serif" size="2"><cfoutput><cfif getHeaderInfo.cs_pm_cash neq 0>Cash<cfelseif getHeaderInfo.cs_pm_crcd neq 0>Credit Card<cfelseif getHeaderInfo.cs_pm_dbcd neq 0>Debit Card</cfif></cfoutput></font></td>
    </tr>

</table>
<hr>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr> 
      	<td width="10%" nowrap><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">ITEM</font></strong></font></div></td>
	  	<cfif tran eq "RC">
	  		<td width="20%" nowrap><div align="left"><font face="Times New Roman, Times, serif"><strong><font size="2">CODE</font></strong></font></div></td>
	  	</cfif>
      	<td width="*"><div align="left"><font face="Times New Roman, Times, serif"><strong><font size="2">DESCRIPTION</font></strong></font></div></td>
      	<td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">QTY</font></strong></font></div></td>
      	<td width="10%" nowrap><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">U.PRICE</font></strong></font></div></td>
		<cfif wpitemtax eq "Y"><td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">TAX</font></strong></font></div></td></cfif>
      	<td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">AMOUNT</font></strong></font></div></td>
		<cfif wpitemtax eq "Y"><td width="10%"><div align="center"><font face="Times New Roman, Times, serif"><strong><font size="2">TAX CODE</font></strong></font></div></td></cfif>
    </tr>
    <tr> 
      <td colspan="100%"><hr></td>
    </tr>
    <cfset totalamt = 0>
    <cfset totalqty = 0>
    <cfset disamt_bil = 0>
    <cfset row = 0>
	
    <cfoutput query="getBodyInfo"> 
		<cfset xamt_bil = 0>
		<cfset xqty = 0>
      
      	<cfquery name="getserial" datasource="#dts#">
      		select * from iserial where refno = '#nexttranno#' and type = '#getbodyinfo.type#' 
      		and itemno = '#getbodyinfo.itemno#' and trancode = '#getbodyinfo.itemcount#'
      	</cfquery>
      	<cfset row = #row# +1>
      	<tr> 
        	<td valign="top" nowrap><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#row#</font></font></div></td>
			<cfif tran eq "RC">
	  		 	<td><div><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.itemno#</font></font></div></td>
	    	</cfif>
        	<td><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.desp# #getBodyInfo.despa#</font></font></td>
        	<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.qty#</font></font></div></td>
        	<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(getBodyInfo.price_bil,stDecl_UPrice)#</font></font></div></td>
			<cfif wpitemtax eq "Y">
				<td><div align="right"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(getBodyInfo.taxamt_bil,".__")#</font></font></div></td>
			</cfif>
			<cfif wpitemtax eq "Y" and getBodyInfo.taxincl neq "T">
				<cfset xamt_bil = val(getBodyInfo.taxamt_bil)+val(getBodyInfo.amt_bil)>
			<cfelse>
				<cfset xamt_bil = val(getBodyInfo.amt_bil)>
			</cfif>
        	<td><div align="right"><font face="Times New Roman, Times, serif"><font size="2">#numberformat(xamt_bil,".__")#</font></font></div></td>
			<cfif wpitemtax eq "Y">
				<td><div align="center"><font face="Times New Roman, Times, serif"><font size="2">#getBodyInfo.note_a#<cfif getBodyInfo.taxincl eq "T"> (Tax Included)</cfif></font></font></div></td>
        </cfif>
			<cfif getbodyinfo.amt_bil neq "">
				<cfset xamt_bil = #getBodyInfo.amt_bil#>
			</cfif>
			<cfif getBodyInfo.qty neq "">
				<cfset xqty = #getBodyInfo.qty#>
			</cfif>
        	<cfset totalamt = #totalamt# + #xamt_bil#>
        	<cfset totalqty = #totalqty# + #xqty#>
		</tr>
      	<cfif getserial.recordcount gt 0>
		  	<cfset myarray = ArrayNew(1)>
		  	<cfloop query="getserial"><cfsilent>#ArrayAppend(myarray, "#serialno#")#<br></cfsilent></cfloop>
		  	<cfset mylist1= Arraytolist(myArray, ', ')>
        	<tr> 
          		<td valign="top"><div align="left"></div></td>
          		<td><font face="Times New Roman, Times, serif"><font size="2">**S/No : #mylist1#</font></font></td>
          		<td><div align="center"></div></td>
          		<td><div align="center"></div></td>
          		<td><div align="right"></div></td>
        	</tr>
      	</cfif>
	  
    	<cfif tostring(comment) neq "">
        	<tr> 
          		<td></td>
                <td></td>
          		<td><font face="Times New Roman"><font size="2">#replace(tostring(comment),chr(10),"<br/>","all")#</font></font></td>
          		<td></td>
          		<td></td>
         	 	<td></td>
        	</tr>
      	</cfif>
	</cfoutput> 
    <cfquery name="getcurdollar" datasource="#dts#">
	select currency1 from currency where currcode='#getHeaderInfo.currcode#'
	</cfquery>
    
    <tr><td colspan="100%"><cfoutput>RM : #UCase(toword(val(getHeaderInfo.grand_bil)))#</cfoutput></td>
	<tr><td colspan="100%"><hr></td></tr>
	<cfset xdisp1 = 0>
	<cfset xdisp2 = 0>
	<cfset xdisp3 = 0>
	<cfset xtaxp1 = 0>
	 
	<cfif getheaderinfo.taxp1 neq "">
		<cfset xtaxp1 = getheaderinfo.taxp1>
	</cfif>
	 
	<cfif getheaderinfo.disp1 neq "">
		<cfset xdisp1 = getheaderinfo.disp1>	
	</cfif>
	
	<cfif getheaderinfo.disp2 neq "">
		<cfset xdisp2 = getheaderinfo.disp2>
	</cfif>
	
	<cfif getheaderinfo.disp3 neq "">
	 	<cfset xdisp3 = getheaderinfo.disp3>
	</cfif>
	
	<cfset disamt_bil = getheaderinfo.disc_bil>
	  
	<cfset net_bil = totalamt - disamt_bil>
	<cfset taxamt_bil = net_bil * (xtaxp1/100)>
	  
	<cfset gross_bil = net_bil + taxamt_bil> 
    <tr>
    <td><br></td>
    </tr>

	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td colspan="2"><strong>Terms & Conditions</strong></td>
      	<td><font face="Times New Roman, Times, serif"><font size="2">TOTAL</font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(totalamt,'____.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
        <cfquery name="gettermandcondition" datasource="#dts#">
            select lcs from ictermandcondition
        </cfquery>
        <cfset info=tostring(gettermandcondition.lcs)>
		<cfset recordcnt = ListLen(info,chr(13)&chr(10))>
        <td colspan="2" rowspan="4">
        <font face="Times New Roman, Times, serif">
        <cfoutput>
        <cfloop from="1" to="#recordcnt#" index="i">
		<cfset str = ListGetAt(info,i,chr(13)&chr(10))>
        #str#<br>
        <cfset i=i+1>
        </cfloop>
        </cfoutput>
        </font>
        </td>
      	<td nowrap>
			<font face="Times New Roman, Times, serif"><font size="2">DISCOUNT 
            <cfif getheaderinfo.disp1 neq 0 and getheaderinfo.disp1 neq "">
			    <cfoutput>#numberformat(xdisp1,'____.__')# </cfoutput>
				<cfif xdisp2 neq 0>
				  	<cfoutput> + #numberformat(xdisp2,'____.__')# </cfoutput>
				</cfif>
				<cfif xdisp3 neq 0>
				  	<cfoutput> + #numberformat(xdisp3,'____.__')# </cfoutput>
				</cfif>
				(%)
			 </cfif></font></font>
		</td>
      	<td nowrap><font size="2"><div align="right"><font face="Times New Roman, Times, serif"><cfoutput>#numberformat(disamt_bil,stDecl_Discount)#</cfoutput></font></div></font></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
        
      	<td><font face="Times New Roman, Times, serif"><font size="2">NET</font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(net_bil,'____.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td nowrap><font face="Times New Roman, Times, serif"><font size="2">TAX <cfif getHeaderInfo.TAXINCL eq "T">ALREADY INCLUDED</cfif> <cfif getheaderinfo.taxp1 neq 0 and getheaderinfo.taxp1 neq ""><cfoutput>(#numberformat(xtaxp1,'____._')#</cfoutput>%)</cfif></font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(getHeaderInfo.tax_bil,'.__')#</cfoutput></font></div></td>
    </tr>
	<tr> 
      	<td></td>
	  	<cfif tran eq "RC">
	  		<td></td>
	  	</cfif>
      	<td><font face="Times New Roman, Times, serif"><font size="2">GROSS&nbsp;<cfoutput>#getheaderinfo.currcode#</cfoutput> </font></font></td>
      	<td nowrap><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#numberformat(getHeaderInfo.grand_bil,'____.__')#</cfoutput></font></div></td>
    </tr>
</table>
<br>
<br>
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr> 
      	<td width="90%"><font size="2" face="Times New Roman, Times, serif">Issued By :</font></td>
      	<td><font size="2" face="Times New Roman, Times, serif">Received By :</font></td>
    </tr>
    <tr> 
      	<td height="52">&nbsp;</td>
      	<td>&nbsp;</td>
    </tr>
    <tr> 
      	<td>_____________________</td>
      	<td>_____________________</td>
    </tr>
    <tr> 
      	<td><font face="Times New Roman, Times, serif"><font size="2"></font></font></td>
      	<td nowrap><font size="2" face="Times New Roman, Times, serif"><cfoutput>Goods received in<br>good order & condition</cfoutput></font></td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
    </tr>
</table>
<div align="right"> 
	<cfif husergrpid eq "Muser">
      	<a href="../../home2.cfm" class="noprint"><u><font size="2" face="Arial, Helvetica, sans-serif">Home</font></u></a> 
    </cfif>
    <font size="2" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font> 
</div>
</cfform>
</body>
</html>