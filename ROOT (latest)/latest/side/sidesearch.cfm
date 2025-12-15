<cfsetting showdebugoutput="no">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Inventory Management System</title>
<link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/latest/css/side/side.css"/>
<link rel="stylesheet" href="/latest/css/side/sidesearch.css" />
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
<cfoutput>
	<script type="text/javascript">
        var husergrpid='#husergrpid#';
        var arcust='#target_arcust#';
        var apvend='#target_apvend#';
        var dts='#dts#';
    </script>
</cfoutput>
<script type="text/javascript" src="/latest/js/side/sidesearch.js"></script>
</head>
<body>
<cfoutput>
    <div id="logo_div" class="section">
    	<img alt="IMS Logo" src="/latest/img/ims logo.png" />
    </div>
    <div class="section keywordDiv">
        <input type="text" id="keyword" class="textInput" />
    </div>
    <div class="criteriaDiv">
        <select id="category" class="selectInput">
            <option value="transaction">Transaction</option>
            <option value="customer">Customer</option>
            <option value="supplier">Supplier</option>
        </select>
        <br />
        <select id="attribute" class="selectInput">
        	<option value="custno" class="stringAttribute">Cust/Supp No.</option>
            <option value="name" class="stringAttribute">Name</option>
            <option value="agenno" class="stringAttribute">Agent</option>
            <option value="source" class="stringAttribute">Project/Job</option>
            <option value="refno" class="numberAttribute">Reference No.</option>
            <option value="fperiod" class="numberAttribute">Period</option>
            <option value="wos_date" class="dateAttribute">Date</option>
        </select>
        <br />
        <select id="operator" class="selectInput">
            <option value="contain">Contains</option>
            <option value="notContain">Not Contains</option>
            <option value="equalTo">Equal To</option>
            <option value="notEqualTo">Not Equal To</option>
        </select>
    </div>
    <div class="bottomNavigationDiv">
        <span id="backNavigation"></span>
    </div>
</cfoutput>
</body>
</html>