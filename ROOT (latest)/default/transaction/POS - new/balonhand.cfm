<cfsetting showdebugoutput="no">
<cfif isdefined('url.itemno')>
<cfset itemno = URLDECODE(url.itemno)>

<cfquery name="checkitemexist" datasource="#dts#">
SELECT qtybf,ucost FROM icitem WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>
<cfif checkitemexist.recordcount eq 0>
<cfquery name="checkitemexist" datasource="#dts#">
SELECT qtybf,ucost,itemno FROM icitem WHERE aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>
<cfset itemno = checkitemexist.itemno>
</cfif>

<cfif checkitemexist.recordcount neq 0>
<cfset itembal = val(checkitemexist.qtybf)>
<cfset location = "">
<cfif isdefined('url.location')>
<cfif url.location neq "">
<cfset location = URLDECODE(url.location)>
<cfquery name="getlocitembal" datasource="#dts#">
			select LOCQFIELD as locqtybf from locqdbf
			where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#">
		</cfquery>
		<cfif getlocitembal.recordcount neq 0>
			<cfset itembal = getlocitembal.locqtybf>
		<cfelse>
			<cfset itembal = 0>
		</cfif>
</cfif>
</cfif>

<cfquery name="getin" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
		and fperiod <> '99' 
		and (void = '' or void is null)
        <cfif location neq "" >
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#"> 
        </cfif>
</cfquery>
<cfif getin.recordcount neq 0>
<cfset inqty = val(getin.sumqty)>
<cfelse>
<cfset inqty = 0>
</cfif>

<cfquery name="getout" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
		and fperiod <> '99' 
        <cfif location neq "" >
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#"> 
        </cfif>
		and (void = '' or void is null);
</cfquery>
<cfif getout.recordcount neq 0>
<cfset outqty = val(getout.sumqty)>
<cfelse>
<cfset outqty = 0>
</cfif>

<cfquery name="getdo" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type='DO' 
		and (toinv='' or toinv is null)
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> 
        <cfif location neq "" >
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#"> 
        </cfif>
		and fperiod <> '99' 
		and (void = '' or void is null);
</cfquery>
<cfif getdo.recordcount neq 0>
<cfset doqty = val(getdo.sumqty)>
<cfelse>
<cfset doqty = 0>
</cfif>

<cfquery name="getGeneralInfo" datasource="#dts#">
SELECT deductso FROM gsetup
</cfquery>

<cfif getGeneralInfo.deductso eq "Y">
		<cfquery name="getso" datasource="#dts#">
			select 
			ifnull(sum(qty),0) as sumqty 
			from ictran 
			where type='SO' 
			and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#"> 
            <cfif location neq "" >
            and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#"> 
            </cfif>
			and fperiod <> '99' 
			and (void = '' or void is null) and (toinv='' or toinv is null);
		</cfquery>
		<cfif getso.recordcount neq 0>
		<cfset soqty = val(getso.sumqty)>
        <cfelse>
        <cfset soqty = 0>
        </cfif>
		<cfset balonhand = itembal + inqty - outqty - doqty - soqty>
	<cfelse>
		<cfset balonhand = itembal + inqty - outqty - doqty>
	</cfif>
    <cfoutput>
Balance: <input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" readonly name="balonhand" id="balonhand" value="#balonhand#" size="7" ><input type="hidden" readonly name="stkcost" id="stkcost" value="#val(checkitemexist.ucost)#" size="7" >
</cfoutput>
</cfif>
</cfif>