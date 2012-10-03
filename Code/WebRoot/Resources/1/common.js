var sScreenWidth = screen.availWidth;
var sScreenHeight = screen.availHeight;
var sDefaultDialogStyle= "dialogWidth="+sScreenWidth+"px;dialogHeight="+sScreenHeight+"px;resizable=yes;maximize:yes;help:no;status:no;";
var OpenStyle="width="+sScreenWidth+"px,height="+sScreenHeight+"px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
var sDefaultModelessDialogStyle = "dialogLeft="+(sScreenWidth*0.6)+";dialogWidth="+(sScreenWidth*0.4)+"px;dialogHeight="+(sScreenHeight)+"px;resizable=yes;status:yes;maximize:yes;help:no;";

function over_change(index,src,clrOver)
{
		if (!src.contains(event.fromElement)) 
	 	{ 
	 		src.style.cursor = 'hand';
	 		src.background = clrOver;
	 	}
}

function out_change(index,src,clrIn)
{
		if (!src.contains(event.toElement))
		{
			src.style.cursor = 'default';
			src.background = clrIn;
		}
}

bIsLocked=false;

function checkIfLocked()
{
	if(bIsLocked)
	{
		if(!confirm("您已经用弹出方式打开了一个新页面，离开本页面将可能导致出错。\n该错误将不会影响系统正常运行。\n您确定要离开本页面吗？")) 
			return true;
		else 
			return false;
	}
	else	
		return true;
}

function randomNumber()
{
	today = new Date();
	num = Math.abs(Math.sin(today.getTime()));
	return num;  
}

//日期检查函数	
function isDate(sItemName) 
{
	var value = Query.elements(sItemName).value;
	var sItems = value.split("/");
	
	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false;
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2150) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
	return true;
}	


//改变工作区大小
function resizeLeft()
{
	try{
		if(myleft.width==1) 
		{
			myleft.width=myleftwidth;
			//self.mymiddle.style.cssText="cursor:w-resize";
		}
		else 
		{
			myleftwidth=myleft.width;
			myleft.width=1;
			//self.mymiddle.style.cssText="cursor:e-resize";
		 }
	}catch(e){
		
	}
}
	 
function resizeTop()
{
	if(mytop.height==25) 
	{
		mytop.height=mytopheight;
		//self.mymiddle.style.cssText="cursor:w-resize";
	}
	else 
	{
		mytopheight=top.mytop.height 
		mytop.height=25;
		//self.mymiddle.style.cssText="cursor:e-resize";
	 }

}


function setObjectInfo(sObjectType,sValueString,iArgDW,iArgRow,sStyle)
{
	//sObjectType：对象类型
	//sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
	//iArgDW: 第几个DW，默认为0
	//iArgRow: 第几行，默认为0
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	
	var sValues = sValueString.split("@");
	
	var sParaString = sValues[0];
	
	var i=sValues.length;
   	i=i-1;
   	if (i%2!=0)
   	{
   		alert("setObjectInfo()返回参数设定有误!\r\n格式为:@ID列名@ID在返回串中的位置...");
		return;
   	}
	else
	{	
		var j=i/2,m,sColumn,iID;	
		//sObjectNoString = PopPage("/SystemManage/SelectionDialog/GetObjectNo.jsp?ObjectType="+sObjectType+"&ParaString="+sParaString,"","dialogWidth:640px;dialogHeight:480px;resizable:yes;scrollbars:no");
		sObjectNoString = selectObjectInfo(sObjectType,sParaString,sStyle);
		if(typeof(sObjectNoString)=="undefined" )
		{
			return;	
		}
		else if(sObjectNoString=="_CANCEL_"  )
		{
			return;
		}
		else if(sObjectNoString=="_CLEAR_")
		{
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,"");
			}
	
		}
		else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined")
		{
			sObjectNos = sObjectNoString.split("@");
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
			}
	
		}
		else
		{
			//alert("选取对象编号失败！对象类型："+sObjectType);
			return;
		}
		return sObjectNoString;
	}	
}
	
