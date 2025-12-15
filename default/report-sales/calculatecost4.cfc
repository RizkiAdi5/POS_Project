<cfcomponent>
	<cffunction name="calculate_first_in_fist_out_cost">
		<cfargument name="dts" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		
		<cfquery name="getgeneral" datasource="#arguments.dts#">
			select 
			date_format(lastaccyear,'%Y-%m-%d') as lastaccyear,CNbaseonprice
			from gsetup;
		</cfquery>
		
		<cfquery name="getitem" datasource="#arguments.dts#">
			select 
			a.itemno,
			ifnull(a.qtybf,0) as qtybf 
			from icitem as a,
			(
				select 
				itemno 
				from ictran 
				where 
				type in ('RC','OAI','CN','INV','DO','CS','DN','ISS','OAR','PR')
				and (toinv='' or toinv is null) 
				and (void = '' or void is null) 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>			
				group by itemno
			) as b 
			where a.itemno=b.itemno 
			order by a.itemno;
		</cfquery>

		<cfloop query="getitem">
			<cfset itemno = getitem.itemno>
			
			<cfif getitem.qtybf neq 0>
				<cfquery name="check_bfcost" datasource="#dts#">
					select 
					ffq11,ffc11,	ffq12,ffc12,	ffq13,ffc13,	ffq14,ffc14,	ffq15,ffc15,
					ffq16,ffc16,	ffq17,ffc17,	ffq18,ffc18,	ffq19,ffc19,	ffq20,ffc20,
					ffq21,ffc21,	ffq22,ffc22,	ffq23,ffc23,	ffq24,ffc24,	ffq25,ffc25,
					ffq26,ffc26,	ffq27,ffc27,	ffq28,ffc28,	ffq29,ffc29,	ffq30,ffc30,
					ffq31,ffc31,	ffq32,ffc32,	ffq33,ffc33,	ffq34,ffc34,	ffq35,ffc35,
					ffq36,ffc36,	ffq37,ffc37,	ffq38,ffc38,	ffq39,ffc39,	ffq40,ffc40,
					ffq41,ffc41,	ffq42,ffc42,	ffq43,ffc43,	ffq44,ffc44,	ffq45,ffc45,
					ffq46,ffc46,	ffq47,ffc47,	ffq48,ffc48,	ffq49,ffc49,	ffq50,ffc50
					from fifoopq 
					where itemno='#itemno#';
				</cfquery>
			</cfif>

			<cfquery name="getstockout" datasource="#arguments.dts#">
				select 
				type,
				refno,
				itemcount,
				ifnull(qty,0) as qty,
				ifnull(amt,0) as amt
				from ictran 
				where itemno='#itemno#'
				and wos_date > "#getgeneral.lastaccyear#"
				and (void = '' or void is null) and (toinv='' or toinv is null) 
				and type in ('INV','CS','DN','PR','DO','ISS','OAR')
				order by wos_date,trdatetime,refno,itemcount;
			</cfquery>
			
			<cfquery name="getstockin" datasource="#arguments.dts#">
				<cfif getitem.qtybf neq 0 and check_bfcost.recordcount neq 0>
					select 
					type,
					refno,
					itemcount,
					counter,
					qty,
					amt,
					it_cos,
                    trdatetime,
					wos_date 
					from 
					(
					<cfloop index="a" from="11" to="50">
						<cfif evaluate("check_bfcost.ffq#a#") neq 0>
							(
								select 
								'RC' as type,
								'' as refno,
								'0' as itemcount,
								'#a#' as counter,
								ffq#a# as qty,
								(ffq#a#*ffc#a#) as amt,
								ffc#a# as it_cos,
                                '#getgeneral.lastaccyear#' as trdatetime,
								'#getgeneral.lastaccyear#' as wos_date
								from fifoopq 
								where itemno='#itemno#'
							)
							union
						</cfif>
					</cfloop>
						(
							select 
							type,
							refno,
							itemcount,
							'1' as counter,
							ifnull(qty,0) as qty,
                            <cfif isdefined ('form.cbincludecharge')>
                            ifnull(amt+M_charge1+M_charge2+M_charge3+M_charge4+M_charge5+M_charge6+M_charge7,0) as amt
                            <cfelse>
							ifnull(amt,0) as amt,
                            </cfif>
							it_cos,
                            trdatetime,
							wos_date 
							from ictran 
							where itemno='#itemno#' and 
							<cfif dts eq "chemline_i">
                            wos_date > "2010-11-01"
                            <cfelse>
                            wos_date > "#getgeneral.lastaccyear#"
                            </cfif>
							and (void = '' or void is null) 
							and type in ('RC','CN','OAI')
							order by wos_date,trdatetime,refno,itemcount
						)
					) as a 
					order by wos_date,refno,itemcount,counter desc;
				<cfelse>
					select 
					type,
					refno,
					itemcount,
					'1' as counter,
					ifnull(qty,0) as qty,
                    <cfif isdefined ('form.cbincludecharge')>
                            ifnull(amt+M_charge1+M_charge2+M_charge3+M_charge4+M_charge5+M_charge6+M_charge7,0) as amt,
                    <cfelse>
					ifnull(amt,0) as amt,
                    </cfif>
					it_cos,
                    trdatetime,
                    wos_date
					from ictran 
					where itemno='#itemno#' and 
                    <cfif dts eq "chemline_i">
                   	wos_date > "2010-11-01"
					<cfelse>
					wos_date > "#getgeneral.lastaccyear#"
                    </cfif>
					and (void = '' or void is null) 
					and type in ('RC','CN','OAI')
					order by wos_date,trdatetime,refno,itemcount;
				</cfif>
			</cfquery>
	
			<cfloop query="getstockin">
				<cfif getstockin.type eq "CN">
                 
					<cfset refno = getstockin.refno>
					<cfset itemcount = getstockin.itemcount>
					<cfset cnqty = getstockin.qty>
					<cfset cnamt = getstockin.amt>
					<cfset count = getstockin.currentrow>
					<cfset count = count - 1>
					<cfif count neq 0>
                    <cfif getstockout.recordcount eq 0>
                    <cftry>
                    <cfquery datasource="#dts#" name="emptyall">
                    truncate fifotemp
                    </cfquery>
                    <cfquery name="getstockoutcount" datasource="#dts#">
                    select 
                    type,
                    refno,
                    itemcount,
                    ifnull(qty,0) as qty,
                    ifnull(amt,0) as amt
                    from ictran 
                    where itemno='#itemno#'
                    and wos_date > "#getgeneral.lastaccyear#"
                    and (void = '' or void is null) and (toinv='' or toinv is null) 
                    and type in ('INV','CS','DN','PR','DO','ISS','OAR')
                    and trdatetime < "#getstockin.trdatetime#"
                    order by wos_date,trdatetime,refno,itemcount;
                    </cfquery>
             
					<cfloop query="getstockin" startrow="1" endrow="#count#">
                    <cfquery name="insertin" datasource="#dts#">
                    INSERT INTO fifotemp (lastin,lastamt,balance)
                    values(
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(getstockin.qty)#">,
                    <cfif getstockin.type eq "CN">
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(getstockin.it_cos)#">,
					<cfelse>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(getstockin.amt)#">,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(getstockin.qty)#">
                    )
                    </cfquery>
                    </cfloop>
                    <cfset countin = 1>
                    
                    <cfquery name="getfifotemp" datasource="#dts#">
                    SELECT * FROM fifotemp
                    </cfquery>
                    
                    <cfloop query="getstockoutcount">
                    <cfset loopcontrol = 1>
                    <cfset balanceoutqty = getstockoutcount.qty>
                    <cfloop condition="loopcontrol GT 0" >
                    
                        <cfloop query="getfifotemp" startrow="#countin#"  endrow="#countin#">
							<cfset balanceleft = getfifotemp.balance - balanceoutqty>
								<cfif balanceleft lt 0>
									<cfset updatedata = 0>
                                    <cfset countin = countin + 1>
                                    <cfset balanceoutqty = abs(balanceleft)>
                                    <cfif getfifotemp.recordcount lt countin>
                                    <cfset loopcontrol = 0>
									</cfif>
                                <cfelse>
									<cfset updatedata = balanceleft >
										<cfif balanceleft eq 0>
                                        <cfset countin = countin + 1>
                                        </cfif>
                               		<cfset loopcontrol = 0>
                                </cfif>
                            <cfquery name="updatebalance" datasource="#dts#">
                            Update fifotemp SET balance = "#updatedata#" WHERE id = "#getfifotemp.currentrow#"
                            </cfquery>
                        </cfloop>
                    </cfloop>
					<cfif getfifotemp.recordcount lt countin>
                    <cfbreak >
                    </cfif>
                    </cfloop>
                    <cfquery name="calculateuseable" datasource="#dts#">
                    Update fifotemp SET useable = (lastin - balance)
                    </cfquery>
                    <cfquery name="gettemplast" datasource="#dts#">
                    SELECT * FROM fifotemp where useable <> 0 order by id desc
                    </cfquery>
                    <cfset openqty = cnqty>
                    <cfset cncost = 0>
                    <cfloop query="gettemplast">
                    <cfset openqty = openqty - gettemplast.useable>
                    <cfif openqty lte 0>
                    <cfset useableqty = gettemplast.useable - abs(openqty)>
                    <cfset cncost = cncost + useableqty * (gettemplast.lastamt/gettemplast.lastin)>
                    <cfbreak>
					<cfelse>
                    <cfset cncost = cncost + gettemplast.useable * (gettemplast.lastamt/gettemplast.lastin)>
					</cfif>
                    </cfloop>
                    <cfset cost = cncost>
                    
                  <cfquery datasource="#dts#" name="emptyall">
                    truncate fifotemp
                    </cfquery>
                    <cfcatch type="any">
                    
                    
					<cfloop query="getstockin" startrow="#count#" endrow="#count#">
               			
                        
							<cfif getstockin.type eq "CN">
								<cfset inqty = inqty>
								<cfset inamt = inamt>
							<cfelse>
								<cfset inqty = getstockin.qty>
								<cfset inamt = getstockin.amt>
							</cfif>
                            			
						</cfloop>
						
						<cfif inamt eq 0 or inqty eq 0>
							<cfset cost = 0>
						<cfelse>
							<!--- REMARK ON 220908 --->
							<!--- <cfset cost = (inamt/inqty)*cnqty> --->
							<cfif val(inqty) neq 0>
								<cfset cost = (inamt/inqty)*cnqty>
							<cfelse>
								<cfset cost = 0>
							</cfif>
						</cfif>
                        </cfcatch>
						</cftry>
                        <cfelse>
                        <cfloop query="getstockin" startrow="#count#" endrow="#count#">
               			
                        
							<cfif getstockin.type eq "CN">
								<cfset inqty = inqty>
								<cfset inamt = inamt>
							<cfelse>
								<cfset inqty = getstockin.qty>
								<cfset inamt = getstockin.amt>
							</cfif>
                            			
						</cfloop>
						
						<cfif inamt eq 0 or inqty eq 0>
							<cfset cost = 0>
						<cfelse>
							<!--- REMARK ON 220908 --->
							<!--- <cfset cost = (inamt/inqty)*cnqty> --->
							<cfif val(inqty) neq 0>
								<cfset cost = (inamt/inqty)*cnqty>
							<cfelse>
								<cfset cost = 0>
							</cfif>
						</cfif>
                        </cfif>
                        
						<cfquery name="updaterecord1" datasource="#arguments.dts#">
							update ictran set 
                            <cfif getgeneral.CNbaseonprice eq '1'>
                            it_cos=price
                            <cfelse>
							it_cos='#cost#'
                            </cfif> 
							where type='CN' 
							and refno='#refno#' 
							and itemno='#itemno#' 
							and itemcount='#itemcount#';
						</cfquery>
                        
					<cfelse>
						<cfset inqty = cnqty>
						<cfset inamt = cnamt>
						<cfquery name="updaterecord2" datasource="#arguments.dts#">
							update ictran 
							set it_cos=0 
							where type='CN' 
							and refno='#refno#' 
							and itemno='#itemno#' 
							and itemcount='#itemcount#';
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfquery name="getstockin" datasource="#arguments.dts#">
				<cfif getitem.qtybf neq 0 and check_bfcost.recordcount neq 0>
					select 
					type,
					refno,
					itemcount,
					counter,
					qty,
					amt,
					it_cos,
					wos_date 
					from 
					(
					<cfloop index="a" from="11" to="50">
						<cfif evaluate("check_bfcost.ffq#a#") neq 0>
							(
								select 
								'RC' as type,
								'' as refno,
								'0' as itemcount,
								'#a#' as counter,
								ffq#a# as qty,
								(ffq#a#*ffc#a#) as amt,
								ffc#a# as it_cos,
								'#getgeneral.lastaccyear#' as wos_date
								from fifoopq 
								where itemno='#itemno#'
							)
							union
						</cfif>
					</cfloop>
						(
							select 
							type,
							refno,
							itemcount,
							'1' as counter,
							ifnull(qty,0) as qty,
                            <cfif isdefined ('form.cbincludecharge')>
                            ifnull(amt+M_charge1+M_charge2+M_charge3+M_charge4+M_charge5+M_charge6+M_charge7,0) as amt
                            <cfelse>
							ifnull(amt,0) as amt,
                            </cfif>
							it_cos,
							wos_date 
							from ictran 
							where itemno='#itemno#' and 
							wos_date > "#getgeneral.lastaccyear#"
							and (void = '' or void is null) 
							and type in ('RC','CN','OAI')
							order by wos_date,trdatetime,refno,itemcount
						)
					) as a 
					order by wos_date,refno,itemcount,counter desc;
				<cfelse>
					select 
					type,
					refno,
					itemcount,
					'1' as counter,
					ifnull(qty,0) as qty,
                    <cfif isdefined ('form.cbincludecharge')>
                            ifnull(amt+M_charge1+M_charge2+M_charge3+M_charge4+M_charge5+M_charge6+M_charge7,0) as amt,
                    <cfelse>
					ifnull(amt,0) as amt,
                    </cfif>
					it_cos 
					from ictran 
					where itemno='#itemno#' and 
					wos_date > "#getgeneral.lastaccyear#"
					and (void = '' or void is null) 
					and type in ('RC','CN','OAI')
					order by wos_date,trdatetime,refno,itemcount;
				</cfif>
			</cfquery>
			
			<cfset stockoutcount = getstockout.recordcount>
			<cfset stockincount = getstockin.recordcount>
			<!--- <cfset suminqty = getitem.qtybf> --->
			<cfset suminqty = 0>
			<cfset countin = 1>
			<cfset countout = 1>
			<cfset oqty = 0>
			<cfset iqty = 0>
			
			<cfloop condition="countout lte stockoutcount">
				<cfif oqty eq 0>
					<cfset cost = 0>
				</cfif>
				<cfif countin gt stockincount>
					<cfbreak>
				</cfif>
				<cfloop query="getstockout" startrow="#countout#" endrow="#stockoutcount#">
					<cfset refno = getstockout.refno>
					<cfset itemcount = getstockout.itemcount>
					<cfset otype = getstockout.type>
					<cfset outqty = getstockout.qty>

					<cfif suminqty gte outqty><!---bf qty eq gte stockout qty--->
						<cfset suminqty = suminqty - outqty>

						<cfquery name="updaterecord" datasource="#arguments.dts#">
							update ictran 
							set it_cos='#cost#' 
							where type='#otype#' 
							and refno='#refno#' 
							and itemno='#itemno#' 
							and itemcount='#itemcount#';
						</cfquery>
						
						<cfset countout = countout + 1>
						<cfset countin = 1>
					<cfelse><!---bf qty eq 0--->
						<cfif suminqty neq 0>
							<cfset oqty = outqty - suminqty>
							<cfset cost = cost + 0>
							<cfset suminqty = 0>
							<cfset countout = countout>
							<cfset countin = 1>
						<cfelse>
                        
							<cfloop query="getstockin" startrow="#countin#" endrow="#stockincount#">
								<cfset inqty = getstockin.qty>
								<cfset iamt = getstockin.amt>
								<cfset itype = getstockin.type>

								<cfif oqty neq 0>
									<cfif inqty gte oqty>
										<cfset iqty = inqty - oqty>
										<cfif itype eq "CN">
											<cfif getstockin.it_cos neq 0>
												<!--- REMARK ON 220908 --->
												<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*oqty)> --->
												<cfif val(inqty) neq 0>
													<cfset cost = cost + ((getstockin.it_cos/inqty)*oqty)>
												<cfelse>
													<cfset cost = cost>
												</cfif>
											<cfelse>
												<cfset cost = cost + 0>
											</cfif>
										<cfelse>
											<!--- REMARK ON 220908 --->
											<!--- <cfset cost = cost + ((iamt/inqty)*oqty)> --->
											<cfif val(inqty) neq 0>
												<cfset cost = cost + ((iamt/inqty)*oqty)>
											<cfelse>
												<cfset cost = cost + 0>
											</cfif>
										</cfif>
										<cfset oqty = 0>
										<cfif iqty eq 0>
											<cfset countin = countin +1>
											<cfset countout = countout + 1>
										<cfelse>
											<cfset countin = countin>
											<cfset countout = countout + 1>
										</cfif>
										<cfbreak>
									<cfelse>
										<cfset oqty = oqty - inqty>
										<cfif itype eq "CN">
											<cfif getstockin.it_cos neq 0>
												<!--- REMARK ON 220908 --->
												<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)> --->
												<cfif val(inqty) neq 0>
													<cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)>
												<cfelse>
													<cfset cost = cost + 0>
												</cfif>
											<cfelse>
												<cfset cost = cost + 0>
											</cfif>
										<cfelse>
											<cfset cost = cost + iamt>
										</cfif>
										<cfset countin = countin + 1>
										<cfset countout = countout>
										<cfbreak>
									</cfif>
								<cfelse>
									<cfif iqty neq 0><!----iqty neq 0--->
										<cfif iqty gte outqty>
											<cfif otype eq "DO">
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- REMARK ON 220908 --->
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- REMARK ON 220908 --->
													<!--- <cfset cost = cost + ((iamt/inqty)*outqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
												<cfset iqty = iqty - (outqty-1)>
											<cfelse>
												<cfset iqty = iqty - outqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- <cfset cost = cost + ((iamt/inqty)*outqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
											</cfif>
											<cfif iqty eq 0>
												<cfset countout = countout + 1>
												<cfset countin = countin + 1>
											<cfelse>
												<cfset countout = countout + 1>
												<cfset countin = countin>
											</cfif>
											<cfbreak>
										<cfelse>
											<cfif otype eq "DO">
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*outqty)>
												</cfif>
												<cfset oqty = (outqty - 1) - iqty>
											<cfelse>
												<cfset oqty = outqty - iqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- REMARK ON 220908 --->
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*iqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*iqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- REMARK ON 220908 --->
													<!--- <cfset cost = cost + ((iamt/inqty)*iqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*iqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
											</cfif>
											<cfif oqty eq 0>
												<cfset countout = countout +1>
												<cfset countin = countin + 1>
											<cfelse>
												<cfset countout = countout>
												<cfset countin = countin + 1>
											</cfif>
											<cfbreak>
										</cfif>
									<cfelse><!----iqty eq 0--->
										<cfif inqty gte outqty>
											<cfif otype eq "DO">
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- <cfset cost = cost + ((iamt/inqty)*outqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
												<cfset iqty = inqty - (outqty - 1)>
											<cfelse>
												<cfset iqty = inqty - outqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- REMARK ON 220908 --->
													<!--- <cfset cost = cost + ((iamt/inqty)*outqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
											</cfif>
											<cfif iqty eq 0>
												<cfset countin = countin + 1>
												<cfset countout = countout + 1>
											<cfelse>
												<cfset countin = countin>
												<cfset countout = countout + 1>
											</cfif>
											<cfbreak>
										<cfelse>
											<cfif otype eq "DO">
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<!--- REMARK ON 220908 --->
													<!--- <cfset cost = cost + ((iamt/inqty)*outqty)> --->
													<cfif val(inqty) neq 0>
														<cfset cost = cost + ((iamt/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												</cfif>
												<cfset oqty = (outqty - 1) - inqty>
											<cfelse>
												<cfset oqty = outqty - inqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<!--- <cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)> --->
														<cfif val(inqty) neq 0>
															<cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)>
														<cfelse>
															<cfset cost = cost + 0>
														</cfif>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + iamt>
												</cfif>
											</cfif>
											<cfif oqty eq 0>
												<cfset countin = countin + 1>
												<cfset countout = countout +1>
											<cfelse>
												<cfset countin = countin + 1>
												<cfset countout = countout>
											</cfif>
											<cfbreak>
										</cfif>
									</cfif>
								</cfif>
							</cfloop><!---Next Stockin--->
						</cfif>
					</cfif>
					<cfquery name="updaterecord" datasource="#arguments.dts#">
						update ictran set 
						it_cos='#cost#' 
						where type='#otype#' 
						and refno='#refno#' 
						and itemno='#itemno#' 
						and itemcount='#itemcount#';
					</cfquery>
					<cfbreak>
				</cfloop><!---Next Stockout--->
			</cfloop>
		</cfloop><!---Next Item--->
		
		<cfreturn 0>
	</cffunction>
</cfcomponent>	