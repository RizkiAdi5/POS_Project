<cfinclude template="../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Product Page</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="../../scripts/collapse_expand_single_item.js"></script>

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script language='JavaScript'>

	function calculate_price3(fixnum){
		if(isNaN(document.form.MURATIO.value)){
			alert("The value is not a number. Please try again");
		}
		else{
			if(document.form.UCOST.value == ''){
				var costprice = 0;
			}
			else{
				var costprice = document.form.UCOST.value;
			}
			var price3 = document.form.MURATIO.value * document.form.UCOST.value;
			price3 = price3.toFixed(fixnum);
			document.form.PRICE3.value = price3;
		}
	}
	
	function validate()
	{
		if(document.form.mitemno.value=='')
		{
			alert("Your Matrix Item's No. cannot be blank.");
			document.form.mitemno.focus();
			return false;
		}
		
		return true;
	}
	
	function getcolorsize(colorno){
		if(colorno !=''){
			DWREngine._execute(_maintenanceflocation, null, 'getcolorsize', colorno, showcolorsize);
		}
	}
	
	function showcolorsize(colorObject){
		//1. Clear all the Size & Color	
		for(j=1;j<=20;j++){
			fieldname = 'color'+j;
			fieldname2 = 'size'+j;
			DWRUtil.setValue(fieldname, '');
			DWRUtil.setValue(fieldname2, '');
		}
		
		//2. Add Color	
		newArray = colorObject.COLORLIST;
		var colorArray = newArray.split(",");
		var count=0;
		if(colorArray.length <= 20){
			for(i=0;i<colorArray.length;i++){
				var count=count+1;
				fieldname = 'color'+count;
				DWRUtil.setValue(fieldname, colorArray[i]);
			}
		}else{
			for(i=0;i<20;i++){
				var count=count+1;
				fieldname = 'color'+count;
				DWRUtil.setValue(fieldname, colorArray[i]);
			}
		}
		
		//3. Add Size
		newArray2 = colorObject.SIZELIST;
		var sizeArray = newArray2.split(",");
		var count1=0;
		if(sizeArray.length <= 20){
			for(i=0;i<sizeArray.length;i++){
				var count1=count1+1;
				fieldname = 'size'+count1;
				DWRUtil.setValue(fieldname, sizeArray[i]);
			}
		}else{
			for(i=0;i<20;i++){
				var count1=count1+1;
				fieldname = 'size'+count1;
				DWRUtil.setValue(fieldname, sizeArray[i]);
			}
		}	
	}
	
</script>
</head>

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

<cfquery name="geticcolor2" datasource="#dts#">
	select distinct colorno from iccolor2
