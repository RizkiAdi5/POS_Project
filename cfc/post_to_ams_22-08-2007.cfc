<cfcomponent>
	<cfscript>
		function resultSetToQuery1(rs)
		{
			var rsmd = rs.getMetaData();
			var columnCount = rsmd.getColumnCount() - 1;
			var lastcol = rsmd.getColumnCount();
			var rowCount = 0;
			var totalrow = 0;
			var i = 1;
			var q = '';

			q = q&('
			insert into glpost 
			(			acc_code,	accno,		fperiod,	date,		batchno,	tranno,		vouc_seq,	vouc_seq_2,	ttype,
			reference,	refno,		desp,		despa,		despb,		despc,		despd,		despe,		taxpec,		debitamt,
			creditamt,	fcamt,		debit_fc,	credit_fc,	exc_rate,	araptype,	age,		source,		job,		job2,
			subjob,		job_value,	job2_value,	posted,		exported,	exported1,	exported2,	exported3,	rem1,		rem2,
			rem3,		rem4,		rem5,		rpt_row,	agent,		stran,		taxpur,		paymode,	trdatetime,	corr_acc,
			accno2,		accno3,		date2,		userid,		tcurrcode,	tcurramt,	bperiod,	bdate,		vperiod) 	
			value ');
					
			while(rs.next()) 
			{
				rowCount = rowCount + 1;
				totalrow = rs.getObject(javaCast('int',lastcol));
				q = q & '(';
				
				for(i = 1; i lte columnCount; i = i + 1) 
				{
					q = q & "'" & jsstringformat(rs.getObject(javaCast('int',i))) & "'";
					if(i lt columnCount)
					{
						q = q & ',';
					}
				}
				
				if(rowCount eq totalrow)
				{
					q = q & ") on duplicate key update entry=''";
				}
				else
				{
					q = q & '),';
				}
			}
			return q;
		}
		function resultSetToQuery2(rs) 
		{
			var rsmd = rs.getMetaData();
			var columnCount = rsmd.getColumnCount() - 1;
			var lastcol = rsmd.getColumnCount();
			var rowCount = 0;
			var totalrow = 0;
			var i = 1;
			var q = '';

			q = q & ('
			insert into arpost 
			(			accno,		date,
			araptype,	reference,	refno,		debitamt,	creditamt,	desp,	despa,	despb,	despc,	despd,
			fcamt,		debit_lc,	credit_lc,	exc_rate,	age,		posted,	rem1,	rem2,	rem4,	source,
			job,		agent,		stran,		fperiod,	batchno,	tranno)
			value ');
					
			while(rs.next()) 
			{
				rowCount = rowCount + 1;
				totalrow = rs.getObject(javaCast('int',lastcol));
				q = q & '(';
				
				for(i = 1; i lte columnCount; i = i + 1) 
				{
					q = q & "'" & jsstringformat(rs.getObject(javaCast('int',i))) & "'";
					if(i lt columnCount)
					{
						q = q & ',';
					}
				}

				if(rowCount eq totalrow)
				{
					q = q & ") on duplicate key update entry=''";
				}
				else
				{
					q = q &'),';
				}
			}
			return q;
		}
		function resultSetToQuery3(rs) 
		{
			var rsmd = rs.getMetaData();
			var columnCount = rsmd.getColumnCount() - 1;
			var lastcol = rsmd.getColumnCount();
			var rowCount = 0;
			var totalrow = 0;
			var i = 1;
			var q = '';

			q = q & ('
			insert into appost 
			(			accno,		date,
			araptype,	reference,	refno,		debitamt,	creditamt,	desp,	despa,	despb,	despc,	despd,
			fcamt,		debit_lc,	credit_lc,	exc_rate,	age,		posted,	rem1,	rem2,	rem4,	source,
			job,		agent,		stran,		fperiod,	batchno,	tranno)
			value ');
					
			while(rs.next()) 
			{
				rowCount = rowCount + 1;
				totalrow = rs.getObject(javaCast('int',lastcol));
				q = q & '(';
				
				for(i = 1; i lte columnCount; i = i + 1) 
				{
					q = q & "'" & jsstringformat(rs.getObject(javaCast('int',i))) & "'";
					if(i lt columnCount)
					{
						q = q&',';
					}
				}
				
				if(rowCount eq totalrow)
				{
					q = q & ") on duplicate key update entry=''";
				}
				else
				{
					q = q & '),';
				}
			}
			return q;
		}
	</cfscript>

	<cffunction name="posting_to_ams_method">
		<cfargument name="dts" required="yes">
		<cfargument name="dts1" required="yes">
		<cfargument name="target_arcust" required="yes">
		<cfargument name="target_apvend" required="yes">
		<cfargument name="form" required="yes" type="struct">
		
		<cfinvoke component="cfc.link_ams_info" method="getamslinkinfo" returnvariable="getlinkresult"></cfinvoke>
		
		<cftry>
			<cfquery name="getdata_from_glpost91_glpost" datasource="#arguments.dts#">
				select 
							acc_code,	accno,		fperiod,	concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				batchno,	tranno,		vouc_seq,	vouc_seq2,	ttype,		reference,	refno,		desp,		despa,		despb,
				despc,		despd,		despe,		taxpec,		debitamt,	creditamt,	fcamt,		debit_fc,	credit_fc,	exc_rate,
				araptype,	age,		source,		job,		job2,		subjob,		job_value,	job_value2,	posted,		exported,
				exported1,	exported2,	exported3,	rem1,		rem2,		rem3,		rem4,		rem5,		rpt_row,	agent,
				stran,		taxpur,		paymode,	trdatetime,	corr_acc,	accno2,		accno3,		date2,		userid,		tcurrcode,
				tcurramt,	fperiod,	concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,	fperiod,
				(
					select count(entry) from glpost91 where fperiod='#form.period#' 
					<cfif form.transaction_type neq "ALL">
					and acc_code='#form.transaction_type#' 
					</cfif>
					<cfif form.date_from neq "" and form.date_to neq "">
					and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
					</cfif>
				) as lastcol 
				from glpost91 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>;
			</cfquery>
			
			<cfquery name="getdata_from_glpost91_arpost" datasource="#arguments.dts#">
				select 
							accno,		concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				araptype,	reference,	refno,		debitamt,	creditamt,	desp,	despa,	despb,	despc,	despd,
				fcamt,		debit_fc,	credit_fc,	exc_rate,	age,		posted,	rem1,	rem2,	rem4,	source,
				job,		agent,		stran,		fperiod,	batchno,	tranno,
				(
					select count(entry) 
					from glpost91 
					where accno in (select custno from #arguments.target_arcust#) 
					and fperiod='#form.period#' 
					<cfif form.transaction_type neq "ALL">
					and acc_code='#form.transaction_type#' 
					</cfif>
					<cfif form.date_from neq "" and form.date_to neq "">
					and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
					</cfif>
				) as lastcol 
				from glpost91 
				where accno in (select custno from #arguments.target_arcust#) 
				and fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>;
			</cfquery>
			
			<cfquery name="getdata_from_glpost91_appost" datasource="#arguments.dts#">
				select 
							accno,		concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				araptype,	reference,	refno,		debitamt,	creditamt,	desp,	despa,	despb,	despc,	despd,
				fcamt,		debit_fc,	credit_fc,	exc_rate,	age,		posted,	rem1,	rem2,	rem4,	source,
				job,		agent,		stran,		fperiod,	batchno,	tranno,
				(
					select count(entry) 
					from glpost91 
					where accno in (select custno from #arguments.target_apvend#) 
					and fperiod='#form.period#' 
					<cfif form.transaction_type neq "ALL">
					and acc_code='#form.transaction_type#' 
					</cfif>
					<cfif form.date_from neq "" and form.date_to neq "">
					and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
					</cfif>
				) as lastcol 
				from glpost91 
				where accno in (select custno from #arguments.target_apvend#) 
				and fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>;
			</cfquery>

			<cfobject type="JAVA" action="Create" name="Class" class="java.lang.Class">
			<cfobject type="JAVA" action="Create" name="DriverManager" class="java.sql.DriverManager">
						
			<cfset Class.forName("org.gjt.mm.mysql.Driver")>		
			<cfset con = DriverManager.getConnection("jdbc:mysql://#getlinkresult.amsipaddress#:#getlinkresult.amsportno#/#arguments.dts1#?user=#getlinkresult.amsusername#&password=#getlinkresult.amspassword#")>
			
			<!--- insert into glpost --->
			<cfset st = con.prepareStatement(resultSetToQuery1(getdata_from_glpost91_glpost))>
			<cfset rs = st.executeUpdate()>
			
			<!--- insert into arpost --->
			<cfif getdata_from_glpost91_arpost.recordcount neq 0>
				<cfset st = con.prepareStatement(resultSetToQuery2(getdata_from_glpost91_arpost))>
				<cfset rs = st.executeUpdate()>
			</cfif>
			
			<!--- insert into appost--->
			<cfif getdata_from_glpost91_appost.recordcount neq 0>
				<cfset st = con.prepareStatement(resultSetToQuery3(getdata_from_glpost91_appost))>
				<cfset rs = st.executeUpdate()>
			</cfif>
			
			<!--- update gldata --->
			<cfset import_period = form.period + 10>
			<cfset st = con.prepareStatement("
			update gldata as a,
			(
				select accno,(sum(debitamt)-sum(creditamt)) as balance 
				from glpost 
				where fperiod="&#form.period#&" 
				group by accno,fperiod 
				order by accno,fperiod
			) as b set 
			a.p"&#import_period#&"=b.balance where a.accno=b.accno;
			")>
			<cfset rs = st.executeUpdate()>
			
			<!--- update glbatch --->
			<cfset st = con.prepareStatement("
			update glbatch as a,
			(
				select a.recno,b.totaltran,b.totaldebit,b.totalcredit
				from glbatch as a
				left join
				(
  					select batchno,count(batchno) as totaltran,sum(debitamt) as totaldebit,sum(creditamt) as totalcredit
  					from glpost
  					group by batchno
  					order by batchno
				) as b on a.recno=b.batchno
			) as b set 
			a.debittt=b.totaldebit,
			a.credittt=b.totalcredit,
			a.notran=b.totaltran 
			where a.recno=b.recno;"
			)>
			<cfset rs = st.executeUpdate()>
			
			<cfset st.close()>
			<cfset con.close()>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="update_glpost91">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="target_arcust" required="yes" type="any">
		<cfargument name="target_apvend" required="yes" type="any">
		<cfargument name="userid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="update_glpost91" datasource="#arguments.dts#">
				update glpost91 set 
				batchno='#form.batch_no#',
				tranno=entry,
				vouc_seq='#form.batch_no#',
				vouc_seq2='#form.batch_no#',
				
				ttype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
				(case acc_code 
					when 'CN' then 'RC' 
					when 'CS' then 'GD' 
					when 'DN' then 'RD' 
					when 'INV' then 'RD' 
					when 'PR' then 'PD' 
					when 'RC' then 'PC' 
				end),
				(case acc_code 
					when 'CN' then 'GD' 
					when 'CS' then 'GC' 
					when 'DN' then 'GC' 
					when 'INV' then 'GC' 
					when 'PR' then 'GC' 
					when 'RC' then 'GD' 
				end))),
				
				araptype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
				(case acc_code 
					when 'CN' then 'C' 
					when 'CS' then 'V' 
					when 'DN' then 'D' 
					when 'INV' then 'I' 
					when 'PR' then 'D' 
					when 'RC' then 'I' 
				end),
				'Z')),			
				
				posted=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),'P','')),
				userid='#arguments.userid#',
				bperiod=fperiod,
				bdate=date,
				vperiod=fperiod
							 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>
			</cfquery>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="delete_posted_glpost91">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="delete_posted_transaction" datasource="#arguments.dts#">
				delete from glpost91 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>
			</cfquery>
		
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="unpost_glpost91">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="type" required="yes" type="any">
		<cfargument name="all_refno2" required="yes" type="any">
		
		<cftry>
			<cfinvoke component="cfc.link_ams_info" method="getamslinkinfo" returnvariable="getlinkresult"></cfinvoke>
			
			<cfobject type="JAVA" action="Create" name="Class" class="java.lang.Class">
			<cfobject type="JAVA" action="Create" name="DriverManager" class="java.sql.DriverManager">
						
			<cfset Class.forName("org.gjt.mm.mysql.Driver")>		
			<cfset con = DriverManager.getConnection("jdbc:mysql://#getlinkresult.amsipaddress#:#getlinkresult.amsportno#/#arguments.dts1#?user=#getlinkresult.amsusername#&password=#getlinkresult.amspassword#")>
			
			<!--- switch target table --->
			<cfswitch expression="#arguments.type#">
				<cfcase value="RC,PR" delimiters=",">
					<cfset table = "appost">
				</cfcase>
				<cfdefaultcase>
					<cfset table = "arpost">
				</cfdefaultcase>
			</cfswitch>
			
			<!--- delete from glpost --->
			<cfset query = "delete from glpost where acc_code='#arguments.type#' and reference in (#arguments.all_refno2#);">
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>
			
			<!--- delete from arpost/appost --->
			<cfset query = "delete from #table#	where reference in (#arguments.all_refno2#);">
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>
			
			<!--- <cfset query = "delete a,b from glpost as a,appost as b 
							where a.acc_code='#arguments.type#' and a.reference=b.reference and a.reference in (#arguments.all_refno2#);">
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()> --->

			<!--- update gldata --->
			<!--- <cfset query = "update gldata set 
							gldata.p11=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='1'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p12=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='2'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p13=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='3'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p14=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='4'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p15=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='5'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p16=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='6'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p17=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='7'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p18=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='8'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p19=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='9'  and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p20=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='10' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p21=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='11' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p22=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='12' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p23=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='13' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p24=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='14' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p25=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='15' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p26=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='16' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p27=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='17' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod),
							gldata.p28=(select (sum(ifnull(glpost.debitamt,0))-sum(ifnull(glpost.creditamt,0))) as balance from glpost where glpost.fperiod='18' and glpost.accno=gldata.accno group by glpost.accno,glpost.fperiod order by glpost.accno,glpost.fperiod);">
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()> --->
			
			<!--- update glbatch --->
			<cfset query = "
			update glbatch as a,
			(
				select a.recno,b.totaltran,b.totaldebit,b.totalcredit
				from glbatch as a
				left join
				(
  					select batchno,count(batchno) as totaltran,sum(debitamt) as totaldebit,sum(creditamt) as totalcredit
  					from glpost
  					group by batchno
  					order by batchno
				) as b on a.recno=b.batchno
			) as b set 
			a.debittt=b.totaldebit,
			a.credittt=b.totalcredit,
			a.notran=b.totaltran 
			where a.recno=b.recno;
			">
			
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>
			
			<cfset st.close()>
			<cfset con.close()>
		
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>