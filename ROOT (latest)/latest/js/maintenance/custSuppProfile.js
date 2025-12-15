// JavaScript Document
$(document).ready(function(e) {
	if(display =='T'){
		visibleC = true;
	}else{
		visibleC = false;
	}
	if(target=='Customer'){
		redirect = 'customerProcess.cfm';
	}else{
		redirect = 'supplierProcess.cfm';
	}
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':account.toUpperCase(),'mData':'custno','bSortable':true,'sWidth':'10%'},
				{
					'aTargets':[1],
					'sTitle':targerWords.toUpperCase(),
					'mData':'name',
					'bSortable':true,
					'sWidth':'20%',
					'mRender':function(data,type,object){
						return object.name+' '+object.name2;
					}
				},
				{'aTargets':[2],'sTitle':'NAME2','mData':'name2','bSortable':true,'bVisible':false},
				{
					'aTargets':[3],
					'sTitle':address.toUpperCase(),
					'mData':'add1',
					'bSortable':true,
					'sWidth':'20%',
					'mRender':function(data,type,object){
						var address='';
						if(object.add1!=''){
							address=address+object.add1+'<br />';
						}
						if(object.add2!=''){
							address=address+object.add2+'<br />';
						}
						if(object.add3!=''){
							address=address+object.add3+'<br />';
						}
						if(object.add4!=''){
							address=address+object.add4+'<br />';
						}
						if(address!=''){
							address=address.substring(0, address.length-6)
						}
						return address;
					}
				},
				{'aTargets':[4],'sTitle':'ADDRESS2','mData':'add2','bSortable':true,'bVisible':false},
				{'aTargets':[5],'sTitle':'ADDRESS3','mData':'add3','bSortable':true,'bVisible':false},
				{'aTargets':[6],'sTitle':'ADDRESS4','mData':'add4','bSortable':true,'bVisible':false},
				{
					'aTargets':[7],
					'sTitle':contact.toUpperCase(),
					'mData':'phone',
					'bSortable':true,
					'sWidth':'15%',
					'mRender':function(data,type,object){
						var contact='';
						var counter=1;
						if(object.phone!=''){
							contact=contact+'['+counter+'] '+object.phone+'<br />';
							counter++;
						}
						if(object.phonea!=''){
							contact=contact+'['+counter+'] '+object.phonea+'<br />'
							counter++;
						}
						if(contact!=''){
							contact=contact.substring(0, contact.length-6)
						}
						return contact;
					}
				},
				{'aTargets':[8],'sTitle':'CONTACT2','mData':'phonea','bSortable':true,'bVisible':false},
				{'aTargets':[9],'sTitle':attention.toUpperCase(),'mData':'attn','bSortable':true,'sWidth':'15%'},
				{
					'aTargets':[10],
					'sTitle':currency.toUpperCase(),
					'mData':'currcode',
					'bSortable':true,
					'sWidth':'10%'
				},
				{
					
					'aTargets':[11],
					'sTitle':action.toUpperCase(),
					'mData':'custno',
					'bSortable':false,
					'bVisible':visibleC,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/latest\/maintenance\/target.cfm?target='+target+'&action=update&menuID='+escape(encodeURIComponent(menuID))+'&custno='+escape(encodeURIComponent(data))+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="if(confirm(\'Are you sure you wish to delete this?\')){window.open(\'\/latest\/maintenance\/'+redirect+'?action=delete&menuID='+escape(encodeURIComponent(menuID))+'&custno='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>';
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
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":dts},
					{"name":"targetTable","value":targetTable}
				);
        	},
			'sAjaxSource':'/latest/maintenance/custSuppProfile.cfc',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		})
		.fadeIn();
		
		var datatable = $('.dataTable');
        // SEARCH - Add the placeholder for Search and Turn this into in-line formcontrol
        var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
        search_input.attr('placeholder', SEARCH)
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
});