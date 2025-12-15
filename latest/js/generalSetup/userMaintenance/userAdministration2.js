// JavaScript Document
$(document).ready(function(e) {
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'COMPANY ID','mData':'userbranch','bSortable':true,'bVisible':false,'sWidth':'0%'},
				{'aTargets':[1],'sTitle':'USER ID','mData':'userid','bSortable':true,'sWidth':'20%'},
				{'aTargets':[2],'sTitle':'USER NAME','mData':'username','bSortable':true,'sWidth':'20%'},
				{'aTargets':[3],'sTitle':'GROUP','mData':'usergrpid','bSortable':true,'sWidth':'10%'},
				{'aTargets':[4],'sTitle':'EMAIL','mData':'useremail','bSortable':true,'sWidth':'20%'},
				{'aTargets':[5],'sTitle':'LAST LOGIN','mData':'lastlogin','bSortable':true,'sWidth':'12%'},
				{'aTargets':[6],'sTitle':'CREATED BY','mData':'created_by','bSortable':true,'sWidth':'11%'},
				{
					'aTargets':[7],
					'sTitle':'ACTION',
					'mData':'userid',
					'bSortable':false,
					'sWidth':'7%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/latest\/generalSetup\/userMaintenance\/user.cfm?action=update&userid='+escape(encodeURIComponent(data))+'&companyID='+escape(encodeURIComponent(row.userbranch))+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="if(confirm(\'Are you sure you wish to delete this user?\')){window.open(\'\/latest\/generalSetup\/userMaintenance\/userProcess.cfm?action=delete&userid='+escape(encodeURIComponent(data))+'&companyID='+escape(encodeURIComponent(row.userbranch))+'\',\'_self\');}"></span>';
					}
				}
				
        	],
			'bAutoWidth':false,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':true,
			
			/*Overwrite default display*/
			'oLanguage': {
      			'sInfoFiltered': ''
    		},
			
			'fnServerParams':function(aoData){
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"userGroup","value":''+userGroup+''},
					{"name":"userID","value":''+userID+''},
					{"name":"targetTable","value":''+targetTable+''}
				);
        	},
			'sAjaxSource':'/latest/generalSetup/userMaintenance/userAdministration2.cfc',
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
});