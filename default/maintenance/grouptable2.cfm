<cfquery name="getgeneral" datasource='#dts#'>
	Select lgroup as layer,creditsales,cashsales,salesreturn,purchasereceive,purchasereturn from gsetup
</cfquery>

<html>
<head>
<title><cfoutput>#getgeneral.layer# Page</cfoutput></title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
	function validate()
	{
		if(document.group.wos_group.value=='')
		{
			alert("Your #getgeneral.layer#'s No. cannot be blank.");
			document.group.wos_group.focus();
			return false;
		}
		return true;
	}
	function change()
	{
		if(document.group.grade.value=='Grade Description')
			{
			document.group.grade.value='Close Grade';
			}
		else if(document.group.grade.value=='Close Grade')
			{
			document.group.grade.value='Grade Description';
			}
	}
</script>

<cfoutput>
<cfif isdefined("form.submit")>	
	<cfif form.submit eq "Close Grade">
		<form name="done" action="grouptable2.cfm?showgrade=no" method="post">
	<cfelseif form.submit eq "Grade Description">
		<form name="done" action="grouptable2.cfm?showgrade=yes" method="post">
	<cfelseif form.submit eq "Create" or form.submit eq "Edit" or form.submit eq "Delete">
		<form name="done" action="grouptableprocess.cfm" method="post" onSubmit="return validate()">
	</cfif>
		<input type="hidden" name="mode" value="#listfirst(mode)#">
		<input type="hidden" name="type" value="#listfirst(type)#">
		<input type="hidden" size="8" name="wos_group" value="#listfirst(wos_group)#" maxlength="8">
		<input type="hidden" size="40" name="desp" value="#listfirst(desp)#" maxlength="40">
		<cfif isdefined("form.meter_read")>
			<input type="hidden" size="1" name="meter_read" value="Y" maxlength="1">
		<cfelse>
			<input type="hidden" size="1" name="meter_read" value="N" maxlength="1">
		</cfif>
		<input type="hidden" size="8" name="SALEC" value="#listfirst(SALEC)#"  maxlength="8">
		<input type="hidden" size="8" name="PURC" value="#listfirst(PURC)#"  maxlength="8">
		<input type="hidden" size="8" name="PURPRC" value="#listfirst(PURPRC)#"  maxlength="8">
		<input type="hidden" size="8" name="SALECSC" value="#listfirst(SALECSC)#"  maxlength="8">
		<input type="hidden" size="8" name="SALECNC" value="#listfirst(SALECNC)#"  maxlength="8">
		<cfloop from="11" to="310" index="i">
			<input type="hidden" size="15" name="gradd#i#" value="#listfirst(form["gradd#i#"])#">
		</cfloop>
		<!--- <input type="hidden" size="15" name="gradd11" value="#listfirst(gradd11)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd12" value="#listfirst(gradd12)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd13" value="#listfirst(gradd13)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd14" value="#listfirst(gradd14)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd15" value="#listfirst(gradd15)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd16" value="#listfirst(gradd16)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd17" value="#listfirst(gradd17)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd18" value="#listfirst(gradd18)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd19" value="#listfirst(gradd19)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd20" value="#listfirst(gradd20)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd21" value="#listfirst(gradd21)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd22" value="#listfirst(gradd22)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd23" value="#listfirst(gradd23)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd24" value="#listfirst(gradd24)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd25" value="#listfirst(gradd25)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd26" value="#listfirst(gradd26)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd27" value="#listfirst(gradd27)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd28" value="#listfirst(gradd28)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd29" value="#listfirst(gradd29)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd30" value="#listfirst(gradd30)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd31" value="#listfirst(gradd31)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd32" value="#listfirst(gradd32)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd33" value="#listfirst(gradd33)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd34" value="#listfirst(gradd34)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd35" value="#listfirst(gradd35)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd36" value="#listfirst(gradd36)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd37" value="#listfirst(gradd37)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd38" value="#listfirst(gradd38)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd39" value="#listfirst(gradd39)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd40" value="#listfirst(gradd40)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd41" value="#listfirst(gradd41)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd42" value="#listfirst(gradd42)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd43" value="#listfirst(gradd43)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd44" value="#listfirst(gradd44)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd45" value="#listfirst(gradd45)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd46" value="#listfirst(gradd46)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd47" value="#listfirst(gradd47)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd48" value="#listfirst(gradd48)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd49" value="#listfirst(gradd49)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd50" value="#listfirst(gradd50)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd51" value="#listfirst(gradd51)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd52" value="#listfirst(gradd52)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd53" value="#listfirst(gradd53)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd54" value="#listfirst(gradd54)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd55" value="#listfirst(gradd55)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd56" value="#listfirst(gradd56)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd57" value="#listfirst(gradd57)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd58" value="#listfirst(gradd58)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd59" value="#listfirst(gradd59)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd60" value="#listfirst(gradd60)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd61" value="#listfirst(gradd61)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd62" value="#listfirst(gradd62)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd63" value="#listfirst(gradd63)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd64" value="#listfirst(gradd64)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd65" value="#listfirst(gradd65)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd66" value="#listfirst(gradd66)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd67" value="#listfirst(gradd67)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd68" value="#listfirst(gradd68)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd69" value="#listfirst(gradd69)#"  maxlength="15">
		<input type="hidden" size="15" name="gradd70" value="#listfirst(gradd70)#"  maxlength="15"> --->
	</form>
	<script language="javascript" type="text/javascript">
		done.submit();
	</script>
