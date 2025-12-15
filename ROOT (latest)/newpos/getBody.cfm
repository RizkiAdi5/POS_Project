<cfsetting showdebugoutput="no">
<cfset uuid = url.uuid>

<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode asc
</cfquery>

<cfoutput>

<table class="table" border="1">
						<thead>
							<tr>
								<th>No.</th>
								<th>Item Code</th>
								<th>Artist</th>
								<th>Description</th>
								<th>QTY</th>
								<th>Price</th>
								<th>Discount</th>
                                <th>Amount</th>
								<th style="text-align:center">Action</th>
							</tr>
						</thead>                      
						<tbody >
                        <cfloop query="getictrantemp">
							<tr>
								<td nowrap><font style="font-size:14px"><label for="no" id="no">#getictrantemp.itemcount#</label></td>
								<td nowrap><font style="font-size:14px"><label for="itemCode" id="itemCode">#getictrantemp.itemno#</label></td>
								<td nowrap><font style="font-size:14px"><label for="artist" id="artist"></label></td>
								<td nowrap><font style="font-size:14px"><label for="desp" id="desp">#getictrantemp.desp#</label></td>
                                <td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" data-toggle="modal" data-target=".change" onClick="changeqty('#getictrantemp.trancode#','#numberformat(val(getictrantemp.qty_bil),',.__')#','qty_bil1')">#numberformat(val(getictrantemp.qty_bil),',.__')#</a></font></td>
								<td nowrap align="right"><font style="font-size:14px"><cfif getpin2.h2F00 eq "T"><a style="cursor:pointer" data-toggle="modal" data-target=".change" onClick="changeprice('#getictrantemp.trancode#','#numberformat(val(getictrantemp.price_bil),',.__')#','price_bil1')">#numberformat(val(getictrantemp.price_bil),',.__')#</a><cfelse>#numberformat(val(getictrantemp.price_bil),',.__')#</cfif></font></td>
								<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" data-toggle="modal" data-target=".change" onClick="changediscount('#getictrantemp.trancode#','#getictrantemp.disamt_bil#','disamt_bil1')"><cfif getictrantemp.disamt_bil eq ''>-<cfelse>#getictrantemp.disamt_bil#</cfif></a></font></td>
								<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" data-toggle="modal" data-target=".change" onClick="changeamt('#getictrantemp.trancode#','#numberformat(val(getictrantemp.amt_bil),',.__')#','amt_bil1')">#numberformat(val(getictrantemp.amt_bil),',.__')#</a></font></td>
								<td nowrap align="center"><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are you confirm to delete?')){deleterow('#getictrantemp.trancode#')}" value="Delete"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"></td>
							</tr>
                        </cfloop>
						</tbody>       
					</table>  
</cfoutput>
