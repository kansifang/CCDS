//var sHCResourcesPath = "/amarbank6/Resources/1";
var sHCResourcesPath = sResourcesPath;
var iCurButtonID = 1;
/** 
*删除数组指定下标或指定对象 
*/ 
Array.prototype.remove=function(obj){ 
	for(var i =0;i <this.length;i++){ 
		var temp = this[i]; 
		if(!isNaN(obj)){ 
			temp=i; 
		} 
		if(temp == obj){ 
			//this[i]=null;//此处是此位置置空，长度不变，而下面是此位置后面的依次往前一位，长度减一
			for(var j = i;j <this.length;j++){ 
				this[j]=this[j+1]; 
			} 
			this.length = this.length-1; 
		} 
	} 
};
/***button*/

/**显示一个button*/

function hc_drawButton(buttonID, buttonText, onclickScript, displayType){
		var result="";
		result += "<span id='"+buttonID+"' onclick=\""+onclickScript+"\">"+"\r";
		result += "<table id='"+buttonID+"_button_frame' cellspacing=0 cellpadding=0 border=0><tr>"+"\r";
		result += "<td id='"+buttonID+"_button_left' class='"+displayType+"buttonleft' width='8'><img src='"+sHCResourcesPath+"/button"+displayType+"_left.gif' width='8' height='16'  border='0'></td>"+"\r";
 		result += "<td id='"+buttonID+"_button_middle' class='"+displayType+"button' valign='bottom' align='center'><span id='"+buttonID+"_button_text' class='"+displayType+"buttontext' style='cursor:pointer;'>"+buttonText+"</span></td>"+"\r";
 		result += "<td id='"+buttonID+"_button_right' class='"+displayType+"buttonright' width='8'><img src='"+sHCResourcesPath+"/button"+displayType+"_right.gif' width='8' height='16'  border='0'></td>"+"\r";
 		result += "</tr></table></span>"+"\r";
		
		document.write(result);
		
}

function hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath){
	hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath,"");
}

function hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath,iconCls){
		if(typeof(iconCls) == "undefined" || iconCls.length == 0){
			if (sText.indexOf("新增") >= 0) iconCls = "btn_icon_add";
			if (sText.indexOf("详情") >= 0) iconCls = "btn_icon_detail";
			if (sText.indexOf("删除") >= 0) iconCls = "btn_icon_delete";
			if (sText.indexOf("提交") >= 0) iconCls = "btn_icon_submit";
			if (sText.indexOf("保存") >= 0) iconCls = "btn_icon_save";
		}
	
		var result="";
		result += "<span id='button"+iCurButtonID+"' title='"+sTips+"' onclick=\""+sScript+"\" ";
 		result += " onMouseOver=\"overButton("+iCurButtonID+");\" ";
 		result += " onMouseOut=\"outButton("+iCurButtonID+");\" ";
 		result += " onMouseDown=\"downButton("+iCurButtonID+");\" ";
 		result += " onMouseUp=\"upButton("+iCurButtonID+");\" ";
		result += ">"+"\r";
		result += "<table id='buttontable"+iCurButtonID+"' cellspacing=0 cellpadding=0 border=0><tr>"+"\r";
		result += "<td id='buttonlefttd"+iCurButtonID+"' class='buttonleft'><img  class='buttonleftimg'  id='buttonimageleft"+iCurButtonID+"' src='"+ssHCResourcesPath+"/1x1.gif' width='1' height='1' boder='0'></td>"+"\r";
 		result += "<td id='buttonmiddletd"+iCurButtonID+"' class='button' nowrap >";
 		result += "<div class=\"";
 		if(typeof(iconCls)!= "undefined" && iconCls.length != 0){
			result += iconCls;
		}
		result += "\"></div>";
 		result +=  sText + "</td>"+"\r";
 		result += "<td id='buttonrighttd"+iCurButtonID+"' class='buttonright'><img  class='buttonrightimg' id='buttonimageright"+iCurButtonID+"' src='"+ssHCResourcesPath+"/1x1.gif' width='1' height='1' boder='0'></td>"+"\r";
 		result += "</tr></table></span>"+"\r";

		document.write(result);
		iCurButtonID++;
}

