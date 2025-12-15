<cfcomponent>
	<cffunction name="fifovalue" access="public" returntype="string">
    	<cfargument name="dts" type="string" required="yes">
		<cfargument name="period" type="string" required="yes">
        <cfargument name="itemno" type="string" required="yes">
        <cfargument name="itemqty" type="string" required="yes">
        <cfargument name="monthp" type="string" required="yes">
        
        
        <cfif val(itemqty) eq 0>
        <cfset fifototal = 0 >
        
        <cfelse>
        <cfquery name="getgeneral" datasource="#dts#">
	select 
	compro,
	lastaccyear 
	from gsetup;
</cfquery>

<cfset datelast = DateAdd('m',#monthp#,#getgeneral.lastaccyear#) >
<cfset newdate = DateAdd('m',#period#,#datelast#) >

<cfquery name="getictran" datasource="#dts#">
	
			select 
			a.itemno,
			a.desp,
			a.qtybf,
			b.refno,
			b.itemno,
			b.type,
			b.dono,
			b.wos_date,
			if(b.type='TROU' or b.type='TRIN','Transfer',b.name) as name,
			b.price,
			b.qty,
			b.toinv,
			(b.amt+b.m_charge1+b.m_charge2+b.m_charge3+b.m_charge4+b.m_charge5+b.m_charge6+b.m_charge7) as amt
		
			from icitem a,ictran b
		
			where a.itemno=b.itemno 
			and a.itemno='#itemno#' 
			and (b.void = '' or b.void is null) 
			and b.type not in ('QUO','SO','PO','SAM')
			and b.fperiod<>'99'
            and b.wos_date < #newdate#
            and b.type in('RC','CN','OAI','TRIN')
            order by b.wos_date DESC, b.trdatetime
		</cfquery>
        
        <cfset validcount = 0>
        <cfset total_fifo = 0>
        
		<cfoutput>
        <cfloop query="getictran">
        
    	
        
        <cfif #validcount# gte 0>
        
        <cfset tempvalue = getictran.qty - itemqty>
        
        <cfif tempvalue gte 0>
        
        <cfset total_fifo = total_fifo + (itemqty * #getictran.price#) >
        <cfset validcount = -1>
        <cfelse>
        <cfset tempvalue = tempvalue * -1 >
        <cfset total_fifo = total_fifo + (getictran.qty * #getictran.price#) >
        <cfset itemqty = tempvalue>
        
		</cfif>
        
        </cfif>
        
        </cfloop>
        </cfoutput>

     
		 <cfif validcount eq 0>
         <cfloop from="11" to="50" index="i">
        
         <cfset ffq = "ffq"&"#i#">
		  <cfset ffc = "ffc"&"#i#">
          <cfset ffd = "ffd"&"#i#" >
        
        <cfquery name="getfifoopq" datasource="#dts#">
				select #ffq# as xffq, #ffc# as xffc
				from fifoopq 
				where itemno='#itemno#' and #ffd# < #newdate#
		</cfquery>
        <cfif getfifoopq.recordcount neq 0>
        
        <cfset totalqty = val(getfifoopq.xffq) - itemqty>
        
        <cfif validcount eq 0>
        
        <cfif totalqty gte 0>
        
        <cfset total_fifo = total_fifo + (itemqty * #val(getfifoopq.xffc)#) >
        <cfset validcount = -1>
        <cfelse>
        <cfset totalqty = totalqty * -1 >
        <cfset total_fifo = total_fifo + (#val(getfifoopq.xffq)# * #val(getfifoopq.xffc)#) >
        <cfset itemqty = totalqty>
        
		</cfif>
        </cfif>
        </cfif>
        
         </cfloop>
         
         </cfif>
    <cfset fifototal = total_fifo >
        </cfif>
		
		<cfset myResult=fifototal>
		<cfreturn myResult>
	</cffunction>
</cfcomponent>