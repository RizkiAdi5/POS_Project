<html>
<head>
<title>Product Page</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="../../scripts/collapse_expand_single_item.js"></script>
</head>

<script language='JavaScript'>
	function validate()
	{
		if(document.CustomerForm.itemno.value=='')
		{
			alert("Your Item's No. cannot be blank.");
			document.CustomerForm.itemno.focus();
			return false;
		}
		if(document.CustomerForm.WOS_GROUP.value == '')
		{
			a=document.CustomerForm.graded1.checked;
			if(a==true)
			{			
				alert("A Graded Item Must Assign A Group !");
				document.CustomerForm.WOS_GROUP.focus();
				return false;
			}
		}
		return true;
	}
</script>

<cfquery name='getgsetup' datasource='#dts#'>
  Select * from gsetup
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_UPrice = '.'>

<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = stDecl_UPrice & '_'>
</cfloop>

<body>
<cfoutput>
	<cfif url.type eq 'Edit'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icitem where itemno='#url.itemno#'
	  	</cfquery>
		
		<cfset edi_id=getitem.edi_id>
	  	<cfset ItemNo=getitem.itemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
	  	<cfset MITEMNO=getitem.MITEMNO>
	  	<cfset BRAND=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset MINIMUM=getitem.MINIMUM>
	  	<cfset xSIZEID=getitem.SIZEID>
	  	<cfset PACKING=getitem.PACKING>
	  	<cfset MAXIMUM=getitem.MAXIMUM>
	  	<cfset xCOSTCODE=getitem.COSTCODE>
	  	<cfset REORDER=getitem.REORDER>
	  	<cfset xCOLORID=getitem.COLORID>
	  	<cfset xshelf=getitem.shelf>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
		<CFSET xUNIT=getitem.UNIT>
	  	<CFSET WQFORMULA=getitem.WQFORMULA>
	  	<CFSET WPFORMULA=getitem.WPFORMULA>
	  	<CFSET QTYBF=getitem.QTYBF>
	  	<CFSET UCOST=getitem.UCOST>
	  	<CFSET PRICE=getitem.PRICE>
	  	<CFSET PRICE2=getitem.PRICE2>
	  	<CFSET PRICE3=getitem.PRICE3>
	  	<CFSET PRICE_MIN=getitem.PRICE_MIN>
	  	<cfset graded=getitem.graded>
	  	<CFSET MURATIO=getitem.MURATIO>
	  	<CFSET QTY2=getitem.QTY2>
	  	<CFSET QTY3=getitem.QTY3>
	  	<CFSET QTY4=getitem.QTY4>
	  	<CFSET QTY5=getitem.QTY5>
	  	<CFSET QTY6=getitem.QTY6>
	  	<CFSET SALEC=getitem.SALEC>
	  	<CFSET SALECSC=getitem.SALECSC>
	  	<CFSET SALECNC=getitem.SALECNC>
	  	<CFSET PURC=getitem.PURC>
	  	<CFSET PURPREC=getitem.PURPREC>
	  	<CFSET WSERIALNO=getitem.WSERIALNO>
		<cfset nonstkitem = getitem.nonstkitem>
	  	<CFSET REMARK1=getitem.REMARK1>
	  	<CFSET REMARK2=getitem.REMARK2>
	  	<CFSET REMARK3=getitem.REMARK3>
	  	<CFSET REMARK4=getitem.REMARK4>
	  	<CFSET REMARK5=getitem.REMARK5>
	  	<CFSET REMARK6=getitem.REMARK6>
	  	<CFSET REMARK7=getitem.REMARK7>
	  	<CFSET REMARK8=getitem.REMARK8>
	  	<CFSET REMARK9=getitem.REMARK9>
	  	<CFSET REMARK10=getitem.REMARK10>
	  	<CFSET REMARK11=getitem.REMARK11>
	  	<CFSET REMARK12=getitem.REMARK12>
	  	<CFSET REMARK13=getitem.REMARK13>
	  	<CFSET REMARK14=getitem.REMARK14>
	  	<CFSET REMARK15=getitem.REMARK15>
		<CFSET REMARK16=getitem.REMARK16>
		<CFSET REMARK17=getitem.REMARK17>
		<CFSET REMARK18=getitem.REMARK18>
		<CFSET REMARK19=getitem.REMARK19>
		<CFSET REMARK20=getitem.REMARK20>
		<CFSET REMARK21=getitem.REMARK21>
		<CFSET REMARK22=getitem.REMARK22>
		<CFSET REMARK23=getitem.REMARK23>
		<CFSET REMARK24=getitem.REMARK24>
		<CFSET REMARK25=getitem.REMARK25>
		<CFSET REMARK26=getitem.REMARK26>
		<CFSET REMARK27=getitem.REMARK27>
		<CFSET REMARK28=getitem.REMARK28>
		<CFSET REMARK29=getitem.REMARK29>
		<CFSET REMARK30=getitem.REMARK30>
	  	<cfset mode='Edit'>
	  	<cfset title='Edit Item'>
	  	<cfset button='Edit'>
	</cfif>

	<cfif url.type eq 'Delete'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icitem where itemno='#url.itemno#'
	  	</cfquery>
		
		<cfset edi_id=getitem.edi_id>
	  	<cfset ItemNo=getitem.itemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
	  	<cfset MITEMNO=getitem.MITEMNO>
	  	<cfset BRAND=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset MINIMUM=getitem.MINIMUM>
	  	<cfset xSIZEID=getitem.SIZEID>
	  	<cfset PACKING=getitem.PACKING>
	  	<cfset MAXIMUM=getitem.MAXIMUM>
	  	<cfset xCOSTCODE=getitem.COSTCODE>
	  	<cfset REORDER=getitem.REORDER>
	  	<cfset xCOLORID=getitem.COLORID>
	  	<cfset xshelf=getitem.shelf>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
		<CFSET xUNIT=getitem.UNIT>
	  	<CFSET WQFORMULA=getitem.WQFORMULA>
	  	<CFSET WPFORMULA=getitem.WPFORMULA>
	  	<CFSET QTYBF=getitem.QTYBF>
	  	<CFSET UCOST=getitem.UCOST>
	  	<CFSET PRICE=getitem.PRICE>
	  	<CFSET PRICE2=getitem.PRICE2>
	  	<CFSET PRICE3=getitem.PRICE3>
	  	<CFSET PRICE_MIN=getitem.PRICE_MIN>
	  	<cfset graded=getitem.graded>
	  	<CFSET MURATIO=getitem.MURATIO>
	  	<CFSET QTY2=getitem.QTY2>
	  	<CFSET QTY3=getitem.QTY3>
	  	<CFSET QTY4=getitem.QTY4>
	  	<CFSET QTY5=getitem.QTY5>
	  	<CFSET QTY6=getitem.QTY6>
	  	<CFSET SALEC=getitem.SALEC>
	  	<CFSET SALECSC=getitem.SALECSC>
	  	<CFSET SALECNC=getitem.SALECNC>
	  	<CFSET PURC=getitem.PURC>
	  	<CFSET PURPREC=getitem.PURPREC>
	  	<CFSET WSERIALNO=getitem.WSERIALNO>
		<cfset nonstkitem = getitem.nonstkitem>
	  	<CFSET REMARK1=getitem.REMARK1>
	  	<CFSET REMARK2=getitem.REMARK2>
	  	<CFSET REMARK3=getitem.REMARK3>
	  	<CFSET REMARK4=getitem.REMARK4>
	  	<CFSET REMARK5=getitem.REMARK5>
	  	<CFSET REMARK6=getitem.REMARK6>
	  	<CFSET REMARK7=getitem.REMARK7>
	  	<CFSET REMARK8=getitem.REMARK8>
	  	<CFSET REMARK9=getitem.REMARK9>
	  	<CFSET REMARK10=getitem.REMARK10>
	  	<CFSET REMARK11=getitem.REMARK11>
	  	<CFSET REMARK12=getitem.REMARK12>
	  	<CFSET REMARK13=getitem.REMARK13>
	  	<CFSET REMARK14=getitem.REMARK14>
	  	<CFSET REMARK15=getitem.REMARK15>
		<CFSET REMARK16=getitem.REMARK16>
		<CFSET REMARK17=getitem.REMARK17>
		<CFSET REMARK18=getitem.REMARK18>
		<CFSET REMARK19=getitem.REMARK19>
		<CFSET REMARK20=getitem.REMARK20>
		<CFSET REMARK21=getitem.REMARK21>
		<CFSET REMARK22=getitem.REMARK22>
		<CFSET REMARK23=getitem.REMARK23>
		<CFSET REMARK24=getitem.REMARK24>
		<CFSET REMARK25=getitem.REMARK25>
		<CFSET REMARK26=getitem.REMARK26>
		<CFSET REMARK27=getitem.REMARK27>
		<CFSET REMARK28=getitem.REMARK28>
		<CFSET REMARK29=getitem.REMARK29>
		<CFSET REMARK30=getitem.REMARK30>
		<cfset mode='Delete'>
	  	<cfset title='Delete Item'>
	  	<cfset button='Delete'>
	</cfif>
			
    <cfif url.type eq 'Create'>
    	<cfset edi_id=''>
      	<cfset ItemNo=''>
	  	<cfset desp=''>
	  	<cfset despa=''>
	  	<cfset MITEMNO=''>
	  	<cfset BRAND=''>
	  	<cfset xCATEGORY=''>
	  	<cfset xSUPP=''>
	  	<cfset MINIMUM=''>
	  	<cfset xSIZEID=''>
	  	<cfset PACKING=''>
	  	<cfset MAXIMUM=''>
	  	<cfset xCOSTCODE=''>
	  	<cfset REORDER=''>
	  	<cfset xCOLORID=''>
	  	<cfset xshelf=''>
	  	<cfset xWOS_GROUP=''>
	  	<CFSET xUNIT=''>
	  	<CFSET WQFORMULA=''>
	  	<CFSET WPFORMULA=''>
	  	<CFSET QTYBF=''>
	  	<CFSET UCOST=''>
	  	<CFSET PRICE=''>
	  	<CFSET PRICE2=''>
	  	<CFSET PRICE3=''>
	  	<CFSET PRICE_MIN=''>
	  	<cfset graded = '0'>
	  	<CFSET MURATIO=''>
	  	<CFSET QTY2=''>
	  	<CFSET QTY3=''>
	  	<CFSET QTY4=''>
	  	<CFSET QTY5=''>
	  	<CFSET QTY6=''>
	  	<CFSET SALEC=''>
	  	<CFSET SALECSC=''>
	  	<CFSET SALECnC=''>
	  	<CFSET PURC=''>
	  	<CFSET PURPREC=''>
	  	<CFSET WSERIALNO=''>
		<cfset nonstkitem = "">
	  	<CFSET REMARK1=''>
	  	<CFSET REMARK2=''>
	  	<CFSET REMARK3=''>
	  	<CFSET REMARK4=''>
	  	<CFSET REMARK5=''>
	  	<CFSET REMARK6=''>
	  	<CFSET REMARK7=''>
	  	<CFSET REMARK8=''>
	  	<CFSET REMARK9=''>
	  	<CFSET REMARK10=''>
	  	<CFSET REMARK11=''>
	  	<CFSET REMARK12=''>
	  	<CFSET REMARK13=''>
	  	<CFSET REMARK14=''>
	  	<CFSET REMARK15=''>
		<CFSET REMARK16=''>
		<CFSET REMARK17=''>
		<CFSET REMARK18=''>
		<CFSET REMARK19=''>
		<CFSET REMARK20=''>
		<CFSET REMARK21=''>
		<CFSET REMARK22=''>
		<CFSET REMARK23=''>
		<CFSET REMARK24=''>
		<CFSET REMARK25=''>
		<CFSET REMARK26=''>
		<CFSET REMARK27=''>
		<CFSET REMARK28=''>
		<CFSET REMARK29=''>
		<CFSET REMARK30=''>
		
	  	<cfset mode='Create'>
	  	<cfset title='Create Item'>
	  	<cfset button='Create'>
	</cfif>

	<h1>#title#</h1>
	
    <h4>
		<cfif getpin2.h1310 eq 'T'>
			<a href="icitem2.cfm?type=Create">Creating a New Item</a>
		</cfif>
		<cfif getpin2.h1320 eq 'T'>
			|| <a href="icitem.cfm?">List all Item</a> 
		</cfif>
		<cfif getpin2.h1330 eq 'T'>
			|| <a href="s_icitem.cfm?type=icitem">Search For Item</a> 
		</cfif>
		<cfif getpin2.h1340 eq 'T'>
			|| <a href="p_icitem.cfm">Item Listing</a> 
		</cfif>
			|| <a href="icitem_setting.cfm">More Setting</a> 
	</h4>
