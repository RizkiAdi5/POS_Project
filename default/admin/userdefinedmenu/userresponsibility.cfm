<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>User responsibility — menu access by group</title>
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
	<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<style type="text/css">
		.ur-brand { color: #f0606d; }
		.list-group-item.ur-row-active { background-color: #fff5f6; border-color: #f0606d; border-left: 3px solid #f0606d; }
		.list-group-item.ur-row-active .ur-row-label { font-weight: 600; color: #1d2835; }
		.ur-col-scroll { max-height: min(62vh, 520px); overflow-y: auto; }
		.ur-cb-cell { width: 2.5rem; min-width: 2.5rem; flex-shrink: 0; display: flex; align-items: center; justify-content: center; background: #f8f9fa; border-right: 1px solid #e9ecef; }
		.ur-row-label { cursor: pointer; user-select: none; line-height: 1.35; word-break: break-word; }
		.ur-table-wrap { font-size: 0.875rem; }
	</style>
	<script language="JavaScript">
	function submitGroup(){ document.frmGroup.submit(); }
	function onMenuAccessChange(menuId, pincol, checked){
		if (!window.CAN_EDIT_GROUP) return;
		if (!checked) {
			$.ajax({
				type: "POST",
				url: "databind/cascaderights.cfm",
				data: { groupid: window.GROUP_NAME, menu_id: String(menuId), value: "F" },
				success: function(txt){
					var p = String(txt).split("|");
					if (p[0] === "1") { window.location.reload(); }
					else { alert(p[2] || "Cascade save failed."); window.location.reload(); }
				},
				error: function(){ alert("Cascade save failed."); window.location.reload(); }
			});
		} else {
			$.ajax({
				type: "POST",
				url: "databind/setright.cfm",
				data: { groupid: window.GROUP_NAME, pincode: String(pincol), value: "T" },
				success: function(txt){
					var p = String(txt).split("|");
					if (p[0] === "1") { window.location.reload(); }
					else { alert(p[1] || "Save failed."); window.location.reload(); }
				},
				error: function(){ alert("Save failed."); window.location.reload(); }
			});
		}
	}

	var selL1 = null, selL2 = null;
	var col3Stack = [];
	var col3ViewParent = null;

	function byParent(pid){
		var p = String(pid);
		return (window.MENU_ITEMS || []).filter(function(it){
			var pp = String(it.pid === null || typeof it.pid === 'undefined' ? '' : it.pid);
			if (p === '0') return (pp === '0' || pp === '');
			return pp === p;
		}).sort(function(a,b){ return (a.ord||0) - (b.ord||0); });
	}

	function displayName(it){
		var t = String(it.nm || '').trim();
		if (t) return t;
		if (it.hasKids) return 'Untitled group';
		if (it.hasp) return 'Menu ' + String(it.id);
		return '';
	}

	function shouldShowRow(it){
		if (String(it.nm || '').trim()) return true;
		if (it.hasKids || it.hasp) return true;
		return false;
	}

	function renderCol1(){
		var el = document.getElementById('col1List');
		if (!el) return;
		var roots = byParent('0');
		if (!roots.length) roots = MENU_ITEMS.filter(function(it){ return String(it.lvl)==='1'; }).sort(function(a,b){ return (a.ord||0)-(b.ord||0); });
		var h = '';
		for (var i=0; i<roots.length; i++) {
			var it = roots[i];
			if (!shouldShowRow(it)) continue;
			var nm = displayName(it);
			var sel = (selL1 && String(selL1)===String(it.id));
			var idJs = String(it.id).replace(/'/g,"\\'");
			var pinJs = String(it.pincol||'').replace(/'/g,"\\'");
			h += '<div class="list-group-item d-flex align-items-stretch p-0 border-start-0 border-end-0'+(sel?' ur-row-active':'')+'">';
			h += '<div class="ur-cb-cell">';
			if (it.hasp && it.pincol && window.CAN_EDIT_GROUP) {
				h += '<input class="form-check-input m-0" type="checkbox"'+(it.allow?' checked':'')+' onclick="event.stopPropagation();" onchange="onMenuAccessChange(\''+idJs+'\',\''+pinJs+'\',this.checked);" />';
			} else if (it.hasp && it.pincol) {
				h += '<input class="form-check-input m-0" type="checkbox" disabled'+(it.allow?' checked':'')+' onclick="event.stopPropagation();" />';
			} else {
				h += '<span class="text-muted small">&nbsp;</span>';
			}
			h += '</div>';
			h += '<div class="flex-grow-1 py-2 px-3 ur-row-label" onclick="pickL1(\''+idJs+'\')">';
			h += escHtml(nm);
			if (it.hasKids) h += ' <i class="bi bi-chevron-right text-muted small"></i>';
			h += '</div></div>';
		}
		el.innerHTML = h || '<p class="text-muted small mb-0 p-3">No main menus.</p>';
	}
	function pickL1(id){
		selL1 = id; selL2 = null; col3Stack = []; col3ViewParent = null;
		renderCol1();
		renderCol2();
		document.getElementById('col3List').innerHTML = '<p class="text-muted small mb-0 p-3">Select a submenu (level 2).</p>';
		var bk = document.getElementById('col3Back');
		if (bk) bk.classList.add('d-none');
	}
	function renderCol2(){
		var el = document.getElementById('col2List');
		if (!el) return;
		if (!selL1) { el.innerHTML = '<p class="text-muted small mb-0 p-3">Choose a main menu (level 1).</p>'; return; }
		var kids = byParent(selL1);
		var h = '';
		for (var i=0; i<kids.length; i++) {
			var it = kids[i];
			if (!shouldShowRow(it)) continue;
			var nm = displayName(it);
			var sel = (selL2 && String(selL2)===String(it.id));
			var idJs = String(it.id).replace(/'/g,"\\'");
			var pinJs = String(it.pincol||'').replace(/'/g,"\\'");
			h += '<div class="list-group-item d-flex align-items-stretch p-0 border-start-0 border-end-0'+(sel?' ur-row-active':'')+'">';
			h += '<div class="ur-cb-cell">';
			if (it.hasp && it.pincol && window.CAN_EDIT_GROUP) {
				h += '<input class="form-check-input m-0" type="checkbox"'+(it.allow?' checked':'')+' onclick="event.stopPropagation();" onchange="onMenuAccessChange(\''+idJs+'\',\''+pinJs+'\',this.checked);" />';
			} else if (it.hasp && it.pincol) {
				h += '<input class="form-check-input m-0" type="checkbox" disabled'+(it.allow?' checked':'')+' onclick="event.stopPropagation();" />';
			} else {
				h += '<span class="text-muted small">&nbsp;</span>';
			}
			h += '</div>';
			h += '<div class="flex-grow-1 py-2 px-3 ur-row-label" onclick="pickL2(\''+idJs+'\')">';
			h += escHtml(nm);
			if (it.hasKids) h += ' <i class="bi bi-chevron-right text-muted small"></i>';
			h += '</div></div>';
		}
		el.innerHTML = h || '<p class="text-muted small mb-0 p-3">No submenus under this main menu.</p>';
	}
	function pickL2(id){
		selL2 = id; col3Stack = []; col3ViewParent = id;
		renderCol2();
		renderCol3();
	}
	function escHtml(s){
		if (!s) return '';
		return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
	}
	function renderCol3(){
		var el = document.getElementById('col3List');
		var bk = document.getElementById('col3Back');
		if (!el) return;
		if (!col3ViewParent) {
			el.innerHTML = '<p class="text-muted small mb-0 p-3">Select a submenu (level 2).</p>';
			if (bk) bk.classList.add('d-none');
			return;
		}
		if (bk) bk.classList.toggle('d-none', col3Stack.length === 0);
		var kids = byParent(col3ViewParent);
		if (!kids.length) {
			el.innerHTML = '<p class="text-muted small mb-0 p-3">No items under this menu.</p>';
			return;
		}
		var h = '<div class="table-responsive ur-table-wrap"><table class="table table-sm table-hover align-middle mb-0">';
		h += '<thead class="table-light"><tr><th>Menu name</th><th style="width:7rem;">Menu ID</th><th style="width:8rem;">Permission</th><th class="text-center" style="width:5.5rem;">Access</th></tr></thead><tbody>';
		var rowCount = 0;
		for (var i=0; i<kids.length; i++) {
			var it = kids[i];
			if (!shouldShowRow(it)) continue;
			rowCount++;
			var nm = displayName(it);
			var safeDrillId = String(it.id).replace(/"/g,'').replace(/</g,'').replace(/'/g,'');
			var rowClick = it.hasKids ? ' role="button" class="ur-drill" data-id="'+safeDrillId+'"' : '';
			h += '<tr'+rowClick+'>';
			h += '<td class="ur-row-label">'+escHtml(nm);
			if (it.hasKids) h += ' <span class="badge rounded-pill text-bg-secondary">Open</span>';
			h += '</td><td><code class="small text-secondary">'+escHtml(String(it.id))+'</code></td><td><code class="small">'+(it.hasp ? escHtml(it.pin) : '&mdash;')+'</code></td>';
			h += '<td class="text-center" onclick="if(event.stopPropagation)event.stopPropagation();else event.cancelBubble=true;">';
			if (it.hasp && it.pincol) {
				var dis = (!window.CAN_EDIT_GROUP) ? ' disabled' : '';
				var chk = it.allow ? ' checked' : '';
				var idJs = String(it.id).replace(/'/g,"\\'");
				var pinJs = String(it.pincol).replace(/'/g,"\\'");
				h += '<input class="form-check-input m-0" type="checkbox" id="cb_'+String(it.pincol).replace(/"/g,'')+'" onclick="if(event.stopPropagation)event.stopPropagation();else event.cancelBubble=true;" onchange="onMenuAccessChange(\''+idJs+'\',\''+pinJs+'\',this.checked);"'+chk+dis+'>';
			} else if (it.hasp) {
				h += '<span class="text-secondary" title="Missing on userpin2">?</span>';
			} else {
				h += '<span class="text-secondary">&mdash;</span>';
			}
			h += '</td></tr>';
		}
		h += '</tbody></table></div>';
		if (rowCount === 0) {
			el.innerHTML = '<p class="text-muted small mb-0 p-3">No displayable items (hidden empty placeholders).</p>';
			return;
		}
		el.innerHTML = h;
		$(el).find('tr.ur-drill').on('click', function(){
			var id = $(this).data('id');
			if (id) drillCol3(String(id));
		});
	}
	function drillCol3(id){
		col3Stack.push(col3ViewParent);
		col3ViewParent = id;
		renderCol3();
	}
	function menuDrillBack(){
		if (!col3Stack.length) return;
		col3ViewParent = col3Stack.pop();
		renderCol3();
	}

	function normalizeMenuItems(){
		var a = window.MENU_ITEMS;
		if (!a || !a.length) return;
		for (var i=0; i<a.length; i++) {
			var o = a[i];
			if (o.nm === undefined && o.NM !== undefined) o.nm = o.NM;
			if (o.id === undefined && o.ID !== undefined) o.id = o.ID;
			if (o.pid === undefined && o.PID !== undefined) o.pid = o.PID;
			if (o.lvl === undefined && o.LVL !== undefined) o.lvl = o.LVL;
			if (o.ord === undefined && o.ORD !== undefined) o.ord = o.ORD;
			if (o.pin === undefined && o.PIN !== undefined) o.pin = o.PIN;
			if (o.pincol === undefined && o.PINCOL !== undefined) o.pincol = o.PINCOL;
			if (o.hasp === undefined && o.HASP !== undefined) o.hasp = o.HASP;
			if (o.allow === undefined && o.ALLOW !== undefined) o.allow = o.ALLOW;
			if (o.hasKids === undefined && o.HASKIDS !== undefined) o.hasKids = o.HASKIDS;
		}
	}
	function menuInit(){
		normalizeMenuItems();
		renderCol1();
		document.getElementById('col2List').innerHTML = '<p class="text-muted small mb-0 p-3">Choose a main menu (level 1).</p>';
		document.getElementById('col3List').innerHTML = '<p class="text-muted small mb-0 p-3">Select a submenu (level 2).</p>';
		var bk = document.getElementById('col3Back');
		if (bk) bk.classList.add('d-none');
	}
	if (window.addEventListener) window.addEventListener('load', menuInit, false);
	else if (window.attachEvent) window.attachEvent('onload', menuInit);
	</script>
</head>
<body class="bg-light">

<cfparam name="url.groupname" default="">
<cfset groupname = trim(url.groupname)>

<cfquery name="getGroups" datasource="#dts#">
	SELECT DISTINCT level
	FROM userpin2
	WHERE level <> 'super'
	ORDER BY level
</cfquery>

<cfset groupOk = false>
<cfloop query="getGroups">
	<cfif getGroups.level eq groupname><cfset groupOk = true></cfif>
</cfloop>
<cfif not groupOk and getGroups.recordcount gt 0>
	<cfloop query="getGroups" startrow="1" endrow="1">
		<cfset groupname = getGroups.level>
	</cfloop>
</cfif>

<cfset canEdit = true>
<cfif isDefined("husergrpid") and husergrpid neq "super" and groupname eq "Admin">
	<cfset canEdit = false>
</cfif>

<cfquery name="getMenuAll" datasource="#dts#">
	SELECT m.menu_id, m.menu_name, m.menu_parent_id, m.menu_level, m.menu_order, m.userpin_id
	FROM main.menunew2 m
	WHERE m.menu_id > 9999
	ORDER BY m.menu_parent_id, m.menu_order, m.menu_level, m.menu_id
</cfquery>

<cfset idsWithChildren = StructNew()>
<cfloop query="getMenuAll">
	<cfset _pid = trim(toString(getMenuAll.menu_parent_id))>
	<cfset idsWithChildren[_pid] = true>
</cfloop>

<cfquery name="getRowRights" datasource="#dts#">
	SELECT *
	FROM userpin2
	WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#groupname#">
</cfquery>

<cfset pinResolve = StructNew()>
<cfloop query="getMenuAll">
	<cfset rp = lCase(trim(toString(getMenuAll.userpin_id)))>
	<cfif len(rp) and not structKeyExists(pinResolve, rp)>
		<cfset pinCol = "H" & reReplace(rp, "^h", "", "one")>
		<cfset actualCol = "">
		<cfif getRowRights.recordcount gt 0>
			<cfloop list="#getRowRights.columnList#" index="cni">
				<cfif compareNoCase(cni, pinCol) eq 0 OR compareNoCase(cni, rp) eq 0 OR compareNoCase(cni, trim(toString(getMenuAll.userpin_id))) eq 0>
					<cfset actualCol = cni>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pinResolve[rp] = actualCol>
	</cfif>
</cfloop>

<cfset menuArr = arrayNew(1)>
<cfloop query="getMenuAll">
	<cfset mid = trim(toString(getMenuAll.menu_id))>
	<cfset ml = val(getMenuAll.menu_level)>
	<cfset rawPin = trim(toString(getMenuAll.userpin_id))>
	<cfset rpKey = lCase(rawPin)>
	<cfset hasPin = len(rawPin)>
	<cfset actualPinCol = "">
	<cfif hasPin and structKeyExists(pinResolve, rpKey)>
		<cfset actualPinCol = pinResolve[rpKey]>
	</cfif>
	<cfset xpin = "">
	<cfif len(actualPinCol)>
		<cfset xpin = evaluate("getRowRights." & actualPinCol)>
	</cfif>
	<cfset row = structNew()>
	<cfset row["id"] = mid>
	<cfset _p = trim(toString(getMenuAll.menu_parent_id))>
	<cfif not len(_p) OR _p EQ "0"><cfset _p = "0"></cfif>
	<cfset row["pid"] = _p>
	<cfset row["lvl"] = ml>
	<cfset row["nm"] = trim(toString(getMenuAll.menu_name))>
	<cfset row["ord"] = val(getMenuAll.menu_order)>
	<cfset row["pin"] = rawPin>
	<cfset row["pincol"] = actualPinCol>
	<cfset row["hasp"] = hasPin>
	<cfset row["allow"] = (xpin eq "T")>
	<cfset row["hasKids"] = structKeyExists(idsWithChildren, mid)>
	<cfset arrayAppend(menuArr, row)>
</cfloop>

<div class="container-fluid px-3 py-4" style="max-width: 1280px;">
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<cfif isDefined("husergrpid") and husergrpid eq "Muser">
			<a href="/home2.cfm" class="link-secondary small"><i class="bi bi-house-door"></i> Home</a>
			<span class="text-muted">|</span>
		</cfif>
		<h1 class="h4 mb-0 ur-brand">User responsibility</h1>
		<span class="text-muted small ms-auto d-none d-md-inline">Menu access by group</span>
	</div>

	

	<form name="frmGroup" method="get" action="userresponsibility.cfm" class="card shadow-sm border-0 mb-4">
		<div class="card-body row align-items-center g-3 py-3">
			<label class="col-auto col-form-label fw-semibold mb-0" for="groupname">User group</label>
			<div class="col-md-4">
				<select name="groupname" id="groupname" class="form-select" onchange="submitGroup();">
					<cfoutput query="getGroups">
						<option value="#getGroups.level#"<cfif getGroups.level eq groupname> selected</cfif>>
							<cfif getGroups.level eq "Standard">Standard User
							<cfelseif getGroups.level eq "General">General User
							<cfelseif getGroups.level eq "Limited">Limited User
							<cfelseif getGroups.level eq "Mobile">Mobile User
							<cfelseif getGroups.level eq "Admin">Administrator
							<cfelseif getGroups.level eq "Super">Super User
							<cfelse>#getGroups.level#
							</cfif>
						</option>
					</cfoutput>
				</select>
			</div>
			<div class="col-md text-muted small">Changing group reloads the page.</div>
		</div>
	</form>

	<script type="text/javascript">
		window.GROUP_NAME = <cfoutput>#serializeJSON(groupname)#</cfoutput>;
		window.CAN_EDIT_GROUP = <cfif canEdit>true<cfelse>false</cfif>;
		window.MENU_ITEMS = <cfoutput>#serializeJSON(menuArr)#</cfoutput>;
	</script>

	<div class="row g-3">
		<div class="col-lg-4">
			<div class="card shadow-sm border-0 h-100">
				<div class="card-header bg-white py-2 border-bottom">
					<span class="fw-semibold">Main menu</span>
					<span class="text-muted small">(level 1)</span>
				</div>
				<div class="list-group list-group-flush ur-col-scroll" id="col1List"></div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="card shadow-sm border-0 h-100">
				<div class="card-header bg-white py-2 border-bottom">
					<span class="fw-semibold">Submenu</span>
					<span class="text-muted small">(level 2)</span>
				</div>
				<div class="list-group list-group-flush ur-col-scroll" id="col2List"></div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="card shadow-sm border-0 h-100">
				<div class="card-header bg-white py-2 border-bottom d-flex align-items-center justify-content-between flex-wrap gap-2">
					<div>
						<span class="fw-semibold">Detail &amp; access</span>
						<span class="text-muted small">(level 3+)</span>
					</div>
					<button type="button" id="col3Back" class="btn btn-sm btn-outline-secondary d-none" onclick="menuDrillBack();"><i class="bi bi-arrow-left"></i> Back</button>
				</div>
				<div class="card-body p-0 ur-col-scroll" id="col3List"></div>
			</div>
		</div>
	</div>

	<p class="text-center text-muted small mt-4 mb-0">
		<cfoutput>
		<a href="usergroup.cfm" class="link-secondary">User Group Maintenance</a>
		<span class="mx-2">&middot;</span>
		<a href="dsp_userdefinedmenu.cfm?groupname=#urlEncodedFormat(groupname)#" class="link-secondary">User Defined Menu (classic)</a>
		</cfoutput>
	</p>
</div>

<div id="CustDiv" style="display:none;width:0;height:0;overflow:hidden;"></div>

</body>
</html>
