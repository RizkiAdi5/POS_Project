<cfquery name="getgeneral" datasource="#dts#">
	select a.compro,a.lastaccyear,concat(',.',repeat('_',b.decl_uprice))as decl_uprice, b.decl_uprice as Decl_UPrice1
	from gsetup as a, gsetup2 as b
</cfquery>

<cfswitch expression="#form.label#">
	<cfcase value="salesqty">
		<cfset stDecl_UPrice = "0">
	</cfcase>
	<cfcase value="salesqtyvalue">
		<cfset stDecl_UPrice = "0">
		<cfset stDecl_UPrice_2 = getgeneral.decl_uprice>
	</cfcase>
	<cfdefaultcase>
		<cfset stDecl_UPrice = getgeneral.decl_uprice>
	</cfdefaultcase>
</cfswitch>

<cfparam name="form.include" default="">
<cfparam name="form.include0" default="">

<cfinvoke component="salesmonth1_2" method="getmonthitem" returnvariable="getitem">
	<cfinvokeargument name = "dts" 			value = "#dts#">
	<cfinvokeargument name = "lastaccyear" 	value = "#getgeneral.lastaccyear#">
	<cfinvokeargument name = "form" 		value = "#form#">
</cfinvoke>

<cfset FinalResult=StructNew()>
<cfset rowId=1>
			
<cfoutput query="getitem" group="itemno">
	<cfset ttotal=0>
	<cfset ttotal2=0>
	<cfset evRow=structnew()>
				
	<cfset structinsert(evRow,"itemno",itemno)>
	<cfset structinsert(evRow,"itemdesp",desp)>
	<cfset structinsert(evRow,"unit",unit)>
	<cfset structinsert(evRow,"total",0)>
	<cfif form.label eq "salesqtyvalue">
		<cfset structinsert(evRow,"total2",0)>
	</cfif>
				
	<cfoutput>
		<cfset amonth="month_"&val(getitem.fperiod)>
		<cfset structinsert(evRow,amonth,getitem.sump)>
		<cfset ttotal=ttotal+val(getitem.sump)>
		<cfif form.label eq "salesqtyvalue">
			<cfset amonth2="month2_"&val(getitem.fperiod)>
			<cfset structinsert(evRow,amonth2,getitem.sump2)>
			<cfset ttotal2=ttotal2+val(getitem.sump2)>
		</cfif>
	</cfoutput>
	<cfset StructUpdate(evRow, "total", ttotal)>
	<cfif form.label eq "salesqtyvalue">
		<cfset StructUpdate(evRow, "total2", ttotal2)>
	</cfif>
	<cfset structinsert(FinalResult,rowId,evRow)>
	<cfset rowId=incrementvalue(rowId)>
</cfoutput>
			
<cfset KeyList=ListSort(StructKeyList(FinalResult),"NUMERIC")> 
<cfset KeyListLen=listlen(KeyList)>
<!--- <cfset columncount=4+(val(form.periodto)-val(form.periodfrom))> --->
<cfif form.label eq "salesqtyvalue">
	<cfset columncount=7+2*(val(form.periodto)-val(form.periodfrom))>
<cfelse>
	<cfset columncount=4+(val(form.periodto)-val(form.periodfrom))>
</cfif>

