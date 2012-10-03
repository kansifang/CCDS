//Copyright (C) 1998-2003 Amarsoft Corporation
//Writed By HouXD,ZhuRC,HuBy
//All rights reserved.

//var sPath = "/amarbank6/Resources/1/Support/";
//begin 关于格式化调查报告提示保存与自动保存
var bEditHtml = false; 
var bEditHtmlChange = false;
var bEditHtmlAutoSave = true;
//end
var sPath = sResourcesPath+"/Support/";
var DZ = new Array();
var f_c=new Array();  
var r_c=new Array(); 
var rr_c=new Array(); 
var f_css = new Array(); 
var pagenum = new Array();  
var pagesize = new Array(); 
var pageone = new Array(); 
var curpage = new Array();  
var my_change = new Array();           
var my_changedoldvalues = new Array(); 
var my_attribute =  new Array();       
var my_sel_gif = new Array("sel_normal.gif","sel_change.gif","sel_add.gif","sel_delete.gif","sel_adddelete.gif","sel_deletechange.gif","sel_adddeletechange.gif");
var my_notnull = new Array();          
var my_notnull_temp = new Array();
var last_sel_rec = new Array();
var cur_sel_rec = new Array();
var last_sel_item = new Array();
var cur_sel_item = new Array();
var last_frame="";
var cur_frame="";
var needReComputeIndex = new Array();
var my_index = new Array(); 
var cur_sortfield = new Array();
var cur_sortorder = new Array();
var sort_begin = new Array();
var sort_end = new Array();
var myimgstr="";
var iCurRow=-1,iCurCol=0;
var sEvenColor = ";background-color: #EEEEEE";
var sGDTitleSpace = "&nbsp;";	//add in 2004/03/04
var bNotCheckModified = false;
//var sDateReadonlyColor = " readonly style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(日期型字段只能选择)
var sDateReadonlyColor = " style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(日期型字段既可选择又可输入)

var s_r_c=new Array(); //server row count,add by hxd in 2004/11/08
var s_p_s=new Array(); 
var s_p_c=new Array();
var s_c_p=new Array(); 
var bTextareaShowLimit = true; //add by hxd in 2005/01/07
var sSaveReturn = "";
var bSavePrompt = true;
var bHighlight = true;
var bNeedCA = false;  
var sContentType = "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">";
var bShowSelectButton = false;
var keyF7=118;
var sUnloadMessage = "\n\r当前页面内容已经被修改，\n\r按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据，\n\r按“确定”则不保存修改过的数据并且离开当前页．";
var bShowUnloadMessage=false;  //true for szcb_bank,ceb 此参数已废弃，请不要修改。2005.01.10 byhu
var bCheckBeforeUnload=false;  //替代 bShowUnloadMessage
var bHighlightFirst = false;
var bDoUnloadOne = true;  //for only one 
var bDoUnload = new Array();
var bShowGridSum = false;
var sSignature = "739D91A4A3A096A58493A4918B9AA097A0B776A795A0AAA6AC5F6261666976A798A2A3A0A6A57698A29185999C95A9AE759E94B2DAE3E26168666E6C719D92";

//var sHighlightColor="background-color:#FFF09E;color:#FF0000;background-image:url("+sPath+"table/dim_scrollup.gif)";
var sHighlightColor="background-color:#AEB9E6;color:#000000;)"; 	//加亮颜色

var sFFormInputStyle   = "font-family:宋体,arial,sans-serif;font-size: 10pt";
var sFFormCaptionStyle = "font-family:宋体,arial,sans-serif;font-size: 10pt;align=center";
var sGridInputStyle    = " ";
var sGridHeaderStyle   = " ";	//color:blue;
var REM_sGridHeaderStyle   = "font-family:宋体,arial,sans-serif;font-size: 10pt; background-color:#B4B4B4;cursor:hand;text-decoration: none ";	//color:blue;

//var sHeaderStyle = "background-color:#B4B4B4;cursor:hand;font-family:宋体;font-size: 10pt; text-decoration: none";	
var sHeaderStyle = " ";	
//var sTDStyle = " font-family:宋体; font-size: 10pt; text-decoration: none";	
var sTDStyle = " ";	
var sSumTDStyle = " background-color:#CCCCCC;font-family:宋体;font-size: 10pt; text-decoration: none";	

var hmRPTable = " align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF ";
var hmRPPageTr = " ";
var hmRPPageTd = " style='font-family:宋体,arial,sans-serif;font-size:9pt;	font-weight: normal;color: #55554B;	padding-left:  5px;padding-right:5px;padding-top:2px;padding-bottom:2px;background-color: #CDCDCD;valign:top;' ";
var hmRPHeaderTr = "bgColor=#cccccc";
var hmRPHeaderTd       = " nowrap align=middle style='background-color:#B4B4B4;cursor:hand;font-family:宋体;font-size: 10pt; text-decoration: none' ";
var hmRPHeaderTdSerial = " nowrap align=middle style='background-color:#B4B4B4;cursor:hand;font-family:宋体;font-size: 10pt; text-decoration: none' ";
var hmRPGroupSumTr = new Array();
var hmRPGroupSumTdSerial = new Array();
var hmRPGroupSumTd = new Array();
var it1=0,itColor=new Array("#FFCCAA","#EE8844","#DD2299","#CC00CC","#BBBBBB","#AAAAAA","#999999","#888888","#777777","#666666","#555555","#444444","#333333","#222222","#111111","#000000");
for(it1=0;it1<16;it1++)
{
	hmRPGroupSumTr[it1] = " ";
	hmRPGroupSumTdSerial[it1] = " nowrap align=middle style='background-color:#E4E4E4;font-family:宋体;font-size: 10pt; text-decoration: none ' ";
	hmRPGroupSumTd[it1]       = " nowrap              style='background-color:"+itColor[it1]+";font-family:宋体;font-size: 10pt; text-decoration: none ' ";
}
var hmRPContentTr = " ";
var hmRPContentTDSerial = " nowrap align=middle bgcolor=#E4E4E4 style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";
var hmRPContentTD       = " nowrap              bgcolor=#ffffff style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";
var hmRPPageSumTr = " ";
var hmRPPageSumTdSerial  = " nowrap align=middle style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";
var hmRPPageSumTd        = " nowrap              style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";
var hmRPTotalSumTr = " ";
var hmRPTotalSumTdSerial = " nowrap align=middle style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";
var hmRPTotalSumTd       = " nowrap              style='font-family:宋体; font-size: 10pt; text-decoration: none ' ";


