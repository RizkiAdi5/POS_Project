<cfquery name="getGSetup" datasource="#dts#">
		SELECT invno,invno_2,invno_3,invno_4,invno_5,invno_6,
    	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
		po_oneset,so_oneset,quo_oneset,assm_oneset,tr_oneset,oai_oneset,oar_oneset,sam_oneset
    	FROM gsetup
</cfquery>
        <cfquery name="validset" datasource="#dts#">
        SELECT #validset#  as oneset from gsetup
        </cfquery>

        <cfquery datasource="#dts#" name="getset">
			select counter,concat(counter," - ",lastusedno) as lastno
            from refnoset
			where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ft#">
            <cfif validset.oneset eq 1>
            and counter = 1
			</cfif>
            order by counter
		</cfquery>
<cfoutput>
			<select name="ft_invtype" id="ft_invtype" >
			<cfloop query="getset">
				<option value="#getset.counter#">#getset.lastno#</option>
			</cfloop>
			</select>
</cfoutput>