</cfif>
</cfoutput>

<cfif type neq "Create" and type neq "Create1">
	<cfif type eq "Edit1">
		<cfset wos_GROUP = listfirst(wos_GROUP)>
		<cfset desp = listfirst(desp)>
		
		<cfif isdefined("form.meter_read")>
			<cfset meter_read = "Y">
		<cfelse>
			<cfset meter_read = "N">
		</cfif>		

		<cfloop from="11" to="310" index="i">
			<cfset "gradd#i#" = listfirst(form["gradd#i#"])>
		</cfloop>
		<!--- <cfset gradd11 = listfirst(form.gradd11)>
		<cfset gradd12 = listfirst(form.gradd12)>
		<cfset gradd13 = listfirst(form.gradd13)>
		<cfset gradd14 = listfirst(form.gradd14)>
		<cfset gradd15 = listfirst(form.gradd15)>
		<cfset gradd16 = listfirst(form.gradd16)>
		<cfset gradd17 = listfirst(form.gradd17)>
		<cfset gradd18 = listfirst(form.gradd18)>
		<cfset gradd19 = listfirst(form.gradd19)>
		<cfset gradd20 = listfirst(form.gradd20)>
		<cfset gradd21 = listfirst(form.gradd21)>
		<cfset gradd22 = listfirst(form.gradd22)>
		<cfset gradd23 = listfirst(form.gradd23)>
		<cfset gradd24 = listfirst(form.gradd24)>
		<cfset gradd25 = listfirst(form.gradd25)>
		<cfset gradd26 = listfirst(form.gradd26)>
		<cfset gradd27 = listfirst(form.gradd27)>
		<cfset gradd28 = listfirst(form.gradd28)>
		<cfset gradd29 = listfirst(form.gradd29)>
		<cfset gradd30 = listfirst(form.gradd30)>
		<cfset gradd31 = listfirst(form.gradd31)>
		<cfset gradd32 = listfirst(form.gradd32)>
		<cfset gradd33 = listfirst(form.gradd33)>
		<cfset gradd34 = listfirst(form.gradd34)>
		<cfset gradd35 = listfirst(form.gradd35)>
		<cfset gradd36 = listfirst(form.gradd36)>
		<cfset gradd37 = listfirst(form.gradd37)>
		<cfset gradd38 = listfirst(form.gradd38)>
		<cfset gradd39 = listfirst(form.gradd39)>
		<cfset gradd40 = listfirst(form.gradd40)>
		<cfset gradd41 = listfirst(form.gradd41)>
		<cfset gradd42 = listfirst(form.gradd42)>
		<cfset gradd43 = listfirst(form.gradd43)>
		<cfset gradd44 = listfirst(form.gradd44)>
		<cfset gradd45 = listfirst(form.gradd45)>
		<cfset gradd46 = listfirst(form.gradd46)>
		<cfset gradd47 = listfirst(form.gradd47)>
		<cfset gradd48 = listfirst(form.gradd48)>
		<cfset gradd49 = listfirst(form.gradd49)>
		<cfset gradd50 = listfirst(form.gradd50)>
		<cfset gradd51 = listfirst(form.gradd51)>
		<cfset gradd52 = listfirst(form.gradd52)>
		<cfset gradd53 = listfirst(form.gradd53)>
		<cfset gradd54 = listfirst(form.gradd54)>
		<cfset gradd55 = listfirst(form.gradd55)>
		<cfset gradd56 = listfirst(form.gradd56)>
		<cfset gradd57 = listfirst(form.gradd57)>
		<cfset gradd58 = listfirst(form.gradd58)>
		<cfset gradd59 = listfirst(form.gradd59)>
		<cfset gradd60 = listfirst(form.gradd60)>
		<cfset gradd61 = listfirst(form.gradd61)>
		<cfset gradd62 = listfirst(form.gradd62)>
		<cfset gradd63 = listfirst(form.gradd63)>
		<cfset gradd64 = listfirst(form.gradd64)>
		<cfset gradd65 = listfirst(form.gradd65)>
		<cfset gradd66 = listfirst(form.gradd66)>
		<cfset gradd67 = listfirst(form.gradd67)>
		<cfset gradd68 = listfirst(form.gradd68)>
		<cfset gradd69 = listfirst(form.gradd69)>
		<cfset gradd70 = listfirst(form.gradd70)> --->
	<cfelseif type eq "Edit" or type eq "Delete">
		<cfquery datasource='#dts#' name="getitem">
			Select * from icgroup where wos_group='#wos_group#'
		</cfquery>
		
		<cfset wos_GROUP=getitem.wos_GROUP>
		<cfset desp=getitem.desp>
		<cfset SALEC=getitem.SALEC>
		<cfset SALECSC=getitem.SALECSC>
		<cfset SALECNC=getitem.SALECNC>
		<cfset PURC=getitem.PURC>
		<cfset PURPRC=getitem.PURPRC>
		<cfset meter_read = getitem.meter_read>
		
		<cfloop from="11" to="310" index="i">
			<cfset "gradd#i#" = listfirst(getitem["gradd#i#"][1])>
		</cfloop>
		<!--- <cfset gradd11 = getitem.gradd11>
		<cfset gradd12 = getitem.gradd12>
		<cfset gradd13 = getitem.gradd13>
		<cfset gradd14 = getitem.gradd14>
		<cfset gradd15 = getitem.gradd15>
		<cfset gradd16 = getitem.gradd16>
		<cfset gradd17 = getitem.gradd17>
		<cfset gradd18 = getitem.gradd18>
		<cfset gradd19 = getitem.gradd19>
		<cfset gradd20 = getitem.gradd20>
		<cfset gradd21 = getitem.gradd21>
		<cfset gradd22 = getitem.gradd22>
		<cfset gradd23 = getitem.gradd23>
		<cfset gradd24 = getitem.gradd24>
		<cfset gradd25 = getitem.gradd25>
		<cfset gradd26 = getitem.gradd26>
		<cfset gradd27 = getitem.gradd27>
		<cfset gradd28 = getitem.gradd28>
		<cfset gradd29 = getitem.gradd29>
		<cfset gradd30 = getitem.gradd30>
		<cfset gradd31 = getitem.gradd31>
		<cfset gradd32 = getitem.gradd32>
		<cfset gradd33 = getitem.gradd33>
		<cfset gradd34 = getitem.gradd34>
		<cfset gradd35 = getitem.gradd35>
		<cfset gradd36 = getitem.gradd36>
		<cfset gradd37 = getitem.gradd37>
		<cfset gradd38 = getitem.gradd38>
		<cfset gradd39 = getitem.gradd39>
		<cfset gradd40 = getitem.gradd40>
		<cfset gradd41 = getitem.gradd41>
		<cfset gradd42 = getitem.gradd42>
		<cfset gradd43 = getitem.gradd43>
		<cfset gradd44 = getitem.gradd44>
		<cfset gradd45 = getitem.gradd45>
		<cfset gradd46 = getitem.gradd46>
		<cfset gradd47 = getitem.gradd47>
		<cfset gradd48 = getitem.gradd48>
		<cfset gradd49 = getitem.gradd49>
		<cfset gradd50 = getitem.gradd50>
		<cfset gradd51 = getitem.gradd51>
		<cfset gradd52 = getitem.gradd52>
		<cfset gradd53 = getitem.gradd53>
		<cfset gradd54 = getitem.gradd54>
		<cfset gradd55 = getitem.gradd55>
		<cfset gradd56 = getitem.gradd56>
		<cfset gradd57 = getitem.gradd57>
		<cfset gradd58 = getitem.gradd58>
		<cfset gradd59 = getitem.gradd59>
		<cfset gradd60 = getitem.gradd60>
		<cfset gradd61 = getitem.gradd61>
		<cfset gradd62 = getitem.gradd62>
		<cfset gradd63 = getitem.gradd63>
		<cfset gradd64 = getitem.gradd64>
		<cfset gradd65 = getitem.gradd65>
		<cfset gradd66 = getitem.gradd66>
		<cfset gradd67 = getitem.gradd67>
		<cfset gradd68 = getitem.gradd68>
		<cfset gradd69 = getitem.gradd69>
		<cfset gradd70 = getitem.gradd70> --->
	</cfif>

	<cfif type eq "Edit" or type eq "Edit1">
		<cfset mode="Edit">
		<cfset title="Edit Group">
		<cfset button="Edit">
	<cfelse>
		<cfset mode="Delete">
		<cfset title="Delete Group">
		<cfset button="Delete">
	</cfif>
