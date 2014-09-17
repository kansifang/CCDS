function getTrueLength(mystr)
{
	var cArr = mystr.match(/[^x00-xff]/ig);
	return mystr.length+(cArr==null?0:cArr.length);
}

function  getLeft(mystr,leftLen)
{
	var mylen=mystr.length;
	var realNum=0;
	for(var i=1;i<=mylen;i++)
	{
		if(mystr.charCodeAt(i-1)<0||mystr.charCodeAt(i-1)>255)
			realNum++;
		if(i+realNum==leftLen) break;
		if(i+realNum>leftLen) {i--; break; }
	}
	return mystr.substring(0,i);
}	

function textareaMaxByIndex(iDW,iRow,iCol)  
{ 
	var obj=getASObjectByIndex(iDW,iRow,iCol); 
	var maxlimit=DZ[iDW][1][iCol][7]; 
	if(maxlimit==0) return; 
	//if (obj.value.length > maxlimit)  
	//	obj.value = obj.value.substring(0, maxlimit); 	
	if(getTrueLength(obj.value) > maxlimit)  
	{
		obj.value = getLeft(obj.value, maxlimit); 
	}
} 


/*去除F2就放开此函数
function AsSaveResult(myobjname) 
{ 
}
*/	

function isDate(value,separator)
{
	if(value==null||value.length<10) return false;	
	var sItems = value.split(separator); // value.split("/");
	
    if (sItems.length!=3) return false;
    if (isNaN(sItems[0])) return false;
    if (isNaN(sItems[1])) return false;
    if (isNaN(sItems[2])) return false;
    //年份必须为4位，月份和日必须为2位
    if (sItems[0].length!=4) return false;
    if (sItems[1].length!=2) return false;
    if (sItems[2].length!=2) return false;

    if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2150) return false;
    if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
    if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;

    if ((sItems[1]<=7) && ((sItems[1] % 2)==0) && (sItems[2]>=31)) return false;
    if ((sItems[1]>=8) && ((sItems[1] % 2)==1) && (sItems[2]>=31)) return false;
    //本年不是闰年
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

try{
	document.frames("myiframe0").document.body.oncontextmenu='self.event.returnValue=true';
}catch(e){}