var hmDate =         "<input type=button class='inputDate' value='...'  ";
var hmSelectButton = "<input type=button class='inputDate' value='...'  ";

var hmFFTable = " class='fftable' border=0 cellspacing=0 cellpadding=4 bordercolordark=#EEEEEE bordercolorlight=#CCCCCC";
var hmFFTr = " class='fftr1' ";
var hmFFTextAreaCaptionTD = " class='fftdheadTextArea' nowrap ";
var hmFFCaptionTD = " class='fftdhead' nowrap ";
var hmFFContentTD = " class='FFContentTD' nowrap ";
var hmFFContentInput = " class='fftdinput' style='behavior:url("+sPath+"amarsoft_onchange.sct);border-style:groove;' ";
var hmFFContentArea = " class='fftdarea' style='behavior:url("+sPath+"amarsoft_onchange.sct)' ";
var hmFFContentSelect = " class='fftdselect' style='behavior:url("+sPath+"amarsoft_onchange.sct)' " ;
var hmFFBlankTD = " class='FFContentTD' nowrap ";

var hmGDTable = " /**hmGDTable*/ align=left border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF ";
var hmGDHeaderTr = " /**hmGDHeaderTr*/ bgColor=#cccccc height=20 style='padding-left:2px;padding-right:2px;'";
var hmGdTdPage = " /**hmGdTdPage*/ class='GdTdPage'";
var hmGDTdHeader = " /**hmGDTdHeader*/ nowrap class='GDTdHeader' "
//var hmGdTdSerial = " /**hmGdTdSerial*/ style='cursor:hand;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#999999 noWrap align=middle valign=top width=14  class='TCSelImageUnselected' ";
var hmGdTdSerial = " /**hmGdTdSerial*/ style='cursor:hand;font-size: 9pt;color:black;align:absmiddle;valign:top;padding-left:4px;padding-right:4px;' bgcolor=#ECECEC  align=center valign=top width=20   ";

var hmGdSumTr = "";
var hmGdSumTdSerial = " <TD nowrap id='T0' style='cursor:hand;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#EEE1D2 align=center valign=top  >总计</TD> ";
var hmGdSumTd = " style='font-family:宋体,arial,sans-serif;font-size: 9pt ' ";

var sMandatorySignal = " &nbsp;<font color=red>*</font> ";
var hmGdTdContent = " nowrap bgcolor=#FEFEFE";

var hmGdTdContentInput1 = " class='GDTdContentInput' ";
var hmGdTdContentArea1 = " class='hmGdTdContentArea' ";
var hmGdTdContentSelect1 = " class='GdTdContentSelect' ";

var hmGdTdContentInput2 =  " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentInput1 ;
var hmGdTdContentArea2 =   " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentArea1;
var hmGdTdContentSelect2 = " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentSelect1;

// add by byhu 2005.01.11 datawindow 排布数组
var arrangements = new Array();
var harbors = new Array();
var bFreeFormMultiCol = false;

//add in 2008/11/02 for cebploan
var bShowCheckRequiredAlert = true;	//离开焦点时是否检查必需项
var bShowCheckTypeAlert = true;		//离开焦点时是否检查数据类型


function f_myPad0(myi)
{
	var f_mys0 = "";
	if(myi<10)
		f_mys0 = "0"+myi.toString(10);
	else
		f_mys0 = myi.toString(10);
	return f_mys0;
}
function drawHarbor(myobjname,myact,iDW,iRow_now)
{
	var dh_sss = new Array();
	var dh_jjj = 0;
	var tmpDocks = harbors[iDW][2];
	var docks = new Array();
	for(iDock=0;iDock<harbors[iDW][2].length;iDock++){
		//boat = getDWControlHtml(myobjname,myact,harbors[iDW][2][iDock][0]);
		boat = arrangeBoats(arrangements,harbors[iDW][2][iDock][0],myobjname,myact,iDW,harbors[iDW][2][iDock][2],harbors[iDW][2][iDock][4],harbors[iDW][2][iDock][5],harbors[iDW][2][iDock][6],harbors[iDW][2][iDock][7],iRow_now);
		docks[iDock] = new Array(harbors[iDW][2][iDock][0],boat);
	}
	//modify by hxd in 2005/07/08 for '
	//return macroReplace(docks,harbors[iDW][1][2],"${DOCK:","}",0,1);
	return macroReplace(docks,amarsoft2Real(harbors[iDW][1][2]),"${DOCK:","}",0,1);
}

