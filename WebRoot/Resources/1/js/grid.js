//grid变量
var hmGDTable = " /**hmGDTable*/ style='border-collapse:collapse;'";//grid table
var hmGdTdPage = " /**hmGdTdPage*/ class='GdTdPage'";//换页面操作行
var hmGDHeaderTr = " /**hmGDHeaderTr*/ style='height:20'";//标题行background-color:green;
var hmGDTdHeader = " /**hmGDTdHeader*/ nowrap class='GDTdHeader' ";
var hmGDTdSerialWidth = "width=20";//行号宽度
//var hmGdTdSerial = " /**hmGdTdSerial*/ style='cursor:pointer;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#999999 noWrap align=middle valign=top width=14  class='TCSelImageUnselected' ";
var hmGdTdSerial = " /**hmGdTdSerial*/ style='cursor:pointer;font-size: 9pt;color:black;align:absmiddle;valign:top;padding-left:4px;padding-right:4px;' bgcolor=#ECECEC  align=center valign=top " + hmGDTdSerialWidth+ "  ";//列宽度

var hmGdSumTr = "";
var hmGdSumTdSerial = " <TD nowrap id='T0' style='cursor:pointer;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#EEE1D2 align=center valign=top  >总计</TD> ";
var hmGdSumTd = " style='font-family:宋体,arial,sans-serif;font-size: 9pt ' ";

