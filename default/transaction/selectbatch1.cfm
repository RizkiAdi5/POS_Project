<cfquery name="getbatchname" datasource="#dts#">
SELECT lbatch FROM gsetup
</cfquery>
<html>
<head>
<title>Select Batch Item</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfif isdefined("bexpdate") and isdefined("bqty")>
	<cfoutput>
	<script language="javascript" type="text/javascript">
			function putbatchinfo()
			{
				document.enterbatchcode.manudate.value = '#dateformat(bmanudate,"dd-mm-yyyy")#';
				document.enterbatchcode.expdate.value = '#dateformat(bexpdate,"dd-mm-yyyy")#';
				document.enterbatchcode.batchqty.value = '#bqty#';
			}
	</script>
	</cfoutput>
</cfif>
</head>

<body <cfif isdefined("bexpdate") and isdefined("bqty")>onLoad="putbatchinfo();"</cfif>>
<cfif isdefined('consignment')>
<cfset consignment=consignment>
<cfelse>
<cfset consignment=''>
</cfif>

<cfif isdefined('location')>
<cfelse>
<cfset location=''>
</cfif>
<cfoutput>
<!--- <cfabort> --->
<cfif isdefined("bmode") and bmode eq "search">
	<cfquery name="getitembatch" datasource="#dts#">
		<cfif listfirst(tran) eq "TR">
			<cfif type1 eq "Add" or type1 eq "Edit">
				<cfif HcomID eq "remo_i">
					select 
					a.location,
					a.batchcode,
					a.itemno,
					a.rc_type,
					a.rc_refno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.expdate as exp_date, 
                    a.manudate as manu_date ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from lobthob as a
					left join 
					(
						select 
						location, 
						batchcode,
						itemno,
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#' 
						and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by location,batchcode
						order by location,batchcode
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
					where a.location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
					and a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <> 0 
					order by a.location,a.batchcode,a.itemno;
				<cfelse>
					<!---select 
					location,
					batchcode,
					rc_type,
					rc_refno,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate as exp_date, 
                    manudate as manu_date ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
					from lobthob
					where location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
					and itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) <> 0 
					order by location,batchcode,itemno;--->
                    
                    select 
                    a.batchcode,a.location,
                    a.rc_type,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.expdate as exp_date,
                    a.manudate as manu_date ,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from lobthob as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode,location  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>'' and location<>''
                    and itemno='#items#' 
                    and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                    group by itemno,batchcode,location
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode,location 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                        group by itemno,batchcode,location
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                    
                    
                    
                    where a.location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                    and a.itemno='#items#' 
                    and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0 
                    order by a.itemno;
                    
                    
				</cfif>
			</cfif>
		<cfelse>
			<cfif location neq "">
				<cfif HcomID eq "remo_i">
					select 
					a.location,
					a.batchcode,
					a.itemno,
					a.rc_type,
					a.rc_refno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.expdate as exp_date, 
                    a.manudate as manu_date ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from lobthob as a
					left join 
					(
						select 
						location, 
						batchcode,
						itemno,
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#' 
						and location='#location#'
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by location,batchcode
						order by location,batchcode
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
					where a.location='#location#' 
					and a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <> 0 
					order by a.itemno;
                <cfelseif HcomID eq "hempel_i">
					select 
					a.location,
					a.batchcode,
					a.itemno,
					a.rc_type,
					a.rc_refno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.expdate as exp_date, 
                    a.manudate as manu_date ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from lobthob as a
					left join 
					(
						select 
						location, 
						batchcode,
						itemno,
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#' 
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by location,batchcode
						order by location,batchcode
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
					where a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <> 0 
					order by a.itemno;
				<cfelse>
                	<!---
					select 
					batchcode,
					rc_type,location,
					rc_refno,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate as exp_date,
                    manudate as manu_date ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
					from lobthob
					where location='#location#' 
					and itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) <> 0 
					order by itemno;
                    --->
                    select 
                    a.batchcode,a.location,
                    a.rc_type,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.expdate as exp_date,
                    a.manudate as manu_date ,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from lobthob as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode,location  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>'' and location<>''
                    and itemno='#items#' 
                    and location='#location#' 
                    group by itemno,batchcode,location
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode,location 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location='#location#' 
                        group by itemno,batchcode,location
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                    
                    
                    
                    where a.location='#location#' 
                    and a.itemno='#items#' 
                    and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0 
                    order by a.itemno;
                    
				</cfif>			
			<cfelse>
				<cfif HcomID eq "remo_i">
					select 
					a.batchcode,
					a.itemno,'' as location,
					a.rc_type,
					a.rc_refno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.exp_date,
                    a.manu_date  ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from obbatch as a
					left join 
					(
						select 
						batchcode,
						itemno, 
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#'
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by batchcode 
						order by batchcode 
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode 
					where a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <> 0 
					order by a.itemno;
                <cfelseif HcomID eq "hempel_i">
					select 
					a.location,
					a.batchcode,
					a.itemno,
					a.rc_type,
					a.rc_refno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.expdate as exp_date, 
                    a.manudate as manu_date ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from lobthob as a
					left join 
					(
						select 
						location, 
						batchcode,
						itemno,
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#' 
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by location,batchcode
						order by location,batchcode
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
					where a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <> 0 
					order by a.itemno;
				<cfelse>
                	<!---
					select 
					batchcode,
					rc_type,'' as location,
					rc_refno,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					exp_date,
                    manu_date  ,
                    milcert,
                    importpermit,
                    countryoforigin,
                    pallet
					from obbatch
					where itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) <> 0 
					order by itemno;--->
                    select 
				a.batchcode,
				a.rc_type,'' as location,
				a.rc_refno,
				((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
				a.exp_date,
                a.manu_date  ,
                a.milcert,a.importpermit,
                a.countryoforigin,
                a.pallet
				from obbatch as a
                
                left join
				(select sum(qty) as getin,itemno,batchcode  
				from ictran
				where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
				and (void = '' or void is null)  and batchcode<>''
                and itemno='#items#' 
				group by itemno,batchcode
				) as b on a.itemno = b.itemno and a.batchcode=b.batchcode

                left join
                (	select sum(qty) as getout,itemno,batchcode 
                    from ictran
                    where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                    and (void = '' or void is null) 
                     and toinv='' and batchcode<>''
                    and itemno='#items#' 
                    group by itemno,batchcode
                ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode
                
                
				where a.itemno='#items#' 
				and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0 
				order by a.itemno;
				</cfif>
			</cfif>
		</cfif>
	</cfquery>

	<cfif getitembatch.recordcount neq 0>
	<h1 align="center">Select #getbatchname.lbatch# Code For Item <font color="red">#items#</font></h1>
	<form name="selectbatchcode" action="" method="post">
		<table align="center" cellpadding="2" cellspacing="0">
			<tr>
				<th>#getbatchname.lbatch# code</th>
                <th>Location</th>
				<th>Expiry Date</th>
				<th>Receive Type</th>
				<th>Receive's Reference No.</th>
				<th>Quantity On Hand</th>
				<th>Action</th>
			</tr>
			<cfloop query="getitembatch">
            <cfquery name="getlocationbatch" datasource="#dts#">
            select location from lobthob where batchcode='#getitembatch.batchcode#'
            </cfquery>
				<cfif (getitembatch.currentrow mod 2) eq 0>
					<tr bgcolor="##99FF00">
				<cfelse>
					<tr bgcolor="##66CCFF">
				</cfif>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#getitembatch.batchcode#</strong></font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitembatch.location#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getitembatch.exp_date,"dd-mm-yyyy")#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitembatch.rc_type#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitembatch.rc_refno#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getitembatch.batch_balance)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">

					<!--- MODIFIED ON 26-03-2009 --->
					<cfif listfirst(tran) neq "TR">
						<a href="selectbatch1.cfm?
						enterbatch=#URLEncodedFormat(getitembatch.batchcode)#
						&items=#URLEncodedFormat(items)#
                        &bmanudate=#URLEncodedFormat(getitembatch.manu_date)#
                        &milcert=#URLEncodedFormat(getitembatch.milcert)#
                        &importpermit=#URLEncodedFormat(getitembatch.importpermit)#
                        &countryoforigin=#URLEncodedFormat(getitembatch.countryoforigin)#
                        &pallet=#URLEncodedFormat(getitembatch.pallet)#
						&bexpdate=#URLEncodedFormat(getitembatch.exp_date)#
						&bqty=#val(getitembatch.batch_balance)#
						&tran=#URLEncodedFormat(tran)#
						&hmode=#URLEncodedFormat(hmode)#
						&type1=#URLEncodedFormat(type1)#
						&nexttranno=#URLEncodedFormat(nexttranno)#
						&itemcount=#itemcount#
						&agenno=#URLEncodedFormat(agenno)#
						&mode=#URLEncodedFormat(mode)#
						&nDateCreate=#URLEncodedFormat(nDateCreate)#
						&location=#URLEncodedFormat(location)#
						&oldenterbatch=#URLEncodedFormat(oldenterbatch)#
						&oldlocation=#URLEncodedFormat(oldlocation)#
						&grdcolumnlist=#URLEncodedFormat(grdcolumnlist)#
						&grdvaluelist=#URLEncodedFormat(grdvaluelist)#
						&totalrecord=#URLEncodedFormat(totalrecord)#
						&bgrdcolumnlist=#URLEncodedFormat(bgrdcolumnlist)#
						&oldgrdvaluelist=#URLEncodedFormat(oldgrdvaluelist)#"
						>Select</a></font></div>
					<cfelse>
						<a href="selectbatch1.cfm?
						enterbatch=#URLEncodedFormat(getitembatch.batchcode)#
						&items=#URLEncodedFormat(items)#
                        &bmanudate=#URLEncodedFormat(getitembatch.manu_date)#
                        &milcert=#URLEncodedFormat(getitembatch.milcert)#
                        &importpermit=#URLEncodedFormat(getitembatch.importpermit)#
                        &countryoforigin=#URLEncodedFormat(getitembatch.countryoforigin)#
                        &pallet=#URLEncodedFormat(getitembatch.pallet)#
						&bexpdate=#URLEncodedFormat(getitembatch.exp_date)#
						&bqty=#val(getitembatch.batch_balance)#
						&tran=#URLEncodedFormat(tran)#
						&hmode=#URLEncodedFormat(hmode)#
						&type1=#URLEncodedFormat(type1)#
						&nexttranno=#URLEncodedFormat(nexttranno)#
                        &consignment=#consignment#
						&itemcount=#itemcount#&agenno=#URLEncodedFormat(agenno)#
						&mode=#URLEncodedFormat(mode)#
						&nDateCreate=#URLEncodedFormat(nDateCreate)#
						&trfrom=#URLEncodedFormat(trfrom)#
						&trto=#URLEncodedFormat(trto)#
						&oldenterbatch=#URLEncodedFormat(oldenterbatch)#
						&oldtrfrom=#oldtrfrom#
						&oldtrto=#oldtrto#
						&ttran=#ttran#
						&grdcolumnlist=#URLEncodedFormat(grdcolumnlist)#
						&grdvaluelist=#URLEncodedFormat(grdvaluelist)#
						&totalrecord=#URLEncodedFormat(totalrecord)#
						&bgrdcolumnlist=#URLEncodedFormat(bgrdcolumnlist)#
						&oldgrdvaluelist=#URLEncodedFormat(oldgrdvaluelist)#"
						>Select</a></font></div>
					</cfif>
					</td>
				</tr>
			</cfloop>
			<tr><td><br></td></tr>
		</table>
		<table align="center">
			<tr>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back();"></td>
			</tr>
		</table>
	</form>
	<cfelse>
		<h1 align="center">No #getbatchname.lbatch# Code For Item <font color="red">#items#</font></h1>
		<table align="center">
			<tr>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back();"></td>
			</tr>
		</table>
	</cfif>
<cfelse>
	<cfif isdefined("enterbatch1")>
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif listfirst(tran) eq "TR">
				select 
				location,
				expdate,
                manudate,
                milcert,
                importpermit,
                countryoforigin,
                pallet,
				qty,
				defective,
				mc1_bil,
				mc2_bil,
				batchcode,
				sodate,
				dodate 
				from ictran
				where location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                and refno='#nexttranno#'
				and batchcode='#enterbatch1#' 
				and itemno='#items#' 
				and itemcount='#itemcount#';
			<cfelse>
				<cfif location neq "">
					select 
					location,
					expdate,
                    manudate,
                    milcert,
                    importpermit,
                    countryoforigin,
                    pallet,
					qty,
					defective,
					mc1_bil,
					mc2_bil,
					batchcode,
					sodate,
					dodate 
					from ictran
					where location='#location#' 
					and batchcode='#enterbatch1#' 
					and itemno='#items#' 
					and itemcount='#itemcount#' 
					and type='#tran#';
				<cfelse>
					select 
					expdate,
                    manudate,
                    milcert,
                    importpermit,
                    countryoforigin,
                    pallet,
					qty,
					defective,
					mc1_bil,
					mc2_bil,
					batchcode,
					sodate,
					dodate 
					from ictran
					where batchcode='#enterbatch1#' 
					and itemno='#items#' 
					and itemcount='#itemcount#' 
					and type='#tran#';
				</cfif>
			</cfif>
		</cfquery>
	<cfelseif isdefined("enterbatch")>
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif listfirst(tran) eq "TR">
				<cfif type1 eq "Add" or type1 eq "Edit">
					<cfif HcomID eq "remo_i">
						select 
						a.location,
						a.batchcode,
						a.itemno,
						((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
						a.expdate, 
                        a.manudate,
                        a.milcert,
                        a.importpermit,
                        a.countryoforigin,
                    	a.pallet
						from lobthob as a
						left join 
						(
							select 
							location, 
							batchcode,
							itemno,
							sum(qty) as soqty 
							from ictran 
							where type='SO' 
							and itemno='#items#' 
							and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
							and (qty-shipped)<>0 
							and fperiod<>'99' 
							and (void = '' or void is null) 
							group by location,batchcode
							order by location,batchcode
						) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
						where a.location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
						and a.batchcode='#enterbatch#' 
						and a.itemno='#items#';
					<cfelse>
						<!---select 
						location,
						batchcode,
						((bth_qob+bth_qin)-bth_qut) as batch_balance,
						expdate,
                        manudate ,
                        milcert,
                        importpermit,
                        countryoforigin,
                    	pallet
						from lobthob 
						where location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif> 
						and batchcode='#enterbatch#' 
						and itemno='#items#';--->
                        select 
                        a.batchcode,a.location,
                        a.rc_type,
                        a.rc_refno,
                        ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                        a.expdate,
                        a.manudate ,
                        a.milcert,a.importpermit,
                        a.countryoforigin,
                        a.pallet
                        from lobthob as a
                        
                        left join
                        (select sum(qty) as getin,itemno,batchcode,location  
                        from ictran
                        where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                        and (void = '' or void is null) and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                        and batchcode='#enterbatch#' 
                        group by itemno,batchcode,location
                        ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
        
                        left join
                        (	select sum(qty) as getout,itemno,batchcode,location 
                            from ictran
                            where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                            and (void = '' or void is null) 
                             and toinv='' and batchcode<>'' and location<>''
                            and itemno='#items#' 
                            and location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                            and batchcode='#enterbatch#' 
                            group by itemno,batchcode,location
                        ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                        
                        
                        
                        where a.location=<cfif ttran eq "TROU">'#listfirst(trfrom)#'<cfelseif ttran eq "TRIN">'#listfirst(trto)#'<cfelse>'#listfirst(trfrom)#'</cfif>
                        and a.itemno='#items#' 
                        and a.batchcode='#enterbatch#' 
                        order by a.itemno;
                        
                        
					</cfif>
				</cfif>
			<cfelse>
				<cfif location neq "">
					<cfif HcomID eq "remo_i">
						select 
						a.location,
						a.batchcode,
						a.itemno,
						((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
						a.expdate,
                        a.manudate ,
                        a.milcert,
                        a.importpermit,
                        a.countryoforigin,
                    	a.pallet
						from lobthob as a
						left join 
						(
							select 
							location, 
							batchcode,
							itemno,
							sum(qty) as soqty 
							from ictran 
							where type='SO' 
							and itemno='#items#' 
							and location='#location#' 
							and batchcode='#enterbatch#' 
							and (qty-shipped)<>0 
							and fperiod<>'99' 
							and (void = '' or void is null) 
							group by location,batchcode
							order by location,batchcode
						) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
						where a.location='#location#' 
						and a.batchcode='#enterbatch#' 
						and a.itemno='#items#' 
						and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <>0;
					<cfelse>
                    <!---
						select 
						location,
						batchcode,
						((bth_qob+bth_qin)-bth_qut) as batch_balance,
						expdate,
                        manudate ,
                        milcert,
                        importpermit,
                        countryoforigin,
                    	pallet
						from lobthob
						where location='#location#' 
						and batchcode='#enterbatch#' 
						and itemno='#items#' 
						and ((bth_qob+bth_qin)-bth_qut) <>0;
						--->
                        select 
                    a.batchcode,a.location,
                    a.rc_type,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.expdate,
                    a.manudate ,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from lobthob as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode,location  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>'' and location<>''
                    and itemno='#items#' 
                    and location='#location#' 
                    and batchcode='#enterbatch#' 
                    group by itemno,batchcode,location
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode,location 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location='#location#' 
                        and batchcode='#enterbatch#' 
                        group by itemno,batchcode,location
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                    
                    
                    
                    where a.location='#location#' 
                    and a.itemno='#items#' 
                    and a.batchcode='#enterbatch#' 
                    order by a.itemno;
                        
					</cfif>
				<cfelse>
					<cfif HcomID eq "remo_i">
						select 
						a.batchcode,
						a.itemno,
						((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
						a.exp_date as expdate,
                        a.manu_date as manudate ,
                        a.milcert,
                        a.importpermit,
                        a.countryoforigin,
                    	a.pallet
						from obbatch as a 
						left join 
						(
							select 
							batchcode,
							itemno, 
							sum(qty) as soqty 
							from ictran 
							where type='SO' 
							and itemno='#items#' 
							and batchcode='#enterbatch#' 
							and (qty-shipped)<>0 
							and fperiod<>'99' 
							and (void = '' or void is null) 
							group by batchcode 
							order by batchcode 
						) as b on a.itemno=b.itemno and a.batchcode=b.batchcode 
						where a.batchcode='#enterbatch#' 
						and a.itemno='#items#' 
						and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <>0;
					<cfelse>
						<!---select 
						batchcode,
						((bth_qob+bth_qin)-bth_qut) as batch_balance,
						exp_date as expdate,
                        manu_date as manudate ,
                        milcert,importpermit,
                        countryoforigin,
                    	pallet
						from obbatch
						where batchcode='#enterbatch#' 
						and itemno='#items#' 
						and ((bth_qob+bth_qin)-bth_qut) <>0;--->
                        select 
                    a.batchcode,
                    a.rc_type,'' as location,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.exp_date as expdate,
                    a.manu_date as manudate,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from obbatch as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>''
                    and itemno='#items#' 
                    and batchcode='#enterbatch#' 
                    group by itemno,batchcode
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>''
                        and itemno='#items#' 
                        and batchcode='#enterbatch#' 
                        group by itemno,batchcode
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode
                    
                    
                    where a.itemno='#items#' 
                    and a.batchcode='#enterbatch#' 
                    order by a.itemno;
                        
					</cfif>
				</cfif>
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif tran eq "TR">
				<cfif HcomID eq "remo_i">
					select 
					a.location,
					a.batchcode,
					a.itemno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.expdate,
                    a.manudate ,
                    a.milcert,
                    a.importpermit,
                    a.countryoforigin,
                    a.pallet
					from lobthob as a
					left join 
					(
						select 
						location, 
						batchcode,
						itemno,
						sum(qty) as soqty 
						from ictran 
						where type='SO' 
						and itemno='#items#' 
						and location='#listfirst(trfrom)#' 
						and (qty-shipped)<>0 
						and fperiod<>'99' 
						and (void = '' or void is null) 
						group by location,batchcode
						order by location,batchcode
					) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
					where a.location='#listfirst(trfrom)#' 
					and a.itemno='#items#' 
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <>0;
				<cfelse>
                <!---
					select 
					location,
					batchcode,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate,
                    manudate ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
					from lobthob
					where location='#listfirst(trfrom)#' 
					and itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) <>0;
				--->
                
                select 
                    a.batchcode,a.location,
                    a.rc_type,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.expdate,
                    a.manudate ,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from lobthob as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode,location  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>'' and location<>''
                    and itemno='#items#' 
                    and location='#listfirst(trfrom)#' 
                    group by itemno,batchcode,location
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode,location 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location='#listfirst(trfrom)#' 
                        group by itemno,batchcode,location
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                    
                    
                    
                    where a.location='#listfirst(trfrom)#' 
                    and a.itemno='#items#' 
                    and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0
                    order by a.itemno;
                
				</cfif>
			<cfelse>
				<cfif trim(location) neq "">
					<cfif HcomID eq "remo_i">
						select 
						a.location,
						a.batchcode,
						a.itemno,
						((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
						a.expdate,
                        a.manudate ,
                        a.milcert,
                        a.importpermit,
                        a.countryoforigin,
                    	a.pallet
						from lobthob as a
						left join 
						(
							select 
							location, 
							batchcode,
							itemno,
							sum(qty) as soqty 
							from ictran 
							where type='SO' 
							and itemno='#items#' 
							and location='#location#' 
							and (qty-shipped)<>0 
							and fperiod<>'99' 
							and (void = '' or void is null) 
							group by location,batchcode
							order by location,batchcode
						) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location 
						where a.location='#location#' 
						and a.itemno='#items#' 
						and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <>0;
					<cfelse>
                    <!---
						select 
						location,
						batchcode,
						((bth_qob+bth_qin)-bth_qut) as batch_balance,
						expdate,
                        manudate ,
                        milcert,importpermit,
                        countryoforigin,
                    	pallet
						from lobthob
						where location='#location#' 
						and itemno='#items#' 
						and ((bth_qob+bth_qin)-bth_qut) <>0;
					--->
                    select 
                    a.batchcode,a.location,
                    a.rc_type,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.expdate,
                    a.manudate ,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from lobthob as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode,location  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null) and batchcode<>'' and location<>''
                    and itemno='#items#' 
                    and location='#location#' 
                    group by itemno,batchcode,location
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode and a.location=b.location
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode,location 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>'' and location<>''
                        and itemno='#items#' 
                        and location='#location#' 
                        group by itemno,batchcode,location
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode and a.location=c.location
                    
                    
                    
                    where a.location='#location#' 
                    and a.itemno='#items#' 
                    and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0
                    order by a.itemno;
					</cfif>
				<cfelse>
					<cfif HcomID eq "remo_i">
						select 
						a.batchcode,
						a.itemno,
						((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
						a.exp_date as expdate,
                        a.manu_date as manudate ,
                        a.milcert,
                        a.importpermit,
                        a.countryoforigin,
                    	a.pallet
						from obbatch as a 
						left join 
						(
							select 
							batchcode,
							itemno, 
							sum(qty) as soqty 
							from ictran 
							where type='SO' 
							and itemno='#items#' 
							and (qty-shipped)<>0 
							and fperiod<>'99' 
							and (void = '' or void is null) 
							group by batchcode 
							order by batchcode 
						) as b on a.itemno=b.itemno and a.batchcode=b.batchcode 
						where a.itemno='#items#' 
						and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) <>0;
					<cfelse>
						<!---select 
						batchcode,
						((bth_qob+bth_qin)-bth_qut) as batch_balance,
						exp_date as expdate,
                        manu_date as manudate  ,
                        milcert,importpermit,
                        countryoforigin,
                    	pallet
						from obbatch
						where itemno='#items#' 
						and ((bth_qob+bth_qin)-bth_qut) <>0;--->
                        
                        select 
                    a.batchcode,
                    a.rc_type,'' as location,
                    a.rc_refno,
                    ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) as batch_balance,
                    a.exp_date as expdate,
                    a.manu_date as manudate,
                    a.milcert,a.importpermit,
                    a.countryoforigin,
                    a.pallet
                    from obbatch as a
                    
                    left join
                    (select sum(qty) as getin,itemno,batchcode  
                    from ictran
                    where (type = 'RC' or type = 'CN' or type = 'OAI' or type = 'TRIN')
                    and (void = '' or void is null)  and batchcode<>''
                    and itemno='#items#' 
                    group by itemno,batchcode
                    ) as b on a.itemno = b.itemno and a.batchcode=b.batchcode
    
                    left join
                    (	select sum(qty) as getout,itemno,batchcode 
                        from ictran
                        where (type = 'INV' or type = 'PR' or type = 'CS' or type = 'DN' or type = 'ISS' or type = 'OAR' or type = 'TROU' or type = 'DO')
                        and (void = '' or void is null) 
                         and toinv='' and batchcode<>''
                        and itemno='#items#' 
                        group by itemno,batchcode
                    ) as c on a.itemno = c.itemno and a.batchcode=c.batchcode
                    
                    
                    where a.itemno='#items#' 
                    and ((a.bth_qob+ifnull(b.getin,0))-ifnull(c.getout,0)) >0
                    order by a.itemno;
                        
					</cfif>
				</cfif>
			</cfif>
		</cfquery>
	</cfif>
	
	<cfif getitembatch.recordcount neq 0>
	<h1 align="center">Select #getbatchname.lbatch# For Item <font color="red">#items#</font></h1>
	<cfform 
	name="enterbatchcode" 
	action="iss4.cfm?
	itemno=#URLEncodedFormat(items)#
	&tran=#URLEncodedFormat(tran)#
	&hmode=#URLEncodedFormat(hmode)#
	&type1=#URLEncodedFormat(type1)#
	&nexttranno=#URLEncodedFormat(nexttranno)#
	&itemcount=#URLEncodedFormat(itemcount)#
	&agenno=#URLEncodedFormat(agenno)#
	&mode=#URLEncodedFormat(mode)#
	&nDateCreate=#URLEncodedFormat(nDateCreate)#&consignment=#consignment#" 
	method="post" 

	>
		<table align="center">
			<tr>
				<th>Other Charges 1</th>
				<cfif isdefined("enterbatch1")>
					<td><cfinput name="mc1bil" type="text" size="10" validate="float" message="Charges 1 Must be in Number Format !" value="#numberformat(getitembatch.mc1_bil,'0.00')#"></td>
				<cfelse>
					<td><cfinput name="mc1bil" type="text" size="10" validate="float" message="Charges 1 Must be in Number Format !"></td>
				</cfif>
			</tr>
			<tr>
				<th>Other Charges 2</th>
				<cfif isdefined("enterbatch1")>
					<td><cfinput name="mc2bil" type="text" size="10" validate="float" message="Charges 2 Must be in Number Format !" value="#numberformat(getitembatch.mc2_bil,'0.00')#"></td>
				<cfelse>
					<td><cfinput name="mc2bil" type="text" size="10" validate="float" message="Charges 2 Must be in Number Format !"></td>
				</cfif>
			</tr>
			<tr><td><br></td></tr>
			<tr>
				<th>Sales Order Date</th>
				<cfif isdefined("enterbatch1")>
					<td><cfinput name="sodate" type="text" size="10" validate="eurodate" message="The Sales Order Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.sodate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
				<cfelse>
					<td><cfinput name="sodate" type="text" size="10" validate="eurodate" message="The Sales Order Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</cfif>
			</tr>
			<tr>
				<th>Delivery Date</th>
				<cfif isdefined("enterbatch1")>
					<td><cfinput name="dodate" type="text" size="10" validate="eurodate" message="The Delevery Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.dodate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
				<cfelse>
					<td><cfinput name="dodate" type="text" size="10" validate="eurodate" message="The Delevery Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</cfif>
			</tr>
			<tr><td><br></td></tr>
			<tr>
				<th>#getbatchname.lbatch# Code</th>
				<td><cfif isdefined("enterbatch")>
						<cfinput name="enterbatch" type="text" size="10" value="#enterbatch#">
						<cfinput name="oldenterbatch" type="hidden" size="10" value="#oldenterbatch#">
					<cfelseif isdefined("enterbatch1")>
						<cfinput name="enterbatch" type="text" size="10" value="#enterbatch1#">
						<cfinput name="oldenterbatch" type="hidden" size="10" value="#enterbatch1#">
					<cfelse>
						<cfinput name="enterbatch" type="text" size="10">
					</cfif>

					<cfif isdefined("enterbatch")>
						<input type="hidden" name="items" value="#items#">
						<input type="hidden" name="mode" value="#mode#">
						<input type="hidden" name="tran" value="#tran#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="nexttranno" value="#nexttranno#">
						<input type="hidden" name="itemcount" value="#itemcount#">
						<input type="hidden" name="agenno" value="#agenno#">
						<cfif tran eq "TR">
                        
                        	<input type="hidden" name="consignment" value="#listfirst(consignment)#">
							<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
							<input type="hidden" name="trto" value="#listfirst(trto)#">
							<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
							<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
							<input type="hidden" name="ttran" value="#listfirst(ttran)#">
						<cfelse>
							<input type="hidden" name="location" value="#location#">
							<input type="hidden" name="oldlocation" value="#oldlocation#">
						</cfif>
					<cfelseif isdefined("enterbatch1")>
						<input type="hidden" name="items" value="#items#">
						<input type="hidden" name="mode" value="#mode#">
						<input type="hidden" name="tran" value="#tran#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="nexttranno" value="#nexttranno#">
						<input type="hidden" name="itemcount" value="#itemcount#">
						<input type="hidden" name="agenno" value="#agenno#">
						<cfif listfirst(tran) eq "TR">
							<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
                            <input type="hidden" name="consignment" value="#listfirst(consignment)#">
							<input type="hidden" name="trto" value="#listfirst(trto)#">
							<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
							<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
							<input type="hidden" name="ttran" value="#listfirst(ttran)#">
						<cfelse>
							<input type="hidden" name="location" value="#location#">
							<input type="hidden" name="oldlocation" value="#oldlocation#">
						</cfif>
					<cfelse>
						<input type="hidden" name="items" value="#items#">
						<input type="hidden" name="mode" value="#mode#">
						<input type="hidden" name="tran" value="#tran#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="nexttranno" value="#nexttranno#">
						<input type="hidden" name="itemcount" value="#itemcount#">
						<input type="hidden" name="agenno" value="#agenno#">
						<input type="hidden" name="oldenterbatch" value="">
						<cfif tran eq "TR">
							<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
                            <input type="hidden" name="consignment" value="#listfirst(consignment)#">
							<input type="hidden" name="trto" value="#listfirst(trto)#">
							<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
							<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
							<input type="hidden" name="ttran" value="#listfirst(ttran)#">
						<cfelse>
							<input type="hidden" name="location" value="#location#">
							<input type="hidden" name="oldlocation" value="#oldlocation#">
						</cfif>
					</cfif>
					<!--- ADD ON 26-03-2009 --->
					<input type="hidden" name="grdcolumnlist" value="#grdcolumnlist#">
			        <input type="hidden" name="grdvaluelist" value="#grdvaluelist#">
					<input type="hidden" name="totalrecord" value="#totalrecord#">
					<input type="hidden" name="bgrdcolumnlist" value="#bgrdcolumnlist#">
					<input type="hidden" name="oldgrdvaluelist" value="#oldgrdvaluelist#">
					
					<input type="hidden" name="mode" value="#mode#">
					<input type="submit" name="searchbatch" value="Search #getbatchname.lbatch# Item">
				</td>
			</tr>
            <tr>
				<th>Manufacturing  Date</th>
                <cfif isdefined("enterbatch1")>
					<cfif enterbatch1 neq "">
						<td><cfinput name="manudate" type="text" size="10" validate="eurodate" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
					<cfelse>
						<td><cfinput name="manudate" type="text" size="10" validate="eurodate" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
					</cfif>
				<cfelseif isdefined("enterbatch")>
					<td><cfinput name="manudate" type="text" size="10" validate="eurodate" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
				<cfelse>
					<td><cfinput name="manudate" type="text" size="10" validate="eurodate" message="The Manufacturing Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</cfif>
			</tr>
			<tr>
				<th>Expiry Date</th>
				<cfif isdefined("enterbatch1")>
					<cfif enterbatch1 neq "">
						<td><cfinput name="expdate" type="text" size="10" validate="eurodate" message="The Expiry Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.expdate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
					<cfelse>
						<td><cfinput name="expdate" type="text" size="10" validate="eurodate" message="The Expiry Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.expdate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
					</cfif>
				<cfelseif isdefined("enterbatch")>
					<td><cfinput name="expdate" type="text" size="10" validate="eurodate" message="The Expiry Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.expdate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
				<cfelse>
					<td><cfinput name="expdate" type="text" size="10" validate="eurodate" message="The Expiry Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</cfif>
			</tr>
            <tr>
                <th><cfif lcase(hcomid) eq 'marquis_i'>Lot No<cfelseif lcase(hcomid) eq 'asaiki_i'>PO No<cfelse>Mill Certificate</cfif></th>
                <td><input type="text" name="milcert" id="milcert" value="#getitembatch.milcert#" maxlength="100"> </td>
                </tr>
			<tr>
            <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">Length<cfelse>Import Permit</cfif></th>
                <td><input type="text" name="importpermit" id="importpermit" value="#getitembatch.importpermit#" maxlength="100"> </td>
                </tr>
			<tr>
            <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">CUST P/N / REMARK<cfelse>Country Of Origin</cfif></th>
                <td>
                <cfquery name="getcountryoforigin" datasource="#dts#">
                select * from iccolorid
                </cfquery>
                
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#" <cfif getitembatch.countryoforigin eq getcountryoforigin.colorid>selected</cfif>>#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                </td>
                </tr>
			<tr>
            <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">SQM<cfelse>Pallet</cfif></th>
                <td>
                <cfif trim(location) neq "">
                <cfquery name="getbatchpalletbalance" datasource="#dts#">
                select a.batchcode,b.pallet-c.pallet as pallet from obbatch as a
                left join (select ifnull(sum(pallet),0) as pallet,batchcode from ictran where type in ('RC','CN','TRIN')
                and (void='' or void is null)
                and fperiod <> '99'
                and location='#location#'
                group by batchcode
                ) as b on a.batchcode=b.batchcode
                left join (select ifnull(sum(pallet),0) as pallet,batchcode from ictran where type in ('INV','CS','DO','PR','DN','TROU')
                and (toinv ='' or toinv is null)
                and (void='' or void is null)
                and fperiod <> '99'
                and location='#location#'
                group by batchcode
                ) as c on a.batchcode=c.batchcode
                where a.batchcode='#getitembatch.batchcode#'
                </cfquery>
                
                <cfelse>
                
                <cfquery name="getbatchpalletbalance" datasource="#dts#">
                select a.batchcode,b.pallet-c.pallet as pallet from obbatch as a
                left join (select ifnull(sum(pallet),0) as pallet,batchcode from ictran where type in ('RC','CN')
                and (void='' or void is null)
                and fperiod <> '99'
                group by batchcode
                ) as b on a.batchcode=b.batchcode
                left join (select ifnull(sum(pallet),0) as pallet,batchcode from ictran where type in ('INV','CS','DO','PR','DN')
                and (toinv ='' or toinv is null)
                and (void='' or void is null)
                and fperiod <> '99'
                group by batchcode
                ) as c on a.batchcode=c.batchcode
                where a.batchcode='#getitembatch.batchcode#'
                </cfquery>
                </cfif>
                <cfif isdefined("enterbatch1")>
               
                <cfinput type="text" name="pallet" id="pallet" value="#(val(getitembatch.pallet))#" maxlength="100" validate="float" message="Please Enter Correct Quantity !" onKeyUp="if (document.getElementById('pallet').value*1 > '#val(getbatchpalletbalance.pallet)+val(getitembatch.pallet)#'){alert('Pallet key is more than balance');document.getElementById('pallet').value='#getitembatch.pallet#'}"> 
 
                <cfelseif isdefined("enterbatch")>
                
                <cfinput type="text" name="pallet" id="pallet" value="#val(getbatchpalletbalance.pallet)#" maxlength="100" validate="float" message="Please Enter Correct Quantity !" onKeyUp="if (document.getElementById('pallet').value*1 > '#getbatchpalletbalance.pallet#'){alert('Pallet key is more than balance');document.getElementById('pallet').value='#getbatchpalletbalance.pallet#'}"> 

                <cfelse>
                <cfinput type="text" name="pallet" id="pallet" value="0" maxlength="100" validate="float" message="Please Enter Correct Quantity !"> 
                </cfif>
                </td>
                </tr>
			<tr>
				<th>Quantity</th>
                <cfquery name="getoldqty" datasource="#dts#">
                select qty_bil from ictran where <cfif listfirst(tran) eq "TR">type='TRIN'<cfelse>type='#tran#'</cfif> and refno='#nexttranno#' and itemcount='#itemcount#'
                </cfquery>
                <cfinput name="oldbatchqty" type="hidden" size="5" value="#getoldqty.qty_bil#">
				<cfif isdefined("enterbatch1")>
					<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#getitembatch.qty#"></td>
				<cfelseif isdefined("enterbatch")>
					<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#getitembatch.batch_balance#"></td>
				<cfelse>
					<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !"></td>
				</cfif>
			</tr>
			<tr><td><br></td></tr>
			<tr>
				<th>#getbatchname.lbatch# Status</th>
				<td align="left">
				<cfif isdefined("enterbatch1")>
					<cfswitch expression="#getitembatch.defective#">
						<cfcase value="D">
							<input name="defective" id="defective" type="radio" value="D"  checked> Damage <br>
							<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
							<input name="defective" id="defective" type="radio" value="R"> Repair <br>
							<input name="defective" id="defective" type="radio" value=""> Good Item
						</cfcase>
						<cfcase value="W">
							<input name="defective" id="defective" type="radio" value="D"> Damage <br>
							<input name="defective" id="defective" type="radio" value="W" checked> Write Off <br>
							<input name="defective" id="defective" type="radio" value="R"> Repair <br>
							<input name="defective" id="defective" type="radio" value=""> Good Item
						</cfcase>
						<cfcase value="R">
							<input name="defective" id="defective" type="radio" value="D"> Damage <br>
							<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
							<input name="defective" id="defective" type="radio" value="R" checked> Repair <br>
							<input name="defective" id="defective" type="radio" value=""> Good Item
						</cfcase>
						<cfcase value="">
							<input name="defective" id="defective" type="radio" value="D"> Damage <br>
							<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
							<input name="defective" id="defective" type="radio" value="R"> Repair <br>
							<input name="defective" id="defective" type="radio" value="" checked> Good Item
						</cfcase>
						<cfdefaultcase>
							<input name="defective" id="defective" type="radio" value="D"> Damage <br>
							<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
							<input name="defective" id="defective" type="radio" value="R"> Repair <br>
							<input name="defective" id="defective" type="radio" value="" checked> Good Item
						</cfdefaultcase>
					</cfswitch>
				<cfelse>
					<input name="defective" id="defective" type="radio" value="D"> Damage <br>
					<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
					<input name="defective" id="defective" type="radio" value="R"> Repair <br>
					<input name="defective" id="defective" type="radio" value="" checked> Good Item
				</cfif>

				</td>
			</tr>
			<tr><td><br></td></tr>
		</table>
		<table align="center">
			<!--- Add on 260808 --->
			<input type="hidden" name="hmode" value="#listfirst(hmode)#">
			<tr>
				<td><input type="submit" name="OK" value="OK"></td>
				<td><input type="reset" name="Reset" value="Reset"></td>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back();"></td>
			</tr>
		</table>
	</cfform>
	<cfelseif getitembatch.recordcount eq 0 and type1 eq "Add" and (listfirst(tran) eq "TR" or listfirst(tran) eq "OAI")>
		<cfform 
		name="enterbatchcode" 
		action="iss4.cfm?
		itemno=#URLEncodedFormat(items)#
		&tran=#URLEncodedFormat(tran)#
		&hmode=#URLEncodedFormat(hmode)#
		&type1=#URLEncodedFormat(type1)#
		&nexttranno=#URLEncodedFormat(nexttranno)#
		&itemcount=#URLEncodedFormat(itemcount)#
		&agenno=#URLEncodedFormat(agenno)#
		&mode=#URLEncodedFormat(mode)#
		&nDateCreate=#URLEncodedFormat(nDateCreate)#" 
		method="post" 
	
		>
			<table align="center">
				<tr>
					<th>Other Charges 1</th>
					<td><cfinput name="mc1bil" type="text" size="10" validate="float" message="Charges 1 Must be in Number Format !"></td>
				</tr>
				<tr>
					<th>Other Charges 2</th>
					<td><cfinput name="mc2bil" type="text" size="10" validate="float" message="Charges 2 Must be in Number Format !"></td>
				</tr>
				<tr><td><br></td></tr>
				<tr>
					<th>Sales Order Date</th>
					<td><cfinput name="sodate" type="text" size="10" validate="eurodate" message="The Sales Order Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
				<tr>
					<th>Delivery Date</th>
					<td><cfinput name="dodate" type="text" size="10" validate="eurodate" message="The Delevery Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
				<tr><td><br></td></tr>
				<tr>
					<th>#getbatchname.lbatch# Code</th>
					<td><cfinput name="enterbatch" type="text" size="10">
							<input type="hidden" name="items" value="#items#">
							<input type="hidden" name="tran" value="#tran#">
							<input type="hidden" name="type1" value="#type1#">
							<input type="hidden" name="nexttranno" value="#nexttranno#">
							<input type="hidden" name="itemcount" value="#itemcount#">
							<input type="hidden" name="agenno" value="#agenno#">
							<cfif listfirst(tran) eq "TR">
								<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
                                <input type="hidden" name="consignment" value="#listfirst(consignment)#">
								<input type="hidden" name="trto" value="#listfirst(trto)#">
								<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
								<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
								<input type="hidden" name="ttran" value="#ttran#">
							<cfelse>
								<input type="hidden" name="location" value="#location#">
								<input type="hidden" name="oldlocation" value="#oldlocation#">
							</cfif>
							
							<!--- ADD ON 26-03-2009 --->
							<input type="hidden" name="grdcolumnlist" value="#grdcolumnlist#">
					        <input type="hidden" name="grdvaluelist" value="#grdvaluelist#">
							<input type="hidden" name="totalrecord" value="#totalrecord#">
							<input type="hidden" name="bgrdcolumnlist" value="#bgrdcolumnlist#">
							<input type="hidden" name="oldgrdvaluelist" value="#oldgrdvaluelist#">
							
							<input type="hidden" name="oldenterbatch" value="">
							<input type="submit" name="searchbatch" value="Search #getbatchname.lbatch# Item">
					</td>
				</tr>
                <tr>
					<th>Manufacturing Date</th>
					<td><cfinput name="manudate" type="text" size="10" validate="eurodate" message="The Manufacturing Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
				<tr>
					<th>Expiry Date</th>
					<td><cfinput name="expdate" type="text" size="10" validate="eurodate" message="The Expiry Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
                <tr>
                <th><cfif lcase(hcomid) eq 'marquis_i'>Lot No<cfelseif lcase(hcomid) eq 'asaiki_i'>PO No<cfelse>Mill Certificate</cfif></th>
                <td><input type="text" name="milcert" id="milcert" value="#getitembatch.milcert#" maxlength="100"> </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">Length<cfelse>Import Permit</cfif></th>
                <td><input type="text" name="importpermit" id="importpermit" value="#getitembatch.importpermit#" maxlength="100"> </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">CUST P/N / REMARK<cfelse>Country Of Origin</cfif></th>
                <td>
                <cfquery name="getcountryoforigin" datasource="#dts#">
                select * from iccolorid
                </cfquery>
                
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#" <cfif getitembatch.countryoforigin eq getcountryoforigin.colorid>selected</cfif>>#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                 </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">SQM<cfelse>Pallet</cfif></th>
                <td><cfinput name="pallet" id="pallet" type="text" value="#val(getitembatch.pallet)#" validate="float" message="Please Enter Correct Quantity !"> </td>
                </tr>
				<tr>
					<th>Quantity<cfinput name="oldbatchqty" type="hidden"></th>
					<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !"></td>
				</tr>
				<tr><td><br></td></tr>
				<tr>
					<th>#getbatchname.lbatch# Status</th>
					<td align="left">
						<input name="defective" id="defective" type="radio" value="D"> Damage <br>
						<input name="defective" id="defective" type="radio" value="W"> Write Off <br>
						<input name="defective" id="defective" type="radio" value="R"> Repair <br>
						<input name="defective" id="defective" type="radio" value="" checked> Good Item
					</td>
				</tr>
				<tr><td><br></td></tr>
			</table>
			<table align="center">
				<tr>
					<td><input type="submit" name="OK" value="OK"></td>
					<td><input type="reset" name="Reset" value="Reset"></td>
					<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back();"></td>
				</tr>
			</table>
		</cfform>
	<cfelse>
		<h1 align="center">No Batch Record For Item <font color="red">#items#</font></h1>
		<table align="center">
			<tr>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back();"></td>
			</tr>
		</table>
	</cfif>
</cfif>
</cfoutput>

</body>
</html>