//var sHCResourcesPath = "/amarbank6/Resources/1";
var sHCResourcesPath = sResourcesPath;
var iCurButtonID = 1;
/** 
*ɾ������ָ���±��ָ������ 
*/ 
Array.prototype.remove=function(obj){ 
	for(var i =0;i <this.length;i++){ 
		var temp = this[i]; 
		if(!isNaN(obj)){ 
			temp=i; 
		} 
		if(temp == obj){ 
			//this[i]=null;//�˴��Ǵ�λ���ÿգ����Ȳ��䣬�������Ǵ�λ�ú����������ǰһλ�����ȼ�һ
			for(var j = i;j <this.length;j++){ 
				this[j]=this[j+1]; 
			} 
			this.length = this.length-1; 
		} 
	} 
};
/***button*/

/**��ʾһ��button*/

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
			if (sText.indexOf("����") >= 0) iconCls = "btn_icon_add";
			if (sText.indexOf("����") >= 0) iconCls = "btn_icon_detail";
			if (sText.indexOf("ɾ��") >= 0) iconCls = "btn_icon_delete";
			if (sText.indexOf("�ύ") >= 0) iconCls = "btn_icon_submit";
			if (sText.indexOf("����") >= 0) iconCls = "btn_icon_save";
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
	//���볬ʱ���ƣ���ֹ����
	setTimeout(function overButtonIn(){
		document.getElementById('buttonmiddletd'+iButtonID).className='buttonHover';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgHover';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgHover';
	}, 1); 
}

function outButton(iButtonID){
	//���볬ʱ���ƣ���ֹ����
    setTimeout(function outButtonIn(){
		document.getElementById('buttonmiddletd'+iButtonID).className='button';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimg';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimg';
	}, 1); 
}

function overImgButton(obj,cname){
	//���볬ʱ���ƣ���ֹ����
    setTimeout(function overImgButtonIn(){
		obj.className=cname+'_hover';
	}, 1); 
}

function outImgButton(obj,cname){
	//���볬ʱ���ƣ���ֹ����
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

/**��ʾһ��button*/
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



/**��ʾһ��inputbox*/
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


/**��ʾfreeform*/
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
			//ȡ��colspan
			temp=obj[j][3];
			if(temp==""){
				colspan = defaultColspan;
			}else{
				colspan = temp;
			}

			//ȡ��position
			temp=obj[j][4];
			if(temp==""){
				position = defaultPosition;
			}else{
				position = temp;
			}

			//��ʾ<tr>
			if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns = totalColumns;
				document.write("<tr height='8'></tr><tr>");
			}

			//��ʾ����
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

			//��ʾ</tr>
			
			if (position=="FULLROW"){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns=0;
			}
		}

		document.write("</table>");
}