function selectObjectInfo(sObjectType,sParaString,sStyle)
{
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	sObjectNoString = PopPage("/Frame/ObjectSelect.jsp?ObjectType="+sObjectType+"&ParaString="+sParaString,"",sStyle);
	
	return sObjectNoString;
}

function createObject(sObjectType,sParaString,sStyle)
{
	alert("本函数已作废，请参考ExampleList.jsp，使用popComp替代");
	/*
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:520px;dialogHeight:420px;resizable:yes;status:no;scrollbars:no";
	sObjectNoString = PopPage("/Frame/ObjectCreationDialog.jsp?ObjectType="+sObjectType+"&ParaString="+sParaString,"",sStyle);
	return sObjectNoString;
	*/
}

function openObject(sObjectType,sObjectNo,sViewID,sStyle)
{		
	OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,"_blank",sStyle);
}

function OpenObject(sObjectType,sObjectNo,sViewID,sStyle){
	openObject(sObjectType,sObjectNo,sViewID,sStyle);
}

function popObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas)
{
	popComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"~ObjectNo="+sObjectNo+"~ViewID="+sViewID,sDialogStyle,sDialogParas);
}

function PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas)
{
	popObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas);
}

function openObjectInFrame(sObjectType,sObjectNo,sViewID,sFrameID)
{
	OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sFrameID,"");
}

function maximizeWindow(){
	window.moveTo(0,0);
	if (document.all) 
	{ 
  		top.window.resizeTo(screen.availWidth,screen.availHeight); 
	} 
 
	else if (document.layers||document.getElementById) 
	{ 
  		if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth) 
  		{ 
    		top.window.outerHeight = screen.availHeight; 
    		top.window.outerWidth = screen.availWidth; 
  		} 
	} 
}

function openComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle){
	return OpenComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle);
}
function OpenComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle)
{
	var sToDestroyClientID="";
	var sWindowToUnload = sTargetWindow;
	if(sCompURL.indexOf("?")>=0){
		alert("错误：组件URL中存在\"?\"。请将组件参数在第三个参数中传入！");
		return;
	}

	if(sTargetWindow=="_blank") {
		sToDestroyClientID = "";
		return popComp(sCompID,sCompURL,sPara);
	}else{
		if(sTargetWindow==null || sTargetWindow=="_self") sWindowToUnload="self";
		if(sTargetWindow==null || sTargetWindow=="_top") sWindowToUnload="top";

		try{
			//修改提示
			oWindow = eval(sWindowToUnload);
			sToDestroyClientID = oWindow.sCompClientID; //add in 2005/04/25
		}catch(e){
			sToDestroyClientID = "";
		}

		try{if(!oWindow.checkModified()) return;}catch(e1){}
	}
	var sURL = sWebRootPath + "/Redirector.jsp?ComponentID="+sCompID+"&OpenerClientID="+sCompClientID+"&ToDestroyClientID="+sToDestroyClientID+"&ComponentURL="+sCompURL+"&"+sPara+"&rand1="+randomNumber();
	window.open(sURL,sTargetWindow,sStyle);
}
function OpenPage(sURL,sTargetWindow,sStyle)
{
	var sPageURL=""; 
	if(sURL.indexOf("?")<0) sPageURL = sWebRootPath + sURL + "?&";
	else sPageURL = sWebRootPath + sURL+"&";

	if(sTargetWindow=="_blank"){
		alert("错误：弹出的页面请不要使用OpenPage函数！");
	}
	
	var sToDestroyPageClientID = ""; // byhu 20050604

	sWindowToUnload="";
	if(sTargetWindow==null || sTargetWindow=="_self"){
		sWindowToUnload="self";
	}else if(sTargetWindow=="_top"){
		sWindowToUnload="top";
	}else if(sTargetWindow=="_blank"){
		sWindowToUnload="";
	}else if(sTargetWindow=="_parent"){
		sWindowToUnload="parent";
	}else sWindowToUnload=sTargetWindow;
	try{
		//修改提示
		oWindow = eval(sWindowToUnload);
		sToDestroyPageClientID = oWindow.sPageClientID; // byhu 20050604
	}catch(e){
	}
	try{
		oWindow = eval(sWindowToUnload);
		if(!oWindow.checkModified()) return;
	}catch(e){
	}
	
	sPageURL = sPageURL + "CompClientID="+sCompClientID+"&ToDestroyPageClientID="+sToDestroyPageClientID+"&rand1="+randomNumber();
	//alert(sPageURL);
	window.open(sPageURL,sTargetWindow,sStyle);
}

