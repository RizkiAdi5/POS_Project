<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- Clear all customer session vars --->
<cfset SESSION.emenu_loggedin     = "No">
<cfset SESSION.emenu_custno       = "">
<cfset SESSION.emenu_name         = "">
<cfset SESSION.emenu_email        = "">
<cfset SESSION.emenu_points       = 0>
<cfset SESSION.emenu_tier         = "">
<cfset SESSION.emenu_is_guest     = "Yes">

<!--- Keep table context — customer returns to menu as guest.

     emenu_order_id is deliberately NOT cleared. The open order belongs to
     the TABLE's QR session, not to whoever is signed in: it is created when
     the waiter generates the QR code and closed when the waiter completes
     the table. Clearing it here left the session with table context but no
     order, so the next attempt to order hit the guard in orderProcess.cfm
     and was bounced back to the menu as "order_already_submitted" — no
     order written, and the in-memory cart lost on the redirect. That hit
     both a returning logged-in customer and a plain guest after logout. --->


<cflocation url="/latest/customer/menu.cfm" addtoken="false">