</cfoutput>

<cfform name='CustomerForm' action='icitemprocess.cfm' method='post' onsubmit='return validate();'>
  	<cfoutput>
		<input type='hidden' name='mode' value='#mode#'>
	  	<input type='hidden' name='edi_id' value='#edi_id#'>
	</cfoutput>
	
    <h1 align='center'>Item File Maintenance</h1>

	<table align='center' class='data' width='50%' cellspacing="0">
    <cfoutput> 
    	<tr> 
        	<td width='126'>Itemno :</td>
        	<td colspan='7'>
				<cfif mode eq 'Delete' or mode eq 'Edit'>            
            		<input type='text' size='40' name='itemno' value='#url.itemno#' readonly>
            	<cfelse>
            		<input type='text' size='40' name='itemno' value='#itemno#' maxlength='24'>
          		</cfif>
			</td>
      	</tr>
      	<tr> 
        	<td>Description :</td>
        	<td colspan='7'><input type='text' size='100' name='desp' value='#desp#' maxlength='60' onClick="onselect()"></td>
      	</tr>
      	<tr> 
        	<td>&nbsp;</td>
        	<td colspan='7'><input type='text' size='100' name='despa' value='#despa#' maxlength='70'></td>
      	</tr>
      	<tr> 
        	<td>Product Code :</td>
        	<td colspan='7'><input type='text' size='60' name='MITEMNO' value='#MITEMNO#' maxlength='20'></td>
      	</tr>
      	<tr> 
        	<td height='22'>Brand :</td>
        	<td colspan='7'> <input type='text' size='100' name='BRAND' value='#BRAND#' maxlength='40'></td>
      	</tr>
    </cfoutput> 
    	<tr> 
      		<td colspan='8'><hr></td>
    	</tr>
    	<tr> 
      		<th height='20' colspan='8'> <div align='center'><strong>General Information</font></strong></div></th>
    	</tr>
		
    <!--- Value Type => Category --->
    <cfquery name='getcate' datasource='#dts#'>
    	select * from iccate order by cate 
    </cfquery>
    <!--- Size => SizeID --->
    <cfquery name='getsizeid' datasource='#dts#'>
    	select * from icsizeid order by sizeid 
    </cfquery>
    <!--- Rating => CostCode --->
    <cfquery name='getcostcode' datasource='#dts#'>
    	select * from iccostcode order by costcode 
    </cfquery>
    <!--- Material => ColorID --->
    <cfquery name='getcolorid' datasource='#dts#'>
    	select * from iccolorid order by colorid 
    </cfquery>
    <!--- Manufacturer => shelf --->
    <cfquery name='getshelf' datasource='#dts#'>
    	select * from icshelf order by shelf 
    </cfquery>
    <!--- Model => Group --->
    <cfquery name='getgroup' datasource='#dts#'>
    	select * from icgroup order by wos_group 
    </cfquery>
    <!--- unit --->
    <cfquery name='getUnit' datasource='#dts#'>
    	select * from Unit order by unit 
    </cfquery>
    <!--- Supplier --->
    <cfquery name='getsupp' datasource='#dts#'>
    	select * from #target_apvend# where status<>'B' order by custno 
    </cfquery>
	
	<tr>
		<td>Supplier :</td>
      	<td colspan='4'>
			<select name='supp'>
          		<option value=''>-</option>
          		<cfoutput query='getsupp'> 
            	<option value='#custno#'<cfif custno eq xsupp>selected</cfif>>#custno# - #getsupp.name#</option>
          		</cfoutput>
			</select>
		</td>
	</tr>
    <tr>
		<cfoutput>
		<td>#getgsetup.lcategory# :</td>
      	</cfoutput> 
      	<td width='148'>
			<select name='CATEGORY'>
          		<option value=''>-</option>
          		<cfoutput query='getcate'> 
            	<option value='#cate#'<cfif cate eq xcategory>selected</cfif>>#cate# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
		<td></td>
		<td></td>
		<td rowspan="6" colspan="2"><img src="../../DSC00316.JPG" width="150" height="150"></td>
    </tr>
    <tr><cfoutput><td>#getgsetup.lsize# :</td></cfoutput>
		<td width='148'>
			<select name='SIZEID'>
          		<option value=''>-</option>
          		<cfoutput query='getsizeid'> 
            	<option value='#sizeid#'<cfif sizeid eq xsizeid>selected</cfif>>#sizeid# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
      	<td colspan='-1'>Packing :</td>
      	<td colspan='-1'>&nbsp;</td>
		<td rowspan="6">&nbsp;</td>
    </tr>   
    <tr><cfoutput><td>#getgsetup.lrating# :</td></cfoutput> 
    	<td width='148'>
			<select name='COSTCODE'>
          		<option value=''>-</option>
          		<cfoutput query='getcostcode'> 
            	<option value='#costcode#'<cfif costcode eq xcostcode>selected</cfif>>#costcode# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
		<td width='100' colspan='-1'>Minimum :</td>
      	<td width='151' colspan='-1'><cfinput type='text' size='14' name='MINIMUM' value='#MINIMUM#' maxlength='14'></td>
    </tr>
    <tr><cfoutput><td>#getgsetup.lmaterial# :</td></cfoutput> 
		<td width='148'>
			<select name='COLORID'>
          		<option value=''>-</option>
          		<cfoutput query='getcolorid'> 
            	<option value='#colorid#'<cfif colorid eq xcolorid>selected</cfif>>#colorid# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
		<td colspan='-1'>Maximum :</td>
      	<td colspan='-1'><cfinput type='text' size='14' name='MAXIMUM' value='#MAXIMUM#' maxlength='14'></td>
    </tr>
    <tr><cfoutput><td>#getgsetup.lgroup# :</td></cfoutput>
		<td width='148'>
			<select name='WOS_GROUP'>
          		<option value=''>-</option>
          		<cfoutput query='getgroup'> 
            	<option value='#wos_group#'<cfif wos_group eq xwos_group>selected</cfif>>#wos_group# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
		<td colspan='-1'>Reorder :</td>
      	<td colspan='-1'><cfinput type='text' size='14' name='REORDER' value='#REORDER#' maxlength='14'></td>
    </tr>
    <tr><cfoutput><td>#getgsetup.lmodel# :</td></cfoutput>
		<td width='148'>
			<select name='shelf'>
          		<option value=''>-</option>
          		<cfoutput query='getshelf'> 
            	<option value='#shelf#'<cfif shelf eq xshelf>selected</cfif>>#shelf# - #desp#</option>
          		</cfoutput>
			</select>
		</td>
      	<td colspan='2'>&nbsp;</td>
      	<td colspan='2'>&nbsp;</td>
      	<td colspan='-1'>&nbsp;</td>
    </tr>
    <tr> 
      	<td colspan='8'><hr></td>
    </tr>
    <tr> 
      	<th colspan='8'><div align='center'><strong>Product Details</strong></div></th>
    </tr>
    <tr align="left"> 
      	<td nowrap>Unit of Measurement :</td>
      	<td>
			<select name='UNIT'>
          		<option value=''>-</option>
          		<cfoutput query='getUnit'> 
            	<option value='#Unit#'<cfif Unit eq xUNIT>selected</cfif>>#Unit# - #desp#</option>
          		</cfoutput>
			</select> 
      	</td>
      	<CFOUTPUT>
        <td nowrap>Qty Formula :</td>
        <td nowrap><input name='WQFORMULA' type='checkbox' value='1' <cfif #WQFORMULA# eq 1>checked</cfif>></td>
        <td nowrap> U.P Formula :</td>
        <td nowrap><input name='WPFORMULA' type='checkbox' value='1' <cfif #WPFORMULA# eq 1>checked</cfif>></td>
      	</CFOUTPUT>
	</tr>
    <cfoutput> 
	<tr> 
    	<td nowrap>Unit Cost Price :</td>
        <td nowrap><input name='UCOST' type='text' value='#NumberFormat(UCOST, stDecl_UPrice)#' size='17' maxlength='17'></td>
        <td nowrap>Serial No. :</td>
      	<td nowrap><input name='wserialno' type='checkbox' value='T'<cfif #wserialno# eq "T">checked</cfif>></td>
        <td colspan='-1'>&nbsp;</td>
        <td colspan='-1'>&nbsp;</td>
	</tr>
    </cfoutput> 
    <tr> 
      	<td height='22'>Unit Selling Price :</td>
      	<td><cfinput name='PRICE' type='text' id='PRICE' value='#NumberFormat(PRICE, stDecl_UPrice)#' size='17' maxlength='17'></td>
		<td nowrap>Non Graded :</td>
        <td nowrap><input name='graded' id="graded2" type='radio' value='N' <cfif graded eq "N" or graded eq ''>checked<cfelse>checked</cfif>></td>
        <td nowrap>Qty B/F :</td>
        <td nowrap><cfoutput><input name='QTYBF' type='text' value='#QTYBF#' size='8' maxlength='8'></cfoutput></td>
      	<td colspan='-1'>&nbsp;</td>
      	<td colspan='-1'>&nbsp;</td>
    </tr>
    <tr> 
      	<td height='22'>Unit Selling Price 2 :</td>
      	<td><cfinput name='PRICE2' type='text' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'></td>
      	<td nowrap>Graded :</td>
        <td nowrap><input name='graded' id="graded1" type='radio' value='Y' <cfif graded eq "Y">checked</cfif>></td>
      	<!--- <td nowrap>Graded 2 :</td>
      	<td nowrap><input name='graded' type='radio' value='Y' <cfif #graded# eq 2>checked</cfif>></td> --->
    </tr>
    <cfoutput> 
	<tr> 
    	<td nowrap>M.U Ratio :<input name='MURATIO' type='text' value='#MURATIO#' size='5' maxlength='5'></td>
        <td><input name='PRICE3' type='text' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
        <td nowrap>Length :</td>
      	<td nowrap><cfinput name='QTY2' type='text' value='#QTY2#' size='8' maxlength='8'></td>
      	<td nowrap>Credit Sales :</td>
      	<td nowrap><cfinput name='SALEC' type='text' value='#SALEC#' size='8' maxlength='8'></td>
    </tr>
    <tr> 
        <td><cfif getgsetup.gpricemin eq 1>Min. Selling Price :</cfif></td>
        <td>
			<cfif getgsetup.gpricemin eq 1>
				<cfinput name='PRICE_MIN' type='text' value='#NumberFormat(PRICE_MIN, stDecl_UPrice)#' size='17' maxlength='17'>
			</cfif>
		</td>
		<td nowrap>Width :</td>
        <td nowrap><input name='QTY3' type='text' value='#QTY3#' size='8' maxlength='8'></td>
        <td nowrap>Cash Sales :</td>
        <td nowrap><input name='SALECSC' type='text' value='#SALECSC#' size='8' maxlength='8'></td>
      </tr>
    </cfoutput>
	<cfoutput> 
	<tr> 
    	<td nowrap>Discontinue Item :</td>
        <td nowrap><input name='nonstkitem' type='checkbox' value='T' <cfif nonstkitem eq 'T'>checked</cfif>></td>
		<td nowrap>Thickness :</td>
        <td nowrap><input name='QTY4' type='text' value='#QTY4#' size='8' maxlength='8'></td>
        <td nowrap>Sales Return :</td>
        <td nowrap><input name='SALECNC' type='text' value='#SALECNC#' size='8' maxlength='8'></td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td>&nbsp;</td>
		<td nowrap>Weight / Length :</td>
        <td nowrap><input name='QTY5' type='text' value='#QTY5#' size='8' maxlength='8'></td>
        <td nowrap>Purchase :</td>
        <td nowrap><input name='PURC' type='text' value='#PURC#' size='8' maxlength='8'></td>
    </tr>
	<tr>
		<td>&nbsp;</td>
        <td>&nbsp;</td>
		<td nowrap>Price / Weight :</td>
        <td nowrap><input name='QTY6' type='text' value='#QTY6#' size='8' maxlength='8'></td>
        <td nowrap>Purchase Return :</td>
        <td nowrap><input name='PURPREC' type='text' value='#PURPREC#' size='8' maxlength='8'></td>
	</tr>
	<tr><td><br></td></tr>
    <tr> 
    	<td colspan="7" align="right"><input name='submit' type='submit' value='#button#'></td>
    </tr>
    <tr> 
        <td colspan='8'><hr></td>
    </tr>
    <tr> 
        <th height='20' colspan='8' onclick="javascript:shoh('r1');"><div align='center'><strong>Remarks<img src="../../images/d.gif" name="imgr1" align="center"></font></strong></div></th>
    </tr>
	<tr>
		<td colspan="7">
			<table id="r1" align="center" width="50%">
				<tr> 
					<td nowrap height='22'>Remark 1 :</td>
					<td colspan='7'><input name='Remark1' type='text' value='#Remark1#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 2 :</td>
					<td colspan='7'><input name='Remark2' type='text' value='#Remark2#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 3 :</td>
					<td colspan='7'><input name='Remark3' type='text' value='#Remark3#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 4 :</td>
					<td colspan='7'><input name='Remark4' type='text' value='#Remark4#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 5 :</td>
					<td colspan='7'><input name='Remark5' type='text' value='#Remark5#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 6 :</td>
					<td colspan='7'><input name='Remark6' type='text' value='#Remark6#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 7 :</td>
					<td colspan='7'><input name='Remark7' type='text' value='#Remark7#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 8 :</td>
					<td colspan='7'><input name='Remark8' type='text' value='#Remark8#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 9 :</td>
					<td colspan='7'><input name='Remark9' type='text' value='#Remark9#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td nowrap height='22'>Remark 10 :</td>
					<td colspan='7'><input name='Remark10' type='text' value='#Remark10#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 11 :</td>
					<td colspan='7'><input name='Remark11' type='text' value='#Remark11#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 12 :</td>
					<td colspan='7'><input name='Remark12' type='text' value='#Remark12#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='26'>Remark 13 :</td>
					<td colspan='7'><input name='Remark13' type='text' value='#Remark13#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 14 :</td>
					<td colspan='7'><input name='Remark14' type='text' value='#Remark14#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 15 :</td>
					<td colspan='7'><input name='Remark15' type='text' value='#Remark15#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 16 :</td>
					<td colspan='7'><input name='Remark16' type='text' value='#Remark16#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 17 :</td>
					<td colspan='7'><input name='Remark17' type='text' value='#Remark17#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 18 :</td>
					<td colspan='7'><input name='Remark18' type='text' value='#Remark18#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 19 :</td>
					<td colspan='7'><input name='Remark19' type='text' value='#Remark19#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 20 :</td>
					<td colspan='7'><input name='Remark20' type='text' value='#Remark20#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 21 :</td>
					<td colspan='7'><input name='Remark21' type='text' value='#Remark21#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 22 :</td>
					<td colspan='7'><input name='Remark22' type='text' value='#Remark22#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 23 :</td>
					<td colspan='7'><input name='Remark23' type='text' value='#Remark23#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 24 :</td>
					<td colspan='7'><input name='Remark24' type='text' value='#Remark24#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 25 :</td>
					<td colspan='7'><input name='Remark25' type='text' value='#Remark25#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 26 :</td>
					<td colspan='7'><input name='Remark26' type='text' value='#Remark26#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 27 :</td>
					<td colspan='7'><input name='Remark27' type='text' value='#Remark27#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 28 :</td>
					<td colspan='7'><input name='Remark28' type='text' value='#Remark28#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 29 :</td>
					<td colspan='7'><input name='Remark29' type='text' value='#Remark29#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
				<tr> 
					<td height='22'>Remark 30 :</td>
					<td colspan='7'><input name='Remark30' type='text' value='#Remark30#' size='100' maxlength='50' onClick="select();"></td>
				</tr>
			</table>
		</td>
	</tr>
    </cfoutput>
	</table>
</cfform>
<cfinput type='text' size='14' name='PACKING' value='#PACKING#' maxlength='20'>
</body>
</html>