/***************************
PSPL Multi Select Box,

A Linkware by
Possible Solutions Pvt. Ltd.
If you are using PSPL Multi Select Box on your pages,
you must place a back link to one of our sites, link codes are as below
<a href="http://possible.in">Possible Solutions, Web Development and design company</a>
<a href="http://multi-select-box.possible.in">PSPL Multi Select Box, Select without pressing ALT</a>

This linkware can not be used on sites meant for making profit or revenue.
For such sites You can buy the commercial version or extended use version.
You can purchase licence on http://multi-select-box.possible.in/purchase
****************************/
function U(au,aw,ap,ai,aj,ah,Z,ac,D,G)
{	
	av=this;
	this.ax=au;
	this.f=aw;
	this.O=ap;
	this.A=ai;
	this.P=aj;
	this.J=ah;
	this.w=Z;
	this.R=ac;
	this.L=D;
	this.o=G;
	this.n=false;
	this.r=document.getElementById(this.f);
	this.Q=false;
	this.at = function(){this.r.style.display="none";B=document.getElementById(this.f+'_box');B.innerHTML+='<input readonly="readonly" id="'+this.f+'_text" name="'+this.f+'_text" type="text" value="" class="'+this.J+'" />';B.innerHTML+='<img id="'+this.f+'_arrow" class="'+this.P+'" src="'+this.A+'" title="Click to Select" /><div id="'+this.f+'_optionDiv" class="'+this.w+'" ></div>';this.r=document.getElementById(this.f);};
	this.F = function(){C=this.r.options;v='';for(j=0;j<C.length;j++){if(C[j].selected==true){v+=C[j].innerHTML+',';}}this.t.value=v;};
	this.K = function(){ar=document.body.offsetTop;ab=document.body.offsetLeft;if(this.n==false){this.n=true;this.d.style.top=aa(this.t)+this.t.offsetHeight+'px';this.d.style.left=Y(this.B)+ab+'px';this.d.style.display='block';this.F();}else{this.al();}};
	this.al = function(){this.n=false;this.d.style.top= -2000+'px';this.d.style.left= -2000+'px';this.d.style.display='none';};
	this.T=function(){C=this.r.options;this.d=document.getElementById(this.f+'_optionDiv');this.d.style.width=this.t.scrollWidth+this.l.width+'px';v='<table id="'+this.f+'_table" cellpadding="0" cellspacing="0" border="0" width="100%" >';for(j=0;j<C.length;j++){if(C[j].selected==true){v+='<tr class="row"><td id="'+this.f+'_td_'+j+'" nowrap class="'+this.o+'">'+C[j].innerHTML+'</td></tr>';}else{v+='<tr class="row"><td id="'+this.f+'_td_'+j+'" nowrap class="'+this.R+'">'+C[j].innerHTML+'</td></tr>';}}v+='</table>';this.d.innerHTML=v;this.d.style.display='block';this.I=document.getElementById(this.f+'_table');if(this.I.scrollWidth>parseInt(this.d.style.width)){this.d.style.width=this.I.scrollWidth+'px';}this.d.style.height=this.I.scrollHeight+'px';as=this;};
	this.X=function(j){if(this.r.options[j].selected==true){this.r.options[j].selected=false;}else{this.r.options[j].selected=true;}this.F();};
	this.H=function(index,ao){if(this.r.options[index].selected==true){this.e[index].className=G;}else{if(ao=="selected"){this.e[index].className=D;}else if(ao=="hover"){this.e[index].className=D;}else{this.e[index].className=ac;}}this.e[index].refresh;}
};
	
function af(g){c[g].l.onclick=function(){c[g].K();};c[g].l.onmouseover=function(){c[g].l.src=c[g].O;};c[g].l.onmouseout=function(){c[g].l.src=c[g].A;};c[g].B.onclick=function(ay){c[g].Q=true;};for(k=0;k<c[g].r.options.length;k++){c[g].e[k]=document.getElementById(c[g].f+'_td_'+k);eval('c['+g+'].e['+k+'].onclick = function(){ c['+g+'].X( '+k+' ); c['+g+'].H( '+k+',\'selected\' ); }');eval('c['+g+'].e[ '+k+'].onmouseover = function(){  c['+g+'].H('+k+', \'hover\' ); }');eval('c['+g+'].e[ '+k+'].onmouseout = function(){  c['+g+'].H( '+k+', \'normal\' ); }');}};
function aa(am){V=am;ag=am.offsetTop;while(V.offsetParent!=null){V=V.offsetParent;ag+=V.offsetTop;}return ag;};
function Y(an){M=an;ad=an.offsetLeft;while(M.offsetParent!=null&&M.offsetParent.tagName!='BODY'){M=M.offsetParent;ad+=M.offsetLeft;}return ad;};
function az(){};
c=Array();
function Init(ak,O,A,P,J,w,R,L,o){
		c[c.length]=new U(c.length,ak,O,A,P,J,w,R,L,o);
		c[c.length-1].at();
		c[c.length-1].B=document.getElementById(c[c.length-1].f+'_box');
		c[c.length-1].t=document.getElementById(c[c.length-1].f+'_text');
		c[c.length-1].l=document.getElementById(c[c.length-1].f+'_arrow');
		c[c.length-1].d=document.getElementById(c[c.length-1].f+'_optionDiv');
		c[c.length-1].e=new Array();
		c[c.length-1].F();
		c[c.length-1].T();
		af(c.length-1);
};
function aq(){for(m=0;m<c.length;m++){if(c[m].Q==false){c[m].al();}c[m].Q=false;}};
function ae(){for(m=0;m<c.length;m++){if(c[m].n==true){c[m].al();c[m].K();}}};document.onclick=aq;window.onresize=ae; 