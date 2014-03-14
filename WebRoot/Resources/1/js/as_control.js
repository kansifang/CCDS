var AsControl = {
	_getDefaultOpenStyle:function() {
		return "width="+screen.availWidth+"px,height="+screen.availHeight+"px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	},
	_getDefaultDialogStyle:function() {
		return "dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;";
	},
	_getDialogStyle:function(sStyle) {
		if(typeof(sStyle)=="undefined" || sStyle=="") 
			return this._getDefaultDialogStyle();
		else 
			return sStyle;
	},
	_getParaString:function(sPara) {
		if(typeof(sPara)=="undefined" || sPara=="") {
			return "";
		}
		else if (sPara.substring(0,1)=="&") {
			return encodeURI(encodeURI(sPara));
		}
		else {
			return "&"+encodeURI(encodeURI(sPara));
		}
	},
	_getCompID:function(sURL) {
		return sURL.substring(sURL.lastIndexOf("/")+1, sURL.indexOf(".jsp"));
	},
	randomNumber:function() {
		return Math.abs(Math.sin(new Date().getTime())).toString().substr(2);
	}
};

AsControl.OpenObject = function(sObjectType,sObjectNo,sViewID,sStyle){
	return OpenObject(sObjectType,sObjectNo,sViewID,sStyle); //
};
AsControl.PopObject = function(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas){
	return PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas); //
};

//打开视图，功能同原来的OpenComp
AsControl.OpenView = function(sURL,sPara,sTargetWindow,sStyle){
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }

	var sToDestroyClientID="";
	var sWindowToUnload = sTargetWindow;
	if(sTargetWindow=="_blank") {
		sToDestroyClientID = "";
		return this.PopView(sURL,sPara);
	}else{
		if(sTargetWindow==null || sTargetWindow=="_self") sWindowToUnload="self";
		if(sTargetWindow==null || sTargetWindow=="_top") sWindowToUnload="top";

		try{
			//修改提示
			oWindow = eval(sWindowToUnload);
			sToDestroyClientID = oWindow.sCompClientID;
		}catch(e){
			sToDestroyClientID = "";
		}

		try{if(!oWindow.checkModified()) return;}catch(e1){}
	}
	var sParaStr = "";
	if(typeof(sPara)!="undefined" && sPara!="") sParaStr="&"+sPara;
	var sPageURL = sWebRootPath + "/Redirector.jsp?ComponentID="+this._getCompID(sURL)+"&OpenerClientID="+sCompClientID+"&ToDestroyClientID="+sToDestroyClientID+"&ComponentURL="+sURL+sParaStr+"&rand1="+randomNumber();
	window.open(sPageURL,sTargetWindow,sStyle);
};

//弹出视图，功能同原来的PopComp
AsControl.PopView = function(sURL,sPara,sStyle){
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }
	var sDialogStyle = this._getDialogStyle(sStyle);
	
	var sDaoID=encodeURIComponent(encodeURIComponent(this._getCompID(sURL)+"@@"+sURL+"@@"+sPara));
	return PopPage("/Frame/OpenCompDialog.jsp?DaoID="+sDaoID,"",sDialogStyle);
};

AsControl.DestroyComp = function (ToDestroyClientID) {
	$.ajax({url: sWebRootPath+"/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID="+ToDestroyClientID,async: false});
};

AsControl.RunJavaMethod = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,""),ClassName);
};

AsControl.RunJavaMethodSqlca = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Sqlca"),ClassName);
};

AsControl.RunJavaMethodTrans = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Trans"),ClassName);
};

AsControl.CallJavaMethodJSP = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		  url: sWebRootPath+"/Frame/page/sys/tools/RunJavaMethod.jsp?ClassName="+ClassName+"&MethodName="+MethodName+this._getParaString("Args="+Args)+ArgsObjectText,
		  async: false
		 }).responseText.trim();
};

AsControl.CallJavaMethod = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		  url: sWebRootPath+"/servlet/run?ClassName="+ClassName+"&MethodName="+MethodName+this._getParaString("Args="+Args)+ArgsObjectText,
		  async: false
		 }).responseText.trim();
};

AsControl.GetJavaMethodReturn = function (sReturnText,ClassName) {
	window.onerror = function(msg, url, line) {
	    alert("运行异常: " + msg + "\n");
	    //alert("JS异常: " + msg + "\n" + goUrlName(sWebRootPath,url) + ":" + line);
	    return true;
	};
	if (typeof(sReturnText)=='undefined' || sReturnText.length<8) {
		throw new Error("【"+AWES0007+"】后台服务调用出错！\n【"+ClassName+"】");
	}
	var rCode = sReturnText.substring(0,8);
	if (rCode != '00000000') {
		throw new Error("【"+rCode+"】"+sReturnText.substring(8)+"\n【"+ClassName+"】");
	}
	return sReturnText.substring(8);
};

var OpenStyle=AsControl._getDefaultOpenStyle();
function randomNumber() { return AsControl.randomNumber();}
function RunJavaMethod(ClassName,MethodName,Args) {return AsControl.RunJavaMethod(ClassName,MethodName,Args);}
function RunJavaMethodSqlca(ClassName,MethodName,Args) {return AsControl.RunJavaMethodSqlca(ClassName,MethodName,Args);}
function RunJavaMethodTrans(ClassName,MethodName,Args) {return AsControl.RunJavaMethodTrans(ClassName,MethodName,Args);}


var AsDialog = {
	OpenSelector : function(sObjectType,sParaString,sStyle){
		return selectObjectValue(sObjectType,sParaString,sStyle); //使用在SELECT_CATALOG中自定义查询选择信息
	},
	OpenCalender : function(obj,strFormat,startDate,endDate){
		if(typeof(strFormat)=="undefined" || strFormat=="") {
			strFormat = "yyyy/MM/dd";
		}
		if(typeof(obj)=="undefined" || obj=="") return null;
		else if (typeof(obj) == "string"){
			obj = document.getElementById(obj);
		}
		var date = new Date();
		var today = date.format(strFormat);
		if(startDate && startDate.toUpperCase() == "TODAY"){
			startDate = today;
		}
		if(endDate && endDate.toUpperCase() == "TODAY"){
			endDate = today;
		}
		SelectDate(obj,strFormat,startDate,endDate);
	}
};