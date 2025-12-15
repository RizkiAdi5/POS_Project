<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
	<cfquery name="getbatchitem" datasource="#dts#">
		select 
		* 
		from ictran 
		where type='#tran#' 
		and refno = '#nexttranno#' 
		and	itemno='#form.itemno#' 
		and itemcount = '#itemcount#'
		and batchcode<>'';
	</cfquery>
	
	<cfif getbatchitem.recordcount gt 0>
		<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
			<cfset obtype = "bth_qin">
		<cfelse>
			<cfset obtype = "bth_qut">
		</cfif>
		
		<cfif location eq "">
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#-#getbatchitem.qty#) 
				where itemno='#getbatchitem.itemno#' 
				and batchcode='#getbatchitem.batchcode#';
			</cfquery>
		<cfelse>
			<cfquery name="updatelobthob" datasource="#dts#">
				update lobthob set 
				#obtype#=(#obtype#-#getbatchitem.qty#) 
				where location='#location#' 
				and itemno='#getbatchitem.itemno#' 
				and batchcode='#getbatchitem.batchcode#';
			</cfquery>
		
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#-#getbatchitem.qty#) 
				where itemno='#getbatchitem.itemno#' 
				and batchcode='#getbatchitem.batchcode#';
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif lcase(HUserID) neq "kellysteel2">
		<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
		
		<!--- <cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=(#qname#-#qty#) 
			where itemno='#itemno#';
		</cfquery> --->
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=(#qname#-#act_qty#) 
			where itemno='#itemno#';
		</cfquery>
	</cfif>
</cfif>		

<cfquery name="checkexist" datasource="#dts#">
	select * from igrade
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
	and trancode='#itemcount#'
</cfquery>

<cfif checkexist.recordcount neq 0>
	<cfset firstcount = 11>
	<cfset maxcounter = 160>
	<cfset totalrecord = (maxcounter - firstcount + 1)>
	
	<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfloop from="#firstcount#" to="#maxcounter#" index="i">
			<cfif i eq firstcount>
				<cfset grdvaluelist = Evaluate("checkexist.GRD#i#")>
				<cfset bgrdlist = "bgrd"&i>
			<cfelse>
				<cfset grdvaluelist = grdvaluelist&","&Evaluate("checkexist.GRD#i#")>
				<cfset bgrdlist = bgrdlist&",bgrd"&i>
			</cfif>	
		</cfloop>
	
		<cfset myArray = ListToArray(bgrdlist,",")>
		<cfset myArray2 = ListToArray(grdvaluelist,",")>
	
		<!--- <cfquery name="updateitemgrd" datasource="#dts#">
			update itemgrd
			set
			<cfloop from="1" to="#totalrecord#" index="i">
				<cfif i neq totalrecord>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
				<cfelse>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
		</cfquery> --->
		<cfquery name="updateitemgrd" datasource="#dts#">
			update itemgrd
			set
			<cfloop from="1" to="#totalrecord#" index="i">
				<cfif i neq totalrecord>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(checkexist.factor2) neq 0>
						(#myArray2[i]# * #checkexist.factor1# / #checkexist.factor2#)
					<cfelse>
						0
					</cfif>,
				<cfelse>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(checkexist.factor2) neq 0>
						(#myArray2[i]# * #checkexist.factor1# / #checkexist.factor2#)
					<cfelse>
						0
					</cfif>
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
		</cfquery>
	
		
		<!--- <cfquery name="updatelogrdob" datasource="#dts#">
			update logrdob
			set
			<cfloop from="1" to="#totalrecord#" index="i">
				<cfif i neq totalrecord>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
				<cfelse>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.location#">
		</cfquery> --->
		<cfquery name="updatelogrdob" datasource="#dts#">
			update logrdob
			set
			<cfloop from="1" to="#totalrecord#" index="i">
				<cfif i neq totalrecord>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(checkexist.factor2) neq 0>
						(#myArray2[i]# * #checkexist.factor1# / #checkexist.factor2#)
					<cfelse>
						0
					</cfif>,
				<cfelse>
					#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(checkexist.factor2) neq 0>
						(#myArray2[i]# * #checkexist.factor1# / #checkexist.factor2#)
					<cfelse>
						0
					</cfif>
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.location#">
		</cfquery>
		
	</cfif>
	
	<cfquery name="delete" datasource="#dts#">
		delete from igrade
		where type='#tran#' 
		and refno='#nexttranno#' 
		and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
		and trancode='#itemcount#'
	</cfquery>
</cfif>

<cfquery name="deleteserial" datasource="#dts#">
	delete from iserial 
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno='#form.itemno#' 
	and trancode='#itemcount#';
</cfquery>
	
<cfquery name="deleteiclink" datasource="#dts#">
	delete from iclink 
	where type='#tran#'
	and refno='#nexttranno#'
	and itemno='#form.itemno#' 
	and trancode='#itemcount#';
</cfquery>	
<cfif getGeneralInfo.asvoucher eq "Y">
<cfquery name="checkvoucher" datasource="#dts#">
SELECT voucherno FROM ictran 
where itemno='#form.itemno#' 
	and refno='#nexttranno#' 
	and type='#tran#' 
	and itemcount='#itemcount#';
</cfquery>
<cfif checkvoucher.voucherno neq "">
<cfquery name="deletevoucher" datasource="#dts#">
DELETE FROM voucher where voucherid = "#checkvoucher.voucherno#"
</cfquery>
</cfif>
</cfif>
<cfquery name="deleteitem" datasource="#dts#">
	delete from ictran 
	where itemno='#form.itemno#' 
	and refno='#nexttranno#' 
	and type='#tran#' 
	and itemcount='#itemcount#';
</cfquery>

<cfquery name="getLast" datasource="#dts#">
	select 
	itemcount 
	from 
	ictran 
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#' 
	order by itemcount;
</cfquery>

<cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(getLast.itemcount)#"/>

<!--- <cfquery name="deleteserial" datasource="#dts#">
	delete from iserial 
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno='#form.itemno#' 
	and trancode='#itemcount#';
</cfquery>
	
<cfquery name="deleteiclink" datasource="#dts#">
	delete from iclink 
	where type='#tran#'
	and refno='#nexttranno#'
	and itemno='#form.itemno#' 
	and trancode='#itemcount#';
</cfquery>	 --->	

<cfif wpitemtax eq "Y">
	<cfquery name="gettax" datasource="#dts#">
    	select sum(taxamt_bil) as tt_taxamt_bil from ictran where type='#tran#' and refno='#nexttranno#' and (void='' or void is null)
    </cfquery>
	<cfset gettax.tt_taxamt_bil=numberformat(val(gettax.tt_taxamt_bil),".__")>
    <cfquery name="updatetax" datasource="#dts#">
    	update artran set tax_bil='#val(gettax.tt_taxamt_bil)#' where type='#tran#' and refno='#nexttranno#'
    </cfquery>
</cfif>
	
<cfset status = "Item Deleted Successfully">