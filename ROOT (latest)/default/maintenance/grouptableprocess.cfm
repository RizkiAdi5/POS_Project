
<cfquery datasource='#dts#' name="getgeneral">
	Select lgroup as layer from gsetup
</cfquery>

<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from icgroup where wos_group = '#form.wos_group#' 
 	</cfquery>
  	
	<cfif checkitemExist.recordcount gt 0 >
		<cfoutput>
      		<h3><font color="##FF0000">Error, This #getgeneral.layer# ("#form.wos_group#") has been created already.</font></h3>
			<script language="javascript" type="text/javascript">
				alert("Error, This #getgeneral.layer# #form.wos_group# Has Been Created Already.");
				javascript:history.back();
				javascript:history.back();
			</script>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<cfinsert datasource='#dts#' tablename="icgroup" 
	formfields="wos_group,desp,salec,salecsc,salecnc,purc,purprc,meter_read,
	gradd11,gradd12,gradd13,gradd14,gradd15,gradd16,gradd17,gradd18,gradd19,gradd20,
	gradd21,gradd22,gradd23,gradd24,gradd25,gradd26,gradd27,gradd28,gradd29,gradd30,
	gradd31,gradd32,gradd33,gradd34,gradd35,gradd36,gradd37,gradd38,gradd39,gradd40,
	gradd41,gradd42,gradd43,gradd44,gradd45,gradd46,gradd47,gradd48,gradd49,gradd50,
	gradd51,gradd52,gradd53,gradd54,gradd55,gradd56,gradd57,gradd58,gradd59,gradd60,
	gradd61,gradd62,gradd63,gradd64,gradd65,gradd66,gradd67,gradd68,gradd69,gradd70,
	gradd71,gradd72,gradd73,gradd74,gradd75,gradd76,gradd77,gradd78,gradd79,gradd80,
	gradd81,gradd82,gradd83,gradd84,gradd85,gradd86,gradd87,gradd88,gradd89,gradd90,
	gradd91,gradd92,gradd93,gradd94,gradd95,gradd96,gradd97,gradd98,gradd99,gradd100,
	gradd101,gradd102,gradd103,gradd104,gradd105,gradd106,gradd107,gradd108,gradd109,gradd110,
	gradd111,gradd112,gradd113,gradd114,gradd115,gradd116,gradd117,gradd118,gradd119,gradd120,
	gradd121,gradd122,gradd123,gradd124,gradd125,gradd126,gradd127,gradd128,gradd129,gradd130,
	gradd131,gradd132,gradd133,gradd134,gradd135,gradd136,gradd137,gradd138,gradd139,gradd140,
	gradd141,gradd142,gradd143,gradd144,gradd145,gradd146,gradd147,gradd148,gradd149,gradd150,
	gradd151,gradd152,gradd153,gradd154,gradd155,gradd156,gradd157,gradd158,gradd159,gradd160,
    
    gradd161,gradd162,gradd163,gradd164,gradd165,gradd166,gradd167,gradd168,gradd169,gradd170,
    gradd171,gradd172,gradd173,gradd174,gradd175,gradd176,gradd177,gradd178,gradd179,gradd180,
    gradd181,gradd182,gradd183,gradd184,gradd185,gradd186,gradd187,gradd188,gradd189,gradd190,
    gradd191,gradd192,gradd193,gradd194,gradd195,gradd196,gradd197,gradd198,gradd199,gradd200,
    gradd201,gradd202,gradd203,gradd204,gradd205,gradd206,gradd207,gradd208,gradd209,gradd210,
    gradd211,gradd212,gradd213,gradd214,gradd215,gradd216,gradd217,gradd218,gradd219,gradd220,
    gradd221,gradd222,gradd223,gradd224,gradd225,gradd226,gradd227,gradd228,gradd229,gradd230,
    gradd231,gradd232,gradd233,gradd234,gradd235,gradd236,gradd237,gradd238,gradd239,gradd240,
    gradd241,gradd242,gradd243,gradd244,gradd245,gradd246,gradd247,gradd248,gradd249,gradd250,
    gradd251,gradd252,gradd253,gradd254,gradd255,gradd256,gradd257,gradd258,gradd259,gradd260,
    gradd261,gradd262,gradd263,gradd264,gradd265,gradd266,gradd267,gradd268,gradd269,gradd270,
    gradd271,gradd272,gradd273,gradd274,gradd275,gradd276,gradd277,gradd278,gradd279,gradd280,
    gradd281,gradd282,gradd283,gradd284,gradd285,gradd286,gradd287,gradd288,gradd289,gradd290,
    gradd291,gradd292,gradd293,gradd294,gradd295,gradd296,gradd297,gradd298,gradd299,gradd300,
    gradd301,gradd302,gradd303,gradd304,gradd305,gradd306,gradd307,gradd308,gradd309,gradd310">
	
	<cfset status="The #getgeneral.layer#, #form.wos_group# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from icgroup where wos_group='#form.wos_group#'
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from icgroup where wos_group='#form.wos_group#'
			</cfquery>
				
			<cfset status="The #getgeneral.layer#, #form.wos_group# had been successfully deleted. ">	
		</cfif>
			
		<cfif form.mode eq "Edit">
			<!--- <cfupdate datasource='#dts#' tablename="icgroup" 
			formfields="wos_group,desp,salec,salecsc,salecnc,purc,purprc,meter_read,
			gradd11,gradd12,gradd13,gradd14,gradd15,gradd16,gradd17,gradd18,gradd19,gradd20,
			gradd21,gradd22,gradd23,gradd24,gradd25,gradd26,gradd27,gradd28,gradd29,gradd30,
			gradd31,gradd32,gradd33,gradd34,gradd35,gradd36,gradd37,gradd38,gradd39,gradd40,
			gradd41,gradd42,gradd43,gradd44,gradd45,gradd46,gradd47,gradd48,gradd49,gradd50,
			gradd51,gradd52,gradd53,gradd54,gradd55,gradd56,gradd57,gradd58,gradd59,gradd60,
			gradd61,gradd62,gradd63,gradd64,gradd65,gradd66,gradd67,gradd68,gradd69,gradd70"> --->
			<cfquery datasource='#dts#' name="updategroup">
				Update icgroup
				set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
				salec=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salec#">,
				salecsc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salecsc#">,
				salecnc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salecnc#">,
				purc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.purc#">,
				purprc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.purprc#">,
				meter_read=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.meter_read#">
				<cfloop from="11" to="310" index="i">
					,gradd#i#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form["gradd#i#"]#">
				</cfloop>
				where wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.wos_group#">
			</cfquery>
			
			<cfset status="The #getgeneral.layer#, #form.wos_group# had been successfully edited. ">
		</cfif>
				
	<cfelse>		
		<cfset status="Sorry, the #getgeneral.layer#, #form.wos_group# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_grouptable.cfm?type=icgroup&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>