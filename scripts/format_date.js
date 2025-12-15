function format_date(datefrom,dateto)
	{
		if(document.getElementById(new String(datefrom)))
		{
			var target_date_from = new String(datefrom);
			var format_date_from = document.getElementById(target_date_from).value;
			var split_date_from = format_date_from.split(/[-,/,\\]/g);
			document.getElementById(target_date_from).value = "{ts '"+split_date_from[2]+"-"+split_date_from[1]+"-"+split_date_from[0]+" 00:00:00'}";
		}
		
		if(document.getElementById(new String(dateto)))
		{
			var target_date_to = new String(dateto);
			var format_date_to = document.getElementById(target_date_to).value;
			var split_date_to = format_date_to.split(/[-,/,\\]/g);
			document.getElementById(target_date_to).value = "{ts '"+split_date_to[2]+"-"+split_date_to[1]+"-"+split_date_to[0]+" 00:00:00'}";
		}
	}