<cfcomponent>
	<cffunction name="getPurchaseMonthContent" output="true" returntype="query">
		<cfargument name="dts" required="yes" type="string">
		<cfargument name="periodDate" required="yes" type="string">
		<cfargument name="itemFrom" required="yes" type="string">
		<cfargument name="itemTo" required="yes" type="string">
		<cfargument name="period" required="yes" type="string">
		<cfargument name="indexFrom" required="yes" type="numeric">
		<cfargument name="indexTo" required="yes" type="numeric">
		<cfargument name="label" required="yes" type="string">
        
        
        <cfset validpr = arraynew(1)>
        <cfloop from="#indexFrom#" to="#indexTo#" index="i">
        <cfset validpr[#i#] = 1>
        <cfquery name="validprcount" datasource="#dts#">
        select custno,sum(amt) as neg_sumamt#i#
					from ictran 
					where type='PR' and fperiod=#i# and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
					group by custno
        </cfquery>
        <cfif validprcount.recordcount eq 0>
        <cfset validpr[#i#] = 0>
        </cfif>
        
        </cfloop>
        
		<cfquery name="getdata" datasource="#dts#">
			select ic.itemno,ic.desp as desp,ic2.*
			from ictran ic
			left join 
			(
				select ict.itemno,type
				<cfloop from="#indexFrom#" to="#indexTo#" index="i">
				<cfif label neq "" and label neq "salesqty">,(if(pos_sumamt#i# is null,0,pos_sumamt#i#)-if(neg_sumamt#i# is null,0,neg_sumamt#i#)) as sumamt#i#
				<cfelse>,(if(pos_sumqty#i# is null,0,pos_sumqty#i#)-if(neg_sumqty#i# is null,0,neg_sumqty#i#)) as sumqty#i#</cfif>
				</cfloop>
				from ictran ict
				<cfloop from="#indexFrom#" to="#indexTo#" index="i">
				left join
				(
					select itemno,sum(amt) as pos_sumamt#i#,
					sum(qty) pos_sumqty#i# 
                    <cfif validpr[#i#] eq 0>
                    ,0 as neg_sumamt#i#
                    ,0 as neg_sumqty#i#
					</cfif>
					from ictran where
					type='RC' and fperiod=#i#
					group by itemno
				) as a#i# on a#i#.itemno=ict.itemno
                <cfif validpr[#i#] neq 0>
				left join
				(
					select itemno,sum(amt) as neg_sumamt#i#,
					sum(qty) as neg_sumqty#i# 
					from ictran 
					where type='PR' and fperiod=#i#
					group by itemno
				) as b#i# on b#i#.itemno=ict.itemno
                </cfif>
				</cfloop>
				where (ict.type='RC' or ict.type='PR') and fperiod<>'99' and (void = "" or void is null) 
				group by ict.itemno
			) as ic2 on ic2.itemno=ic.itemno
           
			where wos_date>#periodDate# and (ic.type='RC' or ic.type='PR')and (linecode ='' or linecode is null) and ic.itemno not in (select servi from icservi)
			<cfif itemfrom neq "" and itemto neq "">
			and ic.itemno>='#itemfrom#' and ic.itemno<='#itemto#'
			</cfif>
			<cfif period neq "" and period eq "1">
			and fperiod>=1 and fperiod<=6
			<cfelseif period neq "" and period eq "2">
			and fperiod>=7 and fperiod<=12
			<cfelseif period neq "" and period eq "3">
			and fperiod>=13 and fperiod<=18
			<cfelse>
			and fperiod>=1 and fperiod<=18
			</cfif>
			group by ic.itemno order by ic.itemno
		</cfquery>
		<cfreturn getdata>
	</cffunction>
	
	<cffunction name="getVendorMonthContent" returntype="query">
		<cfargument name="dts" required="yes" type="string">
		<cfargument name="periodDate" required="yes" type="string">
		<cfargument name="suppFrom" required="yes" type="string">
		<cfargument name="suppTo" required="yes" type="string">
		<cfargument name="period" required="yes" type="string">
		<cfargument name="indexFrom" required="yes" type="numeric">
		<cfargument name="indexTo" required="yes" type="numeric">
        
        
        <cfset validpr = arraynew(1)>
        <cfloop from="#indexFrom#" to="#indexTo#" index="i">
        <cfset validpr[#i#] = 1>
        <cfquery name="validprcount" datasource="#dts#">
        select custno,sum(amt) as neg_sumamt#i#
					from ictran 
					where type='PR' and fperiod=#i# and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
					group by custno
        </cfquery>
        <cfif validprcount.recordcount eq 0>
        <cfset validpr[#i#] = 0>
        </cfif>
        
        </cfloop>

		<cfquery name="getdata" datasource="#dts#">
			select ic.custno,name,ic2.*
			from ictran ic
			left join 
			(
				select ict.custno,type
				<cfloop from="#indexFrom#" to="#indexTo#" index="i">,(if(pos_sumamt#i# is null,0,pos_sumamt#i#)-if(neg_sumamt#i# is null,0,neg_sumamt#i#)) as sumamt#i#
				</cfloop>
				from ictran ict
				<cfloop from="#indexFrom#" to="#indexTo#" index="i">
				left join
				(
					select custno,sum(amt) as pos_sumamt#i#
                    <cfif validpr[#i#] eq 0>
                    ,0 as neg_sumamt#i#
					</cfif>
					from ictran where
					type='RC' and fperiod=#i#
					group by custno
				) as a#i# on a#i#.custno=ict.custno
                <cfif validpr[#i#] neq 0>
				left join
				(
					select custno,sum(amt) as neg_sumamt#i#
					from ictran 
					where type='PR' and fperiod=#i#
					group by custno
				) as b#i# on b#i#.custno=ict.custno
                </cfif>
				</cfloop>
				where (ict.type='RC' or ict.type='PR') and fperiod<>'99'
				group by ict.custno
			) as ic2 on ic2.custno=ic.custno
			where wos_date>#periodDate# and (ic.type='RC' or ic.type='PR') and (linecode ='' or linecode is null) and ic.itemno not in (select servi from icservi)
			<cfif suppFrom neq "" and form.suppTo neq "">
			and ic.custno>='#suppfrom#' and ic.custno<='#suppto#'
			</cfif>
            and ic.custno<>'assm/999'
			<cfif period neq "" and period eq "1">
			and fperiod>=1 and fperiod<=6
			<cfelseif period neq "" and period eq "2">
			and fperiod>=7 and fperiod<=12
			<cfelseif period neq "" and period eq "3">
			and fperiod>=13 and fperiod<=18
			<cfelse>
			and fperiod>=1 and fperiod<=18
			</cfif>
			group by ic.custno order by ic.custno
		</cfquery>
		<cfreturn getdata>
	</cffunction>
</cfcomponent>
