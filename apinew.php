<?php

function debug($var)
{
    echo '<pre>';
    var_dump($var);
    echo '</pre>';
}

$json_data = '{"hsp":"0B4243D9895E7C24A621DC4EE4EC324A","comid":"optilogglobal","clienttempid":"1234","sourcerefno":"INV-1500005","type":"SO","accno":48,"accname":"PT. Croda Indonesia","wosdate":"2015-06-08","sourcerefno2":"EXP-1500017-FCL","termdays":"14","currcode":"USD","currrate":"13000","pono":"INV-1500005","dono":"EXP-1500017-FCL","itemno":["1107"],"itemdesp":["LIFT OFF"],"qtybil":["1"],"pricebil":["356670"],"amtbil":[356670],"unitbil":["FCL - 20&#039;ft Dry"],"discpbil":[0],"discbil":[0],"taxcode":["02"],"taxpbil":[0],"taxbil":[0],"totallinebill":1,"totalamtbil":356670,"totalpaidbil":0,"paidby":"CS","createdon":"2015-06-08 09:15:37","submiton":"2015-06-11 01:36:47"}';
$arrData = json_decode($json_data, true);
debug($arrData);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, "http://crm.netiquette.com.sg/api/putbill.cfm");
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Content-Length: ' . strlen($json_data)]
);
$result = curl_exec($curl);
curl_close($curl);
$result_data = json_decode($result);
var_dump($result_data);
