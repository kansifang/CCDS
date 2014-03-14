<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:RCZhu 2003.7.18
 * Tester:
 *
 * Content: ����ѡ����
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 */
%>

<%
	String d ="'123'";  
	if((request.getParameter("d")!=null)&&(request.getParameter("d").trim().length()!=0))
	{
		d= "'"+request.getParameter("d")+"'";
	}
%>
<%
	String sSql;
	ASResultSet rs;
	String sMyCurrentJob[][] = new String[100][5];
	int iJobs=0;
	String sToday = StringFunction.getToday();
	
	sSql ="select SerialNo,GetItemName('WorkType',WorkType)  as WorkType,"+
			"WorkBrief,PlanFinishDate,"+
			"PromptBeginDate,ActualFinishDate,WorkContent,"+
			"getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName "+
			"from Work_Record "+
			"where  (ActualFinishDate is null or ActualFinishDate='') "+
			"and InputUserID = '"+CurUser.UserID+"'"; 
	rs = SqlcaRepository.getResultSet(sSql);
	while(rs.next()){
		sMyCurrentJob[iJobs][0] = rs.getString("SerialNo");
		sMyCurrentJob[iJobs][1] = rs.getString("WorkType");
		sMyCurrentJob[iJobs][2] = SpecialTools.real2Amarsoft(rs.getString("WorkBrief"));
		sMyCurrentJob[iJobs][3] = SpecialTools.real2Amarsoft(rs.getString("WorkContent"));
		sMyCurrentJob[iJobs][4] = rs.getString("PlanFinishDate");
		if(sMyCurrentJob[iJobs][4]==null) sMyCurrentJob[iJobs][4]="";
		iJobs++;
	}
	rs.getStatement().close();
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
	document.all.calSelectedDate.value = "";
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

function fSetSelectedDay(myElement)
{
	if (myElement.id == "calCell") 
	{
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))) 
		{
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			//modify by hxd in 2001/08/27
			//self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+document.all.calSelectedDate.value;
			self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+myElement.children["calDateText"].innerText;
			window.close();
      }
   }
}

function fGetDaysInMonth(iMonth,iYear) 
{
	var dPrevDate = new Date(iYear, iMonth, 0);//��ȡ�ϸ������һ�������
	return dPrevDate.getDate();//��ȡ�ϸ������һ��Ʃ��29 30 31��
}
/************************��������**************************/
//�����տ�ʼ����������ϰ��
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
		aMonth[0][0] = "��";
		aMonth[0][1] = "һ";
		aMonth[0][2] = "��";
		aMonth[0][3] = "��";
		aMonth[0][4] = "��";
		aMonth[0][5] = "��";
		aMonth[0][6] = "��";
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
//����һ��ʼ�������й�ϰ��
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
		aMonth[0][0] = "һ";
		aMonth[0][1] = "��";
		aMonth[0][2] = "��";
		aMonth[0][3] = "��";
		aMonth[0][4] = "��";
		aMonth[0][5] = "��";
		aMonth[0][6] = "��";
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
					aMonth[w][d] = "0"+iVarDateAf+"p";//���Ǳ��µ����ڼӸ���׺p
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
				//��������ѭ����ӡʱ������ڽ��죬���ϱ���ɫ
				if(iYear==dCurDate.getFullYear() && iMonth==(dCurDate.getMonth()+1) && myMonth[w][d]==document.all.calSelectedDate.value)
				{
					//������ڴ��ڵ��ڵĹ���
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0){
						sReturn += ("<td id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand;background-color:#c0c0c0;' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"\') >");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ("</font>");
					}else{
						sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand;background-color:#c0c0c0;'  onMouseOver='showlayer(0,this)'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+") >");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</font>");
					}
				}else{
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0)
					{
						sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"\')>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ( "</font>");
					}else{
						sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayer(0,this)'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ( "</font>");
					}
				}
			}else{
				sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayer(0,this)' onclick=fSetSelectedDay(this)>");
				sReturn += ("<font id=calDateText color=gray style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onClick=fSetSelectedDay(this)>");
				sReturn += (""+ myMonth[w][d].slice(0,-1)+"");
				sReturn += ( "</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	return sReturn;
}
function showlayer(id,e)
{  
	document.all('subMenu'+id).style.left=getRealLeft(e);
    document.all('subMenu'+id).style.top=getRealTop(e)+e.offsetHeight;
    //document.all('subMenu'+id).style.width=e.offsetWidth;
    if(getRealLeft(e)+ e.offsetWidth + document.all('subMenu'+id).offsetWidth >document.body.offsetWidth)
    	document.all('subMenu'+id).style.left = getRealLeft(e) - document.all('subMenu'+id).offsetWidth;
    if(getRealTop(e)+ e.offsetHeight + document.all('subMenu'+id).offsetHeight >document.body.offsetHeight)
    	document.all('subMenu'+id).style.top = getRealTop(e) - document.all('subMenu'+id).offsetHeight;
    document.all('subMenu'+id).style.visibility="visible";
    for(var i=0;i<2;i++) //modify by xdhou in 2003/09/23 old:for(var i=0;i<8;i++) ע�⣺����subMenu��length����
    {
        if(i!=id)
            document.all('subMenu'+i).style.visibility="hidden";
    }
}
//��ȡiYear/iMonth/iDay�ƻ���ɵ�����ժҪ
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
//�����������ڼƻ���ɵĹ�������չʾ����
function showTipOfToday(id,e,sText)
{  
   // alert("1"); 	
    sHtmlTmp = "";
    sHtmlTmp += "<table  border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=SubMenuTd2>";
    sHtmlTmp += sText;
    sHtmlTmp += "</td></tr></table>";
    while(sHtmlTmp.indexOf("~p")>=0){
    	sHtmlTmp = sHtmlTmp.replace("~p","<br>");
    }
    //alert(sText);
    document.all('subMenu'+id).innerHTML = sHtmlTmp;
    showlayer(id,e);
}
//ͳ�Ƽƻ�iYear/iMonth/iDay��ɵĹ�����
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
	reloadSelf();
}
/************************��������**************************/
//��������չʾ��
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
				sReturn += ("<td  id=calCell align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' style='CURSOR:Hand' onMouseOver='showlayer(0,this)'>");
				sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this);' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick='frmCalendarSample.SelectYearOrDay.value=\"D\";frmCalendarSample.tbSelYear.value="+myMonth[w][d]+";drawHtmlToObject(document.all(\"MyCalendar\"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, \"11px\", \"\", 1));'>");
				sReturn += (""+ myMonth[w][d] +"");
				sReturn += ( "</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	return sReturn;
}
function selected(Y,M){
	frmCalendarSample.tbSelMonth.options[M-1].selected = true;
	frmCalendarSample.tbSelYear.value = Y;
	/*
	for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++)
		if (frmCalendarSample.tbSelYear.options[i].value == Y)
			frmCalendarSample.tbSelYear.options[i].selected = true;
	*/
}
//��һ������б���µ�����
function prev(){
	var YOrD=frmCalendarSample.SelectYearOrDay.value;
	var Y=frmCalendarSample.tbSelYear.value;
	Y=parseInt(Y,10);
	var M=frmCalendarSample.tbSelMonth.value;
	M=parseInt(M,10);
	if(YOrD=='D'){
		if(M==1){
			Y--;
			M=12;
		}else{
			M--;
		}
		selected(Y,M);
		drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1));
	}else if(YOrD=='Y'){
		Y=Y-12;
		selected(Y,M);
		drawHtmlToObject(document.all("MyCalendar"),fDrawYear(Y,60, 40, "11px", "", 1));
	}
}
function next(){
	var YOrD=frmCalendarSample.SelectYearOrDay.value;
	var Y=frmCalendarSample.tbSelYear.value;
	Y=parseInt(Y,10);
	var M=frmCalendarSample.tbSelMonth.value;
	M=parseInt(M,10);
	if(YOrD=='D'){
		if(M==12){
			Y++;
			M=1;
		}else{
			M++;
		}
		selected(Y,M);
		drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1));
	}else if(YOrD=='Y'){
		Y=Y+12;
		selected(Y,M);
		drawHtmlToObject(document.all("MyCalendar"),fDrawYear(Y,60, 40, "11px", "", 1));
	}
}
</script>
<script LANGUAGE="JavaScript">
	var dDate = new Date();
	var dCurMonth = dDate.getMonth();
	var dCurDayOfMonth = dDate.getDate();
	var dCurYear = dDate.getFullYear();
	var objPrevElement = new Object();
