//Copyright (C) 1998-2003 Amarsoft Corporation
//Writed By HouXD,ZhuRC,HuBy
//All rights reserved.

//var sPath = "/amarbank6/Resources/1/Support/";
//begin ���ڸ�ʽ�����鱨����ʾ�������Զ�����
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
//var sDateReadonlyColor = " readonly style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(�������ֶ�ֻ��ѡ��)
var sDateReadonlyColor = " style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(�������ֶμȿ�ѡ���ֿ�����)

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
var sUnloadMessage = "\n\r��ǰҳ�������Ѿ����޸ģ�\n\r����ȡ���������ڵ�ǰҳ��Ȼ���ٰ���ǰҳ�ϵġ����桱��ť�Ա����޸Ĺ������ݣ�\n\r����ȷ�����򲻱����޸Ĺ������ݲ����뿪��ǰҳ��";
var bShowUnloadMessage=false;  //true for szcb_bank,ceb �˲����ѷ������벻Ҫ�޸ġ�2005.01.10 byhu
var bCheckBeforeUnload=true;  //��� bShowUnloadMessage
var bHighlightFirst = false;
var bDoUnloadOne = true;  //for only one 
var bDoUnload = new Array();
var bShowGridSum = false;
var sSignature = "739D91A4A3A096A58493A4918B9AA097A0B776A795A0AAA6AC5F6261666976A798A2A3A0A6A57698A29185999C95A9AE759E94B2DAE3E26168666E6C719D92";

//var sHighlightColor="background-color:#FFF09E;color:#FF0000;background-image:url("+sPath+"table/dim_scrollup.gif)";
var sHighlightColor="background-color:#AEB9E6;color:#000000;)"; 	//������ɫ

var sFFormInputStyle   = "font-family:����,arial,sans-serif;font-size: 10pt";
var sFFormCaptionStyle = "font-family:����,arial,sans-serif;font-size: 10pt;align=center";
var sGridInputStyle    = " ";
var sGridHeaderStyle   = " ";	//color:blue;
var REM_sGridHeaderStyle   = "font-family:����,arial,sans-serif;font-size: 10pt; background-color:#B4B4B4;cursor:hand;text-decoration: none ";	//color:blue;

//var sHeaderStyle = "background-color:#B4B4B4;cursor:hand;font-family:����;font-size: 10pt; text-decoration: none";	
var sHeaderStyle = " ";	
//var sTDStyle = " font-family:����; font-size: 10pt; text-decoration: none";	
var sTDStyle = " ";	
var sSumTDStyle = " background-color:#CCCCCC;font-family:����;font-size: 10pt; text-decoration: none";	

var hmRPTable = " align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF ";
var hmRPPageTr = " ";
var hmRPPageTd = " style='font-family:����,arial,sans-serif;font-size:9pt;	font-weight: normal;color: #55554B;	padding-left:  5px;padding-right:5px;padding-top:2px;padding-bottom:2px;background-color: #CDCDCD;valign:top;' ";
var hmRPHeaderTr = "bgColor=#cccccc";
var hmRPHeaderTd       = " nowrap align=middle style='background-color:#B4B4B4;cursor:hand;font-family:����;font-size: 10pt; text-decoration: none' ";
var hmRPHeaderTdSerial = " nowrap align=middle style='background-color:#B4B4B4;cursor:hand;font-family:����;font-size: 10pt; text-decoration: none' ";
var hmRPGroupSumTr = new Array();
var hmRPGroupSumTdSerial = new Array();
var hmRPGroupSumTd = new Array();
var it1=0,itColor=new Array("#FFCCAA","#EE8844","#DD2299","#CC00CC","#BBBBBB","#AAAAAA","#999999","#888888","#777777","#666666","#555555","#444444","#333333","#222222","#111111","#000000");
for(it1=0;it1<16;it1++)
{
	hmRPGroupSumTr[it1] = " ";
	hmRPGroupSumTdSerial[it1] = " nowrap align=middle style='background-color:#E4E4E4;font-family:����;font-size: 10pt; text-decoration: none ' ";
	hmRPGroupSumTd[it1]       = " nowrap              style='background-color:"+itColor[it1]+";font-family:����;font-size: 10pt; text-decoration: none ' ";
}
var hmRPContentTr = " ";
var hmRPContentTDSerial = " nowrap align=middle bgcolor=#E4E4E4 style='font-family:����; font-size: 10pt; text-decoration: none ' ";
var hmRPContentTD       = " nowrap              bgcolor=#ffffff style='font-family:����; font-size: 10pt; text-decoration: none ' ";
var hmRPPageSumTr = " ";
var hmRPPageSumTdSerial  = " nowrap align=middle style='font-family:����; font-size: 10pt; text-decoration: none ' ";
var hmRPPageSumTd        = " nowrap              style='font-family:����; font-size: 10pt; text-decoration: none ' ";
var hmRPTotalSumTr = " ";
var hmRPTotalSumTdSerial = " nowrap align=middle style='font-family:����; font-size: 10pt; text-decoration: none ' ";
var hmRPTotalSumTd       = " nowrap              style='font-family:����; font-size: 10pt; text-decoration: none ' ";


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
var hmGdSumTdSerial = " <TD nowrap id='T0' style='cursor:hand;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#EEE1D2 align=center valign=top  >�ܼ�</TD> ";
var hmGdSumTd = " style='font-family:����,arial,sans-serif;font-size: 9pt ' ";

var sMandatorySignal = " &nbsp;<font color=red>*</font> ";
var hmGdTdContent = " nowrap bgcolor=#FEFEFE";

var hmGdTdContentInput1 = " class='GDTdContentInput' ";
var hmGdTdContentArea1 = " class='hmGdTdContentArea' ";
var hmGdTdContentSelect1 = " class='GdTdContentSelect' ";

var hmGdTdContentInput2 =  " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentInput1 ;
var hmGdTdContentArea2 =   " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentArea1;
var hmGdTdContentSelect2 = " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentSelect1;

// add by byhu 2005.01.11 datawindow �Ų�����
var arrangements = new Array();
var harbors = new Array();
var bFreeFormMultiCol = false;



//below can modify in jsp

function myAfterLoadGrid(iDW)
{
	//setColor(iDW,sEvenColor);
	//Add you code
}

function myAfterLoadFreeForm(iDW)
{
	//Add you code
}

function mySelectRow()	
{ 
	//demo code
	//if(myiframe0.event.srcElement.tagName=="BODY") return;	
	//setColor();	
}

