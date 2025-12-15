<cfparam name="status" default="">

<cfif submit eq 'Edit Opening Quantity' or submit eq 'Generate Item No'>
	
	<cfquery datasource='#dts#' name="checkitemExist">
	 	Select * from icmitem 
	 	where mitemno = '#form.mitemno#'
 	</cfquery>

	<cfif checkitemExist.recordcount gt 0>
		<cfquery name="update" datasource="#dts#">
			update icmitem
			set desp = '#form.desp#',
			despa = '#form.despa#',
			aitemno = '#form.AITEMNO#',
			unit = '#form.UNIT#',
			ucost = '#val(form.UCOST)#',
			price = '#form.PRICE#',
            price2 = '#val(form.price2)#',
            price3 = '#val(form.price3)#',
            muratio = '#val(form.muratio)#',
			category = '#form.CATEGORY#',
			wos_group = '#form.WOS_GROUP#',
            sizeid = '#form.sizeid#',
			brand = '#form.BRAND#',
			supp = '#form.supp#',
			colorno = '#form.colorno#',
			sizecolor = '#form.sizecolor#',
			<cfloop from="1" to="20" index="i">
				color#i# = '#form["color#i#"]#',
				size#i# = '#form["size#i#"]#',
			</cfloop>
			updated_by = '#HUserID#',
			updated_on = #now()#
			where mitemno = '#form.mitemno#'
		</cfquery>
		<!--- <cfset status="The Matrix Item, #form.mitemno# had been successfully edited. "> --->
	<cfelse>
		<cfquery name="insert" datasource="#dts#">
			insert into icmitem
			(mitemno,desp,despa,aitemno,unit,ucost,price,category,wos_group,brand,supp,colorno,sizecolor,sizeid,price2,price3,muratio,
			<cfloop from="1" to="20" index="i">
				color#i#,size#i#,
			</cfloop>
			created_by,created_on,updated_by,updated_on 
			)
			values
			('#form.mitemno#','#form.desp#','#form.despa#','#form.AITEMNO#','#form.UNIT#','#val(form.UCOST)#','#form.PRICE#',
			'#form.CATEGORY#','#form.WOS_GROUP#','#form.BRAND#','#form.supp#','#form.colorno#','#form.sizecolor#','#form.sizeid#','#val(form.price2)#','#val(form.price3)#','#val(form.muratio)#',
			<cfloop from="1" to="20" index="i">
				'#form["color#i#"]#','#form["size#i#"]#',
			</cfloop>
			'#HUserID#',#now()#,'#HUserID#',#now()#
			)
		</cfquery>
		<!--- <cfset status="The Matrix Item, #form.mitemno# had been successfully created. "> --->
	</cfif>
	
	<cfset counter = 0>
	<cfif form.sizecolor eq "SC">
		<cfloop from="1" to="20" index="i">
			<cfset thiscolor = Evaluate("form.color#i#")>
			<cfif thiscolor neq "">
				<cfloop from="1" to="20" index="j">
					<cfset thissize = Evaluate("form.size#j#")>
					<cfif thissize neq "">
						<cfif isdefined("form.inserthyphen") and form.inserthyphen eq "on">
							<cfset thisitemno = form.mitemno&'-'&thiscolor&'-'&thissize>
						<cfelse>
							<cfset thisitemno = form.mitemno&thiscolor&thissize>
						</cfif>
						<cfquery name="checkitemExist1" datasource="#dts#">
 	 						select * from icitem where itemno = '#thisitemno#' 
 	 					</cfquery>
						<cfif checkitemExist1.recordcount eq 0>
							<cfif isdefined("form.insertcolorsize") and form.insertcolorsize eq "on">
								<cfset thisdesp = form.desp&' ('&thiscolor&'/'&thissize&')'>
							<cfelse>
								<cfset thisdesp = form.desp>
							</cfif>
						
							<cfquery name="insertitem" datasource="#dts#">
								insert into icitem 
								(itemno,aitemno,desp,despa,brand,category,wos_group,unit,ucost,price,supp,sizeid,price2,price3,muratio)
								values 
								('#thisitemno#','#form.AITEMNO#','#thisdesp#','#form.despa#','#form.BRAND#','#form.CATEGORY#','#form.WOS_GROUP#',
								'#form.UNIT#','#val(form.UCOST)#','#form.PRICE#','#form.supp#','#form.sizeid#','#val(form.price2)#','#val(form.price3)#','#val(form.muratio)#')
							</cfquery>
							<cfset counter = counter + 1>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	<cfelseif form.sizecolor eq "S">
		<cfloop from="1" to="20" index="j">
			<cfset thissize = form["size#j#"]>
			<cfif thissize neq "">
				<cfif isdefined("form.inserthyphen") and form.inserthyphen eq "on">
					<cfset thisitemno = form.mitemno&'-'&thissize>
				<cfelse>
					<cfset thisitemno = form.mitemno&thissize>
				</cfif>
				<cfquery name="checkitemExist1" datasource="#dts#">
 	 				select * from icitem where itemno = '#thisitemno#' 
 	 			</cfquery>
				<cfif checkitemExist1.recordcount eq 0>
					<cfif isdefined("form.insertcolorsize") and form.insertcolorsize eq "on">
						<cfset thisdesp = form.desp&' ('&thissize&')'>
					<cfelse>
						<cfset thisdesp = form.desp>
					</cfif>
						
					<cfquery name="insertitem" datasource="#dts#">
						insert into icitem 
						(itemno,aitemno,desp,despa,brand,category,wos_group,unit,ucost,price,supp,sizeid,price2,price3,muratio)
						values 
						('#thisitemno#','#form.AITEMNO#','#thisdesp#','#form.despa#','#form.BRAND#','#form.CATEGORY#','#form.WOS_GROUP#',
						'#form.UNIT#','#val(form.UCOST)#','#form.PRICE#','#form.supp#','#form.sizeid#','#val(form.price2)#','#val(form.price3)#','#val(form.muratio)#')
					</cfquery>
					<cfset counter = counter + 1>
				</cfif>
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop from="1" to="20" index="j">
			<cfset thiscolor = form["color#j#"]>
			<cfif thiscolor neq "">
				<cfif isdefined("form.inserthyphen") and form.inserthyphen eq "on">
					<cfset thisitemno = form.mitemno&'-'&thiscolor>
				<cfelse>
					<cfset thisitemno = form.mitemno&thiscolor>
				</cfif>
				<cfquery name="checkitemExist1" datasource="#dts#">
 	 				select * from icitem where itemno = '#thisitemno#' 
 	 			</cfquery>
				<cfif checkitemExist1.recordcount eq 0>
					<cfif isdefined("form.insertcolorsize") and form.insertcolorsize eq "on">
						<cfset thisdesp = form.desp&' ('&thiscolor&')'>
					<cfelse>
						<cfset thisdesp = form.desp>
					</cfif>
						
					<cfquery name="insertitem" datasource="#dts#">
						insert into icitem 
						(itemno,aitemno,desp,despa,brand,category,wos_group,unit,ucost,price,supp,sizeid,price2,price3,muratio)
						values 
						('#thisitemno#','#form.AITEMNO#','#thisdesp#','#form.despa#','#form.BRAND#','#form.CATEGORY#','#form.WOS_GROUP#',
						'#form.UNIT#','#val(form.UCOST)#','#form.PRICE#','#form.supp#','#form.sizeid#','#val(form.price2)#','#val(form.price3)#','#val(form.muratio)#')
					</cfquery>
					<cfset counter = counter + 1>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("form.inserthyphen") and form.inserthyphen eq "on">
		<cfset inserthyphen = 1>
	<cfelse>
		<cfset inserthyphen = 0>
	</cfif>
	<cfset status="No. Of Record Generated: #counter# ">
	<cfif submit eq 'Edit Opening Quantity' and counter eq 0>
		<cfset status= "">
	</cfif>
