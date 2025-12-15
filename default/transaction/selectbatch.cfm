<html>
<head>
<title>Select Batch Item</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfquery name="getbatchname" datasource="#dts#">
SELECT lbatch FROM gsetup
</cfquery>
<cfquery name="checkquobatch" datasource="#dts#">
SELECT quobatch FROM gsetup
</cfquery>
<cfset quovalid = 0>
<cfif isdefined('form.tran')>
<cfif checkquobatch.quobatch eq "Y" and (form.tran eq "QUO" or form.tran eq "SO" or form.tran eq "PO" or form.tran eq "RQ")>
<cfset quovalid = 1>
</cfif>
</cfif>
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
<cfelse>
	<script language="javascript" type="text/javascript">
		function putbatchinfo(){}
	</script>
</cfif>
</head>

<body onLoad="putbatchinfo();">

<cfoutput>
<cfif isdefined("bmode") and bmode eq "search">
	<cfquery name="getitembatch" datasource="#dts#">
		<cfif trim(location) neq "">
			<cfif HcomID eq "remo_i">
				select 
				a.location,
				a.batchcode,
				a.itemno,'' as location,
				a.rc_type,
				a.rc_refno,
				((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
				a.expdate as exp_date,
                a.manudate as manu_date  ,
                milcert,importpermit,
                countryoforigin,
                pallet
				from lobthob as a 
				left join 
				(
					select 
					batchcode,
					itemno,
					location, 
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
				and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0 
				order by a.itemno;
                <cfelseif HcomID eq "hempel_i">
                <cfif form.tran eq 'SO'>
                select 
				a.location,
				a.batchcode,
				a.itemno,'' as location,
				a.rc_type,
				a.rc_refno,
				((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
				a.expdate as exp_date,
                a.manudate as manu_date  ,
                milcert,importpermit,
                countryoforigin,
                pallet
				from lobthob as a 
				left join 
				(
					select 
					batchcode,
					itemno,
					location, 
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
				and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0 
				order by a.itemno;
                <cfelse>
				select 
				batchcode,location,
				rc_type,
				rc_refno,
				((bth_qob+bth_qin)-bth_qut) as batch_balance,
				expdate as exp_date,
                manudate as manu_date ,
                milcert,importpermit,
                countryoforigin,
                pallet
				from lobthob 
				where itemno='#items#' 
				and ((bth_qob+bth_qin)-bth_qut) >0 
				order by itemno;
                </cfif>
			<cfelse>
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
				and (void = '' or void is null)  and batchcode<>'' and location<>''
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
                a.manu_date ,
                milcert,importpermit,
                countryoforigin,
                pallet
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
				and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0 
				order by a.itemno;
            <cfelseif HcomID eq "hempel_i">
            	<cfif form.tran eq 'SO'>
                select 
				a.location,
				a.batchcode,
				a.itemno,'' as location,
				a.rc_type,
				a.rc_refno,
				((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
				a.expdate as exp_date,
                a.manudate as manu_date  ,
                milcert,importpermit,
                countryoforigin,
                pallet
				from lobthob as a 
				left join 
				(
					select 
					batchcode,
					itemno,
					location, 
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
				and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0 
				order by a.itemno;
                <cfelse>
				select 
				batchcode,location,
				rc_type,
				rc_refno,
				((bth_qob+bth_qin)-bth_qut) as batch_balance,
				expdate as exp_date,
                manudate as manu_date ,
                milcert,importpermit,
                countryoforigin,
                pallet
				from lobthob 
				where itemno='#items#' 
				and ((bth_qob+bth_qin)-bth_qut) >0 
				order by itemno;
                </cfif>
			<cfelse>
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
	</cfquery>
	
	<cfif getitembatch.recordcount neq 0>
	<h1 align="center">Select #getbatchname.lbatch# Code For Item <font color="red">#items#</font></h1>
	<form name="selectbatchcode" action="" method="post">
		<table align="center" cellpadding="2" cellspacing="0">
			<tr>
				<th>#getbatchname.lbatch# code</th>
                <th>Import Permit</th>
                <th>location</th>
				<th>Expiry Date</th>
				<th>Receive Type</th>
				<th>Receive's Reference No.</th>
                <th>Receive's Date</th>
				<th>Quantity On Hand</th>
                <cfif HcomID eq "hempel_i">
                <th>Cap</th>
                <th>Weight</th>
                </cfif>
				<th>Action</th>
			</tr>
			<cfloop query="getitembatch">
            
				<cfif (getitembatch.currentrow mod 2) eq 0>
					<tr bgcolor="##99FF00">
				<cfelse>
					<tr bgcolor="##66CCFF">
				</cfif>
					<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>#getitembatch.batchcode#</strong></font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong>#getitembatch.importpermit#</strong></font></div></td>
					
                    <td><div align="left"><font size="2" face="Times New Roman,Times,serif"><cfif isdefined('getitembatch.location')>#getitembatch.location#<cfelse></cfif></font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#dateformat(getitembatch.exp_date,"dd-mm-yyyy")#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitembatch.rc_type#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getitembatch.rc_refno#</font></div></td>
                    <cfquery name="getreceivedate" datasource="#dts#">
                    select wos_date from artran where type='#getitembatch.rc_type#' and refno='#getitembatch.rc_refno#'
                    </cfquery>
                    <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#dateformat(getreceivedate.wos_date,'dd-mm-yyyy')#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#val(getitembatch.batch_balance)#</font></div></td>
                    <cfif HcomID eq "hempel_i">
                    <cfquery name="getitemprice" datasource="#dts#">
                    select price from ictran where itemno='#items#' and type='RC' and batchcode='#getitembatch.batchcode#' and refno='#getitembatch.rc_refno#'  and location='#getitembatch.location#'
                    </cfquery>
                    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(val(getitemprice.price),',_.__')#</font></div></td>
                    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#numberformat(val(getitembatch.batch_balance)*(round(val(getitemprice.price)*100)/100),',_.__')#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman,Times,serif">
					<a href="selectbatch.cfm?
					enterbatch=#URLEncodedFormat(getitembatch.batchcode)#
					&items=#URLEncodedFormat(listfirst(items))#
                    &bmanudate=#URLEncodedFormat(getitembatch.manu_date)#
                    &milcert=#URLEncodedFormat(getitembatch.milcert)#
                    &importpermit=#URLEncodedFormat(getitembatch.importpermit)#
                    &countryoforigin=#URLEncodedFormat(getitembatch.countryoforigin)#
                    &pallet=#URLEncodedFormat(getitembatch.pallet)#
					&bexpdate=#URLEncodedFormat(getitembatch.exp_date)#
					&oldenterbatch=#URLEncodedFormat(listfirst(oldenterbatch))#
					&bqty=#val(getitembatch.batch_balance)#
					&hmode=#URLEncodedFormat(listfirst(hmode))#
					&tran=#URLEncodedFormat(listfirst(tran))#
					&type1=#URLEncodedFormat(listfirst(type1))#
					&nexttranno=#URLEncodedFormat(listfirst(nexttranno))#
					&oldqty=#URLEncodedFormat(listfirst(oldqty))#
					&itemcount=#URLEncodedFormat(listfirst(itemcount))#
					&service=#URLEncodedFormat(listfirst(service))#
					&agenno=#URLEncodedFormat(listfirst(agenno))#
					&currrate=#URLEncodedFormat(listfirst(currrate))#
					&refno3=#URLEncodedFormat(listfirst(refno3))#
					&location=#URLEncodedFormat(listfirst(location))#
					&oldlocation=#URLEncodedFormat(listfirst(oldlocation))#
					&comment=#URLEncodedFormat(comment)#
					&newtrancode=#newtrancode#&multilocation=#multilocation#&ndatecreate=#ndatecreate#"
					>Select</a></font></div>
					</td>
				</tr>
			</cfloop>
			<tr><td><br></td></tr>
		</table>
		<table align="center">
			<tr>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back()"></td>
			</tr>
		</table>
	</form>
	<cfelse>
		<h1 align="center">No #getbatchname.lbatch# Code For Item <font color="red">#items#</font></h1>
		<table align="center">
			<tr>
				<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back()"></td>
			</tr>
		</table>
	</cfif>
<cfelse>
	<cfif isdefined("enterbatch1")>
		<!--- Modified on 020908, Add the Condition: "and refno ='#nexttranno#'" --->
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif trim(location) neq "">
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
				and type='#tran#'
				and refno ='#nexttranno#';
			<cfelse>
				select 
				expdate,
                manudate,
                '' as location,
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
				and type='#tran#'
				and refno ='#nexttranno#';
			</cfif>
		</cfquery>
	<cfelseif isdefined("enterbatch")>
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif trim(location) neq "">
				<cfif HcomID eq "remo_i">
					select 
					a.location,
					a.batchcode,
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
						batchcode,
						itemno,
						location, 
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
					and a.itemno='#items#';
				<cfelse>
                <!---
					select 
					location,
					batchcode,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate,
                    manudate ,
                    milcert,IMPORTPERMIT,
                    countryoforigin,
                    pallet
					from lobthob 
					where location='#location#' 
					and batchcode='#enterbatch#' 
					and itemno='#items#';
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
					a.batchcode,'' as location,
					a.itemno,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.exp_date as expdate,
                    a.manu_date as manudate ,
                    milcert ,importpermit,
                    countryoforigin,
                    pallet
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
					and a.itemno='#items#';
				<cfelse>
                	<!---
					select 
					batchcode,'' as location,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					exp_date as expdate,
                    manu_date as manudate ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
					from obbatch 
					where batchcode='#enterbatch#' 
					and itemno='#items#';
                    --->
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
		</cfquery>
	<cfelse>
		<cfquery name="getitembatch" datasource="#dts#">
			<cfif trim(location) neq "">
				<cfif HcomID eq "remo_i">
					select 
					a.location,
					a.itemno,
					a.batchcode,
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
						batchcode,
						itemno,
						location, 
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
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0;
                    
				<cfelse>
                	<!---
					select 
					location,
					batchcode,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate,
                    manudate,
                    milcert,IMPORTPERMIT,
                    countryoforigin,
                    pallet
					from lobthob 
					where location='#location#' 
					and itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) >0;--->
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
					a.itemno,'' as location,
					((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
					a.exp_date as expdate,
                    a.manu_date as manudate  ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
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
					and ((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) >0;
                <cfelseif HcomID eq "hempel_i">
                 select 
					location,
					batchcode,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					expdate,
                    manudate,
                    milcert,IMPORTPERMIT,
                    countryoforigin,
                    pallet
					from lobthob 
					where itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) >0;
				<cfelse>
                <!---
					select 
					batchcode,'' as location,
					((bth_qob+bth_qin)-bth_qut) as batch_balance,
					exp_date as expdate,
                    manu_date as manudate ,
                    milcert,importpermit,
                    countryoforigin,
                    pallet
					from obbatch 
					where itemno='#items#' 
					and ((bth_qob+bth_qin)-bth_qut) >0;--->
                    
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
		</cfquery>
	</cfif>

	<cfif getitembatch.recordcount neq 0>
		<h1 align="center">Select #getbatchname.lbatch# For Item <font color="red">#items#</font></h1>
        <cfset batchitemprice=0>
        <cfif HcomID eq "hempel_i">
                    <cfquery name="getitemprice" datasource="#dts#">
                    select price from ictran where itemno='#items#' and type='RC' and batchcode='#getitembatch.batchcode#' and location='#getitembatch.location#'
                    </cfquery>
        <cfset batchitemprice=getitemprice.price>
        <cfelse>
        <cfset batchitemprice=0>
        </cfif>
		<cfform 
		name="enterbatchcode" 
		action="transaction4.cfm?
		itemno=#URLEncodedFormat(listfirst(items))#
		&hmode=#URLEncodedFormat(listfirst(hmode))#
		&tran=#URLEncodedFormat(listfirst(tran))#
		&type1=#URLEncodedFormat(listfirst(type1))#
		&nexttranno=#URLEncodedFormat(listfirst(nexttranno))#
		&itemcount=#URLEncodedFormat(listfirst(itemcount))#
		&service=#URLEncodedFormat(listfirst(service))#
		&agenno=#URLEncodedFormat(listfirst(agenno))#
		&currrate=#URLEncodedFormat(listfirst(currrate))#
		&refno3=#URLEncodedFormat(listfirst(refno3))#
		&comment=#URLEncodedFormat(comment)#
		&newtrancode=#newtrancode#&multilocation=#multilocation#&ndatecreate=#ndatecreate#&location=#URLEncodedFormat(getitembatch.location)#&price=#batchitemprice#" 
		method="post" 
		onSubmit="validate()"
		>
			<table align="center">
				<tr>
					<th>Other Charges 1</th>
					<cfif isdefined("enterbatch1")>
						<td><cfinput name="mc1bil" type="text" size="10" validate="float" message="Charges 1 Must be in Number Format !" value="#numberformat(getitembatch.mc1_bil,'0.00')#"></td>
					<cfelse>
						<td><cfinput name="mc1bil" type="text" size="10" value="0" validate="float" message="Charges 1 Must be in Number Format !"></td>
					</cfif>
				</tr>
				<tr>
					<th>Other Charges 2</th>
					<cfif isdefined("enterbatch1")>
						<td><cfinput name="mc2bil" type="text" size="10" validate="float" message="Charges 2 Must be in Number Format !" value="#numberformat(getitembatch.mc2_bil,'0.00')#"></td>
					<cfelse>
						<td><cfinput name="mc2bil" type="text" size="10" value="0" validate="float" message="Charges 2 Must be in Number Format !"></td>
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
							<cfinput name="enterbatch" type="text" size="25" value="#listfirst(enterbatch)#">
							<cfinput name="oldenterbatch" type="hidden" size="10" value="#listfirst(oldenterbatch)#">
						<cfelseif isdefined("enterbatch1")>
							<cfinput name="enterbatch" type="text" size="25" value="#listfirst(enterbatch1)#">
							<cfinput name="oldenterbatch" type="hidden" size="10" value="#listfirst(enterbatch1)#">
						<cfelse>
							<cfinput name="enterbatch" type="text" size="25">
						</cfif>
						<cfif isdefined("enterbatch")>
							<input type="hidden" name="items" value="#listfirst(items)#">
							<input type="hidden" name="hmode" value="#listfirst(hmode)#">
							<input type="hidden" name="tran" value="#listfirst(tran)#">
							<input type="hidden" name="type1" value="#listfirst(type1)#">
							<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
							<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
							<input type="hidden" name="service" value="#listfirst(service)#">
							<input type="hidden" name="agenno" value="#listfirst(agenno)#">
							<input type="hidden" name="currrate" value="#listfirst(currrate)#">
							<input type="hidden" name="refno3" value="#listfirst(refno3)#">
							<input type="hidden" name="location" value="#listfirst(location)#">
							<input type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
							<input type="hidden" name="comment" value="#comment#">
						<cfelseif isdefined("enterbatch1")>
							<input type="hidden" name="items" value="#listfirst(items)#">
							<input type="hidden" name="hmode" value="#listfirst(hmode)#">
							<input type="hidden" name="tran" value="#listfirst(tran)#">
							<input type="hidden" name="type1" value="#listfirst(type1)#">
							<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
							<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
							<input type="hidden" name="service" value="#listfirst(service)#">
							<input type="hidden" name="agenno" value="#listfirst(agenno)#">
							<input type="hidden" name="currrate" value="#listfirst(currrate)#">
							<input type="hidden" name="refno3" value="#listfirst(refno3)#">
							<input type="hidden" name="location" value="#listfirst(location)#">
							<input type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
							<input type="hidden" name="comment" value="#comment#">
						<cfelse>
							<input type="hidden" name="items" value="#listfirst(items)#">
							<input type="hidden" name="hmode" value="#listfirst(hmode)#">
							<input type="hidden" name="tran" value="#listfirst(tran)#">
							<input type="hidden" name="type1" value="#listfirst(type1)#">
							<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
							<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
							<input type="hidden" name="service" value="#listfirst(service)#">
							<input type="hidden" name="agenno" value="#listfirst(agenno)#">
							<input type="hidden" name="currrate" value="#listfirst(currrate)#">
							<input type="hidden" name="refno3" value="#listfirst(refno3)#">
							<input type="hidden" name="location" value="#listfirst(location)#">
							<input type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
							<input type="hidden" name="oldenterbatch" value="">
							<input type="hidden" name="comment" value="#comment#">
						</cfif>
						<input type="submit" name="searchbatch" value="Search #getbatchname.lbatch# Item">
					</td>
				</tr>
                <tr>
					<th>Manufacturing Date</th>
					<cfif isdefined("enterbatch1")>
						<cfif enterbatch1 neq "">
							<td><cfinput name="manudate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
						<cfelse>
							<td><cfinput name="manudate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
						</cfif>
					<cfelseif isdefined("enterbatch")>
						<td><cfinput name="manudate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Manufacturing Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.manudate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
					<cfelse>
						<td><cfinput name="manudate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Manufacturing Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
					</cfif>		
				</tr>
				<tr>
					<th>Expiry Date</th>
					<cfif isdefined("enterbatch1")>
						<cfif enterbatch1 neq "">
							<td><cfinput name="expdate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Expiry Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.expdate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
						<cfelse>
							<td><cfinput name="expdate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Expiry Date Must Be dd-mm-yyyy !" value="#dateformat(getitembatch.expdate,'dd-mm-yyyy')#">(e.g dd-mm-yyyy)</td>
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
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">Width<cfelse>Import Permit</cfif></th>
                <cfif lcase(hcomid) eq 'marquis_i' and isdefined('form.batchbrem2hid')>    
                <cfset getitembatch.importpermit = trim(form.batchbrem2hid)>
				</cfif>
                <td><input type="text" name="importpermit" id="importpermit" value="#getitembatch.importpermit#" maxlength="100" <cfif lcase(hcomid) neq "asaiki_i">readonly</cfif>> </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">CUST P/N / REMARK<cfelse>Country Of Origin</cfif></th>
                <td>
                <cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">
                <input type="text" name="countryoforigin" id="countryoforigin" value="<cfif isdefined("getitembatch.countryoforigin")>#getitembatch.countryoforigin#</cfif>" maxlength="150">
                <cfelse>
                <cfquery name="getcountryoforigin" datasource="#dts#">
                select * from iccolorid
                </cfquery>
                <cfif isdefined("enterbatch1")>
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#" <cfif getitembatch.countryoforigin eq getcountryoforigin.colorid>selected</cfif>>#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                <cfelseif isdefined("enterbatch")>
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#" <cfif getitembatch.countryoforigin eq getcountryoforigin.colorid>selected</cfif>>#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                <cfelse>
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#">#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                </cfif>
                </cfif>
                </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">SQM<cfelse>Pallet</cfif></th>
                <td>
                <cfif trim(location) neq "">
                <cfquery name="getbatchpalletbalance" datasource="#dts#">
                select a.batchcode,ifnull(b.pallet,0)-ifnull(c.pallet,0) as pallet from obbatch as a
                left join (select sum(pallet) as pallet,batchcode from ictran where type in ('RC','CN','TRIN')
                and (void='' or void is null)
                and fperiod <> '99'
                and location='#location#'
                group by batchcode
                ) as b on a.batchcode=b.batchcode
                left join (select sum(pallet) as pallet,batchcode from ictran where type in ('INV','CS','DO','PR','DN','TROU')
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
                select a.batchcode,ifnull(b.pallet,0)-ifnull(c.pallet,0) as pallet from obbatch as a
                left join (select sum(pallet) as pallet,batchcode from ictran where type in ('RC','CN')
                and (void='' or void is null)
                and fperiod <> '99'
                group by batchcode
                ) as b on a.batchcode=b.batchcode
                left join (select sum(pallet) as pallet,batchcode from ictran where type in ('INV','CS','DO','PR','DN')
                and (toinv ='' or toinv is null)
                and (void='' or void is null)
                and fperiod <> '99'
                group by batchcode
                ) as c on a.batchcode=c.batchcode
                where a.batchcode='#getitembatch.batchcode#'
                </cfquery>
                </cfif>

				
				<cfif isdefined("enterbatch1")>
               
                <cfinput type="text" name="pallet" id="pallet" value="#val(getitembatch.pallet)#" maxlength="100" validate="float" message="Please Enter Correct Quantity !" onKeyUp="if (document.getElementById('pallet').value*1 > '#val(getbatchpalletbalance.pallet)+val(getitembatch.pallet)#'){alert('Pallet key is more than balance');document.getElementById('pallet').value='#val(getitembatch.pallet)#'}"> 
 
                <cfelseif isdefined("enterbatch")>
                
                <cfinput type="text" name="pallet" id="pallet" value="#getbatchpalletbalance.pallet#" maxlength="100" validate="float" message="Please Enter Correct Quantity !" onKeyUp="if (document.getElementById('pallet').value*1 > '#getbatchpalletbalance.pallet#'){alert('Pallet key is more than balance');document.getElementById('pallet').value='#getbatchpalletbalance.pallet#'}"> 

                <cfelse>
                <cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">
                <cfinput type="text" name="pallet" id="pallet" value="0" maxlength="100" validate="float" message="Please Enter Correct Quantity !" onKeyUp="document.getElementById('batchqty').value=document.getElementById('pallet').value;"> 
                <cfelse>
                <cfinput type="text" name="pallet" id="pallet" value="0" maxlength="100" validate="float" message="Please Enter Correct Quantity !"> 
                </cfif>
                </cfif>
                </td>
                </tr>
				<tr>
					<th>Quantity</th>
					<input type="hidden" name="oldqty" value="#listfirst(oldqty)#">
					<cfif isdefined("enterbatch1")>
						<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#getitembatch.qty#"></td>
					<cfelseif isdefined("enterbatch")>
						<td><cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#getitembatch.batch_balance#"></td>
					<cfelse>
						<td><cfif lcase(hcomid) eq 'marquis_i' and isdefined('form.batchqtyhid')>
                        <cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#val(form.batchqtyhid)#" >
                        <cfelseif hcomid eq "bestform_i">
                        <cfinput name="batchqty" type="text" size="5" value="1" validate="float" message="Please Enter Correct Quantity !" >
						<cfelse>
                        <cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" >
						</cfif></td>	
					</cfif>
                    
				</tr>
                <cfif lcase(hcomid) eq 'marquis_i'>
                <tr>
                <th>Cap</th>
                <td>
                <cfif isdefined('form.batchpricehid') eq false>
                <cfquery name="getpricebatch" datasource="#dts#">
                SELECT price_bil FROM ictran WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#items#"> and batchcode = <cfif isdefined("enterbatch")>"#enterbatch#"<cfelseif isdefined("enterbatch1")>"#enterbatch1#"<cfelse>""</cfif> and trim(brem2) = "#trim(getitembatch.importpermit)#" and batchcode <> "" and batchcode is not null
                </cfquery>
				</cfif>
                
                <input type="text" readonly name="batchcap" id="batchcap" value="<cfif isdefined('form.batchpricehid')>#form.batchpricehid#<cfelseif getpricebatch.recordcount neq 0>#val(getpricebatch.price_bil)#</cfif>">
                </td>
                </tr>
                </cfif>
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
				<tr>
					<td><input type="submit" name="OK" value="OK"></td>
					<td><input type="reset" name="Reset" value="Reset"></td>
					<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back()"></td>
				</tr>
			</table>
		</cfform>
	<cfelseif getitembatch.recordcount eq 0 and (form.type1 eq "Add" or form.type1 eq "Edit") and (form.tran eq "RC" or form.tran eq "CN" or form.tran eq "OAI" or quovalid eq 1)>
		<h1 align="center">Select #getbatchname.lbatch# For Item <font color="red">#items#</font></h1>
		<cfform 
		name="enterbatchcode" 
		action="transaction4.cfm?
		itemno=#URLEncodedFormat(listfirst(items))#
		&hmode=#URLEncodedFormat(listfirst(hmode))#
		&tran=#URLEncodedFormat(listfirst(tran))#
		&type1=#URLEncodedFormat(listfirst(type1))#
		&nexttranno=#URLEncodedFormat(listfirst(nexttranno))#
		&itemcount=#URLEncodedFormat(listfirst(itemcount))#
		&service=#URLEncodedFormat(listfirst(service))#
		&agenno=#URLEncodedFormat(listfirst(agenno))#
		&currrate=#URLEncodedFormat(listfirst(currrate))#
		&refno3=#URLEncodedFormat(listfirst(refno3))#
		&comment=#URLEncodedFormat(comment)#
		&newtrancode=#newtrancode#&multilocation=#multilocation#&ndatecreate=#ndatecreate#" 
		method="post" 
		onSubmit="validate()"
		>
			<table align="center">
				<tr>
					<th>Other Charges 1</th>
					<td><cfinput name="mc1bil" type="text" size="10" validate="float" value="0" message="Charges 1 Must be in Number Format !"></td>
				</tr>
				<tr>
					<th>Other Charges 2</th>
					<td><cfinput name="mc2bil" type="text" size="10" validate="float" value="0" message="Charges 2 Must be in Number Format !"></td>
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
					<td><cfinput name="enterbatch" type="text" size="25">
							<input type="hidden" name="items" value="#listfirst(items)#">
							<input type="hidden" name="hmode" value="#listfirst(hmode)#">
							<input type="hidden" name="tran" value="#listfirst(tran)#">
							<input type="hidden" name="type1" value="#listfirst(type1)#">
							<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
							<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
							<input type="hidden" name="service" value="#listfirst(service)#">
							<input type="hidden" name="agenno" value="#listfirst(agenno)#">
							<input type="hidden" name="currrate" value="#listfirst(currrate)#">
							<input type="hidden" name="refno3" value="#listfirst(refno3)#">
							<input type="hidden" name="location" value="#listfirst(location)#">
							<input type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
							<input type="hidden" name="oldenterbatch" value="">
							<input type="hidden" name="comment" value="#comment#">
							<input type="submit" name="searchbatch" value="Search #getbatchname.lbatch# Item">
					</td>
				</tr>
                <tr>
					<th>Manufacturing Date</th>
					<td><cfinput name="manudate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Manufacturing Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
				<tr>
					<th>Expiry Date</th>
					<td><cfinput name="expdate" type="text" size="10" validate="eurodate" mask="99-99-9999" message="The Expiry Date Must Be dd-mm-yyyy !">(e.g dd-mm-yyyy)</td>
				</tr>
                <tr>
                <th><cfif lcase(hcomid) eq 'marquis_i'>Lot No<cfelseif lcase(hcomid) eq 'asaiki_i'>PO No<cfelse>Mill Certificate</cfif></th>
                <td><input type="text" name="milcert" id="milcert" value="" maxlength="100"> </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">Length<cfelse>Import Permit</cfif></th>
                <td><input type="text" name="importpermit" id="importpermit" value="<cfif lcase(hcomid) eq 'marquis_i' and isdefined('form.batchbrem2hid')>#trim(form.batchbrem2hid)#<cfelse></cfif>" maxlength="100"> </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">CUST P/N / REMARK<cfelse>Country Of Origin</cfif></th>
                <td>
                <cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">
                <input type="text" name="countryoforigin" id="countryoforigin" value="<cfif isdefined("getitembatch.countryoforigin")></cfif>" maxlength="150">
                <cfelse>
                <cfquery name="getcountryoforigin" datasource="#dts#">
                select * from iccolorid
                </cfquery>
                
                <select name="countryoforigin" id="countryoforigin">
                <option value="">Select a Country Of Origin</option>
                <cfloop query="getcountryoforigin">
                <option value="#getcountryoforigin.colorid#" <cfif getitembatch.countryoforigin eq getcountryoforigin.colorid>selected</cfif>>#getcountryoforigin.colorid# - #getcountryoforigin.desp#</option>
                </cfloop>
                </select>
                </cfif>
                </td>
                </tr>
                <tr>
                <th><cfif lcase(hcomid) eq "asaiki_i" or lcase(hcomid) eq "netivan_i">SQM<cfelse>Pallet</cfif></th>
                <td><input type="text" name="pallet" id="pallet" value="" maxlength="100"> </td>
                </tr>
				<tr>
					<th>Quantity</th>
					<input type="hidden" name="oldqty" value="#listfirst(oldqty)#">
					<td><cfif lcase(hcomid) eq 'marquis_i' and isdefined('form.batchqtyhid')>
                        <cfinput name="batchqty" type="text" size="5" validate="float" message="Please Enter Correct Quantity !" value="#val(form.batchqtyhid)#" >
                        <cfelseif lcase(hcomid) eq 'besform_i'>
                        <cfinput name="batchqty" type="text" size="5" value="1" validate="float" message="Please Enter Correct Quantity !" >
						<cfelse>
                        <cfinput name="batchqty" type="text" size="5" validate="float"  message="Please Enter Correct Quantity !" >
						</cfif></td>	
				</tr>
                 <cfif lcase(hcomid) eq 'marquis_i'>
                <tr>
                <th>Cap</th>
                <td>
                <cfif isdefined('form.batchpricehid') eq false>
                <cfquery name="getpricebatch" datasource="#dts#">
                SELECT price_bil FROM ictran WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#items#"> and batchcode = <cfif isdefined("enterbatch")>"#enterbatch#"<cfelseif isdefined("enterbatch1")>"#enterbatch1#"<cfelse>""</cfif> and trim(brem2) = "#trim(getitembatch.importpermit)#" and batchcode <> "" and batchcode is not null
                </cfquery>
				</cfif>
                
                <input type="text" readonly name="batchcap" id="batchcap" value="<cfif isdefined('form.batchpricehid')>#form.batchpricehid#<cfelseif getpricebatch.recordcount neq 0>#val(getpricebatch.price_bil)#</cfif>">
                </td>
                </tr>
                </cfif>
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
					<td><input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back()"></td>
				</tr>
			</table>
		</cfform>
	<cfelse>
		<h1 align="center">No #getbatchname.lbatch# Record For Item <font color="red">#items#</font></h1>
		<table align="center">
			<tr>	
				<td>
					<input type="button" name="Back" value="Back" onClick="javascript:history.back();javascript:history.back()">
				</td>
			</tr>
		</table>
	</cfif>
</cfif>
</cfoutput>

</body>
</html>