function drawImgButton(sClassName,sTips,sScript,ssHCResourcesPath){
		var result="";
		result += " <img src=\""+ssHCResourcesPath+"/1x1.gif\" class=\""+sClassName+"\" id='button"+iCurButtonID+"' title='"+sTips+"' alt='"+sTips+"' onclick=\""+sScript+"\" ";
 		result += " onMouseOver=\"overImgButton(this,'"+sClassName+"');\" ";
 		result += " onMouseOut=\"outImgButton(this,'"+sClassName+"');\" ";
 		result += " onMouseDown=\"javascript:this.className='"+sClassName+"_down'\" ";
 		result += " onMouseUp=\"javascript:this.className='"+sClassName+"_hover'\" ";
		result += "/> ";
		document.write(result);
		iCurButtonID++;
}

function overButton(iButtonID){
	//加入超时控制，防止闪屏
	setTimeout(function overButtonIn(){
		document.getElementById('buttonmiddletd'+iButtonID).className='buttonHover';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgHover';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgHover';
	}, 1); 
}

function outButton(iButtonID){
	//加入超时控制，防止闪屏
    setTimeout(function outButtonIn(){
		document.getElementById('buttonmiddletd'+iButtonID).className='button';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimg';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimg';
	}, 1); 
}

function overImgButton(obj,cname){
	//加入超时控制，防止闪屏
    setTimeout(function overImgButtonIn(){
		obj.className=cname+'_hover';
	}, 1); 
}

function outImgButton(obj,cname){
	//加入超时控制，防止闪屏
    setTimeout(function outImgButtonIn(){
		obj.className=cname;
	}, 1); 
}

function downButton(iButtonID){
	document.getElementById('buttonmiddletd'+iButtonID).className='buttonDown';
	document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgDown';
	document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgDown';
	
}
function upButton(iButtonID){
	document.getElementById('buttonmiddletd'+iButtonID).className='buttonHover';
	document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgHover';
	document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgHover';
	
}

/**显示一组button*/
function hc_drawButtons(buttons, displayType){
		document.write("<table cellspacing=0 cellpadding=0 border=0><tr><td>&nbsp;</td>"+"\r");
		for(var i=0; i<buttons.length; i++){
			document.write("<td>"+"\r");
			hc_drawButton(buttons[i][0],buttons[i][1],buttons[i][2],displayType);
			document.write("<td>&nbsp;&nbsp;</td>"+"\r");
 			document.write("</td>"+"\r");
 		}
		document.write("</tr></table>"+"\r");
		
}



/**显示一个inputbox*/
function hc_drawInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
}

function hc_drawMemoInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='top'>&nbsp;&nbsp;<span  class='ibheader1'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><textarea rows='6' class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></textarea></td>"+"\r");
		
}

function hc_drawDateInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
		
}


/**显示freeform*/
function hc_drawFreeForm(obj,width,totalColumns,defaultColspan,defaultColspanForLongType,defaultPosition){
		document.write("<table cellspacing=0 cellpadding=0 border=0 width='"+width+"'>"+"\r");
		var remainColumns = 0;
		var colwidth;
		
		var a = width.replace("%","");
		
		if(a<=100){
			colwidth = (a/totalColumns);
			colwidth = colwidth +"%";
		}else{
			colwidth = a/totalColumns;	
		}
		 
		
				
		document.write("<tr>");
		for(var j=0; j<totalColumns; j++){
			document.write("<td width='"+colwidth+"'></td>");
		}
		document.write("</tr>");
		
		
		for(var j=0; j<obj.length; j++){
			//取得colspan
			temp=obj[j][3];
			if(temp==""){
				colspan = defaultColspan;
			}else{
				colspan = temp;
			}

			//取得position
			temp=obj[j][4];
			if(temp==""){
				position = defaultPosition;
			}else{
				position = temp;
			}

			//显示<tr>
			if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns = totalColumns;
				document.write("<tr height='8'></tr><tr>");
			}

			//显示内容
			if(obj[j][2]=="string"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="memo"){
				hc_drawMemoInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="date"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="dropdownlist"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}

			//显示</tr>
			
			if (position=="FULLROW"){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns=0;
			}
		}

		document.write("</table>");
}

