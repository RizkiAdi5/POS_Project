<cfcomponent>
	<cffunction name="batch">
		<cfargument name="dts" required="yes" type="any">
		
		<cfset intrantype="'RC','CN','OAI','TRIN'">
		<cfif dts eq "eocean_i">
			<cfset outtrantype="'DO','PR','CS','DN','ISS','OAR','TROU','CT'">
		<cfelse>
			<cfset outtrantype="'DO','PR','CS','DN','ISS','OAR','TROU'">
		</cfif>
		
		<cfquery name="getictranin" datasource="#arguments.dts#">
			select sum(qty) as qin , itemno, batchcode
			from ictran 
			where type in (#PreserveSingleQuotes(intrantype)#)
			and fperiod<>'99' 
			and batchcode <> ''
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)  
			group by itemno, batchcode
		</cfquery>
		
		<cfquery name="getictranout" datasource="#arguments.dts#">
			select sum(qty) as qout , itemno, batchcode
			from ictran as a
			where (void = '' or void is null) and (linecode <> 'SV' or linecode is null) 
			and fperiod<>'99' 
			and batchcode <> ''
			and (type in (#PreserveSingleQuotes(outtrantype)#) or 
			(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))  
			group by itemno, batchcode
		</cfquery>
		
		<cfquery name="clear_all_qty" datasource="#arguments.dts#">
			update obbatch set 
			bth_qin=0,
			bth_qut=0;
		</cfquery>
		
		<cftry>
			<cfloop query="getictranin">	
				<cfquery name="UpdateIcitem" datasource="#arguments.dts#">
					update obbatch set bth_qin= #getictranin.qin# 
					where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranin.itemno#">
					and batchcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranin.batchcode#">
				</cfquery>
			</cfloop>
			<cfcatch type="any">
				<cfoutput>Failed to update bth_qin for item #getictranin.itemno# with batchcode #getictranin.batchcode#. #cfcatch.Message# - #cfcatch.SQLState#.</cfoutput>
			</cfcatch>
		</cftry>
	
		<cftry>
			<cfloop query="getictranout">
				<cfquery name="UpdateIcitem" datasource="#arguments.dts#">
					update obbatch set bth_qut= #getictranout.qout# 
					where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranout.itemno#">
					and batchcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranout.batchcode#">
				</cfquery>
			</cfloop>
			<cfcatch type="any">
				<cfoutput>Failed to update bth_qut for item #getictranout.itemno# with batchcode #getictranout.batchcode#. #cfcatch.Message# - #cfcatch.SQLState#.</cfoutput>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="locationbatch">
		<cfargument name="dts" required="yes" type="any">
		
		<cfset intrantype="'RC','CN','OAI','TRIN'">
		<cfif dts eq "eocean_i">
			<cfset outtrantype="'DO','PR','CS','DN','ISS','OAR','TROU','CT'">
		<cfelse>
			<cfset outtrantype="'DO','PR','CS','DN','ISS','OAR','TROU'">
		</cfif>
		
		<cfquery name="getictranin" datasource="#arguments.dts#">
			select sum(qty) as qin , itemno, batchcode,location
			from ictran 
			where type in (#PreserveSingleQuotes(intrantype)#)
			and fperiod<>'99' 
			and batchcode <> ''
			and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)  
			group by itemno, batchcode,location
		</cfquery>
		
		<cfquery name="getictranout" datasource="#arguments.dts#">
			select sum(qty) as qout , itemno, batchcode,location
			from ictran as a
			where (void = '' or void is null) and (linecode <> 'SV' or linecode is null) 
			and fperiod<>'99' 
			and batchcode <> ''
			and (type in (#PreserveSingleQuotes(outtrantype)#) or 
			(type='INV' and refno not in (select refno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by refno)))  
			group by itemno, batchcode,location
		</cfquery>
		
		<cfquery name="clear_all_qty" datasource="#arguments.dts#">
			update lobthob set 
			bth_qin=0,
			bth_qut=0;
		</cfquery>
		
		<cftry>
			<cfloop query="getictranin">	
				<cfquery name="UpdateIcitem" datasource="#arguments.dts#">
					update lobthob set bth_qin= #getictranin.qin# 
					where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranin.itemno#">
					and batchcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranin.batchcode#">
					and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranin.location#">
				</cfquery>
			</cfloop>
			<cfcatch type="any">
				<cfoutput>Failed to update bth_qin for item #getictranin.itemno# with batchcode #getictranin.batchcode#. #cfcatch.Message# - #cfcatch.SQLState#.</cfoutput>
			</cfcatch>
		</cftry>
	
		<cftry>
			<cfloop query="getictranout">
				<cfquery name="UpdateIcitem" datasource="#arguments.dts#">
					update lobthob set bth_qut= #getictranout.qout# 
					where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranout.itemno#">
					and batchcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranout.batchcode#">
					and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictranout.location#">
				</cfquery>
			</cfloop>
			<cfcatch type="any">
				<cfoutput>Failed to update bth_qut for item #getictranout.itemno# with batchcode #getictranout.batchcode#. #cfcatch.Message# - #cfcatch.SQLState#.</cfoutput>
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>