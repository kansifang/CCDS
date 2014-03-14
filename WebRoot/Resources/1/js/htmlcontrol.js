//var sHCResourcesPath = "/amarbank6/Resources/1";
var sHCResourcesPath = sResourcesPath;
var iCurButtonID = 1;


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
		//alert(result);
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

	function hc_drawTabToTable(tabID, tabStrip,selectedStrip,sObject){
		
		sObject.innerHTML="";
		sInnerHTML = "";
		sInnerHTML= sInnerHTML + "<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'>"+"\r";
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
			sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r";

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
		
		function hc_drawTabToTable_plus(tabID, tabStrip,selectedStrip,sObject,beginTabIndex,tabLength){

			//added by byhu 20070726 支持TAB缓存
			/*
			for (var i=0;i<tabStrip.length;i++){
				//创建所有的Iframe
				if(document.getElementById("TabContentFrame"+i)==null){
					document.all("TabIframeTD").innerHTML += "<iframe id='TabContentFrame"+i+"' name='TabContentFrame"+i+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
				}
			}
			for (var i=0;i<tabStrip.length;i++){
				if((selectedStrip-1)==i){
					//显示本TabContentIframe
					document.all("TabContentFrame"+i).style.display="";
				}else{
					//隐藏其他TabContentIframe
					try{
						document.all("TabContentFrame"+i).style.display="none";
					}catch(e){}
				}
			}
			*/
			for (var i=0;i<tabStrip.length;i++){
				//创建所有的Iframe
				if(document.getElementById(tabID+i)==null){
					document.all("TabIframeTD").innerHTML += "<iframe id='"+tabID+i+"' name='"+tabID+i+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
				}
			}
			for (var i=0;i<tabStrip.length;i++){
				if((selectedStrip-1)==i){
					//显示本TabContentIframe
					document.all(tabID+i).style.display="";
				}else{
					//隐藏其他TabContentIframe
					try{
						document.all(tabID+i).style.display="none";
					}catch(e){}
				}
			}
			
			
			
			
			
					
			
			//begin
			var vBeginIndex=beginTabIndex;
			if (parseInt(vBeginIndex,10)>tabStrip.length)
				vBeginIndex=tabStrip.length;
			if (parseInt(vBeginIndex,10)<1)
				vBeginIndex=1;
			var vSelectedStrip=selectedStrip-parseInt(vBeginIndex,10)+1;
			var arrTabStrip=new Array();
			var vCounter=0;
			for (var i=(parseInt(vBeginIndex,10)-1);i<tabStrip.length; i++){
				if (vCounter<tabLength){
					arrTabStrip[vCounter]=new Array();
					for (var j=0;j<tabStrip[i].length;j++){
						arrTabStrip[vCounter][j]=tabStrip[i][j];
					}
				}else{
					break;
				}
				vCounter++;
			}
			//end
			
			sObject.innerHTML="";
			sInnerHTML = "";

			sInnerHTML= sInnerHTML + "<body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0 ><table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom' width=100%>"+"\r";
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				var a1="";
				var a2="";
				var a3="";
				var rowspan="3";
				//added by byhu
				var a4="";
				
				if(i==(vSelectedStrip-1)){
					a2="on";
				}else{
					a2="off";
				}
				if(i==(vSelectedStrip)){
					a1="on";
				}else{
					a1="off";
				}
				if(i==0){
					a1="fr";
					rowspan="2";
					//begin
					if (parseInt(vBeginIndex,10)>1){
						a3= "plus";
						//added by byhu 20070726
						a4= " alt=\"点击此处左移一格\" style={cursor:hand;} onClick=\"javascript:hc_drawTabToTable_plus('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)-1)+","+tabLength+");return false;\"";
					}else{
						a3="";
						//added by byhu 20070726
						a4="";
					}
					//end
				}
				
				sInnerHTML= sInnerHTML + "<td rowspan="+rowspan+"><img class='tab"+a1+a2+a3+"'  src='"+sHCResourcesPath+"/1x1.gif' "+a4+"></td>"+"\r";
				sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				
				if(i==(arrTabStrip.length-1)){
					//begin
					if ((arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
						a3= "plus";
						//added by byhu 20070726
						a4= " alt=\"点击此处右移一格\" style={cursor:hand} onClick=\"javascript:hc_drawTabToTable_plus('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)+1)+","+tabLength+");return false;\"";
					}else{
						a3="";
						//added by byhu 20070726
						a4="";
					}
					//end
					sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+a3+"bk'  src='"+sHCResourcesPath+"/1x1.gif' "+a4+"></td>"+"\r";
				}
				
			}
			sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				var selected="";
				if(i==(vSelectedStrip-1)){
					selected="sel";
				}else{
					selected="desel";
				}
				sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\"if(bForceRefreshTab){"+arrTabStrip[i][3]+"}else{"+arrTabStrip[i][2]+"}\" oncontextmenu=\""+arrTabStrip[i][3]+"\">"+arrTabStrip[i][1]+"</span></td>"+"\r";

			}
		
			//begin
			if (parseInt(vBeginIndex,10)>1 || (arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
				sInnerHTML= sInnerHTML +"<td align=right width=100%><table cellspacing=0 cellpadding=0 border=0><tr>";
				if (parseInt(vBeginIndex,10)>1){
					sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:hc_drawTabToTable_plus('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)-1)+","+tabLength+");return false;\"><img class='tabpre' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabpredisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				if ((arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
					sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:hc_drawTabToTable_plus('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)+1)+","+tabLength+");return false;\"><img class='tabnext' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabnextdisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				//sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:if (document.all('tabMenu1').style.visibility=='visible') {document.all('tabMenu1').style.visibility='hidden';return false;};document.all('tabMenu1').style.visibility=='hidden';var xPos = this.offsetLeft;var tempEl = this.offsetParent;while (tempEl != null){xPos += tempEl.offsetLeft;tempEl = tempEl.offsetParent;};document.all('tabMenu1').style.left=xPos;var yPos = this.offsetTop;tempEl = this.offsetParent;while (tempEl != null){yPos += tempEl.offsetTop;tempEl = tempEl.offsetParent;};document.all('tabMenu1').style.top=yPos;document.all('tabMenu1').style.width=this.offsetWidth;document.all('tabMenu1').style.visibility='visible'; return false;\"><img class='tabmenu' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:showHideTabMenu(this)\" onMouseOver=\"javascript:showTabMenu(this)\"><img class='tabmenu' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				sInnerHTML= sInnerHTML +"</tr></table></td>";
			}else{//added by byhu
				sInnerHTML= sInnerHTML +"<td align=right width=100%></td>";
			}
			//end
			
			sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				if(i==0){
					if(i==(vSelectedStrip-1)){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}
				if(i==(vSelectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
				if(i==(arrTabStrip.length-1)){
					if(i==(vSelectedStrip-1)){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}			
				
				
			}
			
			//sInnerHTML= sInnerHTML +"</tr></table>"+"\r";
			//begin
			sInnerHTML= sInnerHTML +"</tr><tr><td><input type=hidden id='"+tabID+"_beginIndexID' name='"+tabID+"_beginIndex' value='"+vBeginIndex+"'></td></tr></table>\r";
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu1\" style=\"z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;visibility:hidden\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\"  cellpadding=4 cellspacing=0  border=0>\r";
			sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:8px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:hideTabMenu();\">×</span></td></tr>\r";
			for (var i=0;i<tabStrip.length; i++){
				sInnerHTML= sInnerHTML +"<tr>\r";
				var vPre="&nbsp;&nbsp;&nbsp;";
				if ((selectedStrip-1)==i)
					vPre=">&nbsp;&nbsp;";
					//sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd1\" nowrap>&nbsp;V&nbsp;&nbsp;</td>\r";
				//else
					//sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd1\" nowrap>&nbsp;&nbsp;&nbsp;</td>\r";
				var vCurBegin=vBeginIndex;
				if ((i+1)<vBeginIndex)
					vCurBegin=(i+1);
				if ((i+1)>(arrTabStrip.length+parseInt(vBeginIndex,10)-1))
					vCurBegin=vBeginIndex+((i+1)-(arrTabStrip.length+parseInt(vBeginIndex,10)-1));
				var vClickEvent=tabStrip[i][2];
				var vReplaceStr=",document.all('"+tabID+"_beginIndexID').value,";
				var vPos=vClickEvent.indexOf(vReplaceStr);
				if (vPos>=0){
					vClickEvent=vClickEvent.substring(0,vPos)+","+vCurBegin+","+vClickEvent.substring(vPos+vReplaceStr.length);
				}
				sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd2\" nowrap onMouseOver=\"this.className='TabMenuTd_down';\" onMouseOut=\"this.className='TabMenuTd2';\" onClick=\""+vClickEvent+"\">\r";
				sInnerHTML= sInnerHTML +vPre+tabStrip[i][1]+"\r";
				sInnerHTML= sInnerHTML +"</td>\r";
				sInnerHTML= sInnerHTML +"</tr>\r";
			}
			sInnerHTML= sInnerHTML +"</table>\r";
			sInnerHTML= sInnerHTML +"</div>\r</body>";
			//end
			sObject.innerHTML=sInnerHTML;
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
		function showTabMenu(obj){
			var xPos = obj.offsetLeft;
			var tempEl = obj.offsetParent;
			while (tempEl != null){
				xPos += tempEl.offsetLeft;
				tempEl = tempEl.offsetParent;
			};
			document.all('tabMenu1').style.left = xPos + obj.offsetWidth-document.all('tabMenu1').offsetWidth;
			document.all('tabMenu1').style.top = event.offsetY+obj.offsetHeight;
			document.all('tabMenu1').style.width = obj.offsetWidth;
			document.all('tabMenu1').style.visibility='visible';
			return false;
		}
		
		//用于检查Tab动作合法性，如果返回false，则tab不切换
		function checkTabAction(iTabStrip){
			return true;
		}

		//add in 2009/07
		function hc_createTabIFrame_plus_ex(tabStrip)
		{
			//added by byhu 20070726 支持TAB缓存		
			for (var i=0;i<tabStrip.length;i++){
				//创建所有的Iframe
				if(document.getElementById("TabContentFrameArr"+tabStrip[i][0])==null){

					//document.all("TabIframeTD").innerHTML += "<iframe id='TabContentFrame"+tabStrip[i][0]+"' name='TabContentFrame"+tabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					var sHTML="<iframe id='TabContentFrameArr"+tabStrip[i][0]+"' name='TabContentFrameArr"+tabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					document.all("TabIframeTD").insertAdjacentHTML("afterBegin",sHTML);
		
				}
			}
			
			
		}
		
		function hc_drawTabToTable_plus_ex(tabID, tabStrip,selectedStrip,sObject,beginTabIndex,tabLength){
		  //alert("hc_drawTabToTable_plus_ex..."+selectedStrip+","+beginTabIndex);
			//alert(tabStrip.length	);
			if(tabStrip.length == 0) return;
			
			hc_createTabIFrame_plus_ex(tabStrip);	
			
			for (var i=0;i<tabStrip.length;i++){
				if((selectedStrip-1)==i){
					//显示本TabContentIframe
					document.all("TabContentFrameArr"+tabStrip[i][0]).style.display="block";
				}else{
					//隐藏其他TabContentIframe
					try{
						document.all("TabContentFrameArr"+tabStrip[i][0]).style.display="none";
					}catch(e){}
				}
			}
			
			/*
			alert("hc_drawTabToTable_plus_ex..."+document.all("TabContentFrame"+tabStrip[selectedStrip-1][0]).style.display);
			alert("hc_drawTabToTable_plus_ex..."+document.all("TabContentFrame"+tabStrip[selectedStrip-1][0]).outerHTML);
			*/
			//var myobj = eval("TabContentFrame"+tabStrip[selectedStrip-1][0]);
			//alert(myobj.document.URL);
			
			
			//begin
			var vBeginIndex=beginTabIndex;
			if (parseInt(vBeginIndex,10)>tabStrip.length)
				vBeginIndex=tabStrip.length;
			if (parseInt(vBeginIndex,10)<1)
				vBeginIndex=1;
			var vSelectedStrip=selectedStrip-parseInt(vBeginIndex,10)+1;
			var arrTabStrip=new Array();
			var vCounter=0;
			for (var i=(parseInt(vBeginIndex,10)-1);i<tabStrip.length; i++){
				if (vCounter<tabLength){
					arrTabStrip[vCounter]=new Array();
					for (var j=0;j<tabStrip[i].length;j++){
						arrTabStrip[vCounter][j]=tabStrip[i][j];
					}
				}else{
					break;
				}
				vCounter++;
			}
			//end
			
			sObject.innerHTML="";
			sInnerHTML = "";

			sInnerHTML= sInnerHTML + "<body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0 ><table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom' width=100%>"+"\r";
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				var a1="";
				var a2="";
				var a3="";
				var rowspan="3";
				//added by byhu
				var a4="";
				
				if(i==(vSelectedStrip-1)){
					a2="on";
				}else{
					a2="off";
				}
				if(i==(vSelectedStrip)){
					a1="on";
				}else{
					a1="off";
				}
				if(i==0){
					a1="fr";
					rowspan="2";
					//begin
					if (parseInt(vBeginIndex,10)>1){
						a3= "plus";
						//added by byhu 20070726
						a4= " alt=\"点击此处左移一格\" style={cursor:hand;} onClick=\"javascript:hc_drawTabToTable_plus_ex('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)-1)+","+tabLength+");return false;\"";
					}else{
						a3="";
						//added by byhu 20070726
						a4="";
					}
					//end
				}
				
				sInnerHTML= sInnerHTML + "<td rowspan="+rowspan+"><img class='tab"+a1+a2+a3+"'  src='"+sHCResourcesPath+"/1x1.gif' "+a4+"></td>"+"\r";
				sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				
				if(i==(arrTabStrip.length-1)){
					//begin
					if ((arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
						a3= "plus";
						//added by byhu 20070726
						a4= " alt=\"点击此处右移一格\" style={cursor:hand} onClick=\"javascript:hc_drawTabToTable_plus_ex('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)+1)+","+tabLength+");return false;\"";
					}else{
						a3="";
						//added by byhu 20070726
						a4="";
					}
					//end
					sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+a3+"bk'  src='"+sHCResourcesPath+"/1x1.gif' "+a4+"></td>"+"\r";
				}
				
			}
			sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				var selected="";
				if(i==(vSelectedStrip-1)){
					selected="sel";
				}else{
					selected="desel";
				}
				//sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\"if(bForceRefreshTab){"+arrTabStrip[i][3]+"}else{"+arrTabStrip[i][2]+"}\" oncontextmenu=\""+arrTabStrip[i][3]+"\">"+arrTabStrip[i][1]+"</span></td>"+"\r";
				var iTemp = parseInt(vBeginIndex,10)-1+i;
				var sDel = "";
				if(arrTabStrip[i][5]=="1"&&bForceDeleteTab) sDel = "&nbsp;<span class=deletebtn valign=top ><a title='删除' href=\"javascript:myTabDelete("+iTemp+")\"></a></span>";
				sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\"javascript:myTabAction("+iTemp+",false)\" oncontextmenu=\"javascript:myTabAction("+iTemp+",true)\">"+arrTabStrip[i][1]+"</span>"+sDel+"</td>"+"\r";
			}
		
			sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
		
			//begin
			if (parseInt(vBeginIndex,10)>1 || (arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
				sInnerHTML= sInnerHTML +"<td align=left width=100%><table cellspacing=0 cellpadding=0 border=0><tr>";

				if (parseInt(vBeginIndex,10)>1){
					sInnerHTML= sInnerHTML +"<td><a href='#' title='前一个Tab' onClick=\"javascript:hc_drawTabToTable_plus_ex('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)-1)+","+tabLength+");return false;\"><img class='tabpre' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabpredisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				if ((arrTabStrip.length+parseInt(vBeginIndex,10)-1)<tabStrip.length){
					sInnerHTML= sInnerHTML +"<td><a href='#' title='后一个Tab' onClick=\"javascript:hc_drawTabToTable_plus_ex('"+tabID+"',tabstrip,"+selectedStrip+",document.all('"+sObject.id+"'),"+(parseInt(beginTabIndex,10)+1)+","+tabLength+");return false;\"><img class='tabnext' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabnextdisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				//sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:if (document.all('tabMenu1').style.visibility=='visible') {document.all('tabMenu1').style.visibility='hidden';return false;};document.all('tabMenu1').style.visibility=='hidden';var xPos = this.offsetLeft;var tempEl = this.offsetParent;while (tempEl != null){xPos += tempEl.offsetLeft;tempEl = tempEl.offsetParent;};document.all('tabMenu1').style.left=xPos;var yPos = this.offsetTop;tempEl = this.offsetParent;while (tempEl != null){yPos += tempEl.offsetTop;tempEl = tempEl.offsetParent;};document.all('tabMenu1').style.top=yPos;document.all('tabMenu1').style.width=this.offsetWidth;document.all('tabMenu1').style.visibility='visible'; return false;\"><img class='tabmenu' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";
				sInnerHTML= sInnerHTML +"<td><a href='#' onClick=\"javascript:showHideTabMenu(this)\" onMouseOver1=\"javascript:showTabMenu(this)\"><img class='tabmenu' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>\r";

				
			
				//add in 2009/07 for add_tab
				if(bForceAddTab){
				sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
				sInnerHTML= sInnerHTML + "<td><a href='#' title='新增...' onClick=\"javascript:myTabAdd();return false;\"><img class='tabadd' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>"+"\r";
				}else {
				sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
				sInnerHTML= sInnerHTML + "<td nowrap></td>"+"\r";
				}
				sInnerHTML= sInnerHTML +"</tr></table></td>";
			}else{//added by byhu
				if(bForceAddTab){
				//add in 2009/07 for add_tab
				sInnerHTML= sInnerHTML + "<td id=adddiv><a href='#' title='新增...' onClick=\"javascript:myTabAdd();showdiv(this);return false;\"><img class='tabadd' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>"+"\r";
				sInnerHTML= sInnerHTML +"<td align=right width=100% ></td>";
				}else {
					sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
					sInnerHTML= sInnerHTML + "<td align=right width=100%> </td>"+"\r";
				}
			}
			//end

			
			
			sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
			
			for(var i=0; i<arrTabStrip.length; i++){
				if(i==0){
					if(i==(vSelectedStrip-1)){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}
				if(i==(vSelectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
				if(i==(arrTabStrip.length-1)){
					if(i==(vSelectedStrip-1)){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}			
				
				
			}
			
			//sInnerHTML= sInnerHTML +"</tr></table>"+"\r";
			//begin
			sInnerHTML= sInnerHTML +"</tr><tr><td><input type=hidden id='"+tabID+"_beginIndexID' name='"+tabID+"_beginIndex' value='"+vBeginIndex+"'></td></tr></table>\r";
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu1\" style=\"z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;visibility:hidden\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\"  cellpadding=4 cellspacing=0  border=0>\r";
			sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:8px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:hideTabMenu();\">×</span></td></tr>\r";
			for (var i=0;i<tabStrip.length; i++){
				sInnerHTML= sInnerHTML +"<tr>\r";
				var vPre="&nbsp;&nbsp;&nbsp;";
				if ((selectedStrip-1)==i)
					vPre=">&nbsp;&nbsp;";
					//sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd1\" nowrap>&nbsp;V&nbsp;&nbsp;</td>\r";
				//else
					//sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd1\" nowrap>&nbsp;&nbsp;&nbsp;</td>\r";
				var vCurBegin=vBeginIndex;
				if ((i+1)<vBeginIndex)
					vCurBegin=(i+1);
				if ((i+1)>(arrTabStrip.length+parseInt(vBeginIndex,10)-1))
					//vCurBegin=vBeginIndex+((i+1)-(arrTabStrip.length+parseInt(vBeginIndex,10)-1));
					vCurBegin=parseInt(vBeginIndex,10)+((i+1)-(arrTabStrip.length+parseInt(vBeginIndex,10)-1));
			
				//var vClickEvent=tabStrip[i][2];
				//var vReplaceStr=",document.all('"+tabID+"_beginIndexID').value,";
				//var vPos=vClickEvent.indexOf(vReplaceStr);
				//if (vPos>=0){
				//	vClickEvent=vClickEvent.substring(0,vPos)+","+vCurBegin+","+vClickEvent.substring(vPos+vReplaceStr.length);
				//}
				var vClickEvent="myTabAction("+i+",false,"+vCurBegin+")";
			

				sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd2\" nowrap onMouseOver=\"this.className='TabMenuTd_down';\" onMouseOut=\"this.className='TabMenuTd2';\" onClick=\""+vClickEvent+"\">\r";
				sInnerHTML= sInnerHTML +vPre+tabStrip[i][1]+"\r";
				sInnerHTML= sInnerHTML +"</td>\r";
				sInnerHTML= sInnerHTML +"</tr>\r";
			}
			sInnerHTML= sInnerHTML +"</table>\r";
			sInnerHTML= sInnerHTML +"</div>\r";
			//end---------------------------------------平安增加
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu9\" style=\"z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;visibility:hidden\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\" id='SubMenuTable9' cellpadding=4 cellspacing=0  border=0>\r";
			//sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:8px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:showdiv();\">×</span></td></tr>\r";
			
			sInnerHTML= sInnerHTML +"</table>\r";

			//add in 2009/08/20
			sInnerHTML= sInnerHTML +"<iframe id=iframeSelect src=\"javascript:false\" style=\"position:absolute; visibility:inherit; top:0px; left:0px; width:100px; height:200px; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';\"></iframe>"; 

			sInnerHTML= sInnerHTML +"</div>\r</body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0 >";
			
			//delete in 2009/08/20
			//sInnerHTML= sInnerHTML +"<iframe  style=\"position:absolute;z-index:-1;width:e-xpression(this.nextSibling.offsetWidth);height:e-xpression(this.nextSibling.offsetHeight);top:e-xpression(this.nextSibling.offsetTop);left:e-xpression(this.nextSibling.offsetLeft);visibility:hidden;\"   frameborder=0>";
			//sInnerHTML= sInnerHTML +" </iframe>";
		
			//-----------------------------------------------平安
			sObject.innerHTML=sInnerHTML;
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
		
		function addTabMenu(tabNo,tabDesc){
			var tableObj = document.getElementById("SubMenuTable9");
			/*sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:8px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:showdiv();\">×</span></td></tr>\r";
			sInnerHTML= sInnerHTML +"<td class=\"TabMenuTd1\" nowrap>&nbsp;测试&nbsp;&nbsp;</td>\r";
			sInnerHTML= sInnerHTML +"</tr>\r";
			*/
			
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
		function myTabAction(i,bRefresh,vBegin)
		{
				var iBeginTabIndex = 1
				if(typeof(document.all('tab_DeskTopInfo_beginIndexID')) != "undefined" && document.all('tab_DeskTopInfo_beginIndexID') != null)
					iBeginTabIndex= document.all('tab_DeskTopInfo_beginIndexID').value;
				
				if(arguments.length==3) 
					iBeginTabIndex = vBegin;
								
				//sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\"if(bForceRefreshTab){"+arrTabStrip[i][3]+"}else{"+arrTabStrip[i][2]+"}\" oncontextmenu=\""+arrTabStrip[i][3]+"\">"+arrTabStrip[i][1]+"</span></td>"+"\r";
				//sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\"javascript:myTabAction("+i+",false)\" oncontextmenu=\"javascript:myTabAction("+i+",true)\">"+arrTabStrip[i][1]+"</span></td>"+"\r";
				if(bForceRefreshTab || bRefresh )
				{
					if(checkTabAction(i)!=false)
					{
						if(true){						
							eval(tabstrip[i][3]);////OpenComp('ProductApplyTabList','/Common/Configurator/CreditPolicy/ProductApplyTabList.jsp','ObjectType=ProductTypeTab&ObjectNo=2020110&ComponentName=信息项配置&ToInheritObj=y','TabContentFrame7');
							tabstrip[i][4]='LOADED';
						}
						hc_drawTabToTable_plus_ex('tab_DeskTopInfo',tabstrip,i+1,document.all('tabtd'),iBeginTabIndex,iMaxTabLength);
					}				
				}
				else
				{
					if(checkTabAction(i)!=false)
					{	
						if(tabstrip[i][4]!='LOADED'){
							eval(tabstrip[i][2]);
							tabstrip[i][4]='LOADED';
						}
						hc_drawTabToTable_plus_ex('tab_DeskTopInfo',tabstrip,i+1,document.all('tabtd'),iBeginTabIndex,iMaxTabLength);
					}		
				}
		}
		
		function myTabDelete(i)
		{
			//在程序里自己实现 
			//alert("删除..."+i);
		}
		function myTabAdd()
		{
			//在程序里自己实现 
			//alert("新增...");
		}	
		
	//------------------------Added in 2011/01/17 华润项目组 xyqu  END---------------------------------------//