/**自动排列输入项*/
function arrangeBoats(myarrangements,myDockID,myobjname,myact,iDW,width,totalColumns,defaultColspan,defaultColspanForLongType,defaultPosition,iRow_now){
	if(!bFreeFormMultiCol) defaultColspan = defaultColspanForLongType;
	
	var sss=new Array(),jjj=0;

	//modify in 2008/04/10 for bccb dw
	//sss[jjj++]="<table cellspacing=0 cellpadding=4 border=0 width='"+width+"'>"+"\r";
	sss[jjj++]="<table cellspacing=0 cellpadding=1 border=0 width='"+width+"'>"+"\r";

	var remainColumns = 0;
	
	//byhu 20050721
	//remainColumns = totalColumns;

	var colwidth;
	var a = parseInt(width.replace("%",""),10);
	
	if(a<=100){
		colwidth = (a/totalColumns);
		colwidth = colwidth +"%";
	}else{
		colwidth = a/totalColumns;	
	}
	 
	sss[jjj++]="<tr>";
	for(var j=0; j<totalColumns; j++){
		sss[jjj++]="<td width='"+colwidth+"'></td>";
	}
	sss[jjj++]="</tr>";
	
	for(var j=0; j<myarrangements[iDW].length; j++){
		if(DZ[iDW][1][j][2]==0) continue;
		//取得colspan
		if(myarrangements[iDW][j][1]!=myDockID) continue;
		temp=myarrangements[iDW][j][2];
		if(temp==""){
			if(DZ[iDW][1][j][11]==3)
				colspan = defaultColspanForLongType;
			//else if(DZ[iDW][1][j][10].indexOf("width:")>=0) //modify in 2008/08/14 for date_type, add ' style={background:#efefef;color:black} style={width:70px}  '
			else if(DZ[iDW][1][j][10].indexOf("width:")>=0 && DZ[iDW][1][j][12]!=3) //modify in 2008/08/14 
				colspan = defaultColspanForLongType;
			else if(DZ[iDW][1][j][17].length>=6 && DZ[iDW][1][j][17].substring(DZ[iDW][1][j][17].length-1)!=">")
			{
				colspan = defaultColspanForLongType;
				//alert(DZ[iDW][1][j][0]); //add in 2008/08/14
			}
			else
				colspan = defaultColspan;
		}else{
			colspan = temp;
		}

		//取得position
		temp=myarrangements[iDW][j][3];
		if(temp==""){
			position = defaultPosition;
		}else{
			position = temp;
		}

		//显示<tr>
		if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
			if (remainColumns > 0){
				sss[jjj++]="<td colspan='"+remainColumns+"' "+hmFFBlankTD+">&nbsp;</td></tr>"+"\r";
			}
			remainColumns = totalColumns;
			sss[jjj++]="<tr height='8'></tr><tr>";
		}
		
		//显示内容
		sss[jjj++]=drawInputControl(myarrangements,harbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,j,iRow_now);		
		remainColumns = remainColumns -colspan;


		//显示</tr>
		
		if (position=="FULLROW" || j==(myarrangements[iDW].length-1)){
			if (remainColumns > 0){
				sss[jjj++]="<td colspan='"+remainColumns+"'  "+hmFFBlankTD+" >&nbsp;</td></tr>"+"\r";
			}
			remainColumns=0;
		}
	}
	sss[jjj++]="</table>";
	return(sss.join(''));
		
}

/*设置字段的标题*/	
function setItemCaption(iDW,iRow,iCol,sValue) 
{ 
	try {  
		var mysMandatorySignal="";
		if(my_notnull[iDW][iCol]==1) mysMandatorySignal=sMandatorySignal;	

		var obj; 
		obj = document.frames("myiframe"+iDW).document.getElementById("tdR"+iRow+"F"+iCol);

		if(DZ[iDW][1][iCol][11]==3)    
		{ 
			var sTextareaShowLimit="";
			//如果设置了字数限制，并且指定过要显示“(限个汉字)”
			if(bTextareaShowLimit && DZ[iDW][1][iCol][7]>0) sTextareaShowLimit = "(限" + (DZ[iDW][1][iCol][7]/2) +"个汉字)";
			obj.innerHTML = sValue + sTextareaShowLimit +mysMandatorySignal;
		} 
		else    
			obj.innerHTML = sValue + mysMandatorySignal;
	} catch(e) { var a=1; }   
} 