</cfquery>
<body>
<cfoutput>
	<cfif url.type eq 'Edit'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icmitem where mitemno='#url.mitemno#'
	  	</cfquery>
		
		<cfset xcolorno=getitem.colorno>	
	  	<cfset mitemno=getitem.mitemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
	  	<cfset AITEMNO=getitem.AITEMNO>
	  	<cfset BRAND=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
        <cfset xsizeid=getitem.sizeid>
		<cfset xUNIT=getitem.UNIT>
	  	<cfset UCOST=getitem.UCOST>
	  	<cfset PRICE=getitem.PRICE>
        <cfset PRICE2=getitem.PRICE2>
        <cfset PRICE3=getitem.PRICE3>
        <cfset muratio=getitem.muratio>
	  	<cfset sizecolor=getitem.sizecolor>
	  	<cfset mode='Edit'>
	  	<cfset title='Edit Item'>
	  	<cfset button='Edit'>
	</cfif>

	<cfif url.type eq 'Delete'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icmitem where mitemno='#url.mitemno#'
	  	</cfquery>
		
		<cfset xcolorno=getitem.colorno>
	  	<cfset mitemno=getitem.mitemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
	  	<cfset AITEMNO=getitem.AITEMNO>
	  	<cfset BRAND=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
        <cfset xsizeid=getitem.sizeid>
		<cfset xUNIT=getitem.UNIT>
	  	<cfset UCOST=getitem.UCOST>
	  	<cfset PRICE=getitem.PRICE>
        <cfset PRICE2=getitem.PRICE2>
        <cfset PRICE3=getitem.PRICE3>
        <cfset muratio=getitem.muratio>
	  	<cfset sizecolor=getitem.sizecolor>
		<cfset mode='Delete'>
	  	<cfset title='Delete Item'>
	  	<cfset button='Delete'>
	</cfif>
			
    <cfif url.type eq 'Create'>
      	<cfset xcolorno=''>
		<cfset mitemno=''>
	  	<cfset desp=''>
	  	<cfset despa=''>
	  	<cfset AITEMNO=''>
	  	<cfset BRAND=''>
	  	<cfset xCATEGORY=''>
	  	<cfset xSUPP=''>
	  	<cfset xWOS_GROUP=''>
        <cfset xsizeid=''>
	  	<cfset xUNIT=''>
	  	<cfset UCOST=''>
	  	<cfset PRICE=''>
        <cfset PRICE2=''>
        <cfset PRICE3=''>
        <cfset muratio=''>
	  	<cfset sizecolor='SC'>
	  	<cfset mode='Create'>
	  	<cfset title='Create Item'>
	  	<cfset button='Create'>
	</cfif>

	<h1>#title#</h1>
	
    <h4>
		<cfif getpin2.h1M10 eq 'T'><a href="matrixitemtable2.cfm?type=Create">Creating a New Matrix Item</a> </cfif>
		<cfif getpin2.h1M20 eq 'T'>|| <a href="matrixitemtable.cfm">List all Matrix Item</a> </cfif>
		<cfif getpin2.h1M30 eq 'T'>|| <a href="s_matrixitemtable.cfm?type=Icitem">Search For Matrix Item</a> </cfif>
	</h4>
  </cfoutput>

