// JavaScript Document
$(document).ready(function(e) {
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':itemCodeLabel.toUpperCase(),'mData':'item_code','bSortable':true,'sWidth':'20%'},
				{'aTargets':[1],'sTitle':itemNameLabel.toUpperCase(),'mData':'item_name','bSortable':true,'sWidth':'40%'},
				{'aTargets':[2],'sTitle':recipeCountLabel.toUpperCase(),'mData':'recipe_count','bSortable':true,'sWidth':'20%'},
				{
					'aTargets':[3],
					'sTitle':action.toUpperCase(),
					'mData':'item_code',
					'bSortable':false,
					'sWidth':'20%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/latest\/maintenance\/menuRecipe.cfm?itemno='+encodeURIComponent(data)+'&menuID='+menuID+'\',\'_self\');"></span> Edit Recipe';
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
					{"name":"dts","value":dts}
				);
        	},
			'sAjaxSource':'/latest/maintenance/menuRecipeProfile.cfc',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		})
		.fadeIn();

		var datatable = $('.dataTable');
        var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
        search_input.attr('placeholder', SEARCH)
        search_input.addClass('form-control input-small')
        search_input.css('width', '250px')

        var clear_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] a');
        clear_input.html('<i class="icon-remove-circle icon-large"></i>')
        clear_input.css('margin-left', '5px')

        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select');
        length_sel.addClass('form-control input-small')
        length_sel.css('width', '75px')

        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_info]');
        length_sel.css('margin-top', '18px')
});
