<cfset pgQs = Len(CGI.query_string) ? "?" & CGI.query_string : "">
<cflocation url="/PaymentGateway/paymentProfile.cfm#pgQs#" addtoken="false">
