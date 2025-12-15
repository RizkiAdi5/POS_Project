<cfcomponent>
	<cffunction name="calculate_moving_average_cost">
		<cfargument name="dts" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		
		<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			<cfset critirial = "where a.itemno between "&chr(39)&form.itemfrom&chr(39)& " and "&chr(39)&form.itemto&chr(39)>
			<cfset critirial1 = "and itemno between "&chr(39)&form.itemfrom&chr(39)& " and "&chr(39)&form.itemto&chr(39)>
		<cfelse>
			<cfset critirial = "">
			<cfset critirial1 = "">
		</cfif>
		
        <cfif lcase(arguments.dts) eq "gamemartz_i">
        <cfquery name="updatercdate" datasource="#arguments.dts#">
        update ictran set trdatetime=concat(DATE_FORMAT(wos_date,"%Y"),"-",DATE_FORMAT(wos_date,"%m"),"-",DATE_FORMAT(wos_date,"%d")," 00:00:00") where type="RC"
        </cfquery>
        </cfif>
        
		<!--- Get Moving Item --->
		<cfquery name="getitem" datasource="#arguments.dts#">
			select a.itemno,ifnull(a.avcost2,0) as avcost2,ifnull(a.qtybf,0) as qtybf,(ifnull(a.avcost2,0)*ifnull(a.qtybf,0)) as cumtotal 
			from icitem as a,
			(select itemno from ictran where 
            (toinv='' or toinv is null) 
            and (void = '' or void is null) 
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
            and fperiod <> "99"
            and (linecode <> 'SV' or linecode is null)
			and (type='RC' or type='OAI' or type='CN' or type='INV' or type='DO' or type='CS' or type='DN' or type='ISS' or type='OAR' or type='PR') group by itemno
            ) as b 
			where a.itemno=b.itemno order by a.itemno;
		</cfquery>
		
		<cfloop query="getitem">
			<cfset cumqty = getitem.qtybf>
			<cfset cumamt = getitem.cumtotal>
			<cfset cost = getitem.avcost2>
			
			<!--- Get Relevent Cost --->
			<cfquery name="getictran" datasource="#arguments.dts#">
				select type,refno,(date_format(wos_date,'%Y-%m-%d')) as wos_date,trancode,itemno,ifnull(qty,0) as qty,ifnull(amt,0) as amt 
				from ictran 
				where itemno='#getitem.itemno#' and (type='RC' or type='OAI' or type='CN' or type='INV' or type='DO' or type='CS' or type='DN' or type='ISS' or type='OAR' or type='PR')
                and (toinv='' or toinv is null) 
            	and (void = '' or void is null)
            	and fperiod <> "99"
                and (linecode <> 'SV' or linecode is null)
                order by wos_date,trdatetime,trancode;
			</cfquery>
			
			<!--- Calculate Cost --->
			<cfloop query="getictran">
				<cfswitch expression="#getictran.type#">
					<cfcase value="RC,OAI,CN" delimiters=",">
						<cfset cumqty = cumqty + getictran.qty>
						<cfset cumamt = cumamt + getictran.amt>
						
						<cfswitch expression="#cumqty#">
							<cfcase value="0"><cfset cost = 0></cfcase>
							<cfdefaultcase><cfset cost = cumamt/cumqty></cfdefaultcase>
						</cfswitch>
					</cfcase>
					
					<cfdefaultcase>
						<cfset cumqty = cumqty - getictran.qty>
						<cfset cumamt = cumamt - (cost*getictran.qty)>
						
						<cfif cumqty lt 0>
							<cfset cost = 0>
                            <cfelseif cumqty eq 0 and val(getictran.qty) neq 0>
                            <cfset cost = cost>
                            <cfelseif cumqty eq 0>
                            <cfset cost = 0>
                            <cfelse>
							<cfset cost = cumamt/cumqty>
						</cfif>
                        <cfif cost lt 0>
                        <cfset cost = 0>
                        </cfif>
						
                        <cfif val(cost) eq 0>
                        <cfquery name="getlatestrc" datasource="#arguments.dts#">
                        select price from ictran where type='RC' and itemno='#getictran.itemno#' 
						and wos_date>='#getictran.wos_date#' limit 1;
                        </cfquery>
                        
                        <cfset cost = val(getlatestrc.price)>
                        
                        </cfif>
                        
                        
						<!--- Update Cost --->
						<cfquery name="update_cost" datasource="#arguments.dts#">
							update ictran set it_cos=(qty*#cost#)
							where type='#getictran.type#' and refno='#getictran.refno#' and itemno='#getictran.itemno#' 
							and wos_date='#getictran.wos_date#' and trancode='#getictran.trancode#';
						</cfquery>
					</cfdefaultcase>
				</cfswitch>
				
				<cfif cumqty eq 0>
					<cfset cumamt = 0>
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfreturn 0>
	</cffunction>
</cfcomponent>	