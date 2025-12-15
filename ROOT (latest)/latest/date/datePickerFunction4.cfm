<script type="text/javascript">
    
    $(document).ready(function(e) {
    
        $('#date').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#date" ).datepicker( "option", "minDate", selectedDate );
            }
        });

    });
</script>