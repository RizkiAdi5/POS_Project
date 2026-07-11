// Kitchen Profile DataTables
$(document).ready(function(e) {
    var visibleC = (display === 'T');

    var resultTable = $('#resultTable')
        .dataTable({
            'aLengthMenu': [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
            'aoColumnDefs': [
                { 'aTargets': [0], 'sTitle': 'KITCHEN ID', 'mData': 'kitchenID', 'bSortable': true,  'sWidth': '20%' },
                { 'aTargets': [1], 'sTitle': 'NAME',       'mData': 'name',      'bSortable': true,  'sWidth': '50%' },
                {
                    'aTargets': [2],
                    'sTitle': 'ACTION',
                    'mData': 'kitchenID',
                    'bSortable': false,
                    'bVisible': visibleC,
                    'sWidth': '15%',
                    'mRender': function(data, type, row) {
                        return '<span class="glyphicon glyphicon-pencil btn btn-link" ' +
                               'onclick="window.open(\'/latest/maintenance/kitchen.cfm?action=update&kitchenID=' + escape(encodeURIComponent(data)) + '\',\'_self\');"></span>' +
                               '<span class="glyphicon glyphicon-remove btn btn-link" ' +
                               'onclick="if(confirm(\'Are you sure you wish to delete this kitchen staff?\')){window.open(\'/latest/maintenance/kitchenProcess.cfm?action=delete&kitchenID=' + escape(encodeURIComponent(data)) + '\',\'_self\');}"></span>';
                    }
                }
            ],
            'bAutoWidth': false,
            'bFilter': true,
            'bDestroy': true,
            'bProcessing': true,
            'bServerSide': true,
            'bStateSave': false,
            'fnServerParams': function(aoData) {
                aoData.push(
                    { "name": "method",       "value": "listAccount" },
                    { "name": "returnformat", "value": "json" },
                    { "name": "dts",          "value": dts },
                    { "name": "targetTable",  "value": targetTable }
                );
            },
            'sAjaxSource': '/latest/maintenance/kitchenProfile.cfc',
            'sServerMethod': 'POST',
            'sScrollX': '100%'
        })
        .fadeIn();

    var datatable = $('.dataTable');
    var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
    search_input.attr('placeholder', 'Search').addClass('form-control input-small').css('width', '250px');

    var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select');
    length_sel.addClass('form-control input-small').css('width', '75px');

    var info = datatable.closest('.dataTables_wrapper').find('div[id$=_info]');
    info.css('margin-top', '18px');
});
