var AsDebug = {
	URL:"",
	_isWindowOpen:false,
	_isReportWindowOpen:false,
	toggleWindow:function() {
		if (this._isWindowOpen) {
			this.hideWindow();
		}
		else {
			this.showWindow();
		}
	},
	showWindow:function() {
		if (!this._isWindowOpen) {
			var topDiv = $("#debugTool");
			topDiv.show();
			var obj = $("#debugTool_subdiv");//var obj = topDiv.children(".datawindow_overdiv_subdiv");
			obj.show();
			var iLeft = (topDiv[0].offsetWidth-obj[0].offsetWidth)/2;//100 + document.body.scrollLeft;
			var iTop = (topDiv[0].offsetHeight-obj[0].offsetHeight)/2;//100 + document.body.scrollTop;
			obj.css({left:iLeft,top:iTop});
			document.getElementById('sp_debug_overdiv_top').style.display= 'inline';
			this._isWindowOpen = true;
		}
	},
	hideWindow:function() {
		if (this._isWindowOpen) {
			this._isWindowOpen = false;
			$("#debugTool_subdiv").hide();
			$("#debugTool").hide();
		}
	},
	getURL:function() {
		if (typeof(AsDebug_URL) != "undefined")
			this.URL = AsDebug_URL;
		if (this.URL != "")	return this.URL.substring(this.URL.lastIndexOf(sWebRootPath)+sWebRootPath.length);
		return document.URL;
	},
	getPage:function() {
		if (typeof(AsDebug_URL) != "undefined")
			this.URL = AsDebug_URL;
		if (this.URL != "")	return this.URL.substring(this.URL.lastIndexOf("/")+1);
		return document.URL;
	},
	reloadCacheAll:function(oBody){
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
	},
	reloadCache:function(CacheType){
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCache","ConfigName="+CacheType);
		if(sReturn=="SUCCESS") alert("刷新参数缓存成功！");
		else alert("刷新参数缓存失败！");
	},
	reloadConfigFile:function(){
		var sReturn = PopPageAjax("/Common/Configurator/ControlCenter/ClearAmarsoftXMLCache.jsp","","");
		if(sReturn=="SUCCESS") alert("重载配置文件成功！");
		else alert("重载配置文件失败！");
	},
	openControlCenter:function(oBody) {
		this.hideWindow();
		popComp("ControlCenter","/Common/Configurator/ControlCenter/ControlCenter.jsp","","","");
	},
	displayHTML:function(oBody) {
		showModalDialog(sWebRootPath+"/Frame/page/debug/tools/viewsource.htm", oBody,"status:no;resizable:yes;center:yes;dialogHeight:688px;dialogWidth:968px;");
	},
	displayBodyHTML:function() {
		this.hideWindow();
		this.displayHTML(document.body);
	},
	viewComp:function() {
		this.hideWindow();
		popComp("CompStructure","/Common/Configurator/ControlCenter/CompStructure.jsp","","","");
	},
	viewCompDetail:function() {
		this.hideWindow();
		popComp("CompDetail","/Common/Configurator/ControlCenter/CompDetail.jsp","ToShowClientID="+sCompClientID,"","");
	},
	displayDwInfo:function() {
		this.hideWindow();
		try{
			displayHTML(myiframe0.document.body);
		}
		catch(e){
			alert("No DWInfo");
		}
	},
	displayURL:function displayURL() {	
		prompt("URLName                                                         ",this.getURL());
	},
	displayPageName:function() {	
		prompt("PageName                                       ",this.getPage());
	},
	displayURLnPara:function() {	
		prompt("URL",document.URL);
	},
	editDW:function(){
		if(typeof(DisplayDONO)=="undefined" || DisplayDONO.length == 0){
			alert("No DWInfo");
			return;
		}
		PopComp("DataObjectCatalogInfo","/AppConfig/PageMode/DWConfig/DataObjectCatalogInfo.jsp","DONO="+DisplayDONO,"","");
	}
};

$(document).keydown(function(event){
    if(event.altKey && event.keyCode == 49){ //alt+1
		AsDebug.toggleWindow();
	}else if(event.altKey && event.keyCode == 50){ //alt+2
		if(typeof OverrideAlt2 == 'function') OverrideAlt2();
		else AsDebug.editDW();
	}else if(event.altKey && event.keyCode == 51){ //alt+3
		AsDebug.reloadCacheAll();
	}else if(event.keyCode == "27"){ //esc
		AsDebug.hideWindow();
		//AsDebug.closeErrorWindow();
	}
	else if(event.keyCode==113 && window.as_defaultExport){//F2导出excel
		as_defaultExport();
	}
});