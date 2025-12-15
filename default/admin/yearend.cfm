
<html>
<head>
<title>Year End Processing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="submit" default="">
<cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<body>
<form action="" method="post" onSubmit="if(confirm('Are you sure want to Year End?')){ColdFusion.Window.show('processing');return true;} else {return false;}">
<H1>Year End Processing <cfoutput>(Year End Period :#getgsetup.period#)</cfoutput></H1>

<h3>Caution: Please make sure that you really want to do year end processing.</h3>
Click this button to do year end processing --><input type="submit" name="submit" value="Year End">
</form>

<cfif submit eq 'Year End'>
<!---
<cfset currentDirectory = "C:\railo\tomcat\webapps\ROOT\BACKUP\"& dts>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset filename=dts&"_"&dateformat(now(),'YYYYMMDD')&"_"&timeformat(now(),'HHMMSS')&"_"&GetAuthUser()&".sql">
<cfset currentdirfile=currentDirectory&"\"&filename>
<cfexecute name = "C:\railo\tomcat\webapps\ROOT\mysqldump"
    arguments = "--host=localhost --user=root --password=#getgsetup.mysqlpass# #dts#" outputfile="#currentdirfile#" timeout="360">
</cfexecute>--->

	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select lastaccyear, year(lastaccyear) as lyear,period from GSetup
	</cfquery>
	<cfset lastaccyear = #dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")#>
	<cfset period = getGeneralInfo.period>
	<!--- BEGIN: Add on 010708, update the qtybf year end. --->
	<cfquery name="create1" datasource="#dts#">
		CREATE TABLE IF NOT EXISTS icitem_last_year LIKE icitem
	</cfquery>
	<cftry>
		<cfquery name="getrecord" datasource="#dts#">
			SELECT qtybf_actual FROM icitem_last_year limit 1
		</cfquery>
		
		<cfcatch type="database">
			<cfquery name="alter1" datasource="#dts#">
				ALTER TABLE icitem_last_year drop PRIMARY KEY
			</cfquery>
			<cfquery name="alter3" datasource="#dts#">
				ALTER TABLE icitem_last_year add entryno int(50) PRIMARY KEY NOT NULL auto_increment;
			</cfquery>
			<cfquery name="alter" datasource="#dts#">
				alter table icitem_last_year 
				add column qtybf_actual varchar(10) after SIZE
			</cfquery>
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfquery name="getrecord" datasource="#dts#">
			SELECT qtybf_actual FROM icitem limit 1
		</cfquery>
		
		<cfcatch type="database">
			<cfquery name="alter" datasource="#dts#">
				alter table icitem 
				add column qtybf_actual varchar(10) after SIZE
			</cfquery>
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfquery name="getrecord" datasource="#dts#">
			SELECT LastAccDate FROM icitem_last_year limit 1
		</cfquery>
		
		<cfcatch type="database">
			<!--- ADD ON 080708 --->
			<cfquery name="alter4" datasource="#dts#">
				ALTER TABLE icitem_last_year ADD COLUMN LastAccDate Date
			</cfquery>
			<cfquery name="alter5" datasource="#dts#">
				ALTER TABLE icitem_last_year ADD COLUMN ThisAccDate Date
			</cfquery>
		</cfcatch>
	</cftry>
	
	<cfquery name="insert" datasource="#dts#">
		INSERT INTO icitem_last_year 
		(`ITEMNO`,`AITEMNO`,`MITEMNO`,`SHORTCODE`,`DESP`,`DESPA`,`BRAND`,`CATEGORY`,
		`WOS_GROUP`,`SHELF`,`SUPP`,`PACKING`,`WEIGHT`,`COSTCODE`,`UNIT`,`UCOST`,`PRICE`,`PRICE2`,
		`PRICE3`,`PRICE_MIN`,`MINIMUM`,`MAXIMUM`,`REORDER`,`UNIT2`,`COLORID`,`SIZEID`,`FACTOR1`,
		`FACTOR2`,`PRICEU2`,`UNIT3`,`FACTORU3_A`,`FACTORU3_B`,`PRICEU3`,`UNIT4`,`FACTORU4_A`,`FACTORU4_B`,
		`PRICEU4`,`UNIT5`,`FACTORU5_A`,`FACTORU5_B`,`PRICEU5`,`UNIT6`,`FACTORU6_A`,`FACTORU6_B`,`PRICEU6`,
		`DISPEC_A1`,`DISPEC_A2`,`DISPEC_A3`,`DISPEC_B1`,`DISPEC_B2`,`DISPEC_B3`,`DISPEC_C1`,`DISPEC_C2`,`DISPEC_C3`,
		`PRICE_CATA`,`PRICE_CATB`,`PRICE_CATC`,`COST_CATA`,`COST_CATB`,`COST_CATC`,`QTY2`,`QTY3`,`QTY4`,`QTY5`,`QTY6`,
		`WQFORMULA`,`WPFORMULA`,`GRADED`,`MURATIO`,`QTYBF`,`QTYNET`,`QTYACTUAL`,`AVCOST`,`AVCOST2`,`BOM_COST`,`TQ_OBAL`,
		`TQ_IN`,`TQ_OUT`,`TQ_CBAL`,`T_UCOST`,`T_STKV`,`TQ_INV`,`TQ_CS`,`TQ_CN`,`TQ_DN`,`TQ_RC`,`TQ_PR`,`TQ_ISS`,`TQ_OAI`,
		`TQ_OAR`,`TA_INV`,`TA_CS`,`TA_CN`,`TA_DN`,`TA_RC`,`TA_PR`,`TA_ISS`,`TA_OAI`,`TA_OAR`,`QIN11`,`QIN12`,`QIN13`,`QIN14`,
		`QIN15`,`QIN16`,`QIN17`,`QIN18`,`QIN19`,`QIN20`,`QIN21`,`QIN22`,`QIN23`,`QIN24`,`QIN25`,`QIN26`,`QIN27`,`QIN28`,`QOUT11`,
		`QOUT12`,`QOUT13`,`QOUT14`,`QOUT15`,`QOUT16`,`QOUT17`,`QOUT18`,`QOUT19`,`QOUT20`,`QOUT21`,`QOUT22`,`QOUT23`,`QOUT24`,`QOUT25`,
		`QOUT26`,`QOUT27`,`QOUT28`,`SALEC`,`SALECSC`,`SALECNC`,`PURC`,`PURPREC`,`TEMPFIG`,`TEMPFIG1`,`CT_RATING`,`POINT`,`QCPOINT`,
		`AWARD1`,`AWARD2`,`AWARD3`,`AWARD4`,`AWARD5`,`AWARD6`,`AWARD7`,`AWARD8`,`REMARK1`,`REMARK2`,`REMARK3`,`REMARK4`,`REMARK5`,
		`REMARK6`,`REMARK7`,`REMARK8`,`REMARK9`,`REMARK10`,`REMARK11`,`REMARK12`,`REMARK13`,`REMARK14`,`REMARK15`,`REMARK16`,`REMARK17`,
		`REMARK18`,`REMARK19`,`REMARK20`,`REMARK21`,`REMARK22`,`REMARK23`,`REMARK24`,`REMARK25`,`REMARK26`,`REMARK27`,`REMARK28`,
		`REMARK29`,`REMARK30`,`COMMRATE1`,`COMMRATE2`,`COMMRATE3`,`COMMRATE4`,`WOS_DATE`,`QTYDEC`,`TEMP_QTY`,`QTY`,`PHOTO`,
		`COMPEC_A`,`COMPEC_B`,`COMPEC_C`,`WOS_TIME`,`EXPIRED`,`WSERIALNO`,`PROMOTOR`,`TAXABLE`,`TAXPERC1`,`TAXPERC2`,`NONSTKITEM`,
		`GRAPHIC`,`PRODCODE`,`BRK_TO`,`COLOR`,`SIZE`,`qtybf_actual`) 
		SELECT `ITEMNO`,`AITEMNO`,`MITEMNO`,`SHORTCODE`,`DESP`,`DESPA`,`BRAND`,`CATEGORY`,
		`WOS_GROUP`,`SHELF`,`SUPP`,`PACKING`,`WEIGHT`,`COSTCODE`,`UNIT`,`UCOST`,`PRICE`,`PRICE2`,
		`PRICE3`,`PRICE_MIN`,`MINIMUM`,`MAXIMUM`,`REORDER`,`UNIT2`,`COLORID`,`SIZEID`,`FACTOR1`,
		`FACTOR2`,`PRICEU2`,`UNIT3`,`FACTORU3_A`,`FACTORU3_B`,`PRICEU3`,`UNIT4`,`FACTORU4_A`,`FACTORU4_B`,
		`PRICEU4`,`UNIT5`,`FACTORU5_A`,`FACTORU5_B`,`PRICEU5`,`UNIT6`,`FACTORU6_A`,`FACTORU6_B`,`PRICEU6`,
		`DISPEC_A1`,`DISPEC_A2`,`DISPEC_A3`,`DISPEC_B1`,`DISPEC_B2`,`DISPEC_B3`,`DISPEC_C1`,`DISPEC_C2`,`DISPEC_C3`,
		`PRICE_CATA`,`PRICE_CATB`,`PRICE_CATC`,`COST_CATA`,`COST_CATB`,`COST_CATC`,`QTY2`,`QTY3`,`QTY4`,`QTY5`,`QTY6`,
		`WQFORMULA`,`WPFORMULA`,`GRADED`,`MURATIO`,`QTYBF`,`QTYNET`,`QTYACTUAL`,`AVCOST`,`AVCOST2`,`BOM_COST`,`TQ_OBAL`,
		`TQ_IN`,`TQ_OUT`,`TQ_CBAL`,`T_UCOST`,`T_STKV`,`TQ_INV`,`TQ_CS`,`TQ_CN`,`TQ_DN`,`TQ_RC`,`TQ_PR`,`TQ_ISS`,`TQ_OAI`,
		`TQ_OAR`,`TA_INV`,`TA_CS`,`TA_CN`,`TA_DN`,`TA_RC`,`TA_PR`,`TA_ISS`,`TA_OAI`,`TA_OAR`,`QIN11`,`QIN12`,`QIN13`,`QIN14`,
		`QIN15`,`QIN16`,`QIN17`,`QIN18`,`QIN19`,`QIN20`,`QIN21`,`QIN22`,`QIN23`,`QIN24`,`QIN25`,`QIN26`,`QIN27`,`QIN28`,`QOUT11`,
		`QOUT12`,`QOUT13`,`QOUT14`,`QOUT15`,`QOUT16`,`QOUT17`,`QOUT18`,`QOUT19`,`QOUT20`,`QOUT21`,`QOUT22`,`QOUT23`,`QOUT24`,`QOUT25`,
		`QOUT26`,`QOUT27`,`QOUT28`,`SALEC`,`SALECSC`,`SALECNC`,`PURC`,`PURPREC`,`TEMPFIG`,`TEMPFIG1`,`CT_RATING`,`POINT`,`QCPOINT`,
		`AWARD1`,`AWARD2`,`AWARD3`,`AWARD4`,`AWARD5`,`AWARD6`,`AWARD7`,`AWARD8`,`REMARK1`,`REMARK2`,`REMARK3`,`REMARK4`,`REMARK5`,
		`REMARK6`,`REMARK7`,`REMARK8`,`REMARK9`,`REMARK10`,`REMARK11`,`REMARK12`,`REMARK13`,`REMARK14`,`REMARK15`,`REMARK16`,`REMARK17`,
		`REMARK18`,`REMARK19`,`REMARK20`,`REMARK21`,`REMARK22`,`REMARK23`,`REMARK24`,`REMARK25`,`REMARK26`,`REMARK27`,`REMARK28`,
		`REMARK29`,`REMARK30`,`COMMRATE1`,`COMMRATE2`,`COMMRATE3`,`COMMRATE4`,`WOS_DATE`,`QTYDEC`,`TEMP_QTY`,`QTY`,`PHOTO`,
		`COMPEC_A`,`COMPEC_B`,`COMPEC_C`,`WOS_TIME`,`EXPIRED`,`WSERIALNO`,`PROMOTOR`,`TAXABLE`,`TAXPERC1`,`TAXPERC2`,`NONSTKITEM`,
		`GRAPHIC`,`PRODCODE`,`BRK_TO`,`COLOR`,`SIZE`,`qtybf_actual` FROM icitem
	</cfquery>
	<cfquery name="update" datasource="#dts#">
		update icitem_last_year set edi_id = #getGeneralInfo.lyear#	
		where edi_id=0 
	</cfquery>
	<!--- <cfquery name="getitem" datasource="#dts#">
		select a.itemno,ifnull(a.qtybf,0) as qtybf,
		ifnull(b.qin,0) as qin,
		ifnull(c.qout,0) as qout,
		ifnull(d.doqty,0) as doqty
		from icitem as a
		
		left join
		(
			select itemno,sum(qty) as qin 
			from ictran 
			where type in ('RC','CN','OAI') 
			and fperiod<>'99' 
			and (void = '' or void is null)  
			group by itemno
		) as b on a.itemno = b.itemno
		
		left join
		(
			select itemno,sum(qty) as qout 
			from ictran 
			where type in ('INV','DN','PR','CS','ISS','OAR')  
			and fperiod<>'99' 
			and (void = '' or void is null) 
			group by itemno
		) as c on a.itemno=c.itemno
		
		left join
		(
			select itemno,sum(qty) as doqty 
			from ictran 
			where type = 'DO' 
			and fperiod<>'99' 
			and (void = '' or void is null) 
			and toinv=''
			group by itemno
		) as d on a.itemno=d.itemno
	</cfquery> --->
	
	<cfquery name="getitem" datasource="#dts#">
		select a.itemno,ifnull(a.qtybf,0) as qtybf,
		ifnull(b.qin,0) as qin,
		ifnull(c.qout,0) as qout,
		ifnull(d.doqty,0) as doqty
		from icitem as a
		
		left join
		(
			select itemno,sum(qty) as qin 
			from ictran 
			where type in (#PreserveSingleQuotes(intrantype)#) 
			and fperiod<>'99' 
			and (void = '' or void is null) 
			and (linecode <> 'SV' or linecode is null)   
			and fperiod+0 <= #period#
			group by itemno
		) as b on a.itemno = b.itemno
		
		left join
		(
			select itemno,sum(qty) as qout 
			from ictran 
			where type in (#PreserveSingleQuotes(outtrantype)#)  
			and fperiod<>'99' 
			and (void = '' or void is null)   
			and (linecode <> 'SV' or linecode is null) 
			and fperiod+0 <= #period# 
			group by itemno
		) as c on a.itemno=c.itemno
		
		left join
		(
			select itemno,sum(qty) as doqty 
			from ictran as a 
			where type = 'INV'
			and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno) 
			and fperiod<>'99' 
			and (void = '' or void is null) 
			and toinv=''  
			and (linecode <> 'SV' or linecode is null)  
			and fperiod+0 <= #period#
			group by itemno
		) as d on a.itemno=d.itemno
	</cfquery>
	
	<cfset endperiod = val(period) + 10>
	<cfloop query="getitem">
		<cfset balonhand = getitem.qtybf + getitem.qin - getitem.qout - getitem.doqty>
		
		<!-- REMARK ON 18-09-2009 --->
		<!--- <cfif val(balonhand) gte 0> --->
			<!--- <cfquery name="updateqtf" datasource="#dts#">
				update icitem set qtybf = '#balonhand#',
				qin11 = 0, qout11 = 0,  
				qin12 = 0, qout12 = 0,  
				qin13 = 0, qout13 = 0,  
				qin14 = 0, qout14 = 0,  
				qin15 = 0, qout15 = 0,  
				qin16 = 0, qout16 = 0,  
				qin17 = 0, qout17 = 0,  
				qin18 = 0, qout18 = 0,  
				qin19 = 0, qout19 = 0,  
				qin20 = 0, qout20 = 0,  
				qin21 = 0, qout21 = 0,  
				qin22 = 0, qout22 = 0,  
				qin23 = 0, qout23 = 0,  
				qin24 = 0, qout24 = 0,  
				qin25 = 0, qout25 = 0,  
				qin26 = 0, qout26 = 0,  
				qin27 = 0, qout27 = 0,  
				qin28 = 0, qout28 = 0
				where itemno = '#getitem.itemno#'
			</cfquery> --->
			
			<cfquery name="updateqtf" datasource="#dts#">
				update icitem set 
				<cfloop index="a" from="11" to="#endperiod#">qin#a# = 0,qout#a# = 0,</cfloop>
				qtybf = '#val(balonhand)#'
				where itemno = '#getitem.itemno#'
			</cfquery>
		<!--- <cfelse> --->
			<!--- <cfquery name="updateqtf" datasource="#dts#">
				update icitem set qtybf=0,
				qtybf_actual='#balonhand#',
				qin11 = 0, qout11 = 0,  
				qin12 = 0, qout12 = 0,  
				qin13 = 0, qout13 = 0,  
				qin14 = 0, qout14 = 0,  
				qin15 = 0, qout15 = 0,  
				qin16 = 0, qout16 = 0,  
				qin17 = 0, qout17 = 0,  
				qin18 = 0, qout18 = 0,  
				qin19 = 0, qout19 = 0,  
				qin20 = 0, qout20 = 0,  
				qin21 = 0, qout21 = 0,  
				qin22 = 0, qout22 = 0,  
				qin23 = 0, qout23 = 0,  
				qin24 = 0, qout24 = 0,  
				qin25 = 0, qout25 = 0,  
				qin26 = 0, qout26 = 0,  
				qin27 = 0, qout27 = 0,  
				qin28 = 0, qout28 = 0
				where itemno = '#getitem.itemno#'
			</cfquery> --->
			
			<!--- <cfquery name="updateqtf" datasource="#dts#">
				update icitem set 
				<cfloop index="a" from="11" to="#endperiod#">qin#a# = 0,qout#a# = 0,</cfloop>
				qtybf=0,
				qtybf_actual='#balonhand#'
				where itemno = '#getitem.itemno#'
			</cfquery>
		
		</cfif> --->
		
		<cfif val(endperiod) lt 28>
			<cfset range = 28 - val(endperiod) - 1>
			
			<!-- MODIFIED ON 09-12-2008 --->
			<!--- <cfquery name="updateqtyinout" datasource="#dts#">
				update icitem set 
				<cfloop index="a" from="1" to="#range#">qin#a+10# = qin#endperiod+a#,qout#a+10# = qout#endperiod+a#,</cfloop>
				qin#range+11# = qin#endperiod+range+1#
				where itemno = '#getitem.itemno#'
			</cfquery> --->
			<cfquery name="updateqtyinout" datasource="#dts#">
				update icitem set 
				<cfloop index="a" from="1" to="#range#">
					qin#a+10# = qin#endperiod+a#,
					qout#a+10# = qout#endperiod+a#,
				</cfloop>
				qin#range+11# = qin#endperiod+range+1#,
				qout#range+11# = qout#endperiod+range+1#
				where itemno = '#getitem.itemno#'
			</cfquery>
			
			<cfquery name="initialize" datasource="#dts#">
				update icitem set 
				<cfloop index="a" from="1" to="#range#">
					qin#endperiod+a# = 0,
					qout#endperiod+a# = 0,
				</cfloop>
				qin#endperiod+range+1# = 0,
				qout#endperiod+range+1# = 0
				where itemno = '#getitem.itemno#'
			</cfquery>
		</cfif>
	</cfloop>
	<!--- END: Add on 010708, update the qtybf year end. --->
	
	
	<!--- <cfset lastaccyear = #dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")#>
	<cfset period = getGeneralInfo.period> --->
	<cftry>
		<cfquery name="checkexist" datasource="#dts#">
			SELECT OPERIOD FROM artran
		</cfquery>
	<cfcatch type="database">
		<cfquery name="alter" datasource="#dts#">
			alter table artran add column OPERIOD varchar(2)
		</cfquery>
		<cfquery name="alter" datasource="#dts#">
			alter table ictran add column OPERIOD varchar(2)
		</cfquery>

	</cfcatch>
	</cftry>
	
	<cftry>
		<cfquery name="checkexist" datasource="#dts#">
			SELECT OPERIOD FROM igrade
		</cfquery>
	<cfcatch type="database">
		<cfquery name="alter" datasource="#dts#">
			alter table igrade add column OPERIOD varchar(2)
		</cfquery>
	</cfcatch>
	</cftry>
	
	<cfquery name="setoperiod1" datasource="#dts#">
		update artran set OPERIOD = fperiod where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setoperiod2" datasource="#dts#">
		update ictran set OPERIOD = fperiod where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setoperiod3" datasource="#dts#">
		update iserial set OPERIOD = fperiod where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setoperiod4" datasource="#dts#">
		update artranat set OPERIOD = fperiod where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setoperiod5" datasource="#dts#">
		update igrade set OPERIOD = fperiod where fperiod+0 <= #period#
	</cfquery>
	
	<cfquery name="setartran" datasource="#dts#">
		update artran set fperiod = '99' where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setictran" datasource="#dts#">
		update ictran set fperiod = '99' where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setiserial" datasource="#dts#">
		update iserial set fperiod = '99' where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setartranat" datasource="#dts#">
		update artranat set fperiod = '99' where fperiod+0 <= #period#
	</cfquery>
	<cfquery name="setigrade" datasource="#dts#">
		update igrade set fperiod = '99' where fperiod+0 <= #period#
	</cfquery>
	
	<!--- new year --->
	
	<cfset clsyear = year(lastaccyear)>	
	<cfset clsmonth = month(lastaccyear)>
	<cfset clsday = day(lastaccyear)>	
	
	<cfset newmonth = clsmonth + period>
	
	<cfif newmonth gt 24>
		<cfset newmonth = newmonth - 24>
		<cfset newyear = clsyear + 2>
	<cfelseif newmonth gt 12>
		<cfset newmonth = newmonth - 12>
		<cfset newyear = clsyear + 1>
	<cfelse>
		<cfset newyear = clsyear>
	</cfif>
	
	<cfset newday = #DaysInMonth(CreateDate(newyear, newmonth, newmonth))#>	
	<cfset newaccyear = newyear&'-'&numberformat(newmonth,"00")&'-'&newday>
	
	<!--- <cfset clsyear = year(lastaccyear)>	
	<cfset clsmonth = month(lastaccyear)>
	<cfset clsday = day(lastaccyear)>	
	
	<cfset newyear = clsyear + 1>
	<cfset newmonth = clsmonth + period - 12>
	<cfset newday = #DaysInMonth(CreateDate(newyear, newmonth, newmonth))#>	
	<cfset newaccyear = newyear&'-'&newmonth&'-'&newday> --->
	
	<cfquery name="updategsetup" datasource="#dts#">
		update gsetup set lastaccyear = '#newaccyear#'
	</cfquery>
	
	<cfquery name="update" datasource="#dts#">
		update icitem_last_year 
		set LastAccDate = #getGeneralInfo.lastaccyear#,
		ThisAccDate = '#newaccyear#'
		where LastAccDate is null
	</cfquery>
	
	<cfif period neq 18>
		<cfset newperiod = 1>
		<cfset nextperiod = period + 1>
		<cfloop condition = "nextperiod lte 18">
			<cfquery name="updateperiod" datasource="#dts#">
				update artran set fperiod = '#numberformat(newperiod,"00")#' where fperiod = '#numberformat(nextperiod,"00")#'
			</cfquery>
			<cfquery name="updateperiod" datasource="#dts#">
				update ictran set fperiod = '#numberformat(newperiod,"00")#' where fperiod = '#numberformat(nextperiod,"00")#'
			</cfquery>
			<cfquery name="updateperiod" datasource="#dts#">
				update iserial set fperiod = '#numberformat(newperiod,"00")#' where fperiod = '#numberformat(nextperiod,"00")#'
			</cfquery>
			<cfquery name="updateperiod" datasource="#dts#">
				update artranat set fperiod = '#numberformat(newperiod,"00")#' where fperiod = '#numberformat(nextperiod,"00")#'
			</cfquery>
			<cfquery name="updateperiod" datasource="#dts#">
				update igrade set fperiod = '#numberformat(newperiod,"00")#' where fperiod = '#numberformat(nextperiod,"00")#'
			</cfquery>						
			<cfset newperiod = newperiod + 1>
			<cfset nextperiod = nextperiod + 1>
		</cfloop>
		
		<!--- <cfquery name="getcurrency" datasource="#dts#">
			select * from currencyrate
		</cfquery> --->
		<cfquery name="getcurrency" datasource="#dts#">
			select * from currency
		</cfquery>
		
		<cfif getcurrency.recordcount gt 0>			
			<cfloop query="getcurrency">
				<cfset newperiod = 1>
				<cfset nextperiod = period + 1>
				<cfloop condition = "nextperiod lte 18">
					<!--- <cfset nextcurrp = "CurrP"&#numberformat(nextperiod,"00")#>
					<cfquery name="getrate" datasource="#dts#">
						select #nextcurrp# as result from currencyrate where currcode = '#getcurrency.currcode#'
					</cfquery>
					<cfquery name="blankcurrency" datasource="#dts#">
						update currencyrate set currp#numberformat(newperiod,"00")# = '#getrate.result#' where currcode = '#getcurrency.currcode#'
					</cfquery>
					<cfquery name="blankcurrency" datasource="#dts#">
						update currencyrate set #nextcurrp# = '0' where currcode = '#getcurrency.currcode#'
					</cfquery> --->
					<cfset nextcurrp = "CURRP"&#nextperiod#>
					<cfquery name="getrate" datasource="#dts#">
						select #nextcurrp# as result from currency where currcode = '#getcurrency.currcode#'
					</cfquery>
					<cfquery name="blankcurrency" datasource="#dts#">
						update currency set CURRP#newperiod# = '#getrate.result#' where currcode = '#getcurrency.currcode#'
					</cfquery>
					<cfquery name="blankcurrency" datasource="#dts#">
						update currency set #nextcurrp# = '1' where currcode = '#getcurrency.currcode#'
					</cfquery>
					<cfset newperiod = newperiod + 1>
					<cfset nextperiod = nextperiod + 1>
				</cfloop>
			</cfloop>			
		</cfif> 
			
	<cfelse>
		<!--- <cfquery name="blankcurrency" datasource="#dts#">
			update currencyrate set currp01 = '',currp02 = '',currp03 = '',currp04='',currp05='',
			currp06='',currp07='',currp08='',currp09='',currp10='',currp11='',currp12='',currp13='',
			currp14='',	currp15='',currp16='',currp17='',currp18=''
		</cfquery> --->
		<cfquery name="blankcurrency" datasource="#dts#">
			update currency set currp1 = '1',currp2 = '1',currp3 = '1',currp4='1',currp5='1',
			currp6='1',currp7='1',currp8='1',currp9='1',currp10='1',currp11='1',currp12='1',currp13='1',
			currp14='1',	currp15='1',currp16='1',currp17='1',currp18='1'
		</cfquery>
	</cfif>
	<h2>You have done the year end processing.</h2>
<script type="text/javascript">
parent.topFrame.location.reload();
</script>
</cfif>
</body>
<cfwindow name="processing" width="300" height="300" initshow="false"  draggable="false" title="Processing....Please Wait" modal="true" resizable="false" >
<h1>Processing....Please Wait</h1>
<img src="/images/loading.gif" align="middle" />
</cfwindow>

</html>
