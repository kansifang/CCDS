/*
-------------------------------------------------------------------------------
�ļ����ƣ�String.js
˵    ����JavaScript�ű�������һЩ���ַ��йص�
��    ����1.0
�޸ļ�¼:
---------------------------------------------------------------------------
ʱ��			�޸���		˵��
2007-01-08  HJiang		����
------------------------------------------------------------------------------- 	
*/

/*
��;������str1���Ƿ����str2
���룺str1���ַ�����str2�����������ַ���
���أ����������򷵻�str1�д�str2��һ�ַ���ʼ�������ַ��������򷵻ؿ��ַ���e��	
*/
function substringAfter( str1,  str2) { 
   if(typeof(str1)=="undefined") return "";
   var index = str1.indexOf(str2);
   if(index==-1) return "";
   return str1.substring(index+str2.length);
} 

/*
��;������str1���Ƿ����str2
���룺str1���ַ�����str2�����������ַ���
���أ����������򷵻�str1��str2ǰ�������ַ��������򷵻ؿ��ַ�����
*/
function substringBefore( str1,  str2) { 
   if(typeof(str1)=="undefined") return "";
   var index = str1.indexOf(str2);
   if(index==-1) return "";
   return str1.substring(0,index);
} 

/*
��;������ַ������ֽ���
���룺str���ַ�����
���أ������ַ������ֽ���
*/function charLength(str) {
    if( str == null || str ==  "" ) return 0;
    var totalCount = 0;
    for (i = 0; i< str.length; i++) {
        if (str.charCodeAt(i) > 127) 
            totalCount += 2;
        else
            totalCount++ ;
    }
    return totalCount;
}

/*
��;���ж��Ƿ��з�ASCII���ַ�
���룺s���ַ���
���أ�  ���ͨ����֤����true,���򷵻�false  
*/
function containsNOASC( s) {
    if( s == null || s ==  "" ) return false;
    for (i = 0; i< s.length; i++) {
        if (s.charCodeAt(i) > 127) 
             return true;
    }
    return false;
}

/*
��;��ȥ���ַ�����߿ո���
���룺str���ַ���
���أ� ȥ���ո���ַ���  
*/
function lTrim(str){
    var i = 0;
        while(str.charCodeAt(i) <=32 )
        {
            ++i;
        }
        str = str.substring(i);
		return str;
}

/*
��;��ȥ���ַ����ұ߿ո���
���룺str���ַ���
���أ� ȥ���ո���ַ���
*/
function rTrim(str){
    var i = str.length-1;
        while(str.charCodeAt(i) <=32)
        {
            --i;
        }
        str = str.substring(0,i+1);
		return str;
}

/*
��;��ȥ���ַ����������߿ո���
���룺str���ַ���
���أ� ȥ���ո���ַ���
*/
function trim(str){
		return lTrim(rTrim(str));
}

/*
��;��ȥ���ַ����������߻����м�ո���
���룺str���ַ���
���أ� ȥ���ո���ַ���
*/
function allTrim(str){
		return str.replace(/\s/g,"");

}
/*
��;�����ַ����е�"<",">","&"," "��xmlת�����ʾ;
���룺str���ַ���
���أ� ת�����ַ���
*/
function conversion(str)
{
	var newstr="";
		for(var i=0;i<str.length;i++)
	{
		switch(str.charAt(i))
		{
		case '<':
		    newstr=newstr+"&lt;";
			break;
		case ">":
            newstr=newstr+"&gt;";
            break;
		case "&":
            newstr=newstr+"&amp;";
			break;
		case " ":
            newstr=newstr+"&nbsp;";
			break;
		default:
		newstr=newstr+str.charAt(i);
		break;

		}
		
		}
		return newstr;
	}


/*
��;������source����str1��Str2֮�������
���룺sSource��Դ����str1���ַ���1��str2���ַ���2
���أ�������str1��Str2���򷵻�str1��str2����ַ��������򷵻ؿ��ַ�����
*/
function substringBetween(sSource, str1,  str2) { 
   var stringAfter = substringAfter(sSource,str1);
   var stringBetween = substringBefore(stringAfter,str2);
   return stringBetween;
}

function parseReturnXML(sSource,segment,sVariable){
	if(typeof(sSource)=="undefined") return "";
	//alert(1+"\n"+sSource+" \n"+segment+"\n"+sVariable);
	var segString = substringBetween(sSource,"<"+segment+">","</"+segment+">");
	if(segString==""){
		return "";
	}else if(sVariable==null || sVariable==""){
		return segString;
	}else{
		var sValue = trim(substringBetween(segString,"<"+sVariable+">","</"+sVariable+">"))
		return sValue;
	}
}

function getSegment(inStr,separator,segment){
	var elementItems = inStr.split(separator);
	for(var i=0;i<elementItems.length;i++){
		if(segment-1==i) return elementItems[i];
	}
	return "";
}

function getProfileString(inStr,keyStr){
	inStr = inStr.toString();
	if(inStr==null || typeof(inStr)=="undefined"){
		alert("ȱ�������ַ���");
	}
	if(inStr.length<=0){
		return "";
	}
	var valueItems = new Array();
	valueItems = inStr.split(";");
	for(var i=0;i<valueItems.length;i++){
		var itemKey=getSegment(valueItems[i],"=",1);
		if(itemKey==keyStr)
			return getSegment(valueItems[i],"=",2);
	}
	return "";
}