function myHandleSelectChangeByIndex(iDW,iRow,iCol)
{
	sCol = getColName(iDW,iCol);
	myHandleSelectChange(iDW,iRow,sCol);
}

function myHandleSelectChange(iDW,iRow,sCol)
{
}

//add in 2004/03/04
function myNumberBFP(myobj)
{
	try {	//add in 2008/04/10
		clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d\-+.]/g,''));
	}catch(e){}		//add in 2008/04/10
}	


function myNumberFC(myobj)
{
	myobj.value=myobj.value.replace(/,/g,"");
	myNumberPOS(myobj);
}	

function myNumberPOS(myobj)  {
	try
	{
	   if  (myobj.createTextRange)  {
		   var  r  =  myobj.createTextRange();
		   var  ipos = myobj.value.indexOf('.')
		   if (ipos == -1) {
			   ipos = myobj.value.length;
		   }
		   else {
			   ipos = ipos;
		   }
		   r.moveStart('character',ipos);
		   r.collapse();
		   r.select();
	   }
	}
	catch(E)
	{
		var a=1;
	}
}

function myNumberKD(myobj,event)
{
	try
	{
		var mycode = event.keyCode;
		if (mycode == 8 || mycode == 46) { //delete,backspace
		  //event.keyCode = 8; //backspace
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 13 || mycode == 9 || mycode == 27 ) { //enter,tab,esc
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 16 && mycode <= 18 ) { //shift,ctrl,alt
		  event.returnValue = true;
		  return;
		}
		else if (event.ctrlKey == true && (mycode == 67 || mycode == 86 || mycode == 88)) { //ctrl+cvx
		  event.returnValue = true;
		  return;
		}
		else if ((mycode == 110 || mycode == 190) && myobj.value.indexOf('.')==-1) {//'.'
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 109 || mycode == 189) {//'-'
		  event.returnValue = true;
		  return;
		}
		else if (event.shiftKey == false && mycode >= 48 && mycode <= 57 ) { //0-9
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 40) { //down
		  event.keyCode = 9; //tab
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 33 && mycode <= 40) { //left,right,home...
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 229 ) { //chinese
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 96 && mycode <= 105 ) { //[num]0-9
		  event.returnValue = true;
		  return;
		}
		else {
		  event.returnValue = false;
		  return;
		}
	}
	catch(E)
	{
		var a=1;
	}
}

function myNumberKU(myobj, event)
{
	var mycode = document.frames("myiframe0").event.keyCode;
	if( (mycode>=33 && mycode<=39 )|| mycode==16 || mycode==17 ||mycode==18 ||mycode==8) //left,right,home...alt,ctrl,shift,delete
		return; 
	if(mycode!=43 && mycode!=44 && mycode!=45 && mycode!=46 &&
	mycode!=187 && mycode!=188 && mycode!=189 && mycode!=190 &&
	mycode!= 48 && mycode!= 49 && mycode!= 50 && mycode!= 51 && mycode!= 52 &&
	mycode!= 53 && mycode!= 54 && mycode!= 55 && mycode!= 56 && mycode!= 57 && //+,-. 0123456789
	mycode!= 96 && mycode!= 97 && mycode!= 98 && mycode!= 99 && mycode!= 100 &&  //numlock:0-4
	mycode!= 101 && mycode!= 102 && mycode!= 103 && mycode!= 104 && mycode!= 105 &&  //numlock:5-9
	mycode!= 107 && mycode!= 109 && mycode!= 110 ) {//numlock: + - .
		myobj.value=myobj.value.replace(/[^\d\-+.,]/g,'');
		myNumberPOS(myobj);
	}
}	

function myNumberKP(myobj, event)
{
	try
	{
		var mycode = event.keyCode;
		if (mycode == 45) {//'-'
		  if (myobj.value.indexOf('-')==-1) {
			  myobj.value = '-' + myobj.value;
		  }
		  else {
			  myobj.value=myobj.value.replace(/-/,"");
		  }
		  myNumberPOS(myobj);
		  event.returnValue = false;
		  return;
		}

		if(myobj.value!="") 
		{
			var a;
			a=parseFloat(myobj.value,10);
			{
				if(Math.abs(a)>100000000000000) 
				{
					alert("���ݲ�������");
					myobj.value="";
					event.returnValue = false;
				}
			}
		}
	}
	catch(E)
	{
		var a=1;
	}
}	

function myNumberBL(myobj)
{
	try
	{
		myobj.value=myobj.value.replace(/[^\d\-+.,]/g,'');  
		/*
		if(myobj.value!="") 
		{
			myobj.value=parseFloat(myobj.value,10);
			if(isNaN(myobj.value)) myobj.value="";
		}
		*/
		if(myobj.value==".") myobj.value="";		
		if(!reg_Num(myobj.value)) myobj.value="";

		if(typeof(myobj.myvalid)!="undefined" && myobj.myvalid!="undefined" )
		{
			if(myobj.value.replace(/[^\d\-+.]/g,'')!='' && !eval(myobj.myvalid.replace(/myobj.value/g,myobj.value.replace(/[^\d\-+.]/g,''))))	 //kick �� ,
			{
				alert(myobj.mymsg);
				myobj.focus();
			}
		}
	}
	catch(E)
	{
		var a=1;
	}
	
}	

//�����������ݵ�С��λ�Ƿ񳬹��涨��λ��
function FormatNumber(srcStr,nBeforeDot,nAfterDot)  //��ʽ������ (int srcStr,int С��λ��)
{	
	srcStr = new String(srcStr);
	if(srcStr=="" || srcStr==null) return true;
	strLen = srcStr.length;	
	dotPos = srcStr.indexOf(".");		
	if(strLen > (nBeforeDot + nAfterDot +1)){return false;} 
	else
	{
		if (dotPos == -1)
		{
			if(strLen> (nBeforeDot + nAfterDot)){return false;}  
		}else if((strLen - dotPos) > (nAfterDot + 1)){return false;} 
	}	
	return true;	
}

//�ж�����������Ƿ�ȫ��Ϊ���ֻ�һ�����(.)�����������,����true.
function reg_Num(str)
{
	var Letters = "-1234567890.,";
	var j = 0;		
	if(str=="" || str==null) return true;
	for (i=0;i<str.length;i++)
	{
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1){return false;}
		if (CheckChar == "."){j = j + 1;}		
	}
	if (j > 1){return false;}
	
	return true;
}

//�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��
function roundOff(number,digit)
{
    var sNumstr = 1;
    for (i=0;i<digit;i++)
    {
       sNumstr=sNumstr*10;
    }
    sReturnValue = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    return sReturnValue;
}


/////////add by hxd in 2005/01/04
//real,amarsoft,db,js,html
var sAmarReplace = new Array();
sAmarReplace[0] = new Array("\\",		"~[isl]",	"\\",	"\\\\",		"&#92;");
sAmarReplace[1] = new Array("'",		"~[sqt]",	"''",	"\\'",		"&#39;");
sAmarReplace[2] = new Array("\"",		"~[dqt]",	"\"",	"\"",		"&#34;");
sAmarReplace[3] = new Array("<",		"~[alt]",	"<",	"<",		"&#60;");
sAmarReplace[4] = new Array(">",		"~[agt]",	">",	">",		"&#62;");
sAmarReplace[5] = new Array("\r\n",		"~[arn]",	"\r\n",	"\\r\\n",	"&#13;&#10;"); //\r\n
sAmarReplace[6] = new Array("\r",		"~[aor]",	"\r\n",	"\\r\\n",	"&#13;&#10;");
sAmarReplace[7] = new Array("\n",		"~[aon]",	"\r\n",	"\\r\\n",	"&#13;&#10;");
sAmarReplace[8] = new Array("#",		"~[pds]",	"#",	"#",	"#");
sAmarReplace[9] = new Array("(",		"~[lpr]",	"(",	"(",	"(");
sAmarReplace[10] = new Array(")",		"~[rpr]",	")",	")",	")");
sAmarReplace[11] = new Array("+",		"~[pls]",	"+",	"+",	"+");


//add by byhu 2005.01.06
/**
 * ���ַ���sSource����sBeginIdentifier��sEndIdentifier����ʶ�𵽵����ַ���sAttributes[i][iAttID]�滻ΪsAttributes[i][iAttValue]<br>
 */
 
function macroReplace(sAttributes,sSource,sBeginIdentifier,sEndIdentifier,iAttID,iAttValue)
{
	var iPosBegin=0,iPosEnd=0;
	var sAttributeID="";
	var sReturn = sSource;
	while((iPosBegin=sReturn.indexOf(sBeginIdentifier,iPosBegin))>=0){
		iPosEnd = sReturn.indexOf(sEndIdentifier,iPosBegin);
		sAttributeID = sReturn.substring(iPosBegin ,iPosEnd + sEndIdentifier.length);
		sReturn = sReturn.substring(0,iPosBegin) + getAttribute(sAttributes,sAttributeID,iAttID,iAttValue) + sReturn.substring(iPosEnd+sEndIdentifier.length);
	}
	return sReturn;
}

/**ȡ����ֵ���޸����Է���Null @author William @since 2005.01.06*/
function getAttribute(sAttributes,sAttributeName,iAttID,iAttValue)
{
	var sAttributeValue;
	for(var i=0;i<sAttributes.length;i++)
	{
		if (sAttributes[i][iAttID]==sAttributeName) 
		{
			sAttributeValue = sAttributes[i][iAttValue];
			return sAttributeValue;
		}	
	}	
	return sAttributeValue;
}

function temptest(){
	var tmpstr = "~[pds]12345~[alt]";
	alert(macroReplace(sAmarReplace,tmpstr,"~[","]",1,0));
}

