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
			(
				acc_code,
				accno,
				fperiod,
				date,
				batchno,
				tranno,
				vouc_seq,
				vouc_seq_2,
				ttype,
				reference,
				refno,
				desp,
				despa,
				despb,
				despc,
				despd,
				despe,
				taxpec,
				debitamt,
				creditamt,
				fcamt,
				debit_fc,
				credit_fc,
				exc_rate,
				araptype,
				age,
				source,
				job,
				job2,
				subjob,
				job_value,
				job2_value,
				posted,
				exported,
				exported1,
				exported2,
				exported3,
				rem1,
				rem2,
				rem3,
				rem4,
				rem5,
				rpt_row,
				agent,
				stran,
				taxpur,
				paymode,
				trdatetime,
				corr_acc,
				accno2,
				accno3,
				date2,
				userid,
				tcurrcode,
				tcurramt,
				bperiod,
				bdate,
				vperiod
			) 	
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
			(
				accno,
				date,
				araptype,
				reference,
				refno,
				debitamt,
				creditamt,
				desp,
				despa,
				despb,
				despc,
				despd,
				fcamt,
				debit_lc,
				credit_lc,
				exc_rate,
				age,
				posted,
				rem1,
				rem2,
				rem4,
				source,
				job,
				agent,
				stran,
				fperiod,
				batchno,
				tranno,
				lastbal
			)
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
			(
				accno,
				date,
				araptype,
				reference,
				refno,
				debitamt,
				creditamt,
				desp,
				despa,
				despb,
				despc,
				despd,
				fcamt,
				debit_lc,
				credit_lc,
				exc_rate,
				age,
				posted,
				rem1,
				rem2,
				rem4,
				source,
				job,
				agent,
				stran,
				fperiod,
				batchno,
				tranno,
				lastbal
			)
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
				acc_code,
				accno,
				fperiod,
				concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				batchno,
				tranno,
				vouc_seq,
				vouc_seq2,
				ttype,
				reference,
				refno,
				desp,
				despa,
				despb,
				despc,
				despd,
				despe,
				taxpec,
				debitamt,
				creditamt,
				fcamt,
				debit_fc,
				credit_fc,
				exc_rate,
				araptype,
				age,
				source,
				job,
				job2,
				subjob,
				job_value,
				job_value2,
				posted,
				exported,
				exported1,
				exported2,
				exported3,
				rem1,
				rem2,
				rem3,
				rem4,
				rem5,
				rpt_row,
				agent,
				stran,
				taxpur,
				paymode,
				trdatetime,
				corr_acc,
				accno2,
				accno3,
				date2,
				userid,
				tcurrcode,
				tcurramt,
				fperiod,
				concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				fperiod,
				(
					select 
					count(entry) 
					
					from glpost91 
					
					where fperiod='#form.period#' 
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
				accno,
				concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				araptype,
				reference,
				refno,
				debitamt,
				creditamt,
				desp,
				despa,
				despb,
				despc,
				despd,
				fcamt,
				debit_fc,
				credit_fc,
				exc_rate,
				age,
				posted,
				rem1,
				rem2,
				rem4,
				source,
				job,
				agent,
				stran,
				fperiod,
				batchno,
				tranno,
				(if(ifnull(debitamt,0)=0,if(ifnull(creditamt,0)=0,0,creditamt),ifnull(debitamt,0))) as lastbal,
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
				accno,
				concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date,
				araptype,
				reference,
				refno,
				debitamt,
				creditamt,
				desp,
				despa,
				despb,
				despc,
				despd,
				fcamt,
				debit_fc,
				credit_fc,
				exc_rate,
				age,
				posted,
				rem1,
				rem2,
				rem4,
				source,
				job,
				agent,
				stran,
				fperiod,
				batchno,
				tranno,
				(if(ifnull(debitamt,0)=0,if(ifnull(creditamt,0)=0,0,creditamt),ifnull(debitamt,0))) as lastbal,
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
			
			<cfset st = con.prepareStatement(resultSetToQuery1(getdata_from_glpost91_glpost))>
			<cfset rs = st.executeUpdate()>
			
			<cfif getdata_from_glpost91_arpost.recordcount neq 0>
				<cfset st = con.prepareStatement(resultSetToQuery2(getdata_from_glpost91_arpost))>
				<cfset rs = st.executeUpdate()>
			</cfif>
			
			<cfif getdata_from_glpost91_appost.recordcount neq 0>
				<cfset st = con.prepareStatement(resultSetToQuery3(getdata_from_glpost91_appost))>
				<cfset rs = st.executeUpdate()>
			</cfif>
			
			<cfset import_period = form.period + 10>
			
			<cfset st = con.prepareStatement("
			update gldata as a,
			(
				select accno,(sum(debitamt)-sum(creditamt)) as balance 
				from glpost 
				where fperiod="&#form.period#&" 
				group by accno,fperiod 
				order by accno,fperiod
			) as b 
			set 
			a.p"&#import_period#&"=b.balance where a.accno=b.accno;
			")>
			
			<cfset rs = st.executeUpdate()>
			
			<cfset st = con.prepareStatement("
			update 
			glbatch as a,
			(
				select 
				a.recno,
				b.totaltran,
				b.totaldebit,
				b.totalcredit
				
				from glbatch as a
				
				left join
				(
  					select 
					batchno,
					count(batchno) as totaltran,
					sum(debitamt) as totaldebit,
					sum(creditamt) as totalcredit
					
  					from glpost
  					
					group by batchno
  					order by batchno
				) as b on a.recno=b.batchno
			) as b 
			
			set 
			
			a.debittt=b.totaldebit,
			a.credittt=b.totalcredit,
			a.notran=b.totaltran 
			
			where a.recno=b.recno;
			")>
			
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
				update glpost91 
				set 
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
				(case  
					when acc_code='CN' and rem4<>'' then 'GD' 
					when acc_code='CN' and rem4='' then 'GC' 
					when acc_code='CS' and rem4<>'' then 'GC' 
					when acc_code='CS' and rem4='' then 'GD' 
					when acc_code='DN' and rem4<>'' then 'GC' 
					when acc_code='DN' and rem4='' then 'GD' 
					when acc_code='INV' and rem4<>'' then 'GC' 
					when acc_code='INV' and rem4='' then 'GD' 
					when acc_code='PR' and rem4<>'' then 'GC' 
					when acc_code='PR' and rem4='' then 'GD' 
					when acc_code='RC' and rem4<>'' then 'GD' 
					when acc_code='RC' and rem4='' then 'GC' 
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
			
			<cfswitch expression="#arguments.type#">
				<cfcase value="RC,PR" delimiters=",">
					<cfset table = "appost">
				</cfcase>
				<cfdefaultcase>
					<cfset table = "arpost">
				</cfdefaultcase>
			</cfswitch>
			
			<cfset query = "
			delete from glpost 
			where acc_code='#arguments.type#' 
			and reference in (#arguments.all_refno2#);
			">
			
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>
			
			<cfset query = "
			delete from #table#	
			where reference in (#arguments.all_refno2#);
			">
			
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>

			<cfset query = "
			update 
			gldata,
			(
				select 
				a.accno,
				b.balance1,
				c.balance2,
				d.balance3,
				e.balance4,
				f.balance5,
				g.balance6,
				h.balance7,
				i.balance8,
				j.balance9,
				k.balance10,
				l.balance11,
				m.balance12,
				n.balance13,
				o.balance14,
				p.balance15,
				q.balance16,
				r.balance17,
				s.balance18 
				
				from gldata as a 
					
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance1 
					
					from glpost 
					
					where fperiod='1' 
					
					group by accno 
					order by accno
				) as b on a.accno=b.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance2 
					
					from glpost 
					
					where fperiod='2' 
					
					group by accno 
					order by accno
				) as c on a.accno=c.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance3 
					
					from glpost 
					
					where fperiod='3' 
					
					group by accno 
					order by accno
				) as d on a.accno=d.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance4 
					
					from glpost 
					
					where fperiod='4' 
					
					group by accno 
					order by accno
				) as e on a.accno=e.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance5 
					
					from glpost 
					
					where fperiod='5' 
					
					group by accno 
					order by accno
				) as f on a.accno=f.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance6 
					
					from glpost 
					
					where fperiod='6' 
					
					group by accno 
					order by accno
				) as g on a.accno=g.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance7 
					
					from glpost 
					
					where fperiod='7' 
					
					group by accno 
					order by accno
				) as h on a.accno=h.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance8 
					
					from glpost 
					
					where fperiod='8' 
					
					group by accno 
					order by accno
				) as i on a.accno=i.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance9 
					
					from glpost 
					
					where fperiod='9' 
					
					group by accno 
					order by accno
				) as j on a.accno=j.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance10 
					
					from glpost 
					
					where fperiod='10' 
					
					group by accno 
					order by accno
				) as k on a.accno=k.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance11 
					
					from glpost 
					
					where fperiod='11' 
					
					group by accno 
					order by accno
				) as l on a.accno=l.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance12 
					
					from glpost 
					
					where fperiod='12' 
					
					group by accno 
					order by accno
				) as m on a.accno=m.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance13 
					
					from glpost 
					
					where fperiod='13' 
					
					group by accno 
					order by accno
				) as n on a.accno=n.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance14 
					
					from glpost 
					
					where fperiod='14' 
					
					group by accno 
					order by accno
				) as o on a.accno=o.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance15 
					
					from glpost 
					
					where fperiod='15' 
					
					group by accno 
					order by accno
				) as p on a.accno=p.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance16 
					
					from glpost 
					
					where fperiod='16' 
					
					group by accno 
					order by accno
				) as q on a.accno=q.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance17 
					
					from glpost 
					
					where fperiod='17' 
					
					group by accno 
					order by accno
				) as r on a.accno=r.accno 
				
				left join 
				(
					select 
					accno,
					(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance18 
					
					from glpost 
					
					where fperiod='18' 
					
					group by accno 
					order by accno
				) as s on a.accno=s.accno 
				
				order by a.accno
				
			) as gldata_balance 
			
			set 
			
			gldata.p11=gldata_balance.balance1,
			gldata.p12=gldata_balance.balance2,
			gldata.p13=gldata_balance.balance3,
			gldata.p14=gldata_balance.balance4,
			gldata.p15=gldata_balance.balance5,
			gldata.p16=gldata_balance.balance6,
			gldata.p17=gldata_balance.balance7,
			gldata.p18=gldata_balance.balance8,
			gldata.p19=gldata_balance.balance9,
			gldata.p20=gldata_balance.balance10,
			gldata.p21=gldata_balance.balance11,
			gldata.p22=gldata_balance.balance12,
			gldata.p23=gldata_balance.balance13,
			gldata.p24=gldata_balance.balance14,
			gldata.p25=gldata_balance.balance15,
			gldata.p26=gldata_balance.balance16,
			gldata.p27=gldata_balance.balance17,
			gldata.p28=gldata_balance.balance18 
			
			where gldata.accno=gldata_balance.accno;
			">
			
			<cfset st = con.prepareStatement(query)>
			<cfset rs = st.executeUpdate()>
			
			<cfset query = "
			update 
			glbatch as a,
			(
				select 
				a.recno,
				b.totaltran,
				b.totaldebit,
				b.totalcredit 
				
				from glbatch as a 
				
				left join
				(
  					select 
					batchno,
					count(batchno) as totaltran,
					sum(debitamt) as totaldebit,
					sum(creditamt) as totalcredit
  					
					from glpost
  					
					group by batchno
  					order by batchno
				) as b on a.recno=b.batchno
			) as b 
			
			set 
			
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