/**显示一个控件*/
function drawInputControl(myarrangement,myharbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,iCol,iRow_now){
	sColspan = myarrangement[iDW][iCol][2];
	//var iColspan=12;
	if(sColspan=="")
	{		
		if(DZ[iDW][1][iCol][11]==3){
			iColspan = defaultColspanForLongType;
		//}else if(DZ[iDW][1][iCol][10].indexOf("width:")>=0){ //modify in 2008/08/14 for date_type, add ' style={background:#efefef;color:black} style={width:70px}  '
		}else if(DZ[iDW][1][iCol][10].indexOf("width:")>=0 && DZ[iDW][1][iCol][12]!=3 ){ //modify in 2008/08/14 
			iColspan = defaultColspanForLongType;
		}else if(DZ[iDW][1][iCol][17].length>=6 && DZ[iDW][1][iCol][17].substring(DZ[iDW][1][iCol][17].length-1)!=">"){
			//unit有中文并且过长
			iColspan = defaultColspanForLongType;
			//alert(DZ[iDW][1][iCol][0]); //add in 2008/08/14
		}else{
			iColspan = defaultColspan;
		}
	}else{
		iColspan = parseInt(sColspan,10);
	}
	var colspan=iColspan;

	var myobj=document.frames(myobjname);
	var myi=myobj.name.substring(myobj.name.length-1);

	
	var mysss;
	var sss=new Array(),jjj=0;
	
	//modify by hxd in 2008/04/10,2007/12/17 for citibank
	//var myS=new Array("","readonly","disabled","readonly"); 
	var myS=new Array("","readonly","disabled","readonly","readonly","disabled",
						"disabled","readonly","readonly","readonly","readonly",
						"readonly","readonly","readonly","readonly","readonly",
						"readonly","readonly","readonly","readonly","readonly"); 	
	
	var myR=DZ[myi][0][2]; 
	var myFR,myFS; 
	var myAlign=new Array(""," align=left "," align=center "," align=right ");
	var myAlign2=new Array("","left","center","right");
		
	pagesize[myi]=1;  
	var myShowSelect = "",myShowSelectVisible="";
	var myevent_num=""; 
	var j=iRow_now;
	var myi = iDW;
	var i=iCol;


	mysss = DZ[myi][1][i][17];
	var mysMandatorySignal="";
	if(my_notnull[myi][i]==1) mysMandatorySignal=sMandatorySignal;	
	
	try {    
	if(DZ[myi][1][i][11]==3)    
	{ 
		var sTextareaShowLimit="";

		//如果设置了字数限制，并且指定过要显示“(限个汉字)”
		if(bTextareaShowLimit && DZ[myi][1][i][7]>0) sTextareaShowLimit = "(限" + (DZ[myi][1][i][7]/2) +"个汉字)";
		sss[jjj++]=("<td id=tdR"+j+"F"+i+" "+hmFFTextAreaCaptionTD+" >"+DZ[myi][1][i][0]+ sTextareaShowLimit +mysMandatorySignal+" </td>");
	} 
	else    
		sss[jjj++]=("<td id=tdR"+j+"F"+i+" "+hmFFCaptionTD+" >"+DZ[myi][1][i][0]+mysMandatorySignal+"</td>");
	} catch(e) { var a=1; }   
	
	myFS = DZ[myi][1][i][11];  
	sValue = amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12]); 	
	if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
		str2=myS[myFS];    
	else
		str2=" ";	
	if(DZ[myi][1][i][7]==0) str3=" ";			
	else                    str3=" maxlength="+DZ[myi][1][i][7];
	myevent_num=""; 
	
	//modify in 2008/04/10 for bccb number control
	//if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5)	
	if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5 || DZ[myi][1][i][12]>10)	
		myevent_num="  onblur=parent.myNumberBL(this) onkeyup=parent.myNumberKU(this) onbeforepaste=parent.myNumberBFP(this) "; 
	else 
	{ 
		myevent_num=" "; 
		//add in 2007/05/22,2008/04/10
		if(DZ[myi][1][i][7]>0)
			myevent_num = " onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+") ";
	}

	str3 = str3+myevent_num; 
	if(DZ[myi][1][i][12]==3 && DZ[myi][1][i][3]==0  )	
		myCale = " "+hmDate+" onclick='javascript:parent.myShowCalendar(\""+myobj.name+"\",\"R"+j+"F"+i+"\",\"dataTable\","+((j-curpage[myi]*pagesize[myi]+1)*(f_c[myi]+1)+i+1)+");'> ";
	else				
		myCale = " ";
	if(DZ[myi][1][i][12]==3 && DZ[myi][1][i][3]==0  )	
		myCale2 = sDateReadonlyColor;
	else				
		myCale2 = " ";
	if(myFS==1) {	//input
		if(DZ[myi][1][i][8]==1) 
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" >"+mysss+myCale+"</td>";
		else
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";}>"+myCale+mysss+"</td>";
	}
	if(myFS==7) {	//password
		if(DZ[myi][1][i][8]==1) 
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input type=password "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" >"+mysss+myCale+"</td>";
		else
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input type=password "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";}>"+myCale+mysss+"</td>";
	}	
	if(myFS==3) 	//textarea
	{
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><textarea "+hmFFContentArea+" onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+") type=textfield "+str2+DZ[myi][1][i][10]+" name=R"+j+"F"+i+" >"+sValue+"</textarea>"+mysss+"</td>";					
	}	
	if(myFS==2) 	//select
	{
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><select "+hmFFContentSelect+" "+str2+DZ[myi][1][i][10]+" name=R"+j+"F"+i+" value='"+sValue+"' onchange='parent.mE(\""+myobj.name+"\");parent.myHandleSelectChangeByIndex("+myi+","+j+","+i+");' >";
		if(bShowSelectButton)
			myShowSelectVisible="display:visible";
		else
			myShowSelectVisible="display:none";
		myShowSelect = " "+ hmSelectButton +" name=btnR"+j+"F"+i+"  style='"+myShowSelectVisible+"' "+str2+" onclick='javascript:parent.myShowSelect(\""+myobj.name+"\",\"R"+j+"F"+i+"\","+j+","+i+ ");' > ";
		for(k=0;k<DZ[myi][1][i][20].length/2;k++)
		{
			if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
				sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"' selected>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
			else
				sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"'>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
		}
		sss[jjj++] =  "</select>"+myShowSelect+mysss+"</td>";
	}

	if(myFS==5||myFS==6) //radio
	{
		var mybr = "<br>";
		if(myFS==5) mybr="";
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" >";
		sss[jjj++] = "<input type=hidden name=R"+j+"F"+i+" value='"+sValue+"'  >";
		for(k=0;k<DZ[myi][1][i][20].length/2;k++)
		{
			//modify by hxd in 2008/04/10,2007/12/17 for citibank
			//if(DZ[myi][1][i][20][2*k+1]=='') DZ[myi][1][i][20][2*k+1]='(不选择)';
			if(DZ[myi][1][i][20][2*k+1]=='') continue;

			//注意：Radio放在后面，因为name.indexOf("R")有问题
			if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
				sss[jjj++] = "<input type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' checked onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
			else
				sss[jjj++] = "<input type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
		}

		sss[jjj++] =  mysss+"</td>";
	}
	
	//add by hxd in 2005/11/29
	if(myFS==4) //treeview(只读框与一个...按钮)(以及一个隐藏的id)
	{
		
		var sValue_C = "";
		sValue = DZ[myi][2][my_index[myi][j]][i];
		
		for(k=0;k<DZ[myi][1][i][20].length/2;k++)
		{
			if(DZ[myi][1][i][20][2*k]==sValue)
				sValue_C = DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
		}

		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue_C+"' name=R"+j+"F"+i+"_C  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";} readonly >"+myCale+mysss+"<input type=hidden name=R"+j+"F"+i+" value='"+sValue+"' ><input class=inputdate type=button value=\"...\" onClick=parent.popSelectWin('"+DZ[myi][1][i][21]+"',"+myi+","+j+","+i+")> </td>";
		
	}

	//add by hxd in 2008/04/10,2007/12/17 for citibank
	if(myFS==9) 	//flat_dropdown
	{
		if(bShowSelectButton)
			myShowSelectVisible="display:visible";
		else
			myShowSelectVisible="display:none";
		myShowSelect = " "+ hmSelectButton +" name=btnR"+j+"F"+i+"  style='"+myShowSelectVisible+"' "+str2+" onclick='javascript:parent.myShowSelect(\""+myobj.name+"\",\"R"+j+"F"+i+"\","+j+","+i+ ");' > ";

		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" >"+
			"<input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + 
			" value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" style='overflow-x: visible; width: 60px' "+
			" onblur='parent.mySelectBL(this,"+myi+","+j+","+i+")' >"+
			" <span id=spanR"+j+"F"+i+">"+myGetDDValue(myi,i,sValue)+"</span> "+
			myShowSelect+mysss+"</td>";
	}

	return sss.join("");
}

