<cfset pageTitle = url.pageTitle>
<cfif url.target EQ "type1">
    <cfset pageAction = "itemStatusValueReport.cfm">
<cfelseif url.target EQ "type2">
    <cfset pageAction = "groupStatusValueReport.cfm">
<cfelseif url.target EQ "type3">
    <cfset pageAction = "categoryStatusValueReport.cfm">
</cfif>

<cfquery name="getGsetup" datasource="#dts#">
	SELECT cost,lastaccyear,cost,includemisc,period
	FROm gsetup;
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>#pageTitle#</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>

	<cfinclude template="/latest/filter/filterCustomer.cfm">
    <cfinclude template="/latest/filter/filterSupplier.cfm">
	<cfinclude template="/latest/filter/filterItem.cfm">
    <cfinclude template="/latest/filter/filterGroup.cfm">
    <cfinclude template="/latest/filter/filterCategory.cfm">
    <cfinclude template="/latest/filter/filterBrand.cfm">
    <cfinclude template="/latest/date/datePickerFunction.cfm">
</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="basicForm" id="basicForm" action="#pageAction#" method="post" target="_blank">
        <div>#pageTitle#</div>
        <div>
        <table> 
        
        	<input type="hidden" NAME="tf_fperiodfromDesp" id="tf_fperiodfromDesp" readonly="readonly" />
			<input type="hidden" NAME="tf_fperiodtoDesp" id="tf_fperiodtoDesp" readonly="readonly" />
			<input type="hidden" name="rptdate" id="rptdate" value="">
			<input type="hidden" name="tf_fperiod" id="tf_fperiod" value=""> 
            <tr> 
                <th><label for="supplier">Supplier</label></th>			
                <td>
                    <input type="hidden" id="supplierFrom" name="supplierFrom" class="supplierFilter" data-placeholder="[FROM] -- Choose a Supplier" />
                    <input type="hidden" id="supplierTo" name="supplierTo" class="supplierFilter" data-placeholder="[TO] -- Choose a Supplier" />
                </td>
            </tr>  
            <tr> 
                <th><label for="item">Item</label></th>			
                <td>
                    <input type="hidden" id="itemFrom" name="itemFrom" class="itemFilter" data-placeholder="[FROM] -- Choose an Item" />
                    <input type="hidden" id="itemTo" name="itemTo" class="itemFilter" data-placeholder="[TO] -- Choose an Item" />
                </td>
            </tr>
            <tr> 
                <th><label for="group">Group</label></th>			
                <td>
                    <input type="hidden" id="groupFrom" name="groupFrom" class="groupFilter" data-placeholder="[FROM] -- Choose a Group" />
                    <input type="hidden" id="groupTo" name="groupTo" class="groupFilter" data-placeholder="[TO] -- Choose a Group" />
                </td>
            </tr>
            <tr> 
                <th><label for="category">Category</label></th>			
                <td>
                    <input type="hidden" id="categoryFrom" name="categoryFrom" class="categoryFilter" data-placeholder="[FROM] -- Choose a Category" />
                    <input type="hidden" id="categoryTo" name="categoryTo" class="categoryFilter" data-placeholder="[TO] -- Choose a Category" />
                </td>
            </tr>
            <tr> 
                <th><label for="brand">Brand</label></th>			
                <td>
                    <input type="hidden" id="brandFrom" name="brandFrom" class="brandFilter" data-placeholder="[FROM] -- Choose a Brand" />
                    <input type="hidden" id="brandTo" name="brandTo" class="brandFilter" data-placeholder="[TO] -- Choose a Brand" />
                </td>
            </tr>
            <tr> 
                <th><label for="period">Period</label></th>			
                <td>
                    <select name="periodFrom" id="periodFrom" Onchange="tf_fperiodfromDesp.value = this.options[this.selectedIndex].title;">
                        <option value="">Choose a Start Period</option>
                          <cfloop index="fCurrMonth" from="1" to="#getGsetup.Period#">
                              <cfset fccurr = DateAdd('m', fCurrMonth, "#form.dateRange#")>
                              <cfset fdmont = dateformat(fccurr,"mm")>
                              <cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
                              <option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fcurrmonth EQ 1>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
                          </cfloop>
                    </select>
                    <select name="periodTo" id="periodTo" Onchange="tf_fperiodtoDesp.value = this.options[this.selectedIndex].title;">
                        <option value="">Choose an End Period</option>
                        <cfloop index="fCurrMonth" from="1" to="#getGsetup.Period#">
                            <cfset fccurr = DateAdd('m', fCurrMonth, "#form.dateRange#")>
                            <cfset fdmont = dateformat(fccurr,"mm")>
                            <cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
                            <cfset fnow = dateformat(now(),"mmmm ''yyyy")>
                            <option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fnow EQ fdmont2>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr> 
                <th><label for="date">Date</label></th>			
                <td>
					<input type="Text" name="dateFrom" id="dateFrom" maxlength="10" size="10" placeholder="[FROM] -- Choose a Date" readonly="readonly" />
					<input type="Text" name="dateTo" id="dateTo" maxlength="10" size="10" placeholder="[TO] -- Choose a Date" readonly="readonly" />
                </td>
			</tr>
            <tr>
				<th><label>Other Option(s)</label></th>
                <td>
                    <div><input type="checkbox" name="include0" id="1" value="yes">Include 0 Figure</div>
                    <div><input type="checkbox" name="dodate" id="dodate" value="yes" checked>According to DO Date</div>
                </td>
			</tr>
            <tr>
            	<th></th>
                <td>
					<cfif getGsetup.cost NEQ "FIFO" and getGsetup.cost NEQ "LIFO">
						<div><input type="checkbox" name="qty0" id="3" value="yes">Include 0 Quantity</div>
						<div><input type="checkbox" name="itemgroup" id="itemgroup" value="yes">Item Grouping<div>
                	</cfif>
                </td>
            </tr>
            <tr>
            	<th></th>
                <td>
					<cfif getGsetup.cost EQ "FIFO">
            			<input type="checkbox" name="fifocost" id="3" value="yes">FIFO COST
            			<input type="checkbox" name="discounted" id="discounted" value="yes">Discounted Cost
            			<input type="checkbox" name="misccost" id="misccost" value="yes" <cfif getGsetup.includemisc EQ '1'>checked</cfif>>Include Misc Cost
            		</cfif>
                </td>
            </tr>
        </table>
        </div>
        <input type="hidden" name="title" id="title" value="#title#" />
        <div>
            <input type="Submit" name="result" id="result" value="HTML"  />
            <input type="Submit" name="result" id="result" value="EXCEL"  />
            <input type="Submit" name="result" id="result" value="PDF"  />
        </div>
    </cfform>
</cfoutput>
</body>
</html>