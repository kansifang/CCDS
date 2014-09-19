function MR2_head(myobjname,myact){
	var myi=myobjname.substring(myobjname.length-1);
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HEAD>");
	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1) 
		sss[jjj++]=("<LINK href='"+sPath+"style_gd.css' rel=stylesheet>");
	else                 
		sss[jjj++]=("<LINK href='"+sPath+"style_ff.css' rel=stylesheet>");
	sss[jjj++]=("<LINK href='"+sPath+"../style.css' rel=stylesheet>");
	sss[jjj++]=("</HEAD>");
	
	return sss.join('');
}

function MR2_body(myobjname,myact){
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	var curPP=0;
	if(myact==5) curPP=0;//myobj.document.forms[0].elements["txtJump"].value;
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<BODY oncontextmenu='self.event.returnValue=false' onmousedown='parent.mE(event,\""+myobj.name+"\");' onKeyDown='parent.kD(event,\""+myobj.name+"\")' onKeyUp='parent.kU(event,\""+myobj.name+"\")'>");
	sss[jjj++]=("<div style={position:absolute;width:100%;height:100;overflow: auto;}>");
	if(bNeedCA) 
		sss[jjj++]=(" <object id=doit style='display:none' classid='CLSID:8BE89452-A144-49BC-9643-A3D436D83241' border=0 width=0 height=0></object>  ");
	sss[jjj++]=("<form name='form1' class='ffform'>");

	switch(myact){
		case 1:
			curpage[myi]=0;
			break;
		case 2:
			if(curpage[myi]>0) curpage[myi]--;
			break;
		case 3:
			if(curpage[myi]<rr_c[myi]-1) curpage[myi]++;
			break;
		case 4:
			curpage[myi]=rr_c[myi]-1;
			break;				
		case 5:
			curpage[myi]=curPP-1;
			if(curpage[myi]<0) curpage[myi]=0;
			if(curpage[myi]>rr_c[myi]-1) curpage[myi]=rr_c[myi]-1;			
			break;				
	};
	sss[jjj++]=("<span style='font-size: 9pt;display:none'>");
	sss[jjj++]=("<a href='javascript:parent.MR2(\""+myobjname+"\",1)'>首笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",2)'>前一笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",3)'>后一笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",4)'>尾笔</a> <br>");
	sss[jjj++]=("共有&nbsp;"+rr_c[myi]+"&nbsp;条记录，当前为第&nbsp;"+(curpage[myi]+1)+"&nbsp;条记录<br>");
	sss[jjj++]=("&nbsp;&nbsp;跳至&nbsp;<input type=text name=txtJump style='FONT-SIZE: 9pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onkeydown='javascript:parent.MRK2(\""+myobjname+"\",5)'>&nbsp;笔");
	sss[jjj++]=("</span>");

	pagesize[myi]=1;  
	if(rr_c[myi]>0){
		for(var j=curpage[myi]*pagesize[myi];j<=curpage[myi]*pagesize[myi];j++){
			iCurRow = j; 
	     	
			//modify by hxd in 2005/07/08 for '
			//sss[jjj++] = amarsoft2Real(drawHarbor(myobjname,myact,myi,j));
			sss[jjj++] = amarsoft2Html(drawHarbor(myobjname,myact,myi,j));
		}
	}
	
	sss[jjj++]=("</form>");
	sss[jjj++]=("</div>");
	sss[jjj++]=("</BODY>");
	return sss.join('');			
}
//freeform
function MR2(myobjname,myact){
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  

	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_sel_rec[myi]=-1;		
	cur_sel_item[myi]="";		

	myobj.document.write("");
	myobj.document.close();
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HTML>");
	sss[jjj++]=MR2_head(myobjname,myact);
	sss[jjj++]=MR2_body(myobjname,myact);
	sss[jjj++]=("</HTML>");

	//modify by hxd in 2005/07/08 for '
	//myobj.document.writeln(amarsoft2Html(sss.join('')));		
	myobj.document.writeln((sss.join('')));		
	myobj.document.close();		
		
	window.status="Ready";  
	window.status=myoldstatus;  
	myAfterLoadFreeForm(myi);
}