//add by hxd in 2008/04/10,2007/12/17 for citibank 
//modify by hxd in 2008/03/04 for only one-radio 
//单选。。。。。（radio button)。。。。。去掉未选择 
function emptyRadio(iDW,iRow,sCol) 
{ 
	var iCol=getColIndex(iDW,sCol); 
	
	if(typeof(document.frames("myiframe"+iDW).document.all('R'+iRow+'F'+iCol+"_Radio").length)=="undefined") 
		document.frames("myiframe"+iDW).document.all('R'+iRow+'F'+iCol+"_Radio").checked=false; 
	else 
	{ 
		var ii=0; 
		for(ii=0;ii<document.frames("myiframe"+iDW).document.all('R'+iRow+'F'+iCol+"_Radio").length;ii++) 
		{ 
			document.frames("myiframe"+iDW).document.all('R'+iRow+'F'+iCol+"_Radio")[ii].checked = false; 
		} 
	} 
	setItemValue(iDW,iRow,sCol,""); 
} 

//add by hxd in 2008/04/10,2007/12/17 for citibank
function myGetDDValue(iDW,iField,sValue)
{
	var myi=iDW;
	var i=iField;
	var k=0;
	var bFind = false;
	for(k=0;k<DZ[myi][1][i][20].length/2;k++)
	{
		if(DZ[myi][1][i][20][2*k]==sValue)
		{
			bFind = true;
			break;
		}			
	}
	if(!bFind)
		return "";
	else
		return DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
}

//add by hxd in 2008/04/10,2007/12/17 for citibank
//下拉选择。。。。。。。。无下拉框，但要检验合法性。
function mySelectBL(myobj,iDW,iRow,iField)
{
	var myi=iDW;
	var i=iField;
	var k=0;
	//try {
	var bFind = false;
	for(k=0;k<DZ[myi][1][i][20].length/2;k++)
	{
		if(DZ[myi][1][i][20][2*k]==myobj.value)
		{
			bFind = true;
			break;
		}			
	}
	if(!bFind)
	{
		alert("输入项["+DZ[myi][1][i][0]+"]错误，请重新输入!");
		if(my_notnull[myi][i]==1)//如果必须输入的，保持焦点
			myobj.select(); 
		else //否则清空内容
		{
			setItemValueByIndex(iDW,iRow,iField,"");
			myobj.value = "";
			document.frames("myiframe"+myi).document.getElementById("spanR"+iRow+"F"+iField).innerHTML = "";
		}
	}
	else
	{
		//在后面显示该代码对应的内容
		document.frames("myiframe"+myi).document.getElementById("spanR"+iRow+"F"+iField).innerHTML = DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;") ;
	}
	//}	
	//catch(E){var a=1;}
}