<cfform name='form' action='matrixitemtableprocess.cfm' method='post' onsubmit='return validate();'>
<cfoutput><input type='hidden' name='mode' value='#mode#'></cfoutput>
<h1 align='center'>Matrix Item File Maintenance</h1>
	<table align='center' class='data' width='90%' cellspacing="0">
    <cfoutput>
		<tr>
        	<td width='126'>Color No. :</td>
        	<td colspan='7'>
          		<cfif mode eq 'Delete' or mode eq 'Edit'>
            		<input type='text' size='5' name='colorno' value='#xcolorno#' readonly>
            	<cfelse>
            		<select name='colorno' onChange="getcolorsize(this.value)">
          				<option value=''>-</option>
          				<cfloop query='geticcolor2'>
            				<option value='#colorno#'>#colorno#</option>
         	 			</cfloop>
        			</select>
          		</cfif>
       		</td>
      	</tr>
      	<tr>
        	<td width='126'>Matrix Itemno :</td>
        	<td colspan='7'>
          		<cfif mode eq 'Delete' or mode eq 'Edit'>
            		<input type='text' size='40' name='mitemno' value='#convertquote(url.mitemno)#' readonly>
            	<cfelse>
            		<input type='text' size='40' name='mitemno' value='#mitemno#' maxlength='24'>
          		</cfif>
        	</td>
      	</tr>
      	<tr>
        	<td>Description :</td>
        	<td colspan='7'><input type='text' size='100' name='desp' value='#convertquote(desp)#' maxlength='60'></td>
      	</tr>
      	<tr>
        	<td>&nbsp;</td>
        	<td colspan='7'><input type='text' size='100' name='despa' value='#convertquote(despa)#' maxlength='70'></td>
      	</tr>
      	<tr>
        	<td>Alternate Itemno:</td>
        	<td colspan='7'><input type='text' size='60' name='AITEMNO' value='#AITEMNO#' maxlength='20'></td>
      	</tr>
      	<tr>
        	<td height='22'>Brand :</td>
        	<td colspan='7'><input type='text' size='100' name='BRAND' value='#convertquote(BRAND)#' maxlength='40'></td>
      	</tr>
    </cfoutput>
    <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th height='20' colspan='8'>
        <div align='center'><strong>General Information</strong></div></th>
    </tr>
    <!--- Value Type => Category --->
    <cfquery name='getcate' datasource='#dts#'>
    select * from iccate order by cate
    </cfquery>
    <!--- Model => Group --->
    <cfquery name='getgroup' datasource='#dts#'>
    select * from icgroup order by wos_group
    </cfquery>
    <!--- size --->
    <cfquery name='getsize' datasource='#dts#'>
    select * from icsizeid order by sizeid
    </cfquery>
    <!--- unit --->
    <cfquery name='getUnit' datasource='#dts#'>
    select * from Unit order by unit
    </cfquery>
    <!--- Supplier --->
    <cfquery name='getsupp' datasource='#dts#'>
    select * from #target_apvend# where status<>'B' order by custno
    </cfquery>
	<!--- Color --->
	<cfquery name='geticcolor2' datasource='#dts#'>
    	select colorid2,desp from iccolor2 group by colorid2 order by colorid2
    </cfquery>
    <tr>
      <td>Supplier :</td>
      <td colspan='7'>
        <select name='supp'>
          <option value=''>-</option>
          <cfoutput query='getsupp'>
            <option value='#custno#'<cfif custno eq xsupp>selected</cfif>>#custno# - #getsupp.name#</option>
          </cfoutput>
        </select>
      </td>
    </tr>
    <tr> 
		<cfoutput><td>#getgsetup.lcategory# :</td></cfoutput>
        <td colspan='7'>
          <select name='CATEGORY'>
            <option value=''>-</option>
            <cfoutput query='getcate'>
              <option value='#cate#'<cfif cate eq xcategory>selected</cfif>>#cate# - #desp#</option>
            </cfoutput>
          </select>
        </td>
    </tr>
    <tr>
		<cfoutput><td>#getgsetup.lgroup# :</td></cfoutput>
        <td colspan='7'>
          <select name='WOS_GROUP'>
            <option value=''>-</option>
            <cfoutput query='getgroup'>
              <option value='#wos_group#'<cfif wos_group eq xwos_group>selected</cfif>>#wos_group# - #desp#</option>
            </cfoutput>
          </select>
        </td>
    </tr>
     <tr>
		<cfoutput><td>#getgsetup.lsize# :</td></cfoutput>
        <td colspan='7'>
          <select name='sizeid'>
            <option value=''>-</option>
            <cfoutput query='getsize'>
              <option value='#sizeid#'<cfif sizeid eq xsizeid>selected</cfif>>#sizeid# - #desp#</option>
            </cfoutput>
          </select>
        </td>
    </tr>
    <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th colspan='8'><div align='center'><strong>Product Details</strong></div></th>
    </tr>
    <tr align="left">
        <td nowrap>Unit of Measurement :</td>
        <td colspan='7'>
            <select name='UNIT'>
                <option value=''>-</option>
                <cfoutput query='getUnit'>
                	<option value='#Unit#'<cfif Unit eq xUNIT>selected</cfif>>#Unit# - #desp#</option>
                </cfoutput>
            </select>
        </td>
    </tr>
    <cfoutput>
      <tr>
        <td nowrap>Unit Cost Price :</td>
        <td colspan='7'><input name='UCOST' type='text' value='#NumberFormat(UCOST, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
    </cfoutput>
    <tr>
		<td height='22'>Unit Selling Price :</td>
      	<td colspan='7'>
			<cfinput name='PRICE' type='text' id='PRICE' value='#NumberFormat(PRICE, stDecl_UPrice)#' size='17' maxlength='17'>
		</td>
    </tr>
    <tr>
    <cfif getpin2.h1360 neq 'T'>
    <td height='22'></td>
      <td><cfinput name='PRICE2' type='hidden' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'></td>
	<cfelse>
      <td height='22'>Unit Selling Price 2 :</td>
      <td><cfinput name='PRICE2' type='text' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </cfif>
      </tr>
      <cfoutput>
      <tr>
      <cfif getpin2.h1360 neq 'T'>
      <td nowrap>
            <input name='MURATIO' type='hidden' value='#MURATIO#' size='5' maxlength='5' onKeyUp="calculate_price3('#iDecl_UPrice#');"></td>
        <td><input name='PRICE3' type='hidden' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
	  <cfelse>
        <td nowrap>M.U Ratio :
            <input name='MURATIO' type='text' value='#MURATIO#' size='5' maxlength='5' onKeyUp="calculate_price3('#iDecl_UPrice#');"></td>
        <td><input name='PRICE3' type='text' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
      </tr>
      </cfoutput>
	<tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th colspan='8'><div align='center'><strong>Color</strong></div></th>
    </tr>
	<cfset totcol = 4>
	<cfset totalrecord = 20>
	<cfset totrow = ceiling(totalrecord / totcol)>
	<tr>
		<td colspan="100%">
			<table>
				<cfloop from="1" to="#totrow#" index="i">
				<tr>
					<cfloop from="0" to="#totcol-1#" index="j">
						<cfset thisrecord = i+(j*totrow)>
						<cfif thisrecord LTE totalrecord>
							<cfoutput>
							<td width="10%" align="right">Color #thisrecord#&nbsp;&nbsp;</td>
							<td width="15%">
								<cfif mode eq 'Delete' or mode eq 'Edit'>
									<select name="color#thisrecord#" id="color#thisrecord#">
                						<option value="">-</option>
               							<cfloop query='geticcolor2'>
                							<option value='#colorid2#'<cfif colorid2 eq Evaluate("getitem.color#thisrecord#")>selected</cfif>>#colorid2# - #desp#</option>
                						</cfloop>
            						</select>
								<cfelse>
									<select name="color#thisrecord#" id="color#thisrecord#">
                						<option value="">-</option>
               							<cfloop query='geticcolor2'>
                							<option value='#colorid2#'>#colorid2# - #desp#</option>
                						</cfloop>
            						</select>
								</cfif>
							
							</td>
							</cfoutput>
						</cfif>
					</cfloop>
				</tr>
				</cfloop>
			</table>
		</td>
	</tr>
	
	<tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th colspan='8'><div align='center'><strong>Size</strong></div></th>
    </tr>
	<cfloop from="1" to="#totrow#" index="i">
		<tr>
			<cfloop from="0" to="#totcol-1#" index="j">
				<cfset thisrecord = i+(j*totrow)>
				<cfif thisrecord LTE totalrecord>
					<cfoutput>
						<td width="10%" align="right">Size #thisrecord#&nbsp;&nbsp;</td>
						<td width="15%">
							<cfif mode eq 'Delete' or mode eq 'Edit'>
								<input type="text" value="#Evaluate("getitem.size#thisrecord#")#" size="10" id="size#thisrecord#" name="size#thisrecord#">
							<cfelse>
								<input type="text" value="" size="10" id="size#thisrecord#" name="size#thisrecord#">
							</cfif>
						</td>
					</cfoutput>
				</cfif>
			</cfloop>
		</tr>
	</cfloop>
	<tr>
      <td colspan='8'><hr></td>
    </tr>
	<tr>
		<td colspan="5" align="left">
			&nbsp;<input type="checkbox" name="inserthyphen" checked> Insert ' - ' into Item No.
			&nbsp;<input type="checkbox" name="insertcolorsize" checked> Insert (Color/Size) into Item Description			
		</td>
		<td colspan="3">
			&nbsp;<input type="radio" name="sizecolor" value="SC" <cfif sizecolor eq "SC">checked</cfif>>&nbsp;Size and Color
			&nbsp;<input type="radio" name="sizecolor" value="S" <cfif sizecolor eq "S">checked</cfif>>&nbsp;Size Only
			&nbsp;<input type="radio" name="sizecolor" value="C" <cfif sizecolor eq "C">checked</cfif>>&nbsp;Color Only
		</td>
    </tr>
	<tr>
      <td colspan='8'><hr></td>
    </tr>
	<tr>
		<td colspan="8" align="center">
			<input name='submit' type='submit' value='Edit Opening Quantity'>&nbsp;
			<input name='submit' type='submit' value='Generate Item No'>&nbsp;
			<cfoutput><input name='submit' type='submit' value='#button#'></cfoutput>
		</td>
    </tr>
  </table>
</cfform>
</body>
</html>