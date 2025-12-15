<cfcomponent>
	<cffunction name="calculate_first_in_fist_out_cost">
		<cfargument name="dts" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		
		<cfquery name="getgeneral" datasource="#arguments.dts#">
			select date_format(lastaccyear,'%Y-%m-%d') as lastaccyear from gsetup;
		</cfquery>
		
		<cfquery name="getitem" datasource="#arguments.dts#">
			select a.itemno,ifnull(a.qtybf,0) as qtybf 
			from icitem as a,
			(select itemno from ictran where toinv='' and (void = '' or void is null) 
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			and itemno between 'arguments.itemfrom' and 'arguments.itemto' 
			</cfif>			
			and (type='RC' or type='OAI' or type='CN' or type='INV' or type='DO' or type='CS' or type='DN' or type='ISS' or type='OAR' or type='PR') group by itemno) as b 
			where a.itemno=b.itemno order by a.itemno;
		</cfquery>

		<cfloop query="getitem">
			<cfset itemno = getitem.itemno>
				
			<cfquery name="getstockout" datasource="#arguments.dts#">
				select type,refno,itemcount,ifnull(qty,0) as qty,ifnull(amt,0) as amt from ictran 
				where wos_date > #getgeneral.lastaccyear# and (void = '' or void is null) and itemno='#itemno#' and toinv='' 
				and (type='INV' or type='CS' or type='DN' or type='PR' or type='DO' or type='ISS' or type='OAR') 
				order by wos_date,trdatetime,refno,itemcount;
			</cfquery>
			
			<cfquery name="getstockin" datasource="#arguments.dts#">
				select type,refno,itemcount,ifnull(qty,0) as qty,ifnull(amt,0) as amt,it_cos 
				from ictran where wos_date > #getgeneral.lastaccyear# and itemno='#itemno#' and (void = '' or void is null) 
				and (type='RC' or type='CN' or type='OAI') 
				order by wos_date,trdatetime,refno,itemcount;
			</cfquery>
	
			<cfloop query="getstockin">
				<cfif getstockin.type eq "CN">
					<cfset refno = getstockin.refno>
					<cfset itemcount = getstockin.itemcount>
					<cfset cnqty = getstockin.qty>
					<cfset count = getstockin.currentrow>
					<cfset count = count - 1>
					<cfif count neq 0>
						<cfloop query="getstockin" startrow="#count#" endrow="#count#">
							<cfif getstockin.type eq "CN">
								<cfset inqty = inqty>
								<cfset inamt = inamt>
							<cfelse>
								<cfset inqty = getstockin.qty>
								<cfset inamt = getstockin.amt>
							</cfif>
						</cfloop>
						<cfset cost = (inamt/inqty)*cnqty>
						<cfquery name="updaterecord" datasource="#arguments.dts#">
							update ictran set it_cos = "#cost#" where type='CN' and refno='#refno#' and itemno='#itemno#' and itemcount='#itemcount#';
						</cfquery>
					<cfelse>
						<cfquery name="updaterecord" datasource="#arguments.dts#">
							update ictran set it_cos = 0 where type='CN' and refno='#refno#' and itemno='#itemno#' and itemcount='#itemcount#';
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfquery name="getstockin" datasource="#arguments.dts#">
				select type,refno,itemcount,ifnull(qty,0) as qty,ifnull(amt,0) as amt,it_cos 
				from ictran where wos_date > #getgeneral.lastaccyear# and itemno='#itemno#' and (void = '' or void is null) 
				and (type='RC' or type='CN' or type='OAI') 
				order by wos_date,trdatetime,refno,itemcount;
			</cfquery>
			
			<cfset stockoutcount = getstockout.recordcount>
			<cfset stockincount = getstockin.recordcount>
			<cfset suminqty = getitem.qtybf>	
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
							update ictran set it_cos='#cost#' where type='#otype#' and refno='#refno#' and itemno='#itemno#' and itemcount='#itemcount#';
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
												<cfset cost = cost + ((getstockin.it_cos/inqty)*oqty)>
											<cfelse>
												<cfset cost = cost + 0>
											</cfif>
										<cfelse>
											<cfset cost = cost + ((iamt/inqty)*oqty)>
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
												<cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)>
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
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*outqty)>
												</cfif>
												<cfset iqty = iqty - (outqty-1)>
											<cfelse>
												<cfset iqty = iqty - outqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*outqty)>
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
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
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
														<cfset cost = cost + ((getstockin.it_cos/inqty)*iqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*iqty)>
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
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*outqty)>
												</cfif>
												<cfset iqty = inqty - (outqty - 1)>
											<cfelse>
												<cfset iqty = inqty - outqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<cfset cost = cost + ((getstockin.it_cos/inqty)*outqty)>
													<cfelse>
														<cfset cost = cost + 0>
													</cfif>
												<cfelse>
													<cfset cost = cost + ((iamt/inqty)*outqty)>
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
													<cfset cost = cost + ((iamt/inqty)*outqty)>
												</cfif>
												<cfset oqty = (outqty - 1) - inqty>
											<cfelse>
												<cfset oqty = outqty - inqty>
												<cfif itype eq "CN">
													<cfif getstockin.it_cos neq 0>
														<cfset cost = cost + ((getstockin.it_cos/inqty)*inqty)>
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
						update ictran set it_cos = "#cost#" where type='#otype#' and refno = "#refno#" and itemno = '#itemno#' and itemcount = '#itemcount#';
					</cfquery>
					<cfbreak>
				</cfloop><!---Next Stockout--->
			</cfloop>
		</cfloop><!---Next Item--->
		
		<cfreturn 0>
	</cffunction>
</cfcomponent>	