<cfelse>
	<cfset SALEC=getgeneral.creditsales>
	<cfset SALECSC=getgeneral.cashsales>
	<cfset SALECNC=getgeneral.salesreturn>
	<cfset PURC=getgeneral.purchasereceive>
	<cfset PURPRC=getgeneral.purchasereturn>
	
	<cfif type eq "Create1" or type eq "Edit1" or type eq "Edit">
		<cfset wos_GROUP = listfirst(wos_GROUP)>
		<cfset desp = listfirst(desp)>
		
		<cfif isdefined("form.meter_read")>
			<cfset meter_read = "Y">
		<cfelse>
			<cfset meter_read = "N">
		</cfif>
		
		<cfloop from="11" to="310" index="i">
			<cfset "gradd#i#" = listfirst(form["gradd#i#"])>
		</cfloop>
		<!--- <cfset gradd11 = listfirst(form.gradd11)>
		<cfset gradd12 = listfirst(form.gradd12)>
		<cfset gradd13 = listfirst(form.gradd13)>
		<cfset gradd14 = listfirst(form.gradd14)>
		<cfset gradd15 = listfirst(form.gradd15)>
		<cfset gradd16 = listfirst(form.gradd16)>
		<cfset gradd17 = listfirst(form.gradd17)>
		<cfset gradd18 = listfirst(form.gradd18)>
		<cfset gradd19 = listfirst(form.gradd19)>
		<cfset gradd20 = listfirst(form.gradd20)>
		<cfset gradd21 = listfirst(form.gradd21)>
		<cfset gradd22 = listfirst(form.gradd22)>
		<cfset gradd23 = listfirst(form.gradd23)>
		<cfset gradd24 = listfirst(form.gradd24)>
		<cfset gradd25 = listfirst(form.gradd25)>
		<cfset gradd26 = listfirst(form.gradd26)>
		<cfset gradd27 = listfirst(form.gradd27)>
		<cfset gradd28 = listfirst(form.gradd28)>
		<cfset gradd29 = listfirst(form.gradd29)>
		<cfset gradd30 = listfirst(form.gradd30)>
		<cfset gradd31 = listfirst(form.gradd31)>
		<cfset gradd32 = listfirst(form.gradd32)>
		<cfset gradd33 = listfirst(form.gradd33)>
		<cfset gradd34 = listfirst(form.gradd34)>
		<cfset gradd35 = listfirst(form.gradd35)>
		<cfset gradd36 = listfirst(form.gradd36)>
		<cfset gradd37 = listfirst(form.gradd37)>
		<cfset gradd38 = listfirst(form.gradd38)>
		<cfset gradd39 = listfirst(form.gradd39)>
		<cfset gradd40 = listfirst(form.gradd40)>
		<cfset gradd41 = listfirst(form.gradd41)>
		<cfset gradd42 = listfirst(form.gradd42)>
		<cfset gradd43 = listfirst(form.gradd43)>
		<cfset gradd44 = listfirst(form.gradd44)>
		<cfset gradd45 = listfirst(form.gradd45)>
		<cfset gradd46 = listfirst(form.gradd46)>
		<cfset gradd47 = listfirst(form.gradd47)>
		<cfset gradd48 = listfirst(form.gradd48)>
		<cfset gradd49 = listfirst(form.gradd49)>
		<cfset gradd50 = listfirst(form.gradd50)>
		<cfset gradd51 = listfirst(form.gradd51)>
		<cfset gradd52 = listfirst(form.gradd52)>
		<cfset gradd53 = listfirst(form.gradd53)>
		<cfset gradd54 = listfirst(form.gradd54)>
		<cfset gradd55 = listfirst(form.gradd55)>
		<cfset gradd56 = listfirst(form.gradd56)>
		<cfset gradd57 = listfirst(form.gradd57)>
		<cfset gradd58 = listfirst(form.gradd58)>
		<cfset gradd59 = listfirst(form.gradd59)>
		<cfset gradd60 = listfirst(form.gradd60)>
		<cfset gradd61 = listfirst(form.gradd61)>
		<cfset gradd62 = listfirst(form.gradd62)>
		<cfset gradd63 = listfirst(form.gradd63)>
		<cfset gradd64 = listfirst(form.gradd64)>
		<cfset gradd65 = listfirst(form.gradd65)>
		<cfset gradd66 = listfirst(form.gradd66)>
		<cfset gradd67 = listfirst(form.gradd67)>
		<cfset gradd68 = listfirst(form.gradd68)>
		<cfset gradd69 = listfirst(form.gradd69)>
		<cfset gradd70 = listfirst(form.gradd70)> --->
	<cfelse>
		<cfset wos_GROUP = "">
		<cfset desp = "">
		<cfset meter_read = "N">
		
		<cfloop from="11" to="310" index="i">
			<cfset "gradd#i#" = "">
		</cfloop>
		<!--- <cfset gradd11 = "">
		<cfset gradd12 = "">
		<cfset gradd13 = "">
		<cfset gradd14 = "">
		<cfset gradd15 = "">
		<cfset gradd16 = "">
		<cfset gradd17 = "">
		<cfset gradd18 = "">
		<cfset gradd19 = "">
		<cfset gradd20 = "">
		<cfset gradd21 = "">
		<cfset gradd22 = "">
		<cfset gradd23 = "">
		<cfset gradd24 = "">
		<cfset gradd25 = "">
		<cfset gradd26 = "">
		<cfset gradd27 = "">
		<cfset gradd28 = "">
		<cfset gradd29 = "">
		<cfset gradd30 = "">
		<cfset gradd31 = "">
		<cfset gradd32 = "">
		<cfset gradd33 = "">
		<cfset gradd34 = "">
		<cfset gradd35 = "">
		<cfset gradd36 = "">
		<cfset gradd37 = "">
		<cfset gradd38 = "">
		<cfset gradd39 = "">
		<cfset gradd40 = "">
		<cfset gradd41 = "">
		<cfset gradd42 = "">
		<cfset gradd43 = "">
		<cfset gradd44 = "">
		<cfset gradd45 = "">
		<cfset gradd46 = "">
		<cfset gradd47 = "">
		<cfset gradd48 = "">
		<cfset gradd49 = "">
		<cfset gradd50 = "">
		<cfset gradd51 = "">
		<cfset gradd52 = "">
		<cfset gradd53 = "">
		<cfset gradd54 = "">
		<cfset gradd55 = "">
		<cfset gradd56 = "">
		<cfset gradd57 = "">
		<cfset gradd58 = "">
		<cfset gradd59 = "">
		<cfset gradd60 = "">
		<cfset gradd61 = "">
		<cfset gradd62 = "">
		<cfset gradd63 = "">
		<cfset gradd64 = "">
		<cfset gradd65 = "">
		<cfset gradd66 = "">
		<cfset gradd67 = "">
		<cfset gradd68 = "">
		<cfset gradd69 = "">
		<cfset gradd70 = ""> --->
	</cfif>
	
	<cfset mode="Create">
	<cfset title="Create Group">
	<cfset button="Create">