function amarsoft2Html(sSource)
{
	//alert(sSource);
	try{
		if(typeof(sSource)!='string') return sSource;
	
		sReturn = sSource;
		sReturn = macroReplace(sAmarReplace,sReturn,"~[","]",1,4);
		/*
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][1],sAmarReplace[i][4]);
		*/
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function amarsoft2Real(sSource)
{
	//alert(sSource);
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		sReturn = macroReplace(sAmarReplace,sReturn,"~[","]",1,0);
		/*
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][1],sAmarReplace[i][0]);
		*/
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}
function real2Amarsoft(sSource)
{
	//alert(sSource);
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][0],sAmarReplace[i][1]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function html2Amarsoft(sSource)
{
	//alert(sSource);
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][4],sAmarReplace[i][1]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function html2Real(sSource)
{
	//alert(sSource);
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][4],sAmarReplace[i][0]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function beforeKeyDown(myiframe)
{
	try {
	if(document.frames(myiframe).event.srcElement.name.indexOf("Radio")>0)
		return false;
	} catch(e) { var a_a=1; }	

	return true;
}

function doKeyDown(myiframe)
{
	
}

function afterKeyDown(myiframe)
{
	
}

function beforeKeyUp(myiframe)
{
	try {
	if(document.frames(myiframe).event.srcElement.name.indexOf("Radio")>0)
		return false;
	} catch(e) { var a_a=1; }	
		
	return true;
}

function doKeyUp(myiframe)
{
	try {
		if(document.frames(myiframe).event.keyCode==13) 
	   	{
	   		var j = "0";
			var obj = document.frames(myiframe).event.srcElement;
			for(i=0;i<document.frames(myiframe).document.all.length;i++)
			{
				if(document.frames(myiframe).document.all(i).name==obj.name)
				{
					j="1";
					continue;
				}
				//kick btnR(keyF7)
				if(j=="1" && document.frames(myiframe).document.all(i).name!=null && document.frames(myiframe).document.all(i).name.indexOf("R")!=-1 && document.frames(myiframe).document.all(i).name.substring(0,4)!="btnR")
				{
					if (document.frames(myiframe).document.all(i).disabled==true||document.frames(myiframe).document.all(i).readOnly==true) {
						continue;
					}
					document.frames(myiframe).document.all(i).focus();
					break;
				}

			}   			
	   	}	
	} catch(e) { var a_a=1; }
}

function afterKeyUp(myiframe)
{
	
}

function beforeMouseDown(myiframe)
{
	return true;
}

function doMouseDown(myiframe)
{
	
}

function afterMouseDown(myiframe)
{
	
}


function beforeKeyUp_show(myiframe)
{
	//modify by hxd in 2008/04/10
	//return true;
	//return true;  //2008/02/01 citibank����Ҫdw export
	return !myHandleSpecialKey(myiframe); //����ȡ��
}

function doKeyUp_show(myiframe)
{
	
}

function afterKeyUp_show(myiframe)
{
	
}

function beforeMouseDown_show(myiframe)
{
	return true;
}

function doMouseDown_show(myiframe)
{
	
}

function afterMouseDown_show(myiframe)
{
	
}

function mymu()
{
	alert("up");
}	
//frames("myiframe0").document.body.onmouseup = mymu;
	
//���º���Ϊ������ʹ��  add by byhu

var FILTER_OPERATORS = new Array(14);
FILTER_OPERATORS[0] = new Array('SmallerThanOrEquals','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[1] = new Array('BeginsWith','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[2] = new Array('BetweenNumber','','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5');
FILTER_OPERATORS[3] = new Array('BetweenString','','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6');
FILTER_OPERATORS[4] = new Array('BiggerThan','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[5] = new Array('BiggerThanOrEquals','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[6] = new Array('Contains','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[7] = new Array('NotContains','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[8] = new Array('EndWith','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[9] = new Array('EqualsNumber','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3');
FILTER_OPERATORS[10] = new Array('EqualsString','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[11] = new Array('NotEquals','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[12] = new Array('SmallerThan','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[13] = new Array('IsNull','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','');
FILTER_OPERATORS[14] = new Array('IsNotNull','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','');
/**add by byhu 2008.02.21 �������֤18λ��15λ����*/
FILTER_OPERATORS[15] = new Array('EqualsCert','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');

/**add by byhu 2004.12.19*/
function replaceAll(sSource,sOldString,sNewString){
	try{
		if(typeof(sSource)!='string') return sSource;
		var iPosBegin = 0;
		sReturn = sSource;
		//alert(sReturn+"\r\n"+sOldString+"\r\n"+sNewString);
		iPosBegin = sReturn.indexOf(sOldString,iPosBegin);
		while(iPosBegin>=0){
			//sReturn = sReturn.replace(sOldString,sNewString);
			sReturn = sReturn.substring(0,iPosBegin)+sNewString+sReturn.substring(iPosBegin+sOldString.length);
			iPosBegin = sReturn.indexOf(sOldString,iPosBegin+sNewString.length);
		}
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}
}

/**add by byhu 2004.12.19*/
function filterAction(sObjectID,sFilterID){
	alert(sObjectID+" "+sFilterID);
}
function selectFilterDate(sObjectID,sFilterID){
	var oInput = document.all(sObjectID);
	sReturn = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogwidth:320px;dialogheight:280px");
	if(typeof(sReturn)!="undefined" && sReturn!="" && sReturn!="_CANCEL_"){
		oInput.value=sReturn;
	}
}

/**add by byhu 2004.12.19*/
function applyFilters()
{
	alert("abc");
}
function checkDOFilterForm(oForm){
	return true;
}

/**add by byhu 2004.12.19*/
/**modify by zywei 2006.2.16 17:20 �����˺���onFromAction���������ֵ*/
function submitFilterForm(sFormName)
{		
	var oForm = document.forms(sFormName);
	//for(i=0;i<oForm.elements.length;i++) alert(oForm.elements[i].name+":"+oForm.elements[i].value);
	//oForm.submit();		
	amarhidden.style.display = "none";
	onFromAction(oForm,sFormName);
}
function clearFilterForm(sFormName)
{
	var oForm = document.forms(sFormName);
	for(i=0;i<oForm.elements.length;i++){
		if(oForm.elements[i].name.indexOf("_OP")>=0 || oForm.elements[i].type=="button" || oForm.elements[i].type=="reset"|| oForm.elements[i].type=="submit"){
			continue;
		}else if(oForm.elements[i].type=="checkbox"){
			oForm.elements[i].checked=false;
		}else{
			oForm.elements[i].value="";
		}
	}
}
function resetFilterForm(sFormName)
{
	var oForm = document.forms(sFormName);
	oForm.reset();
}

/**add by byhu 2004.12.19*/
function showHideFilterElements(sFilterID,oOperatorObj)
{
	try{
		for(var iOperators=0;iOperators<FILTER_OPERATORS.length;iOperators++){
			if(oOperatorObj.value==FILTER_OPERATORS[iOperators][0]){
				sObjectsToHide = replaceAll(FILTER_OPERATORS[iOperators][1],"#{FilterID}",sFilterID);
				sObjectsToShow = replaceAll(FILTER_OPERATORS[iOperators][2],"#{FilterID}",sFilterID);
				if(sObjectsToHide!="") showHideObjects(sObjectsToHide,"hide");
				if(sObjectsToShow!="") showHideObjects(sObjectsToShow,"show");
			}
		}
	}catch(e){
		alert("��ʾ/���ع��������Ŷ�Ӧ�Ķ���ʱ��������Htmlģ�档");
	}
}

/**add by byhu 2004.12.19*/
function showHideObjects(sObjects,sShowOrHide)
{
	if(sObjects=="") return;
	var sTargetObjects = sObjects.split(",");
	if(sTargetObjects=="") return;
	for (iObject=0;iObject<sTargetObjects.length;iObject++)
	{
		if(sShowOrHide=="hide"){
			try{
				sCurObj = document.all(sTargetObjects[iObject]);
				sCurObj.style.display = "none";
			}catch(e){
				alert("���ع��������Ŷ�Ӧ�Ķ���ʱ��������Htmlģ�档"+e);
			}
		}else{
			try{
				sCurObj = document.all(sTargetObjects[iObject]);
				sCurObj.style.display = "";
			}catch(e){
				alert("��ʾ���������Ŷ�Ӧ�Ķ���ʱ��������Htmlģ�档"+e);
			}
		}
	}
	
}

/**֧�ֶ�ѡ*/
function multiSelectCurrentRow(){		
	//���ԭ��ûֵ�����á�
	if(getItemValue(0,getRow(),"MultiSelectionFlag") != "��")
	{
		setItemValue(0,getRow(),"MultiSelectionFlag","��");
	}
	else //ԭ���С�,�óɿ�  
	{
		setItemValue(0,getRow(),"MultiSelectionFlag","");
	}
}

function getItemValueArray(iDW,sColumnID){
	var b = getRowCount(iDW);
	var countSelected = 0;
	var sMemberIDTemp = "";
	var sSelected = new Array(1000);
	for(var iMSR = 0 ; iMSR < b ; iMSR++)
	{
		var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
		if(a == "��"){
			sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
			countSelected++;
		}
	}
	var sReturn = new Array(countSelected);
	for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
		sReturn[iReturnMSR] = sSelected[iReturnMSR];
	}
	return sReturn;
}



// add by byhu 2003/01/06
var oTempObj; // ������ʱ��ת������

function editWithScriptEditor(iDW,sCol){
	var myobj = getASObject(iDW,getRow(0),sCol);
	editObjectValueWithScriptEditor(myobj);
}

function editObjectValueWithScriptEditor(oObject,sScriptLanguage){
	var sTempLanguage;
	if(typeof(sScriptLanguage)!="undefined" && sScriptLanguage!="")
		sTempLanguage = sScriptLanguage;
	else sTempLanguage = "AmarScript";

	sInput = oObject.value;
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
	if(sTempLanguage=="AFS")
		saveParaToComp("ScriptText="+sInput+"&ScriptLanguage="+sTempLanguage,"openScriptEditorForAFSAndSetText()");
	else
		saveParaToComp("ScriptText="+sInput+"&ScriptLanguage="+sTempLanguage,"openScriptEditorAndSetText()");
}

function editObjectValueWithScriptEditorForAFS(oObject,sModelNo){
	var sTempModelNo;
	if(typeof(sModelNo)!="undefined" && sModelNo!="")
		sTempModelNo = sModelNo;
	else sTempModelNo = "";

	sInput = oObject.value;
	
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
    saveParaToComp("ScriptText="+sInput+"&ModelNo="+sTempModelNo,"openScriptEditorForAFSAndSetText()");
	
}

function editObjectValueWithScriptEditorForASScript(oObject){
	sInput = oObject.value;
	
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
    saveParaToComp("ScriptText="+sInput,"openScriptEditorForASScriptAndSetText()");
	
}

function openScriptEditorAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditor","/Common/ScriptEditor/ScriptEditor.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
	{
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}

function openScriptEditorForAFSAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditorForAFS","/Common/ScriptEditor/ScriptEditorForAFS.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
	{
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}

function openScriptEditorForASScriptAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditorForASScript","/Common/ScriptEditor/ScriptEditorForASScript.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
	{
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}
	
//���ڶ�̬����iframe��ͨ��post�����ݴ�����ģ̬���� byhu 2005.01.07
function generateIframe()
{
	iframeName=randomNumber().toString();
	iframeName = "frame"+iframeName.substring(2);

	//modify in 2008/04/10,2008/02/14 for https
	//var sHTML="<iframe name='"+iframeName+"'  style='display:none'>";
	var sHTML="<iframe name='"+iframeName+"' src='"+sWebRootPath+"/amarsoft.html' style='display:none'>";
	
	document.body.insertAdjacentHTML("afterBegin",sHTML);
	//alert(sHTML);
	return iframeName;
}
//���ڶ�̬���� form ��ͨ��post�����ݴ�����ģ̬���� byhu 2005.01.07
function saveParaToComp(paraString,postAction)
{
	var sFormName=randomNumber().toString();
	sFormName = "form"+sFormName.substring(2);
	var targetFrameName=generateIframe();
	var sHTML = "";
	if(typeof(dialogStyle)=="undefined" || dialogStyle=="") dialogStyle="";
	var sParaStringToPost = real2Amarsoft(paraString);
	var sPostActionToPost = real2Amarsoft(postAction);
	
	//modify in 2008/04/10
	//sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaAndShowDialog.jsp' style='display:none'>";
	sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaToComp.jsp' style='display:none'>";
	
	sHTML+="<input type=hidden name='CompClientID' value='"+sCompClientID+"'>";
	sHTML+="<input type=hidden name='PageClientID' value='"+sPageClientID+"'>";
	sHTML+="<input type=hidden name='TempParaString' id='TempParaString' value=''>";
	sHTML+="<input type=hidden name='TempPostAction' value='"+sPostActionToPost+"'>";
	sHTML+="</form>";
	//alert(sHTML);
	document.body.insertAdjacentHTML("afterBegin",sHTML);

	var oForm = document.forms(sFormName);
	var oElement = oForm.elements("TempParaString");
	oElement.value = sParaStringToPost;
	oForm.submit();
}

//���ڶ�̬���� form ��ͨ��post�����ݴ�����ģ̬���� byhu 2005.01.07
function saveParaToCompSession(paraString,postAction)
{
	var sFormName=randomNumber().toString();
	sFormName = "form"+sFormName.substring(2);
	var targetFrameName=generateIframe();
	var sHTML = "";
	if(typeof(dialogStyle)=="undefined" || dialogStyle=="") dialogStyle="";
	var sParaStringToPost = real2Amarsoft(paraString);
	var sPostActionToPost = real2Amarsoft(postAction);
	sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaToCompSession.jsp' style='display:none'>";
	sHTML+="<input type=hidden name='CompClientID' value='"+sCompClientID+"'>";
	sHTML+="<input type=hidden name='PageClientID' value='"+sPageClientID+"'>";
	sHTML+="<input type=hidden name='TempParaString' id='TempParaString' value=''>";
	sHTML+="<input type=hidden name='TempPostAction' value='"+sPostActionToPost+"'>";
	sHTML+="</form>";
	//alert(sHTML);
	document.body.insertAdjacentHTML("afterBegin",sHTML);

	var oForm = document.forms(sFormName);
	var oElement = oForm.elements("TempParaString");
	oElement.value = sParaStringToPost;
	oForm.submit();
}

// add by byhu 2005.01.10
function checkModified()
{
	var myobjname = cur_frame;
	//begin ���ڸ�ʽ�����鱨����ʾ�������Զ�����
	if(bEditHtml && bEditHtmlChange )
    {
        if(confirm(sUnloadMessage)) return true;
        else return false;
    }
    //end
	if(isModified(myobjname) && bCheckBeforeUnload)
	{
		if(confirm(sUnloadMessage)) return true;//"��ǰҳ�������Ѿ����޸ģ�����ȷ�����򲻱����޸Ĺ������ݲ����뿪��ǰҳ������ȡ���������ڵ�ǰҳ��Ȼ���ٰ���ǰҳ�ϵġ����桱��ť�Ա����޸Ĺ������ݡ�";
		else return false;
				
	}else{
		return true;
	}
}

function f_myPad0(myi)
{
	var f_mys0 = "";
	if(myi<10)
		f_mys0 = "0"+myi.toString(10);
	else
		f_mys0 = myi.toString(10);
	return f_mys0;
}

function f_myDate()
{
	var d = new Date();
	var s = "" ;
	
	s += f_myPad0(d.getYear());
	s += f_myPad0(d.getMonth()+1);
	s += f_myPad0(d.getDate());
	s += f_myPad0(d.getHours());
	s += f_myPad0(d.getMinutes());
	s += f_myPad0(d.getSeconds());
	s += f_myPad0(d.getMilliseconds());
	
	return s;
	
}
	
function amarExport(myname)
{
	try
	{
		//modify by hxd in 2008/04/10 for add rand
		window.showModalDialog(sPath+"GetDWDataAll.jsp?CompClientID="+sCompClientID+"&type=export&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+Math.abs(Math.sin((new Date()).getTime())),"_blank","width=240,height=100,left="+(screen.availWidth-200)/2+",top="+(screen.availHeight-100)/2+",center=yes,toolbar=no,menubar=no");
	}
	catch(e)
	{
		alert(e.name+" "+e.number+" :"+e.message); 
	}		
}

function amarPrint(myname)
{
	try
	{
		window.showModalDialog(sPath+"GetDWDataAll.jsp?CompClientID="+sCompClientID+"&type=print&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+Math.abs(Math.sin((new Date()).getTime())),"_blank","width=240,height=100,left="+(screen.availWidth-200)/2+",top="+(screen.availHeight-100)/2+",center=yes,toolbar=no,menubar=no");
	}
	catch(e)
	{
		alert(e.name+" "+e.number+" :"+e.message); 
	}		
}

//add by hxd in 2005/01/18
String.prototype.trim = function()
{
    return this.replace(/(^[\s]*)|([\s]*$)/g, "");
}
String.prototype.lTrim = function()
{
    return this.replace(/(^[\s]*)/g, "");
}
String.prototype.rTrim = function()
{
    return this.replace(/([\s]*$)/g, "");
}

function checkIsNotEmpty(str)
{
    if(str.trim() == "")
        return false;
    else
        return true;
}

//add by hxd in 2008/04/10
function mydokey_old(myname)
{
	try
	{
		if( document.frames(myname).event.keyCode==113 || 
			(document.frames(myname).event.ctrlKey && document.frames(myname).event.keyCode==114) ) 
		{
			if(document.frames(myname).document.getElementById('div_myd')==null)				
			{
			var sHTML = "<div id='div_myd' style='position:absolute;z-index:9999;filter:alpha(opacity=25);background-color:black;visibility:visible'><table width=100% height=100% border=1><tr valign=middle align=center><td valign=middle align=center><table width=300 height=150 border=1 bordercolor='#000000' style='border-collapse:collapse;background-color:#FFFFFF' ><tr height=30><td valign=middle align=center style='font:9pt;font-family:������;background-color:#0000FF;color:white' height=25>ϵͳ��Ϣ</td></tr><tr><td valign=middle align=center style='font:9pt;font-family:������;background-color:#FFFFFF;color:red;bold:true' >���ڴӷ�������ȡ����,���Ժ�...</td></tr><tr height=30><td valign=middle align=center style='font:9pt;font-family:������;background-color:white;color:black' ><a href='javascript:;' onClick='myhide(\""+myname+"\")' style='font:9pt;font-family:������;color:black' >������ȡ����β���</a></td></tr></table></td></tr></table><iframe name='mydwexportall'></iframe></div>";
			document.body.insertAdjacentHTML('afterBegin',sHTML);
			}
			myshow(myname);
			window.open(sPath+'GetDWDataAllExReport.jsp?dw='+DZ[myname.substring(myname.length-1)][0][1]+'&rand='+Math.abs(Math.sin((new Date()).getTime())),'mydwexportall','width=240,height=100,left='+(screen.availWidth-200)/2+',top='+(screen.availHeight-100)/2+',center=yes,toolbar=no,menubar=no');
			return true;	
		}
	}
	catch(e)
	{
		alert(e.name+' '+e.number+' :'+e.message); 
	}

	return false;	
}

//add by hxd in 2008/04/10
function amarExportNew(myname)
{
	if(document.frames(myname).document.getElementById('div_myd')==null)				
	{
		var sHTML = "<div id='div_myd' style='position:absolute;z-index:9999;filter:alpha(opacity=25);background-color:black;visibility:visible'>"+
			"<table width=100% height=100% border=1><tr valign=middle align=center>"+
			"<td valign=middle align=center>"+
			"<table width=300 height=150 border=1 bordercolor='#000000' style='border-collapse:collapse;background-color:#FFFFFF' >"+
			"<tr height=30><td valign=middle align=center style='font:9pt;font-family:������;background-color:#0000FF;color:white' height=25>ϵͳ��Ϣ</td></tr>"+
			"<tr><td valign=middle align=center style='font:9pt;font-family:������;background-color:#FFFFFF;color:red;bold:true' >���ڴӷ�������ȡ����,���Ժ�...</td></tr>"+
			"<tr height=30><td valign=middle align=center style='font:9pt;font-family:������;background-color:white;color:black' >"+
			"<a href='javascript:;' onClick='myhide(\""+myname+"\")' style='font:9pt;font-family:������;color:black' >������ȡ����β���</a>"+
			"</td></tr></table></td></tr></table><iframe name='mydwexportall'></iframe></div>";
		document.body.insertAdjacentHTML('afterBegin',sHTML);
	}
	myshow(myname);
	window.open(sPath+"GetDWDataAllNew.jsp?CompClientID="+sCompClientID+"&type=export&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+Math.abs(Math.sin((new Date()).getTime())),'mydwexportall','');
}

//modify by hxd in 2008/04/10
function myHandleSpecialKey(myname)
{
	try
	{
		if(document.frames(myname).event.keyCode==113 || 	//F2
			( document.frames(myname).event.ctrlKey && document.frames(myname).event.keyCode==114) ) 	 //F3
		{
			amarExport(myname); //amarExportNew(myname);	//amarPrint(myname);
			return true;
		}
	}
	catch(e)
	{
		alert(e.name+" "+e.number+" :"+e.message); 
		return true;	
	}		
	return false;		
}

//���ڼ�麯��
function isASDate(value,separator)
{
	if(value==null||value.length<10) return false;
	
	var sItems = value.split(separator); // value.split("/");

	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false;
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	//��ݱ���Ϊ4λ���·ݺ��ձ���Ϊ2λ
	if (sItems[0].length!=4) return false;
	if (sItems[1].length!=2) return false;
	if (sItems[2].length!=2) return false;

	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2150) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;

	if ((sItems[1]<=7) && ((sItems[1] % 2)==0) && (sItems[2]>=31)) return false;
	if ((sItems[1]>=8) && ((sItems[1] % 2)==1) && (sItems[2]>=31)) return false;
	//���겻������
	if (!((sItems[0] % 4)==0) && (sItems[1]==2) && (sItems[2]==29))
	{
		if ((sItems[1]==2) && (sItems[2]==29))
			return false;
	}else
	{
		if ((sItems[1]==2) && (sItems[2]==30))
			return false;
	}

	return true;
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

/**�Զ�����������*/
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
		//ȡ��colspan
		if(myarrangements[iDW][j][1]!=myDockID) continue;
		temp=myarrangements[iDW][j][2];
		if(temp==""){
			if(DZ[iDW][1][j][11]==3)
				colspan = defaultColspanForLongType;
			else if(DZ[iDW][1][j][10].indexOf("width:")>=0)
				colspan = defaultColspanForLongType;
			else if(DZ[iDW][1][j][17].length>=6 && DZ[iDW][1][j][17].substring(DZ[iDW][1][j][17].length-1)!=">")
				colspan = defaultColspanForLongType;
			else
				colspan = defaultColspan;
		}else{
			colspan = temp;
		}

		//ȡ��position
		temp=myarrangements[iDW][j][3];
		if(temp==""){
			position = defaultPosition;
		}else{
			position = temp;
		}

		//��ʾ<tr>
		if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
			if (remainColumns > 0){
				sss[jjj++]="<td colspan='"+remainColumns+"' "+hmFFBlankTD+">&nbsp;</td></tr>"+"\r";
			}
			remainColumns = totalColumns;
			sss[jjj++]="<tr height='8'></tr><tr>";
		}
		
		//��ʾ����
		sss[jjj++]=drawInputControl(myarrangements,harbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,j,iRow_now);		
		remainColumns = remainColumns -colspan;


		//��ʾ</tr>
		
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
/**��ʾһ���ؼ�*/
function drawInputControl(myarrangement,myharbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,iCol,iRow_now){
	sColspan = myarrangement[iDW][iCol][2];
	//var iColspan=12;
	if(sColspan=="")
	{		
		if(DZ[iDW][1][iCol][11]==3){
			iColspan = defaultColspanForLongType;
		}else if(DZ[iDW][1][iCol][10].indexOf("width:")>=0){
			iColspan = defaultColspanForLongType;
		}else if(DZ[iDW][1][iCol][17].length>=6 && DZ[iDW][1][iCol][17].substring(DZ[iDW][1][iCol][17].length-1)!=">"){
			//unit�����Ĳ��ҹ���
			iColspan = defaultColspanForLongType;
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

		//����������������ƣ�����ָ����Ҫ��ʾ��(�޸�����)��
		if(bTextareaShowLimit && DZ[myi][1][i][7]>0) sTextareaShowLimit = "(��" + (DZ[myi][1][i][7]/2) +"������)";
		sss[jjj++]=("<td  "+hmFFTextAreaCaptionTD+" >"+DZ[myi][1][i][0]+ sTextareaShowLimit +mysMandatorySignal+" </td>");
	} 
	else    
		sss[jjj++]=("<td  "+hmFFCaptionTD+" >"+DZ[myi][1][i][0]+mysMandatorySignal+"</td>");
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
		myevent_num="  onblur=parent.myNumberBL(this) onfocus=parent.myNumberFC(this) onkeypress=parent.myNumberKP(this,event) onkeydown=parent.myNumberKD(this,event) onkeyup=parent.myNumberKU(this,event) onbeforepaste=parent.myNumberBFP(this) "; 
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
			//if(DZ[myi][1][i][20][2*k+1]=='') DZ[myi][1][i][20][2*k+1]='(��ѡ��)';
			if(DZ[myi][1][i][20][2*k+1]=='') continue;

			//ע�⣺Radio���ں��棬��Ϊname.indexOf("R")������
			if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
				sss[jjj++] = "<input type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' checked onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
			else
				sss[jjj++] = "<input type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
		}

		sss[jjj++] =  mysss+"</td>";
	}
	
	//add by hxd in 2005/11/29
	if(myFS==4) //treeview(ֻ������һ��...��ť)(�Լ�һ�����ص�id)
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
//��ѡ������������radio button)����������ȥ��δѡ�� 
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
//����ѡ�񡣡��������������������򣬵�Ҫ����Ϸ��ԡ�
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
		alert("������["+DZ[myi][1][i][0]+"]��������������!");
		if(my_notnull[myi][i]==1)//�����������ģ����ֽ���
			myobj.select(); 
		else //�����������
		{
			setItemValueByIndex(iDW,iRow,iField,"");
			myobj.value = "";
			document.frames("myiframe"+myi).document.getElementById("spanR"+iRow+"F"+iField).innerHTML = "";
		}
	}
	else
	{
		//�ں�����ʾ�ô����Ӧ������
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
	
	//sObjectType����������
	//iArgDW: �ڼ���DW��Ĭ��Ϊ0
	//iArgRow: �ڼ��У�Ĭ��Ϊ0
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
		//alert("ѡȡ������ʧ�ܣ��������ͣ�"+sObjectType);
		return;
	}

	return sObjectNoString;

}
	
function MR2(myobjname,myact)			
{
	
	var myoldstatus = window.status;  
	window.status="����׼�����ݣ����Ժ�....";  
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
	sss[jjj++]=("<a href='javascript:parent.MR2(\""+myobjname+"\",1)'>�ױ�</a> <a href='javascript:parent.MR2(\""+myobjname+"\",2)'>ǰһ��</a> <a href='javascript:parent.MR2(\""+myobjname+"\",3)'>��һ��</a> <a href='javascript:parent.MR2(\""+myobjname+"\",4)'>β��</a> <br>");
	sss[jjj++]=("����&nbsp;"+rr_c[myi]+"&nbsp;����¼����ǰΪ��&nbsp;"+(curpage[myi]+1)+"&nbsp;����¼<br>");
	sss[jjj++]=("&nbsp;&nbsp;����&nbsp;<input type=text name=txtJump style='FONT-SIZE: 9pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onkeydown='javascript:parent.MRK2(\""+myobjname+"\",5)'>&nbsp;��");
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
		my_sortorder=0;  //(��)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(��)
	else if(my_sortorder==2)  
		my_sortorder=0;
	
	var myi=myobjname.substring(myobjname.length-1);
	
	var myoldstatus = window.status;  
	window.status="���ڴӷ�����������ݣ����Ժ�....";  
	self.showModalDialog(sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&"+
			"sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder+"&rand="+Math.abs(Math.sin((new Date()).getTime())),
			window.self,
			"dialogWidth=1;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	
	window.status=myoldstatus;
	  
	init(false);
	needReComputeIndex[myi]=0;  
	//no need:setPageSize(0,20);
	my_load(my_sortorder_old,sort_which,myobjname,need_change);	  //��Ϊ my_load������sortת��
	//mySelectRow();//no need for my_load do le
}

//add by hxd in 2008/04/10 for sort
function my_load_show_s(my_sortorder,sort_which,myobjname)
{	
	
	var my_sortorder_old = my_sortorder;		
	if(my_sortorder==1)   
		my_sortorder=0;  //(��)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(��)
	else if(my_sortorder==2)  
		my_sortorder=0;
		
	var myi=myobjname.substring(myobjname.length-1);
	var myoldstatus = window.status;  
	window.status="���ڴӷ�����������ݣ����Ժ�....";  
	
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


function amarValue(sMoney,iType)
{
	if (sMoney==null || typeof(sMoney)=='undefined') return "";
	//modify in 2008/04/10 for ��λС��
	//if(iType!=2 && iType!=5 )
	if(iType!=2 && iType!=5 && iType<=10)
		return sMoney;
	else
	{
		//modify in 2008/04/10 for ��λС��
		//if(iType==2)
		if(iType==2 || iType>10)
		{
			if(isNaN(parseFloat(sMoney.replace(/,/g,"")))) return "";
			else return parseFloat(sMoney.replace(/,/g,""));
		}
		if(iType==5)
		{
			if(isNaN(parseInt(sMoney.replace(/,/g,"")))) return "";
			else return parseInt(sMoney.replace(/,/g,""));
		}
	}
}

//modify by hxd in 2008/04/10
function amarMoney(dMoney,iType)
{

    if (dMoney==null || (dMoney==""&&dMoney!=0) || typeof(dMoney)=='undefined') return "";
    if(parseInt(iType,10)!=2 && parseInt(iType,10)!=5 && parseInt(iType,10)<11 ) return dMoney;
    else
    {
        if(parseInt(iType,10)>10) iType=parseInt(iType,10)-10;
        else if(parseInt(iType,10)==5) iType=0;

        if(dMoney=="")
        {
            if( ("amar"+dMoney)=="amar") return "";
            else dMoney=0.00;
        }
        else
                dMoney = parseFloat(dMoney,10);
        if(isNaN(dMoney)) dMoney=0.00;
               
        var sMoney="",i,sTemp="",itemCount,iLength,digit=3,sign="",s1="",s2="",sResultSet="";
       
        sMoney = myFormatNumber(dMoney,iType);

        if(sMoney.indexOf("-")==0)     
        {
            sign = "-";
            sMoney = sMoney.substring(1);                  
        }

        if(iType!=0)
        {
            s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+iType+1);
            s1 = sMoney.substring(0,sMoney.indexOf("."));
        }
        else
            s1 = sMoney;
       
        iLength = s1.length;
        itemCount = parseInt((iLength-1) / digit,10) ;         
        for (i=0;i<itemCount;i++)
        {
            sTemp = ","+s1.substring(iLength-digit*(i+1),iLength-digit*i)+sTemp;
        }              
        sResultSet = sign+s1.substring(0,iLength-digit*i)+sTemp;       
       
        if(iType!=0)    sResultSet = sResultSet + "." + s2;    
       
        return sResultSet;             
    }
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
	setTimeout(hideMessage,1000*10);//maxʱ��:�ȴ�10s
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
	
	//����ͨ�����������жϴ����Ƿ��Ѵ�
	//��ȡ�滻����ȡ���Ĳ����������ظ���
	//��ʾ���־����𳬹�2��,��Ϊ����iframe��̬�߶Ȳ�֪����ôŪ��
	
 	if(typeof msgDiv=="object")
		return ;	 	

	var msgw=300;//��Ϣ��ʾ���ڵĿ��
	var msgh=125;//��Ϣ��ʾ���ڵĸ߶�
	var bordercolor="#336699";//��ʾ���ڵı߿���ɫ

	var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
	
	//**������Ϣ��ĵͲ�iframe**/	
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
	ifmObj.style.marginLeft = "-225px" ;//����λ��
	ifmObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
	ifmObj.style.width = msgw + "px";
	ifmObj.style.height =msgh + "px";
	ifmObj.style.textAlign = "center";
	ifmObj.style.lineHeight ="25px";

	ifmObj.style.zIndex = "9999";
	document.body.appendChild(ifmObj);
	
	//**���Ʊ�����**/	
	var bgObj=document.createElement("div");
	bgObj.setAttribute('id','bgDiv');
	bgObj.style.position="absolute";
	
	bgObj.style.top="0";//��ʾλ��top
	bgObj.style.left="0";//��ʾλ��left
	bgObj.style.background="#777";
	bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";//����ɫЧ�� 
	bgObj.style.opacity="50%";//Ӧ����͸����?

	//���ñ����� ��,��
	var sWidth,sHeight;
	sWidth=document.body.offsetWidth;
	
	sHeight=screen.height;
	bgObj.style.width="100%" ;//sWidth + "px";//��Ϊ100%����,��������
	bgObj.style.height="100%" ;//sHeight + "px";
	
	bgObj.style.zIndex = "10000";//��ʾ���

	//�����㶯�� ����ر�
	if(clickHide)
		bgObj.onclick=hideMessage;
	if(showGb)
		document.body.appendChild(bgObj);
	
	//**������Ϣ��**/
	var msgObj=document.createElement("div")
	msgObj.setAttribute("id","msgDiv");
	msgObj.setAttribute("align","center");
	msgObj.style.background="white";
	msgObj.style.border="1px solid " + bordercolor;
	msgObj.style.position = "absolute";
	msgObj.style.left = "55%";
	msgObj.style.top= scrollTop; //"40%";
	msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
	msgObj.style.marginLeft = "-225px" ;//����λ��
	msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
	msgObj.style.width = msgw + "px";
	msgObj.style.height =msgh + "px";
	msgObj.style.textAlign = "center";
	msgObj.style.lineHeight ="25px";
	msgObj.style.zIndex = "10001";
	
	document.body.appendChild(msgObj);
	
	//**���Ʊ����**/ ����ر�
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
	
	title.innerHTML="ϵͳ������...";
	if(clickHide){
		title.innerHTML="�ر�";
		title.style.cursor="pointer";			
		title.onclick = hideMessage;
	}	
	
	document.getElementById("msgDiv").appendChild(title);
	
	//**�����ʾ��Ϣ**/
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
	//modify in 2008/04/10
	//return true;
	if(!vI_all(objname))
		return false;
	else
	{
		ShowMessage("ϵͳ���ڴ������ݣ���ȴ�...",true,false);
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