/**��ʾһ��tab*/		
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
	//sObject=td
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
	
	//------------------------Added in 2011/01/17 ������Ŀ�� xyqu  BEGIN---------------------------------------//
	/*
		 * ǿ��ˢ�±�־
		 * ȱʡΪfalse������ǿ��ˢ�£�
		 * ����һ�����tab��װ�ظ�ҳ�棬�ڶ������ֱ����ʾ���棬���һ�ʱ����װ�ظ�ҳ��
		 * ��Ϊtrue��������tabҳ������װ��ҳ��
		 */
		var bForceRefreshTab = false;
		var bForceAddTab = false;//true ������  false ����tab����
		var bForceDeleteTab = true;//��ɾ�� false����tabɾ��
		var GbeginTabIndex=0;
		function hc_drawTabToTable_plus_ex(tabStrip,selectedStrip,beginTabIndex,tabLength,hangtbid){
			GbeginTabIndex=beginTabIndex;
			var tabID=hangtbid+"tableID";
			var sObject=document.getElementById(hangtbid);
			if(tabStrip.length == 0) return;
			// ֧��TAB���� ���ٸ�tab�����Ӷ��ٸ�iframe���������Ӧ��ҳ��
			for (var i=0;i<tabStrip.length;i++){
				//�������е�Iframe
				if(document.getElementById(hangtbid+tabStrip[i][0])==null){
					//document.all("TabIframeTD").innerHTML += "<iframe id='TabContentFrame"+tabStrip[i][0]+"' name='TabContentFrame"+tabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					var sHTML="<iframe id='"+hangtbid+tabStrip[i][0]+"' name='"+hangtbid+tabStrip[i][0]+"' src='' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>";
					document.all("TabIframeTD").insertAdjacentHTML("afterBegin",sHTML);
				}
			}	
			//ͻ����ʾ�����tab��ǩ
			for (var i=0;i<tabStrip.length;i++){
				if(selectedStrip==i){
					//��ʾ��TabContentIframe
					document.all(hangtbid+tabStrip[i][0]).style.display="block";
				}else{
					//��������TabContentIframe
					try{
						document.all(hangtbid+tabStrip[i][0]).style.display="none";
					}catch(e){}
				}
			}
			//writeMsg(document.all("TabIframeTD").innerHTML);
			//begin �������tabStrip�е�λ�ã�һ��Ҫ���ֵ�ǰ������������������
			var vBeginIndex=beginTabIndex;
			if (parseInt(vBeginIndex,10)>tabStrip.length-1)
				vBeginIndex=tabStrip.length-1;
			if (parseInt(vBeginIndex,10)<0)
				vBeginIndex=0;
			//selectedStrip����������tabStrip�������ţ�vSelectedStrip�ǵ�ǰӦ��չʾ������arrTabStrip�е����
			//����Ҫչʾ 3,4,5,6,7���������selectedStrip=7����ô���������� 7����ž���4���ɲ��� 7-3
			var vSelectedStrip=selectedStrip-parseInt(vBeginIndex,10);
			var arrTabStrip=new Array();
			var vCounter=0;
			//���ݿ�ʼλ�û�ȡ��Ӧ����ʾ��ǩ
			for (var i=parseInt(vBeginIndex,10);i<tabStrip.length; i++){
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
			sInnerHTML= sInnerHTML + "<body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0 >";
			sInnerHTML= sInnerHTML + "<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom' width=100%>"+"\r";
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			//�Ա�ǩ����ʾ���صĲ���
			for(var i=0; i<arrTabStrip.length; i++){
				if(arrTabStrip[i][6]=="del")continue;//����ɾ����־�Ĳ�����ʾ
				var a1="";
				var a2="";
				var a3="";
				var rowspan="3";
				var a4="";
				if(i==vSelectedStrip){
					a2="on";
				}else{
					a2="off";
				}
				if(i==(vSelectedStrip+1)){
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
						a4= " alt=\"����˴�����һ��\" style={cursor:hand;} onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(beginTabIndex,10)-1)+","+tabLength+","+hangtbid+");return false;\"";
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
					if ((arrTabStrip.length+parseInt(vBeginIndex,10))<tabStrip.length){
						a3= "plus";
						a4= " alt=\"����˴�����һ��\" style={cursor:hand} onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(beginTabIndex,10)+1)+","+tabLength+","+hangtbid+");return false;\"";
					}else{
						a3="";
						a4="";
					}
					//end
					sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+a3+"bk'  src='"+sHCResourcesPath+"/1x1.gif' "+a4+"></td>"+"\r";
				}
			}
			sInnerHTML= sInnerHTML + "</tr>";
			//��tab��ǩ
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			for(var i=0; i<arrTabStrip.length; i++){
				if(arrTabStrip[i][6]=="del")continue;
				var selected="";
				if(i==vSelectedStrip){
					selected="sel";
				}else{
					selected="desel";
				}
				var iTemp = arrTabStrip[i][0];//parseInt(vBeginIndex,10)+i;//vBeginIndex��tabStrip�е����
				var sDel = "";
				if(arrTabStrip[i][5]=="1"&&bForceDeleteTab) 
					sDel = "&nbsp;<span class=deletebtn valign=top onclick=\"javascript:deleteTabMenu('"+hangtbid+"',"+iTemp+","+beginTabIndex+")\"><a title='ɾ��' href=\"javascript:myTabDelete("+iTemp+")\">��</a></span>";
				sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap>" +
										"<span class='tabtext' onclick=\"javascript:myTabAction('"+hangtbid+"',"+iTemp+",false)\" oncontextmenu=\"javascript:myTabAction('"+hangtbid+"',"+iTemp+",true)\">"+
										arrTabStrip[i][1]+
										"</span>"+sDel+"</td>"+"\r";
			}
			sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
			//begin tabǰ�������
			if (parseInt(vBeginIndex,10)>0 || (arrTabStrip.length+parseInt(vBeginIndex,10))<tabStrip.length){
				sInnerHTML= sInnerHTML +"<td align=left width=100%><table cellspacing=0 cellpadding=0 border=0><tr>";
				if (parseInt(vBeginIndex,10)>0){
					sInnerHTML= sInnerHTML +"<td><a href='#' title='ǰһ��Tab' onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(beginTabIndex,10)-1)+","+tabLength+",'"+hangtbid+"');return false;\"><img class='tabpre' border=0 src='"+sHCResourcesPath+"/chooser_orange/arrow-left.png'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabpredisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				if ((arrTabStrip.length+parseInt(vBeginIndex,10))<tabStrip.length){
					sInnerHTML= sInnerHTML +"<td><a href='#' title='��һ��Tab' onClick=\"javascript:hc_drawTabToTable_plus_ex(tabstrip,"+selectedStrip+","+(parseInt(beginTabIndex,10)+1)+","+tabLength+",'"+hangtbid+"');return false;\"><img class='tabnext' border=0 src='"+sHCResourcesPath+"/chooser_orange/arrow-right.png'></a></td>\r";
				}else{
					sInnerHTML= sInnerHTML +"<td><img class='tabnextdisable' border=0 src='"+sHCResourcesPath+"/1x1.gif'></td>\r";
				}
				if(bForceAddTab){
					sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
					sInnerHTML= sInnerHTML + "<td><a href='#' title='����...' onClick=\"javascript:myTabAdd();return false;\"><img class='tabadd' border=0 src='"+sHCResourcesPath+"/new.gif'></a></td>"+"\r";
				}else {
					sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
					sInnerHTML= sInnerHTML + "<td nowrap></td>"+"\r";
				}
				sInnerHTML= sInnerHTML +"</tr></table></td>";
			}else{//added by byhu
				if(bForceAddTab){
					sInnerHTML= sInnerHTML + "<td id=adddiv><a href='#' title='������չʾȫ��...' onClick=\"javascript:myTabAdd();showdiv(this);return false;\"><img class='tabadd' border=0 src='"+sHCResourcesPath+"/1x1.gif'></a></td>"+"\r";
					sInnerHTML= sInnerHTML +"<td align=right width=100% ></td>";
				}else {
					sInnerHTML= sInnerHTML + "<td nowrap>&nbsp;</td>"+"\r";
					sInnerHTML= sInnerHTML + "<td align=right width=100%> </td>"+"\r";
				}
			}
			//չʾȫ��
			sInnerHTML= sInnerHTML +"<td style=\"cursor:hand\" onClick=\"javascript:showHideTabMenu(this)\" onMouseOver1=\"javascript:showTabMenu(this)\" nowrap><img class='tabmenu' border=0 src='"+sHCResourcesPath+"/chooser_orange/arrow02.png'></td>\r";
			sInnerHTML= sInnerHTML + "</tr>";
			//end
			//�ָ��
			sInnerHTML= sInnerHTML + "<tr>"+"\r";
			for(var i=0; i<arrTabStrip.length; i++){
				if(i==0){
					if(i==vSelectedStrip){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
					
				}
				if(i==vSelectedStrip){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
				if(i==(arrTabStrip.length-1)){
					if(i==vSelectedStrip){
						sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}else{
						sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
					}	
				}			
			}
			sInnerHTML= sInnerHTML +"</tr>";
			//���ز�
			sInnerHTML= sInnerHTML +"<tr><td><input type=hidden id='"+tabID+"_beginIndexID' name='"+tabID+"_beginIndex' value='"+vBeginIndex+"'></td></tr></table>\r";
			//�����㣬�������ʱ��ʾ���е�tab
			sInnerHTML= sInnerHTML +"<div id=\"tabMenu1\" style=\"z-index:1000;position:absolute;left:0px;right:0px;top:0px;width:0px;height:0px;visibility:hidden;background:green\" class=\"SubMenuDiv\">\r";
			sInnerHTML= sInnerHTML +"<table  class=\"SubMenuTable\"  cellpadding=4 cellspacing=0  border=0 >\r";
			sInnerHTML= sInnerHTML +"<tr height=5><td class=\"TabMenuTd2\" style=\"font-size:15px;height:10px;\" align=right><span style=\"font-weight:bold;BORDER-LEFT:#999999 1px solid;BORDER-BOTTOM:#999999 1px solid;cursor:hand\" onclick=\"javascript:hideTabMenu();\">��</span></td></tr>\r";
			for (var i=0;i<tabStrip.length; i++){
				if(tabStrip[i][6]=="del")continue;
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
			sInnerHTML= sInnerHTML +"</div>\r</body leftMargin=0 rightMargin=0 topMargin=0 bottomMargin=0 >";
			sObject.innerHTML=sInnerHTML;
		}
		//����tabIndex�����㵱�򿪵���ҳ��ʱ��һ��tab�����currentBeginIndex
		function calBiginIndex(tabIndex,currentBeginIndex){
			var vNewCurBegin=currentBeginIndex;
			if (tabIndex<currentBeginIndex)
				vNewCurBegin=tabIndex;
			//arrTabStrip.length ÿһ��ı�ǩ���������ж���˼��i������һ���ǩ��
			if (tabIndex>(parseInt(currentBeginIndex,10)-1+iMaxTabLength))
				vNewCurBegin=tabIndex-iMaxTabLength+1;
			return vNewCurBegin;
		}
		function myTabAction(hangtbid,tabindex,bRefresh,vBegin)
		{
			var tabID=hangtbid+"tableID";
			var iBeginTabIndex = 1;
			if(typeof(document.all(tabID+'_beginIndexID')) != "undefined" && document.all(tabID+'_beginIndexID') != null)
				iBeginTabIndex= document.all(tabID+'_beginIndexID').value;
			if(arguments.length==4) 
				iBeginTabIndex = vBegin;
			if(bForceRefreshTab || bRefresh )
			{
				if(checkTabAction(tabindex))
				{
					eval(tabstrip[tabindex][3]);
					tabstrip[tabindex][4]='LOADED';
					hc_drawTabToTable_plus_ex(tabstrip,tabindex,iBeginTabIndex,iMaxTabLength,hangtbid);
				}				
			}
			else
			{
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
		function deleteTabMenu(hangtbid,tabindex,currentBeginIndex)
		{
			var nexttab=tabindex;
			if(tabindex>=1){
				nexttab=tabindex-1;
			}
			var iBeginTabIndex = calBiginIndex(nexttab,currentBeginIndex);
			//���ܵ�������ɾ�� i tab
			//tabstrip.remove(tabindex);
			tabstrip[tabindex][6]="del";
			if(checkTabAction(nexttab))
			{	
				if(tabstrip[nexttab][4]!='LOADED'){
					eval(tabstrip[nexttab][2]);
					tabstrip[nexttab][4]='LOADED';
				}
				//strip_id_increment--;
				document.getElementById(hangtbid+tabindex).style.display="none";
				hc_drawTabToTable_plus_ex(tabstrip,nexttab,iBeginTabIndex,iMaxTabLength,hangtbid);
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
		//��ʾ������tab�˵�
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
		//���ڼ��Tab�����Ϸ��ԣ��������false����tab���л�
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
		function myTabDelete(i)
		{
			//�ڳ������Լ�ʵ�� 
			//alert("ɾ��..."+i);
		}
		function myTabAdd()
		{
			//�ڳ������Լ�ʵ�� 
			//alert("����...");
		}	
		
	//------------------------Added in 2011/01/17 ������Ŀ�� xyqu  END---------------------------------------//