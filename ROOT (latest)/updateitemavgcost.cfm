<cfquery name="getictran" datasource="#dts#">
	select itemno from icitem
</cfquery>

<cfloop query = "getictran">
			

            <!---gamemartz--->
            <cfquery name="getgeneral" datasource="#dts#">
                select compro,lastaccyear,agentlistuserid,fifocal from gsetup
            </cfquery>
            <cfquery name="getqtybf" datasource="#dts#">
			select avcost2,qtybf FROM icitem
			where itemno='#getictran.itemno#'
			limit 1
            </cfquery>

            <cfset movingunitcost=val(getqtybf.avcost2)>
            <cfset movingbal=val(getqtybf.qtybf)>
            
            <cfquery name="getmovingictran" datasource="#dts#">
			select 
		    a.amt,a.qty,a.toinv,
            a.type,a.refno,a.itemno,a.trancode
			from ictran a,artran b

			where a.itemno='#getictran.itemno#' 
            and a.refno=b.refno and a.type=b.type
			and (a.void = '' or a.void is null)
			and (a.linecode = '' or a.linecode is null)
			and a.type not in ('QUO','SO','PO','SAM')
			and a.fperiod<>'99'
			order by a.wos_date,b.created_on,a.trdatetime

			</cfquery>
        
        <cfloop query="getmovingictran">
        <cfif isdefined('form.dodate')>
  		<cfif type eq "INV">
  		<cfquery name="checkexist2" datasource="#dts#">
  		select toinv,refno,type,itemno from ictran a  where refno ='#getmovingictran.refno#' and itemno =			
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getmovingictran.itemno#"> and type = "#getmovingictran.type#" and 
        trancode = "#getmovingictran.trancode#" and (dono = "" or dono is null or dono not in (select 
        frrefno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by frrefno))
  		</cfquery>
  		</cfif>
  		</cfif>
        <!---exclude CN --->
        
        	<cfif getmovingictran.type eq "CN">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>

        
        
        	<cfif getmovingictran.type eq "OAI">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>
        
			<cfif getmovingictran.type eq "RC" or getmovingictran.type eq "TRIN">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>
        
        
        <cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO")>
        
        <cfif isdefined('form.dodate')>
                    
        <cfif getmovingictran.type eq "DO">
        <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
		<cfelseif getmovingictran.type eq "INV" and checkexist2.recordcount eq 0>
        <cfelse>
	    <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
	    </cfif>
        <cfelse>
        
        <cfif getmovingictran.type eq "DO" and getmovingictran.toinv neq "">
		<cfelse>
	    <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
	    </cfif>
        
        </cfif>
        </cfif>

        
        </cfloop>
        
			<cfset movingstockbal=val(movingbal)*val(movingunitcost)>
            <cfquery name="updateIcitem" datasource="#dts#">
                update icitem 
                    set ucost=<cfqueryparam cfsqltype="cf_sql_double" value="#val(movingunitcost)#">
                    where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">;
            </cfquery>

          
			
</cfloop>