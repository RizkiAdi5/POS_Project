<cfif isservice neq 1>

	<cfif xlocation neq "">
		<cfquery name="getlocitembal" datasource="#dts#">
			select LOCQFIELD as locqtybf from locqdbf
			where itemno = '#itemno#' 
			and location = '#xlocation#'
		</cfquery>
		<cfif getlocitembal.recordcount neq 0>
			<cfset itembal = getlocitembal.locqtybf>
		<cfelse>
			<cfset itembal = 0>
		</cfif>
	<cfelse>
		<cfif getitembal.qtybf neq "">
			<cfset itembal = getitembal.qtybf>
		</cfif>
	</cfif>
	
	<cfquery name="getin" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('RC','CN','OAI') 
		and itemno='#itemno#'
		<cfif xlocation neq "">
			and location = '#xlocation#' 
		</cfif> 
		and fperiod <> '99' 
		and (void = '' or void is null);
	</cfquery>

	<cfif getin.sumqty neq "">
		<cfset inqty = getin.sumqty>
	</cfif>

	<cfquery name="getout" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('INV','DN','PR','CS','ISS','OAR') 
		and itemno='#itemno#'
		<cfif xlocation neq "">
			and location = '#xlocation#' 
		</cfif>  
		and fperiod <> '99' 
		and (void = '' or void is null);
	</cfquery>

	<cfif getout.sumqty neq "">
		<cfset outqty = getout.sumqty>
	</cfif>

	<cfquery name="getdo" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type='DO' 
		and toinv='' 
		and itemno='#itemno#' 
		<cfif xlocation neq "">
			and location = '#xlocation#' 
		</cfif> 
		and fperiod <> '99' 
		and (void = '' or void is null);
	</cfquery>

	<cfif getdo.sumqty neq "">
		<cfset DOqty = getdo.sumqty>
	</cfif>
	
	<cfif getGeneralInfo.deductso eq "Y">
		<cfquery name="getso" datasource="#dts#">
			select 
			ifnull(sum(qty),0) as sumqty 
			from ictran 
			where type='SO' 
			and itemno='#itemno#' 
			and fperiod <> '99' 
			<cfif xlocation neq "">
				and location = '#xlocation#' 
			</cfif> 
			and (void = '' or void is null) and toinv='';
		</cfquery>
		
		<cfset balonhand = itembal + inqty - outqty - doqty - getso.sumqty>
	<cfelse>
		<cfset balonhand = itembal + inqty - outqty - doqty>
	</cfif>
    
    <cfquery name="getmin" datasource="#dts#">
    SELECT minimum FROM icitem where itemno ='#itemno#' 
    </cfquery>
    <cfset minimumqty = val(getmin.minimum) >
   
</cfif>