var hmGdTdContent = " nowrap bgcolor=#FEFEFE";
var hmGdTdContentInput1 = " class='GDTdContentInput' ";
var hmGdTdContentArea1 = " class='hmGdTdContentArea' ";
var hmGdTdContentSelect1 = " class='GdTdContentSelect' ";
var hmGdTdContentInput2 =  " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentInput1 ;
var hmGdTdContentArea2 =   " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentArea1;
var hmGdTdContentSelect2 = " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentSelect1;
if(navigator.appName != "Microsoft Internet Explorer"){
	hmFFContentInput = " class='fftdinput' ";
	hmFFContentArea = " class='fftdarea' ";
	hmFFContentSelect = " class='fftdselect' " ;
	hmGdTdContentInput2 =  hmGdTdContentInput1 ;
	hmGdTdContentArea2 =   hmGdTdContentArea1;
	hmGdTdContentSelect2 = hmGdTdContentSelect1;
}
////////////////////////////////////////排序功能
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
//////////////////////////////分页功能
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
//点击排序功能
function my_load_s(my_sortorder,sort_which,myobjname,need_change){
	var my_sortorder_old = my_sortorder;		
	getDWDataSort(my_sortorder,sort_which,myobjname,need_change);
	my_load(my_sortorder_old,sort_which,myobjname,need_change);	  //因为 my_load还会作sort转换
}
function beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change){
	return true;
}
// MR1_s是服务器端分页功能，进行计算相应页面数据
function MR1_s(myobjname,myact,my_sortorder,sort_which,need_change){
	if(!beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)) 
		return;
 	getDWData(myobjname,myact);
 	my_load(2,0,myobjname);
} 
function beforeMyLastCB(myframename,curItemName){
	return true;
}
function myLastCB(myframename,curItemName){
	if(!beforeMyLastCB(myframename,curItemName)) return;
	if(myframename=="") return;
	if(curItemName=="") return;
	
	var myi,objp;
	var iBegin,iEnd,iField,iRec;
	myi=myframename.substring(myframename.length-1);
	objp = window.frames[myframename];
	last_sel_item[myi]=cur_sel_item[myi];//形式如：R0F0 第一行第一个字段
	cur_sel_item[myi]=curItemName;
		
	if(last_sel_item[myi]!=""){
		iBegin=last_sel_item[myi].indexOf("R");
		iEnd=last_sel_item[myi].indexOf("F");
		if(iBegin!=-1&&iEnd!=-1) {
			iRec=parseInt(last_sel_item[myi].substring(iBegin+1,iEnd));
			iField=parseInt(last_sel_item[myi].substring(iEnd+1));
			if(("HXD"+amarValue(objp.document.forms[0].elements[last_sel_item[myi]].value,DZ[myi][1][iField][12]))!=("HXD"+DZ[myi][2][my_index[myi][iRec]][iField])) 
				hC(objp.document.forms[0].elements[last_sel_item[myi]],myframename);
			if(cur_sel_item[myi]!=last_sel_item[myi])
				vI(objp.document.forms[0].elements[last_sel_item[myi]],myframename);
		}
	}
}
function beforeMRK1(myobjname,myact,my_sortorder,sort_which){
	return true;
}
//客户端 跳至第几页处理函数
function MRK1(myobjname,myact,my_sortorder,sort_which){
	if(!beforeMRK1(myobjname,myact,my_sortorder,sort_which)) return;
	
	if(myact==6) {
		var myobj=window.frames[myobjname];
		var myi=myobj.name.substring(myobj.name.length-1);
		for(var i=0;i<f_c[myi];i++) {
			if(DZ[myi][1][i][2]==0) continue; 
			if(myobj.document.forms[0].elements["txtField"+i].value!=""){
				iRec = getRecNum(myi,i,myobj.document.forms[0].elements["txtField"+i].value);
				if(iRec!=-1){
					myobj.document.forms[0].elements["txtJump"].value=parseInt(iRec/pagesize[myi])+1;
					MR1(myobjname,5,my_sortorder,sort_which);
					sR(cur_sel_rec[myi],iRec,myobjname);
					return;
				}
			}
		}	
		alert("无匹配记录！");
		return;
	}
	if(myact==7) {
		var myobj=window.frames[myobjname];
		var myi=myobj.name.substring(myobj.name.length-1);
		for(i=0;i<f_c[myi];i++) {
			if(DZ[myi][1][i][2]==0) continue; 
			myobj.document.forms[0].elements["txtField"+i].value="";
		}
		return;
	}
	
	if(myact==8) {
		alert("save");
		return;
	}
	
	if(myact==9) {
		alert("print");
		return;
	}
	
   	if(window.frames[myobjname].event.keyCode==13) {   
		if(isNaN(window.frames[myobjname].document.forms[0].elements["txtJump"].value)) 
			alert("输入内容必须为数字！");
		else
			MR1(myobjname,myact,my_sortorder,sort_which);
	}
}
function beforeMouseDown(myiframe){
	if(cur_frame=="myform999")
		cur_frame=myiframe;
		
	return true;
}
//鼠标点击事件
function mE(e, myframename){
	 try{
	 	if(!beforeMouseDown(myframename)) 
	 		return;
	 	if(myframename==""){
			if(cur_frame!="") {
				last_frame=cur_frame;
				cur_frame="";
				myLastCB(last_frame,"");
			}
			return;
		}	
		
		if(cur_frame=="") 
			cur_frame=myframename;
		
		var curItemName0 = cur_sel_item[cur_frame.substring(cur_frame.length-1)];
		var iBegin0,iEnd0,iField0,iRec0,myi0,obj0;
		myi0 = myframename.substring(myframename.length-1);
		obj0 = window.frames[myframename].document.forms[0].elements[curItemName0];
		iBegin0=curItemName0.indexOf("R");
		if(iBegin0!=-1 ) {
			iEnd0=curItemName0.indexOf("F");
			iRec0=parseInt(curItemName0.substring(iBegin0+1,iEnd0));
			iField0=parseInt(curItemName0.substring(iEnd0+1));
			if(obj0.onchange!=null && ("HXD"+amarValue(obj0.value,DZ[myi0][1][iField0][12])) !=("HXD"+DZ[myi0][2][my_index[myi0][iRec0]][iField0]))   
			{
				hC(obj0,myframename);
				DZ[myi0][2][my_index[myi0][iRec0]][iField0] = real2Amarsoft(amarValue(obj0.value,DZ[myi0][1][iField0][12]));

				try {
					obj0.amar_onchange();
				} catch(e) {  }
			}
		}
		var myi,objp,obj,curItemName;
		var iBegin,iEnd,iField,iRec,sName;
		myi=myframename.substring(myframename.length-1);
		objp = window.frames[myframename];
		e = e || objp.event;
		obj = e.srcElement||e.target;
		
		if( obj.tagName=="BODY" || obj.tagName=="TD" || (obj.tagName=="A" && obj.href!=null) || (obj.onclick!=null) ) 	 	
		{
			myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
			return;
		}
		if(typeof(obj)!='undefined' && obj.name!='undefined' && obj.name!=null && obj.name!="") 
			curItemName=obj.name;
		else
			curItemName="";	
		
		if(obj.name=='txtJump') 
			return; 
		
		if(myframename!=cur_frame) {
			last_frame=cur_frame;
			cur_frame=myframename;
			myLastCB(last_frame,"");
		}else{
			myLastCB(myframename,curItemName);
		}
		if(curItemName!=""){//选中的input name 如R0F0
			if((iBegin=curItemName.indexOf("img"))!=-1) {
				iRec=parseInt(curItemName.substring(iBegin+3));
				sR(cur_sel_rec[myi],iRec,myframename);
				for(var i=0;i<f_c[myi];i++){
					if(DZ[myi][1][i][2]==1) break; 			
					sName="R"+iRec+"F"+i;
					try {
						if(!objp.document.forms[0].elements[sName].disabled) 
							objp.document.forms[0].elements[sName].focus();
			  		} catch(e) { }
				} 
			}else {
				iBegin=curItemName.indexOf("R");
				iEnd=curItemName.indexOf("F");
				iRec=parseInt(curItemName.substring(iBegin+1,iEnd));
				iField=parseInt(curItemName.substring(iEnd+1));
				iCurRow=iRec; iCurCol=iField;
				if(iBegin!=-1) {
					sR(cur_sel_rec[myi],iRec,myframename);
					cur_sel_item[myi]=curItemName;
			  	}
			}
		}else {
			if(cur_sel_rec[myi]!=-1) {//行号 如2是第三行
				for(i=0;i<f_c[myi];i++) {
					if(DZ[myi][1][i][2]==1) //visible 1 可见 0 不可见
						break; 	
					sName="R"+cur_sel_rec[myi]+"F"+i;
					try {
						if(!objp.document.forms[0].elements[sName].disabled && (obj.parentNode.tagName.toUpperCase()!='SELECT')) 
							objp.document.forms[0].elements[sName].focus();
			  		} catch(e) { }
				}
	  		}
		}
		doMouseDown(myframename);
		afterMouseDown(myframename);
	  } catch(e) {	
		alert(e.name+" "+e.number+" :"+e.message); 
	  } 	
	}
