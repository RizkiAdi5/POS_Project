// JavaScript Document
var menu_level;
function getuAcctype(){
	return menu_level;
}
function setuAcctype(input){
	menu_level=input;
}
$(document).ready(function(e) {
	setuAcctype('');
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'MENU ID','mData':'menu_id','bSortable':true,'bVisible':false,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':'MENU NAME','mData':'menu_name','bSortable':true,'sWidth':'20%'},
				{	'aTargets':[2],
					'sTitle':'NEW MENU NAME',
					'mData':'new_menu_name',
					'bSortable':true,
					'sWidth':'20%',
					'mRender':function(data,type,row){
						if(data!=''){
							return '<div id="'+row.menu_id+'" class="menuEditable">'+data+'</div>';
						}else{
							return '<div id="'+row.menu_id+'" class="menuEditable">'+''+'</div>';
						};
					}
				},
				{
					'aTargets':[3],
					'sTitle':'MENU LEVEL',
					'mData':'menu_level',
					'bSortable':true,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						if(data=='1'){
							return '1';
						}else if(data=='2'){
							return '2';
						}else if(data=='3'){
							return '3';
						}else if(data=='4'){
							return '4';
						}else{
							return '';
						}
					}
				},
        	],
			'bAutoWidth':false,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':false,
			'fnDrawCallback':function(oSettings){
				$('.menuEditable').editable('/latest/generalSetup/generalInfoSetup/userDefinedMenu.cfc',{
					id:$(this).attr('id'),
					name:'new_menu_name',
					cancel:'CANCEL',
					submit:'OK',
					indicator : 'Updating...',
					tooltip:'Click to change the menu name.',
					type:'text',
					submitdata:{
						method:'updateMenuName',
						returnformat:'plain',
						dts:dts,
						authUser:authUser,
					},
					onsubmit:function(settings,original){
						return confirm('Are you sure want to update?');
					},
					callback:function(value,settings){
						resultTable.fnDraw();
					}
				});
			},
			'fnServerData':function(sSource,aoData,fnCallback,oSettings){
				oSettings.jqXHR=$.ajax({
					'dataType':'json',
					'type':'POST',
					'url':sSource,
					'data':aoData,
					'success':function(data,status,jqXHR){
						grandTotalDebit=data.iTotalDebit;
						grandTotalCredit=data.iTotalCredit;
						fnCallback(data);
					}
				});
			},
			'fnServerParams':function(aoData){
				var uAcctype=getuAcctype();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"menu_level","value":''+uAcctype+''}
				);
        	},
			'sAjaxSource':'/latest/generalSetup/generalInfoSetup/userDefinedMenu.cfc',
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
		setuAcctype('');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#level1Button').on('click',function(e){
		$('li').removeClass('active');
		$('#level1Nav').addClass('active');
		setuAcctype('1');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#level2Button').on('click',function(e){
		$('li').removeClass('active');
		$('#level2Nav').addClass('active');
		setuAcctype('2');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#level3Button').on('click',function(e){
		$('li').removeClass('active');
		$('#level3Nav').addClass('active');
		setuAcctype('3');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#level4Button').on('click',function(e){
		$('li').removeClass('active');
		$('#level4Nav').addClass('active');
		setuAcctype('4');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
});