//add by hxd in 2005/11/29
function popSelectWin(sArgPopSource,iArgDW,iArgRow,iArgCol)
{
	var sPopSource = sArgPopSource;
	var vPop = sPopSource.split(":")
	
	if(vPop[0]!="Code") return;
	var myCode = vPop[1];
	
	//sObjectType：对象类型
	//iArgDW: 第几个DW，默认为0
	//iArgRow: 第几行，默认为0
	var sObjectType,sPataString,sStyle;

	sObjectType = "SelectCode";
	sPataString = "CodeNo"+","+myCode;
	sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";

	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	var iCol = iArgCol;
	if(iCol == null) iCol=0;
	
	var sObjectNoString = selectObjectValue(sObjectType,sPataString,sStyle);
		
	if(typeof(sObjectNoString)=="undefined" )
	{
		return;	
	}else if(sObjectNoString=="_CANCEL_"  )
	{
		return;
	}else if(sObjectNoString=="_CLEAR_")
	{
		setItemValueByIndex(iDW,iRow,iCol,"");

		var objp = document.frames("myiframe"+iDW);
		var itemname = "R"+iRow+"F"+iCol+"_C";
		objp.document.forms(0).elements(itemname).value="";
				
	}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined")
	{
		var sObjectNos = sObjectNoString.split("@");
		
		setItemValueByIndex(iDW,iRow,iCol,sObjectNos[0]);

		var objp = document.frames("myiframe"+iDW);
		var itemname = "R"+iRow+"F"+iCol+"_C";
		objp.document.forms(0).elements(itemname).value=sObjectNos[1];
				
	}else
	{
		//alert("选取对象编号失败！对象类型："+sObjectType);
		return;
	}

	return sObjectNoString;

}
	
function MR2(myobjname,myact)			
{
	
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	var myobj=document.frames(myobjname);
	var myi=myobj.name.substring(myobj.name.length-1);
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_sel_rec[myi]=-1;		
	cur_sel_item[myi]="";		
	var curPP=0;
	if(myact==5) curPP=myobj.document.forms(0).elements("txtJump").value;
	myobj.document.clear();	
	myobj.document.close();
	
	var mysss;
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HTML>");
	sss[jjj++]=("<HEAD>");
	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1) 
		sss[jjj++]=("<LINK href='"+sPath+"style_dw.css' rel=stylesheet>");
	else                 
		sss[jjj++]=("<LINK href='"+sPath+"style_ff.css' rel=stylesheet>");
	sss[jjj++]=("<LINK href='"+sPath+"../style.css' rel=stylesheet>");
	sss[jjj++]=("</HEAD>");
	sss[jjj++]=("<BODY oncontextmenu='self.event.returnValue=false' onmousedown='parent.mE(\""+myobj.name+"\");' onKeyDown='parent.kD(\""+myobj.name+"\")' onKeyUp='parent.kU(\""+myobj.name+"\")'>");
	sss[jjj++]=("<div style={position:absolute;width:100%;height:100;overflow: auto;}>");
	if(bNeedCA) 
		sss[jjj++]=(" <object id=doit style='display:none' classid='CLSID:8BE89452-A144-49BC-9643-A3D436D83241' border=0 width=0 height=0></object>  ");
	sss[jjj++]=("<form name='form1' class='ffform'>");

	var myS=new Array("","readonly","disabled","readonly"); 
	var myR=DZ[myi][0][2]; 
	var myFR,myFS; 
	var myAlign=new Array(""," align=left "," align=center "," align=right ");
	var myAlign2=new Array("","left","center","right");
	switch(myact) 
	{
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
	
	var myShowSelect = "",myShowSelectVisible="";
	var myevent_num=""; 
	
if(rr_c[myi]>0)
{	
	for(j=curpage[myi]*pagesize[myi];j<=curpage[myi]*pagesize[myi];j++)  
	{
     iCurRow = j; 
     	
	//add by byhu
	//modify by hxd in 2005/07/08 for '
	//sss[jjj++] = amarsoft2Real(drawHarbor(myobjname,myact,myi,j));
	sss[jjj++] = amarsoft2Html(drawHarbor(myobjname,myact,myi,j));

	}
}

	sss[jjj++]=("</form>");
	sss[jjj++]=("</div>");
	sss[jjj++]=("</BODY>");
	sss[jjj++]=("</HTML>");
	//modify by hxd in 2005/07/08 for '
	//myobj.document.writeln(amarsoft2Html(sss.join('')));		
	myobj.document.writeln((sss.join('')));		
	
	myobj.document.close();		
	
	window.status="Ready";  
	window.status=myoldstatus;  
	myAfterLoadFreeForm(myi);
}