function doMouseDown(myiframe){ }
function afterMouseDown(myiframe){ }
function beforeMR1(myobjname,myact,my_sortorder,sort_which,need_change){
	return true;
}
//////////////////////////////////////对grid进行页面展示 my_load(2,0,'myiframe0')来引用
//for amarchange at grid when rec>100 then release need some mins.
//myiframe0,1
//myact表示第几页----MR1是客户端分页即js进行计算相应页面数据
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
			if(curpage[myi]>pagenum[myi]-1) 
				curpage[myi]=pagenum[myi]-1;			
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
	if(DZ[myi][0][0]==1) //grid or freeform
		sss[jjj++]=("<LINK href='"+sPath+"style_gd.css' rel=stylesheet>");
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
	sss[jjj++]=("<form name='form1' class='gdform' >");//gdform 根本没有找到
	
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
	sss[jjj++]=("<div id='tableContainer' class='tableContainer'>");
	sss[jjj++]=("<table "+hmGDTable +">");
	///////////////////////标题
	if(isIEBrowser())
		sss[jjj++]=("<thead class='fixedHeader'>");//IE可以固定标题头部哦
	else
		sss[jjj++]=("<TBODY class='scrollContent fixedHeader'>");
	//有页数才显示第一页 前一页等信息
	if(pagenum[myi]>1 || s_p_c[myi]>1 )
		sss[jjj++]=("	<tr style='display:BLOCK;'> ");
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
	 }
	//服务器端分页
	if(s_p_c[myi]>1 ){
 		if(pagenum[myi]>1 ){ 
 		    sss[jjj++]=("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); 
 		}
 	    sss[jjj++]=("                <img align=absmiddle class=ServerFirstPage  title='第一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerPrevPage title='前一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>"); 
 		sss[jjj++]=(" 				 &nbsp"+(s_c_p[myi]+1)+"/"+s_p_c[myi]+"&nbsp;("+s_r_c[myi]+")&nbsp;"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerNextPage title='下一页(服务器)'   src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>"); 
 	    sss[jjj++]=("                <img align=absmiddle class=ServerLastPage title='最后一页(服务器)' src="+sWebRootPath+"/Resources/1/Support/1x1.gif width=1 height=1 onclick='javascript:parent.MR1_s(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>"); 
 		sss[jjj++]=("&nbsp;&nbsp;跳至&nbsp;<input type=text name='txtJump_s' style='width=30' class='GdJumpInput' onkeydown='var keynum;if(window.event){keynum=window.event.keyCode;}else if(event.which){keynum=event.which;} if(keynum==13){javascript:parent.MR1_s(\""+myobjname+"\",5,"+my_sortorder+","+sort_which+");}'>&nbsp;页"); 
 	}
    sss[jjj++]=(" </td>");
    sss[jjj++]=("</tr>	");
    //记录序号的标题头
    //1、显示表头，点击进行升降序排列获取记录
    sss[jjj++]=("<tr "+hmGDHeaderTr +">");
    if(isIEBrowser()){
    	sss[jjj++]=("<TH "+hmGDTdHeader+" style='border-left:0px;'>&nbsp;</TH>");
	}else{
    	sss[jjj++]=("<TH "+hmGDTdHeader+">&nbsp;</TH>");
	}
    //1、展示标题
	for(i=0;i<f_c[myi];i++){//f_c是字段数
		if(DZ[myi][1][i][2]==0) //visible
			continue; 
		myHeaderUnit=DZ[myi][1][i][0]+DZ[myi][1][i][17]+sGDTitleSpace;//Header+Unit
		if(DZ[myi][1][i][6]==1) {//Sortable 可排序
			if(sort_which==i){ //sort_which 表示以第几个字段来进行排序，字段序号 0表示第一个字段以此类推
				sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + " onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+myimgstr+"</TH>");//升降序排列获取记录
			}else{              
				sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + "  onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+"</TH>");
			}
		}else{
			sss[jjj++]=("<TH "+hmGDTdHeader+" " + myAlign[DZ[myi][1][i][8]] + "   >"+myHeaderUnit+"</TH>");
		} 		          
	}
	sss[jjj++]=("</tr>");
	if(isIEBrowser()){
		sss[jjj++]=("</thead>");
		sss[jjj++]=("<TBODY class='scrollContent'>");
	}
	//////////////////////////////////////////////////标题结束
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
	//加入超时控制，防止闪屏
	setTimeout(function(){change_height(myobj.name);},1);
    //setTimeout("change_height("+myobj.name+")", 1); //"change_height("+myobj.name+")"=function(){change_height(myobj.name)}
}
//below can modify in jsp
function myAfterLoadGrid(iDW){
	setColor(iDW,sEvenColor);
	//Add you code
}
//对所有行数据进行奇数行一个底色，偶数行一个底色
function setColor(iDW,sColor){
 	var myDW,myColor; 
 	if(iDW==null)  
 		myDW = 0; 
 	else 
 		myDW = parseInt(iDW,10); 
 	 
 	if(sColor==null)  
 		myColor = sEvenColor; 
 	else 
 		myColor = sColor;	 
 		 
 	iCurRow = getRow(myDW); 
 	var i=0; 
 	for(i=curpage[myDW]*pagesize[myDW];i<(curpage[myDW]+1)*pagesize[myDW]&&i<rr_c[myDW];i++){ 
 		if(i==iCurRow) 
 			continue; 
 		if (i%2==1) {
 			for(var j=0;j<f_c[myDW];j++) 
 				if(DZ[myDW][1][j][2]!=0) 
 					getASObjectByIndex(myDW,i,j).style.cssText = f_css[myDW][j]+myColor; 
 		} 
 	} 
 	for(i=curpage[myDW]*pagesize[myDW];i<(curpage[myDW]+1)*pagesize[myDW]&&i<rr_c[myDW];i++) 
		for(var j=0;j<f_c[myDW];j++)
			if(DZ[myDW][1][j][2]!=0)
				getASObjectByIndex(myDW,i,j).parentNode.style.backgroundColor = getASObjectByIndex(myDW,i,j).style.backgroundColor;
 	
}
function change_height(framename){
	var myobj = frames[framename];
	//alert(myobj.document.body.style.paddingLeft);
	//alert("myobj.document.body.offsetWidth="+myobj.document.body.offsetWidth+",myobj.document.getElementById('tableContainer').offsetLeft="+myobj.document.getElementById('tableContainer').offsetLeft);
	myobj.document.getElementById('tableContainer').style.width = myobj.document.body.offsetWidth-15;//- myobj.document.getElementById('tableContainer').offsetLeft*2;
	myobj.document.getElementById('tableContainer').style.height = myobj.document.body.clientHeight - myobj.document.getElementById('tableContainer').offsetTop - 15;
	//alert(myobj.document.body.clientHeight+"@"+myobj.document.getElementById('tableContainer').offsetTop );
}
function beforeSetPageSize(i,iSize){
	return true;
}
//设置每页多少条记录
function setPageSize(i,iSize){
	if(!beforeSetPageSize(i,iSize)) return;
	pagesize[i]=iSize;
	pagenum[i]=Math.ceil(rr_c[i]/pagesize[i]);
}