/**显示一组tab*/		
function hc_drawTab(tabID, tabStrip,selectedStrip){
		
		document.write("<table id='"+tabID+"'cellspacing=0 cellpadding=0 border=0><tr>"+"\r");

		

		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			document.write("<td rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			if(i==(tabStrip.length-1)){
				document.write("<td rowspan=2><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			}
			
		}
		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			document.write("<td class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");

		}
	
		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}
			}
			if(i==(selectedStrip-1)){
				document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}else{
				document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
			}			
		}

		document.write("</tr></table>"+"\r");

	}

	//sObject=window
	function hc_drawTabToIframe(tabID, tabStrip,selectedStrip,sObject){
		
		
		sObject.document.clear();
		sObject.document.close();
		
		sObject.document.write("<html>"+"\r");
		sObject.document.write("<head>"+"\r");
		sObject.document.write("<link rel='stylesheet' href='"+sHCResourcesPath+"/Style.css'>"+"\r");
		sObject.document.write("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=gb2312'>"+"\r");

//		/*
		sObject.document.write("<style>\r");
				sObject.document.write("img.tabonoff \r {\r height:19px; \rwidth:24px;\r background-image:url("+sHCResourcesPath+"/tab/onoff.gif);\r}");
				sObject.document.write("img.taboffon { height:19px;	width:24px;	background-image:url("+sHCResourcesPath+"/tab/offon.gif);}\r");
				sObject.document.write("img.taboffoff { height:19px;width:24px;	background-image:url("+sHCResourcesPath+"/tab/offoff.gif);}\r");
				sObject.document.write("img.taboffbk{height:18px;width:14px;background-image:url("+sHCResourcesPath+"/tab/bkoff.gif);}\r");
				sObject.document.write("img.tabonbk{height:18px;width:14px;	background-image:url("+sHCResourcesPath+"/tab/bkon.gif);}\r");
				sObject.document.write("img.tabfroff{height:18px;width:28px;background-image:url("+sHCResourcesPath+"/tab/froff.gif);}\r");
				sObject.document.write("img.tabfron{height:18px;width:28px;background-image:url("+sHCResourcesPath+"/tab/fron.gif);}\r");
				sObject.document.write(".tabdesel{background-color:#C4C4C4;}\r");
				sObject.document.write(".tabsel{background-color:#DCDCDC;}\r");
				sObject.document.write(".tabline1{background-color:#DCDCDC;}\r");
				sObject.document.write(".tabline{background-color:#FFFFFF;}\r");
				sObject.document.write(".tabtext{cursor:pointer;}\r");
				sObject.document.write(".tabcontent{border-top: #DCDCDC 1px solid;border-bottom: #AAAAAA 2px solid;border-left: #FFFFFF 1px solid;border-right: #AAAAAA 2px solid;background-color:#DEDEC8;}\r");
				sObject.document.write(".tabbar{background-image:url("+sHCResourcesPath+"/tab/barback.gif);height: 1 px;}\r");
		sObject.document.write("</style>\r");
//		*/
		sObject.document.write("</head>"+"\r");		
		sObject.document.write("<body class='pagebackground' leftmargin='0' topmargin='0'  background='"+sHCResourcesPath+"/tab/barback.gif'>"+"\r");
		//sObject.document.write("<Tbody>"+"\r");
		sObject.document.write("<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'><tr>"+"\r");

		

		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			sObject.document.write("<td    rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			sObject.document.write("<td   class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			if(i==(tabStrip.length-1)){
				sObject.document.write("<td rowspan=2 ><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			}
			
		}
		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			sObject.document.write("<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");

		}
	
		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
				
			}
			if(i==(selectedStrip-1)){
				sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}else{
				sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
			}			
		}

		sObject.document.write("</tr></table>"+"\r");
		//sObject.document.write("</Tbody>"+"\r");
		sObject.document.write("</body>\r");
		sObject.document.write("</html>\r");
		//alert(sObject.document.src);
	} 
	//sObject=td 一组tab是一个三行的table 一三行是标签前后的装饰
	function hc_drawTabToTable(tabID, tabStrip,selectedStrip,sObject){
		sObject.innerHTML="";
		sInnerHTML = "";
		sInnerHTML= sInnerHTML + "<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0 width='100%' align='left' valign='bottom'>"+"\r";
		sInnerHTML= sInnerHTML + "<tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			sInnerHTML= sInnerHTML + "<td rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			
			if(i==(tabStrip.length-1)){
				sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}
			
		}
		sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			sInnerHTML= sInnerHTML + "<td class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r";
			//writeMsg(tabStrip[i][2]);
		}
	
		sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
			}
			if(i==(selectedStrip-1)){
				sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}else{
				sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
			}			
		}
		sInnerHTML= sInnerHTML +"</tr></table>"+"\r";
		sObject.innerHTML=sInnerHTML;
	} 
	function writeMsg(fuc){ 
	    var kk=fuc+"";
	    kk=kk.replace(/</g,"<~");
	    kk=kk.replace(/&/g,"&~");
	    kk=kk.replace(/\r|\n|\r\n/g,"\r\n<br><pre>");
	    traceWin=window.open("","traceWindow","height=600, width=800,scrollbars=yes");
	    traceWin.document.writeln(kk);
	}
	function drawHtmlToObject(oObject,sHtml){
		oObject.innerHTML="";
		oObject.innerHTML=sHtml;
	}
	
	//------------------------Added in 2011/01/17 华润项目组 xyqu  BEGIN---------------------------------------//
	/*
		 * 强制刷新标志
		 * 缺省为false，代表不强制刷新，
		 * 即第一次左击tab项装载该页面，第二次左击直接显示缓存，仅右击时重新装载该页面
		 * 改为true后，左键点击tab页亦重新装载页面
		 */
		var bForceRefreshTab = false;
		var bForceAddTab = false;//true 可新增  false 屏蔽tab新增
		var bForceDeleteTab = true;//可删除 false屏蔽tab删除
		var GbeginTabIndex=0;
		function hc_drawTabToTable_plus_ex(tabStrip,selectedStrip,beginTabIndex,tabLength,hangtbid){
			GbeginTabIndex=beginTabIndex;
			
			if(tabStrip.length == 0) 
				return;
//一、根据开始位置获取相应的显示标签 存放到另一个数组里面 arrTabStrip
	//beginTabIndex 代表的是tabStrip中的位置，一定要区分当前数组和整个数组的区分
			var vBeginIndex=beginTabIndex;
			if (parseInt(vBeginIndex,10)>tabStrip.length-1)
				vBeginIndex=tabStrip.length-1;
			if (parseInt(vBeginIndex,10)<0)
				vBeginIndex=0;
			
			//当前页面展示的标签组
			var arrTabStrip=new Array();
			var vCounter=0;
			for (var i=parseInt(vBeginIndex,10);i<tabStrip.length&&vCounter<tabLength; i++){
				if(tabStrip[i][6]=="del"){
					continue;
				}
				arrTabStrip[vCounter]=new Array();
				for (var j=0;j<tabStrip[i].length;j++){
					arrTabStrip[vCounter][j]=tabStrip[i][j];
				}
				vCounter++;
			}
			var arrTabStrip1=new Array();
			if(vCounter<tabLength){
				var vCounter1=0;
				for (var i=parseInt(vBeginIndex,10)-1;i>=0&&vCounter1<(tabLength-vCounter); i--){
					if(tabStrip[i][6]=="del"){
						continue;
					}
					arrTabStrip1[vCounter1]=new Array();
					for (var j=0;j<tabStrip[i].length;j++){
						arrTabStrip1[vCounter1][j]=tabStrip[i][j];
					}
					vCounter1++;
				}
			}
			//两个数组合并 逻辑是 从开始处往后如果达不到展示的最大数，就从开始处往前再追加直到达到最大展示数
			arrTabStrip=arrTabStrip1.concat(arrTabStrip);
			//不往前追加的话，下面两处是相等的，追加的话arrTabStrip[0][0]肯定小于vBeginIndex 所以在此赋一下值
			vBeginIndex=arrTabStrip[0][0];
	//end
			
			// 支持TAB缓存 多少个tab，增加多少个iframe以容纳其对应的页面
//二、tabStrip每个tab对应一个iframe
			for (var i=0;i<arrTabStrip.length;i++){
				//创建所有的Iframe
				if(document.getElementById(hangtbid+arrTabStrip[i][0])==null){
					//document.all("TabIframeTD").innerHTML += "<iframe id='TabContentFrame"+tabStrip[i][0]+"' name='TabContentFrame"+tabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					var sHTML="<iframe id='"+hangtbid+arrTabStrip[i][0]+"' name='"+hangtbid+arrTabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					document.all("TabIframeTD").insertAdjacentHTML("afterBegin",sHTML);
				}
				//突出显示点击的tab标签
				if(selectedStrip==arrTabStrip[i][0]){
					//显示本TabContentIframe
					document.all(hangtbid+arrTabStrip[i][0]).style.display="block";
				}else{
					//隐藏其他TabContentIframe
					document.all(hangtbid+arrTabStrip[i][0]).style.display="none";
				}
			}	
			//writeMsg(document.all("TabIframeTD").innerHTML);
			var sInnerHTML = "";
			sInnerHTML= sInnerHTML + "<body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0>";
//三、开始生成html***************************大table在此开始
			sInnerHTML= sInnerHTML + "<table cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom' width='100%'><tr>";
			//tab挂靠的table id
			var tabID=hangtbid+"tableID";
			sInnerHTML= sInnerHTML + "<td width='95%'><table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom' width='100%'>"+"\r";
	//1、标签层  对标签的显示隐藏的操作
		//第一行
			sInnerHTML= sInnerHTML + "<tr>\r";
			//一个tab页有三个td组成，前后装饰和中间的tab标题
			for(var i=0; i<arrTabStrip.length; i++){
				var a1="";
				var a2="";
				var a3="";
				var rowspan="3";
				var a4="";
				if(arrTabStrip[i][0]==selectedStrip){
					a2="on";
				}else{
					a2="off";
				}
				if(arrTabStrip[i][0]==(selectedStrip+1)){
					a1="on";
				}else{
					a1="off";
				}
				//第一个tab 如果前面还有很多tab没有展示时，显示一个向左的按钮支持向前移动展示 
				var srcc=sHCResourcesPath+"/tab/1x1.gif";
				if(i==0){
					a1="fr";
					rowspan="2";
					if (parseInt(vBeginIndex,10)>0){
						a3= "plus";
						a4= " alt=\"点击此处左移一格\" style={cursor:hand;} onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(vBeginIndex,10)-1)+","+tabLength+",'"+hangtbid+"');return false;\"";
						srcc=sHCResourcesPath+"/chooser_orange/arrow-left.png";
					}else{
						a3="";
						a4="";
					}
				}
				sInnerHTML= sInnerHTML + "<td rowspan="+rowspan+"><img class='tab"+a1+a2+a3+"'  src='"+srcc+"' "+a4+"></td>"+"\r";
				
				sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				
				//最后一个tab 多增加一个td  如果后面还有很多tab没有展示时，显示一个向右的按钮支持向后移动展示 
				if(i==(arrTabStrip.length-1)){
					if ((arrTabStrip.length+parseInt(vBeginIndex,10))<tabStrip.length){
						a3= "plus";
						a4= " alt=\"点击此处右移一格\" style={cursor:hand} onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(vBeginIndex,10)+1)+","+tabLength+",'"+hangtbid+"');return false;\"";
						sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+a3+"bk'  src='"+sHCResourcesPath+"/chooser_orange/arrow-right.png' "+a4+"></td>"+"\r";
					}else{
						a3="";
						a4="";
						sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+a3+"bk'  src='"+sHCResourcesPath+"/tab/1x1.gif' "+a4+"></td>"+"\r";
					}
				}
			}
			sInnerHTML= sInnerHTML + "</tr>";
	//2、画tab标签
		//第二行
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			for(var i=0; i<arrTabStrip.length; i++){
				var selected="";
				if(arrTabStrip[i][0]==selectedStrip){
					selected="sel";
				}else{
					selected="desel";
				}
				//vBeginIndex是tabStrip中的序号
				var tabid = arrTabStrip[i][0];//parseInt(vBeginIndex,10)+i;
				var sDel = "";
				if(arrTabStrip[i][5]=="1"&&bForceDeleteTab){ 
					sDel = "&nbsp;<span class='deletebtn' valign=top onclick=\"javascript:deleteTabMenu('"+hangtbid+"',"+tabid+","+vBeginIndex+");\">×</span>";
				}
				sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap>" +
											"<span class='tabtext' onclick=\"javascript:myTabAction('"+hangtbid+"',"+tabid+",false)\" oncontextmenu=\"javascript:myTabAction('"+hangtbid+"',"+tabid+",true)\">"+//左键仅仅从缓存中打开tab，右键刷新tab
												arrTabStrip[i][1]+
											"</span>"+sDel+
										"</td>"+"\r";
			}
			sInnerHTML= sInnerHTML + "</tr>\r";
			//end
			
	//3、tab底
		//第三行
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			for(var i=0; i<arrTabStrip.length; i++){
				if(i==0){
					if(arrTabStrip[i][0]==selectedStrip){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}
				if(arrTabStrip[i][0]==selectedStrip){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
				if(i==(arrTabStrip.length-1)){
					if(arrTabStrip[i][0]==selectedStrip){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
				}			
			}
			sInnerHTML= sInnerHTML +"</tr>";
	//4、隐藏层 可存储一些值，让各种事件来获取，相当于一个隐藏变量
		//第四行
			sInnerHTML= sInnerHTML +"<tr><td><input type=hidden id='"+tabID+"_beginIndexID' name='"+tabID+"_beginIndex' value='"+vBeginIndex+"'></td></tr>";
			sInnerHTML= sInnerHTML +"</table></td>\r";
	//tab之table 后面再跟一个table
			sInnerHTML= sInnerHTML + "<td width='5%'><table cellspacing=0 cellpadding=0 border=0 width='100%' align='center' valign='bottom'  style={table-layout:fixed;}><tr>"+"\r";
			//当tab前台展示不下时 增加一个下拉框 展示全部tab
			sInnerHTML= sInnerHTML +"<td nowrap>";
			if (parseInt(vBeginIndex,10)>0 || (arrTabStrip.length+parseInt(vBeginIndex,10))<tabStrip.length){
				sInnerHTML= sInnerHTML +"<span class='tabtext' onClick=\"javascript:showHideTabMenu(this)\" onMouseOver=\"javascript:showTabMenu(this)\">" +
											"<img class='tabmenu' src='"+sHCResourcesPath+"/chooser_orange/arrow02.png'>" +
										"</span>";
			}else{
				sInnerHTML= sInnerHTML +"<img src='"+sHCResourcesPath+"/1x1.gif'>";
			}
			sInnerHTML= sInnerHTML + "</td>";
			//展示新增按钮，可以新增tab
			sInnerHTML= sInnerHTML +"<td nowrap>";
			if(bForceAddTab){
				sInnerHTML= sInnerHTML +"<span class='tabtext' onClick=\"javascript:myTabAdd();showdiv(this);return false;\">" +
							"<img class='tabadd' src='"+sHCResourcesPath+"/new.gif'>" +//可以点击增加tab，可择机实现
							"</span>";
			}else{
				sInnerHTML= sInnerHTML +"<img src='"+sHCResourcesPath+"/1x1.gif'>";
			}
			sInnerHTML= sInnerHTML + "</td>";
			sInnerHTML= sInnerHTML + "</tr></table></td>"+"\r";
			sInnerHTML= sInnerHTML +"</tr></table>\r";
//***************************大table在此结束
			//浮动层，点击下拉框时显示所有的tab 是两个div
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu1\" style=\"z-index:1000;position:absolute;left:0px;right:0px;top:0px;width:0px;height:0px;visibility:hidden;background:green\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\"  cellpadding=4 cellspacing=0  border=0 >\r";
			sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:15px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:hideTabMenu();\">×</span></td></tr>\r";
			for (var i=0;i<tabStrip.length; i++){
				if(tabStrip[i][6]=="del"){
					continue;
				}
				sInnerHTML= sInnerHTML +"<tr>\r";
				var vPre="&nbsp;&nbsp;&nbsp;";
				if (selectedStrip==i)
					vPre=">&nbsp;&nbsp;";
				var vCurBegin=calBiginIndex(i,vBeginIndex);
				var vClickEvent="myTabAction('"+hangtbid+"',"+i+",false,"+vCurBegin+")";
				sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd2\" nowrap onMouseOver=\"this.className='TabMenuTd_down';\" onMouseOut=\"this.className='TabMenuTd2';\" onClick=\""+vClickEvent+"\">\r";
				sInnerHTML= sInnerHTML +vPre+tabStrip[i][1]+"\r";
				sInnerHTML= sInnerHTML +"</td>\r";
				sInnerHTML= sInnerHTML +"</tr>\r";
			}
			sInnerHTML= sInnerHTML +"</table>\r";
			sInnerHTML= sInnerHTML +"</div>\r";
			
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu9\" style=\"z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;visibility:hidden\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\" id='SubMenuTable9' cellpadding=4 cellspacing=0  border=0>\r";
			sInnerHTML= sInnerHTML +"</table>\r";
			sInnerHTML= sInnerHTML +"<iframe id=iframeSelect src=\"javascript:false\" style=\"position:absolute; visibility:inherit; top:0px; left:0px; width:100px; height:200px; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';\"></iframe>"; 
			sInnerHTML= sInnerHTML +"</div>\r" +
			"</body>";
			var sObject=document.getElementById(hangtbid);
			sObject.innerHTML=sInnerHTML;
			if(checkTabAction(selectedStrip))
			{	
				if(tabstrip[selectedStrip][4]!='LOADED'){
					eval(tabstrip[selectedStrip][2]);
					tabstrip[selectedStrip][4]='LOADED';
				}
			}		
		}
		function myTabAction(hangtbid,tabindex,bRefresh,vBegin)
		{
			var tabID=hangtbid+"tableID";
			var iBeginTabIndex = 1;
			if(typeof(document.all(tabID+'_beginIndexID')) != "undefined" && document.all(tabID+'_beginIndexID') != null)
				iBeginTabIndex= document.all(tabID+'_beginIndexID').value;
			if(arguments.length==4) 
				iBeginTabIndex = vBegin;
			if(bForceRefreshTab || bRefresh ){
				if(checkTabAction(tabindex)){
					//打开tab对应的页面内容 起始 [3]和[2]内容一样啦，暂时是这样
					eval(tabstrip[tabindex][3]);
					tabstrip[tabindex][4]='LOADED';
					hc_drawTabToTable_plus_ex(tabstrip,tabindex,iBeginTabIndex,iMaxTabLength,hangtbid);
				}				
			}else{
				if(checkTabAction(tabindex))
				{	
					if(tabstrip[tabindex][4]!='LOADED'){
						eval(tabstrip[tabindex][2]);
						tabstrip[tabindex][4]='LOADED';
					}
					hc_drawTabToTable_plus_ex(tabstrip,tabindex,iBeginTabIndex,iMaxTabLength,hangtbid);
				}		
			}
		}
		//根据tabIndex来计算当打开的新页面时第一个tab的序号currentBeginIndex
		function calBiginIndex(nexttab,currentBeginIndex){
			var vNewCurBegin=currentBeginIndex;
			if(nexttab<currentBeginIndex){
				vNewCurBegin=nexttab;
			}
			//arrTabStrip.length 每一组的标签个数，此判断意思是i到了下一组标签里
			if (nexttab>(parseInt(currentBeginIndex,10)-1+iMaxTabLength))
				vNewCurBegin=nexttab-iMaxTabLength+1;
			return vNewCurBegin;
		}
		//删除一个tab时要解决两个问题
		//1、默认要展示下一组tab是哪些：从当前开始tab往后展示，如果不够最大展示数，就往前排，直到展示到最大数为止，如果达不到就全展示
		//2、默认打开的下一个tab是哪个：从当前删除的tab往后顺延，如果后面没有了，就往前顺延直到一个都没有，这是显示空白页
		//原则就是 先往后再往前
		function deleteTabMenu(hangtbid,tabid,currentBeginIndex){
			//从总的数组中删除 i tab 只是把删除的打上标识，不删除的
			//tabstrip.remove(tabid);
			tabstrip[tabid][6]="del";
			//删除当前tab后默认后一个没有打上 del标识的tab被选中
			var nextSelectedTab=tabid+1;
			//var iBeginTabIndex = calBiginIndex(nextSelectedTab,currentBeginIndex);
			var iBeginTabIndex=currentBeginIndex;
			if(tabid==currentBeginIndex){
				iBeginTabIndex=tabid+1;
			}
			//检查下一个tab合法后打开，已加载的只是展示出来
			if(checkTabAction(nextSelectedTab)){	
				if(tabstrip[nextSelectedTab][4]!='LOADED'){
					eval(tabstrip[nextSelectedTab][2]);
					tabstrip[nextSelectedTab][4]='LOADED';
				}
				hc_drawTabToTable_plus_ex(tabstrip,nextSelectedTab,iBeginTabIndex,iMaxTabLength,hangtbid);
			}		
		}
		function showdiv(obj){
			if (document.all('tabMenu9').style.visibility=='visible') {
				var tableObj = document.getElementById("SubMenuTable9");
				var v_i = 0 ; 
				var v_count = tableObj.rows.length;
				for(;v_i<v_count;v_i++)
				{
					tableObj.deleteRow(0);
				}
				document.all('tabMenu9').style.visibility='hidden';
			}else{
				var xPos = obj.offsetLeft;
				var tempEl = obj.offsetParent;
				while (tempEl != null){
					xPos += tempEl.offsetLeft;
					tempEl = tempEl.offsetParent;
				};
				document.all('tabMenu9').style.left = xPos + obj.offsetWidth-document.all('adddiv').offsetWidth;
				document.all('tabMenu9').style.top = event.offsetY+obj.offsetHeight+10;
				document.all('tabMenu9').style.width = obj.offsetWidth;
				document.all('tabMenu9').style.visibility='visible';
				//add in 2009/08/20
				document.all('iframeSelect').style.height = document.all('tabMenu9').offsetHeight;;
				document.all('iframeSelect').style.width = document.all('tabMenu9').offsetWidth;
			}
		}
		function showTabMenu(obj){
			var xPos = obj.offsetLeft;
			var yPos = obj.offsetTop;
			var tempEl = obj.offsetParent;
			while (tempEl != null){
				xPos += tempEl.offsetLeft;
				yPos += tempEl.offsetTop;
				tempEl = tempEl.offsetParent;
			};
			document.all('tabMenu1').style.left = xPos*0.84-document.all('tabMenu1').offsetWidth;
			document.all('tabMenu1').style.top = yPos*0.84-obj.offsetHeight;
			document.all('tabMenu1').style.width = obj.offsetWidth;
			document.all('tabMenu1').style.visibility='visible';
			return false;
		}
		//显示及隐藏tab菜单
		function showHideTabMenu(obj){
			if (document.all('tabMenu1').style.visibility=='visible') {
				hideTabMenu();
				return false;
			}else{
				showTabMenu(obj);
				return false;
			}
		}
		function hideTabMenu(){
				try{
					document.all('tabMenu1').style.visibility='hidden';
				}catch(e){}
				return false;
		}
		//用于检查Tab动作合法性，如果返回false，则tab不切换
		function checkTabAction(iTabStrip){
			return true;
		}
		function addTabMenu(tabNo,tabDesc){
			var tableObj = document.getElementById("SubMenuTable9");
			try
			{
				var trs = tableObj.rows.length;
				var newTr = tableObj.insertRow(trs);
				var newTD = newTr.insertCell(0);
				//alert(newTD);
				newTr.style.height=3;
				newTr.style.width=60; 
				newTD.className = "TabMenuTd1";
				newTD.noWrap=true;
				newTD.innerHTML = tabDesc;
				newTr.id = tabNo;
				newTr.onclick = function(){onSelectTab(tabNo);};
				newTD.onmouseover = function(){this.className="TabMenuTd_down";};
				newTD.onmouseout = function(){this.className="TabMenuTd2";};
			}
			catch(e)
			{
				alert(e.message);
			}
		}
		
		function onSelectTab(tabno)
		{
			
		}
		function myTabAdd()
		{
			//在程序里自己实现 
			//alert("新增...");
		}	
		
	//------------------------Added in 2011/01/17 华润项目组 xyqu  END---------------------------------------//