function popComp(sComponentID,sComponentURL,sParaString,sStyle,sDialogParameters)
{
	var sDialogStyle = "";
	if(typeof(sStyle)=="undefined" || sStyle=="") sDialogStyle= sDefaultDialogStyle;
	else sDialogStyle = sStyle;

	var sActualDialogParameters = "";
	if(typeof(sDialogParameters)!="undefined" && sDialogParameters!="") sActualDialogParameters= sDialogParameters;

	var sCompParaString = sParaString;
	while(sCompParaString.indexOf("&")>=0) sCompParaString = sCompParaString.replace("&","$[and]");
	return PopPage("/Frame/OpenCompDialog.jsp?ComponentID="+sComponentID+"&ComponentURL="+sComponentURL+"&ParaString="+sCompParaString+"&"+sActualDialogParameters,"",sDialogStyle);
}

function PopComp(sComponentID,sComponentURL,sParaString,sStyle,sDialogParameters)
{
	return popComp(sComponentID,sComponentURL,sParaString,sStyle,sDialogParameters);
}

/*~add by jbye~*/
//*************************************** Ajax *************************
//create xmlHttp Object
function getXmlHttpObject() {
	var xmlHttp=null;
	try{
		  // Firefox, Opera 8.0+, Safari
		  xmlHttp=new XMLHttpRequest();
	  }catch (e) {
		  // Internet Explorer
		  try{
		    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		  }catch (e){
		    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
  	}
	return xmlHttp;
}
//
var ajaxmessage = "";
function getInfoFromAjax(Url){
	xmlHttp=getXmlHttpObject();
	if (xmlHttp==null){
	  alert ("Your browser does not support AJAX!");
	  return;
	}
	xmlHttp.onreadystatechange=getMyAjaxStateChanged;
	xmlHttp.open("GET",Url,false);
	xmlHttp.send(null); 
}
function getMyAjaxStateChanged() { 
	if (xmlHttp.readyState==4){ 
		ajaxmessage = xmlHttp.responseText;
	}else{
		ajaxmessage = "Loading Data......,Powered by AJAX.";
	}
}
function PopPageAjax(sURL,sTargetWindow,sStyle)
{
	//alert("ajax");
	var sDialogStyle = "";
	var sReturnInfo = "";
	if(typeof(sStyle)=="undefined" || sStyle=="") sDialogStyle= sDefaultDialogStyle;
	else sDialogStyle = sStyle;

	var sPageURL=""; 
	if(sURL.indexOf("?")<0) sPageURL = sWebRootPath+sURL+"?";
	else sPageURL = sWebRootPath+sURL+"&";
	
	sPageURL = sPageURL + "CompClientID="+sCompClientID+"&rand1="+randomNumber();
	getInfoFromAjax(sPageURL);
	return trim(ajaxmessage); //modify by hwang 20090603.去掉两端空格
	//return ajaxmessage;
}
//*************************************** Ajax *************************
/*~***************************************end***************************************~*/

function PopPage(sURL,sTargetWindow,sStyle)
{
	var sDialogStyle = "";
	if(typeof(sStyle)=="undefined" || sStyle=="") sDialogStyle= sDefaultDialogStyle;
	else sDialogStyle = sStyle;

	var sPageURL=""; 
	if(sURL.indexOf("?")<0) sPageURL = sWebRootPath+sURL+"?";
	else sPageURL = sWebRootPath+sURL+"&";
	
	sPageURL = sPageURL + "CompClientID="+sCompClientID+"&rand1="+randomNumber();
	//alert(sPageURL);
	return window.showModalDialog(sPageURL,sTargetWindow,sDialogStyle);
}

function PopModelessPage(sURL,sTargetWindow,sStyle){
	var sDialogStyle = "";
	if(typeof(sStyle)=="undefined" || sStyle=="") sDialogStyle= sDefaultModelessDialogStyle;
	else sDialogStyle = sStyle;

	var sPageURL=""; 
	if(sURL.indexOf("?")<0) sPageURL = sWebRootPath+sURL+"?";
	else sPageURL = sWebRootPath+sURL+"&";
	
	sPageURL = sPageURL + "ShowSysArea=false&CompClientID="+sCompClientID+"&rand1="+randomNumber();
	//alert(sPageURL);
	return window.showModelessDialog(sPageURL,sTargetWindow,sDialogStyle);
}
function PopModelessComp(sComponentID,sComponentURL,sParaString,sStyle)
{
	var sDialogStyle = "";
	if(typeof(sStyle)=="undefined" || sStyle=="") sDialogStyle= sDefaultModelessDialogStyle;
	else sDialogStyle = sStyle;

	var sCompParaString = sParaString;
	while(sCompParaString.indexOf("&")>=0) sCompParaString = sCompParaString.replace("&","$[and]");
	return PopModelessPage("/Frame/OpenCompDialog.jsp?ComponentID="+sComponentID+"&ComponentURL="+sComponentURL+"&ParaString="+sCompParaString,"",sDialogStyle);
}

function ShowCompHelp(sCompID)
{ 					
		PopModelessComp('OnlineHelp','/Common/help/HelpFrame.jsp','ObjectType=ComponentDefinition&ObjectNo='+sCompID+'&CommentType=Help');
}
function ShowHelp(sHelpID)
{ 					
		PopModelessComp('OnlineHelp','/Common/help/HelpFrame.jsp','CommentItemID='+sHelpID);
}
function viewSource()
{
	var ress  =parent.location;
	window.location="view-source:"+ress;
}
function key_up(e){
	if( document.event.shiftKey  && document.event.ctrlKey && document.event.altKey   )
	{
		alert("ss");
		return;
	}
}
function GetPropertiesString(objObject) //byhu: 此函数可以察看传入对象的所有属性
{
   var varProp;
   var strProperties = objObject.id + "\n";

   for (varProp in objObject)
   {
      strProperties += varProp + " = " + objObject[varProp] + "\n";
   }
   return strProperties;
}

function reloadSelf(){
	//记住当前的页号和行号
	rememberPageRow();
	if(document.forms("DOFilter")==null){
		self.location.reload();
	} else if(typeof(document.forms("DOFilter"))=="undefined"){
		self.location.reload();
	}else{
		document.forms("DOFilter").submit();
	}
}
function rememberPageRow(){
	//document.all("DWCurPage").value=curpage[0];
	//document.all("DWCurRow").value=getRow(0);
}

//add by hxd in 2008/04/10 
function reloadCurrentRow_old(iDW,iTempCurrRow)
{
 	var ii=0,mycond=" 1e1eq2qu3u1 "; 
	for(ii=0;ii<f_c[iDW];ii++)
	{
		if(DZ[iDW][1][ii][1]==1) 
		{
			if(DZ[iDW][1][ii][12]==1||DZ[iDW][1][ii][12]==3||DZ[iDW][1][ii][12]==4)
				mycond = mycond + " and " + DZ[iDW][1][ii][15] + "e1eq2qu3u'"+DZ[iDW][2][iTempCurrRow][ii]+"'";
			else
				mycond = mycond + " and " + DZ[iDW][1][ii][15] + "e1eq2qu3u"+DZ[iDW][2][iTempCurrRow][ii];
		}
	}	
	
 	var myoldstatus = window.status;   
 	window.status="正在从服务器获得数据更新当前记录，请稍候....";   
 	self.showModalDialog(sPath+"GetDWCurrRow.jsp?dw="+DZ[iDW][0][1]+"&cond="+real2Amarsoft(mycond)+"&rand="+amarRand(),window.self,"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no"); 
 	window.status=myoldstatus; 
 	   
	for(ii=0;ii<f_c[iDW];ii++) 
	{	
		setItemValue(iDW,getRow(iDW),DZ[iDW][1][ii][15],DZ[iDW][2][iTempCurrRow][ii]+"A");
	}	
}

//add by hxd in 2008/04/10 
function reloadCurrentRow(_iDW,_iTempCurrRow)
{
	var iDW=0;
	var iTempCurrRow=0;
	
	if(arguments.length==0)
	{
		iDW = 0;
		iTempCurrRow = getRow(0);
	}
	
	if(arguments.length==1)
	{
		iDW = _iDW ;
		iTempCurrRow = getRow(iDW);
	}
	
	if(arguments.length==2)
	{
		iDW = _iDW ;
		iTempCurrRow = _iTempCurrow;
	}
		
	var bHaveKey = false;
 	var ii=0,mycond=""; 
 	
 	mycond = "dw="+DZ[iDW][0][1]+"&row="+iTempCurrRow;
 	
	for(ii=0;ii<f_c[iDW];ii++)
	{
		if(DZ[iDW][1][ii][1]==1) 
		{
			bHaveKey = true;
			mycond = mycond+"&col"+ii+"="+real2Amarsoft(DZ[iDW][2][iTempCurrRow][ii]);
		}
	}	
	
	if(!bHaveKey)
	{
		alert("该DW窗口没有定义主键，不能动态更新！");
		return;
	}

 	var myoldstatus = window.status;   
 	window.status="正在从服务器获得数据更新当前记录，请稍候....";   
 	self.showModalDialog(sPath+"GetDWCurrRow.jsp?"+mycond+"&rand="+amarRand(),window.self,
 		"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no"); 
 	window.status=myoldstatus; 
 	   
	for(ii=0;ii<f_c[iDW];ii++) 
	{	
		try {
		setItemValue(iDW,iTempCurrRow,DZ[iDW][1][ii][15],DZ[iDW][2][iTempCurrRow][ii]);
		}catch(e){}
	}	
}

function setDialogTitle(sTitleText){
	oTitleTD = top.document.all("TitleTD");
	oTitleTR = top.document.all("TitleTR");
	if(typeof(oTitleTD)=="undefined") return;
	if(sTitleText==""){
		oTitleTR.style.display = "none";
		oTitleTD.innerHTML="";
	}else{
		oTitleTR.style.display = "";
		oTitleTD.innerHTML="&nbsp;&nbsp;<b>"+sTitleText+"</b>";
	}
}

function sessionOut()
{
	if(confirm("确认退出本系统吗？"))
		OpenPage("/SignOut.jsp","_top","");
}

// byhu 2005.08.04 运行一个ASMethod，并返回值
function returnText2(){
    return amarsoft2Real(PopPage("/Common/ToolsB/RunMethod2.jsp"));
}
function RunMethod2(ClassName,MethodName,Args){
      saveParaToComp("ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args,"returnText2()");
}

function RunMethod(ClassName,MethodName,Args){
		//modify by jbye,解决界面引导中弹出闪的问题
		return PopPageAjax("/Common/ToolsB/RunMethodAJAX.jsp?ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args,"","width:1000px;height:100px");
		//return PopPage("/Common/ToolsB/RunMethod.jsp?ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args,"","width:0px;height:0px");
}

function RunMethod9(ClassName,MethodName,Args){ 
		return PopPage("/Common/ToolsB/RunMethod9.jsp?ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args,"","width:0px;height:0px");
}


/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
function getSerialNo(sTableName,sColumnName,sPrefix) 
{
	//使用GetSerialNo.jsp来抢占一个流水号
	return PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
}
	
	
	

//*************************begin********************
//Author:thong
//Create Date?2005-9-7 8:20
//Describe:在页面中提交查询动作后，出现进度条，直到新的页面的数据全部load出来。
//**************************************************
function onSubmit(sUrl,sParameter) {
	var waitingInfo = document.getElementById(getNetuiTagName("waitingInfo"));
	//设置显示
	waitingInfo.style.display = ""; 
	//滚动开始
	progress_update(); 
	//间隔控制
	for(i=0;i<1000000;i++){
		j=i+i;
	}
	
	OpenPage(sUrl,sParameter,""); 
}

//Modify Date?2006-2-16 17:20 为了兼顾不同的form，增加了一个参数sFormName
function onFromAction(sUrl,sFormName) {
	var waitingInfo = document.getElementById(getNetuiTagName("waitingInfo"));
	waitingInfo.style.display = ""; 
	progress_update(); 
	for(i=0;i<1000000;i++){
		j=i+i;
	}
	if(sFormName == "report")
	{
		document.report.action = sUrl;
		document.report.submit();
	}
	if(sFormName == "DOFilter")
	{
		sUrl.submit();
	}
	
}

// Build the netui_names table to map the tagId attributes
// to the real id written into the HTML
if (netui_names == null)
var netui_names = new Object();
netui_names.selectButton="portlet_15_1selectButton"
// method which will return a real id for a tagId
function getNetuiTagName(id) {
	return netui_names[id];
}

// method which will return a real id for a tagId,
// the tag parameter will be used to find the scopeId for
// containers that may scope their ids
function getNetuiTagName(id, tag) {
	var scopeId = getScopeId(tag);
	if (scopeId == "")
		return netui_names[id];
	else
		return netui_names[scopeId + "__" + id];
}

// method which get a tag will find any scopeId that,
// was inserted by the containers
function getScopeId(tag) {
	if (tag == null)
		return "";
	if (tag.getAttribute) { 
		if (tag.getAttribute('scopeId') != null)
			return tag.getAttribute('scopeId');
	} 
	if (tag.scopeId != null)
		return tag.scopeId;
		return getScopeId(tag.parentNode);
}

// Build the netui_names table to map the tagId attributes
// to the real id written into the HTML
if (netui_names == null)
var netui_names = new Object();
netui_names.waitingInfo="waitingInfo"

//滚动量
var progressEnd = 18; 
//滚动条颜色
var progressColor = 'green'; 
var progressInterval = 200; // set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;

function progress_clear() {
	for (var i = 1; i <= progressEnd; i++) 
		document.getElementById('progress'+i).style.backgroundColor = 'transparent';
	progressAt = 0;
}
function progress_update() {
progressAt++;
	if (progressAt > progressEnd) progress_clear();
	else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
	progressTimer = setTimeout('progress_update()',progressInterval);
}
function progress_stop() {
	clearTimeout(progressTimer);
	progress_clear();
}	
//*******************************end*********************************
	
//add zywei 2005/08/31 主要是使用在select_catalog中自定义查询选择信息		
function setObjectValue(sObjectType,sPataString,sValueString,iArgDW,iArgRow,sStyle)
{
	//sObjectType：对象类型
	//sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
	//iArgDW: 第几个DW，默认为0
	//iArgRow: 第几行，默认为0
	
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	
	var sValues = sValueString.split("@");
	
	var i=sValues.length;
 	i=i-1;
 	if (i%2!=0)
 	{
 		alert("setObjectValue()返回参数设定有误!\r\n格式为:@ID列名@ID在返回串中的位置...");
	return;
 	}else
	{	
		
		var j=i/2,m,sColumn,iID;			
		sObjectNoString = selectObjectValue(sObjectType,sPataString,sStyle);
		
		if(typeof(sObjectNoString)=="undefined" )
		{
			return;	
		}else if(sObjectNoString=="_CANCEL_"  )
		{
			return;
		}else if(sObjectNoString=="_CLEAR_")
		{
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,"");
			}	
		}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined")
		{
			sObjectNos = sObjectNoString.split("@");
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
			}	
		}else
		{
			//alert("选取对象编号失败！对象类型："+sObjectType);
			return;
		}
		return sObjectNoString;
	}	
}

//add zywei 2005/08/31 主要是使用在select_catalog中自定义查询选择信息	
function selectObjectValue(sObjectType,sParaString,sStyle)
{
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	//sObjectNoString = PopComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	sObjectNoString = PopPage("/Frame/DialogSelect.jsp?SelName="+sObjectType+"&ParaString="+sParaString,"",sStyle);
	return sObjectNoString;
}

//add zywei 2005/08/31 主要是使用在select_catalog中自定义查询选择信息	
function selectMultipleGrid(sObjectType,sParaString,sStyle)
{
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	//sObjectNoString = PopComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	sObjectNoString = PopComp("SelectMultipleGridDialog","/Frame/SelectMultipleGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	return sObjectNoString;
}

//add by byhu 2006.08.03 编辑规则
function editRule(sTable,sRegisteredColumn)
{
	sScript=getItemValue(0,getRow(),sRegisteredColumn);
	saveParaToComp("Script="+sScript,"openRuleEditor('"+sTable+"','"+sRegisteredColumn+"')");
	//openRuleEditor(sTable,sRegisteredColumn,sScript);
}

function openRuleEditor(sTable,sColumnName)
{
	var sDialogWidth = "780px", sDialogHeight="580px";
	if(sScreenWidth>=1000) sDialogWidth = "950px", sDialogHeight="700px";
	//sValue = PopComp("RuleEditor","/Common/Configurator/RuleManage/RuleEditor.jsp","Table="+sTable+"&Column="+sColumnName,"dialogwidth:"+sDialogWidth+";dialogheight:"+sDialogHeight+";resizable:yes;");
	sValue = PopComp("RuleEditor","/Common/Configurator/RuleManage/RuleEditor.jsp","Table="+sTable+"&Column="+sColumnName,"");
	if (sValue!=null && sValue!='undefined') {
		setItemValue(0,getRow(),sColumnName,sValue);
	}
}

/**从组件参数池取参数*/
function getCompAttribute(sAttributeID){
	var sReturn = PopPage("/Common/ToolsB/GetCompAttribute.jsp?AttributeID="+sAttributeID);
	return sReturn;
}

/**测试脚本*/
function testRule(sScript){
	sScript = real2Amarsoft(sScript);
	var sData = getCompAttribute("ScenarioPara");
	if(sData==null ||sData=="null" || sData=="") sData = selectObjectValue("SelectAllCBTestApply","","");
	if(typeof(sData)=="undefined" || sData=="") return;
	sDatas = sData.split("@");
	
	var sScriptScenario = getCompAttribute("Scenario");
	if(sScriptScenario==null ||sScriptScenario=="null" || sScriptScenario=="") sScriptScenario = selectObjectValue("SelectAllScriptScenario","","");
	if(typeof(sScriptScenario)=="undefined" || sScriptScenario=="") return;
	if(sScriptScenario=="_CANCEL_") return;
	sScriptScenario = sScriptScenario.split("@")[0];
	
	//var sPath = RunMethod("Configurator","TestBusinessRule",sScriptScenario+",TaskNo="+sDatas[1]+","+sScript);
	var sPath = PopPage("/Common/Configurator/RuleManage/TestScript.jsp?Scenario="+sScriptScenario+"&ParaString=TaskNo="+sDatas[1]+"&Script="+sScript,"","width:0px;height:0px");
	if(typeof(sPath)=="undefined") return;
	if(sPath=="_CANCEL_") return;
	
	if(sPath.indexOf("LogID=")>=0){
		PopComp("DecisionFlow","/Common/Configurator/RuleManage/DecisionFlowDisplay.jsp","Path="+sPath);
	}else{
		alert("规则执行的结果为:\n\n"+sPath);
	}
}

//检查主键冲突
function checkPrimaryKey(sTable,sColumnString){
	var sParameters = "Type=PRIMARYKEY&TableName="+sTable+"";
	var sColumns=sColumnString.split("@");
	for(var i=0;i<sColumns.length;i++){
		if(i==4){
			alert("关键字最多4个");
			return false;
		}
		sParameters+="&FieldName"+(i+1)+"="+sColumns[i];
		sParameters+="&FieldValue"+(i+1)+"="+getItemValue(0,0,sColumns[i]);
	}
	sReturnValue = PopPage("/Common/ToolsB/CheckPrimaryKeyAction.jsp?"+sParameters,"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
	if(sReturnValue == "TRUE")
	{
		return true;
	}else{
		return false;
	}
}

	