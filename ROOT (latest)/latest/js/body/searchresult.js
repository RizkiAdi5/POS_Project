// JavaScript Document
var resultTable='';
var invisibleColumns='';
var method='';
var husergrpid='';
var dts='';
var category='';
var attribute='';
var operator='';
var keyword='';
var target_arcust='';
var target_apvend='';

$(document).ready(function(e) {
	resultTable=top.frames['leftFrame'].initResultTable();
	removeSorting();
		
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
function initResultTable(){
	var resultTable=$('#resultTable')
		.dataTable({
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[22],'sTitle':'TYPE','mData':'type','bSortable':true,'bVisible':false,'sWidth':'5%'},
				{'aTargets':[0],'sTitle':'CUST/SUPP NO','mData':'custno','bSortable':true,'sWidth':'12%'},
				{'aTargets':[1],'sTitle':'NAME','mData':'name','bSortable':true,'sWidth':'15%'},
				{'aTargets':[2],'sTitle':'AGENT','mData':'agenno','bSortable':true,'sWidth':'9%'},
				{'aTargets':[3],'sTitle':'PROJECT/JOB','mData':'source','bSortable':true,'sWidth':'10%'},
				{'aTargets':[4],'sTitle':'REFERENCE NO','mData':'refno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[5],'sTitle':'PERIOD','mData':'fperiod','bSortable':true,'sWidth':'8%'},
				{'aTargets':[6],'sTitle':'DATE','mData':'wos_date','bSortable':true,'sWidth':'8%'},		
				{'aTargets':[7],'sTitle':'Customer','mData':'custno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[8],'sTitle':'Supplier','mData':'custno','bSortable':true,'sWidth':'10%'},
				
				{'aTargets':[9],'sTitle':'NAME','mData':'nameA','bSortable':true,'sWidth':'10%'},
				{'aTargets':[10],'sTitle':'Address','mData':'address','bSortable':true,'sWidth':'25%'},
				{'aTargets':[11],'sTitle':'Country','mData':'country','bSortable':true},
				{'aTargets':[12],'sTitle':'Postal Code','mData':'postalcode','bSortable':true},
				{'aTargets':[13],'sTitle':'Attention','mData':'attn','bSortable':true,'sWidth':'10%'},
				{'aTargets':[14],'sTitle':'Email','mData':'e_mail','bSortable':true},
				{'aTargets':[15],'sTitle':'Website','mData':'web_site','bSortable':true},
				{'aTargets':[16],'sTitle':'Phone','mData':'phone','bSortable':true,'sWidth':'10%'},
				{'aTargets':[17],'sTitle':'Fax','mData':'fax','bSortable':true,'sWidth':'10%'},
				{'aTargets':[18],'sTitle':'Contact','mData':'contact','bSortable':true},
				{'aTargets':[19],'sTitle':'CR','mData':'currency','bSortable':true,'sWidth':'6%'},
				{'aTargets':[20],'sTitle':'DATE','mData':'date','bSortable':true,'sWidth':'6%'},
				{'aTargets':[21],'sTitle':'Action','mData':'action','bSortable':false,'sWidth':'6%'},
				{'bVisible':false,'aTargets':invisibleColumns}
        	],
			'bAutoWidth':false,
			'bFilter':false,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':false,
			'fnServerParams':function(aoData){
				var uMethod=getuMethod();
				var uHusergrpid=getuHusergrpid();
				var uDts=getuDts();
				var uCategory=getuCategory();
				var uAttribute=getuAttribute();
				var uOperator=getuOperator();
				var uKeyword=getuKeyword();
				var uTargetArcust=getTargetArcust();
				var uTargetApvend=getTargetApvend();
				aoData.push(
					{"name":"method","value":''+uMethod+''},
					{"name":"returnformat","value":"json"},
					{"name":"husergrpid","value":''+uHusergrpid+''},
					{"name":"dts","value":''+uDts+''},
					{"name":"category","value":''+uCategory+''},
					{"name":"attribute","value":''+uAttribute+''},
					{"name":"operator","value":''+uOperator+''},
					{"name":"keyword","value":''+uKeyword+''},
					{"name":"target_arcust","value":''+uTargetArcust+''},
					{"name":"target_apvend","value":''+uTargetApvend+''}
				);
        	},
			'sAjaxSource':'/latest/body/searchresult.cfc',
			'sDom':'<"row"<"col-xs-6"l><"col-xs-6"p>r>t<"row"<"col-xs-6"i><"col-xs-6"p>>',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		});
	return resultTable;
};
function setuMethod(uMethod){
	method=uMethod;
};
function setuHusergrpid(uHusergrpid){
	husergrpid=uHusergrpid;
};
function setuDts(uDts){
	dts=uDts;
};
function setuCategory(uCategory){
	category=uCategory;
};
function setuAttribute(uAttribute){
	attribute=uAttribute;
};
function setuOperator(uOperator){
	operator=uOperator;
};
function setuKeyword(uKeyword){
	keyword=uKeyword;
};
function setuTargetArcust(uTargetArcust){
	target_arcust=uTargetArcust;
};
function setuTargetApvend(uTargetApvend){
	target_apvend=uTargetApvend;
};


function getuMethod(){
	return method;
};
function getuHusergrpid(){
	return husergrpid;
};
function getuDts(){
	return dts;
};
function getuCategory(){
	return category;
};
function getuAttribute(){
	return attribute;
};
function getuOperator(){
	return operator;
};
function getuKeyword(){
	return keyword;
};
function getTargetArcust(){
	return target_arcust;
};

function getTargetApvend(){
	return target_apvend;
};

function setInitialInvisibleColumn(columns){
	invisibleColumns=columns;
};

function showColumn(columns){	
	for (var i=0;i<21;i++){
		resultTable.fnSetColumnVis(i,false,false);
	};
	for (var i=0;i<columns.length;i++){
		resultTable.fnSetColumnVis(columns[i],true,false);
	};
};

function removeSorting(){
	resultTable.fnSort([]);
};

function redrawResultTable(){
	resultTable.fnDraw();
};