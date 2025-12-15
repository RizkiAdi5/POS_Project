<cfif url.type1 eq "Edit">
	<cfquery name="checkcustom" datasource="#dts#">
        select customcompany from dealer_menu
    </cfquery>
	<cfif url.multilocation eq "Y" and url.service neq "SV">
		<cfquery datasource="#dts#" name="getitem">
			select 
			sum(qty_bil) as qty_bil,sum(amt1_bil) as amt1_bil,sum(amt_bil) as amt_bil,sum(DISAMT_BIL) as DISAMT_BIL,sum(taxamt_bil) as taxamt_bil,
			itemno,desp,despa,custno,price_bil,packing,unit_bil,brem1,brem2,brem3,brem4,
			shelf,dono,gst_item,dispec1,dispec2,dispec3,taxpec1,gltradac,factor1,factor2,
			linecode,comment,sv_part,sercost,grade,nodisplay,title_id,title_desp<cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">,title_despa</cfif>,
			supp,qty1,qty2,qty3,qty4,qty5,qty6,qty7,note_a,source,job,it_cos,foc<cfif tran eq "INV" and getGeneralInfo.asvoucher eq "Y">,asvoucher,voucherno</cfif>
			from ictran 
			where type='#tran#'
			and refno='#nexttranno#'
			and	itemno='#url.itemno#'
			group by itemno,desp,despa,custno,price_bil,packing,unit_bil,brem1,brem2,brem3,brem4,<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem5,brem6,<cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem7,brem8,brem9,</cfif> </cfif>
			shelf,dono,gst_item,dispec1,dispec2,dispec3,taxpec1,gltradac,factor1,factor2,linecode,
			comment,sv_part,sercost,grade,nodisplay,title_id,title_desp,supp,qty1,qty2,qty3,qty4,qty5,qty6,qty7,note_a,source,job
		</cfquery>
		
		<cfquery name="geticlocation" datasource="#dts#">
			select a.location,ifnull(b.qty,0) as oldqtybyloc,ifnull(b.qty_bil,0) as qtybyloc,
			ifnull(b.batchcode,'') as batchcode,ifnull(b.dodate,'') as dodate,ifnull(b.sodate,'') as sodate,
			ifnull(b.mc1_bil,'') as mc1_bil,ifnull(b.mc2_bil,'') as mc2_bil,ifnull(b.defective,'') as defective,ifnull(b.expdate,'') as expdate,b.milcert,b.importpermit
			from iclocation as a			
			left join
			(
				select qty,qty_bil,batchcode,dodate,sodate,mc1_bil,mc2_bil,defective,expdate,location,milcert,importpermit from ictran
				where type='#tran#'
				and refno='#nexttranno#'
				and	itemno='#url.itemno#' 
			)as b on a.location = b.location
			order by a.location
		</cfquery>
		<cfset locationlist = valuelist(geticlocation.location,";")>
		<cfset qtylist = valuelist(geticlocation.qtybyloc,";")>
		<cfset oldqtylist = valuelist(geticlocation.oldqtybyloc,";")>
		<cfset batchlist = "">
		<cfset oldbatchlist = "">
		<cfset mc1billist = "">
		<cfset mc2billist = "">
		<cfset sodatelist = "">
		<cfset dodatelist = "">
		<cfset expdatelist = "">
        <cfset milcertlist = "">
        <cfset importpermitlist = "">
		<cfset defectivelist = "">
		
		<cfloop query="geticlocation">
			<cfif geticlocation.currentrow eq 1>
				<cfif geticlocation.batchcode neq "">
					<cfset batchlist = geticlocation.batchcode>
				<cfelse>
					<cfset batchlist = " ">
				</cfif>	
				<cfif geticlocation.batchcode neq "">
					<cfset oldbatchlist = geticlocation.batchcode>
				<cfelse>
					<cfset oldbatchlist = " ">
				</cfif>
				<cfif geticlocation.mc1_bil neq "">
					<cfset mc1billist = geticlocation.mc1_bil>
				<cfelse>
					<cfset mc1billist = " ">
				</cfif>
                <cfif geticlocation.milcert neq "">
					<cfset milcertlist = geticlocation.milcert>
				<cfelse>
					<cfset milcertlist = " ">
				</cfif>
                <cfif geticlocation.importpermit neq "">
					<cfset importpermitlist = geticlocation.importpermit>
				<cfelse>
					<cfset importpermitlist = " ">
				</cfif>
				<cfif geticlocation.mc2_bil neq "">
					<cfset mc2billist = geticlocation.mc2_bil>
				<cfelse>
					<cfset mc2billist = " ">
				</cfif>
				<cfif geticlocation.sodate neq "0000-00-00" and geticlocation.sodate neq "">
					<cfset sodatelist = dateformat(geticlocation.sodate,"dd-mm-yyyy")>
				<cfelse>
					<cfset sodatelist = " ">
				</cfif>
				<cfif geticlocation.dodate neq "0000-00-00" and geticlocation.dodate neq "">
					<cfset dodatelist = dateformat(geticlocation.dodate,"dd-mm-yyyy")>
				<cfelse>
					<cfset dodatelist = " ">
				</cfif>
				<cfif geticlocation.expdate neq "0000-00-00" and geticlocation.expdate neq "">
					<cfset expdatelist = dateformat(geticlocation.expdate,"dd-mm-yyyy")>
				<cfelse>
					<cfset expdatelist = " ">
				</cfif>
				<cfif geticlocation.defective neq "">
					<cfset defectivelist = geticlocation.defective>
				<cfelse>
					<cfset defectivelist = " ">
				</cfif>				
			<cfelse>
				<cfif geticlocation.batchcode neq "">
					<cfset batchlist = batchlist&";"&geticlocation.batchcode>
				<cfelse>
					<cfset batchlist = batchlist&"; ">
				</cfif>
                <cfif geticlocation.milcert neq "">
					<cfset milcertlist = milcertlist&";"&geticlocation.milcert>
				<cfelse>
					<cfset milcertlist = milcertlist&"; ">
				</cfif>
                <cfif geticlocation.importpermit neq "">
					<cfset importpermitlist = importpermitlist&";"&geticlocation.importpermit>
				<cfelse>
					<cfset importpermitlist = importpermitlist&"; ">
				</cfif>
				<cfif geticlocation.batchcode neq "">
					<cfset oldbatchlist = oldbatchlist&";"&geticlocation.batchcode>
				<cfelse>
					<cfset oldbatchlist = oldbatchlist&"; ">
				</cfif>
				<cfif geticlocation.mc1_bil neq "">
					<cfset mc1billist = mc1billist&";"&geticlocation.mc1_bil>
				<cfelse>
					<cfset mc1billist = mc1billist&"; ">
				</cfif>
				<cfif geticlocation.mc2_bil neq "">
					<cfset mc2billist = mc2billist&";"&geticlocation.mc2_bil>
				<cfelse>
					<cfset mc2billist = mc2billist&"; ">
				</cfif>
				<cfif geticlocation.sodate neq "0000-00-00" and geticlocation.sodate neq "">
					<cfset sodatelist = sodatelist&";"&dateformat(geticlocation.sodate,"dd-mm-yyyy")>
				<cfelse>
					<cfset sodatelist = sodatelist&"; ">
				</cfif>
				<cfif geticlocation.dodate neq "0000-00-00" and geticlocation.dodate neq "">
					<cfset dodatelist = dodatelist&";"&dateformat(geticlocation.dodate,"dd-mm-yyyy")>
				<cfelse>
					<cfset dodatelist = dodatelist&"; ">
				</cfif>
				<cfif geticlocation.expdate neq "0000-00-00" and geticlocation.expdate neq "">
					<cfset expdatelist = expdatelist&";"&dateformat(geticlocation.expdate,"dd-mm-yyyy")>
				<cfelse>
					<cfset expdatelist = expdatelist&"; ">
				</cfif>
				<cfif geticlocation.defective neq "">
					<cfset defectivelist = defectivelist&";"&geticlocation.defective>
				<cfelse>
					<cfset defectivelist = defectivelist&"; ">
				</cfif>								
			</cfif>
		</cfloop>
		<cfset xlocation = "">
	<cfelse>
		<cfquery datasource="#dts#" name="getitem">
			select 
			* 
			from ictran 
			where type='#tran#'
			and refno='#nexttranno#'
			and	itemno='#url.itemno#'  
			and itemcount='#itemcount#';
		</cfquery>
		
		<cfif isdefined("location")>
			<cfset xlocation = location>
		<cfelse>
			<cfset xlocation = getitem.location>
		</cfif>
	</cfif>

	<!--- <cfquery datasource="#dts#" name="getpricehis">
		select 
		wos_date,
		price,
		dispec1,
		dispec2,
		dispec3 
		from ictran 
		where itemno='#url.itemno#' 
		and custno='#getitem.custno#' 
		order by wos_date desc limit 3;
	</cfquery> --->
    <cfif getGeneralInfo.histpriceinv eq 'Y'>
    <cfif tran eq 'PO' or tran eq 'RC' or tran eq 'PR'>
    <cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.custno#"> 
        and type = 'RC'
		order by wos_date desc limit 5;
	</cfquery>
    <cfelse>
    <cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.custno#"> 
        and type = 'INV'
		order by wos_date desc limit 5;
	</cfquery>
    </cfif>
    <cfelse>
	<cfquery name="getpricehis" datasource="#dts#">
		select 
		refno,wos_date,price,dispec1,dispec2,dispec3,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.custno#"> 
		order by wos_date desc limit 5;
	</cfquery>
    </cfif>

	<cfquery name="getitembal" datasource="#dts#">
		select 
		qtybf,
		minimum,
		graded,
		remark1,wpformula,wqformula 
		from icitem 
		where itemno='#url.itemno#';
	</cfquery>

	<cfset itemno = url.itemno>
	<cfset desp = getitem.desp>
	<cfset despa = getitem.despa>
	
	<!--- Remark On 27-11-2008 --->
	<!--- <cfif url.multilocation neq "Y">
		<cfif isdefined("location")>
			<cfset xlocation = location>
		<cfelse>
			<cfset xlocation = getitem.location>
		</cfif>
	<cfelse>
		<cfset xlocation = "">
	</cfif> --->
	

	<!--- <cfset qty = getitem.qty> --->	<!--- Remark on 290908 and Replace with the Below One. --->
	<cfset qty = getitem.qty_bil>
	<cfset price = getitem.price_bil>
	<cfset amt = getitem.amt1_bil>		<!--- ADD ON 090608, SHOW THE PRODUCT'S AMOUNT IN THE BODY PART (FORM) --->
    <cfset foc = getitem.foc>
	<cfset packing = getitem.packing>	<!--- Add On 270608, For Avent_i To Show The No Of Package --->
	<!--- <cfset unit = getitem.unit> --->	<!--- Remark on 290908 and Replace with the Below One. --->
	<cfset unit = getitem.unit_bil>
	<cfset Brem1 = getitem.brem1>
	<cfset Brem2 = getitem.brem2>
	<cfset Brem3 = getitem.BREM3>
	<cfset Brem4 = getitem.BREM4>
    <cfset it_cos = getitem.it_cos>
	<cfif lcase(hcomid) eq "avent_i" or  lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
		<cfset Brem5 = getitem.BREM5>	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
		<cfset Brem6 = getitem.BREM6>	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
    <cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
    	<cfset Brem7 = getitem.BREM7>
        <cfset Brem8 = getitem.BREM8>
        <cfset Brem9 = getitem.BREM9>
	</cfif>
	</cfif>
	<cfif checkcustom.customcompany eq "Y">
		<cfset Brem5 = getitem.BREM5>	<!--- ADD ON 30-03-2009, FOR PERMIT NO --->
		<cfset Brem7 = getitem.BREM7>	<!--- PERMIT NO (RM) IN --->
		<cfset Brem8 = getitem.BREM8>	<!--- PERMIT NO (DP) OUT --->
		<cfset Brem9 = getitem.BREM9>	<!--- PERMIT NO (OO) OUT --->
		<cfset Brem10 = getitem.BREM10>	<!--- PERMIT NO (RM) OUT --->
	</cfif>
	<cfset shelf = getitem.shelf>	<!--- Add on 090908 --->
	<cfset dono = getitem.dono>
	<cfset gst_item = getitem.gst_item>
	<cfset dispec1 = getitem.dispec1>
	<cfset dispec2 = getitem.dispec2>
	<cfset dispec3 = getitem.dispec3>
	<cfset taxpec1 = getitem.taxpec1>
    <cfset taxamt_bil= getitem.taxamt_bil>	<!--- ADD ON 30-07-2009 --->
	<cfset gltradac = getitem.gltradac>
	<!--- ADD ON 260908, FOR 2ND UNIT --->
	<cfset factor1 = getitem.factor1>
	<cfset factor2 = getitem.factor2>
	<cfset nodisplay = getitem.nodisplay>		<!--- ADD ON 01-12-2008, FOR NOT DISPAY ITEM IN BILL --->
    <cfif tran eq "INV" and getGeneralInfo.asvoucher eq "Y">
    <cfset asvoucher = getitem.asvoucher>
    <cfquery name="getvoucher" datasource="#dts#">
    SELECT voucherno FROM voucher where voucherid = "#getitem.voucherno#"
    </cfquery>
    <cfif getvoucher.voucherno eq "">
    <cfquery name="getlastvoucherno" datasource="#dts#">
    select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.custno#">
    </cfquery>
    <cfif getlastvoucherno.voucherno neq "">
    <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
    <cfset voucherno = newvoucherno>
    <cfelse>
    <cfset voucherno = right(getitem.custno,3)&"000001">
	</cfif>
	<cfelse>
    <cfset voucherno = getvoucher.voucherno>
	</cfif>
	</cfif>
	<cfset title = getitem.title_id>			<!--- ADD ON 25-02-2009, FOR ITEM TITLE --->
	<cfset titledesp=getitem.title_desp>		<!--- ADD ON 26-02-2009, FOR ITEM TITLE --->
    <cfif isdefined('getitem.ictranfilename')>
    <cfset ictranfilename = getitem.ictranfilename>
    </cfif>
	<cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">	<!--- ADD ON 21-04-2009 --->
		<cfset titledespa=getitem.title_despa>
	</cfif>
    <cfset supp=getitem.supp>		<!--- ADD ON 24-05-2009 --->
	
	<!--- ADD ON 05-06-2009 --->
	<cfset qty1=getitem.qty1>
	<cfset qty2=getitem.qty2>
	<cfset qty3=getitem.qty3>
	<cfset qty4=getitem.qty4>
	<cfset qty5=getitem.qty5>
	<cfset qty6=getitem.qty6>
	<cfset qty7=getitem.qty7>
    <cfset xnote_a=getitem.note_a>
	
	<!--- ADD ON 10-12-2009 --->
	<cfset xsource=getitem.source>
	<cfset xjob=getitem.job>
	
	<cfset remark1 = getitembal.remark1>	<!--- ADD ON 10-02-2009 --->
	<cfif getitem.linecode eq "SV">
		<cfset graded = "">
		<cfset is_service = 1>	<!--- ADD ON 190908, WANT TO KNOW THE TYPE: SERVICE/PRODUCT --->
		<cfset wpformula="">	<!--- ADD ON 05-06-2009 --->
		<cfset wqformula="">
	<cfelse>
		<cfset graded = getitembal.graded>
		<cfset is_service = 0>	<!--- ADD ON 190908, WANT TO KNOW THE TYPE: SERVICE/PRODUCT --->
		<cfset wpformula=getitembal.wpformula>	<!--- ADD ON 05-06-2009 --->
		<cfset wqformula=getitembal.wqformula>
	</cfif>
	
	<!--- ADD ON 20-11-2008, SET THE GRADED ITEM VALUE --->
	<cfset firstcount = 11>
	<cfset maxcounter = 70>
	<cfset totalrecord = (maxcounter - firstcount + 1)>
	<cfif url.multilocation neq "Y">
		<cfquery name="getigrade" datasource="#dts#">
			select * from igrade 
    		where type = <cfqueryparam cfsqltype="cf_sql_char" value="#getitem.type#">
    		and refno = <cfqueryparam cfsqltype="cf_sql_char" value="#getitem.refno#">
    		and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">
			and trancode = <cfqueryparam cfsqltype="cf_sql_char" value="#getitem.trancode#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#getitem.location#">
		</cfquery>
		<cfif getigrade.recordcount neq 0>
			<cfloop from="#firstcount#" to="#maxcounter#" index="i">
				<cfif i eq firstcount>
					<cfset grdvaluelist = Evaluate("getigrade.GRD#i#")>
					<cfset oldgrdvaluelist = Evaluate("getigrade.GRD#i#")>
					<cfset grdcolumnlist = "grd"&i>
					<cfset bgrdcolumnlist = "bgrd"&i>
				<cfelse>
					<cfset grdvaluelist = grdvaluelist&","&Evaluate("getigrade.GRD#i#")>
					<cfset oldgrdvaluelist = oldgrdvaluelist&","&Evaluate("getigrade.GRD#i#")>
					<cfset grdcolumnlist = grdcolumnlist&",grd"&i>
					<cfset bgrdcolumnlist = bgrdcolumnlist&",bgrd"&i>
				</cfif>	
			</cfloop>
		<cfelse>
			<cfset grdcolumnlist = "">
			<cfset grdvaluelist = "">
			<cfset bgrdcolumnlist = "">
			<cfset oldgrdvaluelist = "">
		</cfif>
	<cfelse>
		<cfset grdcolumnlist = "">
		<cfset grdvaluelist = "">
		<cfset bgrdcolumnlist = "">
		<cfset oldgrdvaluelist = "">
	</cfif>
	<cfif isdefined("url.code")>
		<cfquery name="getcomment" datasource="#dts#">
			select 
			* 
			from comments 
			where code = '#url.code#';
		</cfquery>

		<cfquery name="gettempcomment" datasource="#dts#">
			select 
			comment 
			from commentemp 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno='#itemno#' 
			and userid='#huserid#';
		</cfquery>

		<cfif tostring(gettempcomment.comment) eq "">
			<cfset comment = ToString(getcomment.details)>
		<cfelse>
			<cfset comment = tostring(gettempcomment.comment)&chr(13)&chr(13)&ToString(getcomment.details)>
		</cfif>

		<cfquery name="deltempcomment" datasource="#dts#">
			delete from commentemp 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno='#itemno#' 
			and userid='#huserid#';
		</cfquery>
	<cfelse>
		<cfif isdefined("form.comment")>
			<cfset comment = form.comment>
		<cfelse>
			<cfset comment = ToString(getitem.comment)>
		</cfif>
	</cfif>
	
	 <!--- ADD ON 230908 --->
    <!--- <cfif lcase(hcomid) eq "ecraft_i">
		<cfquery name="getarrival" datasource="#dts#">
        	select * from ictran
            where itemno = '#url.itemno#' 
            and type = 'PO'
            and fperiod <> '99' 
            order by wos_date desc 
            limit 1
        </cfquery>
        <cfif getarrival.recordcount neq 0 and getarrival.wos_date neq "">
			<cfset arrivaldate = dateformat(getarrival.wos_date,"dd/mm/yyyy")>
		<cfelse>
        	<cfset arrivaldate = "-">
		</cfif>
	</cfif> --->
	<!--- Modified on 17-11-2008 --->
	<cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and (tran eq "INV" or tran eq "CS" or tran eq "DO")>
		<cfquery name="getarrival" datasource="#dts#">
        	select a.rem9 from artran a,ictran b
            where a.type = b.type and a.refno = b.refno 
			and b.itemno = '#itemno#'
            and a.type = 'PO'
            and a.fperiod <> '99'
            order by a.rem9 desc 
            limit 1
        </cfquery>
        <cfif getarrival.recordcount neq 0 and getarrival.rem9 neq "">
			<cfset arrivaldate = dateformat(getarrival.rem9,"dd/mm/yyyy")>
		<cfelse>
        	<cfset arrivaldate = "-">
		</cfif>
	</cfif>
	<cfset discamt = getitem.DISAMT_BIL>
	
	<cfset xsv_part = getitem.sv_part>
	<cfset sercost = getitem.sercost>
	<cfset mode = "Edit">
	<cfset button = "Edit">
</cfif>