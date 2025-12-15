        <cfquery name="getgsetup" datasource="#dts#">
        select ddllocation from gsetup
        </cfquery>
        <cfquery name="getdeposit" datasource="#dts#">
      	select (cs_pm_cash+cs_pm_cheq+cs_pm_crcd+cs_pm_crc2+cs_pm_dbcd+cs_pm_vouc+cs_pm_cashcd) as deposit from deposit where depositno = '#url.reserveno#'
		</cfquery>
        
<cfinvoke component="cfc.Period" method="getCurrentPeriod" dts="#dts#" inputDate="#dateformat(now(),'yyyy-mm-dd')#" returnvariable="fperiod"/>
        
        <cfquery name="checkexistrefno" datasource="#dts#">
        select max(refno) as refno from artran where type='CS'
        </cfquery>
        
        <cfquery datasource="#dts#" name="getGeneralInfo">
				select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                from refnoset
				where type = 'CS'
				and counter = 1
			</cfquery>
        <cfset refnocheck = 0>
        <cfset refno1 = checkexistrefno.refno>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#refno1#" returnvariable="refno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#refno1#" returnvariable="refno" />	
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE 
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#"> and type = 'CS'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset refno1 = refno>
		</cfif>
        </cfloop>


<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,rem30,rem31,rem32)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="CS">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="3000/CS1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(now(),'yyyy-mm-dd')#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(-getdeposit.deposit)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
'#val(-getdeposit.deposit)#',
'0',
'0',
'0',
'0',
'0',
'0',
'0',
'',
'0',
'',
"",
'',
'',
'',
'',
'0',
'0',
'0',
"",
"",
'',
'',
'',
''
)
</cfquery>


<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran 

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, LOCATION,QTY_BIL, PRICE_BIL, AMT1_BIL, AMT_BIL, NOTE_A, QTY, PRICE, AMT1, AMT,FACTOR1,FACTOR2, TRDATETIME)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="CS">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="3000/CS1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(now(),'yyyy-mm-dd')#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Return deposit for Reserve #url.reserveno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getgsetup.ddllocation#">,
'1',
#val(-getdeposit.deposit)#,
#val(-getdeposit.deposit)#,
#val(-getdeposit.deposit)#,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
'1',
#val(-getdeposit.deposit)#,
#val(-getdeposit.deposit)#,
#val(-getdeposit.deposit)#,
'1',
'1',
now()

)
</cfquery>

<cfquery name="recalculateictran" datasource="#dts#">
Update reserve set status='Cancel' where reserveno='#url.reserveno#'
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
Update reservedet set status='Cancel' where reserveno='#url.reserveno#'
</cfquery>

<cfquery name="deletereserve" datasource="#dts#">
       update deposit set billno='Void' where depositno = '#url.reserveno#'
</cfquery>


<script type="text/javascript">
    alert('Order Cancelled');
	<cfoutput>
	window.location.href="/billformat/#dts#/preprintedformat.cfm?tran=CS&nexttranno=#refno#&billname=receipt_non_editable&dotion=0";
	window.opener.location="s_Reservetable.cfm?type=icReserve.cfm";
</cfoutput>
</script>
