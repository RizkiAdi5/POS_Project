// JavaScript Document
var tax_type;
function getuTax_type(){
	return tax_type;
}
function setuTax_type(input){
	tax_type=input;
}
$(document).ready(function(e) {
	setuTax_type('T,PT,ST');
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'ENTRY CODE','mData':'entryno','bSortable':false,'sWidth':'0%','bVisible':false},
				{'aTargets':[1],'sTitle':'TAX CODE','mData':'code','bSortable':true,'sWidth':'15%'},
				{'aTargets':[2],'sTitle':'DESCRIPTION','mData':'desp','bSortable':true,'sWidth':'35%'},
				{
					'aTargets':[3],
					'sTitle':'RATE',
					'mData':'rate1',
					'bSortable':true,
					'sWidth':'11%',
					'mRender':function(data,type,row){
						return data;
					}
				},
				{	'aTargets':[4],
					'sTitle':'TYPE',
					'mData':'tax_type',
					'bSortable':true,
					'sWidth':'14%',
					'mRender':function(data,type,row){
						if(data=='T'){
							return 'GENERAL';
						}else if(data=='PT'){
							return 'PURCHASE';
						}else if(data=='ST'){
							return 'SALES';
						}else{
							return '';
						}
					}
				},
				{'aTargets':[5],'sTitle':'CORRESPONDENT ACC NO.','mData':'corr_accno','bSortable':true,'sWidth':'25%'},

				{
					'aTargets':[6],
					'sTitle':'ACTION',
					'mData':'entryno',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/latest\/generalSetup\/currencyTax\/tax.cfm?action=update&entryno='+escape(encodeURIComponent(data))+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="if(confirm(\'Are you sure you wish to delete this tax?\')){window.open(\'\/latest\/generalSetup\/currencyTax\/taxProfile.cfm?action=delete&entryno='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>';
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
				var uTax_type=getuTax_type();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"targetTable","value":''+targetTable+''},
					{"name":"tax_type","value":''+uTax_type+''}
				);
        	},
			'sAjaxSource':'/latest/generalSetup/currencyTax/taxProfile.cfc',
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

	$('#allButton').on('click',function(e){
		$('li').removeClass('active');
		$('#allNav').addClass('active');
		setuTax_type('T,PT,ST');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#generalButton').on('click',function(e){
		$('li').removeClass('active');
		$('#generalNav').addClass('active');
		setuTax_type('T');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#purchaseButton').on('click',function(e){
		$('li').removeClass('active');
		$('#purchaseNav').addClass('active');
		setuTax_type('PT');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#salesButton').on('click',function(e){
		$('li').removeClass('active');
		$('#salesNav').addClass('active');
		setuTax_type('ST');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
});