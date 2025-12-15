ic<cfparam name="status" default="">

<cfset form.photo = form.picture_available>

<cfif form.mode eq "Create">
	<cfquery name="checkitemExist" datasource="#dts#">
 	 	select * from icitem where itemno = '#form.itemno#' 
 	 </cfquery>
	
	<cfif checkitemExist.recordcount gt 0>
		<cfoutput><h3><font color="##FF0000">Error, This Item Number ("#form.itemno#") has been created already.</font></h3></cfoutput>
		<cfabort>
	</cfif>
	
	<cfif isdefined("form.wqformula")>
		<cfset wqformula = form.wqformula>
	<cfelse>
		<cfset wqformula = 0>
	</cfif>
	
	<cfif isdefined("form.wpformula")>
		<cfset wpformula = form.wpformula>
	<cfelse>
		<cfset wpformula = 0>
	</cfif>
	
	<cfif isdefined("form.price_min")>
		<cfset price_min = form.price_min>
	<cfelse>
		<cfset price_min = ''>
	</cfif>
	
	<cfif isdefined("form.wserialno")>
		<cfset wserialno = form.wserialno>
	<cfelse>
		<cfset wserialno = 'F'>
	</cfif>
    
    
        <cfquery name="checkexistbarcode" datasource="#dts#">
            select barcode from icitem where barcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.barcode#">
        </cfquery>
		<cfif checkexistbarcode.recordcount neq 0>
        
        <cfset refnocheck = 0>
        <cfset barcode1 = checkexistbarcode.barcode>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#barcode1#" returnvariable="barcode"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#barcode1#" returnvariable="barcode" />	
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
       	select barcode from icitem where barcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode#">
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset barcode1 = barcode>
		</cfif>
        </cfloop>
        
        </cfif>
    
    
    
	
	<cfquery name="insertitem" datasource="#dts#">
		insert into icitem (itemno,aitemno,desp,despa,comment,brand,category,sizeid,costcode,colorid,wos_group,
		shelf,taxcode, supp,packing,unit,wqformula,wpformula,ucost,price,price2,price3,price4,price5,price6,price_min,minimum,maximum,
		reorder,qty2,qty3,qty4,qty5,qty6,graded,muratio,qtybf,salec,salecsc,salecnc,purc,purprec,wserialno,
		remark1,remark2,remark3,remark4,remark5,remark6,remark7,remark8,remark9,remark10,remark11,remark12,
		remark13,remark14,remark15,remark16,remark17,remark18,remark19,remark20,remark21,remark22,remark23,
		remark24,remark25,remark26,remark27,remark28,remark29,remark30,nonstkitem,wos_date,
		unit2,factor1,factor2,priceu2,costformula,
		<cfloop from="3" to="6" index="i">
		unit#i#,factoru#i#_a,factoru#i#_b,priceu#i#,
		</cfloop>
		photo,created_by,fcurrcode,fucost,fprice,commlvl,itemtype<cfif isdefined('form.custprice_rate')>,custprice_rate</cfif>,barcode)
		
		values ('#itemno#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#aitemno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#desp#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#despa#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#comment#">,'#brand#','#category#','#sizeid#','#costcode#','#colorid#',
		'#wos_group#','#jsstringformat(shelf)#',"#form.taxcode#",'#supp#','#packing#','#unit#','#wqformula#','#wpformula#','#val(ucost)#','#val(price)#','#val(price2)#',
		'#val(price3)#','#val(price4)#','#val(price5)#','#val(price6)#','#val(price_min)#','#val(minimum)#','#val(maximum)#','#val(reorder)#','#val(qty2)#','#val(qty3)#','#val(qty4)#','#val(qty5)#','#val(qty6)#','#graded#',
		'#val(muratio)#','#val(qtybf)#','#salec#','#salecsc#','#salecnc#','#purc#','#purprec#','#wserialno#','#remark1#','#remark2#',
		'#remark3#','#remark4#','#remark5#','#remark6#','#remark7#','#remark8#','#remark9#','#remark10#','#remark11#','#remark12#',
		'#remark13#','#remark14#','#remark15#','#remark16#','#remark17#','#remark18#','#remark19#','#remark20#','#remark21#','#remark22#',
		'#remark23#','#remark24#','#remark25#','#remark26#','#remark27#','#remark28#','#remark29#','#remark30#',
		'<cfif isdefined("form.nonstkitem")>#form.nonstkitem#<cfelse></cfif>','#dateformat(now(),"yyyy-mm-dd")#',
		'#unit2#','#FACTOR1#','#FACTOR2#','#PRICEU2#','#costformula#',
		<cfloop from="3" to="6" index="i">
			'#Evaluate("form.unit#i#")#','#Evaluate("form.factoru#i#_a")#','#Evaluate("form.factoru#i#_b")#','#Evaluate("form.priceu#i#")#',
		</cfloop>
		'#jsstringformat(form.photo)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fcurrcode#">,"#val(form.fucost)#","#val(form.fprice)#",<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comm#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemtype#"><cfif isdefined('form.custprice_rate')>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custprice_rate#"></cfif>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode#">)
	</cfquery>
	
	<cfif graded eq "Y">
		<cfinsert datasource="#dts#" tablename="itemgrd" formfields="itemno">
	</cfif>
	
	<cfif hcomid eq "fincom_i">
		<cfquery name="insert_from_special_item_price" datasource="#dts#">
			insert ignore into special_item_price 
			(
				itemno,
				custno,
				description
			)
			values 
			(
				'#jsstringformat(preservesinglequotes(form.itemno))#',
				'#jsstringformat(preservesinglequotes(form.supp))#',
				'#jsstringformat(preservesinglequotes(form.desp))#'
			)
		</cfquery>
	</cfif>
	
	<cfset status="The Item, #form.itemno# had been successfully created.">
	
<cfelse>
	<cfquery name="checkitemExist" datasource="#dts#">
		select * from icitem where itemno='#form.itemno#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery name="checktranexist" datasource="#dts#">
				select itemno from ictran where itemno = '#form.itemno#'
			</cfquery>
            
            <cfquery name="checktranexist2" datasource="#dts#">
				select sum(locqfield) as qty from locqdbf where itemno = '#form.itemno#'
			</cfquery>
			
			<cfif checktranexist.recordcount gt 0 or checktranexist2.qty gt 0>
				<h3>You have created transaction for this item / There is location quantity for this item. You are not allowed to delete this item.</h3>					
				<cfabort>
			</cfif>
			
			<!--- ADD ON 290908, Delete Grade --->
			<cfquery name="deleteitemgrd" datasource='#dts#'>
				Delete from itemgrd where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
			
			<cfquery name="deletelogrdob" datasource='#dts#'>
				Delete from logrdob where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
			
			<cfquery name="deleterelateditem1" datasource='#dts#'>
				Delete from relitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
			
			<cfquery name="deleterelateditem1" datasource='#dts#'>
				Delete from relitem where relitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
			
			<!--- ADD ON 26-10-2009, KEEP TRACK THE DELETED RECORD --->
			<cfquery name="insert_audittrail" datasource="#dts#">
				insert into deleted_icitem ( 
				  `EDI_ID`,
				  `ITEMNO`,
				  `AITEMNO`,
				  `MITEMNO`,
				  `SHORTCODE`,
				  `DESP`,
				  `DESPA`,
				  `BRAND`,
				  `CATEGORY`,
				  `WOS_GROUP`,
				  `SHELF`,
				  `SUPP`,
				  `PACKING`,
				  `WEIGHT`,
				  `COSTCODE`,
				  `UNIT`,
				  `UCOST`,
				  `PRICE`,
				  `PRICE2`,
				  `PRICE3`,
				  `PRICE_MIN`,
				  `MINIMUM`,
				  `MAXIMUM`,
				  `REORDER`,
				  `UNIT2`,
				  `COLORID`,
				  `SIZEID`,
				  `FACTOR1`,
				  `FACTOR2`,
				  `PRICEU2`,
				  `UNIT3`,
				  `FACTORU3_A`,
				  `FACTORU3_B`,
				  `PRICEU3`,
				  `UNIT4`,
				  `FACTORU4_A`,
				  `FACTORU4_B`,
				  `PRICEU4`,
				  `UNIT5`,
				  `FACTORU5_A`,
				  `FACTORU5_B`,
				  `PRICEU5`,
				  `UNIT6`,
				  `FACTORU6_A`,
				  `FACTORU6_B`,
				  `PRICEU6`,
				  `DISPEC_A1`,
				  `DISPEC_A2`,
				  `DISPEC_A3`,
				  `DISPEC_B1`,
				  `DISPEC_B2`,
				  `DISPEC_B3`,
				  `DISPEC_C1`,
				  `DISPEC_C2`,
				  `DISPEC_C3`,
				  `PRICE_CATA`,
				  `PRICE_CATB`,
				  `PRICE_CATC`,
				  `COST_CATA`,
				  `COST_CATB`,
				  `COST_CATC`,
				  `QTY2`,
				  `QTY3`,
				  `QTY4`,
				  `QTY5`,
				  `QTY6`,
				  `WQFORMULA`,
				  `WPFORMULA`,
				  `GRADED`,
				  `MURATIO`,
				  `QTYBF`,
				  `QTYNET`,
				  `QTYACTUAL`,
				  `AVCOST`,
				  `AVCOST2`,
				  `BOM_COST`,
				  `TQ_OBAL`,
				  `TQ_IN`,
				  `TQ_OUT`,
				  `TQ_CBAL`,
				  `T_UCOST`,
				  `T_STKV`,
				  `TQ_INV`,
				  `TQ_CS`,
				  `TQ_CN`,
				  `TQ_DN`,
				  `TQ_RC`,
				  `TQ_PR`,
				  `TQ_ISS`,
				  `TQ_OAI`,
				  `TQ_OAR`,
				  `TA_INV`,
				  `TA_CS`,
				  `TA_CN`,
				  `TA_DN`,
				  `TA_RC`,
				  `TA_PR`,
				  `TA_ISS`,
				  `TA_OAI`,
				  `TA_OAR`,
				  `QIN11`,
				  `QIN12`,
				  `QIN13`,
				  `QIN14`,
				  `QIN15`,
				  `QIN16`,
				  `QIN17`,
				  `QIN18`,
				  `QIN19`,
				  `QIN20`,
				  `QIN21`,
				  `QIN22`,
				  `QIN23`,
				  `QIN24`,
				  `QIN25`,
				  `QIN26`,
				  `QIN27`,
				  `QIN28`,
				  `QOUT11`,
				  `QOUT12`,
				  `QOUT13`,
				  `QOUT14`,
				  `QOUT15`,
				  `QOUT16`,
				  `QOUT17`,
				  `QOUT18`,
				  `QOUT19`,
				  `QOUT20`,
				  `QOUT21`,
				  `QOUT22`,
				  `QOUT23`,
				  `QOUT24`,
				  `QOUT25`,
				  `QOUT26`,
				  `QOUT27`,
				  `QOUT28`,
				  `SALEC`,
				  `SALECSC`,
				  `SALECNC`,
				  `PURC`,
				  `PURPREC`,
				  `TEMPFIG`,
				  `TEMPFIG1`,
				  `CT_RATING`,
				  `POINT`,
				  `QCPOINT`,
				  `AWARD1`,
				  `AWARD2`,
				  `AWARD3`,
				  `AWARD4`,
				  `AWARD5`,
				  `AWARD6`,
				  `AWARD7`,
				  `AWARD8`,
				  `REMARK1`,
				  `REMARK2`,
				  `REMARK3`,
				  `REMARK4`,
				  `REMARK5`,
				  `REMARK6`,
				  `REMARK7`,
				  `REMARK8`,
				  `REMARK9`,
				  `REMARK10`,
				  `REMARK11`,
				  `REMARK12`,
				  `REMARK13`,
				  `REMARK14`,
				  `REMARK15`,
				  `REMARK16`,
				  `REMARK17`,
				  `REMARK18`,
				  `REMARK19`,
				  `REMARK20`,
				  `REMARK21`,
				  `REMARK22`,
				  `REMARK23`,
				  `REMARK24`,
				  `REMARK25`,
				  `REMARK26`,
				  `REMARK27`,
				  `REMARK28`,
				  `REMARK29`,
				  `REMARK30`,
				  `COMMRATE1`,
				  `COMMRATE2`,
				  `COMMRATE3`,
				  `COMMRATE4`,
				  `WOS_DATE`,
				  `QTYDEC`,
				  `TEMP_QTY`,
				  `QTY`,
				  `PHOTO`,
				  `COMPEC_A`,
				  `COMPEC_B`,
				  `COMPEC_C`,
				  `WOS_TIME`,
				  `EXPIRED`,
				  `WSERIALNO`,
				  `PROMOTOR`,
				  `TAXABLE`,
				  `TAXPERC1`,
				  `TAXPERC2`,
				  `NONSTKITEM`,
				  `GRAPHIC`,
				  `PRODCODE`,
				  `BRK_TO`,
				  `COLOR`,
				  `SIZE`,
				  `qtybf_actual`, 
				  `CREATED_BY`,
				  `CREATED_ON`,
				  `UPDATED_BY`,
				  `UPDATED_ON`,
				  `DELETED_BY`,
				  `DELETED_ON`)
				select 
				  a.EDI_ID,
				  a.ITEMNO,
				  a.AITEMNO,
				  a.MITEMNO,
				  a.SHORTCODE,
				  a.DESP,
				  a.DESPA,
				  a.BRAND,
				  a.CATEGORY,
				  a.WOS_GROUP,
				  a.SHELF,
				  a.SUPP,
				  a.PACKING,
				  a.WEIGHT,
				  a.COSTCODE,
				  a.UNIT,
				  a.UCOST,
				  a.PRICE,
				  a.PRICE2,
				  a.PRICE3,
				  a.PRICE_MIN,
				  a.MINIMUM,
				  a.MAXIMUM,
				  a.REORDER,
				  a.UNIT2,
				  a.COLORID,
				  a.SIZEID,
				  a.FACTOR1,
				  a.FACTOR2,
				  a.PRICEU2,
				  a.UNIT3,
				  a.FACTORU3_A,
				  a.FACTORU3_B,
				  a.PRICEU3,
				  a.UNIT4,
				  a.FACTORU4_A,
				  a.FACTORU4_B,
				  a.PRICEU4,
				  a.UNIT5,
				  a.FACTORU5_A,
				  a.FACTORU5_B,
				  a.PRICEU5,
				  a.UNIT6,
				  a.FACTORU6_A,
				  a.FACTORU6_B,
				  a.PRICEU6,
				  a.DISPEC_A1,
				  a.DISPEC_A2,
				  a.DISPEC_A3,
				  a.DISPEC_B1,
				  a.DISPEC_B2,
				  a.DISPEC_B3,
				  a.DISPEC_C1,
				  a.DISPEC_C2,
				  a.DISPEC_C3,
				  a.PRICE_CATA,
				  a.PRICE_CATB,
				  a.PRICE_CATC,
				  a.COST_CATA,
				  a.COST_CATB,
				  a.COST_CATC,
				  a.QTY2,
				  a.QTY3,
				  a.QTY4,
				  a.QTY5,
				  a.QTY6,
				  a.WQFORMULA,
				  a.WPFORMULA,
				  a.GRADED,
				  a.MURATIO,
				  a.QTYBF,
				  a.QTYNET,
				  a.QTYACTUAL,
				  a.AVCOST,
				  a.AVCOST2,
				  a.BOM_COST,
				  a.TQ_OBAL,
				  a.TQ_IN,
				  a.TQ_OUT,
				  a.TQ_CBAL,
				  a.T_UCOST,
				  a.T_STKV,
				  a.TQ_INV,
				  a.TQ_CS,
				  a.TQ_CN,
				  a.TQ_DN,
				  a.TQ_RC,
				  a.TQ_PR,
				  a.TQ_ISS,
				  a.TQ_OAI,
				  a.TQ_OAR,
				  a.TA_INV,
				  a.TA_CS,
				  a.TA_CN,
				  a.TA_DN,
				  a.TA_RC,
				  a.TA_PR,
				  a.TA_ISS,
				  a.TA_OAI,
				  a.TA_OAR,
				  a.QIN11,
				  a.QIN12,
				  a.QIN13,
				  a.QIN14,
				  a.QIN15,
				  a.QIN16,
				  a.QIN17,
				  a.QIN18,
				  a.QIN19,
				  a.QIN20,
				  a.QIN21,
				  a.QIN22,
				  a.QIN23,
				  a.QIN24,
				  a.QIN25,
				  a.QIN26,
				  a.QIN27,
				  a.QIN28,
				  a.QOUT11,
				  a.QOUT12,
				  a.QOUT13,
				  a.QOUT14,
				  a.QOUT15,
				  a.QOUT16,
				  a.QOUT17,
				  a.QOUT18,
				  a.QOUT19,
				  a.QOUT20,
				  a.QOUT21,
				  a.QOUT22,
				  a.QOUT23,
				  a.QOUT24,
				  a.QOUT25,
				  a.QOUT26,
				  a.QOUT27,
				  a.QOUT28,
				  a.SALEC,
				  a.SALECSC,
				  a.SALECNC,
				  a.PURC,
				  a.PURPREC,
				  a.TEMPFIG,
				  a.TEMPFIG1,
				  a.CT_RATING,
				  a.POINT,
				  a.QCPOINT,
				  a.AWARD1,
				  a.AWARD2,
				  a.AWARD3,
				  a.AWARD4,
				  a.AWARD5,
				  a.AWARD6,
				  a.AWARD7,
				  a.AWARD8,
				  a.REMARK1,
				  a.REMARK2,
				  a.REMARK3,
				  a.REMARK4,
				  a.REMARK5,
				  a.REMARK6,
				  a.REMARK7,
				  a.REMARK8,
				  a.REMARK9,
				  a.REMARK10,
				  a.REMARK11,
				  a.REMARK12,
				  a.REMARK13,
				  a.REMARK14,
				  a.REMARK15,
				  a.REMARK16,
				  a.REMARK17,
				  a.REMARK18,
				  a.REMARK19,
				  a.REMARK20,
				  a.REMARK21,
				  a.REMARK22,
				  a.REMARK23,
				  a.REMARK24,
				  a.REMARK25,
				  a.REMARK26,
				  a.REMARK27,
				  a.REMARK28,
				  a.REMARK29,
				  a.REMARK30,
				  a.COMMRATE1,
				  a.COMMRATE2,
				  a.COMMRATE3,
				  a.COMMRATE4,
				  a.WOS_DATE,
				  a.QTYDEC,
				  a.TEMP_QTY,
				  a.QTY,
				  a.PHOTO,
				  a.COMPEC_A,
				  a.COMPEC_B,
				  a.COMPEC_C,
				  a.WOS_TIME,
				  a.EXPIRED,
				  a.WSERIALNO,
				  a.PROMOTOR,
				  a.TAXABLE,
				  a.TAXPERC1,
				  a.TAXPERC2,
				  a.NONSTKITEM,
				  a.GRAPHIC,
				  a.PRODCODE,
				  a.BRK_TO,
				  a.COLOR,
				  a.SIZE,
				  a.qtybf_actual, 
				  a.CREATED_BY,
				  a.CREATED_ON,
				  a.UPDATED_BY,
				  a.UPDATED_ON,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,now()
				from icitem as a
				where a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
					
			<cfquery name="deleteitem" datasource='#dts#'>
				Delete from icitem where itemno='#form.itemno#'
			</cfquery>
            
            <cfquery name="deleteprice" datasource="#dts#">
            	Delete from icl3p2 where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
            </cfquery>
            
            <cfquery name="deleteprice1" datasource="#dts#">
            	Delete from icl3p where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
            </cfquery>
			
			<cfif hcomid eq "fincom_i">
				<cfquery name="delete_from_special_item_price" datasource="#dts#">
					delete from special_item_price 
					where itemno='#jsstringformat(preservesinglequotes(form.itemno))#';
				</cfquery>
			</cfif>
			
			<cfset status="The Item, #form.itemno# had been successfully deleted. ">	
		</cfif>
				
		<cfif form.mode eq "Edit">
			<cfloop from="3" to="6" index="i">
				<cfif i eq 3>
					<cfset columname = "UNIT"&i&",FACTORU"&i&"_A"&",FACTORU"&i&"_B"&",PRICEU"&i>
				<cfelse>
					<cfset columname = columname&",UNIT"&i&",FACTORU"&i&"_A"&",FACTORU"&i&"_B"&",PRICEU"&i>
				</cfif>
			</cfloop>
			<!--- <cfoutput>#columname#</cfoutput><cfabort> --->
			<!--- <cfupdate datasource='#dts#' tablename="icitem" formfields="edi_id,itemno,aitemno,desp,despa,brand,category,sizeid,
			costcode,colorid,wos_group,shelf,supp,packing,unit,wpformula,wqformula,ucost,price,price2,price3,price_min,minimum,
			maximum,reorder,qty2,qty3,qty4,qty5,qty6,graded,muratio,qtybf,salec,salecsc,salecnc,purc,purprec,wserialno,remark1,
			remark2,remark3,remark4,remark5,remark6,remark7,remark8,remark9,remark10,remark11,remark12,remark13,remark14,remark15,
			remark16,remark17,remark18,remark19,remark20,remark21,remark22,remark23,remark24,remark25,remark26,remark27,remark28,
			remark29,remark30,nonstkitem,photo,unit2,priceu2,factor1,factor2,#columname#"> --->
			<cfquery name="updateicitem" datasource="#dts#">
				UPDATE icitem
				SET aitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aitemno#">,
				desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
				despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
                comment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comment#">,
				brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">,
				category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.category#">,
				sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sizeid#">,
				costcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.costcode#">,
				colorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colorid#">,
				wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.wos_group#">,
				shelf=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.shelf#">,
                taxcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.taxcode#">,
				supp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.supp#">,
				packing=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.packing#">,
				unit=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unit#">,
				wpformula=<cfif isdefined("form.wpformula")>'1'<cfelse>''</cfif>,
				wqformula=<cfif isdefined("form.wqformula")>'1'<cfelse>''</cfif>,
                costformula=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.costformula#">,
				ucost='#val(form.ucost)#',price='#val(form.price)#',price2='#val(form.price2)#',price3='#val(form.price3)#',price4='#val(form.price4)#',price5='#val(form.price5)#',price6='#val(form.price6)#',
				price_min='#val(form.price_min)#',minimum='#val(form.minimum)#',maximum='#val(form.maximum)#',reorder='#val(form.reorder)#',
				qty2='#val(form.qty2)#',qty3='#val(form.qty3)#',qty4='#val(form.qty4)#',qty5='#val(form.qty5)#',qty6='#val(form.qty6)#',
				graded='#form.graded#',
				muratio='#val(form.muratio)#',
				qtybf='#val(form.qtybf)#',
				salec='#form.salec#',
				salecsc='#form.salecsc#',
				salecnc='#form.salecnc#',
				purc='#form.purc#',
				purprec='#form.purprec#',
				wserialno=<cfif isdefined("form.wserialno")>'T'<cfelse>''</cfif>,
				<cfloop from="1" to="30" index="x">
					remark#x#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form["remark#x#"]#">,
				</cfloop>
				nonstkitem=<cfif isdefined("form.nonstkitem")>'T'<cfelse>''</cfif>,
				photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.photo#">,
				factor1='#val(form.factor1)#',factor2='#val(form.factor2)#',
				unit2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unit2#">,priceu2='#val(form.priceu2)#',
				<cfloop from="3" to="6" index="y">
					unit#y#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form["unit#y#"]#">,
					factoru#y#_a='#val(form["factoru#y#_a"])#',
					factoru#y#_b='#val(form["factoru#y#_b"])#',
					priceu#y#='#val(form["priceu#y#"])#',
				</cfloop>
                fcurrcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fcurrcode#">,
                fucost="#form.fucost#",
                fprice="#form.fprice#",
                <cfif isdefined('form.custprice_rate')>custprice_rate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custprice_rate#">,</cfif>
                commlvl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comm#">,
                itemtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemtype#">,
				updated_by=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
				updated_on=now(),
                barcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.barcode#">
				WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
			</cfquery>
			<cfset status="The Item, #form.itemNo# had been successfully edited. ">
			
			<cfif graded eq "Y">
				<cftry>
					<cfinsert datasource="#dts#" tablename="itemgrd" formfields="itemno">
					<cfcatch type="database"></cfcatch>
				</cftry>
			</cfif>
			
			<cfif hcomid eq "fincom_i">
				<cfquery name="edit_special_item_price" datasource="#dts#">
					update special_item_price set 
					custno='#jsstringformat(preservesinglequotes(form.supp))#',
					description='#jsstringformat(preservesinglequotes(form.desp))#'
					where itemno='#jsstringformat(preservesinglequotes(form.itemno))#';
				</cfquery>
			</cfif>
		</cfif>				
	<cfelse>		
		<cfset status="Sorry, the Item, #form.itemNo# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<cfif isdefined("form.relitem") and form.mode neq "Delete">
		<form name="done" action="addrelateditem.cfm?itemno=#form.itemno#" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
	<cfelse>
		<form name="done" action="s_icitem.cfm?type=icitem&process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
	</cfif>
</cfoutput>

<script language="javascript" type="text/javascript">
<cfif isdefined('form.express')>
opener.document.invoicesheet.expressservicelist.value = <cfoutput>'#form.itemno#'</cfoutput>;
opener.document.invoicesheet.expressservicelist.focus();
window.close();

<cfelseif isdefined('form.ovasexpress')>
<cfoutput>window.opener.updateitem('#form.itemno#','#form.desp#');</cfoutput>
</cfif>	
done.submit();
</script>