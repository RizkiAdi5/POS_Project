<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">
<cfset pageTitle = "Pengaturan Payment Gateway">
<!doctype html>
<html lang="id">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.css">
	<style>
		body{background:#f6f8fb;padding:22px}
		.wrap{max-width:980px;margin:0 auto}
		.cardx{background:#fff;border:1px solid #e9edf2;border-radius:12px;padding:18px;margin-bottom:14px}
		.rowx{display:flex;gap:10px;flex-wrap:wrap}
		.badgex{display:inline-block;padding:5px 10px;border-radius:999px;font-size:12px;font-weight:700}
		.badge-gray{background:#eef2f7;color:#4b5563}
		.badge-green{background:#e7f8ee;color:#146c43}
		.badge-red{background:#fdeaea;color:#a51c30}
		.muted{color:#6b7280}
		.kv{margin:6px 0}
		.kv strong{display:inline-block;min-width:170px}
		.gridx{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:10px}
		.method-card{border:1px solid #d8dee8;border-radius:10px;padding:10px 12px;cursor:pointer;position:relative;min-height:58px}
		.method-card.active{border-color:#0d6efd;background:#eef5ff}
		.method-card.disabled{opacity:.55;background:#f8f9fb;cursor:not-allowed}
		.method-name{font-weight:700}
		.method-sub{font-size:12px;color:#6b7280;margin-top:2px}
		.method-check{position:absolute;top:8px;right:10px;font-size:12px;font-weight:700;color:#0d6efd}
		.hiddenx{display:none}
		.token-mask{font-family:monospace;letter-spacing:1px}
		.toastx{position:fixed;right:18px;bottom:18px;z-index:9999;min-width:260px;max-width:360px;display:none}
		.copy-btn{margin-left:8px}
	</style>
</head>
<body>
<div class="wrap">
	<h3><cfoutput>#pageTitle#</cfoutput></h3>
	<p class="muted">Mode Master Account Only: semua pembayaran customer diproses oleh satu API key Xendit milik aplikasi.</p>

	<div id="alertArea"></div>

	<div class="cardx">
		<h4>1) Koneksi Xendit</h4>
		<div class="kv"><strong>Status:</strong> <span id="statusBadge" class="badgex badge-gray">Memeriksa...</span></div>
		<div class="kv"><strong>Balance:</strong> <span id="balanceValue" class="muted">-</span></div>
		<div class="kv"><strong>Xendit Account:</strong> <span id="accountId" class="muted">MASTER ACCOUNT (tanpa sub-account)</span></div>
		<div class="rowx" style="margin-top:8px">
			<button id="btnVerifyConn" class="btn btn-primary">Cek Koneksi</button>
			<button id="btnRefreshProfile" class="btn btn-default">Refresh Profile</button>
		</div>
		<p class="muted" style="margin-top:8px">API key dikonfigurasi di server. Hubungi admin untuk mengubahnya.</p>
	</div>

	<div class="cardx">
		<h4>2) Metode Pembayaran</h4>
		<p class="muted">Pilih metode aktif untuk checkout customer.</p>

		<div style="margin:10px 0 6px"><strong>Virtual Account</strong></div>
		<div class="gridx">
			<div class="method-card method-toggle" data-method="VIRTUAL_ACCOUNT" data-channel="BRI">
				<div class="method-name">BRI</div><div class="method-sub">BRI Virtual Account</div><div class="method-check">Aktif</div>
			</div>
			<div class="method-card method-toggle" data-method="VIRTUAL_ACCOUNT" data-channel="BNI">
				<div class="method-name">BNI</div><div class="method-sub">BNI Virtual Account</div><div class="method-check">Aktif</div>
			</div>
			<div class="method-card method-toggle" data-method="VIRTUAL_ACCOUNT" data-channel="MANDIRI">
				<div class="method-name">Mandiri</div><div class="method-sub">Mandiri Virtual Account</div><div class="method-check">Aktif</div>
			</div>
			<div class="method-card method-toggle" data-method="VIRTUAL_ACCOUNT" data-channel="PERMATA">
				<div class="method-name">Permata</div><div class="method-sub">Permata Virtual Account</div><div class="method-check">Aktif</div>
			</div>
			<div class="method-card disabled">
				<div class="method-name">BCA</div><div class="method-sub">Tidak tersedia untuk mode ini</div>
			</div>
		</div>

		<div style="margin:14px 0 6px"><strong>E-Wallet</strong></div>
		<div class="gridx">
			<div class="method-card method-toggle" data-method="EWALLET" data-channel="OVO"><div class="method-name">OVO</div><div class="method-sub">Checkout redirect</div><div class="method-check">Aktif</div></div>
			<div class="method-card method-toggle" data-method="EWALLET" data-channel="DANA"><div class="method-name">DANA</div><div class="method-sub">Checkout redirect</div><div class="method-check">Aktif</div></div>
			<div class="method-card method-toggle" data-method="EWALLET" data-channel="SHOPEEPAY"><div class="method-name">ShopeePay</div><div class="method-sub">Checkout redirect</div><div class="method-check">Aktif</div></div>
		</div>

		<div style="margin:14px 0 6px"><strong>Lainnya</strong></div>
		<div class="gridx">
			<div class="method-card method-toggle" data-method="QRIS" data-channel="QRIS"><div class="method-name">QRIS</div><div class="method-sub">Dynamic QR</div><div class="method-check">Aktif</div></div>
		</div>

		<div style="margin-top:14px">
			<button id="btnSaveMethods" class="btn btn-success">Simpan Pengaturan</button>
		</div>
	</div>

	<div class="cardx">
		<h4>3) Webhook</h4>
		<div class="kv"><strong>Webhook URL:</strong> <code id="webhookUrl"></code></div>
		<div class="kv">
			<strong>Callback Token:</strong>
			<span id="callbackToken" class="token-mask">********</span>
			<button id="btnCopyToken" class="btn btn-xs btn-default copy-btn">Copy</button>
		</div>
		<p class="muted">Daftarkan URL ini di Xendit Dashboard -> Settings -> Webhooks.</p>
		<p><a href="https://dashboard.xendit.co/settings/developers#webhooks" target="_blank" rel="noopener">Buka halaman Webhooks Xendit</a></p>
	</div>

	<div class="cardx">
		<h4>4) Panduan Singkat</h4>
		<div class="panel-group" id="guideAccordion" role="tablist" aria-multiselectable="false">
			<div class="panel panel-default" style="margin-bottom:0">
				<div class="panel-heading" role="tab" id="guideHeading">
					<h4 class="panel-title">
						<a role="button" data-toggle="collapse" data-parent="#guideAccordion" href="#guideCollapse" aria-expanded="true" aria-controls="guideCollapse">
							Lihat cara kerja payment di sistem
						</a>
					</h4>
				</div>
				<div id="guideCollapse" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="guideHeading">
					<div class="panel-body">
						<ol style="margin:0;padding-left:18px">
							<li>Customer checkout, sistem membuat payment request ke Xendit dari server.</li>
							<li>Customer menyelesaikan pembayaran via VA / E-Wallet / QRIS.</li>
							<li>Status ter-update via webhook dan sinkron polling hingga order jadi PAID.</li>
						</ol>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="toastBox" class="alert toastx"></div>

<script src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/latest/js/bootstrap/bootstrap.js"></script>
<script>
(function(){
	var state = {
		status: "PENDING",
		accountId: "",
		callbackToken: "",
		methods: [],
		banks: [],
		balance: null,
		currency: "IDR"
	};

	function api(path, method, body){
		return $.ajax({
			url: path,
			type: method || "GET",
			contentType: "application/json",
			dataType: "json",
			data: body ? JSON.stringify(body) : null
		});
	}

	function esc(v){
		return String(v || "").replace(/[&<>"]/g, function(c){ return {"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;"}[c]; });
	}

	function showAlert(type, msg){
		$("#alertArea").html('<div class="alert alert-' + type + '">' + esc(msg) + '</div>');
	}

	function showToast(type, msg){
		var box = $("#toastBox");
		box.removeClass("alert-success alert-danger alert-warning alert-info");
		box.addClass("alert-" + type).text(msg).stop(true, true).fadeIn(150);
		setTimeout(function(){ box.fadeOut(250); }, 2600);
	}

	function statusMeta(s){
		var x = String(s || "PENDING").toUpperCase();
		if(x === "LIVE" || x === "REGISTERED"){ return {label:"Terhubung", cls:"badge-green"}; }
		if(x === "CHECKING"){ return {label:"Memeriksa...", cls:"badge-gray"}; }
		return {label:"Tidak Terhubung", cls:"badge-red"};
	}

	function mask(token){
		if(!token || token.length < 8){ return "********"; }
		return token.substring(0, 4) + "********" + token.substring(token.length - 4);
	}

	function formatRupiah(amount){
		var v = Number(amount || 0);
		return "Rp " + v.toLocaleString("id-ID");
	}

	function setMethodCardActive(selector, active){
		$(selector).toggleClass("active", !!active);
	}

	function getSelectedState(){
		var banks = [];
		var methodMap = {};
		$(".method-toggle.active").each(function(){
			var method = String($(this).data("method") || "").toUpperCase();
			var channel = String($(this).data("channel") || "").toUpperCase();
			if(!method){ return; }
			methodMap[method] = true;
			if(method === "VIRTUAL_ACCOUNT" && channel){ banks.push(channel); }
		});
		return {
			methods: Object.keys(methodMap),
			banks: banks
		};
	}

	function render(){
		var sm = statusMeta(state.status);
		$("#statusBadge").attr("class", "badgex " + sm.cls).text(sm.label);
		$("#accountId").text(state.accountId || "MASTER ACCOUNT (tanpa sub-account)");
		$("#callbackToken").text(state.callbackToken ? mask(state.callbackToken) : "********");
		$("#webhookUrl").text(location.origin + "/PaymentGateway/api/payment-webhook.cfm");
		if(state.balance === null){
			$("#balanceValue").text("-");
		}else{
			$("#balanceValue").text(formatRupiah(state.balance) + " (" + (state.currency || "IDR") + ")");
		}

		setMethodCardActive(".method-toggle[data-method='EWALLET']", state.methods.indexOf("EWALLET") >= 0);
		setMethodCardActive(".method-toggle[data-method='QRIS']", state.methods.indexOf("QRIS") >= 0);
		setMethodCardActive(".method-toggle[data-method='VIRTUAL_ACCOUNT']", false);

		var vaOn = state.methods.indexOf("VIRTUAL_ACCOUNT") >= 0;
		if(vaOn){
			if((state.banks || []).length){
				(state.banks || []).forEach(function(b){
					setMethodCardActive(".method-toggle[data-method='VIRTUAL_ACCOUNT'][data-channel='" + b + "']", true);
				});
			}else{
				setMethodCardActive(".method-toggle[data-method='VIRTUAL_ACCOUNT']", true);
			}
		}
	}

	function loadProfile(){
		return api("/PaymentGateway/api/payment-profile.cfm", "GET").done(function(res){
			state.accountId = res.xendit_account_id || "";
			state.status = res.xendit_status || "PENDING";
			state.callbackToken = res.xendit_callback_token || "";
			state.methods = res.payment_methods_enabled || [];
			state.banks = res.va_banks_enabled || [];
			render();
		}).fail(function(){
			showAlert("danger", "Gagal memuat pengaturan payment gateway.");
		});
	}

	function verifyConnection(){
		state.status = "CHECKING";
		render();
		$("#btnVerifyConn").prop("disabled", true).text("Memeriksa...");
		return api("/PaymentGateway/api/payment-verify-connection.cfm", "POST", {}).done(function(res){
			var data = res && res.data ? res.data : {};
			state.balance = Number(data.balance || 0);
			state.currency = data.currency || "IDR";
			state.status = "LIVE";
			render();
			showToast("success", "Koneksi Xendit berhasil.");
		}).fail(function(xhr){
			state.balance = null;
			state.status = "PENDING";
			render();
			var msg = "Koneksi Xendit gagal.";
			try{ msg = (xhr.responseJSON && xhr.responseJSON.error) || msg; }catch(e){}
			showToast("danger", msg);
		}).always(function(){
			$("#btnVerifyConn").prop("disabled", false).text("Cek Koneksi");
		});
	}

	$(document).on("click", ".method-toggle", function(){
		if($(this).hasClass("disabled")){ return; }
		var method = String($(this).data("method") || "").toUpperCase();
		if(method === "VIRTUAL_ACCOUNT"){
			$(this).toggleClass("active");
		}else{
			var group = ".method-toggle[data-method='" + method + "']";
			var active = $(this).hasClass("active");
			$(group).toggleClass("active", !active);
		}
	});

	$("#btnVerifyConn").on("click", verifyConnection);

	$("#btnRefreshProfile").on("click", function(){
		loadProfile().done(function(){
			showToast("info", "Profile payment diperbarui.");
		});
	});

	$("#btnSaveMethods").on("click", function(){
		var picked = getSelectedState();
		if(picked.methods.indexOf("VIRTUAL_ACCOUNT") >= 0 && picked.banks.length === 0){
			showToast("warning", "Pilih minimal 1 bank untuk Virtual Account.");
			return;
		}
		api("/PaymentGateway/api/payment-profile.cfm", "POST", {
			payment_methods_enabled: picked.methods,
			va_banks_enabled: picked.banks
		}).done(function(){
			showToast("success", "Pengaturan metode pembayaran tersimpan.");
			loadProfile();
		}).fail(function(xhr){
			var msg = "Gagal menyimpan pengaturan metode pembayaran.";
			try{
				msg = (xhr.responseJSON && (xhr.responseJSON.detail || xhr.responseJSON.error)) || xhr.responseText || msg;
			}catch(e){}
			showToast("danger", msg);
		});
	});

	$("#btnCopyToken").on("click", function(){
		if(!state.callbackToken){
			showToast("warning", "Callback token belum tersedia.");
			return;
		}
		var ta = $("<textarea>").val(state.callbackToken).appendTo("body").select();
		document.execCommand("copy");
		ta.remove();
		showToast("info", "Callback token disalin.");
	});

	loadProfile().done(function(){
		verifyConnection();
	});
})();
</script>
</body>
</html>
