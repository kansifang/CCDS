//从MR1_s 和my_load_show_action_s 提取出公共部分
function getDWData(myobjname,myact){
	var myobj=window.frames[myobjname]; 
 	var curPP = 0; 
 	if(myact==5){
 	   	if(myobj.event.keyCode==13){
 			if(isNaN(myobj.document.forms[0].elements["txtJump_s"].value)){
 				alert("输入内容必须为数字！"); 
 				return; 
 			}else 
 				curPP=myobj.document.forms[0].elements["txtJump_s"].value;	 
 		}else 
 			return; 
 	}
	var myi=myobjname.substring(myobjname.length-1); 
 	switch(myact){
 		case 1: 
 			s_c_p[myi]=0; //curpage
 			break; 
 		case 2: 
 			if(s_c_p[myi]>0) 
 				s_c_p[myi]--; 
 			break; 
 		case 3: 
 			if(s_c_p[myi]<s_p_c[myi]-1) 
 				s_c_p[myi]++; 
 			break; 
 		case 4: 
 			s_c_p[myi]=s_p_c[myi]-1; 
 			break;
 		case 5: 
 			s_c_p[myi]=curPP-1;
 			if(s_c_p[myi]<0) 
 				s_c_p[myi]=0;
 			if(s_c_p[myi]>s_p_c[myi]-1) 
 				s_c_p[myi]=s_p_c[myi]-1;
 			break;
 	}
 	var myoldstatus = window.status;
 	window.status="正在从服务器获得数据，请稍候....";
 	/**/
 	self.showModalDialog(sPath+"GetDWData.jsp?dw="+DZ[myi][0][1]+"&pg="+s_c_p[myi]+"&rand="+amarRand(),
 			window.self,"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no"); 
 	/*
 	var sPageURL = sPath+"GetDWData.jsp?dw="+DZ[myi][0][1]+"&pg="+s_c_p[myi];
	var script = $.ajax({url: sPageURL,async: false}).responseText.trim();
	script = replaceAll(replaceAll(script, "<script type=\"text/javascript\">", ""), "</script>", "");
	eval(script);
	*/
 	window.status=myoldstatus; 
 	init(false);
}
//服务器端分页功能
function MR1_s(myobjname,myact,my_sortorder,sort_which,need_change){
	if(!beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)) 
		return;
 	getDWData(myobjname,myact);
 	my_load(2,0,myobjname);
} 
//点击列表页面标题对记录排序
function getDWDataSort(my_sortorder,sort_which,myobjname,need_change){
	if(my_sortorder==1)   
		my_sortorder=0;  //(升)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(降)
	else if(my_sortorder==2)  
		my_sortorder=0;
	var myi=myobjname.substring(myobjname.length-1);
	var myoldstatus = window.status;
	window.status="正在从服务器获得数据，请稍候....";
	/**/
	self.showModalDialog(sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&"+
			"sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder+"&rand="+randomNumber(),
			window.self,
			"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	/*
	var sPageURL = sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder;
	var script = $.ajax({url: sPageURL,async: false}).responseText.trim();
	script = replaceAll(replaceAll(script, "<script type=\"text/javascript\">", ""), "</script>", "");
	eval(script);
	*/
	window.status=myoldstatus;
	init(false);
	needReComputeIndex[myi]=0;
}
// for sort
function my_load_s(my_sortorder,sort_which,myobjname,need_change){
	var my_sortorder_old = my_sortorder;		
	getDWDataSort(my_sortorder,sort_which,myobjname,need_change);
	my_load(my_sortorder_old,sort_which,myobjname,need_change);	  //因为 my_load还会作sort转换
}
//对grid进行页面展示
//for amarchange at grid when rec>100 then release need some mins.
//myiframe0,1
//myact表示第几页
function MR1(myobjname,myact,my_sortorder,sort_which,need_change){
	if(!beforeMR1(myobjname,myact,my_sortorder,sort_which,need_change)) return;
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);//myiframe0之0
	
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_sel_rec[myi]=-1;		
	cur_sel_item[myi]="";		
	
	var curPP=0;
	if(myact==5) curPP=myobj.document.forms[0].elements["txtJump"].value;
	myobj.document.clear();	
	myobj.document.close();
	
	switch(myact) {
		case 1://第一页
			curpage[myi]=0;
			break;
		case 2://上一页
			if(curpage[myi]>0) curpage[myi]--;
			break;
		case 3://下一页
			if(curpage[myi]<pagenum[myi]-1) curpage[myi]++;
			break;
		case 4://最后一页
			curpage[myi]=pagenum[myi]-1;
			break;				
		case 5://在输入框输入的页数
			curpage[myi]=curPP-1;
			if(curpage[myi]<0) curpage[myi]=0;
			if(curpage[myi]>pagenum[myi]-1) curpage[myi]=pagenum[myi]-1;			
			break;				
	}
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HTML>");
	sss[jjj++]=("<HEAD>");

	var hmGdTdContentInput ;
	var hmGdTdContentArea ;
	var hmGdTdContentSelect ;	
	hmGdTdContentInput = hmGdTdContentInput1;
	hmGdTdContentArea = hmGdTdContentArea1;
	hmGdTdContentSelect = hmGdTdContentSelect1;	
	if(arguments.length==5){
		if(need_change==1){
			hmGdTdContentInput = hmGdTdContentInput2;
			hmGdTdContentArea = hmGdTdContentArea2;
			hmGdTdContentSelect = hmGdTdContentSelect2;	
		}
	}
	
	if(DZ[myi][0][2]==0){//ReadOnly 1 只读 0 可写
		hmGdTdContentInput = hmGdTdContentInput2;
		hmGdTdContentArea = hmGdTdContentArea2;
		hmGdTdContentSelect = hmGdTdContentSelect2;	
	}

	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1) 
		sss[jjj++]=("<LINK href='"+sPath+"style_dw.css' rel=stylesheet>");
	else                 
		sss[jjj++]=("<LINK href='"+sPath+"style_ff.css' rel=stylesheet>");
	sss[jjj++]=("</HEAD>");
	sss[jjj++]=("<BODY oncontextmenu='self.event.returnValue=false' "+
			" onmousedown='parent.mE(event, \""+myobj.name+"\");parent.mySelectRow()' "+"" +
			" onKeyDown='parent.kD(event, \""+myobj.name+"\")' "+
			" onKeyUp='parent.kU(event, \""+myobj.name+"\");parent.mySelectRow()'")+
			" onresize='parent.change_height(\""+myobj.name+"\")'>"; 

	if(bNeedCA) 
		sss[jjj++]=(" <object id=doit style='display:none' classid='CLSID:8BE89452-A144-49BC-9643-A3D436D83241' border=0 width=0 height=0></object>  ");
	sss[jjj++]=("<form name='form1' class='gdform' >");
	
	var myS=new Array("","readonly","disabled","readonly"); 
	var myR=DZ[myi][0][2]; 
	var myFS,myHeaderUnit; 
	var myAlign=new Array(""," align=left "," align=center "," align=right ");
	var myAlign2=new Array("","left","center","right");
	
	sss[jjj++]=("<span style='display:none'>");
	sss[jjj++]=("<span style='font-size: 9pt'>");
	sss[jjj++]=("<a href='javascript:parent.MR1(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>首页</a> "+
					" <a href='javascript:parent.MR1(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>前一页</a> "+
					" <a href='javascript:parent.MR1(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>后一页</a> "+
					" <a href='javascript:parent.MR1(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>尾页</a> ");
	sss[jjj++]=("&nbsp;&nbsp;共&nbsp;"+rr_c[myi]+"&nbsp;条记录,共&nbsp;"+pagenum[myi]+"&nbsp;页,当前为第&nbsp;"+(curpage[myi]+1)+"&nbsp;页");
	sss[jjj++]=("</span><br>");
	sss[jjj++]=("<span style='font-size: 9pt'>按&nbsp;");
	for(var i=0;i<f_c[myi];i++) {
		if(DZ[myi][1][i][2]==0) //Visible  0不可见  1 可见
			continue; 
		sss[jjj++]=DZ[myi][1][i][0]+"：<input type=text name=txtField"+i+" style='FONT-SIZE: 9pt;border-style:groove;text-align:center;width:40pt;height:13pt' size=1>";
	}
	sss[jjj++]=("<input type=button name=btnReset  value='重置' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",7,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnSearch value='查找' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",6,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnSave   value='另存' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",8,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnPrint  value='打印' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",9,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("</span><br>");
	sss[jjj++]=("</span>");
	sss[jjj++]=("<div id='tableContainer' class='tableContainer' style='overflow:auto;'>");
	sss[jjj++]=("<table "+hmGDTable +">");
	if(isIEBrowser())
		sss[jjj++]=("<thead class='fixedHeader'>");
	else
		sss[jjj++]=("<TBODY class='scrollContent fixedHeader'>");
	if(pagenum[myi]>1 || s_p_c[myi]>1 )
		sss[jjj++]=("	<tr style='display:BLOCK'> ");
	else
		sss[jjj++]=("	<tr style='display:none'> ");
    sss[jjj++]=(" <td colspan="+(f_c[myi]+1)+" "+hmGdTdPage+" > ");
     //客户端分页
	 if(pagenum[myi]>1 ){
	    sss[jjj++]=("                <img align=absmiddle class=TCTopPageA  title='第一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>");
	    sss[jjj++]=("                <img align=absmiddle class=TCPrevPageA title='前一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>");
		sss[jjj++]=("                &nbsp"+(curpage[myi]+1)+"/"+pagenum[myi]+"&nbsp;("+rr_c[myi]+")&nbsp;");
	    sss[jjj++]=("                <img align=absmiddle class=TCNextPageA title='下一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>");
	    sss[jjj++]=("                <img align=absmiddle class=TCLastPageA title='最后一页' src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>");
		sss[jjj++]=("		     &nbsp;&nbsp;跳至&nbsp;<input type=text name=txtJump class='GdJumpInput' onkeydown='javascript:parent.MRK1(\""+myobjname+"\",5,"+my_sortorder+","+sort_which+")'>&nbsp;页");
	 }else
		 sss[jjj++]=("		     &nbsp;&nbsp;跳至&nbsp;<input type=hidden name=txtJump class='GdJumpInput' onkeydown='javascript:parent.MRK1(\""+myobjname+"\",5,"+my_sortorder+","+sort_which+")'>&nbsp;页");
	//服务器端分页
	if(s_p_c[myi]>1 ){
 		if(pagenum[myi]>1 ){ 
 		    sss[jjj++]=("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); 
 		}
 	    sss[jjj++]=("                <img align=absmiddle class=ServerFirstPage  title='第一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerPrevPage title='前一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>"); 
 		sss[jjj++]=(" &nbsp"+(s_c_p[myi]+1)+"/"+s_p_c[myi]+"&nbsp;("+s_r_c[myi]+")&nbsp;"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerNextPage title='下一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerLastPage title='最后一页(服务器)' src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>"); 
 		sss[jjj++]=("&nbsp;&nbsp;跳至&nbsp;<input type=text name='txtJump_s' style='width=30' class='GdJumpInput' onkeydown='var keynum;if(window.event){keynum=window.event.keyCode;}else if(event.which){keynum=event.which;} if(keynum==13){javascript:parent.MR1_s(\""+myobjname+"\",5,"+my_sortorder+","+sort_which+");}'>&nbsp;页"); 
 	}
    sss[jjj++]=(" </td>");
    sss[jjj++]=("   </tr>	");
    //1、显示表头，点击进行升降序排列获取记录
    sss[jjj++]=("<TR "+hmGDHeaderTr +">");
    if(isIEBrowser())
    	sss[jjj++]=("<TH "+hmGDTdHeader+" style='border-left:0px'>&nbsp;</TH>");
    else
    	sss[jjj++]=("<TH "+hmGDTdHeader+">&nbsp;</TH>");
    
	for(i=0;i<f_c[myi];i++) {
		if(DZ[myi][1][i][2]==0) 
			continue; 
		myHeaderUnit=DZ[myi][1][i][0]+DZ[myi][1][i][17]+sGDTitleSpace;//Header+Unit
		if(DZ[myi][1][i][6]==1) {//Sortable 可排序
			if(sort_which==i) //sort_which 是字段序号 0表示第一个字段以此类推
				sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + " onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+myimgstr+"</TH>");//升降序排列获取记录
			else              
				sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + "  onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+"</TH>");
		}
		else 		          
			sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + "   >"+myHeaderUnit+"</TH>");
	}
	sss[jjj++]=("</TR>");
	if(isIEBrowser()){
		sss[jjj++]=("</thead>");
		sss[jjj++]=("<TBODY class='scrollContent'>");
	}
	var myCale;
	var myShowSelect = "",myShowSelectVisible="";
	var myevent_num=""; 
	//2、展示数据记录
	for(var j=curpage[myi]*pagesize[myi];j<(curpage[myi]+1)*pagesize[myi]&&j<rr_c[myi];j++){
		sss[jjj++]=("<tr height=1");
		if(j==curpage[myi]*pagesize[myi])
			sss[jjj++]=(" id='DWTRDATA'");
		sss[jjj++]=(">");
		sss[jjj++]=("<TD id='R"+j+"FZ' "+ hmGdTdSerial +">"+(j+1)+"</TD>");
		for(i=0;i<f_c[myi];i++){
			if(DZ[myi][1][i][2]==0) 
				continue; 
			myFS = DZ[myi][1][i][11];  
			if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
				str2=myS[myFS];    
			else
				str2=" ";	
			if(DZ[myi][1][i][7]==0) 
				str3=" ";			
			else                    
				str3=" maxlength="+DZ[myi][1][i][7];
			myevent_num=""; 
			if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5)	
				myevent_num="  onblur=parent.myNumberBL(this) onkeyup=parent.myNumberKU(this) onbeforepaste=parent.myNumberBFP(this) "; 
			else 
				myevent_num=" "; 
			str3 = str3+myevent_num; 
			//文本框
			if(myFS==1) {
				if(DZ[myi][1][i][12]==3 && myR==0)
					myCale = " "+hmDate+" onclick='javascript:parent.myShowCalendar(\""+myobj.name+"\",\"R"+j+"F"+i+"\",\"dataTable\","+((j-curpage[myi]*pagesize[myi]+1)*(f_c[myi]+1)+i+1)+");'> ";
				else				
					myCale = " ";
				
				if(DZ[myi][1][i][8]==1) 
					sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" ><input   "+hmGdTdContentInput + " "+str2+" "+DZ[myi][1][i][10]+
						" type=text value='"+amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12])+"' name=R"+j+"F"+i+"  "+str3+" >"+myCale+"</td>";
				else
					sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" ><input   "+hmGdTdContentInput + " "+str2+" "+DZ[myi][1][i][10]+
						" type=text value='"+amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12])+"' name=R"+j+"F"+i+"  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";}>"+myCale+"</td>";
			}
			//Textarea框
			if(myFS==3) 
				sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" >"+
					"<textarea "+hmGdTdContentArea + 
					"  onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") "+
					"  onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+")  "+
					"  type=textfield "+str2+" "+DZ[myi][1][i][10]+" name=R"+j+"F"+i+" >"+DZ[myi][2][my_index[myi][j]][i]+"</textarea></td>";					
			//选择框
			if(myFS==2){
				if(bShowSelectButton)
					myShowSelectVisible="display:visible";
				else
					myShowSelectVisible="display:none";
				myShowSelect = " "+ hmSelectButton +" name=btnR"+j+"F"+i+"   style='"+myShowSelectVisible+"' "+str2+
					" onclick='javascript:parent.myShowSelect(\""+myobj.name+"\",\"R"+j+"F"+i+"\","+j+","+i+ ");' > ";

				sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" >"+
					" <select "+hmGdTdContentSelect + " "+str2+" " +DZ[myi][1][i][10]+" name=R"+j+"F"+i+
					" value='"+DZ[myi][2][my_index[myi][j]][i]+"'    "+
					" onchange='parent.mE(event, \""+myobj.name+"\");parent.myHandleSelectChangeByIndex("+myi+","+j+","+i+");'   >";
				
				for(var k=0;k<DZ[myi][1][i][20].length/2;k++){
					if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
						sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"' selected>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
					else
						sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"'>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
				}

				sss[jjj++] =  "</select>"+myShowSelect+"</td>";
			}
		}
		sss[jjj++]=("</tr>");
	}
	//--------------------------------------------------------------展示数据记录结束	
	if(bShowGridSum){
		sss[jjj++]=("<tr "+ hmGdSumTr +">");
		sss[jjj++]=(" " + hmGdSumTdSerial +" ");		
		for(i=0;i<f_c[myi];i++){
			if(DZ[myi][1][i][2]==0) continue; 
			//2:double 5:long
			if(DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5)
				sss[jjj++] = "<td nowrap "+ hmGdSumTd +" "+myAlign[DZ[myi][1][i][8]]+" > "+amarMoney(getItemTotalByIndex(myi,i),DZ[myi][1][i][12])+"</td>";
			else
				sss[jjj++] = "<td nowrap "+ hmGdSumTd +">&nbsp;</td>";
		}
		sss[jjj++]=("</tr>");
	}
	
	//页尾。。。
	if(pagenum[myi]>1 || s_p_c[myi]>1 )
		sss[jjj++]=("	<tr style='display:BLOCK'> ");
	else
		sss[jjj++]=("	<tr style='display:none'> ");
	
    sss[jjj++]=("          <td colspan="+(f_c[myi]+1)+" "+hmGdTdPage+" > ");

     //客户端分页
	 if(pagenum[myi]>1 ){
	    sss[jjj++]=("                <img align=absmiddle class=TCTopPageA  title='第一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>");
	    sss[jjj++]=("                <img align=absmiddle class=TCPrevPageA title='前一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>");
		sss[jjj++]=("                &nbsp"+(curpage[myi]+1)+"/"+pagenum[myi]+"&nbsp;("+rr_c[myi]+")&nbsp;");
	    sss[jjj++]=("                <img align=absmiddle class=TCNextPageA title='下一页'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>");
	    sss[jjj++]=("                <img align=absmiddle class=TCLastPageA title='最后一页' src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>");
	 }
	 
	//服务器端分页 
 	if(s_p_c[myi]>1 ){
 		if(pagenum[myi]>1 ){ 
 		    sss[jjj++]=("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); 
 		} 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerFirstPage  title='第一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerPrevPage title='前一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>"); 
 		sss[jjj++]=("                &nbsp"+(s_c_p[myi]+1)+"/"+s_p_c[myi]+"&nbsp;("+s_r_c[myi]+")&nbsp;"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerNextPage title='下一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerLastPage title='最后一页(服务器)' src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>"); 
 	}
    sss[jjj++]=("          </td>");
    sss[jjj++]=("   </tr>	");
	sss[jjj++]=("</TBODY>");
	sss[jjj++]=("</TABLE>");
	sss[jjj++]=("</div>");
	sss[jjj++]=("</form>");
	sss[jjj++]=("</BODY>");
	sss[jjj++]=("</HTML>");
	myobj.document.writeln(amarsoft2Html(sss.join('')));		
	myobj.document.close();		
	
	//myobj.document.getElementById('tableContainer').style.height = myobj.document.body.clientHeight - myobj.document.getElementById('tableContainer').offsetTop; 
	//记录当前表格的单元格的样式
	try {
		for(j=0;j<my_index[myi].length;j++){
			if(DZ[myi][0][0]==1) {
				if(my_index[myi][j]==-1) break; 
				for(i=0;i<f_c[myi];i++){
					if(DZ[myi][1][i][2]==1){
						f_css[myi][i]=myobj.document.forms[0].elements["R0F"+i].style.cssText;
					}
				}
				break;
			} else {
				for(i=0;i<f_c[myi];i++)			
					f_css[myi][i]=myobj.document.forms[0].elements["R"+curpage[myi]+"F"+i].style.cssText;
				break;				
			}		
		}	
	} catch(e) { }
	
	window.status="Ready";  
	window.status=myoldstatus;  
	
	//for default:line 1 highlight
	if(rr_c[myi] >0 && bHighlightFirst){
		sR(-1,curpage[myi]*pagesize[myi],myobjname);
		iCurRow=curpage[myi]*pagesize[myi];
	}
	
	myAfterLoadGrid(myi);
	change_height(myobj.name);
}
function MR2_head(myobjname,myact){
	var myi=myobjname.substring(myobjname.length-1);
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HEAD>");
	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1) 
		sss[jjj++]=("<LINK href='"+sPath+"style_dw.css' rel=stylesheet>");
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
	}else               //freeform    
		MR2(myobjname,1);
		
	window.status="Ready";  
	window.status=myoldstatus;  
	if(bShowUnloadMessage)
		document.body.onbeforeunload=closeCheck;//(myobjname);
}
//设置每页多少条记录
function setPageSize(i,iSize){
	if(!beforeSetPageSize(i,iSize)) return;
	pagesize[i]=iSize;
	pagenum[i]=Math.ceil(rr_c[i]/pagesize[i]);
}