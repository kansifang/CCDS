<%
	String d ="'123'";  
	if((request.getParameter("d")!=null)&&(request.getParameter("d").trim().length()!=0))
	{
		d= "'"+request.getParameter("d")+"'";
	}
%>
<%
	String sSql1000;
	ASResultSet rs1000;
	String sMyCurrentJob[][] = new String[100][5];
	int iJobs=0;
	String sToday = StringFunction.getToday();
	
	sSql1000 ="select SerialNo,GetItemName('WorkType',WorkType)  as WorkType,"+
			"WorkBrief,PlanFinishDate,"+
			"PromptBeginDate,ActualFinishDate,WorkContent,"+
			"getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName "+
			"from Work_Record "+
			"where  (ActualFinishDate is null or ActualFinishDate='') "+
			"and InputUserID = '"+CurUser.UserID+"'"; 
	rs1000 = SqlcaRepository.getResultSet(sSql1000);
	while(rs1000.next()){
		sMyCurrentJob[iJobs][0] = rs1000.getString("SerialNo");
		sMyCurrentJob[iJobs][1] = rs1000.getString("WorkType");
		sMyCurrentJob[iJobs][2] = SpecialTools.real2Amarsoft(rs1000.getString("WorkBrief"));
		sMyCurrentJob[iJobs][3] = SpecialTools.real2Amarsoft(rs1000.getString("WorkContent"));
		sMyCurrentJob[iJobs][4] = rs1000.getString("PlanFinishDate");
		if(sMyCurrentJob[iJobs][4]==null) sMyCurrentJob[iJobs][4]="";
		iJobs++;
	}
	rs1000.getStatement().close();
%>


<script language="javascript">
var sCurJob = new Array();
<%
	String sCurYear,sCurMonth,sDate;
	int iCurYear,iCurMonth,iDate;
	for(int i=0;i<iJobs;i++){
		if(sMyCurrentJob[i]==null) 
			break;
		if(sMyCurrentJob[i][0]!=null){
%>
			sCurJob[<%=i%>] = new Array(7);
			sCurJob[<%=i%>][0] = "<%=sMyCurrentJob[i][0]%>";
			sCurJob[<%=i%>][1] = "<%=sMyCurrentJob[i][1]%>";
			sCurJob[<%=i%>][2] = "<%=sMyCurrentJob[i][2]%>";
			sCurJob[<%=i%>][3] = "<%=sMyCurrentJob[i][3]%>";
<%
			sCurYear = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",1);
			sCurMonth = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",2);
			sDate = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",3);
			
			if(sCurYear==null || sCurYear.equals("")) 
				iCurYear=0;
			else 
				iCurYear=Integer.parseInt(sCurYear);
			if(sCurMonth==null || sCurMonth.equals("")) 
				iCurMonth=0;
			else 
				iCurMonth=Integer.parseInt(sCurMonth);
			if(sDate==null || sDate.equals("")) 
				iDate=0;
			else 
				iDate=Integer.parseInt(sDate);
%>
			sCurJob[<%=i%>][4] = <%=iCurYear%>;
			sCurJob[<%=i%>][5] = <%=iCurMonth%>;
			sCurJob[<%=i%>][6] = <%=iDate%>;
<%
		}else{
			break;
		}
	}
%>


function fToggleColor(myElement) 
{
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText") 
	{
		if (myElement.color == toggleColor) 
		{
			myElement.color = "";
		} 
		else 
		{
			myElement.color = toggleColor;
	   	}
	} 
	else 
	{	
		if (myElement.id == "calCell") 
		{
			for (var i in myElement.children) 
			{
				if (myElement.children[i].id == "calDateText") 
				{
					if (myElement.children[i].color == toggleColor) 
					{
						myElement.children[i].color = "";
					} 
					else 
					{
						myElement.children[i].color = toggleColor;
            		}
         		}
      		}
   		}
   	}
}
function fUpdateCal(iYear, iMonth) 
{
	myMonth = fBuildCalC(iYear, iMonth);
	objPrevElement.bgColor = "";
	calSelectedDate = "";
	for (var w = 1; w < 7; w++) 
	{
		for (var d = 0; d < 7; d++) 
		{
			if (!isNaN(myMonth[w][d])) 
			{
				calDateText[((7*w)+d)-7].innerText = myMonth[w][d];
			} 
			else 
			{
				calDateText[((7*w)+d)-7].innerText = " ";
        	}
      	}
   	}
}

