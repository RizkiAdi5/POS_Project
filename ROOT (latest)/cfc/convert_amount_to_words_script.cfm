<cfscript>
	function toWords(s)
	{
		var th=arrayNew(1);
		var dg=arrayNew(1);
		var tn=arrayNew(1);
		var tw=arrayNew(1);
		th=listtoarray(" , thousand, million, billion,trillion", ",");
		dg=listtoarray("zero, one, two, three, four, five, six, seven, eight, nine", ","); 
		tn=listtoarray("ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen",","); 
		tw=listtoarray("twenty, thirty, forty, fifty, sixty, seventy, eighty, ninety",","); 
		s=Replace(s, ",", "", "All");
		
		if(s lt 0)
		{
			str='Negative';
			s=Replace(s, "-", "", "All");
		} 
		else 
		{
			str='';
		}
		
		if (s neq 0)
		{
			x=Find('.', S)-1;
			z=mid(s, 1, x);
			zd=mid(s, x+2, 2);
			cents_p=mid(s, x+2, 2);
			w_num=REReplace(z, "[T]*",",","ALL") ;
			w_num=RemoveChars(w_num, ((len(z)*2)+1), 1);
			w_num=RemoveChars(w_num, 1, 1);
			sk=0; 
			d_num=REReplace(cents_p, "[T]*",",","ALL") ;
			d_num=RemoveChars(d_num, ((len(cents_p)*2)+1), 1);
			d_num=RemoveChars(d_num, 1, 1);
			d_sk=0; 
			
			for (i=1; i lte x; i=i+1)
			{
				if (((x+1)-i) mod 3 eq 2) 
            	{
					if (listgetat(w_num, i) eq '1') 
                        {
							str=listAppend(str, tn[Val(listgetat(w_num, i+1))+1]); 
                            str=listAppend(str, ' '); 
                            i=i+1; 
                            sk=1;
                        } 
                        else if (listgetat(w_num, i) neq 0) 
                        {
                        	str=ListAppend(str, tw[Val(listgetat(w_num, i))-1]);
                        	str=listAppend(str, ' '); 
                        	sk=1;
                        }
            	} 
            	else if (listgetat(w_num, i) neq 0) 
				{
					str=ListAppend(str, dg[Val(listgetat(w_num, i))+1]); 
                    str=listAppend(str, ' '); 
                    
					if (((x+1)-i) mod 3 eq 0)
					{
                        str=ListAppend(str, 'hundred ');
                    }
                        sk=1;
            	} 
            	
				if (((x-i)-2) mod 3 eq 1) 
            	{
					if (sk)
					{
						str=listAppend(str, th[((x-i)/3)+1]); 
                        str=listAppend(str, ' '); 
					}
					sk=0;
            	}
            } 
			
			if (z gte 1  and x eq 1) 
			{
            	str=listAppend(str, 'dollar ');
			}
			else if (z neq 0 and x gte 1) 
			{
            	str=listAppend(str, 'dollars ');
			}
			
			if (zd neq 00)
			{ 
            	if (x neq len(s)) 
            	{
					y=len(s);
					
					if (z neq 0) 
					{
                        str=listAppend(str, 'and '); 
					}
					
					for (i=1; i lte 2; i=i+1) 
            		{
						if ((3-i) mod 3 eq 2) 
						{
							if (listgetat(d_num, i) eq '1') 
							{
								str=listAppend(str, tn[listgetat(d_num, i+1)+1]); 
                                i=i+1; 
                                d_sk=1;
                            } 
							else if (listgetat(d_num, i) neq 0) 
							{
								str=listAppend(str, tw[Val(listgetat(d_num, i))-1]); 
                                d_sk=1;
                            }
                        } 
                        else if (listgetat(d_num, i) neq 0) 
                        {
                        	str=listAppend(str, dg[listgetat(d_num, i)+1]); 
                        	d_sk=1;
                        }
					}
					
					if (zd eq 01)
					{
                        str=listAppend(str, ' cent');
                    }
                    else 
					{
                        str=listAppend(str, ' cents');
                    }
				}
			}
            return Replace(str, ",", "", "All");
		}
		return '-';
	}
</cfscript>