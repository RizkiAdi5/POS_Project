// JavaScript Document
var transactionType;
function getutransactionType(){
	return transactionType;
}
function setuTransactionType(input){
	transactionType=input;
}
$(document).ready(function(e) {
	setuTransactionType('RC');
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'REFERENCE NO','mData':'refno','bSortable':false,'sWidth':'15%','bVisible':false},
				{'aTargets':[1],'sTitle':'TYPE','mData':'type','bSortable':false,'sWidth':'15%','bVisible':false},
				{'aTargets':[2],'sTitle':'REFERENCE NO','mData':'refno','bSortable':true,'sWidth':'15%'},
				{'aTargets':[3],'sTitle':'CUSTOMER NO','mData':'custno','bSortable':true,'sWidth':'20%'},
				{'aTargets':[4],'sTitle':'DATE','mData':'wos_date','bSortable':true,'sWidth':'10%'},
				{'aTargets':[5],'sTitle':'PERIOD','mData':'fperiod','bSortable':true,'sWidth':'10%'},
				{
					'aTargets':[6],
					'sTitle':'ACTION',
					'mData':'refno',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-envelope btn btn-link" '+
								'onclick="openFormModal(\''+data+'\',\''+row.type+'\');"></span>';
					}
				}
        	],
			'bAutoWidth':false,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':false,
			'fnServerParams':function(aoData){
				var utransactionType=getutransactionType();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"targetTable","value":''+targetTable+''},
					{"name":"transactionType","value":''+utransactionType+''}
				);
        	},
			'sAjaxSource':'/latest/generalSetup/eSPT/eSPT.cfc',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		})
		.fadeIn();
		
		var datatable = $('.dataTable');
        // SEARCH - Add the placeholder for Search and Turn this into in-line formcontrol
        var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
        search_input.attr('placeholder', 'Search')
        search_input.addClass('form-control input-small')
        search_input.css('width', '250px')
 
        // SEARCH CLEAR - Use an Icon
        var clear_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] a');
        clear_input.html('<i class="icon-remove-circle icon-large"></i>')
        clear_input.css('margin-left', '5px')
 
        // LENGTH - Inline-Form control
        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select');
        length_sel.addClass('form-control input-small')
        length_sel.css('width', '75px')
 
        // LENGTH - Info adjust location
        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_info]');
        length_sel.css('margin-top', '18px')

	$('#purchaseReceiveButton').on('click',function(e){
		$('li').removeClass('active');
		$('#purchaseReceiveNav').addClass('active');
		setuTransactionType('RC');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#purchaseReturnButton').on('click',function(e){
		$('li').removeClass('active');
		$('#purchaseReturnNav').addClass('active');
		setuTransactionType('PR');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#invoiceButton').on('click',function(e){
		$('li').removeClass('active');
		$('#invoiceNav').addClass('active');
		setuTransactionType('INV');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#creditNoteButton').on('click',function(e){
		$('li').removeClass('active');
		$('#creditNoteNav').addClass('active');
		setuTransactionType('ST');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#debitNoteButton').on('click',function(e){
		$('li').removeClass('active');
		$('#debitNoteNav').addClass('active');
		setuTransactionType('DN');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#cashSalesButton').on('click',function(e){
		$('li').removeClass('active');
		$('#cashSalesNav').addClass('active');
		setuTransactionType('CS');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
		
	});
	
	
	$('#formModal').modal({
		keyboard:true,
		show:false
	});
	
	$('.closeFormModal').on('click',function(e){
		$('#formModal').modal('hide');
	});
	
	$('#submit').on('click',function(e){
		$.ajax({
			'dataType':'json',
			'type':'POST',
			'url':'/latest/generalSetup/eSPT/eSPT.cfc',
			'data':{
				method:'updateArtranINDO',
				returnformat:'json',
				dts:dts,
				refno:$('#refno').html(),
				type:$('#type').html(),
				kodePajak:$('#kodePajak').val(),
				kodeTransaksi:$('#kodeTransaksi').val(),
				kodeStatus:$('#kodeStatus').val(),
				kodeDokumen:$('#kodeDokumen').val(),
				flagVAT:$('#flagVAT').val(),
				NPWP:$('#NPWP').val(),
				namaLwnTransaksi:$('#namaLwnTransaksi').val(),
				nomorDokumen:$('#nomorDokumen').val(),
				jenisDokumen:$('#jenisDokumen').val(),
				nomorSeriDiganti:$('#nomorSeriDiganti').val(),
				jenisDokumenDiganti:$('#jenisDokumenDiganti').val(),
				tanggalDokumen:$('#tanggalDokumen').val(),
				tanggalSSP:$('#tanggalSSP').val(),
				masaPajak:$('#masaPajak').val(),
				tahunPajak:$('#tahunPajak').val(),
				pembetulan:$('#pembetulan').val(),
				DPP:$('#DPP').val(),
				PPN:$('#PPN').val(),
				PPnBM:$('#PPnBM').val()	
			},
			
			'success':function(data,status,jqXHR){
				alert(11);
				if(data.toString()=='true'){
					$('#alertBox').addClass('alert-success');
					$('#alertBox p').html('Update successfully!');
					$('#alertBox')
					.fadeIn('fast')
					.delay(5000).fadeOut('fast');
				}else{
					alert(22);
					$('#alertBox').addClass('alert-danger');
					$('#alertBox p').html('Failed to update!');
					$('#alertBox')
					.fadeIn('fast')
					.delay(5000).fadeOut('fast');
				}
			},
			'complete':function(jqXHR,status){
				$('#formModal').modal('hide');
			}
		});
	});
	
	$('.closeAlertBox').on('click',function(e){
		$('#alertBox').hide();
	});
});

function openFormModal(refno,type){
	$('#formModalTitle').html(targetTitle+': '+refno);
	$('#refno').html(refno);
	$('#type').html(type);
	$('#targetLabel').html(targetTitle);
	$.ajax({
		'dataType':'json',
		'type':'POST',
		'url':'/latest/generalSetup/eSPT/eSPT.cfc',
		'data':{
			method:'getArtranINDO',
			returnformat:'json',
			dts:dts,
			refno:refno,
			type:type
		},
		'success':function(data,status,jqXHR){
			
			
		},
		'complete':function(jqXHR,status){
			$('#formModal').modal('show');
		}
	});
}

