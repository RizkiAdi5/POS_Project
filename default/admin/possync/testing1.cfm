


<cfset pcent = 20>
<Cfoutput>

 <div id="progressbardiv" class="progress-bar" role="progressbar" aria-valuenow="#pcent#" aria-valuemin="0" aria-valuemax="100" style="width: #pcent#%">
                #pcent#          
 </div>
     
</cfoutput>