//add by hxd in 2008/04/10 for sort
function my_load_s(my_sortorder,sort_which,myobjname,need_change)			
{	
	var my_sortorder_old = my_sortorder;		
	if(my_sortorder==1)   
		my_sortorder=0;  //(升)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(降)
	else if(my_sortorder==2)  
		my_sortorder=0;
	
	var myi=myobjname.substring(myobjname.length-1);
	
	var myoldstatus = window.status;  
	window.status="正在从服务器获得数据，请稍候....";  
	self.showModalDialog(sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&"+
			"sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder+"&rand="+Math.abs(Math.sin((new Date()).getTime())),
			window.self,
			"dialogWidth=1;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	
	window.status=myoldstatus;
	  
	init(false);
	needReComputeIndex[myi]=0;  
	//no need:setPageSize(0,20);
	my_load(my_sortorder_old,sort_which,myobjname,need_change);	  //因为 my_load还会作sort转换
	//mySelectRow();//no need for my_load do le
}

//add by hxd in 2008/04/10 for sort
function my_load_show_s(my_sortorder,sort_which,myobjname)
{	
	
	var my_sortorder_old = my_sortorder;		
	if(my_sortorder==1)   
		my_sortorder=0;  //(升)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(降)
	else if(my_sortorder==2)  
		my_sortorder=0;
		
	var myi=myobjname.substring(myobjname.length-1);
	var myoldstatus = window.status;  
	window.status="正在从服务器获得数据，请稍候....";  
	
	self.showModalDialog(sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&"+
			"sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder+"&rand="+Math.abs(Math.sin((new Date()).getTime())),
			window.self,
			"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	window.status=myoldstatus;
	
	init(false);
	needReComputeIndex[myi]=0;  
	my_load_show(my_sortorder_old,sort_which,myobjname);
	//mySelectRow();//no need
}

//add by hxd in 2008/04/10 for vI_all(check)
function check6789(iEditStyle,sValue)
{
	return true;
}

//add by hxd in 2008/04/10
function showMess(mess)
{
	ShowMessage(mess,false,true);
	setTimeout(hideMessage,500);	
}
function waitMess(mess)
{
	ShowMessage(mess,true,false);
	setTimeout(hideMessage,1000*10);//max时间:等待10s
}
function hideMessage(){
	try{
		msgDiv.removeChild(msgTxt);
		msgDiv.removeChild(msgTitle);
		document.body.removeChild(msgDiv);
		document.all.msgIfm.removeNode();
		document.body.removeChild(bgDiv);
	}catch(e)
	{	
		;
	}
}
function ShowMessage(str,showGb,clickHide){
	
	//可以通过对象检查来判断窗口是否已打开
	//采取替换或者取消的操作来避免重复打开
	//提示文字尽量别超过2行,因为背景iframe动态高度不知道怎么弄。
	
 	if(typeof msgDiv=="object")
		return ;	 	

	var msgw=300;//信息提示窗口的宽度
	var msgh=125;//信息提示窗口的高度
	var bordercolor="#336699";//提示窗口的边框颜色

	var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
	
	//**绘制信息层的低层iframe**/	
	var ifmObj=document.createElement("iframe");
	//add in 2008/04/10 for https
	ifmObj.src = sWebRootPath+"/amarsoft.html";	
	
	ifmObj.setAttribute('id','msgIfm');
	ifmObj.setAttribute('align','center');
	ifmObj.style.background="white";
	ifmObj.style.border="0px none " + bordercolor;
	ifmObj.style.position = "absolute";
	ifmObj.style.left = "55%";
	ifmObj.style.top = scrollTop; //"40%";
	ifmObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
	ifmObj.style.marginLeft = "-225px" ;//文字位置
	ifmObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
	ifmObj.style.width = msgw + "px";
	ifmObj.style.height =msgh + "px";
	ifmObj.style.textAlign = "center";
	ifmObj.style.lineHeight ="25px";

	ifmObj.style.zIndex = "9999";
	document.body.appendChild(ifmObj);
	
	//**绘制背景层**/	
	var bgObj=document.createElement("div");
	bgObj.setAttribute('id','bgDiv');
	bgObj.style.position="absolute";
	
	bgObj.style.top="0";//显示位置top
	bgObj.style.left="0";//显示位置left
	bgObj.style.background="#777";
	bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";//渐变色效果 
	bgObj.style.opacity="50%";//应该是透明度?

	//设置背景层 宽,高
	var sWidth,sHeight;
	sWidth=document.body.offsetWidth;
	
	sHeight=screen.height;
	bgObj.style.width="100%" ;//sWidth + "px";//改为100%更好,铺满窗口
	bgObj.style.height="100%" ;//sHeight + "px";
	
	bgObj.style.zIndex = "10000";//显示层次

	//背景层动作 点击关闭
	if(clickHide)
		bgObj.onclick=hideMessage;
	if(showGb)
		document.body.appendChild(bgObj);
	
	//**绘制信息层**/
	var msgObj=document.createElement("div")
	msgObj.setAttribute("id","msgDiv");
	msgObj.setAttribute("align","center");
	msgObj.style.background="white";
	msgObj.style.border="1px solid " + bordercolor;
	msgObj.style.position = "absolute";
	msgObj.style.left = "55%";
	msgObj.style.top= scrollTop; //"40%";
	msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
	msgObj.style.marginLeft = "-225px" ;//文字位置
	msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
	msgObj.style.width = msgw + "px";
	msgObj.style.height =msgh + "px";
	msgObj.style.textAlign = "center";
	msgObj.style.lineHeight ="25px";
	msgObj.style.zIndex = "10001";
	
	document.body.appendChild(msgObj);
	
	//**绘制标题层**/ 点击关闭
	var title=document.createElement("h4");
	title.setAttribute("id","msgTitle");
	title.setAttribute("align","left");
	title.style.margin="0";
	title.style.padding="3px";
	title.style.background=bordercolor;
	title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
	title.style.opacity="0.75";
	title.style.border="1px solid " + bordercolor;
	title.style.height="18px";
	//title.style.width = msgw + "px";	
	title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
	title.style.color="white";
	
	title.innerHTML="系统处理中...";
	if(clickHide){
		title.innerHTML="关闭";
		title.style.cursor="pointer";			
		title.onclick = hideMessage;
	}	
	
	document.getElementById("msgDiv").appendChild(title);
	
	//**输出提示信息**/
	str = "<br>"+str.replace(/\n/g,"<br>");
	var txt=document.createElement("p");
	txt.style.margin="1em 0"
	txt.setAttribute("id","msgTxt");
	txt.innerHTML=str;
	document.getElementById("msgDiv").appendChild(txt);
		
}


function beforeInit(bSetPageSize)
{
	var i = 0, j = 0;
	for(i=0;i<DZ.length;i++) {
		my_notnull_temp[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull_temp[i][j] = DZ[i][1][j][4];
	}
		
	return true;
}

function beforeInit_show(bSetPageSize)
{
	var i = 0, j = 0;
	for(i=0;i<DZ.length;i++) {
		my_notnull[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull_temp[i][j] = DZ[i][1][j][4];
	}
		
	return true;
}

function beforeMRK1(myobjname,myact,my_sortorder,sort_which)
{
	return true;
}

function beforeMR1(myobjname,myact,my_sortorder,sort_which,need_change)
{
	return true;
}

function beforeMRK2(myobjname,myact)
{
	return true;
}

function beforeMy_load(my_sortorder,sort_which,myobjname,need_change)
{
	return true;
}

function beforeMy_load_show_action(myobjname,myact,my_sortorder,sort_which)
{
	return true;
}

function beforeMy_load_show(my_sortorder,sort_which,myobjname)
{
	return true;
}

function beforeSR(lastRec,iRec,myname)
{
	return true;
}

function beforeCSS(iRec,myname)
{
	return true;
}

function beforeSR_show(lastRec,iRec,myname)
{
	return true;
}

function beforeMyLastCB(myframename,curItemName)
{
	return true;
}

function beforeHC(obj,objpname)
{
	return true;
}

function beforeVI(obj,objpname)
{
	return true;
}

function beforeAsAdd(objname)
{
	return true;
}

function beforeAsDel(objname)
{
	return true;
}

function beforeVIAll(objpname)
{
	return true;
}

function beforeAsSave(objname,afteraction,aftertarget,afterprop)
{
	//add in 2009/04/01
	try {
		var obj0 = document.frames(objname).document.forms(0).elements(cur_sel_item[objname.substring(objname.length-1)]);
		obj0.amar_onchange();
	} catch(e) { var a_a=1; }

	//modify in 2008/04/10
	//return true;
	if(!vI_all(objname))
		return false;
	else
	{
		ShowMessage("系统正在处理数据，请等待...",true,false);
		return true;
	}
}

function beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)
{
	return true;
}

function before_my_load_show_action_s(myobjname,myact,my_sortorder,sort_which)
{
	return true;
}

function beforeMyLoadSave(my_sortorder,sort_which,myobjname)
{
	return true;
}

function beforeAsSaveResult(myobjname)
{
	return true;
}

function beforeIsModified(objname)
{
	return true;
}

function beforeCloseCheck()
{
	return true;
}

function beforeSetPageSize(i,iSize)
{
	return true;
}

function setNoCheckRequired(iDw)
{
	for(i=0;i<f_c[iDw];i++) 
	{
		my_notnull_temp[iDw][i] = my_notnull[iDw][i];
		my_notnull[iDw][i] = 0;
	}
}

function setNeedCheckRequired(iDw)
{
	for(i=0;i<f_c[iDw];i++) 
		my_notnull[iDw][i] = my_notnull_temp[iDw][i];
}


function setItemRequired(iDW,iRow,sItemName,bRequired)
{
	var iCol = getColIndex(iDW,sItemName);
	if(bRequired)
		my_notnull[iDW][iCol] = 1;
	else
		my_notnull[iDW][iCol] = 0;
	setItemCaption(iDW,iRow,iCol,DZ[iDW][1][iCol][0]);
}


function isNotNull(sField)
{
  if(typeof(sField) == "undefined" || sField.length == 0)
    return false ;
  return true;  
}	
//如果colName得value =temp ，initcolName必输 add by lpzhang 2009-8-6 
function setRequiredFlag1(colName,initColName,temp)
{
	sFlag = getItemValue(0,getRow(),colName);
	var sFieldTemp = initColName.split(",");
    if(isNotNull(sFieldTemp))
    {
	    for(var i=0;i<sFieldTemp.length;i++)
	    {
	      if(sFlag == temp) 
 	  		setItemRequired(0,0,sFieldTemp[i],true);	 
 	      else
 	    	setItemRequired(0,0,sFieldTemp[i],false);	 
	    }
    }
	
}
//如果colName得value =temp ，initcolName1必输 ,否则initColName2必输
function setRequiredFlag2(colName,initColName1,initColName2,temp)
{
	sFlag = getItemValue(0,getRow(),colName);
	var sFieldTemp1 = initColName1.split(",");
	var sFieldTemp2 = initColName2.split(",");
	if(sFlag == temp)
	{
		if(isNotNull(sFieldTemp1))
	    {
		    for(var i=0;i<sFieldTemp1.length;i++)
		    {
	 	  		setItemRequired(0,0,sFieldTemp1[i],true);	 
		    }
	    }
	    if(isNotNull(sFieldTemp2))
	    {
	     for(var i=0;i<sFieldTemp2.length;i++)
		    {
	 	  		setItemRequired(0,0,sFieldTemp2[i],false);	 
		    }
	    }
	}else
	{
		if(isNotNull(sFieldTemp2))
	    {
		    for(var i=0;i<sFieldTemp2.length;i++)
		    {
	 	  		setItemRequired(0,0,sFieldTemp2[i],true);	 
		    }
	    }
	    if(isNotNull(sFieldTemp1))
	    {
		    for(var i=0;i<sFieldTemp1.length;i++)
		    {
	 	  		setItemRequired(0,0,sFieldTemp1[i],false);	 
		    }
	    }
	}
    
	
}

//  设置是否必须项 colName为'是"，initColName必输
function setRequiredFlag(colName,initColName)
{
	sFlag = getItemValue(0,getRow(),colName);
	var sFieldTemp = initColName.split(",");
    if(isNotNull(sFieldTemp))
    {
	    for(var i=0;i<sFieldTemp.length;i++)
	    {
	      if(sFlag == "1") 
 	  		setItemRequired(0,0,sFieldTemp[i],true);	 
 	      else
 	    	setItemRequired(0,0,sFieldTemp[i],false);	 
	    }
    }
  
}

