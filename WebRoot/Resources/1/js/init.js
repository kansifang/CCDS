function beforeInit(bSetPageSize){
	var i = 0, j = 0;
	for(i=0;i<DZ.length;i++) {
		my_notnull_temp[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull_temp[i][j] = DZ[i][1][j][4];
	}
		
	return true;
}
//初始化各种变量
function init(bSetPageSize){
	if(!beforeInit(bSetPageSize)) return;
	var myoldstatus = window.status;  
	window.status="正在初始化数据，请稍候....";
	var i;
	for(i=0;i<DZ.length;i++) {
		f_c[i]=DZ[i][1].length;
		r_c[i] =DZ[i][2].length;		
		rr_c[i]=DZ[i][2].length;		
		f_css[i]=new Array();
		for(var j=0;j<f_c[i];j++)
			f_css[i][j]="";
		if(arguments.length==0 || (arguments.length>=1 && bSetPageSize) ){
			if(DZ[i][0][0]==1) { 
				pagesize[i]=99999999;
				pageone[i]=1; 
			} 
			else              
				pagesize[i]=1; 
		}
		pagenum[i]=Math.ceil(rr_c[i]/pagesize[i]);
		curpage[i]=0;
		bDoUnload[i] = false;
	}
	for(i=0;i<DZ.length;i++) {
		my_change[i] = new Array();
		for(var iTemp=0;iTemp<rr_c[i];iTemp++){
			my_change[i][iTemp] = new Array();
			for(var jTemp=0;jTemp<f_c[i];jTemp++)
				my_change[i][iTemp][jTemp]=0;
		}		
	}
	for(i=0;i<DZ.length;i++) {
		my_changedoldvalues[i] = new Array();
		for(iTemp=0;iTemp<rr_c[i];iTemp++){
			my_changedoldvalues[i][iTemp] = new Array();
			for(jTemp=0;jTemp<f_c[i];jTemp++)
				my_changedoldvalues[i][iTemp][jTemp]="";
		}		
	}
	for(i=0;i<DZ.length;i++) {
		my_attribute[i] = new Array();
		for(j=0;j<rr_c[i];j++)
			my_attribute[i][j] = 0;
	}
	for(i=0;i<DZ.length;i++) {
		my_notnull[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull[i][j] = DZ[i][1][j][4];
	}
	for(i=0;i<DZ.length;i++) {
		last_sel_rec[i]=-1;
		cur_sel_rec[i]=-1;
		last_sel_item[i]="";
		cur_sel_item[i]="";
		needReComputeIndex[i]=1;
		my_index[i]=new Array();
		for(j=0;j<rr_c[i];j++)
			my_index[i][j]=j;
		cur_sortfield[i]=0;
		cur_sortorder[i]=2; 
		sort_begin[i]=0;
		sort_end[i]=rr_c[i]-1;
	}
	iCurRow = -1;
	iCurCol = 0;
	window.status="Ready";  
	window.status=myoldstatus;  
}
function beforeMy_load(my_sortorder,sort_which,myobjname,need_change){
	return true;
}
//for amarchange at grid when rec>100 then release need some mins.
function my_load(my_sortorder,sort_which,myobjname,need_change){
	if(!beforeMy_load(my_sortorder,sort_which,myobjname,need_change)) return;
	if(!isValid()) return;
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	cur_sortorder[myi] = my_sortorder;
	cur_sortfield[myi] = sort_which;			
	
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	
	if(needReComputeIndex[myi]==1) {
		cur_sel_rec[myi]=-1;		
		cur_sel_item[myi]="";		
		a_b(my_sortorder,DZ[myi][2],sort_which,sort_begin[myi],sort_end[myi],my_index[myi]);
	}
	if(my_sortorder==1) {//正排序
		myimgstr="<img align='absmiddle' src='"+sPath+"sort_up.gif'>";
		my_sortorder=0;
	} else if(my_sortorder==0) {//倒排序
		myimgstr="<img  align='absmiddle' src='"+sPath+"sort_down.gif'>";
		my_sortorder=1;
	} else if(my_sortorder==2) {
		myimgstr="&nbsp;";
		my_sortorder=0;
	}
	myobj.document.clear();	
	myobj.document.close();
	
	curpage[myi]=0;
	if(DZ[myi][0][0]==1){//grid
		if(arguments.length==4) 
			MR1(myobjname,1,my_sortorder,sort_which,need_change);
		else
			MR1(myobjname,1,my_sortorder,sort_which);
	}else{               //freeform    
		MR2(myobjname,1);
	}
	window.status="Ready";  
	window.status=myoldstatus;  
	if(bShowUnloadMessage)
		document.body.onbeforeunload=closeCheck;//(myobjname);
}