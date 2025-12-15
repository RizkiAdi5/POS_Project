_copyflocation = "http://"+location.host+"/ajax/functions/copyf.cfm";
_tranflocation = "http://"+location.host+"/ajax/functions/tranf.cfm";
_commonflocation = "http://"+location.host+"/ajax/functions/commonf.cfm";
_crmflocation = "http://"+location.host+"/ajax/functions/crmf.cfm";
_reportflocation = "http://"+location.host+"/ajax/functions/reportf.cfm";
_maintenanceflocation = "http://"+location.host+"/ajax/functions/maintenancef.cfm";
_fdipxflocation = "http://"+location.host+"/ajax/functions/fdipxf.cfm";

function errorHandler(message)
{
	$('disabledZone').style.visibility = 'hidden';
    if (typeof message == "object" && message.name == "Error" && message.description)
    {
        alert("Error: " + message.description);
    }
    else
    {
        alert(message);
    }
};
