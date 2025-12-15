<cfoutput>
	<cfswitch expression="#lcase(hcomid)#">
		<cfcase value="tmt_i|taff_i|taftc_i" delimiters="|">
			<cfif getpin2.hc016 eq "T">
				<hr/>
				<li>
					<a href="/tmt/commission_menu.cfm" target="mainFrame">
						Commission Profile
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="fincom_i">
			<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
				<hr/>
				<li>
					<a href="/fincom/special_item_price.cfm" target="mainFrame">
						Special Item Price Profile
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="pnp_i">
			<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
				<hr/>
				<li>
					<a href="/pnp/userid_location_profile.cfm" target="mainFrame">
						User Id Location Profile
					</a>
				</li>
				<li>
					<a href="/pnp/others_transaction_setting.cfm" target="mainFrame">
						Others Transaction Setting
					</a>
				</li>
				<li>
					<a href="/pnp/special_setting.cfm" target="mainFrame">
						Special Setting
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="ecraft_i,ovas_i" delimiters=",">
			<cfif HUserGrpID eq "super">
				<hr/>
				<li>
					<a href="/customized/#dts#/special_setting.cfm" target="mainFrame">
						Special Setting
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="fdipx_i,ulp_i">
			<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
				<hr/>
				<li>
					<a href="/customized/fdipx_i/maintenance/s_processcode.cfm" target="mainFrame">
						Process Code Profile
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="thaipore_i|jaynbtrading_i|lotdemo_i|bhs_i|laihock_i" delimiters="|">
			<cfif getpin2.HC101 eq "T">
				<hr/>
				<li>
					<a href="/customized/#dts#/maintenance/d_usedLotNumber.cfm" target="mainFrame">
						Delete Used Lot Number
					</a>
				</li>
			</cfif>
		</cfcase>
		<cfcase value="iel_i,ielm_i" delimiters=",">
			<hr/>
			<li>
				<a href="/customized/iel_i/maintenance/s_collectionaddress.cfm" target="mainFrame">
					Collection Address
				</a>
			</li>			
		</cfcase>
		<cfcase value="net_i|netm_i" delimiters="|">
			<hr/>
			<li>
				<a href="/customized/#lcase(hcomid)#/maintenance/s_cso.cfm" target="mainFrame">
					CSO Profile
				</a>
			</li>
			<li>
				<a href="/customized/#lcase(hcomid)#/maintenance/s_servicetype.cfm" target="mainFrame">
					Service Type Profile
				</a>
			</li>			
		</cfcase>	
		<cfcase value="ideal_i|idealb_i" delimiters="|">
			<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
				<hr/>
				<li>
					<a href="/customized/ideal_i/maintenance/s_discount.cfm" target="mainFrame">
						Discount Profile
					</a>
				</li>	
			</cfif>		
		</cfcase>			
	</cfswitch>
</cfoutput>