</script>
<body class="pagebackground" leftmargin="0" topmargin="0">
<table border="0" align='center' width='100%' >
	<form name="frmCalendarSample" method="post" action="">
		<tr>
		<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
			<img name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onclick='prev();' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft.gif' alt='Remove selected items' />
		</td>
		<td align='center' onMouseOver="showlayer(0,this)" height=28>
			<input type="hidden" name="calSelectedDate" value="">
			<input type="hidden" name="SelectYearOrDay" value="D">
			<input name="tbSelYear" style='width=60' onClick='frmCalendarSample.SelectYearOrDay.value="Y";drawHtmlToObject(document.all("MyCalendar"),fDrawYear(frmCalendarSample.tbSelYear.value,60, 40, "11px", "", 1));' onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
					<!-- 
					<script LANGUAGE="JavaScript">
						for(var i=parseInt(dCurYear,10)-5;i<=parseInt(dCurYear,10)+5;i++){
							document.write("<option value="+i+">"+i+"</option>");
						}
					</script>
			</select> -->
			<select name="tbSelMonth" onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
			<option value="01">1</option>
			<option value="02">2</option>
			<option value="03">3</option>
			<option value="04">4</option>
			<option value="05">5</option>
			<option value="06">6</option>
			<option value="07">7</option>
			<option value="08">8</option>
			<option value="09">9</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			</select>
		</td>
		<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
			<img name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onclick='next();' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight.gif' alt='Remove selected items' />
		</td>
		</tr>
		<tr><td id=MyCalendar colspan='3'></td></tr>
	</form>
</table>
<div id="subMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden">
</div>
<div id="subMenu1" style="position:absolute; left:0px; top:0px; width:80px; visibility:hidden" onMouseOver='showlayer(0,this)'>
</div>
</body>
<script language="JavaScript">
	var dCurDate = new Date();
	selected(dCurDate.getFullYear(),dCurDate.getMonth()+1);
	if(dCurDate.getDate()<10)
		document.all.calSelectedDate.value = "0"+dCurDate.getDate();
	else
		document.all.calSelectedDate.value = dCurDate.getDate();
	drawHtmlToObject(document.all("MyCalendar"),amarsoft2Real(fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 20, "11px", "", 1)));
</script>
<%@ include file="/IncludeEnd.jsp"%>