<cfelse>
	<cfif form.mode eq "Create">
		<cfquery datasource='#dts#' name="checkitemExist">
	 	 	Select * from icmitem 
	 		where mitemno = '#form.mitemno#'
 		</cfquery>
  	
		<cfif checkitemExist.recordcount gt 0 >
			<cfoutput>
      			<h3><font color="##FF0000">Error, This Matrix Item No. ("#form.mitemno#") Already Exist.</font></h3>
				<script language="javascript" type="text/javascript">
					alert("Error, This record #form.mitemno# Already Exist.");
					javascript:history.back();
					javascript:history.back();
				</script>
	    	</cfoutput> 
    		<cfabort>
		</cfif>
	
		<cfquery name="insert" datasource="#dts#">
			insert into icmitem
			(mitemno,desp,despa,aitemno,unit,ucost,price,category,wos_group,brand,supp,colorno,sizecolor,sizeid,price2,price3,muratio,
			<cfloop from="1" to="20" index="i">
				color#i#,size#i#,
			</cfloop>
			created_by,created_on,updated_by,updated_on 
			)
			values
			('#form.mitemno#','#form.desp#','#form.despa#','#form.AITEMNO#','#form.UNIT#','#val(form.UCOST)#','#form.PRICE#',
			'#form.CATEGORY#','#form.WOS_GROUP#','#form.BRAND#','#form.supp#','#form.colorno#','#form.sizecolor#','#form.sizeid#','#val(form.price2)#','#val(form.price3)#','#val(form.muratio)#',
			<cfloop from="1" to="20" index="i">
				'#Evaluate("form.color#i#")#','#Evaluate("form.size#i#")#',
			</cfloop>
			'#HUserID#',#now()#,'#HUserID#',#now()#
			)
		</cfquery>
	
		<cfset status="The Matrix Item, #form.mitemno# had been successfully created. ">
	<cfelse>
		<cfquery datasource='#dts#' name="checkitemExist">
	 	 	Select * from icmitem 
	 		where mitemno = '#form.mitemno#'
 		</cfquery>

		<cfif checkitemExist.recordcount GT 0>
			<cfif form.mode eq "Delete">
				<cfquery datasource='#dts#' name="deleteitem">
					Delete from icmitem
					where mitemno = '#form.mitemno#'
				</cfquery>
				
				<cfset status="The Matrix Item, #form.mitemno# had been successfully deleted. ">	
			</cfif>
			
			<cfif form.mode eq "Edit">
				<cfquery name="update" datasource="#dts#">
					update icmitem
					set desp = '#form.desp#',
					despa = '#form.despa#',
					aitemno = '#form.AITEMNO#',
					unit = '#form.UNIT#',
					ucost = '#val(form.UCOST)#',
					price = '#form.PRICE#',
                    price2 = '#val(form.price2)#',
          			price3 = '#val(form.price3)#',
         			muratio = '#val(form.muratio)#',
					category = '#form.CATEGORY#',
					wos_group = '#form.WOS_GROUP#',
                    sizeid = '#form.sizeid#',
					brand = '#form.BRAND#',
					supp = '#form.supp#',
					colorno = '#form.colorno#',
					sizecolor = '#form.sizecolor#',
					<cfloop from="1" to="20" index="i">
						color#i# = '#Evaluate("form.color#i#")#',
						size#i# = '#Evaluate("form.size#i#")#',
					</cfloop>
					updated_by = '#HUserID#',
					updated_on = #now()#
					where mitemno = '#form.mitemno#'
				</cfquery>
			
				<cfset status="The Matrix Item, #form.mitemno# had been successfully edited. ">
			</cfif>
				
		<cfelse>		
			<cfset status="Sorry, the Matrix Item, #form.mitemno# was ALREADY removed from the system. Process unsuccessful.">
		</cfif>
	</cfif>
</cfif>

<cfoutput>
	<cfif submit neq 'Edit Opening Quantity'>
		<form name="done" action="s_matrixitemtable.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
	<cfelse>
		<form name="done" action="matrixitem_openingqty.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
			<input name="inserthyphen" value="#inserthyphen#" type="hidden">
			<input name="sizecolor" value="#form.sizecolor#" type="hidden">
			<input name="mitemno" value="#form.mitemno#" type="hidden">
		</form>
	</cfif>
</cfoutput>

<script>
	done.submit();
</script>