function isDate(value,separator) 
{
	var sItems = value.split(separator);
	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false; 
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
	return true;
}
function getRealTop(imgElem) 
{
    yPos = eval(imgElem).offsetTop;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) 
    {
        yPos += tempEl.offsetTop;
        tempEl = tempEl.offsetParent;
    }
    return yPos;
}
function getRealLeft(imgElem) 
{
    xPos = eval(imgElem).offsetLeft;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) 
    {
        xPos += tempEl.offsetLeft;
        tempEl = tempEl.offsetParent;
    }
    return xPos;
}
function fGetDaysInMonth(iMonth,iYear) 
{
	var dPrevDate = new Date(iYear, iMonth, 0);//获取上个月最后一天的日期
	return dPrevDate.getDate();//获取上个月最后一天譬如29 30 31等
}
/************************构建日历**************************/
//以周日开始，符合西方习惯
function fBuildCal(iYear, iMonth, iDayStyle) 
{
	var aMonth = new Array();
	aMonth[0] = new Array(7);
	aMonth[1] = new Array(7);
	aMonth[2] = new Array(7);
	aMonth[3] = new Array(7);
	aMonth[4] = new Array(7);
	aMonth[5] = new Array(7);
	aMonth[6] = new Array(7);
	var dCalDate = new Date(iYear, iMonth-1, 1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
	var iVarDate = 1;
	var d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Sunday";
		aMonth[0][1] = "Monday";
		aMonth[0][2] = "Tuesday";
		aMonth[0][3] = "Wednesday";
		aMonth[0][4] = "Thursday";
		aMonth[0][5] = "Friday";
		aMonth[0][6] = "Saturday";
	} 
	else if (iDayStyle == 1) 
	{
		aMonth[0][0] = "日";
		aMonth[0][1] = "一";
		aMonth[0][2] = "二";
		aMonth[0][3] = "三";
		aMonth[0][4] = "四";
		aMonth[0][5] = "五";
		aMonth[0][6] = "六";
	} 
	else 
	{
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}

	for (d = iDayOfFirst; d < 7; d++) 
	{
		if(iVarDate<10) 
			aMonth[1][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
		else
			aMonth[1][d] = iVarDate;
		
		iVarDate++;
	}

	for (w = 2; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{	
			if (iVarDate <= iDaysInMonth) 
			{
				if(iVarDate<10) 
					aMonth[w][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
				else
					aMonth[w][d] = iVarDate;
				iVarDate++;
	      }
	   }
	}
	
	return aMonth;
}
//以周一开始，符合中国习惯
function fBuildCalC(iYear, iMonth, iDayStyle) 
{
	var aMonth = new Array();
	aMonth[0] = new Array(7);
	aMonth[1] = new Array(7);
	aMonth[2] = new Array(7);
	aMonth[3] = new Array(7);
	aMonth[4] = new Array(7);
	aMonth[5] = new Array(7);
	aMonth[6] = new Array(7);
	var dCalDate = new Date(iYear, iMonth-1, 1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
	var iVarDateBe = fGetDaysInMonth(iMonth-1, iYear),iVarDate = 1,iVarDateAf = 1;
	var d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Monday";
		aMonth[0][1] = "Tuesday";
		aMonth[0][2] = "Wednesday";
		aMonth[0][3] = "Thursday";
		aMonth[0][4] = "Friday";
		aMonth[0][5] = "Saturday";
		aMonth[0][6] = "Sunday";
	} 
	else if (iDayStyle == 1) 
	{
		aMonth[0][0] = "一";
		aMonth[0][1] = "二";
		aMonth[0][2] = "三";
		aMonth[0][3] = "四";
		aMonth[0][4] = "五";
		aMonth[0][5] = "六";
		aMonth[0][6] = "日";
	} 
	else 
	{
		aMonth[0][0] = "Mo";
		aMonth[0][1] = "Tu";
		aMonth[0][2] = "We";
		aMonth[0][3] = "Th";
		aMonth[0][4] = "Fr";
		aMonth[0][5] = "Sa";
		aMonth[0][6] = "Su";
	}
	if(iDayOfFirst==0){
		aMonth[1][6] = "0"+iVarDate++;
		for (d = 6-1; d >=0 ; d--){
			aMonth[1][d] = iVarDateBe--+"p";
		}
	}else{
		for (d = iDayOfFirst-1; d < 7; d++){
			aMonth[1][d] = "0"+iVarDate++;
		}
		for (d = iDayOfFirst-1-1; d >=0 ; d--){
			aMonth[1][d] = iVarDateBe--+"p";
		}
	}
	for (w = 2; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{
			if (iVarDate <= iDaysInMonth){
				if(iVarDate<10) 
					aMonth[w][d] = "0"+iVarDate;
				else
					aMonth[w][d] = iVarDate;
				iVarDate++;
	      	}else{
	      		if(iVarDateAf<10) 
					aMonth[w][d] = "0"+iVarDateAf+"p";//不是本月的日期加个后缀p
				else
					aMonth[w][d] = iVarDateAf+"p";
	      		iVarDateAf++;
	      	}
	   }
	}
	return aMonth;
}
function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle) 
{
	var sReturn = "";
	var myMonth = fBuildCalC(iYear, iMonth, iDayStyle);
	sReturn += ("<table align='right' border='0' cellpadding='0' cellspacing='0'>");
	sReturn += ("<tr>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	sReturn += ("</tr>");
	for (var w = 1; w < 7; w++){
		sReturn += ("<tr>");
		for (var d = 0; d < 7; d++){
			if (!isNaN(myMonth[w][d])){
				//日历表中循环打印时如果等于今天，加上背景色
				if(iYear==dCurYear && iMonth==dCurMonth && myMonth[w][d]==calSelectedDate){
					//这个日期存在到期的工作
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0){
						sReturn += ("<td id=calCells align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand;' onMouseOver=showTipOfToday(1,this,'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"') onClick='selectDay(this);'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onDBLClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ("</font>");
					}else{
						sReturn += ("<td  id=calCells align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand;'  onMouseOver='showlayerforCP(0,this)' onclick='selectDay(this);'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onDBLClick='newTask("+iYear+","+iMonth+","+myMonth[w][d]+");' >");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</font>");
					}
				}else{
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0)
					{
						sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"\') onclick='selectDay(this);'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onDBLClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ( "</font>");
					}else{
						sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayerforCP(0,this)' onclick='selectDay(this);'");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onDBLClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ( "</font>");
					}
				}
			}else{
				sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayerforCP(0,this)'>");
				sReturn += ("<font id=calDateText color=gray style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "'>");
				sReturn += (""+ myMonth[w][d].slice(0,-1)+"");
				sReturn += ( "</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	$('#MyCalendar').html(amarsoft2Real(sReturn));
	$("#calCells").css('background-color','#c0c0c0');
}
//获取iYear/iMonth/iDay计划完成的内容摘要
function getTodayTip(iYear,iMonth,iDay){
	var sTips="",sTmp="",j=1;
	for(var i=0;i<sCurJob.length;i++)
	{
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay)
		{
			//alert(iYear+iMonth+iDay);
			sTmp = j+"."+sCurJob[i][2];
			if(sTmp==null) sTmp="";
			if(sTmp.length>10) sTmp = sTmp.substring(0,10)+"...";
			sTips += sTmp+"~p";
			j++;
		}
	}
	sTips=""+sTips;
	return sTips;
}

//统计计划iYear/iMonth/iDay完成的工作数
function getTodayJobCount(iYear,iMonth,iDay){
	var iCountWorks=0;
	for(var i=0;i<sCurJob.length;i++)
	{
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay)
		{
			iCountWorks++;
		}
	}
	return iCountWorks;
}
function newTask(iYear,iMonth,iDate)
{
	var sSerialNo="";
	for(var i=0;i<sCurJob.length;i++){
		//alert(sCurJob[i][4]+"/"+sCurJob[i][5]+"/"+sCurJob[i][6]);
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDate){
			//alert("in");
			sSerialNo=sCurJob[i][0];
			//OpenPage("/DeskTop/WorkRecordInfo.jsp?SerialNo="+sSerialNo,"","");
			editWork(sSerialNo);
			return;
		}
	}
	editWork("");
}
function editWork(sSerialNo)
{
	//OpenComp("NewWork","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo,"","width=640,height=480,top=20,left=20");
	popComp("WorkRecordInfo","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo, "","");
	//reloadSelf();
}
/************************构建年历**************************/
//四列三行展示年
function fBuildYear(iYear){
	var aYear = new Array();
	aYear[0] = new Array(4);
	aYear[1] = new Array(4);
	aYear[2] = new Array(4);
	var iVarDate = parseInt(iYear);
	for(var w = 0; w < 3; w++){
		for(var d = 0; d < 4; d++){	
			aYear[w][d]=iVarDate++;
	   }
	}
	return aYear;
}
function fDrawYear(iYear, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle){
	var sReturn = "";
	var myMonth = fBuildYear(iYear);
	sReturn += ("<table align='right' border='0' cellpadding='0' cellspacing='0'>");
	for (var w = 0; w < 3; w++){
		sReturn += ("<tr>");
		for (var d = 0; d < 4; d++){
			if (!isNaN(myMonth[w][d])){
				sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayerforCP(0,this)'>");
				sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick='SelectYearOrDay=\"M\";document.getElementById(\"tbSelYear\").innerHTML="+myMonth[w][d]+";fDrawCal(document.getElementById(\"tbSelYear\").innerHTML, document.getElementById(\"tbSelMonth\").innerHTML, 30, 20, \"11px\", \"\", 1);'>");
				sReturn += (""+ myMonth[w][d] +"");
				sReturn += ( "</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	$('#MyCalendar').html(amarsoft2Real(sReturn));
}
function selected(Y,M){
	document.getElementById("tbSelYear").innerHTML = Y;
	document.getElementById("tbSelMonth").innerHTML = M;
}
//上一个年的列表或月的日历
function prev(){
	var YOrD=SelectYearOrDay;
	var Y=document.getElementById("tbSelYear").innerHTML;
	Y=parseInt(Y,10);
	var M=document.getElementById("tbSelMonth").innerHTML;
	M=parseInt(M,10);
	if(YOrD=='M'){
		if(M==1){
			Y--;
			M=12;
		}else{
			M--;
		}
		selected(Y,M);
		fDrawCal(document.getElementById("tbSelYear").innerHTML, document.getElementById("tbSelMonth").innerHTML, 30, 20, "11px", "", 1);
	}else if(YOrD=='Y'){
		Y=Y-12;
		selected(Y,M);
		fDrawYear(Y,60, 40, "11px", "", 1);
	}
}
function next(){
	var YOrD=SelectYearOrDay;
	var Y=document.getElementById("tbSelYear").innerHTML;
	Y=parseInt(Y,10);
	var M=document.getElementById("tbSelMonth").innerHTML;
	M=parseInt(M,10);
	if(YOrD=='M'){
		if(M==12){
			Y++;
			M=1;
		}else{
			M++;
		}
		selected(Y,M);
		fDrawCal(document.getElementById("tbSelYear").innerHTML, document.getElementById("tbSelMonth").innerHTML, 30, 20, "11px", "", 1);
	}else if(YOrD=='Y'){
		Y=Y+12;
		selected(Y,M);
		fDrawYear(Y,60, 40, "11px", "", 1);
	}
}
var displayDetail=false;
function displayD(){
	displayDetail=!displayDetail;
	if(displayDetail){
		$('#du').html("<img name='movefrom_report_chosen' style='cursor:hand' onmousedown='pushButton(\"movefrom_report_chosen\",true);' onmouseup='pushButton(\"movefrom_report_chosen\",false);' onmouseout='pushButton(\"movefrom_report_chosen\",false);' onclick='displayD();' border='0' src='<%=sResourcesPath%>/chooser_orange/scroll_arrow_up.gif' alt='detail'/>");
		$('#MyCalendar').css("visibility","visible");
	}else{
		$('#du').html("<img name='movefrom_report_chosen' style='cursor:hand' onmousedown='pushButton(\"movefrom_report_chosen\",true);' onmouseup='pushButton(\"movefrom_report_chosen\",false);' onmouseout='pushButton(\"movefrom_report_chosen\",false);' onclick='displayD();' border='0' src='<%=sResourcesPath%>/chooser_orange/scroll_arrow_down.gif' alt='detail'/>");
		$('#MyCalendar').css("visibility","hidden");
	}
}
function showlayerforCP(id,e){  
	document.all('sMenu'+id).style.left=getRealLeft(e);
	document.all('sMenu'+id).style.top=getRealTop(e)+e.offsetHeight;
    //document.all('sMenu'+id).style.width=e.offsetWidth;
    if(getRealLeft(e)+ e.offsetWidth + document.all('sMenu'+id).offsetWidth >document.body.offsetWidth)
    	document.all('sMenu'+id).style.left = getRealLeft(e) - document.all('sMenu'+id).offsetWidth;
    if(getRealTop(e)+ e.offsetHeight + document.all('sMenu'+id).offsetHeight >document.body.offsetHeight)
    	document.all('sMenu'+id).style.top = getRealTop(e) - document.all('sMenu'+id).offsetHeight;
    document.all('sMenu'+id).style.visibility="visible";
    for(var i=0;i<2;i++){
        if(i!=id)
        	document.all('sMenu'+i).style.visibility="hidden";
    }
}
//如果此日起存在计划完成的工作，则展示内容
function showTipOfToday(id,e,sText){  
    sHtmlTmp = "";
    sHtmlTmp += "<table  border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=sMenuTd2>";
    sHtmlTmp += sText;
    sHtmlTmp += "</td></tr></table>";
    while(sHtmlTmp.indexOf("~p")>=0){
    	sHtmlTmp = sHtmlTmp.replace("~p","<br>");
    }
    document.all('sMenu'+id).innerHTML = sHtmlTmp;
    showlayerforCP(id,e);
}
	var dDate = new Date();
	var dCurMonth = dDate.getMonth()+1;
	var dCurDayOfMonth = dDate.getDate();
	var dCurYear = dDate.getFullYear();
	var objPrevElement = new Object();
	var calSelectedDate="";
	var SelectYearOrDay="M";
	function selectDay(obj){
		var clickedday=$(obj).text();//children().find("b:eq(0)")
		if (!isNaN(parseInt(clickedday))){
			$(obj).attr('id','calCells');
			$(obj).css('background-color','#c0c0c0');
			objPrevElement.attr('id','calCell');
			objPrevElement.css('background-color','');
			dCurYear=$("#tbSelYear").text();
			dCurMonth=$("#tbSelMonth").text();
			calSelectedDate = clickedday;
			objPrevElement = $(obj);
			$("#tbSelDay").text(clickedday);
	  	}
	}
</script>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td valign="top" nowrap>
			<img name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onclick='prev();' border='0' src='<%=sResourcesPath%>/chooser_orange/triangle-left.png' alt='Remove selected items' />
		</td>
		<td onMouseOver="showlayerforCP(0,this)" valign="top" nowrap>
			<span id="tbSelYear" style='width:25;cursor:hand' onClick='SelectYearOrDay="Y";fDrawYear(document.getElementById("tbSelYear").innerHTML,60, 40, "11px", "", 1);displayD();' onchange='fDrawCal(document.getElementById("tbSelYear").innerHTML, document.getElementById("tbSelMonth").innerHTML, 30, 20, "11px", "", 1)'>
			</span>年
		</td>
		<td nowrap valign="top">
			<span id="tbSelMonth" style='width:10;cursor:hand' onClick='SelectYearOrDay="M";displayD();fDrawCal(document.getElementById("tbSelYear").innerHTML, document.getElementById("tbSelMonth").innerHTML, 30, 20, "11px", "", 1);' onchange='fDrawCal(document.getElementById("tbSelYear").innerHTML, document.getElementById("tbSelMonth").innerHTML, 30, 20, "11px", "", 1);'>
			</span>月
		</td>
		<td nowrap valign="top">
			<span id="tbSelDay" style='width:10;'></span>日
		</td>
		<td nowrap>
			<img  name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onclick='next();' border='0' src='<%=sResourcesPath%>/chooser_orange/triangle-right.png' alt='next'/>
		</td>
		<td id=du nowrap>
			<img style='cursor:hand' name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onClick='displayD();' border='0' src='<%=sResourcesPath%>/chooser_orange/scroll_arrow_down.gif' alt='detail'/>
		</td>
		</tr>
	</table>
<div id="MyCalendar" style="position:absolute; right:0px; top:60px; width:180px; visibility:hidden;background:green">
</div>
<div id="sMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden">
</div>
<div id="sMenu1" style="position:absolute; left:0px; top:0px; width:80px; visibility:hidden;background:blue" onMouseOver='showlayerforCP(0,this)'>
</div>
<script language="javascript">
	$('table').ready(function(){
		$('#calCells').css('background-color','#c0c0c0');//css写法
		$("#tbSelDay").text(calSelectedDate);
		objPrevElement=$("#calCells");
	});
	selected(dCurYear,dCurMonth);
	if(dCurDayOfMonth<10)
		calSelectedDate = "0"+dCurDayOfMonth;
	else
		calSelectedDate = dCurDayOfMonth;
	fDrawCal(dCurYear,dCurMonth, 30, 20, "11px", "", 1);
</script>