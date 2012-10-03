<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page contentType="text/html; charset=gb2312"%>
<html>
<head>
<title>请选择统计年月</title>
</head>
<BODY bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<script>
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurYear = dDate.getFullYear();
var dCurDayOfMonth = dDate.getDate();

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

function fSetSelectedQuarter(month)
{
	self.returnValue=document.all.Year.value+"/"+month;
	window.close();
      	
}

function doCancel()
{	
	self.returnValue="";
	window.close();
}

function doClose()
{	
	window.close();
}

</script>
<div align=center>
<form name="item">
<table>
<tr><td align="right">
<select name="Year">
<script>
document.write("<option selected value='"+dCurYear+"'>"+dCurYear+"</option>");
for(i=dCurYear-1;i>dCurYear-50;i--)
{
	document.write("<option value='"+i+"'>"+i+"</option>");
}
</script>
</select>年
</td>
</tr>
<tr>
<td>
<table align='right' border='1' bordercolor='#EEEEEE' cellpadding='0' cellspacing='1'>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='CURSOR:Hand;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('03')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('03')>一季度</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='CURSOR:Hand;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('06')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('06')>二季度</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='CURSOR:Hand;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('09')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('09')>三季度</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='CURSOR:Hand;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('12')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedQuarter('12')>四季度</font>
</td>
</tr>

</table>
</td>
</tr>
<tr>
<td align='right'>
     <img border='0' src='<%=sResourcesPath%>/close.gif' onclick="javascript:doClose();" style='cursor:hand'>
     <img border='0' src='<%=sResourcesPath%>/zero.gif'  onclick="javascript:doCancel();" style='cursor:hand'>
     
</td>
</tr>
</table>
</form>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>