<cfparam name="qrError" default="No table context found. Please scan the QR code on your table to get started.">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invalid QR Code</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #fff7ed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .card {
            background: #fff;
            border: 2px solid #fdba74;
            border-radius: 16px;
            padding: 40px 32px;
            max-width: 400px;
            width: 100%;
            text-align: center;
            box-shadow: 0 4px 16px rgba(0,0,0,.06);
        }
        .icon {
            font-size: 56px;
            margin-bottom: 16px;
        }
        h2 {
            color: #ea580c;
            font-size: 22px;
            margin-bottom: 12px;
        }
        p {
            color: #6b7280;
            font-size: 15px;
            line-height: 1.6;
        }
        .hint {
            margin-top: 24px;
            background: #fff7ed;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 13px;
            color: #9a3412;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="icon">&#x26A0;&#xFE0F;</div>
    <h2>QR Code Error</h2>
    <p><cfoutput>#qrError#</cfoutput></p>
    <div class="hint">
        Please scan the QR code directly from your table, or ask a staff member for help.
    </div>
</div>
</body>
</html>