<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Product Sales By Month Report</title>
		<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		</head>
		<body>
		<table align="center" cellpadding="3" cellspacing="0" width="100%">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Arial,Helvetica,sans-serif"><strong><cfoutput>#trantype#</cfoutput> SALES BY MONTH REPORT <cfif form.include neq "">(Included DN/CN)<cfelse>(Excluded DN/CN)</cfif></strong></font></div></td>
			</tr>
			<cfoutput>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		        <tr>
		          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
		        </tr>
		    </cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		        <tr>
		          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
		        </tr>
		    </cfif>
		    <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		        <tr>
		          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
		        </tr>
		    </cfif>
		    <cfif form.periodfrom neq "" and form.periodto neq "">
		        <tr>
		          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
		        </tr>
		    </cfif>
			<cfset columncount2=columncount-2>
			<tr>
		      	<td colspan="#columncount2#"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></div></td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		    </tr>
			</cfoutput>
			<tr>
		      	<td colspan="100%" height="10"></td>
		    </tr>	    	
			<tr>
			    <td style="border-top:1px solid black;border-bottom:1px solid black;" height="25" <cfif form.label eq "salesqtyvalue">rowspan="2"</cfif>><font size="2" face="Times New Roman, Times, serif">ITEM CODE</font></td>
				<td style="border-top:1px solid black;border-bottom:1px solid black;" <cfif form.label eq "salesqtyvalue">rowspan="2"</cfif>><font size="2" face="Times New Roman, Times, serif">ITEM DESCRIPTION</font></td>
				<cfif form.label eq "salesqty" or form.label eq "salesqtyvalue">
					<td style="border-top:1px solid black;border-bottom:1px solid black;" <cfif form.label eq "salesqtyvalue">rowspan="2"</cfif>><font size="2" face="Times New Roman, Times, serif">UNIT</font></td>
				</cfif>
				<td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;"<cfif form.label eq "salesqtyvalue">colspan="2"</cfif>><div <cfif form.label eq "salesqtyvalue">align="center"<cfelse>align="right"</cfif>><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL</strong></font></div></td>
				<cfloop from="#val(form.periodfrom)#" to="#val(form.periodto)#" index="j">
					<cfoutput><td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;" <cfif form.label eq "salesqtyvalue">colspan="2"</cfif>><div <cfif form.label eq "salesqtyvalue">align="center"<cfelse>align="right"</cfif>><font size="2" face="Times New Roman, Times, serif">#ucase(dateformat(dateadd('m',j,getgeneral.lastaccyear),"mmm yy"))#</font></div></td></cfoutput>	
				</cfloop>
			</tr>
			<cfif form.label eq "salesqtyvalue">
				<tr>
					<td style="border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
					<td style="border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">AMT</font></div></td>
					<cfloop from="#val(form.periodfrom)#" to="#val(form.periodto)#" index="j">
						<td style="border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
						<td style="border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">AMT</font></div></td>
					</cfloop>
				</tr>
			</cfif>			
			<cfoutput>
			<cfloop from="#val(form.periodfrom)#" to="#val(form.periodto)#" index="a">
				<cfset grandmonthtotal[a]=0>
				<cfif form.label eq "salesqtyvalue">	<!--- ADD ON 27-04-2009 --->
					<cfset grandmonthtotal2[a]=0>
				</cfif>
			</cfloop>
			<cfset grandtotal=0>
			<cfif form.label eq "salesqtyvalue">
				<cfset grandtotal2=0>
			</cfif>
			<cfloop from="1" to="#KeyListLen#" index="k">
				<cfset grpKey=listgetat(KeyList,k)>
				<cfset aRow=structfind(FinalResult,grpKey)>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><font size="2" face="Times New Roman, Times, serif">#aRow.itemno#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#aRow.itemdesp#</font></td>
					<cfif form.label eq "salesqty" or form.label eq "salesqtyvalue">
						<td><font size="2" face="Times New Roman, Times, serif">#aRow.unit#</font></td>
					</cfif>
					<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(aRow.total,stDecl_UPrice)#</font></div></td>
					<cfif form.label eq "salesqtyvalue">
						<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(aRow.total2,stDecl_UPrice_2)#</font></div></td>
					</cfif>
					<cfloop from="#val(form.periodfrom)#" to="#val(form.periodto)#" index="a">
						<cfset amonth="month_"&a>
						<cfif StructKeyExists(aRow,amonth)>
							<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(aRow["#amonth#"],stDecl_UPrice)#</font></div></td>
							<cfset grandmonthtotal[a]=grandmonthtotal[a]+val(aRow["#amonth#"])>
						<cfelse>
							<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(0,stDecl_UPrice)#</font></div></td>
						</cfif>
						<cfif form.label eq "salesqtyvalue">
							<cfset amonth2="month2_"&a>
							<cfif StructKeyExists(aRow,amonth2)>
								<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(aRow["#amonth2#"],stDecl_UPrice_2)#</font></div></td>
								<cfset grandmonthtotal2[a]=grandmonthtotal2[a]+val(aRow["#amonth2#"])>
							<cfelse>
								<td style="border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(0,stDecl_UPrice_2)#</font></div></td>
							</cfif>
						</cfif>
					</cfloop>
					<cfset grandtotal=grandtotal+val(aRow.total)>
					<cfif form.label eq "salesqtyvalue">
						<cfset grandtotal2=grandtotal2+val(aRow.total2)>
					</cfif>
				</tr>
				<cfset StructDelete(FinalResult,grpKey)>
			</cfloop>
			<!--- <tr><td height="5"></td></tr> --->
			<tr>
				<cfif form.label eq "salesqty" or form.label eq "salesqtyvalue">
					<td style="border-top:1px solid black;border-bottom:1px solid black;">&nbsp;</td>
				</cfif>
				<td style="border-top:1px solid black;border-bottom:1px solid black;" colspan="2"><font size="2" face="Arial,Helvetica,sans-serif"><div align="right"><b>TOTALS</b></div></font></td>
				<td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(grandtotal,stDecl_UPrice)#</strong></font></div></td>
				<cfif form.label eq "salesqtyvalue">
					<td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(grandtotal2,stDecl_UPrice_2)#</strong></font></div></td>
				</cfif>
				<cfloop from="#val(form.periodfrom)#" to="#val(form.periodto)#" index="j">
					<td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandmonthtotal[j],stDecl_UPrice)#</font></div></td>
					<cfif form.label eq "salesqtyvalue">
						<td style="border-top:1px solid black;border-bottom:1px solid black;border-left:1px solid black;"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grandmonthtotal2[j],stDecl_UPrice_2)#</font></div></td>
					</cfif>	
				</cfloop>
			</tr>
			</cfoutput>
		</table>
		</body>
		</html>
	</cfcase>
	
	<cfcase value="EXCELDEFAULT">
		<cfset iDecl_UPrice=getgeneral.Decl_UPrice1>
		<cfset stDecl_UPrice="">
		<cfset stDecl_UPrice2 = ",.">
		
		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice=stDecl_UPrice&"0">
			<cfset stDecl_UPrice2 = stDecl_UPrice2 & "_">
		</cfloop>
			
		<cfinclude template="salesmonth_21_excel.cfm">
	</cfcase>
</cfswitch>