</cfif>

<body>
<cfoutput>
<h1>#title#</h1>

<h4>
   	<cfif getpin2.h1510 eq 'T'><a href="grouptable2.cfm?type=Create">Creating a New #getgeneral.layer#</a> </cfif>
	<cfif getpin2.h1520 eq 'T'>|| <a href="grouptable.cfm">List all #getgeneral.layer#</a> </cfif>
	<cfif getpin2.h1530 eq 'T'>|| <a href="s_grouptable.cfm?type=Icitem">Search For #getgeneral.layer#</a> </cfif>
	<cfif getpin2.h1540 eq 'T'>|| <a href="p_group.cfm">#getgeneral.layer# Listing</a></cfif>
</h4>

<form name="group" action="grouptable2.cfm" method="post">
	<input type="hidden" name="mode" value="#mode#">
	<cfif type eq "Create" or type eq "Create1">
		<input type="hidden" name="type" value="Create1">
	<cfelseif type eq "Edit" or type eq "Edit1">
		<input type="hidden" name="type" value="Edit1">
	<cfelse>
		<input type="hidden" name="type" value="#type#">
	</cfif>
	<h1 align="center">#getgeneral.layer# File Maintenance</h1>
  	
	<table align="center" class="data" width="800">
      	<tr> 
        	<td width="15%" nowrap>#getgeneral.layer# :</td>
        	<td colspan="4">
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="24" name="wos_group" value="#wos_group#" maxlength="24" readonly>
            <cfelse>
            	<input type="text" size="24" name="wos_group" value="#wos_group#" maxlength="24">
          	</cfif>
			</td>
      	</tr>
      	<tr> 
        	<td>Description:</td>
        	<td colspan="4"><input type="text" size="40" name="desp" value="#desp#" maxlength="40"></td>
      	</tr>
		<tr> 
			<td colspan="100%"><hr></td>
		</tr>
		<tr> 
			<td colspan="5"><div align="center"><strong>Product Details</strong></div></td>
		</tr>
		<tr align="center"> 
			<td align="left">Credit Sales :</td>
			<td align="left"><input name="SALEC" type="text" id="SALEC" value="#SALEC#" size="8" maxlength="8" onClick="select();"></td>
			<td align="left">Purchase :</td>
			<td align="left"><input name="PURC" type="text" id="PURC" value="#PURC#" size="8" maxlength="8" onClick="select();"></td>
			<td>&nbsp;</td>
		<tr align="center"> 
			<td align="left">Cash Sales :</td>
			<td align="left"><input name="SALECSC" type="text" id="SALECSC" value="#SALECSC#" size="8" maxlength="8" onClick="select();"></td>
			<td align="left">Purchase Return :</td>
			<td align="left"><input name="PURPRC" type="text" id="PURPRC" value="#PURPRC#" size="8" maxlength="8" onClick="select();"></td>
			<td>&nbsp;</td>
		</tr>
		<tr align="center">
			<td align="left">Sales Return :</td>
			<td align="left"><input name="SALECNC" type="text" id="SALECNC" value="#SALECNC#" size="8" maxlength="8" onClick="select();"></td>
			<td align="left">Meter Reading :</td>
			<td align="left"><cfif meter_read eq "Y">
								<input name="meter_read" type="checkbox" id="meter_read" value="Y" checked>
							<cfelse>
								<input name="meter_read" type="checkbox" id="meter_read" value="Y">
							</cfif>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<cfif isdefined("showgrade") and showgrade eq "yes">
			<tr> 
				<td colspan="100%"><hr></td>
			</tr>
			<cfset totcol = 5>
			<cfset firstcount = 11>
			<cfset maxcounter = 310>
			<cfset totalrecord = (maxcounter - firstcount + 1)>
			<cfset totrow = ceiling(totalrecord / totcol)>
			<cfloop from="1" to="#totrow#" index="i">
				<tr align="center">
					<cfloop from="0" to="#totcol-1#" index="j">
						<cfset thisrecord = i+(j*totrow)>
						<cfif thisrecord LTE totalrecord>
								<td>#thisrecord#  .<input name="gradd#thisrecord+10#" type="text" value="#variables["gradd#thisrecord+10#"]#" size="15" maxlength="15" onClick="select();"></td>
						</cfif>
					</cfloop>
				</tr>
			</cfloop>
			<!--- <tr align="center">
				<td>1  .<input name="gradd11" type="text" value="#gradd11#" size="15" maxlength="15" onClick="select();"></td>
				<td>16.<input name="gradd26" type="text" value="#gradd26#" size="15" maxlength="15" onClick="select();"></td>
				<td>31.<input name="gradd41" type="text" value="#gradd41#" size="15" maxlength="15" onClick="select();"></td>
				<td>46.<input name="gradd56" type="text" value="#gradd56#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>2  .<input name="gradd12" type="text" value="#gradd12#" size="15" maxlength="15" onClick="select();"></td>
				<td>17.<input name="gradd27" type="text" value="#gradd27#" size="15" maxlength="15" onClick="select();"></td>
				<td>32.<input name="gradd42" type="text" value="#gradd42#" size="15" maxlength="15" onClick="select();"></td>
				<td>47.<input name="gradd57" type="text" value="#gradd57#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>3  .<input name="gradd13" type="text" value="#gradd13#" size="15" maxlength="15" onClick="select();"></td>
				<td>18.<input name="gradd28" type="text" value="#gradd28#" size="15" maxlength="15" onClick="select();"></td>
				<td>33.<input name="gradd43" type="text" value="#gradd43#" size="15" maxlength="15" onClick="select();"></td>
				<td>48.<input name="gradd58" type="text" value="#gradd58#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>4  .<input name="gradd14" type="text" value="#gradd14#" size="15" maxlength="15" onClick="select();"></td>
				<td>19.<input name="gradd29" type="text" value="#gradd29#" size="15" maxlength="15" onClick="select();"></td>
				<td>34.<input name="gradd44" type="text" value="#gradd44#" size="15" maxlength="15" onClick="select();"></td>
				<td>49.<input name="gradd59" type="text" value="#gradd59#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>5  .<input name="gradd15" type="text" value="#gradd15#" size="15" maxlength="15" onClick="select();"></td>
				<td>20.<input name="gradd30" type="text" value="#gradd30#" size="15" maxlength="15" onClick="select();"></td>
				<td>35.<input name="gradd45" type="text" value="#gradd45#" size="15" maxlength="15" onClick="select();"></td>
				<td>50.<input name="gradd60" type="text" value="#gradd60#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>6  .<input name="gradd16" type="text" value="#gradd16#" size="15" maxlength="15" onClick="select();"></td>
				<td>21.<input name="gradd31" type="text" value="#gradd31#" size="15" maxlength="15" onClick="select();"></td>
				<td>36.<input name="gradd46" type="text" value="#gradd46#" size="15" maxlength="15" onClick="select();"></td>
				<td>51.<input name="gradd61" type="text" value="#gradd61#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>7  .<input name="gradd17" type="text" value="#gradd17#" size="15" maxlength="15" onClick="select();"></td>
				<td>22.<input name="gradd32" type="text" value="#gradd32#" size="15" maxlength="15" onClick="select();"></td>
				<td>37.<input name="gradd47" type="text" value="#gradd47#" size="15" maxlength="15" onClick="select();"></td>
				<td>52.<input name="gradd62" type="text" value="#gradd62#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>8  .<input name="gradd18" type="text" value="#gradd18#" size="15" maxlength="15" onClick="select();"></td>
				<td>23.<input name="gradd33" type="text" value="#gradd33#" size="15" maxlength="15" onClick="select();"></td>
				<td>38.<input name="gradd48" type="text" value="#gradd48#" size="15" maxlength="15" onClick="select();"></td>
				<td>53.<input name="gradd63" type="text" value="#gradd63#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>9  .<input name="gradd19" type="text" value="#gradd19#" size="15" maxlength="15" onClick="select();"></td>
				<td>24.<input name="gradd34" type="text" value="#gradd34#" size="15" maxlength="15" onClick="select();"></td>
				<td>39.<input name="gradd49" type="text" value="#gradd49#" size="15" maxlength="15" onClick="select();"></td>
				<td>54.<input name="gradd64" type="text" value="#gradd64#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>10.<input name="gradd20" type="text" value="#gradd20#" size="15" maxlength="15" onClick="select();"></td>
				<td>25.<input name="gradd35" type="text" value="#gradd35#" size="15" maxlength="15" onClick="select();"></td>
				<td>40.<input name="gradd50" type="text" value="#gradd50#" size="15" maxlength="15" onClick="select();"></td>
				<td>55.<input name="gradd65" type="text" value="#gradd65#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>11.<input name="gradd21" type="text" value="#gradd21#" size="15" maxlength="15" onClick="select();"></td>
				<td>26.<input name="gradd36" type="text" value="#gradd36#" size="15" maxlength="15" onClick="select();"></td>
				<td>41.<input name="gradd51" type="text" value="#gradd51#" size="15" maxlength="15" onClick="select();"></td>
				<td>56.<input name="gradd66" type="text" value="#gradd66#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>12.<input name="gradd22" type="text" value="#gradd22#" size="15" maxlength="15" onClick="select();"></td>
				<td>27.<input name="gradd37" type="text" value="#gradd37#" size="15" maxlength="15" onClick="select();"></td>
				<td>42.<input name="gradd52" type="text" value="#gradd52#" size="15" maxlength="15" onClick="select();"></td>
				<td>57.<input name="gradd67" type="text" value="#gradd67#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>13.<input name="gradd23" type="text" value="#gradd23#" size="15" maxlength="15" onClick="select();"></td>
				<td>28.<input name="gradd38" type="text" value="#gradd38#" size="15" maxlength="15" onClick="select();"></td>
				<td>43.<input name="gradd53" type="text" value="#gradd53#" size="15" maxlength="15" onClick="select();"></td>
				<td>58.<input name="gradd68" type="text" value="#gradd68#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>14.<input name="gradd24" type="text" value="#gradd24#" size="15" maxlength="15" onClick="select();"></td>
				<td>29.<input name="gradd39" type="text" value="#gradd39#" size="15" maxlength="15" onClick="select();"></td>
				<td>44.<input name="gradd54" type="text" value="#gradd54#" size="15" maxlength="15" onClick="select();"></td>
				<td>59.<input name="gradd69" type="text" value="#gradd69#" size="15" maxlength="15" onClick="select();"></td>
			</tr>
			<tr align="center">
				<td>15.<input name="gradd25" type="text" value="#gradd25#" size="15" maxlength="15" onClick="select();"></td>
				<td>30.<input name="gradd40" type="text" value="#gradd40#" size="15" maxlength="15" onClick="select();"></td>
				<td>45.<input name="gradd55" type="text" value="#gradd55#" size="15" maxlength="15" onClick="select();"></td>
				<td>60.<input name="gradd70" type="text" value="#gradd70#" size="15" maxlength="15" onClick="select();"></td>
			</tr> --->
		<cfelseif (isdefined("showgrade") and showgrade eq "no") and (type eq "Create1" or type eq "Edit" or type eq "Edit1")>
			<input type="hidden" name="mode" value="#mode#">
			<input type="hidden" size="8" name="wos_group" value="#wos_group#" maxlength="8">
			<input type="hidden" size="40" name="desp" value="#desp#" maxlength="40">
			
			<cfloop from="11" to="310" index="i">
				<input type="hidden" size="15" name="gradd#i#" value="#variables["gradd#i#"]#">
			</cfloop>
			<!--- <input type="hidden" size="15" name="gradd11" value="#gradd11#"  maxlength="15">
			<input type="hidden" size="15" name="gradd12" value="#gradd12#"  maxlength="15">
			<input type="hidden" size="15" name="gradd13" value="#gradd13#"  maxlength="15">
			<input type="hidden" size="15" name="gradd14" value="#gradd14#"  maxlength="15">
			<input type="hidden" size="15" name="gradd15" value="#gradd15#"  maxlength="15">
			<input type="hidden" size="15" name="gradd16" value="#gradd16#"  maxlength="15">
			<input type="hidden" size="15" name="gradd17" value="#gradd17#"  maxlength="15">
			<input type="hidden" size="15" name="gradd18" value="#gradd18#"  maxlength="15">
			<input type="hidden" size="15" name="gradd19" value="#gradd19#"  maxlength="15">
			<input type="hidden" size="15" name="gradd20" value="#gradd20#"  maxlength="15">
			<input type="hidden" size="15" name="gradd21" value="#gradd21#"  maxlength="15">
			<input type="hidden" size="15" name="gradd22" value="#gradd22#"  maxlength="15">
			<input type="hidden" size="15" name="gradd23" value="#gradd23#"  maxlength="15">
			<input type="hidden" size="15" name="gradd24" value="#gradd24#"  maxlength="15">
			<input type="hidden" size="15" name="gradd25" value="#gradd25#"  maxlength="15">
			<input type="hidden" size="15" name="gradd26" value="#gradd26#"  maxlength="15">
			<input type="hidden" size="15" name="gradd27" value="#gradd27#"  maxlength="15">
			<input type="hidden" size="15" name="gradd28" value="#gradd28#"  maxlength="15">
			<input type="hidden" size="15" name="gradd29" value="#gradd29#"  maxlength="15">
			<input type="hidden" size="15" name="gradd30" value="#gradd30#"  maxlength="15">
			<input type="hidden" size="15" name="gradd31" value="#gradd31#"  maxlength="15">
			<input type="hidden" size="15" name="gradd32" value="#gradd32#"  maxlength="15">
			<input type="hidden" size="15" name="gradd33" value="#gradd33#"  maxlength="15">
			<input type="hidden" size="15" name="gradd34" value="#gradd34#"  maxlength="15">
			<input type="hidden" size="15" name="gradd35" value="#gradd35#"  maxlength="15">
			<input type="hidden" size="15" name="gradd36" value="#gradd36#"  maxlength="15">
			<input type="hidden" size="15" name="gradd37" value="#gradd37#"  maxlength="15">
			<input type="hidden" size="15" name="gradd38" value="#gradd38#"  maxlength="15">
			<input type="hidden" size="15" name="gradd39" value="#gradd39#"  maxlength="15">
			<input type="hidden" size="15" name="gradd40" value="#gradd40#"  maxlength="15">
			<input type="hidden" size="15" name="gradd41" value="#gradd41#"  maxlength="15">
			<input type="hidden" size="15" name="gradd42" value="#gradd42#"  maxlength="15">
			<input type="hidden" size="15" name="gradd43" value="#gradd43#"  maxlength="15">
			<input type="hidden" size="15" name="gradd44" value="#gradd44#"  maxlength="15">
			<input type="hidden" size="15" name="gradd45" value="#gradd45#"  maxlength="15">
			<input type="hidden" size="15" name="gradd46" value="#gradd46#"  maxlength="15">
			<input type="hidden" size="15" name="gradd47" value="#gradd47#"  maxlength="15">
			<input type="hidden" size="15" name="gradd48" value="#gradd48#"  maxlength="15">
			<input type="hidden" size="15" name="gradd49" value="#gradd49#"  maxlength="15">
			<input type="hidden" size="15" name="gradd50" value="#gradd50#"  maxlength="15">
			<input type="hidden" size="15" name="gradd51" value="#gradd51#"  maxlength="15">
			<input type="hidden" size="15" name="gradd52" value="#gradd52#"  maxlength="15">
			<input type="hidden" size="15" name="gradd53" value="#gradd53#"  maxlength="15">
			<input type="hidden" size="15" name="gradd54" value="#gradd54#"  maxlength="15">
			<input type="hidden" size="15" name="gradd55" value="#gradd55#"  maxlength="15">
			<input type="hidden" size="15" name="gradd56" value="#gradd56#"  maxlength="15">
			<input type="hidden" size="15" name="gradd57" value="#gradd57#"  maxlength="15">
			<input type="hidden" size="15" name="gradd58" value="#gradd58#"  maxlength="15">
			<input type="hidden" size="15" name="gradd59" value="#gradd59#"  maxlength="15">
			<input type="hidden" size="15" name="gradd60" value="#gradd60#"  maxlength="15">
			<input type="hidden" size="15" name="gradd61" value="#gradd61#"  maxlength="15">
			<input type="hidden" size="15" name="gradd62" value="#gradd62#"  maxlength="15">
			<input type="hidden" size="15" name="gradd63" value="#gradd63#"  maxlength="15">
			<input type="hidden" size="15" name="gradd64" value="#gradd64#"  maxlength="15">
			<input type="hidden" size="15" name="gradd65" value="#gradd65#"  maxlength="15">
			<input type="hidden" size="15" name="gradd66" value="#gradd66#"  maxlength="15">
			<input type="hidden" size="15" name="gradd67" value="#gradd67#"  maxlength="15">
			<input type="hidden" size="15" name="gradd68" value="#gradd68#"  maxlength="15">
			<input type="hidden" size="15" name="gradd69" value="#gradd69#"  maxlength="15">
			<input type="hidden" size="15" name="gradd70" value="#gradd70#"  maxlength="15"> --->
		<cfelse>
			<cfloop from="11" to="310" index="a">
				<input type="hidden" name="gradd#a#" value="" size="15" maxlength="15">
			</cfloop> 
		</cfif>
		<tr align="center"> 
			<td colspan="5" align="center">
			<input name="grade" type="submit"
				<cfif isdefined("showgrade") and showgrade eq "yes">
					value="Close Grade">
					<input type="hidden" name="showgrade" value="no">
				<cfelse>
					value="Grade Description">
					<input type="hidden" name="showgrade" value="yes">
				</cfif>
			<input name="submit" type="submit" value="#button#">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

</body>
</html>