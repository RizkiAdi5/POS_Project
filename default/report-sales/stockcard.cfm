<cfprocessingdirective pageencoding="UTF-8">
<cfquery name="getgsetup" datasource="#dts#">
	SELECT * 
    FROM gsetup
</cfquery>
<cfset c_Period = getgsetup.Period>

<cfset pageTitle = "Stock Card Report">


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><cfoutput>#pageTitle#</cfoutput></title>
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

	<cfinclude template="/latest/filter/filterCategory.cfm">
    <cfinclude template="/latest/filter/filterGroup.cfm">
	<cfinclude template="/latest/filter/filterItem.cfm">
    <cfinclude template="/latest/filter/filterSupplier.cfm">
    <cfinclude template="/latest/date/datePickerFunction.cfm"> 

</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="stockCardForm" id="stockCardForm" action="stockcard2.cfm" method="post" target="_blank">
		<div>#pageTitle#</div>
        <div>
            <table> 
			<tr> 
                <th><label for="product">Product</label></th>			
                <td>
                    <input type="hidden" id="productfrom" name="productfrom" class="itemFilter" data-placeholder="[FROM] - Choose a Product"/>
                    <input type="hidden" id="productto" name="productto" class="itemFilter" placeholder="[TO] - Choose a Product" />
                </td>
            </tr>  
                <tr> 
                    <th><label for="category">Category</label></th>			
                    <td>
                        <input type="hidden" id="Catefrom" name="Catefrom" class="categoryFilter" data-placeholder="[FROM] - Choose a Category" />
                        <input type="hidden" id="Cateto" name="Cateto" class="categoryFilter" placeholder="[TO] - Choose a Category" />
                    </td>
                </tr>   
                <tr> 
                    <th><label for="group">Group</label></th>			
                    <td>
                        <input type="hidden" id="groupfrom" name="groupfrom" class="groupFilter" data-placeholder="[FROM] - Choose a Group" />
                        <input type="hidden" id="groupto" name="groupto" class="groupFilter" placeholder="[TO] - Choose a Group" />
                    </td>
                </tr>
                
            <tr> 
                <th><label for="supplier">Supplier</label></th>			
                <td>
                    <input type="hidden" id="suppfrom" name="suppfrom" class="supplierFilter" data-placeholder="[FROM] - Choose a Supplier" />
                    <input type="hidden" id="suppto" name="suppto" class="supplierFilter" placeholder="[TO] - Choose a Supplier" />
                </td>
            </tr>
            
            
            <tr> 
                <th><label for="period">Period</label></th>			
                <td>
                    <select name="periodfrom" id="periodfrom" Onchange="tf_fperiodfromDesp.value = this.options[this.selectedIndex].title;">
                        <option value="">[FROM] - Choose a Period</option>
                          <cfloop index="fCurrMonth" from="1" to="#c_Period#">
                              <cfset fccurr = DateAdd('m', fCurrMonth, "#getgsetup.LastAccYear#")>
                              <cfset fdmont = dateformat(fccurr,"mm")>
                              <cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
                              <option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fcurrmonth eq 1>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
                          </cfloop>
                    </select>
                    <select name="periodto" id="periodto" Onchange="tf_fperiodtoDesp.value = this.options[this.selectedIndex].title;">
                        <option value="">[TO] - Choose a Period</option>
                        <cfloop index="fCurrMonth" from="1" to="#c_Period#">
                            <cfset fccurr = DateAdd('m', fCurrMonth, "#getgsetup.LastAccYear#")>
                            <cfset fdmont = dateformat(fccurr,"mm")>
                            <cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
                            <cfset fnow = dateformat(now(),"mmmm ''yyyy")>
                            <option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fnow eq fdmont2>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
                        </cfloop>
                    </select>               
                </td>
            </tr>
            <tr> 
                	<th><label for="date">Date</label></th>							                   
                    <td>
					<input type="Text" name="dateFrom" id="dateFrom" maxlength="10" size="10" placeholder="(DD/MM/YYYY)" readonly="readonly" value="#dateformat(now(),'dd/mm/yyyy')#" />
                    <input type="Text" name="dateTo" id="dateTo" maxlength="10" size="10" placeholder="(DD/MM/YYYY)" readonly="readonly" value="#dateformat(now(),'dd/mm/yyyy')#" />
                    </td>
				</tr>
            <tr>
            <th><label for="other">Other Option(s)</label></th>
                <td>
                    <div><input type="checkbox" name="include0" id="include0" value="yes"> Include 0 Figure</div>
                    <div><input type="checkbox" name="showdetail" id="showdetail" value="yes" > Stock Card Detail</div>
                    <div><input type="checkbox" name="dodate" id="dodate" value="yes" checked="checked"> According To DO Date</div>
                </td>
			</tr>
            <tr>
            <th></th>
                <td>
                    <div><input type="checkbox" name="exclude" id="1" value="yes"> Exclude Updated Bill</div>
                    <div><input type="checkbox" name="include" id="1" value="yes"> Show Updated Bill Only</div>
                    <div><input type="checkbox" name="cb2ndunit" id="cb2ndunit" value="yes"> Show 2nd Unit</div>
                </td>
			</tr>
			<tr>
            <th></th>
                <td>
                    <div><input type="checkbox" name="cbcate" id="cbcate" value="yes"> Category</div>
                    <div><input type="checkbox" name="cbbrand" id="cbbrand" value="yes"> Brand</div>
                    <div><input type="checkbox" name="cbrating" id="cbrating" value="yes"> Rating</div>
                </td>
			</tr>
            
            </table>
		</div>
        <div>
            <input type="Submit" name="result" id="result" value="HTML"  />
        </div>
        
    </cfform>
</cfoutput>
</body>
</html>